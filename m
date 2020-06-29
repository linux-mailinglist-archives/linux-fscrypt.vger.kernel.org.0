Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C94B220E0CA
	for <lists+linux-fscrypt@lfdr.de>; Mon, 29 Jun 2020 23:57:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729999AbgF2Utt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 29 Jun 2020 16:49:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731486AbgF2TNk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 29 Jun 2020 15:13:40 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 37EBDC0F26C7
        for <linux-fscrypt@vger.kernel.org>; Mon, 29 Jun 2020 05:04:13 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id h5so8682870pgq.4
        for <linux-fscrypt@vger.kernel.org>; Mon, 29 Jun 2020 05:04:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=OgrownsdciRkQfHLu2Mfy3btRxxtBKOX+y4E3Oqteos=;
        b=gBiZCVlEO4XDHJNS23BhAsQTP1jO1/1YSpaH/WgvMSS3FuMlqd+4vKZrSzJYaWnl/Y
         1n1gSdCt3z+pNV3CigPeOXG4eWXKbpivWBuPyrfPGp1RIgFeEDVv/cPemO6wV3JCho0e
         jtOIYCZIL5m5allS+ROBU+GL06J1VYIuxb9Z5y9RT3Zi8IiwzIYN+bmBk1wt2JfYac8c
         Ye2I8lshSh/FtnYECOI3yuRPOKNSi/QlD9zFMx5r0MsMNroQ3ZPLZjUGeLkHYYQ4sm3/
         3luLSZG+zTmBtBG1Ed7XTgsbFfmZSkITPVvXtYQ1D95XhQY/gcG72x8y0aBQeNDpQhaa
         CvEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=OgrownsdciRkQfHLu2Mfy3btRxxtBKOX+y4E3Oqteos=;
        b=fkTRIoo1W+/adkTukLyyiq1AV+FoWfG8KexnDKzN6/eYA1REhhd0FPRgfefrMVChnk
         ZDFkTx+8R5mG5yFzrkok7Kv8sqOrKpHQtpQt/A/VNFvHF4j//saFQtUp84TmAdpYlxKx
         5eMtRAe7xermiluHrsebYvvvjTrf5eF+zYHsrEQtlitYAY/WYP+oTUQCVaxSnuOt9J3s
         oeD7dD1O8dZxgTbQ0lOAW6Tf+Mv/3bPY4zgxgay61H1gzfe2zhADtft104+EkrpXTNgo
         mVCmoyw7YWgXsknmHXTGuDahabyN3S8NVDh0N2AfWrNzLM/3OoxOmLhQPWI+d0+bCdki
         PlDQ==
X-Gm-Message-State: AOAM530iFUWELSE66zmOf29A9dmoZfD32ZeK1w25nBXB3mwIN30jpfzO
        Jgud1rDwLWuawg439wUsx6wC8b+wdMas9MqgAVwtFbOB0uNc5u7+F8vC/ceqh708r5dMuQVBqow
        yH/4gXecDT71F5lW5iIND8A1vyi16CBqZ0Uqc/krTYS52oAbWZDZNgHHpaF6v8ruqU3veDRY=
X-Google-Smtp-Source: ABdhPJwYLTVSt9n1XjUVygrqIZ2mKYtW5G+8LSUlIBRmnIEmdQxeGLDbPT+he1blzav1wz1DLUaRqIPqKYM=
X-Received: by 2002:a17:902:c408:: with SMTP id k8mr13536731plk.279.1593432252439;
 Mon, 29 Jun 2020 05:04:12 -0700 (PDT)
Date:   Mon, 29 Jun 2020 12:04:01 +0000
Message-Id: <20200629120405.701023-1-satyat@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH v2 0/4] Inline Encryption Support for fscrypt
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patch series adds support for Inline Encryption to fscrypt, f2fs
and ext4. It builds on the inline encryption support now present in
the block layer, and has been rebased on v5.8-rc3.

This patch series previously went though a number of iterations as part
of the "Inline Encryption Support" patchset (last version was v13:
https://lkml.kernel.org/r/20200514003727.69001-1-satyat@google.com).

Patch 1 introduces the SB_INLINECRYPT sb options, which filesystems
should set if they want to use blk-crypto for file content en/decryption.

Patch 2 adds inline encryption support to fscrypt. To use inline
encryption with fscrypt, the filesystem must set the above mentioned
SB_INLINECRYPT sb option. When this option is set, the contents of
encrypted files will be en/decrypted using blk-crypto.

Patches 3 and 4 wire up f2fs and ext4 respectively to fscrypt support for
inline encryption, and e.g ensure that bios are submitted with blocks
that not only are contiguous, but also have continuous DUNs.

This patchset was tested by running xfstests with the "inlinecrypt" mount
option on ext4 and f2fs with test dummy encryption (the actual
en/decryption of file contents was handled by the blk-crypto-fallback). It
was also tested along with the UFS patches from the original series on some
Qualcomm and Mediatek chipsets with hardware inline encryption support
(refer to
https://lkml.kernel.org/linux-scsi/20200501045111.665881-1-ebiggers@kernel.org/
and
https://lkml.kernel.org/linux-scsi/20200304022101.14165-1-stanley.chu@mediatek.com/
for more details on those tests).

Changes v1 => v2
 - SB_INLINECRYPT mount option is shown by individual filesystems instead
   of by the common VFS code since the option is parsed by filesystem
   specific code, and is not a mount option applicable generically to
   all filesystems.
 - Make fscrypt_select_encryption_impl() return error code when it fails
   to allocate memory.
 - cleanups
 
Changes v13 in original patchset => v1
 - rename struct fscrypt_info::ci_key to ci_enc_key
 - set dun bytes more precisely in fscrypt
 - cleanups

Eric Biggers (1):
  ext4: add inline encryption support

Satya Tangirala (3):
  fs: introduce SB_INLINECRYPT
  fscrypt: add inline encryption support
  f2fs: add inline encryption support

 Documentation/admin-guide/ext4.rst    |   6 +
 Documentation/filesystems/f2fs.rst    |   7 +
 Documentation/filesystems/fscrypt.rst |   3 +
 fs/buffer.c                           |   7 +-
 fs/crypto/Kconfig                     |   6 +
 fs/crypto/Makefile                    |   1 +
 fs/crypto/bio.c                       |  50 ++++
 fs/crypto/crypto.c                    |   2 +-
 fs/crypto/fname.c                     |   4 +-
 fs/crypto/fscrypt_private.h           | 115 ++++++++-
 fs/crypto/inline_crypt.c              | 351 ++++++++++++++++++++++++++
 fs/crypto/keyring.c                   |   6 +-
 fs/crypto/keysetup.c                  |  70 +++--
 fs/crypto/keysetup_v1.c               |  16 +-
 fs/ext4/inode.c                       |   4 +-
 fs/ext4/page-io.c                     |   6 +-
 fs/ext4/readpage.c                    |  11 +-
 fs/ext4/super.c                       |  12 +
 fs/f2fs/compress.c                    |   2 +-
 fs/f2fs/data.c                        |  78 +++++-
 fs/f2fs/super.c                       |  35 +++
 include/linux/fs.h                    |   1 +
 include/linux/fscrypt.h               |  82 ++++++
 23 files changed, 804 insertions(+), 71 deletions(-)
 create mode 100644 fs/crypto/inline_crypt.c

-- 
2.27.0.212.ge8ba1cc988-goog

