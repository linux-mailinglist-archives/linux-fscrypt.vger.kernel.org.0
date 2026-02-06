Return-Path: <linux-fscrypt+bounces-1115-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0LkFFkE0hmneKQQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1115-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:34:41 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B85EB101F3A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:34:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 95EE130D6130
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:29:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 99E9544B66A;
	Fri,  6 Feb 2026 18:25:21 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5264343D509
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:25:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402321; cv=none; b=ACm9IUroWK9V2SgoLkZwoO9iJQFaVPJhasuxz3bB0q9EIx2Su0if7jwQ9ZWdvJOULdW7FDZmV6a6Ar3iDJyr78iXl0NYd1MmM9lVkHN25IT8zQ2kpXqJONOU6CHJwU6JxV6LiHohOEXjOkxwORM1xEWbP/mCtIsRBTm2wgQFQRo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402321; c=relaxed/simple;
	bh=U0l18ou8F/MGcFM1MDGVGTmRLR8+PcY/gyt+caSfplE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OXK9OAJ1EyOQ0bYvqMMbPSub7traqQgJQULjjl9T5lO57t1XMpvG/ld9pQ/56qGGcsaEXZZ4tYk6jiaRMT93oLH6rx6cQw+/VgHKsIZ+oO2N926ecfcGrAJkvNpxzw9wKiDJyKENv6cfBsa43/ZqoDWUEejWQZAcOjCmVQcIEzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 67DD23E75E;
	Fri,  6 Feb 2026 18:24:16 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 3C6803EA63;
	Fri,  6 Feb 2026 18:24:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id oElJDtAxhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:24:16 +0000
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
Subject: [PATCH v6 34/43] btrfs: add test_dummy_encryption support
Date: Fri,  6 Feb 2026 19:23:06 +0100
Message-ID: <20260206182336.1397715-35-neelx@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260206182336.1397715-1-neelx@suse.com>
References: <20260206182336.1397715-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Level: 
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.54 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[suse.com : SPF not aligned (relaxed), No valid DKIM,quarantine];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1115-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.993];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:mid,suse.com:email,toxicpanda.com:email]
X-Rspamd-Queue-Id: B85EB101F3A
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
index 20c405a4789d..f47a20976b53 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -1224,6 +1224,7 @@ void btrfs_free_fs_info(struct btrfs_fs_info *fs_info)
 	btrfs_extent_buffer_leak_debug_check(fs_info);
 	kfree(fs_info->super_copy);
 	kfree(fs_info->super_for_commit);
+	fscrypt_free_dummy_policy(&fs_info->dummy_enc_policy);
 	kvfree(fs_info);
 }
 
diff --git a/fs/btrfs/fs.h b/fs/btrfs/fs.h
index 5077b7eed4b8..13cfb6887d89 100644
--- a/fs/btrfs/fs.h
+++ b/fs/btrfs/fs.h
@@ -27,6 +27,7 @@
 #include <linux/sched.h>
 #include <linux/rbtree.h>
 #include <linux/xxhash.h>
+#include <linux/fscrypt.h>
 #include <uapi/linux/btrfs.h>
 #include <uapi/linux/btrfs_tree.h>
 #include "extent-io-tree.h"
@@ -263,6 +264,7 @@ enum {
 	BTRFS_MOUNT_IGNOREMETACSUMS		= (1ULL << 31),
 	BTRFS_MOUNT_IGNORESUPERFLAGS		= (1ULL << 32),
 	BTRFS_MOUNT_REF_TRACKER			= (1ULL << 33),
+	BTRFS_MOUNT_TEST_DUMMY_ENCRYPTION	= (1ULL << 34),
 };
 
 /* These mount options require a full read-only fs, no new transaction is allowed. */
@@ -951,6 +953,7 @@ struct btrfs_fs_info {
 	spinlock_t eb_leak_lock;
 	struct list_head allocated_ebs;
 #endif
+	struct fscrypt_dummy_policy dummy_enc_policy;
 };
 
 #define folio_to_inode(_folio)	(BTRFS_I(_Generic((_folio),			\
diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
index f74404bdd89e..d1a4cbb990d4 100644
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
@@ -389,4 +394,5 @@ const struct fscrypt_operations btrfs_fscrypt_ops = {
 	.empty_dir = btrfs_fscrypt_empty_dir,
 	.get_devices = btrfs_fscrypt_get_devices,
 	.process_bio = btrfs_process_encrypted_bio,
+	.get_dummy_policy = btrfs_get_dummy_policy,
 };
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 3914abec5b12..06788b27a870 100644
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
2.51.0


