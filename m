Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBA4557F237
	for <lists+linux-fscrypt@lfdr.de>; Sun, 24 Jul 2022 02:52:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230506AbiGXAwj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 23 Jul 2022 20:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229772AbiGXAwi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 23 Jul 2022 20:52:38 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CE8C14D10;
        Sat, 23 Jul 2022 17:52:37 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id F0D6780794;
        Sat, 23 Jul 2022 20:52:36 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1658623957; bh=RAQNqSLQnPCNoIiEhDvY+4M3GbpUGvsojzAKy+lc6/Q=;
        h=From:To:Cc:Subject:Date:From;
        b=SdCm/HZTzCERxBrSYy57Lv5VWfRalppRdv/RcLrb5LvH/4SvbnoLOQTa6tsbtZTzA
         +i0XYqbfWhLa6nv9RuHreGac2jT2kk+KuXfHxS9GDD7GTOeSlxxDt4DMd1HO/mXJlo
         kvrGJLi8cZBbnEyr9eq3qBp+CDv+oQ3x5BtlyXhUDDCAmZKwSBUnCAkzAJvhfhsn2r
         hZCyRq/kDhZexVvlxRFGdwuu/PFznInLCtPlI0vxZA3eolC2va8NY2MHJD2kVufbMm
         Mhx54KAz6/KKNc0m7t+0T6hyyUjF5dq2g3+doB+DxrJcH7yvsBFyvfyVY/uLoE0ABJ
         wshdUrn6QaeQQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y . Ts'o " <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, osandov@osandov.com,
        kernel-team@fb.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH RFC 0/4] fscrypt changes for btrfs encryption
Date:   Sat, 23 Jul 2022 20:52:24 -0400
Message-Id: <cover.1658623235.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This is the fscrypt section of my draft patch series [1] to add
encryption support to btrfs.

Last October, Omar Sandoval sent out a design proposal for using fscrypt
with btrfs [2]. To tersely summarize the challenges laid out in the
document, btrfs supports sharing the same physical storage between
multiple files (reflinks); moving the physical location of file data
without access to the file inodes; and creating writable snapshots of
some directories (subvolumes). To allow encryption to coexist with these
features, the proposal was for btrfs to create and preserve an IV per
data block, no matter its physical location or owning inode(s), and for
btrfs to allow partially-encrypted writable snapshots of unencrypted
subvolumes.

To deal with these issues, a few changes to fscrypt are proposed:
- To enable snapshotting and then encrypting new writes to that
  subvolume, a flag to allow partially encrypted directories;
- To allow filesystems to supply an IV in cases where the logical block
  number and owning inode for data may change, a new policy and
  interface to convey IVs from filesystem to fscrypt.

Comments, especially on the new policy and interface, appreciated!

[1] https://lore.kernel.org/linux-btrfs/cover.1658623319.git.sweettea-kernel@dorminy.me
[2] https://lore.kernel.org/linux-btrfs/YXGyq+buM79A1S0L@relinquished.localdomain/

Omar Sandoval (3):
  fscrypt: expose fscrypt_nokey_name
  fscrypt: add flag allowing partially-encrypted directories
  fscrypt: add fscrypt_have_same_policy() to check inode's compatibility

Sweet Tea Dorminy (1):
  fscrypt: Add new encryption policy for btrfs.

 fs/crypto/crypto.c           | 28 +++++++++++++++--
 fs/crypto/fname.c            | 56 ++++++++++-----------------------
 fs/crypto/fscrypt_private.h  |  4 +--
 fs/crypto/inline_crypt.c     | 20 ++++++++----
 fs/crypto/keysetup.c         |  5 +++
 fs/crypto/policy.c           | 42 ++++++++++++++++++++++++-
 include/linux/fscrypt.h      | 61 +++++++++++++++++++++++++++++++++++-
 include/uapi/linux/fscrypt.h |  1 +
 8 files changed, 166 insertions(+), 51 deletions(-)

-- 
2.35.1

