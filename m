Return-Path: <linux-fscrypt+bounces-1589-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 8F1vEIg/BGoqFgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1589-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:08:24 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id EB1F253042C
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:08:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D61D5312F179
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 09:00:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1266C410D20;
	Wed, 13 May 2026 08:56:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RrcjGrYe";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="RrcjGrYe"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCF313EAC77
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:56:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662571; cv=none; b=K6s9EjiTglAxvqkEHT6NyQqm/kthgKqpHV5pFBhvPEXLPmqyUg+W8f+qMTKArTv4vNRTk7U2HWvtdwkLTRNMTevqWfc6XZTNFG6eqT55DoyvYnmAQQjTiqFg09XIsG451BpYPdYafELj771IIqgg5DbIZIwhMGzfhGuBx4OSyP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662571; c=relaxed/simple;
	bh=Sqeud+c2uoKtkawkJCHD0i5nWa2kmjJMbrR4/6tdj8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n3FwKx3XZBAuyuSgUgjHEnEirvTdH3vAEN20NLFrxHNky8itFYa84MDpiFmpgECC5hEPLIwIeYv3FiGWOf3sfZiitpKgesjYXmPnixJKBOcpJP1nCtcfrWs5IxrhxkPlsDPhwebk+6xDPdzHZ0qaT0o8hfVBk6MPVaDNEYcHt+c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RrcjGrYe; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=RrcjGrYe; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 00C785CEA7;
	Wed, 13 May 2026 08:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ohKr70eL2HfkHBiEfr/ycL6lrsS2CR1ba1VfGgnUJaY=;
	b=RrcjGrYe8J/RUg3k307jpcZdU3MtbH6hdQ+xZELN0cijWH12YY339EHKKFroXvEBlL10D8
	+0xGfXnq05x7fsjdPeIXtR5IEmPntFmxCu5uRa+6+4QasHRbHQE1NCsdJAOHRtMPIM9KxE
	TV+kXJpFmhSyG1B+tTneKKxYuVadJwg=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662483; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=ohKr70eL2HfkHBiEfr/ycL6lrsS2CR1ba1VfGgnUJaY=;
	b=RrcjGrYe8J/RUg3k307jpcZdU3MtbH6hdQ+xZELN0cijWH12YY339EHKKFroXvEBlL10D8
	+0xGfXnq05x7fsjdPeIXtR5IEmPntFmxCu5uRa+6+4QasHRbHQE1NCsdJAOHRtMPIM9KxE
	TV+kXJpFmhSyG1B+tTneKKxYuVadJwg=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id D3B24593A9;
	Wed, 13 May 2026 08:54:42 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mLIxM1I8BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:42 +0000
From: Daniel Vacek <neelx@suse.com>
To: Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>
Cc: linux-block@vger.kernel.org,
	Daniel Vacek <neelx@suse.com>,
	linux-fscrypt@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v7 34/43] btrfs: add test_dummy_encryption support
Date: Wed, 13 May 2026 10:53:08 +0200
Message-ID: <20260513085340.3673127-35-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260513085340.3673127-1-neelx@suse.com>
References: <20260513085340.3673127-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Rspamd-Queue-Id: EB1F253042C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.105.105.114:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1589-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.105.96.0/20, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,toxicpanda.com:email,suse.com:email,suse.com:mid,suse.com:dkim]
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

In order to enable more thorough testing of fscrypt enable the
test_dummy_encryption mount option.  This is used by fscrypt users to
easily enable fscrypt on the file system for testing without needing to
do the key setup and everything.

The only deviation from other file systems we make is we only support
the fsparam_flag version of this mount option, as it defaults to v2.  We
don't want to have to bother with rejecting v1 related mount options.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v5: https://lore.kernel.org/linux-btrfs/77449ee5a882db2945429946c74ea7e796122328.1706116485.git.josef@toxicpanda.com/
 * No changes since.  Just re-wrapping.  We now accept longer lines.
---
 fs/btrfs/disk-io.c |  1 +
 fs/btrfs/fs.h      |  3 +++
 fs/btrfs/fscrypt.c |  6 +++++
 fs/btrfs/super.c   | 58 ++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 68 insertions(+)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index 8a11be02eeb9..1f0fe29dd549 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1230,6 +1230,7 @@ void btrfs_free_fs_info(struct btrfs_fs_info *fs_info)
 	btrfs_extent_buffer_leak_debug_check(fs_info);
 	kfree(fs_info->super_copy);
 	kfree(fs_info->super_for_commit);
+	fscrypt_free_dummy_policy(&fs_info->dummy_enc_policy);
 	kvfree(fs_info);
 }
 
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index dbdb73722c14..b21909d37b56 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -28,6 +28,7 @@
 #include <linux/rbtree.h>
 #include <linux/xxhash.h>
 #include <linux/fserror.h>
+#include <linux/fscrypt.h>
 #include <uapi/linux/btrfs.h>
 #include <uapi/linux/btrfs_tree.h>
 #include "extent-io-tree.h"
@@ -270,6 +271,7 @@ enum {
 	BTRFS_MOUNT_IGNOREMETACSUMS		= (1ULL << 31),
 	BTRFS_MOUNT_IGNORESUPERFLAGS		= (1ULL << 32),
 	BTRFS_MOUNT_REF_TRACKER			= (1ULL << 33),
+	BTRFS_MOUNT_TEST_DUMMY_ENCRYPTION	= (1ULL << 34),
 };
 
 /* These mount options require a full read-only fs, no new transaction is allowed. */
@@ -958,6 +960,7 @@ struct btrfs_fs_info {
 	spinlock_t eb_leak_lock;
 	struct list_head allocated_ebs;
 #endif
+	struct fscrypt_dummy_policy dummy_enc_policy;
 };
 
 #define folio_to_inode(_folio)	(BTRFS_I(_Generic((_folio),			\
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index 924ee3df7f32..111ca92a3450 100644
--- a/fs/btrfs/fscrypt.c
+++ b/fs/btrfs/fscrypt.c
@@ -240,6 +240,11 @@ static blk_status_t btrfs_process_encrypted_bio(struct bio *orig_bio,
 	return btrfs_csum_one_bio(bbio, enc_bio, false);
 }
 
+static const union fscrypt_policy *btrfs_get_dummy_policy(struct super_block *sb)
+{
+	return btrfs_sb(sb)->dummy_enc_policy.policy;
+}
+
 int btrfs_fscrypt_load_extent_info(struct btrfs_inode *inode,
 				   struct btrfs_path *path,
 				   struct btrfs_key *key,
@@ -356,4 +361,5 @@ const struct fscrypt_operations btrfs_fscrypt_ops = {
 	.empty_dir = btrfs_fscrypt_empty_dir,
 	.get_devices = btrfs_fscrypt_get_devices,
 	.process_bio = btrfs_process_encrypted_bio,
+	.get_dummy_policy = btrfs_get_dummy_policy,
 };
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 84df97363611..2c033c68f052 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -87,6 +87,7 @@ struct btrfs_fs_context {
 	unsigned long compress_type:4;
 	int compress_level;
 	refcount_t refs;
+	struct fscrypt_dummy_policy dummy_enc_policy;
 };
 
 static void btrfs_emit_options(struct btrfs_fs_info *info,
@@ -125,6 +126,7 @@ enum {
 	Opt_treelog,
 	Opt_user_subvol_rm_allowed,
 	Opt_norecovery,
+	Opt_test_dummy_encryption,
 
 	/* Rescue options */
 	Opt_rescue,
@@ -259,6 +261,8 @@ static const struct fs_parameter_spec btrfs_fs_parameters[] = {
 	fsparam_enum("fragment", Opt_fragment, btrfs_parameter_fragment),
 	fsparam_flag("ref_tracker", Opt_ref_tracker),
 	fsparam_flag("ref_verify", Opt_ref_verify),
+	fsparam_flag("test_dummy_encryption", Opt_test_dummy_encryption),
+	fsparam_string("test_dummy_encryption", Opt_test_dummy_encryption),
 #endif
 	{}
 };
@@ -651,6 +655,23 @@ static int btrfs_parse_param(struct fs_context *fc, struct fs_parameter *param)
 	case Opt_ref_tracker:
 		btrfs_set_opt(ctx->mount_opt, REF_TRACKER);
 		break;
+	case Opt_test_dummy_encryption:
+		int ret;
+
+		/*
+		 * We only support v2, so reject any v1 policies.
+		 */
+		if (param->type == fs_value_is_string && *param->string &&
+		    !strcmp(param->string, "v1")) {
+			btrfs_info(NULL, "v1 encryption isn't supported");
+			return -EINVAL;
+		}
+
+		btrfs_set_opt(ctx->mount_opt, TEST_DUMMY_ENCRYPTION);
+		ret = fscrypt_parse_test_dummy_encryption(param, &ctx->dummy_enc_policy);
+		if (ret)
+			return ret;
+		break;
 #endif
 	default:
 		btrfs_err(NULL, "unrecognized mount option '%s'", param->key);
@@ -986,6 +1007,9 @@ static int btrfs_fill_super(struct super_block *sb,
 		return ret;
 	}
 
+	if (fscrypt_is_dummy_policy_set(&fs_info->dummy_enc_policy))
+		btrfs_set_fs_incompat(fs_info, ENCRYPT);
+
 	btrfs_emit_options(fs_info, NULL);
 
 	inode = btrfs_iget(BTRFS_FIRST_FREE_OBJECTID, fs_info->fs_root);
@@ -1150,6 +1174,8 @@ static int btrfs_show_options(struct seq_file *seq, struct dentry *dentry)
 		seq_puts(seq, ",ref_verify");
 	if (btrfs_test_opt(info, REF_TRACKER))
 		seq_puts(seq, ",ref_tracker");
+	if (btrfs_test_opt(info, TEST_DUMMY_ENCRYPTION))
+		fscrypt_show_test_dummy_encryption(seq, ',', dentry->d_sb);
 	seq_printf(seq, ",subvolid=%llu", btrfs_root_id(BTRFS_I(d_inode(dentry))->root));
 	subvol_name = btrfs_get_subvol_name_from_objectid(info,
 			btrfs_root_id(BTRFS_I(d_inode(dentry))->root));
@@ -1415,6 +1441,18 @@ static void btrfs_ctx_to_info(struct btrfs_fs_info *fs_info, struct btrfs_fs_con
 	fs_info->mount_opt = ctx->mount_opt;
 	fs_info->compress_type = ctx->compress_type;
 	fs_info->compress_level = ctx->compress_level;
+
+	/*
+	 * If there's nothing set, or if the fs_info already has one set, don't
+	 * do anything.  If the fs_info is set we'll free the dummy one when we
+	 * free the ctx.
+	 */
+	if (!fscrypt_is_dummy_policy_set(&ctx->dummy_enc_policy) ||
+	    fscrypt_is_dummy_policy_set(&fs_info->dummy_enc_policy))
+		return;
+
+	fs_info->dummy_enc_policy = ctx->dummy_enc_policy;
+	memset(&ctx->dummy_enc_policy, 0, sizeof(ctx->dummy_enc_policy));
 }
 
 static void btrfs_info_to_ctx(struct btrfs_fs_info *fs_info, struct btrfs_fs_context *ctx)
@@ -1468,6 +1506,7 @@ static void btrfs_emit_options(struct btrfs_fs_info *info,
 	btrfs_info_if_set(info, old, IGNOREDATACSUMS, "ignoring data csums");
 	btrfs_info_if_set(info, old, IGNOREMETACSUMS, "ignoring meta csums");
 	btrfs_info_if_set(info, old, IGNORESUPERFLAGS, "ignoring unknown super block flags");
+	btrfs_info_if_set(info, old, TEST_DUMMY_ENCRYPTION, "test dummy encryption mode enabled");
 
 	btrfs_info_if_unset(info, old, NODATASUM, "setting datasum");
 	btrfs_info_if_unset(info, old, NODATACOW, "setting datacow");
@@ -1498,6 +1537,21 @@ static void btrfs_emit_options(struct btrfs_fs_info *info,
 		btrfs_info(info, "max_inline set to %llu", info->max_inline);
 }
 
+static bool btrfs_check_test_dummy_encryption(struct fs_context *fc)
+{
+	struct btrfs_fs_context *ctx = fc->fs_private;
+	struct btrfs_fs_info *fs_info = btrfs_sb(fc->root->d_sb);
+
+	if (!fscrypt_is_dummy_policy_set(&ctx->dummy_enc_policy))
+		return true;
+
+	if (fscrypt_dummy_policies_equal(&fs_info->dummy_enc_policy, &ctx->dummy_enc_policy))
+		return true;
+
+	btrfs_warn(fs_info, "Can't set or change test_dummy_encryption on remount");
+	return false;
+}
+
 static int btrfs_reconfigure(struct fs_context *fc)
 {
 	struct super_block *sb = fc->root->d_sb;
@@ -1523,6 +1577,9 @@ static int btrfs_reconfigure(struct fs_context *fc)
 	if (!btrfs_check_options(fs_info, &ctx->mount_opt, fc->sb_flags))
 		return -EINVAL;
 
+	if (!mount_reconfigure && !btrfs_check_test_dummy_encryption(fc))
+		return -EINVAL;
+
 	ret = btrfs_check_features(fs_info, !(fc->sb_flags & SB_RDONLY));
 	if (ret < 0)
 		return ret;
@@ -2139,6 +2196,7 @@ static void btrfs_free_fs_context(struct fs_context *fc)
 		btrfs_free_fs_info(fs_info);
 
 	if (ctx && refcount_dec_and_test(&ctx->refs)) {
+		fscrypt_free_dummy_policy(&ctx->dummy_enc_policy);
 		kfree(ctx->subvol_name);
 		kfree(ctx);
 	}
-- 
2.53.0


