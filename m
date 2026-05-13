Return-Path: <linux-fscrypt+bounces-1558-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id 0AHPMRA9BGoqFgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1558-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 10:57:52 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 5462C53013E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 10:57:51 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id E4DE2303AF3F
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 08:54:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C243C3AE70A;
	Wed, 13 May 2026 08:54:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aG3IEvt5";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="aG3IEvt5"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2AFF53E3C7C
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662458; cv=none; b=RVOkG4FhpfbA48z1lL/mI8R+IiETVlOoxNB2dFW0OwYtJ9WB+vovrZyeFJBxn1MQaxVVE2Vs12n/ZbnQw4Msp1yRIjfD+GWkhFtOklhRJt/ykoFCSL0dO9jA35RrgqiDqOQCBRT96bg7ajMINhrPp4PfkVdusF93QLLfOZnR10U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662458; c=relaxed/simple;
	bh=Y29+1tJECBAhDbQ8d/Bek1wFSQNEgeN4jcVsYIWfsJc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=YtVyraC5Fpdu16F/3n4G+4Z8akj5I6E4yHvDu/yVxBoNBddkxZt9F1suAqmu1LuxWofF2w5N3DXBUreykRLpKQnVu+6ZymZmpiW3jTdyC9Dnf71T7I6P/xqEZr+OJ7ls1U9GABTHc/HqrqQsEmPv7sE7vVPOEv0N95heeoDcxkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=aG3IEvt5; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=aG3IEvt5; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 7ECB76AE54;
	Wed, 13 May 2026 08:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662455; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=20FaKWKoBS11519zIQEwjd5nJxOwVdBo5IIuF0POkpk=;
	b=aG3IEvt5RsuEeZEWZwZOMawZfUhiWxnABZWHENgVfvBsCvn9OKh7tMMY7Z6zywjZlb045a
	K5A+ObiG2Qf4AJv3CTVwX7gpzKDnR7rfHQw1U8e0+PSP1Ziknal2yMeKBpvF3rOVwF33s6
	w0GvWj9rWQGP2B9NcyRtF0poKMVGt/A=
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662455; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=20FaKWKoBS11519zIQEwjd5nJxOwVdBo5IIuF0POkpk=;
	b=aG3IEvt5RsuEeZEWZwZOMawZfUhiWxnABZWHENgVfvBsCvn9OKh7tMMY7Z6zywjZlb045a
	K5A+ObiG2Qf4AJv3CTVwX7gpzKDnR7rfHQw1U8e0+PSP1Ziknal2yMeKBpvF3rOVwF33s6
	w0GvWj9rWQGP2B9NcyRtF0poKMVGt/A=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E43B4593A9;
	Wed, 13 May 2026 08:54:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aQs3NzY8BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:14 +0000
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
Subject: [PATCH v7 00/43] btrfs: add fscrypt support
Date: Wed, 13 May 2026 10:52:34 +0200
Message-ID: <20260513085340.3673127-1-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -2.80
X-Rspamd-Queue-Id: 5462C53013E
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1558-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:mid,suse.com:dkim]
X-Rspamd-Action: no action

Hello,

These are the remaining parts from former series [1] from Omar, Sweet Tea
and Josef.  Some bits of it were split into the separate set [2] before.

Notably, at this stage encryption is not supported with RAID5/6 setup
and send is also disabled for now.

For straight git access you can find this series as the `fscrypt-v7` tag
e85358ef9fba here:

[0] https://github.com/dvacek/linux-btrfs/tree/fscrypt-v7

Changes since v6 [3]
 * Rebased onto linux v7.1-rc3.
 * Adapted to the v7.0 fscrypt API changes, mostly following commit
   bb8e2019ad613 ("blk-crypto: handle the fallback above the block layer")
 * Addressed all the review feedback, thanks to Eric Biggers, Chris Mason
   (and his LLM review prompts) and Neal Gompa.
 * Adapted to the v7.1 fscrypt API cleanups, using byte offsets as function
   arguments instead of logical block numbers for newly introduced functions.
   This should match https://lore.kernel.org/linux-fscrypt/20260218061531.3318130-1-hch@lst.de/
   As a result btrfs_set_bio_crypt_ctx_from_extent() and btrfs_mergeable_encrypted_bio()
   helpers were no longer needed and they got removed.

There are a few changes since v5 [1]:
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
[2]    https://lore.kernel.org/linux-btrfs/20251112193611.2536093-1-neelx@suse.com/
[3] v6 https://lore.kernel.org/linux-btrfs/20260206182336.1397715-1-neelx@suse.com/

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
  btrfs: handle nokey names
  btrfs: add get_devices hook for fscrypt
  btrfs: set file extent encryption excplicitly
  btrfs: add fscrypt_info and encryption_type to extent_map

 Documentation/filesystems/fscrypt.rst |  41 +++
 block/blk-crypto-fallback.c           |  41 +++
 block/blk-crypto-internal.h           |   8 +
 block/blk-crypto-profile.c            |   2 +
 block/blk-crypto.c                    |   6 +-
 fs/btrfs/Kconfig                      |   4 +
 fs/btrfs/Makefile                     |   1 +
 fs/btrfs/accessors.h                  |   2 +
 fs/btrfs/backref.c                    |  43 ++-
 fs/btrfs/bio.c                        | 155 +++++++++-
 fs/btrfs/bio.h                        |  14 +-
 fs/btrfs/btrfs_inode.h                |   7 +-
 fs/btrfs/compression.c                |   6 +
 fs/btrfs/ctree.h                      |   3 +
 fs/btrfs/defrag.c                     |  14 +
 fs/btrfs/delayed-inode.c              |  25 +-
 fs/btrfs/delayed-inode.h              |   5 +-
 fs/btrfs/dir-item.c                   | 110 ++++++-
 fs/btrfs/dir-item.h                   |  10 +-
 fs/btrfs/direct-io.c                  |  28 +-
 fs/btrfs/disk-io.c                    |   3 +-
 fs/btrfs/extent_io.c                  | 115 ++++++-
 fs/btrfs/extent_io.h                  |   3 +
 fs/btrfs/extent_map.c                 | 102 ++++++-
 fs/btrfs/extent_map.h                 |  26 ++
 fs/btrfs/file-item.c                  |  28 +-
 fs/btrfs/file-item.h                  |   2 +-
 fs/btrfs/file.c                       |  79 +++++
 fs/btrfs/fs.h                         |   6 +-
 fs/btrfs/fscrypt.c                    | 413 ++++++++++++++++++++++++++
 fs/btrfs/fscrypt.h                    |  86 ++++++
 fs/btrfs/inode.c                      | 404 +++++++++++++++++++------
 fs/btrfs/ioctl.c                      |  41 ++-
 fs/btrfs/ordered-data.c               |  35 ++-
 fs/btrfs/ordered-data.h               |  14 +
 fs/btrfs/reflink.c                    |  43 ++-
 fs/btrfs/root-tree.c                  |   9 +-
 fs/btrfs/root-tree.h                  |   2 +-
 fs/btrfs/send.c                       | 134 ++++++++-
 fs/btrfs/super.c                      |  99 +++++-
 fs/btrfs/super.h                      |   3 +-
 fs/btrfs/sysfs.c                      |   6 +
 fs/btrfs/tree-checker.c               |  64 +++-
 fs/btrfs/tree-log.c                   |  34 ++-
 fs/btrfs/volumes.c                    |   5 +
 fs/crypto/crypto.c                    |  10 +-
 fs/crypto/fname.c                     |  36 ---
 fs/crypto/fscrypt_private.h           |  51 +++-
 fs/crypto/hooks.c                     |  38 ++-
 fs/crypto/inline_crypt.c              |  91 +++++-
 fs/crypto/keyring.c                   |  18 +-
 fs/crypto/keysetup.c                  | 164 ++++++++++
 fs/crypto/policy.c                    |  47 +++
 include/linux/blk-crypto.h            |  15 +-
 include/linux/fscrypt.h               | 127 ++++++++
 include/uapi/linux/btrfs.h            |   1 +
 include/uapi/linux/btrfs_tree.h       |  26 +-
 57 files changed, 2665 insertions(+), 240 deletions(-)
 create mode 100644 fs/btrfs/fscrypt.c
 create mode 100644 fs/btrfs/fscrypt.h

-- 
2.53.0


