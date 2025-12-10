Return-Path: <linux-fscrypt+bounces-999-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [172.232.135.74])
	by mail.lfdr.de (Postfix) with ESMTPS id 2EB2ECB1B4D
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Dec 2025 03:22:12 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id 993373010067
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Dec 2025 02:22:11 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 59D1025F988;
	Wed, 10 Dec 2025 02:22:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gc1EziTu"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C03425CC79;
	Wed, 10 Dec 2025 02:22:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765333329; cv=none; b=CeNyBdzxnl4Um7hYZglA+PZPaMwCLWBR6XcqfBMVNUbfmzZtYiNLemgYQwVt5+QKr3PZfn6yYDH5pTUv8g076zl9lPW/hNNw36ZAu9uOlHW3PSpSkgfeiQGm7wLKjoINYBHAnxcbFzZwvdhoIenD+qnuHJeTgwj8VJ0E4XEe5NE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765333329; c=relaxed/simple;
	bh=E8/YVwOp3fUxjVn9z9qVw0TPC4K0zrGT8qrQc6+THtc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aembpj3xyFctJFoTWuQKcTVSZdT+G+7EMKrBWYsDnepfBBQ5+9nuzUEGg3y6Nf0Fn/qvKYEV3F7Q/hmjs8RVf6tHCYwo8clDNKt/LX5U6ogUQbFv5sNkqd+OysQ4ebdx2fYyfj57NdYI+MHiVtz2p0QjXeZfnmjfcHVZICulpLo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gc1EziTu; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 501FDC4CEF5;
	Wed, 10 Dec 2025 02:22:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1765333327;
	bh=E8/YVwOp3fUxjVn9z9qVw0TPC4K0zrGT8qrQc6+THtc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=gc1EziTul0p2DKNuE7mCojyLncN0y1DqGLOckisCZ3oduNxqfOuFUViiFHGMMsCdT
	 XxBMidN8aGfrQwyN+mIT6XS1bxKs6CouoOV5zhPGRzBicDJAUlOOqKrwN07D/iP5WB
	 Y0YHhIghJHYcusN0pjvlWpHhtGTj/XHbXUW8DMLpbPP97BUJ8J4ZmqeKwdWZ2hO17g
	 pwI0SlxKT0Fhr/CMhz139LFj7v4C3/Szhz5Ir+lasPpsnC6BHkqE5Q5MMmZSGXvQb+
	 XnSP/oB1yapVty3U+pCtWiDK3xJtJAjwybnT+U/5c45mfXdfYYFhcHVLu2Nhjfbrdl
	 3og0dMNj/9icw==
Date: Tue, 9 Dec 2025 18:22:02 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: syzbot <syzbot+7add5c56bc2a14145d20@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, herbert@gondor.apana.org.au, jaegeuk@kernel.org,
	linux-crypto@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Subject: Re: [syzbot] [ext4] [fscrypt] KMSAN: uninit-value in
 fscrypt_crypt_data_unit
Message-ID: <20251210022202.GB4128@sol>
References: <68ee633c.050a0220.1186a4.002a.GAE@google.com>
 <69380321.050a0220.1ff09b.0000.GAE@google.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69380321.050a0220.1ff09b.0000.GAE@google.com>

On Tue, Dec 09, 2025 at 03:08:17AM -0800, syzbot wrote:
> syzbot has found a reproducer for the following issue on:
> 
> HEAD commit:    a110f942672c Merge tag 'pinctrl-v6.19-1' of git://git.kern..
> git tree:       upstream
> console output: https://syzkaller.appspot.com/x/log.txt?x=17495992580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=10d58c94af5f9772
> dashboard link: https://syzkaller.appspot.com/bug?extid=7add5c56bc2a14145d20
> compiler:       Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=1122aec2580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=14012a1a580000

Simplified reproducer:

    rm -f image
    mkdir -p mnt
    mkfs.ext4 -O encrypt -b 1024 image 1M
    mount image mnt -o test_dummy_encryption
    dd if=/dev/urandom of=mnt/file bs=1 seek=1024 count=1
    sync

It causes ext4 to encrypt uninitialized memory:

    BUG: KMSAN: uninit-value in crypto_aes_encrypt+0x511b/0x5260
    [...]
    fscrypt_encrypt_pagecache_blocks+0x309/0x6c0
    ext4_bio_write_folio+0xd2f/0x2210
    [...]

ext4_bio_write_folio() has:

	/*
	 * If any blocks are being written to an encrypted file, encrypt them
	 * into a bounce page.  For simplicity, just encrypt until the last
	 * block which might be needed.  This may cause some unneeded blocks
	 * (e.g. holes) to be unnecessarily encrypted, but this is rare and
	 * can't happen in the common case of blocksize == PAGE_SIZE.
	 */
	if (fscrypt_inode_uses_fs_layer_crypto(inode)) {
		gfp_t gfp_flags = GFP_NOFS;
		unsigned int enc_bytes = round_up(len, i_blocksize(inode));

So I think that if a non-first block in a page is being written to disk
and all preceding blocks in the page are holes, the (uninitialized)
sections of the page corresponding to the holes are being encrypted too.

This is probably "benign", as ext4 doesn't do anything with the
encrypted uninitialized data.  (Also note that this issue can occur only
when block_size < PAGE_SIZE.)

I'm not yet sure how to proceed here.  We could make ext4 be more
selective about encrypting the exact set of blocks in the page that are
being written.  That would require support in fs/crypto/ for that.  We
could use kmsan_unpoison_memory() to just suppress the warning.

Or, we could go forward with removing support for the "fs-layer crypto"
from ext4 and only support blk-crypto (relying on blk-crypto-fallback
for the software fallback).  The blk-crypto code path doesn't have this
problem since it more closely ties the encryption to the actual write.
It also works better with folios.

- Eric

