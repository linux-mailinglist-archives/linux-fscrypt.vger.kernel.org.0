Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 000B7492DD4
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Jan 2022 19:49:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244812AbiARSto (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Jan 2022 13:49:44 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:47658 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239777AbiARSto (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Jan 2022 13:49:44 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A6E29B816B8;
        Tue, 18 Jan 2022 18:49:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F203FC340E5;
        Tue, 18 Jan 2022 18:49:40 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="U/Y+YHBu"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1642531777;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=8kDfRJVSB/Dcaimsa/vjMLUP8srTQCq9bVl6p5ZAm2c=;
        b=U/Y+YHBuewTXqw0C6Dj06InDbbu4B8M3iGKZaGvn1NdBWM9C+47xqEH+P0VHOepFNXU+FE
        5Ue6x1hkyZoBp7FRPjhB/KUzhdk/KKK0lcQwM8b1TF3B2IArDW5xYzXR2j4p2mRKhKzyKA
        RpWgPrc2X0yu+PRQIJRb8+A+DXlW40I=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id 4704321f (TLSv1.3:AEAD-AES256-GCM-SHA384:256:NO);
        Tue, 18 Jan 2022 18:49:36 +0000 (UTC)
Received: by mail-yb1-f179.google.com with SMTP id 23so4732437ybf.7;
        Tue, 18 Jan 2022 10:49:35 -0800 (PST)
X-Gm-Message-State: AOAM5304+u5MliVSIqnDuvJ6zgsUuXxUBNGi9N99bB22nJMLLvtpXKhZ
        Qn21/aqB3w/yRbMgnHUNaQMHtxjO/xova/Jym/E=
X-Google-Smtp-Source: ABdhPJwjXcqqMBS96Vtvk119QZBIJ9xohbPgfh8+w+auW1qVQLfqIpJyVlBaV93K+rzMyMYefFNSjqHidvJp07ttYOk=
X-Received: by 2002:a25:ef08:: with SMTP id g8mr499647ybd.115.1642531774549;
 Tue, 18 Jan 2022 10:49:34 -0800 (PST)
MIME-Version: 1.0
References: <20220111180318.591029-1-roberto.sassu@huawei.com>
 <YeV+jkGg6mpQdRID@zx2c4.com> <887a1e46cd6f4c02a6530a15f00e8eb8@huawei.com>
In-Reply-To: <887a1e46cd6f4c02a6530a15f00e8eb8@huawei.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Tue, 18 Jan 2022 19:49:23 +0100
X-Gmail-Original-Message-ID: <CAHmME9pMEJxGzmetDu0Bkf1=fqb+BHGQ3-6NB3hhtRjLWHm1cA@mail.gmail.com>
Message-ID: <CAHmME9pMEJxGzmetDu0Bkf1=fqb+BHGQ3-6NB3hhtRjLWHm1cA@mail.gmail.com>
Subject: Re: [PATCH 00/14] KEYS: Add support for PGP keys and signatures
To:     roberto.sassu@huawei.com
Cc:     "dhowells@redhat.com" <dhowells@redhat.com>,
        "dwmw2@infradead.org" <dwmw2@infradead.org>,
        "herbert@gondor.apana.org.au" <herbert@gondor.apana.org.au>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "keyrings@vger.kernel.org" <keyrings@vger.kernel.org>,
        "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "zohar@linux.ibm.com" <zohar@linux.ibm.com>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Roberto,

Thanks for your detailed reply.

On Mon, Jan 17, 2022 at 4:21 PM Roberto Sassu <roberto.sassu@huawei.com> wrote:
> The problem is that I don't see that transition coming soon.
> Transition from PGP to another scheme would require Linux
> distribution vendors to do an huge amount of work. It could
> probably take years before that transition occurs.
> More specifically, the first task would be to modify how
> RPMs are signed (and thus how they are verified). The second
> task would be to have a different way to certify the public key.
> Lastly, Linux distribution vendors would have to change their
> building infrastructure to use the new certified key, a new
> version of the rpm package manager which takes as input
> the new key, produces a different type of signature and embeds
> it in the RPM header.

Hm, yea, I see your dilemma.

On the one hand, you recognize the problems with what currently
exists. On the other hand, you[r organization] hasn't made the
transition to something better. So, rather than putting in what might
be a lot of work to transition to something better (which includes
actually evaluating *what* the better thing would be), you'd prefer to
put in a smaller amount of work to make the current thing satisfy some
of your needs, even though you recognize its flaws. It seems like this
is one of those "short term" vs "long term" investment tradeoffs.

I don't have a whole lot _technical_ to say about long term vs short
term thinking, but it does strike me that PGP is one of these cases
where people have known about the flaws for decades, but the ecosystem
keeps being extended because people continue to go with the short term
solutions, one by one, and now they've wound up here, at the doorstep
of the kernel. Maybe if at some point somebody puts down the foot and
says, "the road of short term intentions stops here," there might
gradually be impetus toward looking into long term solutions, e.g.
viable PGP replacements? Just a thought.

> If in the future the transition from PGP to another scheme
> occurs, support for PGP keys and signatures can be still
> deprecated.

Things in the kernel rarely disappear. At best, they become subtly
neglected, and then somebody gets bit by some security bug. At worst,
we're stuck maintaining a PGP implementation until the end of
eternity.


On the technical front, though, I had sort of the same thought as
Maciej: is there some way that you can unwrap the PGP data in
userspace, and re-encode it in ASN.1, and somehow magically account
for the various metadata included in the signatures? The devil here
might be in the details, and I'm not sure whether it's feasible. But
if it is, this would seem to be a much nicer solution. I'm not the
hugest fan of having an ASN.1 parser in the kernel either, but it's
_already_ there, and if you could somehow piggyback on top of it, that
means we'd be able to avoid importing this PGP implementation.

Concretely, it looks like the hardest part of this is the fact that
pgp_digest_signature seems to hash in some PGP-specific metadata, not
just the raw data. Am I reading that right, and that's the case? If
so, that might spell trouble. You also mentioned in that other thread
the possibility of using a new/custom PGP packet type for this? Is the
idea there that you'd come up with something that could be unwrapped
into an ASN.1-verifable blob, as a custom extension of PGP that
distros could then distribute?

Jason
