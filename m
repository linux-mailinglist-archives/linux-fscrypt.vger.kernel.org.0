Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BFAB250A47
	for <lists+linux-fscrypt@lfdr.de>; Mon, 24 Aug 2020 22:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726867AbgHXUtP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 24 Aug 2020 16:49:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38656 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHXUtP (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 24 Aug 2020 16:49:15 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 195B02067C;
        Mon, 24 Aug 2020 20:49:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598302154;
        bh=PDF5FB3f/iX6KmB9XrlWFrnk42OQsjSRBtJ1FLkbKmk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jUh/EXYBZSsJDdmVjLNI9Ide1YTidVvRvP57Wf4SyWXTEaa/Oq3Sun1fEYKw2zPbo
         aKCpyYiHp520+hjmEuKybQsRGqMfFfEWdJnjuX5r1U5Kobvoccm1Wqv2sA2JRBKfsY
         /d8CDZHgd3G1/Lq1Dw0aWx5EI4uNe9CYC6tcvDpQ=
Date:   Mon, 24 Aug 2020 13:49:12 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-mtd@lists.infradead.org, ceph-devel@vger.kernel.org
Subject: Re: [RFC PATCH 1/8] fscrypt: add fscrypt_prepare_new_inode() and
 fscrypt_set_context()
Message-ID: <20200824204912.GD1650861@gmail.com>
References: <20200824061712.195654-1-ebiggers@kernel.org>
 <20200824061712.195654-2-ebiggers@kernel.org>
 <0cf5638796e7cddacc38dcd1e967368b99f0069a.camel@kernel.org>
 <20200824182114.GB1650861@gmail.com>
 <06a7d9562b84354eb72bd67c9d4b7262dac53457.camel@kernel.org>
 <20200824190221.GC1650861@gmail.com>
 <fe81c713ed827b91004b0e2838800684da33e60c.camel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fe81c713ed827b91004b0e2838800684da33e60c.camel@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 24, 2020 at 03:42:59PM -0400, Jeff Layton wrote:
> On Mon, 2020-08-24 at 12:02 -0700, Eric Biggers wrote:
> > On Mon, Aug 24, 2020 at 02:47:07PM -0400, Jeff Layton wrote:
> > > On Mon, 2020-08-24 at 11:21 -0700, Eric Biggers wrote:
> > > > On Mon, Aug 24, 2020 at 12:48:48PM -0400, Jeff Layton wrote:
> > > > > > +void fscrypt_hash_inode_number(struct fscrypt_info *ci,
> > > > > > +			       const struct fscrypt_master_key *mk)
> > > > > > +{
> > > > > > +	WARN_ON(ci->ci_inode->i_ino == 0);
> > > > > > +	WARN_ON(!mk->mk_ino_hash_key_initialized);
> > > > > > +
> > > > > > +	ci->ci_hashed_ino = (u32)siphash_1u64(ci->ci_inode->i_ino,
> > > > > > +					      &mk->mk_ino_hash_key);
> > > > > 
> > > > > i_ino is an unsigned long. Will this produce a consistent results on
> > > > > arches with 32 and 64 bit long values? I think it'd be nice to ensure
> > > > > that we can access an encrypted directory created on a 32-bit host from
> > > > > (e.g.) a 64-bit host.
> > > > 
> > > > The result is the same regardless of word size and endianness.
> > > > siphash_1u64(v, k) is equivalent to:
> > > > 
> > > > 	__le64 x = cpu_to_le64(v);
> > > > 	siphash(&x, 8, k);
> > > > 
> > > 
> > > In the case where you have an (on-storage) inode number that is larger
> > > than 2^32, x will almost certainly be different on a 32 vs. 64-bit
> > > wordsize.
> > > 
> > > On the box with the 32-bit wordsize, you'll end up promoting i_ino to a
> > > 64-bit word and the upper 32 bits will be zeroed out. So it seems like
> > > this means that if you're using inline hardware you're going to end up
> > > with a result that won't work correctly across different wordsizes.
> > 
> > That's only possible if the VFS is truncating the inode number, which would also
> > break userspace in lots of ways like making applications think that files are
> > hard-linked together when they aren't.  Also, IV_INO_LBLK_64 would break.
> > 
> > The correct fix for that would be to make inode::i_ino 64-bit.
> > 
> 
> ...or just ask the filesystem for the 64-bit inode number via ->getattr
> or a new op. You could also just truncate it down to 32 bits or xor the
> top and bottom bits together first, etc...
> 
> > Note that ext4 and f2fs (currently the only filesystems that support the
> > IV_INO_LBLK_* flags) only support 32-bit inode numbers.
> > 
> 
> Ahh, ok. That explains why it's not been an issue so far. Still, if
> you're reworking this code anyway, you might want to consider avoiding
> i_ino here.

Let's just enforce ino_bits <= 32 for IV_INO_LBLK_32 for now,
like is done for IV_INO_LBLK_64:
https://lkml.kernel.org/r/20200824203841.1707847-1-ebiggers@kernel.org

There's no need to add extra complexity for something that no one wants yet.

(And as mentioned, this won't prevent ceph or other filesystems with 64-bit
inode numbers from adding support for fscrypt, as IV_INO_LBLK_32 support is
optional and has a pretty specific use case.)

- Eric
