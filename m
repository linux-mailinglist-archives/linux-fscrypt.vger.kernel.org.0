Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DDAD13EF7F0
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Aug 2021 04:09:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235913AbhHRCK3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Aug 2021 22:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:49628 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233380AbhHRCK0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Aug 2021 22:10:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6AC4F60F5E;
        Wed, 18 Aug 2021 02:09:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629252592;
        bh=B15pn2XunpVBloy8qLk8GOdp/fRGBs/dMCBl1c1wvW8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=HuBUUoZEtHR8q3eIHhlcYOMaxVYN9EtN5/AnsOeRV7mlH1f3r4Nz5Ka5dQpaVrr7f
         AzEuFy1vbDUheHR+mm3qjkfrCzg9oclx9Sbc2tfkAlxLEFIUnPkRRhMUpwipNFBN3B
         y751zJkymZ/G6drWdcxb+8ixCgP29n0XLQIX1azSirCxo7Z/oDqBRKWV3xTgNFK6dk
         VCkItm1/os96sMi5D3/7K5HqrOD50nuI00r6bWq/s1XyqhWnIRWW8NZjhw5PvNg7i6
         GbDirjDIVLcodJ3YerbdyN/5Y436Zu3NzcajsGgBRXWkhw3TPkYbfRwn1rysZJyN4P
         9N6z4Z09XR3RQ==
Date:   Wed, 18 Aug 2021 05:09:50 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel@pengutronix.de,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        David Howells <dhowells@redhat.com>,
        linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fscrypt: support trusted keys
Message-ID: <20210818020950.GA23184@iki.fi>
References: <20210810212140.sdq5dq2wy5uaj7h7@kernel.org>
 <YRLvPJehAeMiYb2Z@gmail.com>
 <20210811001743.ofzkwdwa6rcjsf4d@kernel.org>
 <d4f5c2593380c82ceebae2c8782a1c440b35f165.camel@linux.ibm.com>
 <YRQF09f8st95yrFZ@gmail.com>
 <0e69a0aa394dd20347b06ae4e700aa17d52583ef.camel@linux.ibm.com>
 <a6eb6f38-b9f4-c59c-4181-2049f181e67d@pengutronix.de>
 <285cb263d9c1c16f3918c98dd36074ef16568e6d.camel@linux.ibm.com>
 <b77836af-42a1-5aca-9363-d050352bd8aa@pengutronix.de>
 <f4264f0a83c1b080ad2a22d63ecf1fcca87dfebb.camel@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f4264f0a83c1b080ad2a22d63ecf1fcca87dfebb.camel@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 17, 2021 at 10:24:44AM -0400, Mimi Zohar wrote:
> On Tue, 2021-08-17 at 16:13 +0200, Ahmad Fatoum wrote:
> > On 17.08.21 15:55, Mimi Zohar wrote:
> > > I have no opinion as to whether this is/isn't a valid usecase.
> > 
> > So you'd be fine with merging trusted key support as is and leave encrypted
> > key support to someone who has a valid use case and wants to argue
> > in its favor?
> 
> That decision as to whether it makes sense to support trusted keys
> directly, based on the new trust sources, is a decision left up to the
> maintainer(s) of the new usecase and the new trust sources maintainer
> Jarkko.

I'm fine with "direct", as long as also "indirect" is supported.

/Jarkko
