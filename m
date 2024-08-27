Return-Path: <linux-fscrypt+bounces-366-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8625496186B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 27 Aug 2024 22:16:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id AB9E11C232CD
	for <lists+linux-fscrypt@lfdr.de>; Tue, 27 Aug 2024 20:16:50 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 599071D2F7A;
	Tue, 27 Aug 2024 20:16:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="H2cRDo2s";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Oigw9UeX";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="H2cRDo2s";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Oigw9UeX"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C85A15B554;
	Tue, 27 Aug 2024 20:16:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724789805; cv=none; b=pmKj9ANSNg1SsTSZ4xOKCaG3CGxul3pS4W56tiF0+KNdaM0Y0QD0ibK2RA9C9erLxPVkrP1SczdViQX6rAYBTG4VEJRwEtTpVtq+Uh0kYXCbYpRldPIMKoBgd1/5x1miJROJHvyz8VU0KgMLiYbCekwlgSBCI3ftC7/oFF/hjk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724789805; c=relaxed/simple;
	bh=Hcx8QcIxQCwYgcS9aVzVA/bgTxxtOqbsBjmUJhdmgDE=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=tNOR5fsbFYz7f4ojncvA+HUFaYZSBqOlBF3rThvZ3pnzqABhRO6pjIJQp7RBYtTXGQn4uWXCIiOQN99yNdU9QRaLDX4L+XtnD71nZQwPdmIRCHjE9aGr6x+3pq/NzFubQoM61pTk4u53mzufZ86S4FMMmKET8FUo/ULGIHihyEM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=H2cRDo2s; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Oigw9UeX; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=H2cRDo2s; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Oigw9UeX; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id A903621B26;
	Tue, 27 Aug 2024 20:16:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1724789801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nGZ2P7NBrFDQ9r5RZr35OZ49pTXK6VSOYy22Fa0AIok=;
	b=H2cRDo2sZsK9GGwhMSl1+LBbuJkzDzZYXcRxrrBUP1ii16m+nlgl5lQuGRMlXjKO3rMU+2
	RW7ZakNBPsPXhimbmHe87HiRt56Srjp7XbDJTAs786nC4bb+YpVip4YFqKQJVmk2ruOvwG
	TTSl5TE1vADus4Sac+O5ia3FfZexrQE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1724789801;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nGZ2P7NBrFDQ9r5RZr35OZ49pTXK6VSOYy22Fa0AIok=;
	b=Oigw9UeXIEcBSjzCMhjwNNDBauMqt8lcBgPJkrJGXLDcmeW7czBJF9IftZwl7tLtBCB5ac
	SJ5wvU5kPUJ/WpCg==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1724789801; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nGZ2P7NBrFDQ9r5RZr35OZ49pTXK6VSOYy22Fa0AIok=;
	b=H2cRDo2sZsK9GGwhMSl1+LBbuJkzDzZYXcRxrrBUP1ii16m+nlgl5lQuGRMlXjKO3rMU+2
	RW7ZakNBPsPXhimbmHe87HiRt56Srjp7XbDJTAs786nC4bb+YpVip4YFqKQJVmk2ruOvwG
	TTSl5TE1vADus4Sac+O5ia3FfZexrQE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1724789801;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=nGZ2P7NBrFDQ9r5RZr35OZ49pTXK6VSOYy22Fa0AIok=;
	b=Oigw9UeXIEcBSjzCMhjwNNDBauMqt8lcBgPJkrJGXLDcmeW7czBJF9IftZwl7tLtBCB5ac
	SJ5wvU5kPUJ/WpCg==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 6516913A20;
	Tue, 27 Aug 2024 20:16:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id NMafEik0zmYWfQAAD6G6ig
	(envelope-from <krisman@suse.de>); Tue, 27 Aug 2024 20:16:41 +0000
From: Gabriel Krisman Bertazi <krisman@suse.de>
To: "Theodore Ts'o" <tytso@mit.edu>
Cc: Lizhi Xu <lizhi.xu@windriver.com>,  adilger.kernel@dilger.ca,
  coreteam@netfilter.org,  davem@davemloft.net,  ebiggers@kernel.org,
  fw@strlen.de,  jaegeuk@kernel.org,  kadlec@netfilter.org,
  kuba@kernel.org,  linux-ext4@vger.kernel.org,
  linux-fscrypt@vger.kernel.org,  linux-kernel@vger.kernel.org,
  lkp@intel.com,  llvm@lists.linux.dev,  netdev@vger.kernel.org,
  netfilter-devel@vger.kernel.org,  oe-kbuild-all@lists.linux.dev,
  pablo@netfilter.org,
  syzbot+340581ba9dceb7e06fb3@syzkaller.appspotmail.com,
  syzkaller-bugs@googlegroups.com
Subject: [PATCH] ext4: Fix error message when rejecting the default hash
In-Reply-To: <172433877724.370733.16770771071139702263.b4-ty@mit.edu>
	(Theodore Ts'o's message of "Thu, 22 Aug 2024 11:00:11 -0400")
Organization: SUSE
References: <87le3kle87.fsf@mailhost.krisman.be>
	<20240605012335.44086-1-lizhi.xu@windriver.com>
	<172433877724.370733.16770771071139702263.b4-ty@mit.edu>
Date: Tue, 27 Aug 2024 16:16:36 -0400
Message-ID: <87jzg1en6j.fsf_-_@mailhost.krisman.be>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Score: -2.80
X-Spamd-Result: default: False [-2.80 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	ARC_NA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	HAS_ORG_HEADER(0.00)[];
	RCVD_TLS_ALL(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[21];
	MIME_TRACE(0.00)[0:+];
	TAGGED_RCPT(0.00)[340581ba9dceb7e06fb3];
	DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	FUZZY_BLOCKED(0.00)[rspamd.com];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCVD_COUNT_TWO(0.00)[2];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,suse.de:email]
X-Spam-Flag: NO
X-Spam-Level: 

"Theodore Ts'o" <tytso@mit.edu> writes:

> On Wed, 05 Jun 2024 09:23:35 +0800, Lizhi Xu wrote:
>> When mounting the ext4 filesystem, if the default hash version is set to
>> DX_HASH_SIPHASH but the casefold feature is not set, exit the mounting.
>> 
>> 
>
> Applied, thanks!
>
> [1/1] fs/ext4: Filesystem without casefold feature cannot be mounted with spihash
>       commit: 985b67cd86392310d9e9326de941c22fc9340eec

Ted,

Since you took the above, can you please consider the following fixup?
I had pointed we shouldn't have siphash as the sb default hash at all:

based on your dev branch.

>8
Subject: [PATCH] ext4: Fix error message when rejecting the default hash

Commit 985b67cd8639 ("ext4: filesystems without casefold feature cannot
be mounted with siphash") properly rejects volumes where
s_def_hash_version is set to DX_HASH_SIPHASH, but the check and the
error message should not look into casefold setup - a filesystem should
never have DX_HASH_SIPHASH as the default hash.  Fix it and, since we
are there, move the check to ext4_hash_info_init.

Fixes:985b67cd8639 ("ext4: filesystems without casefold feature cannot
be mounted with siphash")
Signed-off-by: Gabriel Krisman Bertazi <krisman@suse.de>
---
 fs/ext4/ext4.h  |  1 +
 fs/ext4/super.c | 27 +++++++++++++++++----------
 2 files changed, 18 insertions(+), 10 deletions(-)

diff --git a/fs/ext4/ext4.h b/fs/ext4/ext4.h
index 5845e4aa091a..4120f24880cb 100644
--- a/fs/ext4/ext4.h
+++ b/fs/ext4/ext4.h
@@ -2462,6 +2462,7 @@ static inline __le16 ext4_rec_len_to_disk(unsigned len, unsigned blocksize)
 #define DX_HASH_HALF_MD4_UNSIGNED	4
 #define DX_HASH_TEA_UNSIGNED		5
 #define DX_HASH_SIPHASH			6
+#define DX_HASH_LAST 			DX_HASH_SIPHASH
 
 static inline u32 ext4_chksum(struct ext4_sb_info *sbi, u32 crc,
 			      const void *address, unsigned int length)
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 25cd0d662e31..c6a34ad07ecc 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -3582,13 +3582,6 @@ int ext4_feature_set_ok(struct super_block *sb, int readonly)
 			 "mounted without CONFIG_UNICODE");
 		return 0;
 	}
-	if (EXT4_SB(sb)->s_es->s_def_hash_version == DX_HASH_SIPHASH &&
-	    !ext4_has_feature_casefold(sb)) {
-		ext4_msg(sb, KERN_ERR,
-			 "Filesystem without casefold feature cannot be "
-			 "mounted with siphash");
-		return 0;
-	}
 
 	if (readonly)
 		return 1;
@@ -5094,16 +5087,27 @@ static int ext4_load_super(struct super_block *sb, ext4_fsblk_t *lsb,
 	return ret;
 }
 
-static void ext4_hash_info_init(struct super_block *sb)
+static int ext4_hash_info_init(struct super_block *sb)
 {
 	struct ext4_sb_info *sbi = EXT4_SB(sb);
 	struct ext4_super_block *es = sbi->s_es;
 	unsigned int i;
 
+	sbi->s_def_hash_version = es->s_def_hash_version;
+
+	if (sbi->s_def_hash_version > DX_HASH_LAST) {
+		ext4_msg(sb, KERN_ERR,
+			 "Invalid default hash set in the superblock");
+		return -EINVAL;
+	} else if (sbi->s_def_hash_version == DX_HASH_SIPHASH) {
+		ext4_msg(sb, KERN_ERR,
+			 "SIPHASH is not a valid default hash value");
+		return -EINVAL;
+	}
+
 	for (i = 0; i < 4; i++)
 		sbi->s_hash_seed[i] = le32_to_cpu(es->s_hash_seed[i]);
 
-	sbi->s_def_hash_version = es->s_def_hash_version;
 	if (ext4_has_feature_dir_index(sb)) {
 		i = le32_to_cpu(es->s_flags);
 		if (i & EXT2_FLAGS_UNSIGNED_HASH)
@@ -5121,6 +5125,7 @@ static void ext4_hash_info_init(struct super_block *sb)
 #endif
 		}
 	}
+	return 0;
 }
 
 static int ext4_block_group_meta_init(struct super_block *sb, int silent)
@@ -5256,7 +5261,9 @@ static int __ext4_fill_super(struct fs_context *fc, struct super_block *sb)
 	if (err)
 		goto failed_mount;
 
-	ext4_hash_info_init(sb);
+	err = ext4_hash_info_init(sb);
+	if (err)
+		goto failed_mount;
 
 	err = ext4_handle_clustersize(sb);
 	if (err)
-- 
2.46.0

