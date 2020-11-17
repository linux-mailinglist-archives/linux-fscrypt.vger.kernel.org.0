Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 388962B66EC
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Nov 2020 15:11:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387908AbgKQOHm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Nov 2020 09:07:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731397AbgKQOHj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Nov 2020 09:07:39 -0500
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 278C0C061A47
        for <linux-fscrypt@vger.kernel.org>; Tue, 17 Nov 2020 06:07:40 -0800 (PST)
Received: by mail-yb1-xb4a.google.com with SMTP id w8so4903173ybq.4
        for <linux-fscrypt@vger.kernel.org>; Tue, 17 Nov 2020 06:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=BwiyyJFpFKuHzxO9ElSEoW591wjEhbpMFVEeLerCK4A=;
        b=B6mSrSI+KLsPLHZOubezapg1w7KyF48Gcd5KvqiZAUUomrvCt93BMFte58x4CeD/eg
         k0xlCR7goDt3KvTfbq6ZMZJTRtCUUnhHZa0njAuLo6BAWtOyT0lG1N+rkq1ohiO1t97Q
         qemqcHPO0pfn6jMj0SXbr2ZPFcNslQAZJlIrb9BwOmPHHl8x9VSfb8bJ8B9PJOSyLNxA
         sh1xch+eqx6drXfRAgiE1e5/U0BiaXHV0kNKfFjq0GDmh5MgGwrgrpp+Gb33sSAE+/7N
         uiK1X9QiX7TLKFELMTbOhucdRKr0jLm77xygNNOq76Vp9Flin7B1n7wnTkkNWd/qi3VO
         sykw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=BwiyyJFpFKuHzxO9ElSEoW591wjEhbpMFVEeLerCK4A=;
        b=BLArgA/x7OLs+pLI3e9Mfg+jDlCs46wPhSPHW5yiXIvXeoKoqenht+tkotjWoj7jud
         NYMnd990H1WkeFgLtUT5ttHIsOorvYlAj/znbE7XqwpAPMH0sJKJ6yHgQ4umtfHYEnVa
         gcpsNrbYTK7S7NNX4ZY+saye8nxzBYPs3G1mY19YzY6raTjcHcQRwENvd73KLvIXl3qh
         LF5I8ANd9QZZbA/NdqI2IZuGyYFbIKEySNmiWPlyLvUeSbyP28W2AqUz+u6KAStibR6I
         e/cn/ln4bMPtxbr7BqzYCLN+mpoPcpYIwqvShfIxwf2warBtDSVsz5Cilb8sJqLLsF5I
         ScJA==
X-Gm-Message-State: AOAM531nHloeRFxqgSeoKBuLXc67K8ZYEvKldWPo66itEN7R4IjVmu4b
        tkizeGdM6OR88V54+21HRg2hwOKsQWg=
X-Google-Smtp-Source: ABdhPJzSl4jy6BzVHmPfkYxBH8ET6UtBl4AEksaq1fddCMgxT0uxzDjjRNZm1PxWWWwhr7bOMNiWNibk17E=
Sender: "satyat via sendgmr" <satyat@satyaprateek.c.googlers.com>
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a25:2fcf:: with SMTP id v198mr26506998ybv.492.1605622059376;
 Tue, 17 Nov 2020 06:07:39 -0800 (PST)
Date:   Tue, 17 Nov 2020 14:07:07 +0000
In-Reply-To: <20201117140708.1068688-1-satyat@google.com>
Message-Id: <20201117140708.1068688-8-satyat@google.com>
Mime-Version: 1.0
References: <20201117140708.1068688-1-satyat@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [PATCH v7 7/8] f2fs: support direct I/O with fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Wire up f2fs with fscrypt direct I/O support. direct I/O with fscrypt is
only supported through blk-crypto (i.e. CONFIG_BLK_INLINE_ENCRYPTION must
have been enabled, the 'inlinecrypt' mount option must have been specified,
and either hardware inline encryption support must be present or
CONFIG_BLK_INLINE_ENCYRPTION_FALLBACK must have been enabled). Further,
direct I/O on encrypted files is only supported when the *length* of the
I/O is aligned to the filesystem block size (which is *not* necessarily the
same as the block device's block size).

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
Acked-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/f2fs.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index cb700d797296..d518e668618e 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4120,7 +4120,11 @@ static inline bool f2fs_force_buffered_io(struct inode *inode,
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	int rw = iov_iter_rw(iter);
 
-	if (f2fs_post_read_required(inode))
+	if (!fscrypt_dio_supported(iocb, iter))
+		return true;
+	if (fsverity_active(inode))
+		return true;
+	if (f2fs_compressed_file(inode))
 		return true;
 	if (f2fs_is_multi_device(sbi))
 		return true;
-- 
2.29.2.299.gdc1121823c-goog

