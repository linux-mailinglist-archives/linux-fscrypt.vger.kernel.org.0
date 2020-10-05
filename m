Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4D592830EF
	for <lists+linux-fscrypt@lfdr.de>; Mon,  5 Oct 2020 09:36:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725907AbgJEHgP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 5 Oct 2020 03:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725875AbgJEHgO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 5 Oct 2020 03:36:14 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B184C0613CE
        for <linux-fscrypt@vger.kernel.org>; Mon,  5 Oct 2020 00:36:14 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id g24so5698859pfo.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 05 Oct 2020 00:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:message-id:mime-version:subject:from:to:cc;
        bh=bLEC7Itfwt/vTBCBtwVmtMMOr1PQX84du7+WuinK0VQ=;
        b=HV6ym01K6y8BOz1GIxrCnw53fIUAS3awJUA7m9Z3ZlkOp5tuQKJ11SG2ntvCAnJUrm
         A/LRe4di/5HTVp1kuFcw6lod0tqBwi9AKovXncUB7nRs13Iyv+O7hU9XYUXW5nAEd588
         wC0O5FjvB0VbzoCZ/1zL3M+BKnbxKHEEcG6UIyQYU/OR66xiczJXtUw+ey2lvFeiHMjG
         OoEqBgy6iTVVju+xW9bb7gbqWn2KOxs0Ju7tkzwornb7aQXpHavJw5nB9Fi1FQfCX7IQ
         6bLtHS+ZfjPZUimtDeddRxX+PerODtxNYWvz5iPRZiez2yUVGTf31iy/ReL/jqQievKx
         ++cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:message-id:mime-version:subject:from
         :to:cc;
        bh=bLEC7Itfwt/vTBCBtwVmtMMOr1PQX84du7+WuinK0VQ=;
        b=cjpVUJ5B8eL4u5AORGly5Sjca35eRzXbFngzCJ0/iaenF2xdjumqQnHmVc0qwRNhzQ
         m6I0Yv9PlvwIqyYkb9TVpU17xFa80MBKCQ8EdvD2YJpu+72GD/dQwIFfWE98xI90Dtlv
         BYqyBYyvHgFaYJYSf0njYZ8LlCKwuXVBsn7D//vDIMXLrhJCcEhozaK5itbRsOEiviqG
         FGcJFIzOFJN9S2G2YKmQkzz+BcqPBcy21m/0Qrfhk8O3Ac5gK4cJSH3CaHzY6EqifA8i
         OvQiBS2nP7Gcu6Ij9gJA/sLbIX2hUKPBdIkL6UNtvbVwf766nIAnEqbyLn3n4+oUMsZB
         4K2Q==
X-Gm-Message-State: AOAM532RBIMk2Zjh6S+wUSIltXU1PwOaeFadB0H9CRw0XfyXzxPC0kjz
        mpUuWDxFSBn+GZa9uY9nStnAsHq9p5g=
X-Google-Smtp-Source: ABdhPJzJGbGYLMsgB9X9c+qhb2fFNPXy1LQlJv8XkQxZGAvle6p4UqaXXWl6X4IRPgmB12jFV/RqtEYP/l0=
Sender: "satyat via sendgmr" <satyat@satyaprateek.c.googlers.com>
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a17:90b:608:: with SMTP id
 gb8mr2322362pjb.6.1601883373853; Mon, 05 Oct 2020 00:36:13 -0700 (PDT)
Date:   Mon,  5 Oct 2020 07:36:03 +0000
Message-Id: <20201005073606.1949772-1-satyat@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.28.0.806.g8561365e88-goog
Subject: [PATCH 0/3] add support for metadata encryption to F2FS
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
filesystem, the encryption algorithm and the descriptor of the encryption
key. The descriptor is looked up in the logon keyring of the current
session with "fscrypt:" as the prefix of the descriptor.

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

Satya Tangirala (3):
  fscrypt, f2fs: replace fscrypt_get_devices with fscrypt_get_device
  fscrypt: Add metadata encryption support
  f2fs: Add metadata encryption support

 Documentation/filesystems/f2fs.rst |  12 ++
 fs/crypto/Kconfig                  |   6 +
 fs/crypto/Makefile                 |   1 +
 fs/crypto/fscrypt_private.h        |  19 +++
 fs/crypto/inline_crypt.c           |  37 +----
 fs/crypto/metadata_crypt.c         | 220 +++++++++++++++++++++++++++++
 fs/f2fs/data.c                     |  24 ++--
 fs/f2fs/f2fs.h                     |   2 +
 fs/f2fs/super.c                    |  83 +++++++++--
 include/linux/f2fs_fs.h            |   3 +-
 include/linux/fs.h                 |   3 +
 include/linux/fscrypt.h            |  51 ++++++-
 12 files changed, 410 insertions(+), 51 deletions(-)
 create mode 100644 fs/crypto/metadata_crypt.c

-- 
2.28.0.806.g8561365e88-goog

