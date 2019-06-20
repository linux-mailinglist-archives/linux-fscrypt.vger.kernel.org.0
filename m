Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3A614D880
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 20:27:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbfFTS1L (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 14:27:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:58018 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727880AbfFTS1K (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 14:27:10 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 765BF20665;
        Thu, 20 Jun 2019 18:27:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561055229;
        bh=eMOLl0DcLSBYMu58BKMqYpLM96sUSYjdEOqgHR8GkUs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ze7xvxmKDeulGb8SrJFzP470JWAhV0FOt7sxyxvg91DvU/QIBJvW918i/i2jUyL2T
         tuw0fZSduK7oCDpGwRfuWw9/XRy6vKr5ErO5v8nHFRTWMW5rpsrqVr2JA2yVN2Wmox
         75oBRUUHeuGl822CW8ASR1JPL2qSADcVBQBgI0n8=
Date:   Thu, 20 Jun 2019 11:27:07 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v3 1/6] crypto: essiv - create wrapper template for ESSIV
 generation
Message-ID: <20190620182706.GA246122@gmail.com>
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-2-ard.biesheuvel@linaro.org>
 <20190620010417.GA722@sol.localdomain>
 <20190620011325.phmxmeqnv2o3wqtr@gondor.apana.org.au>
 <CAKv+Gu-OwzmoYR5uymSNghEVc9xbkkt5C8MxAYA48UE=yBgb5g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-OwzmoYR5uymSNghEVc9xbkkt5C8MxAYA48UE=yBgb5g@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jun 20, 2019 at 09:30:41AM +0200, Ard Biesheuvel wrote:
> On Thu, 20 Jun 2019 at 03:14, Herbert Xu <herbert@gondor.apana.org.au> wrote:
> >
> > On Wed, Jun 19, 2019 at 06:04:17PM -0700, Eric Biggers wrote:
> > >
> > > > +#define ESSIV_IV_SIZE              sizeof(u64)     // IV size of the outer algo
> > > > +#define MAX_INNER_IV_SIZE  16              // max IV size of inner algo
> > >
> > > Why does the outer algorithm declare a smaller IV size?  Shouldn't it just be
> > > the same as the inner algorithm's?
> >
> > In general we allow outer algorithms to have distinct IV sizes
> > compared to the inner algorithm.  For example, rfc4106 has a
> > different IV size compared to gcm.
> >
> > In this case, the outer IV size is the block number so that's
> > presumably why 64 bits is sufficient.  Do you forsee a case where
> > we need 128-bit block numbers?
> >
> 
> Indeed, the whole point of this template is that it turns a 64-bit
> sector number into a n-bit IV, where n equals the block size of the
> essiv cipher, and its min/max keysize covers the digest size of the
> shash.
> 
> I don't think it makes sense to generalize this further, and if I
> understand the feedback from Herbert and Gilad correctly, it would
> even be better to define the input IV as a LE 64-bit counter
> explicitly, so we can auto increment it between sectors.
> 

I was understanding ESSIV at a more abstract level, where you pass in some IV
(which may or may not contain a sector number of some particular length and
endianness) and it encrypts it.

I see that both fscrypt and dm-crypt use the convention of a __le64 sector
number though, so it's probably reasonable to define the IV to be that.  A brief
comment explaining this might be helpful, though.

- Eric
