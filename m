Return-Path: <linux-fscrypt+bounces-1572-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id cOYgKfU+BGoqFgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1572-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:05:57 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [104.64.211.4])
	by mail.lfdr.de (Postfix) with ESMTPS id D357B530360
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:05:56 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 9F9F5308D618
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 08:56:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 438943E5A04;
	Wed, 13 May 2026 08:55:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SRFos1Kh";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="SRFos1Kh"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E423E5577
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662519; cv=none; b=jhvvXCvt3tOyzKdlQpaiL5or7zoJ1x4c+3igOuJQ07DHfvzl0M7tOoSvONPQ0YnqoZyqGpL+iYISmUf/u1nwAVUBeJF9TiLOoet8jOVYiQCRP2Ve2FI2cyjVHEjrlZeQ9x/aq9w087X2aDp/i/CIp2WVxcGbiCVTBMqvpvHZqzg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662519; c=relaxed/simple;
	bh=QudFzzGRsBp/RQAJy9QtJ/4ZZbwfLmqwj7esHu7INFI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RTK/Y/eAqJbSmyyj2JTTfQF9xWGOl+g/vxh897+GKlq73CcUgALrUsakTzh2KBqyxHjlwpIXNKqfvVlO3Mye4ik+dLtO91woZC6cDzqyIKYYCqtDbccuyN2CiElpUJ0rmhVIdnFkoRTJoUXrmLjBLFLmIltipQRTKS77BG8ksik=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SRFos1Kh; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=SRFos1Kh; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6D10F76649;
	Wed, 13 May 2026 08:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hto4bWwwDqXe84eZTdLqLEozvhO5GKXi5cVmcNrLTAU=;
	b=SRFos1Kh5jubs9NplnUT4TSexhuMEXv+nbc9E9qfuuXA6dZArhsngkT2ZLc/SzkE+2xwWH
	jyvZ/ddmtRShg06c9/MQJXQTkHBo0BZutB71Lqziz+OV7KGVgY4Y9ZnkEjVDQ7aeuoV92x
	Gf32/pmieBk8yAo5b6fOnI7zz930M3I=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662468; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Hto4bWwwDqXe84eZTdLqLEozvhO5GKXi5cVmcNrLTAU=;
	b=SRFos1Kh5jubs9NplnUT4TSexhuMEXv+nbc9E9qfuuXA6dZArhsngkT2ZLc/SzkE+2xwWH
	jyvZ/ddmtRShg06c9/MQJXQTkHBo0BZutB71Lqziz+OV7KGVgY4Y9ZnkEjVDQ7aeuoV92x
	Gf32/pmieBk8yAo5b6fOnI7zz930M3I=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 48921593A9;
	Wed, 13 May 2026 08:54:28 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EJ4YEUQ8BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:28 +0000
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
	linux-kernel@vger.kernel.org,
	Omar Sandoval <osandov@osandov.com>,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v7 15/43] btrfs: implement fscrypt ioctls
Date: Wed, 13 May 2026 10:52:49 +0200
Message-ID: <20260513085340.3673127-16-neelx@suse.com>
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
X-Rspamd-Queue-Id: D357B530360
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:104.64.211.4:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1572-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[14];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:104.64.192.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,suse.com:email,suse.com:mid,suse.com:dkim,dorminy.me:email,osandov.com:email,sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns]
X-Rspamd-Action: no action

From: Omar Sandoval <osandov@osandov.com>

These ioctls allow encryption to actually be used.

The set_encryption_policy ioctl is the thing which actually turns on
encryption, and therefore sets the ENCRYPT flag in the superblock.
This prevents the filesystem from being loaded on older kernels.

fscrypt provides CONFIG_FS_ENCRYPTION-disabled versions of all these
functions which just return -EOPNOTSUPP, so the ioctls don't need
to be compiled out if CONFIG_FS_ENCRYPTION isn't enabled.

We could instead gate this ioctl on the superblock having the flag set,
if we wanted to require mkfs with the encrypt flag in order to have a
filesystem with any encryption.

Since this is a disk format change and is currently in development,
gate the fscrypt ioctls for btrfs behind BTRFS_EXPERIMENTAL.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

No changes in v7.
v6 changes:
 * Squash in https://lore.kernel.org/linux-btrfs/5134ab713b080f78b90eae46671596f72bbb1815.1706116485.git.josef@toxicpanda.com/
   ("btrfs: gate encryption behind BTRFS_DEBUG") and change it to
   BTRFS_EXPERIMENTAL as suggested by Dave.
v5: https://lore.kernel.org/linux-btrfs/6182b77868d0c9f9447641f869658ef017c1f467.1706116485.git.josef@toxicpanda.com/
---
 fs/btrfs/ioctl.c | 29 +++++++++++++++++++++++++++++
 1 file changed, 29 insertions(+)

diff --git a/fs/btrfs/ioctl.c b/fs/btrfs/ioctl.c
index 6a37dd3cc5ee..2e0b79f41197 100644
--- a/fs/btrfs/ioctl.c
+++ b/fs/btrfs/ioctl.c
@@ -5159,6 +5159,35 @@ long btrfs_ioctl(struct file *file, unsigned int
 		return btrfs_ioctl_get_fslabel(fs_info, argp);
 	case FS_IOC_SETFSLABEL:
 		return btrfs_ioctl_set_fslabel(file, argp);
+#ifdef CONFIG_BTRFS_EXPERIMENTAL
+	case FS_IOC_SET_ENCRYPTION_POLICY: {
+		if (!IS_ENABLED(CONFIG_FS_ENCRYPTION))
+			return -EOPNOTSUPP;
+		if (sb_rdonly(fs_info->sb))
+			return -EROFS;
+		/*
+		 *  If we crash before we commit, nothing encrypted could have
+		 * been written so it doesn't matter whether the encrypted
+		 * state persists.
+		 */
+		btrfs_set_fs_incompat(fs_info, ENCRYPT);
+		return fscrypt_ioctl_set_policy(file, (const void __user *)arg);
+	}
+	case FS_IOC_GET_ENCRYPTION_POLICY:
+		return fscrypt_ioctl_get_policy(file, (void __user *)arg);
+	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
+		return fscrypt_ioctl_get_policy_ex(file, (void __user *)arg);
+	case FS_IOC_ADD_ENCRYPTION_KEY:
+		return fscrypt_ioctl_add_key(file, (void __user *)arg);
+	case FS_IOC_REMOVE_ENCRYPTION_KEY:
+		return fscrypt_ioctl_remove_key(file, (void __user *)arg);
+	case FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS:
+		return fscrypt_ioctl_remove_key_all_users(file, (void __user *)arg);
+	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
+		return fscrypt_ioctl_get_key_status(file, (void __user *)arg);
+	case FS_IOC_GET_ENCRYPTION_NONCE:
+		return fscrypt_ioctl_get_nonce(file, (void __user *)arg);
+#endif /* CONFIG_BTRFS_EXPERIMENTAL */
 	case FITRIM:
 		return btrfs_ioctl_fitrim(fs_info, argp);
 	case BTRFS_IOC_SNAP_CREATE:
-- 
2.53.0


