Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CA1F728A4FB
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Oct 2020 04:05:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728687AbgJKCFS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 10 Oct 2020 22:05:18 -0400
Received: from szxga07-in.huawei.com ([45.249.212.35]:40424 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726473AbgJKCFR (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 10 Oct 2020 22:05:17 -0400
Received: from DGGEMS405-HUB.china.huawei.com (unknown [172.30.72.59])
        by Forcepoint Email with ESMTP id 2FE562A869CF12B54854;
        Sat, 10 Oct 2020 17:53:12 +0800 (CST)
Received: from [10.136.114.67] (10.136.114.67) by smtp.huawei.com
 (10.3.19.205) with Microsoft SMTP Server (TLS) id 14.3.487.0; Sat, 10 Oct
 2020 17:53:07 +0800
Subject: Re: [PATCH 0/3] add support for metadata encryption to F2FS
To:     Satya Tangirala <satyat@google.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>
CC:     <linux-kernel@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>,
        <linux-f2fs-devel@lists.sourceforge.net>
References: <20201005073606.1949772-1-satyat@google.com>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <471e0eb7-b035-03da-3ee3-35d5880a6748@huawei.com>
Date:   Sat, 10 Oct 2020 17:53:06 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20201005073606.1949772-1-satyat@google.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.136.114.67]
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2020/10/5 15:36, Satya Tangirala wrote:
> This patch series adds support for metadata encryption to F2FS using
> blk-crypto.

It looks this implementation is based on hardware crypto engine, could you
please add this info into f2fs.rst as well like inlinecrypt...

> 
> Patch 1 replaces fscrypt_get_devices (which took an array of request_queues
> and filled it up) with fscrypt_get_device, which takes a index of the
> desired device and returns the device at that index (so the index passed
> to fscrypt_get_device must be between 0 and (fscrypt_get_num_devices() - 1)
> inclusive). This allows callers to avoid having to allocate an array to
> pass to fscrypt_get_devices() when they only need to iterate through
> each element in the array (and have no use for the array itself).
> 
> Patch 2 introduces some functions to fscrypt that help filesystems perform
> metadata encryption. Any filesystem that wants to use metadata encryption
> can call fscrypt_setup_metadata_encryption() with the super_block of the
> filesystem, the encryption algorithm and the descriptor of the encryption
> key. The descriptor is looked up in the logon keyring of the current
> session with "fscrypt:" as the prefix of the descriptor.
> 
> The patch also introduces fscrypt_metadata_crypt_bio() which an FS should
> call on a bio that the FS wants metadata crypted. The function will add
> an encryption context with the metadata encryption key set up by the call
> to the above mentioned fscrypt_setup_metadata_encryption().
> 
> The patch also introduces fscrypt_metadata_crypt_prepare_all_devices().
> Filesystems that use multiple devices should call this function once all
> the underlying devices have been determined. An FS might only be able to
> determine all the underlying devices after some initial processing that
> might already require metadata en/decryption, which is why this function
> is separate from fscrypt_setup_metadata_encryption().
> 
> Patch 3 wires up F2FS with the functions introduced in Patch 2. F2FS
> will encrypt every block (that's not being encrypted by some other
> encryption key, e.g. a per-file key) with the metadata encryption key
> except the superblock (and the redundant copy of the superblock). The DUN
> of a block is the offset of the block from the start of the F2FS
> filesystem.

Why not using nid as DUN, then GC could migrate encrypted node block directly via
meta inode's address space like we do for encrypted data block, rather than
decrypting node block to node page and then encrypting node page with DUN of new
blkaddr it migrates to.

Thanks,

> 
> Please refer to the commit message for why the superblock was excluded from
> en/decryption, and other limitations. The superblock and its copy are
> stored in plaintext on disk. The encryption algorithm used for metadata
> encryption is stored within the superblock itself. Changes to the userspace
> tools (that are required to test out metadata encryption with F2FS) are
> also being sent out - I'll post a link as a reply to this mail once it's
> out.
> 
> Satya Tangirala (3):
>    fscrypt, f2fs: replace fscrypt_get_devices with fscrypt_get_device
>    fscrypt: Add metadata encryption support
>    f2fs: Add metadata encryption support
> 
>   Documentation/filesystems/f2fs.rst |  12 ++
>   fs/crypto/Kconfig                  |   6 +
>   fs/crypto/Makefile                 |   1 +
>   fs/crypto/fscrypt_private.h        |  19 +++
>   fs/crypto/inline_crypt.c           |  37 +----
>   fs/crypto/metadata_crypt.c         | 220 +++++++++++++++++++++++++++++
>   fs/f2fs/data.c                     |  24 ++--
>   fs/f2fs/f2fs.h                     |   2 +
>   fs/f2fs/super.c                    |  83 +++++++++--
>   include/linux/f2fs_fs.h            |   3 +-
>   include/linux/fs.h                 |   3 +
>   include/linux/fscrypt.h            |  51 ++++++-
>   12 files changed, 410 insertions(+), 51 deletions(-)
>   create mode 100644 fs/crypto/metadata_crypt.c
> 
