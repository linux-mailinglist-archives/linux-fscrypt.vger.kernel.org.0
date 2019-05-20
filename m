Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A47AD23D40
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 May 2019 18:30:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389226AbfETQaW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 May 2019 12:30:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:44866 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730795AbfETQaV (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 May 2019 12:30:21 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0C1620815;
        Mon, 20 May 2019 16:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1558369821;
        bh=qgPdUJE/0daEUKkRjmiTlZG0dOGdMLxQxjTzXSw4Rv0=;
        h=From:To:Cc:Subject:Date:From;
        b=O2IH3/wClCcNtvPWFoheNIncMp0iBWfW5iJnR9rn/U9EpHAQ4yYvG79uvBTdU2mdy
         q/0lti2ZK9imVN7kY95KpTwbcixNKBcWoxdHh42Irdd7nmogh191csqMvoScQhkhIQ
         qdNLPAoXphJvOpr/ts88DJe7IQNk+40IxVhYw594=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org,
        Chandan Rajendra <chandan@linux.ibm.com>
Subject: [PATCH v2 00/14] fscrypt, ext4: prepare for blocksize != PAGE_SIZE
Date:   Mon, 20 May 2019 09:29:38 -0700
Message-Id: <20190520162952.156212-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.21.0.1020.gf2820cf01a-goog
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

This patchset prepares fs/crypto/, and partially ext4, for the
'blocksize != PAGE_SIZE' case.

This basically contains the encryption changes from Chandan Rajendra's
patchset "[V2,00/13] Consolidate FS read I/O callbacks code"
(https://patchwork.kernel.org/project/linux-fscrypt/list/?series=111039)
that don't require introducing the read_callbacks and don't depend on
fsverity stuff.  But they've been reworked to clean things up a lot.

I'd like to apply this patchset for 5.3 in order to make things forward
for ext4 encryption with 'blocksize != PAGE_SIZE'.

AFAICT, after this patchset the only thing stopping ext4 encryption from
working with blocksize != PAGE_SIZE is the lack of encryption support in
block_read_full_page(), which the read_callbacks will address.

This patchset applies to v5.2-rc1, and it can also be retrieved from git
at https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
branch "fscrypt-subpage-blocks-prep".

Changed since v1 (minor cleanups only):

- In "fscrypt: simplify bounce page handling", also remove
  the definition of FS_CTX_HAS_BOUNCE_BUFFER_FL.

- In "ext4: decrypt only the needed blocks in ext4_block_write_begin()",
  simplify the code slightly by moving the IS_ENCRYPTED() check.

- Change __fscrypt_decrypt_bio() in a separate patch rather than as part
  of "fscrypt: support decrypting multiple filesystem blocks per page".
  The resulting code is the same, so I kept Chandan's Reviewed-by.

- Improve the commit message of
  "fscrypt: introduce fscrypt_decrypt_block_inplace()".

Chandan Rajendra (3):
  ext4: clear BH_Uptodate flag on decryption error
  ext4: decrypt only the needed blocks in ext4_block_write_begin()
  ext4: decrypt only the needed block in __ext4_block_zero_page_range()

Eric Biggers (11):
  fscrypt: simplify bounce page handling
  fscrypt: remove the "write" part of struct fscrypt_ctx
  fscrypt: rename fscrypt_do_page_crypto() to fscrypt_crypt_block()
  fscrypt: clean up some BUG_ON()s in block encryption/decryption
  fscrypt: introduce fscrypt_encrypt_block_inplace()
  fscrypt: support encrypting multiple filesystem blocks per page
  fscrypt: handle blocksize < PAGE_SIZE in fscrypt_zeroout_range()
  fscrypt: introduce fscrypt_decrypt_block_inplace()
  fscrypt: support decrypting multiple filesystem blocks per page
  fscrypt: decrypt only the needed blocks in __fscrypt_decrypt_bio()
  ext4: encrypt only up to last block in ext4_bio_write_page()

 fs/crypto/bio.c             |  73 +++------
 fs/crypto/crypto.c          | 299 ++++++++++++++++++++----------------
 fs/crypto/fscrypt_private.h |  15 +-
 fs/ext4/inode.c             |  37 +++--
 fs/ext4/page-io.c           |  44 +++---
 fs/f2fs/data.c              |  17 +-
 fs/ubifs/crypto.c           |  19 +--
 include/linux/fscrypt.h     |  96 ++++++++----
 8 files changed, 319 insertions(+), 281 deletions(-)

-- 
2.21.0.1020.gf2820cf01a-goog

