Return-Path: <linux-fscrypt+bounces-1014-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id BF4DFCB749C
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Dec 2025 23:19:48 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id BE3ED30006E1
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Dec 2025 22:19:45 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F150D2DCF70;
	Thu, 11 Dec 2025 22:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LTnbx4FL"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DCC2BEC5F;
	Thu, 11 Dec 2025 22:19:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765491583; cv=none; b=npVk4TQttjQT3UUW3kSkS3VeS9yhfx2qdjmCgZDA61IsXM4ujZv3TGMLJoziyebB2+HIzgLFp8qXOmBKJ5wpp6zTaxQptKV37+eLHRO/2XJfIUiNVHxwGjxGLCxBhXct68VeapN2vCD5cQfx/yML0bbMIhkmJnFnw86srMYNfI4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765491583; c=relaxed/simple;
	bh=UpmmJcVrARm3X1M3qpVksYhL/7KC8iP9jqjV1Qjfvgw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=AIIfpGxEUD0XY4h7o4xHWbAz3NQgvo/VzzpRSqq7wNkALEH3jfwVtz5yczAC7Tf+OvdtL2C4gnCCuX5CXsWEJiYgeYBvrOs47+JDSNDdjbijKjxB/JvL/9E/JuBNlt4o2JlLx4It44uisbjHqr6S5ZH6BzZsIiAvpq126xGWoeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LTnbx4FL; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C787C4CEF7;
	Thu, 11 Dec 2025 22:19:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765491583;
	bh=UpmmJcVrARm3X1M3qpVksYhL/7KC8iP9jqjV1Qjfvgw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=LTnbx4FL7nx0qo0Z2OZwr5rYVFDjJl217GcKUpqun6LdFgL1vwOOCGYD4zG4oCbOh
	 r1HGn+4IYVqc73OGD152ExD8TfQcqhWtCM4D3XEAn7wtBfGpXpfsZ8AdmAj+roBZBI
	 pD1cmYh9ME9pEmLaELQDefcl4RI3YoIwP8B5MwdjswLF2GJytgr62r/DDi6LdBcJzY
	 4CGwMEa3oAnVukfzT8/Y1kGByONBxWAIfWENHPP+OSnpM7ARiaGG7mVkpRfONfmtO0
	 qbOJGgSaKAkHGYhRKKnJfEKSmvja+s5EGMAIFNUckbb3udpL9FLc/TDheE8RQKZRT+
	 y2hAQfcqqBwDA==
Date: Thu, 11 Dec 2025 14:19:43 -0800
From: "Darrick J. Wong" <djwong@kernel.org>
To: Eric Biggers <ebiggers@kernel.org>
Cc: syzbot <syzbot+7add5c56bc2a14145d20@syzkaller.appspotmail.com>,
	davem@davemloft.net, herbert@gondor.apana.org.au,
	jaegeuk@kernel.org, linux-crypto@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzkaller-bugs@googlegroups.com,
	tytso@mit.edu, Neal Gompa <neal@gompa.dev>
Subject: Re: [syzbot] [ext4] [fscrypt] KMSAN: uninit-value in
 fscrypt_crypt_data_unit
Message-ID: <20251211221943.GN94594@frogsfrogsfrogs>
References: <68ee633c.050a0220.1186a4.002a.GAE@google.com>
 <69380321.050a0220.1ff09b.0000.GAE@google.com>
 <20251210022202.GB4128@sol>
 <20251211185215.GM94594@frogsfrogsfrogs>
 <20251211194502.GA1742838@google.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20251211194502.GA1742838@google.com>

On Thu, Dec 11, 2025 at 07:45:02PM +0000, Eric Biggers wrote:
> On Thu, Dec 11, 2025 at 10:52:15AM -0800, Darrick J. Wong wrote:
> > On Tue, Dec 09, 2025 at 06:22:02PM -0800, Eric Biggers wrote:
> > > On Tue, Dec 09, 2025 at 03:08:17AM -0800, syzbot wrote:
> > > > syzbot has found a reproducer for the following issue on:
> > > > 
> > > > HEAD commit:    a110f942672c Merge tag 'pinctrl-v6.19-1' of git://git.kern..
> > > > git tree:       upstream
> > > > console output: https://syzkaller.appspot.com/x/log.txt?x=17495992580000
> > > > kernel config:  https://syzkaller.appspot.com/x/.config?x=10d58c94af5f9772
> > > > dashboard link: https://syzkaller.appspot.com/bug?extid=7add5c56bc2a14145d20
> > > > compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > > > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1122aec2580000
> > > > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14012a1a580000
> > > 
> > > Simplified reproducer:
> > > 
> > >     rm -f image
> > >     mkdir -p mnt
> > >     mkfs.ext4 -O encrypt -b 1024 image 1M
> > >     mount image mnt -o test_dummy_encryption
> > >     dd if=/dev/urandom of=mnt/file bs=1 seek=1024 count=1
> > >     sync
> > > 
> > > It causes ext4 to encrypt uninitialized memory:
> > > 
> > >     BUG: KMSAN: uninit-value in crypto_aes_encrypt+0x511b/0x5260
> > >     [...]
> > >     fscrypt_encrypt_pagecache_blocks+0x309/0x6c0
> > >     ext4_bio_write_folio+0xd2f/0x2210
> > >     [...]
> > > 
> > > ext4_bio_write_folio() has:
> > > 
> > > 	/*
> > > 	 * If any blocks are being written to an encrypted file, encrypt them
> > > 	 * into a bounce page.  For simplicity, just encrypt until the last
> > > 	 * block which might be needed.  This may cause some unneeded blocks
> > > 	 * (e.g. holes) to be unnecessarily encrypted, but this is rare and
> > > 	 * can't happen in the common case of blocksize == PAGE_SIZE.
> > > 	 */
> > > 	if (fscrypt_inode_uses_fs_layer_crypto(inode)) {
> > > 		gfp_t gfp_flags = GFP_NOFS;
> > > 		unsigned int enc_bytes = round_up(len, i_blocksize(inode));
> > > 
> > > So I think that if a non-first block in a page is being written to disk
> > > and all preceding blocks in the page are holes, the (uninitialized)
> > > sections of the page corresponding to the holes are being encrypted too.
> > > 
> > > This is probably "benign", as ext4 doesn't do anything with the
> > > encrypted uninitialized data.  (Also note that this issue can occur only
> > > when block_size < PAGE_SIZE.)
> > > 
> > > I'm not yet sure how to proceed here.  We could make ext4 be more
> > > selective about encrypting the exact set of blocks in the page that are
> > > being written.  That would require support in fs/crypto/ for that.  We
> > > could use kmsan_unpoison_memory() to just suppress the warning.
> > > 
> > > Or, we could go forward with removing support for the "fs-layer crypto"
> > > from ext4 and only support blk-crypto (relying on blk-crypto-fallback
> > > for the software fallback).  The blk-crypto code path doesn't have this
> > > problem since it more closely ties the encryption to the actual write.
> > > It also works better with folios.
> > 
> > Hey waitaminute, are you planning to withdraw fscrypt from ext4?
> > 
> > (I might just not know enough about what blk-crypto is)
> > 
> 
> ext4 (and also f2fs) has two different implementations of file contents
> en/decryption: one where the filesystem directly calls the crypto
> functions to en/decrypt file contents, and one where the filesystem
> instead adds a bio_crypt_ctx to the bios it submits, causing the block
> layer to handle the en/decryption (via either inline crypto hardware or
> blk-crypto-fallback).  See the "Inline encryption support" section of
> Documentation/filesystems/fscrypt.rst.
> 
> These correspond to fscrypt_inode_uses_fs_layer_crypto() and
> fscrypt_inode_uses_inline_crypto() in the code.  The "fs-layer"
> implementation is used by default, while the inline crypto
> implementation is used when the 'inlinecrypt' mount option is used.
> 
> It's just an implementation detail and doesn't affect the end result.
> 
> Note that "fscrypt" is the name for the overall ext4/f2fs/etc encryption
> feature, which both these implementations are part of.
> 
> I'm talking about possibly removing the first of these file contents
> encryption implementations, which again are just implementation details,
> so that we standardize on just the blk-crypto one.

Ooh, I bet that will integrate better with iomap, whenever someone gets
around to attempting the first port. :)

--D

> Again, this KMSAN warning is specific to the first implementation.  I.e.
> it doesn't appear when the inlinecrypt mount option is used.
> 
> - Eric
> 

