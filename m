Return-Path: <linux-fscrypt+bounces-1079-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id ULxKIb8xhmmcKQQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1079-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:23:59 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [172.105.105.114])
	by mail.lfdr.de (Postfix) with ESMTPS id 15710101C16
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:23:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 98BD23014422
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:23:56 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BAD0540FDB8;
	Fri,  6 Feb 2026 18:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rHQdeqzz";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="rHQdeqzz"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A68034CFD3
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402235; cv=none; b=UiiXWWZsYyjqg3oeyJiumJHOPQJsRl508mGLH3S4psy/hjZkk8v8bUlNjA2QGELkchiHibRtLS2HQV3I035+HWSlpjtA8N8VNv+o0xmFU3kKWH0u0ZfOBmFzu1WXgDCs5oxI8PYO0/Ion2vhsYAhwXKJVOgq3fvUTPwDDR/Giso=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402235; c=relaxed/simple;
	bh=dIqKiSlY6yNdxjQxGu210Ie7qOHPUtULTn1tPmtqflM=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=d6NTQqTWTQA6mt6lLHhFHYnebl4K9sryBTBey/sjZ1y/pmgAMTfZnyTQA8pwZyeGjWjVEOezAWKeWN/4/K7ZD2LHSgEO+VKEupKoMdevahsovu+paWC6ZzjR509pf1V6uihjBJZTOvKfaoOaTp7ewB3tNUV4FKVakuZmX/ksKmU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rHQdeqzz; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=rHQdeqzz; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id A77B55BCE0;
	Fri,  6 Feb 2026 18:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MIRhxrqhiDY772RSDyo8PIZZrI+FmYW4jPHHJZuHZgo=;
	b=rHQdeqzzijupV4DN4b6OeeVl2Nk7QCroTqhLfAh7BIUShDAhbtXoY/5tYnzVvGqFcPO6Yi
	9wTAwmgNHtpzdvvWrpccBWaCIMjJuwmUegEyi6MC/OI0rpQz86kOLvuSkk5bmZ75ivaNnj
	Edm5S1UnvlK4K9OabYCXw0aLTjE7BNs=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402233; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=MIRhxrqhiDY772RSDyo8PIZZrI+FmYW4jPHHJZuHZgo=;
	b=rHQdeqzzijupV4DN4b6OeeVl2Nk7QCroTqhLfAh7BIUShDAhbtXoY/5tYnzVvGqFcPO6Yi
	9wTAwmgNHtpzdvvWrpccBWaCIMjJuwmUegEyi6MC/OI0rpQz86kOLvuSkk5bmZ75ivaNnj
	Edm5S1UnvlK4K9OabYCXw0aLTjE7BNs=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 741243EA63;
	Fri,  6 Feb 2026 18:23:53 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 0TgMG7kxhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:23:53 +0000
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
Subject: [PATCH v6 00/43] btrfs: add fscrypt support
Date: Fri,  6 Feb 2026 19:22:32 +0100
Message-ID: <20260206182336.1397715-1-neelx@suse.com>
X-Mailer: git-send-email 2.51.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Spam-Level: 
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
	TAGGED_FROM(0.00)[bounces-1079-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,suse.com:mid,suse.com:dkim]
X-Rspamd-Queue-Id: 15710101C16
X-Rspamd-Action: no action

Hello,

These are the remaining parts from former series [1] from Omar, Sweet Tea
and Josef.  Some bits of it were split into the separate set [2] before.

Notably, at this stage encryption is not supported with RAID5/6 setup
and send is also isabled for now.

There are a few changes since v5:
 * Rebased to btrfs/for-next branch.  Couple things changed in the last
   years.  A few patches were dropped as the code cleaned up or refactored.
   More details in the patches themselves.
 * As suggested by Qu and Dave, the on-disk format of storing the extent
   encryption context was re-designed.  Now, a new tree item with dedicated
   key is inserted instead of extending the file extent item.  As a result
   a special care needs to be taken when removing the encrypted extents
   to also remove the related encryption context item.
 * Fixed bugs found during testing.

Have a nice day,
Daniel

[1] v5 https://lore.kernel.org/linux-btrfs/cover.1706116485.git.josef@toxicpanda.com/
[2] https://lore.kernel.org/linux-btrfs/20251112193611.2536093-1-neelx@suse.com/

Josef Bacik (33):
  fscrypt: add per-extent encryption support
  fscrypt: allow inline encryption for extent based encryption
  fscrypt: add a __fscrypt_file_open helper
  fscrypt: conditionally don't wipe mk secret until the last active user
    is done
  blk-crypto: add a process bio callback
  fscrypt: add a process_bio hook to fscrypt_operations
  fscrypt: add documentation about extent encryption
  btrfs: add infrastructure for safe em freeing
  btrfs: select encryption dependencies if FS_ENCRYPTION
  btrfs: add fscrypt_info and encryption_type to ordered_extent
  btrfs: plumb through setting the fscrypt_info for ordered extents
  btrfs: populate the ordered_extent with the fscrypt context
  btrfs: keep track of fscrypt info and orig_start for dio reads
  btrfs: add extent encryption context tree item type
  btrfs: pass through fscrypt_extent_info to the file extent helpers
  btrfs: implement the fscrypt extent encryption hooks
  btrfs: setup fscrypt_extent_info for new extents
  btrfs: populate ordered_extent with the orig offset
  btrfs: set the bio fscrypt context when applicable
  btrfs: add a bio argument to btrfs_csum_one_bio
  btrfs: limit encrypted writes to 256 segments
  btrfs: implement process_bio cb for fscrypt
  btrfs: implement read repair for encryption
  btrfs: add test_dummy_encryption support
  btrfs: make btrfs_ref_to_path handle encrypted filenames
  btrfs: deal with encrypted symlinks in send
  btrfs: decrypt file names for send
  btrfs: load the inode context before sending writes
  btrfs: set the appropriate free space settings in reconfigure
  btrfs: support encryption with log replay
  btrfs: disable auto defrag on encrypted files
  btrfs: disable encryption on RAID5/6
  btrfs: disable send if we have encryption enabled

Omar Sandoval (6):
  fscrypt: expose fscrypt_nokey_name
  btrfs: start using fscrypt hooks
  btrfs: add inode encryption contexts
  btrfs: add new FEATURE_INCOMPAT_ENCRYPT flag
  btrfs: adapt readdir for encrypted and nokey names
  btrfs: implement fscrypt ioctls

Sweet Tea Dorminy (4):
  btrfs: handle nokey names.
  btrfs: add get_devices hook for fscrypt
  btrfs: set file extent encryption excplicitly
  btrfs: add fscrypt_info and encryption_type to extent_map

 Documentation/filesystems/fscrypt.rst |  41 +++
 block/blk-crypto-fallback.c           |  43 +++
 block/blk-crypto-internal.h           |   8 +
 block/blk-crypto-profile.c            |   2 +
 block/blk-crypto.c                    |   6 +-
 fs/btrfs/Kconfig                      |   3 +
 fs/btrfs/Makefile                     |   1 +
 fs/btrfs/accessors.h                  |   2 +
 fs/btrfs/backref.c                    |  42 ++-
 fs/btrfs/bio.c                        | 146 ++++++++-
 fs/btrfs/bio.h                        |  14 +-
 fs/btrfs/btrfs_inode.h                |   6 +-
 fs/btrfs/compression.c                |   6 +
 fs/btrfs/ctree.h                      |   3 +
 fs/btrfs/defrag.c                     |  14 +
 fs/btrfs/delayed-inode.c              |  25 +-
 fs/btrfs/delayed-inode.h              |   5 +-
 fs/btrfs/dir-item.c                   | 102 +++++-
 fs/btrfs/dir-item.h                   |  10 +-
 fs/btrfs/direct-io.c                  |  28 +-
 fs/btrfs/disk-io.c                    |   3 +-
 fs/btrfs/extent_io.c                  | 115 ++++++-
 fs/btrfs/extent_io.h                  |   3 +
 fs/btrfs/extent_map.c                 | 102 +++++-
 fs/btrfs/extent_map.h                 |  26 ++
 fs/btrfs/file-item.c                  |  28 +-
 fs/btrfs/file-item.h                  |   2 +-
 fs/btrfs/file.c                       |  75 +++++
 fs/btrfs/fs.h                         |   6 +-
 fs/btrfs/fscrypt.c                    | 446 ++++++++++++++++++++++++++
 fs/btrfs/fscrypt.h                    | 108 +++++++
 fs/btrfs/inode.c                      | 408 +++++++++++++++++------
 fs/btrfs/ioctl.c                      |  41 ++-
 fs/btrfs/ordered-data.c               |  35 +-
 fs/btrfs/ordered-data.h               |  14 +
 fs/btrfs/reflink.c                    |  43 ++-
 fs/btrfs/root-tree.c                  |   9 +-
 fs/btrfs/root-tree.h                  |   2 +-
 fs/btrfs/send.c                       | 134 +++++++-
 fs/btrfs/super.c                      |  99 +++++-
 fs/btrfs/super.h                      |   3 +-
 fs/btrfs/sysfs.c                      |   6 +
 fs/btrfs/tree-checker.c               |  67 +++-
 fs/btrfs/tree-log.c                   |  34 +-
 fs/crypto/crypto.c                    |  10 +-
 fs/crypto/fname.c                     |  36 ---
 fs/crypto/fscrypt_private.h           |  42 +++
 fs/crypto/hooks.c                     |  38 ++-
 fs/crypto/inline_crypt.c              |  84 ++++-
 fs/crypto/keyring.c                   |  18 +-
 fs/crypto/keysetup.c                  | 165 ++++++++++
 fs/crypto/policy.c                    |  47 +++
 include/linux/blk-crypto.h            |  15 +-
 include/linux/fscrypt.h               | 125 ++++++++
 include/uapi/linux/btrfs.h            |   1 +
 include/uapi/linux/btrfs_tree.h       |  26 +-
 56 files changed, 2683 insertions(+), 240 deletions(-)
 create mode 100644 fs/btrfs/fscrypt.c
 create mode 100644 fs/btrfs/fscrypt.h

-- 
2.51.0


