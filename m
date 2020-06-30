Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 756D020F443
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jun 2020 14:14:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732042AbgF3MOp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 30 Jun 2020 08:14:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732120AbgF3MOo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 30 Jun 2020 08:14:44 -0400
Received: from mail-pf1-x44a.google.com (mail-pf1-x44a.google.com [IPv6:2607:f8b0:4864:20::44a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9801C03E97A
        for <linux-fscrypt@vger.kernel.org>; Tue, 30 Jun 2020 05:14:43 -0700 (PDT)
Received: by mail-pf1-x44a.google.com with SMTP id e80so656567pfh.13
        for <linux-fscrypt@vger.kernel.org>; Tue, 30 Jun 2020 05:14:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=lhA0BWoSWsBTuwKzKn01wZo9Oy70PMD7N1A7rW96zZc=;
        b=Yf2T2rzyob0oJjaxt0VAVSVU7RtyTQTloLFyysxD+7tOEox6O0w6u6uNVA7lVNprXh
         SQQYFdez1F5TGZVN4lSw4TnqPYpciAIRvTUsntD9m7woLfjh43R7PrVWe2Qtbf60l4Xs
         SJ7gFsGfV11H8cDRSoAR2jf0eQIlCwuSeQTWZWFiSpmcBtkkIzKff6UE+YIybzU+Zsbo
         qF3e2oYLtOqsCNLFkm9IZA745dR9XvYldgqBK69sUEtf/7haBMalAiiZJQSbFa+HYoQX
         /f2sZu89aEa8LzaztOQMCuLcYLWd7YvscLhYTKJhE7qSLXK8gMKVvbjlSWjnw/rXjQ05
         hPtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=lhA0BWoSWsBTuwKzKn01wZo9Oy70PMD7N1A7rW96zZc=;
        b=O5YkFNq1+OaXB2SjodwfCFk2L7HJuZArMe15emi3AvP5GTUs+ELWBeDSh87iRqmKUH
         a0QQ6rbyF/pONLmgcJ+dJmM2t8DJZtYz2LLzExlYBQgAT8K+qw3dIOx+rE7WEldNzFBX
         LIlOuBUONA66EH7qoko2zJKl+wS/Kvn3s/4LXMSIFzoWfvKwcM/LE65fM2iiw0bBVONo
         2Ha5DuMM+A+Y4TQMXyGNZd/aVHqE0/Lcm9sqW8VqHQ0E1339rye9+dtZRAqAMbSuaC+z
         mXWCMO67DdEQw9kANFf51WwqstTR+U0tmbmLmlpR6Mk7wecMOkApDzk1/JlRdkoT+w/s
         351A==
X-Gm-Message-State: AOAM532y/FlkMqRABSqTbUBADApJgQTT/zP2FvsWOCOdzuGhA9HIDkAD
        vOqV6igcL75I7+S8mHtbNaGj5z3xyrI5HIo4amhfBDkv85AUF3Dviv/QNyCCfTWFAaZztmPIH8p
        OJPIt+nm/1BEK0g3UtTltSUeu1q96fyMXWyEvEDgBiPJqSLeAHKq8w/2cnMfNI1GHse5L0xo=
X-Google-Smtp-Source: ABdhPJwAHOyLt+3kT7UZQ7QETmF2sx1NwYFgJgFhaQoJiYfMqjNMWPplC+KCJoZ+BYN22obKmbu7zEAVADQ=
X-Received: by 2002:a17:90a:d30c:: with SMTP id p12mr739331pju.4.1593519283036;
 Tue, 30 Jun 2020 05:14:43 -0700 (PDT)
Date:   Tue, 30 Jun 2020 12:14:34 +0000
Message-Id: <20200630121438.891320-1-satyat@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.27.0.212.ge8ba1cc988-goog
Subject: [PATCH v3 0/4] Inline Encryption Support for fscrypt
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

Changes v2 => v3
 - Fix issue with inline encryption + IV_INO_LBLK_32 policy found by Eric
 - minor cleanup

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

 Documentation/admin-guide/ext4.rst    |   7 +
 Documentation/filesystems/f2fs.rst    |   7 +
 Documentation/filesystems/fscrypt.rst |   3 +
 fs/buffer.c                           |   7 +-
 fs/crypto/Kconfig                     |   6 +
 fs/crypto/Makefile                    |   1 +
 fs/crypto/bio.c                       |  51 ++++
 fs/crypto/crypto.c                    |   2 +-
 fs/crypto/fname.c                     |   4 +-
 fs/crypto/fscrypt_private.h           | 115 +++++++-
 fs/crypto/inline_crypt.c              | 364 ++++++++++++++++++++++++++
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
 23 files changed, 819 insertions(+), 71 deletions(-)
 create mode 100644 fs/crypto/inline_crypt.c

-- 
2.27.0.212.ge8ba1cc988-goog

