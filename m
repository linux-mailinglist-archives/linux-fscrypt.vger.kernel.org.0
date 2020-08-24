Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 73355250868
	for <lists+linux-fscrypt@lfdr.de>; Mon, 24 Aug 2020 20:47:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726435AbgHXSrJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 24 Aug 2020 14:47:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:49126 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725904AbgHXSrJ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 24 Aug 2020 14:47:09 -0400
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net [68.20.15.154])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3950E2065F;
        Mon, 24 Aug 2020 18:47:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598294828;
        bh=Q7rmqcK2cO9kRc9mX2R6752q1QKh7uDgYP8Nhp7kyZI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=jW/d0Pp4ABd3WvH2jRkyX22o8nNqFLAVEM/VSskJLw2gvHHnZXrjOHSDgr3mVdwG0
         dV4128xFP6onTskk79j4bPFBm6QXO20H6zHsikIukfmpAWaXp/Gm48/7ic85qV5ZZQ
         GftdbOJTX3YHxf3lfJum6XjMMK0spCkkUxBerdlE=
Message-ID: <06a7d9562b84354eb72bd67c9d4b7262dac53457.camel@kernel.org>
Subject: Re: [RFC PATCH 1/8] fscrypt: add fscrypt_prepare_new_inode() and
 fscrypt_set_context()
From:   Jeff Layton <jlayton@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org
Date:   Mon, 24 Aug 2020 14:47:07 -0400
In-Reply-To: <20200824182114.GB1650861@gmail.com>
References: <20200824061712.195654-1-ebiggers@kernel.org>
         <20200824061712.195654-2-ebiggers@kernel.org>
         <0cf5638796e7cddacc38dcd1e967368b99f0069a.camel@kernel.org>
         <20200824182114.GB1650861@gmail.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5 (3.36.5-1.fc32) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2020-08-24 at 11:21 -0700, Eric Biggers wrote:
> On Mon, Aug 24, 2020 at 12:48:48PM -0400, Jeff Layton wrote:
> > > +void fscrypt_hash_inode_number(struct fscrypt_info *ci,
> > > +			       const struct fscrypt_master_key *mk)
> > > +{
> > > +	WARN_ON(ci->ci_inode->i_ino == 0);
> > > +	WARN_ON(!mk->mk_ino_hash_key_initialized);
> > > +
> > > +	ci->ci_hashed_ino = (u32)siphash_1u64(ci->ci_inode->i_ino,
> > > +					      &mk->mk_ino_hash_key);
> > 
> > i_ino is an unsigned long. Will this produce a consistent results on
> > arches with 32 and 64 bit long values? I think it'd be nice to ensure
> > that we can access an encrypted directory created on a 32-bit host from
> > (e.g.) a 64-bit host.
> 
> The result is the same regardless of word size and endianness.
> siphash_1u64(v, k) is equivalent to:
> 
> 	__le64 x = cpu_to_le64(v);
> 	siphash(&x, 8, k);
> 

In the case where you have an (on-storage) inode number that is larger
than 2^32, x will almost certainly be different on a 32 vs. 64-bit
wordsize.

On the box with the 32-bit wordsize, you'll end up promoting i_ino to a
64-bit word and the upper 32 bits will be zeroed out. So it seems like
this means that if you're using inline hardware you're going to end up
with a result that won't work correctly across different wordsizes.

Maybe that's ok, but it seems like something that could be handled by
hashing a different value.

> > It may be better to base this on something besides i_ino
> 
> This code that hashes the inode number is only used when userspace used
> FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32 for the directory.  IV_INO_LBLK_32 modifies
> the encryption to be optimized for eMMC inline encryption hardware.  For more
> details, see commit e3b1078bedd3 which added this feature.
> 
> We actually could have hashed the file nonce instead of the inode number.  But I
> wanted to make the eMMC-optimized format similar to IV_INO_LBLK_64, which is the
> format optimized for UFS inline encryption hardware.
> 
> Both of these flags have very specific use cases; they make it feasible to use
> inline encryption hardware
> (https://www.kernel.org/doc/html/latest/block/inline-encryption.html)
> that only supports a small number of keyslots and that limits the IV length.
> 
> You don't need to worry about these flags at all for ceph, since there won't be
> any use case to use them on ceph, and ceph won't be declaring support for them.

Ahh, good to know. Thanks!
-- 
Jeff Layton <jlayton@kernel.org>

