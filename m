Return-Path: <linux-fscrypt+bounces-1114-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id bWe7MiU2hmmHLAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1114-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:42:45 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3C488102293
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:42:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id CCA1930A2D5E
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:28:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD16744A701;
	Fri,  6 Feb 2026 18:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="D7eLlhRf";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="o3CIKfJw"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AB6644A71D
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:25:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402317; cv=none; b=X3qGtKE8yu51tgWu8Hh++rh4cW2zJq7gH77ePK0lsiiHg7Ip094OASgqdKEmpaTkAaXbvMIIpQUvlp2RLjz0HnShWFrOymM9lF+yE3xsXstc2yxpwznrTGv2CbYnbKPY+Ho8qegovgP6FM/UVm8pOkX/SxEZqc6yYGOvDY3vEhg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402317; c=relaxed/simple;
	bh=x51Cg5xsCzKVGWOmBJtih3DOztBpxfL6ZG35siCQ3ms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V/lBFGeNTdy0UVIQn93ABbF75O5nwHC4NClqXLUwVtNcFTthMzGX82yfA6F6UWAAC0UBjdiQtG5JyNIR35/zYc+mYxts1g3YU5dR+IU6N+smvGUUO9HxDATqu/EUGRXPj2r6gKjVWpx9xN2kmTOtRa0W3/MHfVKjlHOMPwF+j0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=D7eLlhRf; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=o3CIKfJw; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E70C05BD38;
	Fri,  6 Feb 2026 18:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402259; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u9CaRWPO0XEEkcqklCFMGPi2Gz5Gl8+A3LyPbQLO5J0=;
	b=D7eLlhRfCnY9+hkf+p9KXeqIRvCUG/8VTOeBoBatxFEeHl/Xn0bMe5QwI88ijwFQ+EWRiH
	uvth8ETfOFWA1ozenxXnMFRMTrVEiI/qif9B64u8lnRZnzmxLfbBQmV88MX8fSKsMuXwcI
	VopFnAy38Gpat5BMEP9cRgdHwHI2HQc=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402258; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=u9CaRWPO0XEEkcqklCFMGPi2Gz5Gl8+A3LyPbQLO5J0=;
	b=o3CIKfJwv0X6WkIAr2IiYMi8eN6avPef/zXeFxEXUE36h903nV+Owpb7u4etSigKcKohLD
	gdEgUE5gkC9KQaUnY11RyWswS+kgcFwLNuK7No7/ssnOEx6DuCszdIE0mPjwJE35N/GHJl
	2U392xn0mh+Rg5g2lhcEdHOhoNKz4CY=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id B9DC33EA63;
	Fri,  6 Feb 2026 18:24:18 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id ACrlLNIxhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:24:18 +0000
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
Subject: [PATCH v6 39/43] btrfs: set the appropriate free space settings in reconfigure
Date: Fri,  6 Feb 2026 19:23:11 +0100
Message-ID: <20260206182336.1397715-40-neelx@suse.com>
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
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1114-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,suse.com:email,suse.com:dkim,suse.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3C488102293
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

btrfs/330 uncovered a problem where we were accidentally turning off the
free space tree when we do the transition from ro->rw.  This happens
because we don't update

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v5: https://lore.kernel.org/linux-btrfs/325598eeb1d23f9ae04f675b4ee218f7e98e3ff0.1706116485.git.josef@toxicpanda.com/
 * Re-wrapped comments.
 * Fixed argument type.  mount_opt is now ull.
---
 fs/btrfs/disk-io.c |  2 +-
 fs/btrfs/super.c   | 28 +++++++++++++++-------------
 fs/btrfs/super.h   |  3 ++-
 3 files changed, 18 insertions(+), 15 deletions(-)

diff --git a/fs/btrfs/disk-io.c b/fs/btrfs/disk-io.c
index f47a20976b53..993d2080fcbf 100644
--- a/fs/btrfs/disk-io.c
+++ b/fs/btrfs/disk-io.c
@@ -3416,7 +3416,7 @@ int __cold open_ctree(struct super_block *sb, struct btrfs_fs_devices *fs_device
 	 * Handle the space caching options appropriately now that we have the
 	 * super block loaded and validated.
 	 */
-	btrfs_set_free_space_cache_settings(fs_info);
+	btrfs_set_free_space_cache_settings(fs_info, &fs_info->mount_opt);
 
 	if (!btrfs_check_options(fs_info, &fs_info->mount_opt, sb->s_flags)) {
 		ret = -EINVAL;
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 06788b27a870..4a2887147ead 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -745,10 +745,10 @@ bool btrfs_check_options(const struct btrfs_fs_info *info,
 }
 
 /*
- * This is subtle, we only call this during open_ctree().  We need to pre-load
- * the mount options with the on-disk settings.  Before the new mount API took
- * effect we would do this on mount and remount.  With the new mount API we'll
- * only do this on the initial mount.
+ * Because we have an odd set of behavior with turning on and off the space cache
+ * and free space tree we have to call this before we start the mount operation
+ * after we load the super, or before we start remount.  This is to make sure we
+ * have the proper free space settings in place if the user didn't specify any.
  *
  * This isn't a change in behavior, because we're using the current state of the
  * file system to set the current mount options.  If you mounted with special
@@ -756,21 +756,22 @@ bool btrfs_check_options(const struct btrfs_fs_info *info,
  * settings, because mounting without these features cleared the on-disk
  * settings, so this being called on re-mount is not needed.
  */
-void btrfs_set_free_space_cache_settings(struct btrfs_fs_info *fs_info)
+void btrfs_set_free_space_cache_settings(struct btrfs_fs_info *fs_info,
+					 unsigned long long *mount_opt)
 {
-	if (fs_info->sectorsize != PAGE_SIZE && btrfs_test_opt(fs_info, SPACE_CACHE)) {
+	if (fs_info->sectorsize != PAGE_SIZE && btrfs_raw_test_opt(*mount_opt, SPACE_CACHE)) {
 		btrfs_info(fs_info,
 			   "forcing free space tree for sector size %u with page size %lu",
 			   fs_info->sectorsize, PAGE_SIZE);
-		btrfs_clear_opt(fs_info->mount_opt, SPACE_CACHE);
-		btrfs_set_opt(fs_info->mount_opt, FREE_SPACE_TREE);
+		btrfs_clear_opt(*mount_opt, SPACE_CACHE);
+		btrfs_set_opt(*mount_opt, FREE_SPACE_TREE);
 	}
 
 	/*
 	 * At this point our mount options are populated, so we only mess with
 	 * these settings if we don't have any settings already.
 	 */
-	if (btrfs_test_opt(fs_info, FREE_SPACE_TREE))
+	if (btrfs_raw_test_opt(*mount_opt, FREE_SPACE_TREE))
 		return;
 
 	if (btrfs_is_zoned(fs_info) &&
@@ -780,10 +781,10 @@ void btrfs_set_free_space_cache_settings(struct btrfs_fs_info *fs_info)
 		return;
 	}
 
-	if (btrfs_test_opt(fs_info, SPACE_CACHE))
+	if (btrfs_raw_test_opt(*mount_opt, SPACE_CACHE))
 		return;
 
-	if (btrfs_test_opt(fs_info, NOSPACECACHE))
+	if (btrfs_raw_test_opt(*mount_opt, NOSPACECACHE))
 		return;
 
 	/*
@@ -791,9 +792,9 @@ void btrfs_set_free_space_cache_settings(struct btrfs_fs_info *fs_info)
 	 * them ourselves based on the state of the file system.
 	 */
 	if (btrfs_fs_compat_ro(fs_info, FREE_SPACE_TREE))
-		btrfs_set_opt(fs_info->mount_opt, FREE_SPACE_TREE);
+		btrfs_set_opt(*mount_opt, FREE_SPACE_TREE);
 	else if (btrfs_free_space_cache_v1_active(fs_info))
-		btrfs_set_opt(fs_info->mount_opt, SPACE_CACHE);
+		btrfs_set_opt(*mount_opt, SPACE_CACHE);
 }
 
 static void set_device_specific_options(struct btrfs_fs_info *fs_info)
@@ -1573,6 +1574,7 @@ static int btrfs_reconfigure(struct fs_context *fc)
 
 	sync_filesystem(sb);
 	set_bit(BTRFS_FS_STATE_REMOUNTING, &fs_info->fs_state);
+	btrfs_set_free_space_cache_settings(fs_info, &ctx->mount_opt);
 
 	if (!btrfs_check_options(fs_info, &ctx->mount_opt, fc->sb_flags))
 		return -EINVAL;
diff --git a/fs/btrfs/super.h b/fs/btrfs/super.h
index d80a86acfbbe..584f428d36e2 100644
--- a/fs/btrfs/super.h
+++ b/fs/btrfs/super.h
@@ -16,7 +16,8 @@ bool btrfs_check_options(const struct btrfs_fs_info *info,
 int btrfs_sync_fs(struct super_block *sb, int wait);
 char *btrfs_get_subvol_name_from_objectid(struct btrfs_fs_info *fs_info,
 					  u64 subvol_objectid);
-void btrfs_set_free_space_cache_settings(struct btrfs_fs_info *fs_info);
+void btrfs_set_free_space_cache_settings(struct btrfs_fs_info *fs_info,
+					 unsigned long long *mount_opt);
 
 static inline struct btrfs_fs_info *btrfs_sb(struct super_block *sb)
 {
-- 
2.51.0


