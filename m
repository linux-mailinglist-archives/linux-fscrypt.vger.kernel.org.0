Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4474FB0A
	for <lists+linux-fscrypt@lfdr.de>; Sun, 23 Jun 2019 12:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726440AbfFWKMw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 23 Jun 2019 06:12:52 -0400
Received: from helcar.hmeau.com ([216.24.177.18]:38678 "EHLO deadmen.hmeau.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726350AbfFWKMw (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 23 Jun 2019 06:12:52 -0400
Received: from gondobar.mordor.me.apana.org.au ([192.168.128.4] helo=gondobar)
        by deadmen.hmeau.com with esmtps (Exim 4.89 #2 (Debian))
        id 1hezUM-00014o-44; Sun, 23 Jun 2019 18:12:46 +0800
Received: from herbert by gondobar with local (Exim 4.89)
        (envelope-from <herbert@gondor.apana.org.au>)
        id 1hezUH-0002t7-8M; Sun, 23 Jun 2019 18:12:41 +0800
Date:   Sun, 23 Jun 2019 18:12:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [PATCH v4 0/6] crypto: switch to crypto API for ESSIV generation
Message-ID: <20190623101241.6cr4sbxyviigu3sz@gondor.apana.org.au>
References: <20190621080918.22809-1-ard.biesheuvel@arm.com>
 <CAKv+Gu-ZO9Fnfx06XYJ-tp+6nrk0D8TBGa2chmxFW-kjPMmLCw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-ZO9Fnfx06XYJ-tp+6nrk0D8TBGa2chmxFW-kjPMmLCw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jun 23, 2019 at 11:30:41AM +0200, Ard Biesheuvel wrote:
>
> So with that in mind, I think we should decouple the multi-sector
> discussion and leave it for a followup series, preferably proposed by
> someone who also has access to some hardware to prototype it on.

Yes that makes sense.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
