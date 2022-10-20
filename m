Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 29EA9606669
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Oct 2022 18:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229747AbiJTQ7G (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 12:59:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229792AbiJTQ7C (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 12:59:02 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFEAC1E1942;
        Thu, 20 Oct 2022 09:59:00 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 5159780040;
        Thu, 20 Oct 2022 12:58:59 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1666285139; bh=x+TP93dSW9WbfMpM+XGLUmTikryV2cpEI0Y1EvA27FE=;
        h=From:To:Cc:Subject:Date:From;
        b=vycH7XV3tUNG4+w0W2y2988nTTyECghXyi/15cIq/FcBN6rI8L5Hf9r9VaGOiI1Dp
         Bd/pWzNRsp/e3kWN1PMEoHbm1KsOnsrf5G4lhlQtCgh/+xUvroqKDMBGVW9vnSzAqJ
         ZmszcQkWOeH6+w3/2bEJK/c3MdCsTnv6Xla//Qro9+gMb8a6bIXlvVQrIl+I4aqeZC
         oKdRaxYXRnPAMbeBICqqULOfwIY7bdpL5VZom1Bg3r5w6QJs0DYjYlKxi1GPkBr2GM
         TsXg25dtDH/zMQaQnn2GADD14K8ST5yDIwcw5jramL/9uWALqX+iqaLzLzoWccbEXZ
         NcgB4vZbUT9Eg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 00/22] btrfs: add fscrypt integration
Date:   Thu, 20 Oct 2022 12:58:19 -0400
Message-Id: <cover.1666281276.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This is a changeset adding encryption to btrfs.

Last October, Omar Sandoval sent out a design document for having fscrypt
integration with btrfs [1]. In summary, it proposes btrfs storing its
own encryption IVs on a per-file-extent basis. fscrypt usually encrypts
files using an IV derived from per-inode information; this would prevent
snapshotting or reflinking or data relocation for btrfs. We have
refined this into a fscrypt extent context object, opaque to the
filesystem, which fscrypt uses to generate an IV associated with each
block in an extent. Thus, all the inodes sharing a particular
key and file extent may decrypt the extent.

This series implements this integration for the simple case,
non-compressed data extents, and for verity items. Followup changes will
allow encryption of compressed extents, inline extents, and will add
tests around subvolume encryption. This series should provide encryption
for the simplest cases, but this series should not be used in
production, as there are likely bugs.

This set hopefully reflects all of the feedback given on v2, with two
exceptions: per-extent keys, and fewer fscrypt extent context members of
btrfs structures.

On v2, Eric Biggers suggested in passing we reconsider having
per-extent keys, instead of continuing to rely on per-inode keys.
Previously, we'd considered this too memory expensive, as our reference
system averaged 4 extents per inode. But if we gave each extent its own
key structure, non-dir inodes would no longer need its own keys, making
up for the increased memory; and we can free and recreate keys as
needed to fit within a smaller memory space, it just results in more
churn. Additionally, there's a certain elegance potentially resulting:
we could take any number of levels of snapshot, giving each snapshot a
new key, and the last snapshot could be readable if you loaded all of
the N keys; this is more elegant than just supporting mixed single-key
and unencrypted extents. However, after giving this a lengthy try, I
found the result too ugly. There seemed just too many ifs in the fscrypt
hooks necessary to refer to the parent dir in many places if
extent-based, and it seemed too expensive and redundant to just have
full fscrypt contexts for both all inodes and all extents. So this
version still has only a fscrypt_iv in each fscrypt_extent_context. I
would love suggestions on how to elegantly implement per-extent keys;
the elegance of their theory is delightful.

Secondly, on v2 David Sterba disliked the abundant new fscrypt_context
members of multiple structures and hoped they could be smaller or less
frequent, and perhaps compiled out if CONFIG_FS_ENCRYPTION is disabled.
I didn't split the extent contexts out into separately allocated and
freed structures, and I preserved a 1-byte member even when encryption
is disabled in order to not ifdef every check for encryption. However,
if this turns out too inelegant, I'm happy to amend things further, or
separate the objects from extent maps altogether. My impression is that
most fscrypt functions have a no-encryption version which returns an
error, so their calls don't need to be gated on encryption.

I apologize if I missed any past feedback.

[1]
https://lore.kernel.org/linux-btrfs/YXGyq+buM79A1S0L@relinquished.localdomain/

Changelog:
v3: 
 - fscrypt: changed to generate extent contexts the same way as IVs are
   generated for inode-based encryption, allowing use of any existing
   policy and making the difference in encryption more minimal.
 - Changed to use qstr's, then fscrypt_strs, then fscrypt_names only
   where absolutely necessary, rather than fscrypt_names everywhere.
 - Reordered changes to put partially-encrypted directories, and no-key
   name handling, in their own sections at the end of the patchset.
 - Expanded on descriptions of how no-key name handling works.
 - Added encryption of verity items (but see notes in change about
   outstanding questions there)
 - Stylistic fixes
 - Renamed flags from FSCRYPT to ENCRYPT in multiple instances.
 - Made the incompat encrypt superblock flag be set the first time a
   directory is set to be encrypted, so there isn't a need for a mkfs
   option.
 - Hopefully addressed all other minor feedback points.

v2:
 - Amended the fscrypt side to generically add extent contexts,
   hopefully as per Eric Biggers' past comments. IVs are now entirely
   abstracted within an extent context, and there is no longer a new
   encryption policy, as DIRECT_KEY sufficiently encapsulates the
   needs of extent-based encryption. Documented its usage in btrfs
   briefly in the documentation. 
 - Adjusted the btrfs side to deal in opaque extent contexts. Improved
   optimization to skip storing inode contexts if they are the same as
   the inode's root item's inode context.
 - Combined 'add fscrypt operation table to superblock' into 'start
   using fscrypt hooks'.
 - https://lore.kernel.org/linux-btrfs/cover.1662420176.git.sweettea-kernel@dorminy.me
 - progs: https://lore.kernel.org/linux-btrfs/cover.1662417859.git.sweettea-kernel@dorminy.me
 - tests: https://lore.kernel.org/linux-btrfs/cover.1662417905.git.sweettea-kernel@dorminy.me

v1:
 - Recombined the fscrypt changes back into this patchset.
 - Fixed several races and incorrectly ordered operations.
 - Improved IV retrieval to correctly distinguish between
   filename/symlink encryption and encryption of block 0 of a file.
 - https://lore.kernel.org/linux-btrfs/cover.1660744500.git.sweettea-kernel@dorminy.me
 - progs: https://lore.kernel.org/linux-btrfs/cover.1660729916.git.sweettea-kernel@dorminy.me
 - tests: https://lore.kernel.org/linux-btrfs/cover.1660729861.git.sweettea-kernel@dorminy.me

RFC v2: 
 - Fixed all warnings and known incorrectnesses.
 - Split fscrypt changes into their own patchset:
    https://lore.kernel.org/linux-fscrypt/cover.1658623235.git.sweettea-kernel@dorminy.me
 - Combined and reordered changes so that enabling fscrypt is the last change.
 - Removed unnecessary factoring.
 - Split a cleanup change off.
 - https://lore.kernel.org/linux-btrfs/cover.1658623319.git.sweettea-kernel@dorminy.me 

RFC v1:
 - https://lore.kernel.org/linux-btrfs/cover.1657707686.git.sweettea-kernel@dorminy.me


Omar Sandoval (12):
  fscrypt: expose fscrypt_nokey_name
  fscrypt: add fscrypt_have_same_policy() to check inode compatibility
  btrfs: store directory encryption state
  btrfs: disable various operations on encrypted inodes
  btrfs: start using fscrypt hooks
  btrfs: add fscrypt_context items
  btrfs: translate btrfs encryption flags and encrypted inode flag
  btrfs: encrypt normal file extent data if appropriate
  btrfs: Add new FEATURE_INCOMPAT_ENCRYPT feature flag.
  btrfs: implement fscrypt ioctls
  btrfs: permit searching for nokey names for removal
  fscrypt: add flag allowing partially-encrypted directories

Sweet Tea Dorminy (10):
  fscrypt: allow fscrypt_generate_iv() to distinguish filenames
  fscrypt: add extent-based encryption
  fscrypt: document btrfs' fscrypt quirks.
  btrfs: use struct qstr instead of name and namelen
  btrfs: setup qstrings from dentrys using fscrypt helper
  btrfs: use struct fscrypt_str instead of struct qstr
  btrfs: store a fscrypt extent context per normal file extent
  btrfs: use correct name hash for nokey names
  btrfs: adapt lookup for partially encrypted directories
  btrfs: encrypt verity items

 Documentation/filesystems/fscrypt.rst |  62 ++-
 fs/btrfs/Makefile                     |   1 +
 fs/btrfs/btrfs_inode.h                |   3 +
 fs/btrfs/ctree.h                      |  96 ++++-
 fs/btrfs/delayed-inode.c              |  36 +-
 fs/btrfs/delayed-inode.h              |   6 +-
 fs/btrfs/dir-item.c                   | 193 +++++++--
 fs/btrfs/extent_io.c                  |  94 ++++-
 fs/btrfs/extent_io.h                  |   3 +
 fs/btrfs/extent_map.c                 |   7 +
 fs/btrfs/extent_map.h                 |   4 +
 fs/btrfs/file-item.c                  |  25 +-
 fs/btrfs/file.c                       |  11 +-
 fs/btrfs/fscrypt.c                    | 273 +++++++++++++
 fs/btrfs/fscrypt.h                    |  63 +++
 fs/btrfs/inode-item.c                 |  73 ++--
 fs/btrfs/inode-item.h                 |  20 +-
 fs/btrfs/inode.c                      | 559 +++++++++++++++++++-------
 fs/btrfs/ioctl.c                      |  55 ++-
 fs/btrfs/ordered-data.c               |  11 +-
 fs/btrfs/ordered-data.h               |   4 +-
 fs/btrfs/print-tree.c                 |   4 +-
 fs/btrfs/reflink.c                    |   8 +
 fs/btrfs/root-tree.c                  |  21 +-
 fs/btrfs/send.c                       |  13 +-
 fs/btrfs/super.c                      |  10 +-
 fs/btrfs/transaction.c                |  40 +-
 fs/btrfs/tree-checker.c               |  51 ++-
 fs/btrfs/tree-log.c                   | 304 +++++++-------
 fs/btrfs/tree-log.h                   |   4 +-
 fs/btrfs/verity.c                     | 112 +++++-
 fs/crypto/crypto.c                    |  29 +-
 fs/crypto/fname.c                     |  60 +--
 fs/crypto/fscrypt_private.h           |  25 +-
 fs/crypto/inline_crypt.c              |  28 +-
 fs/crypto/policy.c                    | 105 +++++
 include/linux/fscrypt.h               |  93 +++++
 include/uapi/linux/btrfs.h            |   1 +
 include/uapi/linux/btrfs_tree.h       |  28 ++
 39 files changed, 1978 insertions(+), 557 deletions(-)
 create mode 100644 fs/btrfs/fscrypt.c
 create mode 100644 fs/btrfs/fscrypt.h

-- 
2.35.1

