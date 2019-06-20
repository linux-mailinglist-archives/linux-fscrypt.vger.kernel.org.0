Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 912D54C4E2
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 03:18:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731068AbfFTBS2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 Jun 2019 21:18:28 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:50496 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726211AbfFTBS2 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 Jun 2019 21:18:28 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hdlia-0005Vu-LJ; Thu, 20 Jun 2019 09:18:24 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hdli5-0006fe-4U; Thu, 20 Jun 2019 09:17:53 +0800
Date:   Thu, 20 Jun 2019 09:17:53 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v3 1/6] crypto: essiv - create wrapper template for ESSIV
 generation
Message-ID: <20190620011752.et6clrrrbl5llgr2@gondor.apana.org.au>
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-2-ard.biesheuvel@linaro.org>
 <20190620010417.GA722@sol.localdomain>
 <20190620011325.phmxmeqnv2o3wqtr@gondor.apana.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190620011325.phmxmeqnv2o3wqtr@gondor.apana.org.au>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jun 20, 2019 at 09:13:25AM +0800, Herbert Xu wrote:
> On Wed, Jun 19, 2019 at 06:04:17PM -0700, Eric Biggers wrote:
> >
> > > +#define ESSIV_IV_SIZE		sizeof(u64)	// IV size of the outer algo
> > > +#define MAX_INNER_IV_SIZE	16		// max IV size of inner algo
> > 
> > Why does the outer algorithm declare a smaller IV size?  Shouldn't it just be
> > the same as the inner algorithm's?
> 
> In general we allow outer algorithms to have distinct IV sizes
> compared to the inner algorithm.  For example, rfc4106 has a
> different IV size compared to gcm.
> 
> In this case, the outer IV size is the block number so that's
> presumably why 64 bits is sufficient.  Do you forsee a case where
> we need 128-bit block numbers?

Actually this reminds me, the essiv template needs to be able to
handle multiple blocks/sectors, as otherwise this will still only
be able to push a single block/sector to the hardware at a time.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
