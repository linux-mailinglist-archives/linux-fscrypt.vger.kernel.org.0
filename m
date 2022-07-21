Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7B37857C4AA
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Jul 2022 08:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231543AbiGUGtO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Jul 2022 02:49:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229653AbiGUGtN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Jul 2022 02:49:13 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0927C64E0F;
        Wed, 20 Jul 2022 23:49:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8C907B82295;
        Thu, 21 Jul 2022 06:49:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A8797C341C0;
        Thu, 21 Jul 2022 06:49:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658386148;
        bh=sbmjTOZdbfb61pYAqfcLf+gQecjJoeuOtog/94c9WAQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YDdWNRHpsIpTaPx3DZlCey3vUfICJaSq9DGk4gXqMe/0+XUnxkkXV12IFa2DeTMWA
         DhkCzN6gnAMLw7SQxNWdpb+eEH944oCYePUzeSwUOVzId2JNMx50o4/yvaMthwpm31
         Yr+J3Tif63xyplnis8DWqUvny3lr6pBlJwpmTP8g71sWE0pzFk2GOND/fOeppppXNJ
         aOQv69W1jQaMeD82D4tsMgxa2Cxiu2B6QhXTqJ1uyvy+kPTrRwJ67eKMulvoHKtaZH
         P/bF//9yKQBix7zIs5v9t9BI0w6ICrPKFPgL89fuEWCbOY2XMN7eRRvLQujK0HeH+b
         O1kpjj+kbGgjQ==
Date:   Wed, 20 Jul 2022 23:49:07 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Israel Rukshin <israelr@nvidia.com>
Cc:     Linux-block <linux-block@vger.kernel.org>,
        Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
        Nitzan Carmi <nitzanc@nvidia.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 1/1] block: Add support for setting inline encryption key
 per block device
Message-ID: <Ytj249InQTKdFshA@sol.localdomain>
References: <1658316391-13472-1-git-send-email-israelr@nvidia.com>
 <1658316391-13472-2-git-send-email-israelr@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1658316391-13472-2-git-send-email-israelr@nvidia.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Israel,

On Wed, Jul 20, 2022 at 02:26:31PM +0300, Israel Rukshin wrote:
> Until now, using inline encryption key has been possible only at
> filesystem level via fs-crypt. The patch allows to set a default
> inline encryption key per block device. Once the key is set, all the
> read commands will be decrypted, and all the write commands will
> be encrypted. The key can be overridden by another key from a higher
> level (FS/DM).
> 
> To add/remove a key, the patch introduces a block device ioctl:
>  - BLKCRYPTOSETKEY: set a key with the following attributes:
>     - crypto_mode: identifier for the encryption algorithm to use
>     - raw_key_ptr:  pointer to a buffer of the raw key
>     - raw_key_size: size in bytes of the raw key
>     - data_unit_size: the data unit size to use for en/decryption
>       (must be <= device logical block size)
> To remove the key, use the same ioctl with raw_key_size = 0.
> It is not possible to remove the key when it is in use by any
> in-flight IO or when the block device is open.
> 
> Signed-off-by: Israel Rukshin <israelr@nvidia.com>

Thanks for sending this out.  I've added dm-devel@redhat.com to Cc, as I think
the device-mapper developers need to be aware of this.  I also added
linux-fscrypt@vger.kernel.org, as this is relevant there too.

I'm glad to see a proposal in this area -- this is something that is greatly
needed.  Chrome OS is looking for something like "dm-crypt with inline crypto
support", which this should work for.  Android is also looking for something
similar with the additional property that filesystems can override the key used.

Some high-level comments about this approach (I'll send some more routine code
review nits in a separate email):

> @@ -134,7 +150,8 @@ static inline void bio_crypt_do_front_merge(struct request *rq,
>  bool __blk_crypto_bio_prep(struct bio **bio_ptr);
>  static inline bool blk_crypto_bio_prep(struct bio **bio_ptr)
>  {
> -	if (bio_has_crypt_ctx(*bio_ptr))
> +	if (bio_has_crypt_ctx(*bio_ptr) ||
> +	    blk_crypto_bio_set_default_ctx(*bio_ptr))
>  		return __blk_crypto_bio_prep(bio_ptr);
>  	return true;

This allows upper layers to override the block device key, which as I've
mentioned is very useful -- it allows block device encryption and file
encryption to be used together without the performance cost of double
encryption.  Android already needs and uses this type of encryption.

Still, it's important to understand the limitations of this particular way to
achieve this type of encryption, since I want to make sure everyone is on board.


First, this implementation currently doesn't provide a way to skip the default
key without setting an encryption context.  There are actually two cases where
the default key must be skipped when there is no encryption context.  The first
is when the filesystem is doing I/O to an encrypted file, but the filesystem
wasn't mounted with the "inlinecrypt" mount option.  This could be worked around
by requiring "inlinecrypt" if a default key is set; that loses some flexibility,
but it could be done.  The second case, which can't be worked around at the
filesystem level, is that the f2fs garbage collector sometimes has to move the
data of encrypted files on-disk without having access to their encryption key.

So we'll actually need a separate indicator for "skip the default key".  The
simplest solution would be a new flag in the bio.  However, to avoid using space
in struct bio, it could instead be a special value of the encryption context.


Second, both this solution and dm-based solutions have the property that they
allow the default key to be *arbitrarily* overridden by upper layers.  That
means that there is no *general* guarantee that all data on the device is
protected at least as well as the default key.  Consider e.g. the default key
being overridden by an all-zeros key.  Concerns about this sort of architecture
were raised on a dm-crypt patchset several years ago; see
https://lore.kernel.org/r/0b268ff7-5fc8-c85f-a530-82e9844f0400@gmail.com and
https://lore.kernel.org/r/20170616125511.GA11824@yeono.kjorling.se.

The alternative architecture for this that I've had in mind, and which has been
prototyped for f2fs
(https://lore.kernel.org/linux-f2fs-devel/20201005073606.1949772-1-satyat@google.com/T/#u),
is for the filesystem to manage *all* the encryption, and to mix the default key
into all file keys.  Then, all data on the block device would always be
protected by the default key or better, regardless of userspace.

On the other hand, I'd personally be fine with saying that this isn't actually
needed, i.e. that allowing arbitrary overriding of the default key is fine,
since userspace should just set up the keys properly.  For example, Android
doesn't need this at all, as it sets up all its keys properly.  But I want to
make sure that everyone is generally okay with this now, as I personally don't
see a fundamental difference between this and what the dm-crypt developers had
rejected *very* forcefully before.  Perhaps it's acceptable now simply because
it wouldn't be part of dm-crypt; it's a new thing, so it can have new semantics.

> +static int blk_crypto_ioctl_create_key(struct request_queue *q,
> +				       void __user *argp)
> +{
> +	struct blk_crypto_set_key_arg arg;
> +	u8 raw_key[BLK_CRYPTO_MAX_KEY_SIZE];
> +	struct blk_crypto_key *blk_key;
> +	int ret;
> +
> +	if (copy_from_user(&arg, argp, sizeof(arg)))
> +		return -EFAULT;
> +
> +	if (memchr_inv(arg.reserved, 0, sizeof(arg.reserved)))
> +		return -EINVAL;
> +
> +	if (!arg.raw_key_size)
> +		return blk_crypto_destroy_default_key(q);
> +
> +	if (q->blk_key) {
> +		pr_err("Crypto key is already configured\n");
> +		return -EBUSY;
> +	}
> +
> +	if (arg.raw_key_size > sizeof(raw_key))
> +		return -EINVAL;
> +
> +	if (arg.data_unit_size > queue_logical_block_size(q)) {
> +		pr_err("Data unit size is bigger than logical block size\n");
> +		return -EINVAL;
> +	}

This is forbidding data_unit_size greater than logical_block_size.  I see why
you did this: the block layer doesn't know what is above it, and it could
receive I/O requests targeting individual logical blocks.  However, this can
result in a big efficiency loss; a common example is when a filesystem with a
4096-byte block size is used on a block device with a logical block size of 512
bytes.  Since such a filesystem only submits I/O in 4096-byte blocks, it's safe
for the data_unit_size to be 4096 bytes as well.  This is much more efficient
than 512 bytes, since there is overhead for every data unit.  Note that some of
this overhead is intrinsic in the crypto algorithms themselves and cannot be
optimized out by better hardware.

The device-mapper based solution wouldn't have this problem, as the
device-mapper target (dm-inlinecrypt or whatever) would just advertise the
crypto data unit size as the logical block size, like dm-crypt does.

I'm wondering if anyone any thoughts about how to allow data_unit_size >
logical_block_size with this patch's approach.  I suppose that the ioctl could
just allow setting it, and the block layer could fail any I/O that isn't
properly aligned to the data_unit_size.

- Eric
