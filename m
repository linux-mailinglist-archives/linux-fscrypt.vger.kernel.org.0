Return-Path: <linux-fscrypt+bounces-121-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 6CD7782C881
	for <lists+linux-fscrypt@lfdr.de>; Sat, 13 Jan 2024 01:58:08 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 08E7A1F23D4F
	for <lists+linux-fscrypt@lfdr.de>; Sat, 13 Jan 2024 00:58:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 76A6DF503;
	Sat, 13 Jan 2024 00:58:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eODxrC7K"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B265F4FE
	for <linux-fscrypt@vger.kernel.org>; Sat, 13 Jan 2024 00:58:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB788C433C7;
	Sat, 13 Jan 2024 00:58:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1705107483;
	bh=RxNtLoFlaYoXk2ozFC0KCCJOZR/NiydpaY6j5+vbHVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eODxrC7KJqSVwjjWLGXQnRd47j8WYnKrpiPNO7IihIkKkB4n2mbS9wn1Y7t/UBE1N
	 IGKLNLQr2frucR76YgODf7qO5MDiwAuLPffUHVJMH4GqwDi4/KUnjqWPw5zZmi3A5z
	 45O/WtByzkcXfywjqipJ90rkNMB1pwC18+7YL9Zcyjo6OPamM1XLTCmigXuvjmSai5
	 OCEsehxvzP4ZDOvvgqUTMyUkIAzQbTjuMoeezu1HSZ1eQAW7bOxnkSdCMzysp23qEh
	 q3SFWE23VnPmVlSFEr9gLRF75sK2cyKE2qVGFzQOk969EHHku9p4f2o9JL/DtE8cnY
	 KbJbg2TJR23JA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-f2fs-devel@lists.sourceforge.net
Cc: linux-fscrypt@vger.kernel.org,
	syzbot+8f477ac014ff5b32d81f@syzkaller.appspotmail.com
Subject: [PATCH] f2fs: fix double free of f2fs_sb_info
Date: Fri, 12 Jan 2024 16:57:47 -0800
Message-ID: <20240113005747.38887-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113005031.GA1147@sol.localdomain>
References: <20240113005031.GA1147@sol.localdomain>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

kill_f2fs_super() is called even if f2fs_fill_super() fails.
f2fs_fill_super() frees the struct f2fs_sb_info, so it must set
sb->s_fs_info to NULL to prevent it from being freed again.

Fixes: 275dca4630c1 ("f2fs: move release of block devices to after kill_block_super()")
Reported-by: syzbot+8f477ac014ff5b32d81f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/r/0000000000006cb174060ec34502@google.com
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/f2fs/super.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/fs/f2fs/super.c b/fs/f2fs/super.c
index d00d21a8b53ad..d45ab0992ae59 100644
--- a/fs/f2fs/super.c
+++ b/fs/f2fs/super.c
@@ -4873,20 +4873,21 @@ static int f2fs_fill_super(struct super_block *sb, void *data, int silent)
 		kfree(F2FS_OPTION(sbi).s_qf_names[i]);
 #endif
 	fscrypt_free_dummy_policy(&F2FS_OPTION(sbi).dummy_enc_policy);
 	kvfree(options);
 free_sb_buf:
 	kfree(raw_super);
 free_sbi:
 	if (sbi->s_chksum_driver)
 		crypto_free_shash(sbi->s_chksum_driver);
 	kfree(sbi);
+	sb->s_fs_info = NULL;
 
 	/* give only one another chance */
 	if (retry_cnt > 0 && skip_recovery) {
 		retry_cnt--;
 		shrink_dcache_sb(sb);
 		goto try_onemore;
 	}
 	return err;
 }
 

base-commit: 38814330fedd778edffcabe0c8cb462ee365782e
-- 
2.43.0


