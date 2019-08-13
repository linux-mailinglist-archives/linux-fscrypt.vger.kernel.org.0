Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 979538C012
	for <lists+linux-fscrypt@lfdr.de>; Tue, 13 Aug 2019 20:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728287AbfHMSAY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 13 Aug 2019 14:00:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55908 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728183AbfHMSAY (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 13 Aug 2019 14:00:24 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3EA692064A;
        Tue, 13 Aug 2019 18:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565719223;
        bh=xbId40i8Dmjn2QpQ5F72v+idr4xKL+uiDE3bps/IbM8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BayrdhFEfQMICZuff9kc8Zczn1zZKbpC1zN4w2uSaXqUVlPSOnGX3eT3XDZboDZ5I
         AMgS6M/AAct+38Y+zPdoNsuNtrqDboYb831ILAwZrjxkMTrQBG54x3arFtyaQ/mgsS
         1QSpuT+ktcVAeodm5b+IgGs4to2MdOKn9sa2bAqc=
Date:   Tue, 13 Aug 2019 11:00:21 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Subject: Re: [dm-devel] [PATCH v10 2/7] fs: crypto: invoke crypto API for
 ESSIV handling
Message-ID: <20190813180020.GA233786@gmail.com>
Mail-Followup-To: Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
References: <20190812145324.27090-1-ard.biesheuvel@linaro.org>
 <20190812145324.27090-3-ard.biesheuvel@linaro.org>
 <20190812194747.GB131059@gmail.com>
 <CAKv+Gu-9aHY0op6MEmN8PfQhNa0kv=xNYB6rqtaCoiUdH4OASA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu-9aHY0op6MEmN8PfQhNa0kv=xNYB6rqtaCoiUdH4OASA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 13, 2019 at 08:09:41AM +0300, Ard Biesheuvel wrote:
> On Mon, 12 Aug 2019 at 22:47, Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Mon, Aug 12, 2019 at 05:53:19PM +0300, Ard Biesheuvel wrote:
> > > Instead of open coding the calculations for ESSIV handling, use a
> > > ESSIV skcipher which does all of this under the hood.
> > >
> > > Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> >
> > This looks fine (except for one comment below), but this heavily conflicts with
> > the fscrypt patches planned for v5.4.  So I suggest moving this to the end of
> > the series and having Herbert take only 1-6, and I'll apply this one to the
> > fscrypt tree later.
> >
> 
> I think the same applies to dm-crypt: at least patch #7 cannot be
> applied until my eboiv patch is applied there as well, but [Milan
> should confirm] I'd expect them to prefer taking those patches via the
> dm tree anyway.
> 
> Herbert, what would you prefer:
> - taking a pull request from a [signed] tag based on v4.3-rc1 that
> contains patches #1, #4, #5 and #6, allowing Eric and Milan/Mike to
> merge it as well, and apply the respective fscrypt and dm-crypt
> changes on top
> - just take patches #1, #4, #5 and #6 as usual, and let the fscrypt
> and dm-crypt changes be reposted to the respective lists during the
> next cycle
> 

FWIW I'd much prefer the second option, to minimize the number of special things
that Linus will have to consider or deal with.  (There's also going to be a
conflict between the fscrypt and keyrings trees.)  I'd be glad to take the
fscrypt patch for 5.5, if the essiv template is added in 5.4.

- Eric
