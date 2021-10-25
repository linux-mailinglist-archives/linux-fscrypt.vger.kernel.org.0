Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 470CD43A059
	for <lists+linux-fscrypt@lfdr.de>; Mon, 25 Oct 2021 21:27:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235178AbhJYT35 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 25 Oct 2021 15:29:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:48428 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235588AbhJYT2s (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 25 Oct 2021 15:28:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 535A76115B;
        Mon, 25 Oct 2021 19:25:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635189917;
        bh=BQPuoan/SFpa8mNqVgzRLgNVibScROpRuiUrkpMQRls=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XqbWoM6M2AV94w5fc6HUe7OnKwOSUsFrlPn3fZdXztkoeXSLpDCrHc1mPOVHGAiPh
         ZCYZlAGSDMTvThzFFWSTJm0pytgIXP2u/yrs1klBgKdHH3d8iZ3H5dFzhUTSXs4d2Q
         8bTK37r8CymPonwymU+cUkASWWAAS7T5YYN2i+F4z3Dy+pzZtlc65s2uBDKkQYdqwn
         CyQ9XS557VuQzWTOTvZmkryOL57rvoLGTVuDYJ1ZRX0Zq+HobmE5HNUibU+Qr7gX4U
         hzd4g3vtb9OdiTUhMfgMw77bVh2oSjh7R4A7dTjV8SSbeveKduv4B6pM/NnSDGeLCL
         /7yTNyXiw3C6A==
Date:   Mon, 25 Oct 2021 12:25:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Omar Sandoval <osandov@osandov.com>
Cc:     Vadim Akimov <lvd.mhm@gmail.com>, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@fb.com
Subject: Re: Btrfs Fscrypt Design Document
Message-ID: <YXcEm2Ws02KydImk@gmail.com>
References: <YXGyq+buM79A1S0L@relinquished.localdomain>
 <CAMnT83tLqZU-bdsOJX9L==c82EvmQ2QTiOYCLch=kasscU+MiA@mail.gmail.com>
 <YXMYJ9nOd/88T8gc@relinquished.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YXMYJ9nOd/88T8gc@relinquished.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Oct 22, 2021 at 12:59:35PM -0700, Omar Sandoval wrote:
> On Fri, Oct 22, 2021 at 10:14:11PM +0300, Vadim Akimov wrote:
> > Hi!
> > 
> > On Thu, 21 Oct 2021 at 21:34, Omar Sandoval <osandov@osandov.com> wrote:
> > 
> > > Here is the Google Doc:
> > >
> > > https://docs.google.com/document/d/1iNnrqyZqJ2I5nfWKt7cd1T9xwU0iHhjhk9ALQW3XuII/edit?usp=sharing
> > >
> > 
> > As I've understood, you are inclined to have single key and only change IV
> > for each extent. This might be dangerous as per this answer (and comments
> > below):  https://crypto.stackexchange.com/a/70630/71448
> 
> Correct me if I'm wrong, but I don't think this is a practical concern
> in the fscrypt threat model. The birthday bound for AES is 256 EiB
> (2^(128 / 2) blocks * 16 bytes per block). The theoretical maximum size
> of a Btrfs filesystem is 16 EiB (since we use 64-bit byte addresses).
> fscrypt protects against a "single point-in-time permanent offline
> compromise". This means that the attacker only has what was on disk at
> the time that they stole your disk. In this case, they won't have enough
> data for a birthday attack. I'm curious where that post got the
> "multiple petabytes" number.

So, fscrypt originally only supported per-file keys.  The reason we added
support for some "one key per encryption policy" settings are because there are
cases where many keys can't be handled efficiently.  In the case of Adiantum
encryption (which is intended for devices which might not have a lot of memory)
a key takes a lot of memory, so we didn't want to have one for every file.
Similarly, in the case where file contents encryption is done using UFS or eMMC
inline encryption hardware rather than in software, there might be only a small
number of hardware keyslots and changing them can be slow, so we didn't want to
have to change keys for every file.

There are definitely some advantages to per-file keys, including reducing the
amount of data which is encrypted with each key, increasing the difficulty of
recovering deleted files, and eliminating the need to distinguish between
different files in the IVs.

None of these are too important in practice, though.  E.g. we don't get anywhere
near the cryptographic bounds in practice anyway, and secure deletion isn't
guaranteed even with per-file keys.

For btrfs, it sounds like per-file keys won't work out due to reflinks anyway.
However you could do per-extent keys in the same way, where the key for each
extent is derived from a nonce (stored in the metadata describing the extent)
and the master key.

Did you consider per-extent keys?  If they are practical, that would be the best
approach cryptographically.  But if they aren't practical (more likely IMO,
given that a file can contain a large number of extents), I think it would be
acceptable to not use them.

- Eric
