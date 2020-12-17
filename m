Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F4192DD3B4
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 16:06:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727936AbgLQPF0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 10:05:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727394AbgLQPFZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 10:05:25 -0500
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51FEBC061794
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 07:04:45 -0800 (PST)
Received: by mail-qk1-x74a.google.com with SMTP id i82so11612389qke.19
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 07:04:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=Yk0fWIDpYSRXNFlvOOk6G8jCPlvAFL7y91EQrAZ1ReI=;
        b=mr2pGb6Ug8sFbn6nsJV39BmxtDqXSgMty9VRhi4fw/oUwA1VVRxorzdlpbwaLHHhW6
         kClxH6KlsV0JluSSglqx7kq4oym5rQyH2bP2DCw2jvxjER47Kn9LfeK09AFDlB6w0X/M
         CoysKAxeKEYFY9N5JMIsgzw0on0XJmTRpVRvo0k7ggiBVUzI/XukO4gAtM1qU/9VVn87
         FTg1Fhfr53JAtgdMUl7sj3cGSxp6o15ExwemihkSL3sP8+KaCHbwoaAyMpWP7CyRqo3P
         y4/LEK7ijSCnSS7LGHSD0Tp1UanZhsZOhzendhCedxSA8OU7thFa+RSx/dfmP8UYNnQX
         r6xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=Yk0fWIDpYSRXNFlvOOk6G8jCPlvAFL7y91EQrAZ1ReI=;
        b=X+fR+WlHRlqeGqO4ME4ha/3eZ49lfQNVOdOEFzsnuF4Ir2c+M8tTMz3bPkSbfOkPnx
         vzWT2pP23+Lm3eNy365dFrJ4qH850H6LYcCUoLFTuGZ0/aZaW1ko/edAexh77NKbPvBi
         G1nyuzepoLVDmwQZEi/pNmYG/8q7qw3p3Pqj+Q9aspciy5dwXneAySELtRFJGZS3U14Z
         pdh1/QRNt6JwNb9Y5TjB4fKVBsVJsQET9Dr6Qt763zSB7uNRfc0G/moNWg0C3vn9UK24
         tXDVDSQbiI+plcbyAA6DJ7EVH2fpSQfOYqwy9ymEDc62CK/oBQ2Ur6f0I++TWkTIMUtB
         HVjA==
X-Gm-Message-State: AOAM532VkMaALP1Ud3GGhBqQnhAH4+KS9CvhB0kmK16wfgmPK/TP2lIz
        t1XYXo0x8fZ3vbhI2dJY7OOXn7d1Fjc=
X-Google-Smtp-Source: ABdhPJzt/WpiPThyfJOP52ud+2ffcF3oKSw6cetCFfe4FYdRSEvVK4B8STY6mFD+mtQDqMOq19ELoJDkEVU=
Sender: "satyat via sendgmr" <satyat@satyaprateek.c.googlers.com>
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:ad4:4c8c:: with SMTP id bs12mr50361550qvb.11.1608217484419;
 Thu, 17 Dec 2020 07:04:44 -0800 (PST)
Date:   Thu, 17 Dec 2020 15:04:32 +0000
Message-Id: <20201217150435.1505269-1-satyat@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.29.2.684.gfbc64c5ab5-goog
Subject: [PATCH v2 0/3] add support for metadata encryption to F2FS
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patch series adds support for metadata encryption to F2FS using
blk-crypto.

Currently, F2FS supports native file based encryption (FBE) via fscrypt.
FBE encrypts the contents of files that reside in folders with encryption
policies, as well as their filenames, but all other file contents
and filesystem metadata is stored unencrypted. We'd like to have metadata
and the contents of non-FBE files encrypted too, to protect data like
file sizes, xattrs, locations, etc. which can be valuable in certain
contexts.

The simplest way to do metadata encryption would be to run the filesystem
over dm-crypt (set up to encrypt all bios with the metadata encryption
key). This would essentially encrypt file contents twice (once with the FBE
key and once with the metadata encryption key).  On many android devices,
this is slower than we'd like, and also doesn't play well with inline
encryption engines (which only allow for one layer of encryption, so the
other layer must be done by the kernel crypto API).

Android currently has metadata encryption, and due to the drawbacks
listed above, doesn't use the above mentioned approach, and avoids
double encryption. Metadata encryption on android is currently
implemented using a new DM target (dm-default-key) that encrypts any
bio it receives that has data which has not previously been encrypted
(in practice, it checks for the presence of bio->bi_crypt_context, and
if it's missing, dm-default-key adds a bi_crypt_context to the bio with
the metadata encryption key that it was configured with). This works fine
as long as filesystems submit bios without bi_crypt_contexts for
filesystem metadata/unencrypted file contents, or submit bios with
bi_crypt_contexts for encrypted file contents. However, filesystems like
F2FS sometimes want to read the ciphertext of fscrypt encrypted data
contents (so F2FS will submit a bio without any bi_crypt_context, but
expects to receive ciphertext rather than the file contents decrypted
with the metadata encryption key). To address this issue, F2FS sets a flag
on the bio which essentially instructs dm-default-key not to add a
bi_crypt_context on that bio even though there isn't already one on it.
We'd like to try to come up with a metadata encryption solution that avoids
this layering violation.

The most natural solution that avoids double encryption and layering
violations is to let the filesystem take care of metadata encryption,
since the filesystem is what's responsible for knowing where the filesystem
metadata/unencrypted file contents/encrypted file contents are. This patch
series follows that approach, and adds support for metadata encryption to
F2FS and fscrypt.

Patch 1 replaces fscrypt_get_devices (which took an array of request_queues
and filled it up) with fscrypt_get_device, which takes a index of the
desired device and returns the device at that index (so the index passed
to fscrypt_get_device must be between 0 and (fscrypt_get_num_devices() - 1)
inclusive). This allows callers to avoid having to allocate an array to
pass to fscrypt_get_devices() when they only need to iterate through
each element in the array (and have no use for the array itself).

Patch 2 introduces some functions to fscrypt that help filesystems perform
metadata encryption. Any filesystem that wants to use metadata encryption
can call fscrypt_setup_metadata_encryption() with the super_block of the
filesystem, the encryption algorithm and the descriptor of the metadata
crypt key. The descriptor is looked up in the logon keyring of the
current session with "fscrypt:" as the prefix of the descriptor. The
metadata crypt key is not directly used for encryption - the actual
metadata encryption key is derived from this metadata key (refer to
fscrypt_setup_metadata_encryption() in fs/crypto/metadata_crypt.c for
details). 

The patch also introduces fscrypt_metadata_crypt_bio() which an FS should
call on a bio that the FS wants metadata crypted. The function will add
an encryption context with the metadata encryption key set up by the call
to the above mentioned fscrypt_setup_metadata_encryption().

The patch also introduces fscrypt_metadata_crypt_prepare_all_devices().
Filesystems that use multiple devices should call this function once all
the underlying devices have been determined. An FS might only be able to
determine all the underlying devices after some initial processing that
might already require metadata en/decryption, which is why this function
is separate from fscrypt_setup_metadata_encryption().

Finally, the patch makes the metadata crypt key for the filesystem part
of the key derivation process for all fscrypt file content encryption
keys used with that filesystem - this way, the file content encryption
keys are at least as strong as the metadata encryption key. For more
details please refer to fscrypt_mix_in_metadata_key() in
fs/crypto/metadata_crypt.c

Patch 3 wires up F2FS with the functions introduced in Patch 2. F2FS
will encrypt every block (that's not being encrypted by some other
encryption key, e.g. a per-file key) with the metadata encryption key
except the superblock (and the redundant copy of the superblock). The DUN
of a block is the offset of the block from the start of the F2FS
filesystem.

Please refer to the commit message for why the superblock was excluded from
en/decryption, and other limitations. The superblock and its copy are
stored in plaintext on disk. The encryption algorithm used for metadata
encryption is stored within the superblock itself. Changes to the userspace
tools (that are required to test out metadata encryption with F2FS) are
also being sent out - I'll post a link as a reply to this mail once it's
out.

Changes v1 => v2:
 - The metadata crypt key is no longer used directly for encryption. The
   actual metadata encryption key is now derived from the metadata crypt key.
   A key identifier is also derived from the metadata crypt key (and this
   identifier is verified at FS mount time). The key identifier is stored
   directly in the F2FS superblock, so there's no longer a need for any new
   mount options.
 - The metadata crypt key is now mixed into the key derivation process for
   all subkeys derived from fscrypt master keys
 - Make the metadata key payload in the keyring just the raw bytes of the
   key (instead of having it represent a struct fscrypt_key)
 - export some of the metadata_crypt.c functions, since F2FS can be built
   as a module
 - make FS_ENCRYPTION_METADATA depend on FS_ENCRYPTION_INLINE_CRYPT
 - fscrypt_set_bio_crypt_ctx() calls fscrypt_metadata_crypt_bio()
   directly, so filesystems only need to call fscrypt_set_bio_crypt_ctx()
 - Cleanups and updated docs

Satya Tangirala (3):
  fscrypt, f2fs: replace fscrypt_get_devices with fscrypt_get_device
  fscrypt: Add metadata encryption support
  f2fs: Add metadata encryption support

 Documentation/filesystems/fscrypt.rst |  86 +++++++-
 fs/crypto/Kconfig                     |  12 +
 fs/crypto/Makefile                    |   1 +
 fs/crypto/bio.c                       |   2 +-
 fs/crypto/fscrypt_private.h           |  46 ++++
 fs/crypto/hkdf.c                      |   1 +
 fs/crypto/inline_crypt.c              |  52 ++---
 fs/crypto/keyring.c                   |   4 +
 fs/crypto/metadata_crypt.c            | 303 ++++++++++++++++++++++++++
 fs/ext4/readpage.c                    |   2 +-
 fs/f2fs/data.c                        |  17 +-
 fs/f2fs/f2fs.h                        |   2 +
 fs/f2fs/super.c                       |  60 ++++-
 include/linux/f2fs_fs.h               |   7 +-
 include/linux/fs.h                    |  10 +
 include/linux/fscrypt.h               |  50 ++++-
 16 files changed, 586 insertions(+), 69 deletions(-)
 create mode 100644 fs/crypto/metadata_crypt.c

-- 
2.29.2.729.g45daf8777d-goog

