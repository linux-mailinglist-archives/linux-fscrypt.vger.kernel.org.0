Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41DFA24DF72
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Aug 2020 20:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgHUS2S (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Aug 2020 14:28:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:59348 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725770AbgHUS2P (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Aug 2020 14:28:15 -0400
Received: from tleilax.com (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A63AF22EBF;
        Fri, 21 Aug 2020 18:28:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598034494;
        bh=twZ0xibB1gzq93Rw7bdYpP5BmMSEwShppiwFS164MoI=;
        h=From:To:Subject:Date:From;
        b=P9iriKvFpIluBm+77xY0388RWR3Nf6QIBWk8pQIKhoClaRhtOD6+TqTGnOzu4Unzb
         sn4ktgLbwE4no1NwHpz6FcHje30c9na9P6VO0MQY1kNy/T8/tZe5fh1OmrVAY9SAgG
         wtkTUcWwff8r1HucNyk/9eXXVjDwS5EHdArIppEE=
From:   Jeff Layton <jlayton@kernel.org>
To:     ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 00/14] ceph+fscrypt: together at last (contexts and filenames)
Date:   Fri, 21 Aug 2020 14:27:59 -0400
Message-Id: <20200821182813.52570-1-jlayton@kernel.org>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This is a (very rough and incomplete) draft patchset that I've been
working on to add fscrypt support to cephfs. The main use case is being
able to allow encryption at the edges, without having to trust your storage
provider with keys.

Implementing fscrypt on a network filesystem has some challenges that
you don't have to deal with on a local fs:

Ceph (and most other netfs') will need to pre-create a crypto context
when creating a new inode as we'll need to encrypt some things before we
have an inode. This patchset stores contexts in an xattr, but that's
probably not ideal for the final implementation [1].

Storing a binary crypttext filename on the MDS (or most network
fileservers) may be problematic. We'll probably end up having to base64
encode the names when storing them. I expect most network filesystems to
have similar issues. That may limit the effective NAME_MAX for some
filesystems [2].

For content encryption, Ceph (and probably at least CIFS/SMB) will need
to deal with writes not aligned on crypto blocks. These filesystems
sometimes write synchronously to the server instead of going through the
pagecache [3].

Symlink handling in fscrypt will also need to be refactored a bit, as we
won't have an inode before we'll need to encrypt its contents.

This draft is _very_ rough and not ready for merge. This only covers the
context handling and filename encryption. It's missing a lot of stuff
still, but what's there basically works.

I'm mostly posting this now to get some early feedback on the basic idea
and approach. In particular, I'd appreciate some feedback from the
fscrypt maintainers. Please let me know if any of the changes I'm
proposing there look problematic.

Thanks for looking!
-- Jeff

[1]: We'll likely add a dedicated field to the standard on-the-wire
inode representation and in the MDS, but that's a separate sub-project.

[2]: For ceph, it looks like it's not a huge problem as the MDS doesn't
enforce filename lengths at all. Still, we may extend the protocol to
handle that better.

[3]: For Ceph, I think we'll be able to do a CMPEXT op to do a
read/modify/write-if-nothing-changed cycle for this case.

Jeff Layton (14):
  fscrypt: drop unused inode argument from fscrypt_fname_alloc_buffer
  fscrypt: add fscrypt_new_context_from_parent
  fscrypt: don't balk when inode is already marked encrypted
  fscrypt: export fscrypt_d_revalidate
  lib: lift fscrypt base64 conversion into lib/
  ceph: add fscrypt ioctls
  ceph: crypto context handling for ceph
  ceph: add routine to create context prior to RPC
  ceph: set S_ENCRYPTED bit if new inode has encryption.ctx xattr
  ceph: make ceph_msdc_build_path use ref-walk
  ceph: add encrypted fname handling to ceph_mdsc_build_path
  ceph: make d_revalidate call fscrypt revalidator for encrypted
    dentries
  ceph: add support to readdir for encrypted filenames
  ceph: add fscrypt support to ceph_fill_trace

 fs/ceph/Makefile        |   1 +
 fs/ceph/crypto.c        | 171 ++++++++++++++++++++++++++++++++++++++++
 fs/ceph/crypto.h        |  81 +++++++++++++++++++
 fs/ceph/dir.c           |  97 ++++++++++++++++++++---
 fs/ceph/file.c          |   4 +
 fs/ceph/inode.c         |  62 +++++++++++++--
 fs/ceph/ioctl.c         |  26 ++++++
 fs/ceph/mds_client.c    |  74 ++++++++++++-----
 fs/ceph/super.c         |  37 +++++++++
 fs/ceph/super.h         |  11 ++-
 fs/ceph/xattr.c         |  32 ++++++++
 fs/crypto/Kconfig       |   1 +
 fs/crypto/fname.c       |  67 +---------------
 fs/crypto/hooks.c       |   2 +-
 fs/crypto/keysetup.c    |   2 +-
 fs/crypto/policy.c      |  42 +++++++---
 fs/ext4/dir.c           |   2 +-
 fs/ext4/namei.c         |   7 +-
 fs/f2fs/dir.c           |   2 +-
 fs/ubifs/dir.c          |   2 +-
 include/linux/base64.h  |  11 +++
 include/linux/fscrypt.h |  12 ++-
 lib/Kconfig             |   3 +
 lib/Makefile            |   1 +
 lib/base64.c            |  71 +++++++++++++++++
 25 files changed, 696 insertions(+), 125 deletions(-)
 create mode 100644 fs/ceph/crypto.c
 create mode 100644 fs/ceph/crypto.h
 create mode 100644 include/linux/base64.h
 create mode 100644 lib/base64.c

-- 
2.26.2

