Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66F364E40C7
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Mar 2022 15:16:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236471AbiCVOPI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 22 Mar 2022 10:15:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236514AbiCVOPB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 22 Mar 2022 10:15:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CAC71ED3;
        Tue, 22 Mar 2022 07:13:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A116615B3;
        Tue, 22 Mar 2022 14:13:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B169C340EC;
        Tue, 22 Mar 2022 14:13:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647958399;
        bh=Ha1+8pi51KUiSDXwMDT5GMTm0kDK44uSoiLpkhjNyUM=;
        h=From:To:Cc:Subject:Date:From;
        b=DCVZFgNrXTc4tnf86Kj4ZzEI7b52cAeINE7D5p6ksk/mxTlY3LtJvTL0EflN16Ja6
         jBnNjg1uygmVu1OGE5IWsj+ICd0wMvD7Upeekbdjaf7tzFa/hF2IUe5hPogAg2T9RM
         LobLXSBdQlwjRD2rNMTmosl7syw4qFZQq7sH9M9hFkAc9JGfMe5C9w33vnrusAgcZ1
         Xn7uwgv2d8D2/13xMY3CzuEjG146cGR2B3RgB0sUKXnV2vBFyT9np3AlxWPHWq7uMK
         VrMuU0tTeYdBPiBJuJ6rGe3gb8YDE9V5BmWSz36sZh/OGS/gVkz2D8t9qYfPW6eSaU
         xg4yXiHAnE8UQ==
From:   Jeff Layton <jlayton@kernel.org>
To:     idryomov@gmail.com, xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        lhenriques@suse.de
Subject: [RFC PATCH v11 00/51] ceph+fscrypt : full support
Date:   Tue, 22 Mar 2022 10:12:25 -0400
Message-Id: <20220322141316.41325-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patchset represents a (mostly) working prototype of the
ceph+fscrypt work. With this, I'm able run xfstests with
test_dummy_encryption, and most of the tests that pass on ceph without
fscrypt now pass on it.

When I made the last posting of this series [1], I mentioned that proper
support for sparse read support would be necessary to do this. Thus, the
biggest difference from the v10 set is that this is now based on top of
the patch series that I posted yesterday to implement sparse reads [2].

Aside from that, there are also numerous cleanups all over the tree, as
well as an overhaul of the readdir handling by Xiubo.

This series is not yet bug-free, but it's at a point where it is quite
usable, providing you're running against the Quincy release of ceph
(which should ship sometime in the next few months).

Next Steps:
===========
I'm not going to sugar-coat it. This is a huge, invasive patch series
that touches a lot of the most sensitive code in ceph.

Eric Biggers has acked the changes we need in fscrypt infrastructure. I
still need Al to ack exporting the new_inode_pseudo symbol. The rest is
pretty much all ceph and libceph code.

The main piece missing at this point is support for sparse reads with
ms_mode settings other than "crc". Once that's complete, I want to merge
that and this series into the ceph "testing" branch so we can start
running tests against it in teuthology with fscrypt enabled.

If that goes well, I think we could probably merge this into mainline
for v5.20 or v5.21. There is also some incoming support for netfs write
and DIO read helpers that we may want to convert to as well [3]. That
may alter the timing as well.

Review, comments and questions are welcome...

[1]: https://lore.kernel.org/ceph-devel/20220111191608.88762-1-jlayton@kernel.org/

[2]: https://lore.kernel.org/ceph-devel/20220318135013.43934-1-jlayton@kernel.org/

[3]: https://lore.kernel.org/ceph-devel/YixWLJXyWtD+STvl@codewreck.org/T/#maec7e3579f13a45171ad23d7a49183d169fcfcca

Jeff Layton (41):
  vfs: export new_inode_pseudo
  fscrypt: export fscrypt_base64url_encode and fscrypt_base64url_decode
  fscrypt: export fscrypt_fname_encrypt and fscrypt_fname_encrypted_size
  fscrypt: add fscrypt_context_for_new_inode
  ceph: preallocate inode for ops that may create one
  ceph: crypto context handling for ceph
  ceph: parse new fscrypt_auth and fscrypt_file fields in inode traces
  ceph: add support for fscrypt_auth/fscrypt_file to cap messages
  ceph: add ability to set fscrypt_auth via setattr
  ceph: implement -o test_dummy_encryption mount option
  ceph: decode alternate_name in lease info
  ceph: add fscrypt ioctls
  ceph: make ceph_msdc_build_path use ref-walk
  ceph: add encrypted fname handling to ceph_mdsc_build_path
  ceph: send altname in MClientRequest
  ceph: encode encrypted name in dentry release
  ceph: properly set DCACHE_NOKEY_NAME flag in lookup
  ceph: make d_revalidate call fscrypt revalidator for encrypted
    dentries
  ceph: add helpers for converting names for userland presentation
  ceph: add fscrypt support to ceph_fill_trace
  ceph: create symlinks with encrypted and base64-encoded targets
  ceph: make ceph_get_name decrypt filenames
  ceph: add a new ceph.fscrypt.auth vxattr
  ceph: add some fscrypt guardrails
  libceph: add CEPH_OSD_OP_ASSERT_VER support
  ceph: size handling for encrypted inodes in cap updates
  ceph: fscrypt_file field handling in MClientRequest messages
  ceph: get file size from fscrypt_file when present in inode traces
  ceph: handle fscrypt fields in cap messages from MDS
  ceph: add infrastructure for file encryption and decryption
  libceph: allow ceph_osdc_new_request to accept a multi-op read
  ceph: disable fallocate for encrypted inodes
  ceph: disable copy offload on encrypted inodes
  ceph: don't use special DIO path for encrypted inodes
  ceph: align data in pages in ceph_sync_write
  ceph: add read/modify/write to ceph_sync_write
  ceph: plumb in decryption during sync reads
  ceph: add fscrypt decryption support to ceph_netfs_issue_op
  ceph: set i_blkbits to crypto block size for encrypted inodes
  ceph: add encryption support to writepage
  ceph: fscrypt support for writepages

Luis Henriques (1):
  ceph: don't allow changing layout on encrypted files/directories

Xiubo Li (9):
  ceph: make the ioctl cmd more readable in debug log
  ceph: fix base64 encoded name's length check in ceph_fname_to_usr()
  ceph: pass the request to parse_reply_info_readdir()
  ceph: add ceph_encode_encrypted_dname() helper
  ceph: add support to readdir for encrypted filenames
  ceph: add __ceph_get_caps helper support
  ceph: add __ceph_sync_read helper support
  ceph: add object version support for sync read
  ceph: add truncate size handling support for fscrypt

 fs/ceph/Makefile                |   1 +
 fs/ceph/acl.c                   |   4 +-
 fs/ceph/addr.c                  | 128 ++++++--
 fs/ceph/caps.c                  | 212 +++++++++++--
 fs/ceph/crypto.c                | 432 +++++++++++++++++++++++++
 fs/ceph/crypto.h                | 256 +++++++++++++++
 fs/ceph/dir.c                   | 182 ++++++++---
 fs/ceph/export.c                |  44 ++-
 fs/ceph/file.c                  | 530 ++++++++++++++++++++++++++-----
 fs/ceph/inode.c                 | 546 +++++++++++++++++++++++++++++---
 fs/ceph/ioctl.c                 | 126 +++++++-
 fs/ceph/mds_client.c            | 455 ++++++++++++++++++++++----
 fs/ceph/mds_client.h            |  24 +-
 fs/ceph/super.c                 |  91 +++++-
 fs/ceph/super.h                 |  43 ++-
 fs/ceph/xattr.c                 |  29 ++
 fs/crypto/fname.c               |  44 ++-
 fs/crypto/fscrypt_private.h     |   9 +-
 fs/crypto/hooks.c               |   6 +-
 fs/crypto/policy.c              |  35 +-
 fs/inode.c                      |   1 +
 include/linux/ceph/ceph_fs.h    |  21 +-
 include/linux/ceph/osd_client.h |   6 +-
 include/linux/ceph/rados.h      |   4 +
 include/linux/fscrypt.h         |  10 +
 net/ceph/osd_client.c           |  32 +-
 26 files changed, 2907 insertions(+), 364 deletions(-)
 create mode 100644 fs/ceph/crypto.c
 create mode 100644 fs/ceph/crypto.h

-- 
2.35.1

