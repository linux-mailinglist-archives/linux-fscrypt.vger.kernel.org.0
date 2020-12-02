Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1AD12CC5B8
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Dec 2020 19:45:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730909AbgLBSon (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Dec 2020 13:44:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:41834 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729177AbgLBSon (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Dec 2020 13:44:43 -0500
Date:   Wed, 2 Dec 2020 10:44:00 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1606934642;
        bh=elsBDR/ZSis7YJlWkfrLyFe7ySAjjeFlqFr/roD2Re0=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=VoZ13d8BoHnY2bVles/jjMrok+g+aAvkzM2JJNot/aJIumaJ1kLDdAd6hE+xOBlsY
         Wu6/VJxfXt4Ab4fH/5xBr8jVZ8qZWt16fqQABvPgXOhhJAkll0xfnLbRRM/mVDE3FR
         X5EL9UdDEQiXCXU3DP50nOMoG8MhHox2jTZ7k4/jfd0Q53eRhqyfoOmhX/xHGU+Eux
         tZ38CQysbu7KoOM3xLeK/XIe/fXratV6ykgwg370B/kKqc/0K9aHxpOMq5sGuGmiEh
         S0LieIQrUfSA3hdEB76SXHIZPvCDzsnC0rVAD5M25nzfW+cdDEnxbiJxbUPweNRNZi
         FKovMoqJb4IPg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chris Mason <clm@fb.com>
Cc:     Boris Burkov <borisb@fb.com>, linux-fscrypt@vger.kernel.org
Subject: Re: max fsverity descriptor size?
Message-ID: <X8fgcP+0b32ayyXn@sol.localdomain>
References: <7F52BBF2-46A8-4854-9B68-1DC3EFA12EF0@fb.com>
 <X8fZI93Agr4f4Lwh@sol.localdomain>
 <1618E915-F81F-4175-8830-6FFD7B3B9F6C@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1618E915-F81F-4175-8830-6FFD7B3B9F6C@fb.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Dec 02, 2020 at 01:33:54PM -0500, Chris Mason wrote:
> 
> 
> On 2 Dec 2020, at 13:12, Eric Biggers wrote:
> 
> > +linux-fscrypt
> > 
> > On Wed, Dec 02, 2020 at 09:01:52AM -0500, Chris Mason wrote:
> > > Hi Eric,
> > > 
> > > I’m working on fsverity support in btrfs and wanted to check on the
> > > max size
> > > of the descriptor.  I can go up to any size, just wanted to make
> > > sure I had
> > > things correct in the disk format.
> > > 
> > > -chris
> > 
> > The implementations of fs-verity in ext4 and f2fs store the built-in
> > signature
> > (if there is one) appended to the 'struct fsverity_descriptor', and
> > limit the
> > total size of those two things combined to 16384 bytes.  See
> > FS_VERITY_MAX_DESCRIPTOR_SIZE in fs/verity/fsverity_private.h.
> > 
> > Note that there's nothing special about this particular number; it's
> > just an
> > implementation limit to prevent userspace doing weird things with
> > megabytes
> > "signatures".
> > 
> > If btrfs will be storing built-in signatures in the same way, it
> > probably should
> > use the same limit.  Preferably it would be done in a way such that it's
> > possible to increase the limit later if it's ever needed.
> > 
> 
> +Boris
> 
> Thanks Eric, the current btrfs code is just putting it in the btree, but
> I’ve got it setup so we won’t run into trouble if it spans multiple btree
> blocks.
> 
> Looks like the fs/verity/*.c are in charge of validating against the max
> size?  I’m not finding specific checks in ext4.

Yes, that's the case currently.

- Eric
