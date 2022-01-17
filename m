Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 168B0490B03
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jan 2022 16:02:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235060AbiAQPCI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jan 2022 10:02:08 -0500
Received: from bedivere.hansenpartnership.com ([96.44.175.130]:34668 "EHLO
        bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S240209AbiAQPCH (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jan 2022 10:02:07 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1642431727;
        bh=OW9U2+meBQy34anl2WyrbHUSGOf1VsTYY9i3U35ob8o=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=bPWlyPd/jb39x4iVyZI97znobRTN1qgkMVypI7NHCRLTttyLlhac9QH5lgDebxscn
         Xi5axGZUEOQVdAf4BNGOXzNOB+i4HmxGbPpQra3hs9x/tKS8hE1kf29WSr+S9m+zcG
         3/TFuRa/JwCHemTSH99x5rw/KhLyxqCpu5rf4QIc=
Received: from localhost (localhost [127.0.0.1])
        by bedivere.hansenpartnership.com (Postfix) with ESMTP id 00CA81280D73;
        Mon, 17 Jan 2022 10:02:07 -0500 (EST)
Received: from bedivere.hansenpartnership.com ([127.0.0.1])
        by localhost (bedivere.hansenpartnership.com [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id HK_gtpdkho8J; Mon, 17 Jan 2022 10:02:06 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
        d=hansenpartnership.com; s=20151216; t=1642431726;
        bh=OW9U2+meBQy34anl2WyrbHUSGOf1VsTYY9i3U35ob8o=;
        h=Message-ID:Subject:From:To:Date:In-Reply-To:References:From;
        b=PkZteIGaeDYl2y+DI/FyeeGXNY4eKlxnUNF7lsoIrxF8oV+G6rcTY2q22hp2AmJpa
         MTJ3DMq33n5rwtb0PJoSUjVl+uBK1i3SS91+PWFe/1+Mq3YKZsCqrdPUdadKiRJtKH
         gNoeXbJ1YWksWIWcIGpw93CDKH31dZug6/BsI3zg=
Received: from jarvis.int.hansenpartnership.com (unknown [IPv6:2601:5c4:4300:c551::527])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by bedivere.hansenpartnership.com (Postfix) with ESMTPSA id C28E51280D51;
        Mon, 17 Jan 2022 10:02:05 -0500 (EST)
Message-ID: <d92912bba61ee37e42d04b64073b9031604acc0f.camel@HansenPartnership.com>
Subject: Re: [PATCH 00/14] KEYS: Add support for PGP keys and signatures
From:   James Bottomley <James.Bottomley@HansenPartnership.com>
To:     "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Roberto Sassu <roberto.sassu@huawei.com>
Cc:     dhowells@redhat.com, dwmw2@infradead.org,
        herbert@gondor.apana.org.au, davem@davemloft.net,
        keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.ibm.com,
        ebiggers@kernel.org
Date:   Mon, 17 Jan 2022 10:02:04 -0500
In-Reply-To: <YeV+jkGg6mpQdRID@zx2c4.com>
References: <20220111180318.591029-1-roberto.sassu@huawei.com>
         <YeV+jkGg6mpQdRID@zx2c4.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.4 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2022-01-17 at 15:34 +0100, Jason A. Donenfeld wrote:
> Hi,
> 
> While it looks like you put a lot of work into this patchset, I think
> the general idea of adding PGP *to the kernel* is a pretty daunting
> proposition. The general consensus in the crypto engineering world is
> that PGP ought to be on its way out. We definitely don't want to
> perpetuate this project-on-life-support into the permanence of kernel
> code. Some quick Google searches will reveal a litany of blog posts
> to the tune of, "why oh why are people still using this?" Here's one
> from 2019: 
> https://latacora.micro.blog/2019/07/16/the-pgp-problem.html . I
> think these are arguments to take seriously. And even if you disagree
> with some parts, you may want to consider whether the remaining parts
> warrant a bit of pause before adding this to the kernel and
> perpetuating PGP's design further.

The reason is simple though: for all the detractors and whining, no-
one's actually been able to come up with a more usable replacement. 
Very few people who complain about GPG actually submit patches to fix
it.  A few come up with their own infrastructure which tends to have
even more problems.

> If you're looking for a simple signature mechanism to replace the use
> of X.509 and all of that infrastructure, may I suggest just coming up
> with something simple using ed25519,

Please, no, use universally supported crypto that we can use TPM
hardware for, which for EC currently means P-256.  It may be possible
to get the TCG and the other security bodies to add Edwards signatures
but the rate of progression of quantum means that Grover's Algorithm
will likely get there first and we'll need P-521 or X448.

>  similar to signify or minisign? Very minimal code in the kernel, in
> userspace, and very few moving parts to break.

Heh, this is the classic cryptographers dilemma: go for something
pejorative which can be minimal but which has only a relatively small
set of possible use cases and no future proofing or go for something
extensible which ends up more complex and others then criticize as
being a "swiss army knife".

James


