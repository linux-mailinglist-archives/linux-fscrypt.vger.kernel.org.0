Return-Path: <linux-fscrypt+bounces-1600-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id YMBOCVVEBGp0GQIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1600-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:28:53 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FA37530A16
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:28:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 8A0CE308020D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 09:03:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DBEB63FAE02;
	Wed, 13 May 2026 08:57:03 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47AC83E9C24
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662623; cv=none; b=B7efDlzVMvIhTmOLpIrTTk114QuEUSOECjzaegnq03M1hjLAZLw40bvOwbPGj2iIlvvCR68xTFMkFLZdoTUtSjTGPmjJti8QtxpWYdQE6hXQj5Gu4Fa7maYH0KIJLx9YIzNozyOrEe0yp3MaareIG3BGHQ/8RtQHjFGCS3uMkBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662623; c=relaxed/simple;
	bh=sj+D8+YdmYwbe3A3rsYn4/PyDAXXPM9Q719WZGnilC4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p3DxXpokrVr9nFV9Tt89HXinZJWX6sn7QOCH6GnN1jvy4wFYfdAKFBRXnAatBQw3MqvuZkPUrRRKvqmWy9ugqx1j4ON+PYhuqXYYot3YMCnC+Dp5GhaOxXPLrwE/dB9Nu1koK7ObYnPE9QTPAwbZyPXf3sFEvgZGEAimxkZ/+hA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 41FAF76668;
	Wed, 13 May 2026 08:54:48 +0000 (UTC)
Authentication-Results: smtp-out2.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 222A6593A9;
	Wed, 13 May 2026 08:54:48 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id SKzbB1g8BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:48 +0000
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
Subject: [PATCH v7 42/43] btrfs: disable encryption on RAID5/6
Date: Wed, 13 May 2026 10:53:16 +0200
Message-ID: <20260513085340.3673127-43-neelx@suse.com>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Score: -4.00
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Queue-Id: 4FA37530A16
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.54 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[suse.com : SPF not aligned (relaxed), No valid DKIM,quarantine];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1600-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.997];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,suse.com:email,suse.com:mid,toxicpanda.com:email]
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

The RAID5/6 code will re-arrange bios and submit them through a
different mechanism.  This is problematic with inline encryption as we
have to get the bio and csum it after it's been encrypted, and the
raid5/6 bio's don't have the btrfs_bio embedded, so we have no way to
get the csums put on disk.

This isn't an unsolvable problem, but would require a bit of reworking.
Since we discourage users from using this code currently simply don't
allow encryption on RAID5/6 setups.  If there's sufficient demand in the
future we can add the support for this.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v7 changes:
 * Prevent converting to RAID5/6 if encryption is already enabled as
   suggested by Chris' AI review.
No changes in v6.
v5: https://lore.kernel.org/linux-btrfs/941f02bb923edadae1aea4ae3e5aa6ba05d1215a.1706116485.git.josef@toxicpanda.com/
---
 fs/btrfs/ioctl.c   | 4 ++++
 fs/btrfs/super.c   | 6 ++++++
 fs/btrfs/volumes.c | 5 +++++
 3 files changed, 15 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 2e0b79f41197..873fe08cd19c 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5165,6 +5165,10 @@ long btrfs_ioctl(struct file *file, unsigned int
 			return -EOPNOTSUPP;
 		if (sb_rdonly(fs_info->sb))
 			return -EROFS;
+		if (btrfs_fs_incompat(fs_info, RAID56)) {
+			btrfs_warn(fs_info, "can't enable encryption with RAID5/6");
+			return -EINVAL;
+		}
 		/*
 		 *  If we crash before we commit, nothing encrypted could have
 		 * been written so it doesn't matter whether the encrypted
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index 7ec07d0bb473..5072ead57d49 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -734,6 +734,12 @@ bool btrfs_check_options(const struct btrfs_fs_info *info,
 	if (btrfs_check_mountopts_zoned(info, mount_opt))
 		ret = false;
 
+	if (btrfs_fs_incompat(info, RAID56) &&
+	    btrfs_raw_test_opt(*mount_opt, TEST_DUMMY_ENCRYPTION)) {
+		btrfs_err(info, "cannot use test_dummy_encryption with RAID5/6");
+		ret = false;
+	}
+
 	if (!test_bit(BTRFS_FS_STATE_REMOUNTING, &info->fs_state)) {
 		if (btrfs_raw_test_opt(*mount_opt, SPACE_CACHE)) {
 			btrfs_warn(info,
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index a88e68f90564..d70735d501c4 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -6053,6 +6053,11 @@ struct btrfs_block_group *btrfs_create_chunk(struct btrfs_trans_handle *trans,
 
 	lockdep_assert_held(&info->chunk_mutex);
 
+	if (type & BTRFS_BLOCK_GROUP_RAID56_MASK && btrfs_fs_incompat(info, ENCRYPT)) {
+		btrfs_warn(info, "RAID5/6 not yet supported on encrypted filesystem");
+		return ERR_PTR(-EINVAL);
+	}
+
 	if (!alloc_profile_is_valid(type, 0)) {
 		DEBUG_WARN("invalid alloc profile for type %llu", type);
 		return ERR_PTR(-EINVAL);
-- 
2.53.0


