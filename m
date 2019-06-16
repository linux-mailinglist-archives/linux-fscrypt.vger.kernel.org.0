Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CBB09476EA
	for <lists+linux-fscrypt@lfdr.de>; Sun, 16 Jun 2019 23:09:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727115AbfFPVJG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 Jun 2019 17:09:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:43550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725920AbfFPVJG (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 Jun 2019 17:09:06 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 731C32084D;
        Sun, 16 Jun 2019 21:09:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560719345;
        bh=GTQ0Rb1obiOnV/loBYnTUldGJZLtLtyNtKdBjRCT2WY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xltwFOLyMNBwP569RW8nfVX87xkROwc6ffnB9dNtW6AFnDAh80Y+EQBzV8dsCi+dN
         BWL8tW67Wvqq2wBSh0tyfQiVhUmCjZdGOm/UTpDPk+s1w5FARQOBC1b0yayfi2Rxsg
         4PoqnST+b0yaxcSjh37V+939+TrtkzXSfV80lntg=
Date:   Sun, 16 Jun 2019 14:09:03 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>
Cc:     Milan Broz <gmazyland@gmail.com>,
        Mike Snitzer <msnitzer@redhat.com>,
        device-mapper development <dm-devel@redhat.com>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        linux-fscrypt@vger.kernel.org
Subject: Re: [dm-devel] [RFC PATCH 0/3] crypto: switch to shash for ESSIV
 generation
Message-ID: <20190616210903.GF923@sol.localdomain>
References: <20190614083404.20514-1-ard.biesheuvel@linaro.org>
 <9cd635ec-970b-bd1b-59f4-1a07395e69a0@gmail.com>
 <CAKv+Gu88tYOmO=8mi7yP2oj=x_SOB_o7D9jo6v_3xfbUxY2R1A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKv+Gu88tYOmO=8mi7yP2oj=x_SOB_o7D9jo6v_3xfbUxY2R1A@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

[+Cc linux-fscrypt]

On Sun, Jun 16, 2019 at 09:13:01PM +0200, Ard Biesheuvel wrote:
> >
> >  - ESSIV is useful only for CBC mode. I wish we move to some better mode
> > in the future instead of cementing CBC use... But if it helps people
> > to actually use unpredictable IV for CBC, it is the right approach.
> > (yes, I know XTS has own problems as well... but IMO that should be the default
> > for sector/fs-block encryption these days :)
> >
> 
> I agree that XTS should be preferred. But for some reason, the
> kernel's XTS implementation does not support ciphertext stealing (as
> opposed to, e.g., OpenSSL), and so CBC ended up being used for
> encrypting the filenames in fscrypt.
> 

Actually, for fscrypt CTS-CBC was also chosen because all filenames in each
directory use the same IV, in order to efficiently support all the possible
filesystem operations and to support filenames up to NAME_MAX.  So there was a
desire for there to be some propagation across ciphertext blocks rather than use
XTS which would effectively be ECB in this case.

Neither solution is great though, since CBC-CTS still has the common prefix
problem.  Long-term we're planning to switch to an AES-based wide block mode
such as AES-HEH or AES-HCTR for filenames encryption.  This is already solved
for Adiantum users since Adiantum is a wide-block mode, but there should be a
pure AES solution too to go along with AES contents encryption.

- Eric
