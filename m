Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 52D7C308EDC
	for <lists+linux-fscrypt@lfdr.de>; Fri, 29 Jan 2021 21:58:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232727AbhA2U5r (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 29 Jan 2021 15:57:47 -0500
Received: from mail.kernel.org ([198.145.29.99]:46618 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232344AbhA2U5q (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 29 Jan 2021 15:57:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id AC2DE64E05;
        Fri, 29 Jan 2021 20:57:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611953822;
        bh=v9S6wHwtGdGrrwTyPE1Do5RofOqY+qRTh/Bh20GJ1qc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=V3ZsmdujUmQ9dzuY5Q398/k/yoryMqYl8BmcTGLLS8loaaJg0D/A1osCjaItn0KPd
         XSxEaZWndZTL4bd4FJKbKBLOiw2dfXxmMGkdNYxVyu344ooqhiMgr6wdbSdu3ESZ7O
         0rOwZ1OUQEN8q/S66kpCLu9dB52Yw7Mh0yX8QHbRCRvGXHWQjeSVBkbJTjVyGgvWRf
         t4i+2qn8G97qnHtaWylwAWAUqVUbQWc88HlA0ziRuLrCCOjlBf2vS39CbH5+j0bygh
         K3S+worwg8AD+NAoPRiTNxgdHnRNCeT6YbcaRUVnhKJRh5oWVB3MJ/ygyXFwR6vzeW
         p5+T1Lr4s6oOA==
Date:   Fri, 29 Jan 2021 12:57:00 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Subject: Re: [PATCH v2 3/3] f2fs: Add metadata encryption support
Message-ID: <YBR2nGbrYeWW219s@sol.localdomain>
References: <20201217150435.1505269-1-satyat@google.com>
 <20201217150435.1505269-4-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201217150435.1505269-4-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 17, 2020 at 03:04:35PM +0000, Satya Tangirala wrote:
> Wire up metadata encryption support with the fscrypt metadata crypt
> additions. Note that this feature relies on the blk-crypto framework
> for encryption, and thus requires either hardware inline encryption
> support or the blk-crypto-fallback.
> 
> Filesystems can be configured with metadata encryption support using the
> f2fs userspace tools (mkfs.f2fs). Once formatted, F2FS filesystems with
> metadata encryption can be mounted as long as the required key is present.
> fscrypt looks for a logon key with the key descriptor=
> fscrypt:<metadata_key_identifier>. The metadata_key_identifier is stored in
> the filesystem superblock (and the userspace tools print the required
> key descriptor).
> 
> Right now, the superblock of the filesystem is itself not encrypted. F2FS
> reads the superblock using sb_bread, which uses the bd_inode of the block
> device as the address space for any data it reads from the block device -
> the data read under the bd_inode address space must be what is physically
> present on disk (i.e. if the superblock is encrypted, then the ciphertext
> of the superblock must be present in the page cache in the bd_inode's
> address space), but f2fs requires that the superblock is decrypted by
> blk-crypto, which would put the decrypted page contents into the page cache
> instead. We could make f2fs read the superblock by submitting bios directly
> with a separate address space, but we choose to just not encrypt the
> superblock for now.
> 
> Not encrypting the superblock allows us to store the encryption algorithm
> used for metadata encryption within the superblock itself, which simplifies
> a few things. The userspace tools will store the encryption algorithm in
> the superblock when formatting the FS.

The explanation about why the superblock isn't encrypted seems a bit backwards.
It makes it sound like this decision was mainly an accident because of how f2fs
is currently implemented.  But actually we need to leave the superblock
unencrypted anyway in order to keep the filesystem type and metadata encryption
options readable from disk, so that the filesystem can be mounted without
knowing the filesystem type and encryption options ahead of time -- right?
I.e. would anything actually be different if it was super easy to encrypt the
superblock in the kernel?

> 
> +	/* Check if FS has metadata encryption if kernel doesn't support it */
> +#ifndef CONFIG_FS_ENCRYPTION_METADATA
> +	if (raw_super->metadata_crypt_alg) {
> +		f2fs_err(sbi, "Filesystem has metadata encryption but kernel support for it wasn't enabled");
> +		return -EINVAL;
> +	}
> +#endif

This can use !IS_ENABLED(CONFIG_FS_ENCRYPTION_METADATA).

> +	if (fscrypt_metadata_crypted(sb)) {
> +		f2fs_notice(sbi, "Mounted with metadata key identifier = %s%*phN",
> +			    FSCRYPT_KEY_DESC_PREFIX,
> +			    FSCRYPT_KEY_IDENTIFIER_SIZE,
> +			    sbi->raw_super->metadata_crypt_key_ident);
> +	}

Should this show the encryption algorithm too?  Maybe:

"Metadata encryption enabled; algorithm=%s, key_identifier=%*phN"

Note that showing the "fscrypt:" key description prefix doesn't really add
anything, so I recommend leaving it out.

> +	/* The metadata encryption algorithm (FSCRYPT_MODE_*) */

... or 0 if none.

> +	__le32 metadata_crypt_alg;

> +	/* The metadata encryption key identifier */
> +	__u8 metadata_crypt_key_ident[FSCRYPT_KEY_IDENTIFIER_SIZE];

... (if metadata_crypt_alg != 0)

- Eric
