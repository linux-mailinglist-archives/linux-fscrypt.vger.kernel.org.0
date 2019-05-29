Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 43D052E670
	for <lists+linux-fscrypt@lfdr.de>; Wed, 29 May 2019 22:47:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726438AbfE2Ur5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 29 May 2019 16:47:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:34604 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726139AbfE2Ur5 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 29 May 2019 16:47:57 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4B60E2419D;
        Wed, 29 May 2019 20:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559162876;
        bh=/h0YRele2HgHkOZgeVioQRed572yyLTKQ40p6fvDYw8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Lb1DvaJJHbk0WgcihUPP6WKeOKiLCST6LBMU309vMD6yXyT/o/4JTHPxrFxkTU9EO
         NSM/ONxEZ81Yu4WnG7Vh6YfH08T4wiXKKCHwNySkJGtxqZE5k4Ys/uctQ+Tlzg3Jug
         K6XB6SwDdiK2V2HU79sMV/UvG7D8wgagV6puSOcg=
Date:   Wed, 29 May 2019 13:47:54 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-mtd@lists.infradead.org,
        Chandan Rajendra <chandan@linux.ibm.com>,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH v2 00/14] fscrypt, ext4: prepare for blocksize !=
 PAGE_SIZE
Message-ID: <20190529204753.GB141639@gmail.com>
References: <20190520162952.156212-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190520162952.156212-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, May 20, 2019 at 09:29:38AM -0700, Eric Biggers wrote:
> Hello,
> 
> This patchset prepares fs/crypto/, and partially ext4, for the
> 'blocksize != PAGE_SIZE' case.
> 
> This basically contains the encryption changes from Chandan Rajendra's
> patchset "[V2,00/13] Consolidate FS read I/O callbacks code"
> (https://patchwork.kernel.org/project/linux-fscrypt/list/?series=111039)
> that don't require introducing the read_callbacks and don't depend on
> fsverity stuff.  But they've been reworked to clean things up a lot.
> 
> I'd like to apply this patchset for 5.3 in order to make things forward
> for ext4 encryption with 'blocksize != PAGE_SIZE'.
> 
> AFAICT, after this patchset the only thing stopping ext4 encryption from
> working with blocksize != PAGE_SIZE is the lack of encryption support in
> block_read_full_page(), which the read_callbacks will address.
> 
> This patchset applies to v5.2-rc1, and it can also be retrieved from git
> at https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
> branch "fscrypt-subpage-blocks-prep".
> 
> Changed since v1 (minor cleanups only):
> 
> - In "fscrypt: simplify bounce page handling", also remove
>   the definition of FS_CTX_HAS_BOUNCE_BUFFER_FL.
> 
> - In "ext4: decrypt only the needed blocks in ext4_block_write_begin()",
>   simplify the code slightly by moving the IS_ENCRYPTED() check.
> 
> - Change __fscrypt_decrypt_bio() in a separate patch rather than as part
>   of "fscrypt: support decrypting multiple filesystem blocks per page".
>   The resulting code is the same, so I kept Chandan's Reviewed-by.
> 
> - Improve the commit message of
>   "fscrypt: introduce fscrypt_decrypt_block_inplace()".
> 
> Chandan Rajendra (3):
>   ext4: clear BH_Uptodate flag on decryption error
>   ext4: decrypt only the needed blocks in ext4_block_write_begin()
>   ext4: decrypt only the needed block in __ext4_block_zero_page_range()
> 
> Eric Biggers (11):
>   fscrypt: simplify bounce page handling
>   fscrypt: remove the "write" part of struct fscrypt_ctx
>   fscrypt: rename fscrypt_do_page_crypto() to fscrypt_crypt_block()
>   fscrypt: clean up some BUG_ON()s in block encryption/decryption
>   fscrypt: introduce fscrypt_encrypt_block_inplace()
>   fscrypt: support encrypting multiple filesystem blocks per page
>   fscrypt: handle blocksize < PAGE_SIZE in fscrypt_zeroout_range()
>   fscrypt: introduce fscrypt_decrypt_block_inplace()
>   fscrypt: support decrypting multiple filesystem blocks per page
>   fscrypt: decrypt only the needed blocks in __fscrypt_decrypt_bio()
>   ext4: encrypt only up to last block in ext4_bio_write_page()
> 
>  fs/crypto/bio.c             |  73 +++------
>  fs/crypto/crypto.c          | 299 ++++++++++++++++++++----------------
>  fs/crypto/fscrypt_private.h |  15 +-
>  fs/ext4/inode.c             |  37 +++--
>  fs/ext4/page-io.c           |  44 +++---
>  fs/f2fs/data.c              |  17 +-
>  fs/ubifs/crypto.c           |  19 +--
>  include/linux/fscrypt.h     |  96 ++++++++----
>  8 files changed, 319 insertions(+), 281 deletions(-)
> 

I've applied this series to fscrypt.git for 5.3.

- Eric
