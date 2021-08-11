Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585DA3E8720
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 Aug 2021 02:17:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235724AbhHKASJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Aug 2021 20:18:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:34146 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235680AbhHKASI (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Aug 2021 20:18:08 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3A02360FD9;
        Wed, 11 Aug 2021 00:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628641065;
        bh=vS0O2G4UqYCFp5XbO0UvX+Z3o0P/EBLHkKPuQEwAbYc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=m90I8MFYojVSKUZbGrXDKIJU8CpLr0ZkbA+yZJ31ujVzplnqw+lVK5V/WFofFfbtY
         YJl9Jd8kVgfFQCL9hbNlX9aweGNOlBnrqZIJ9e4oC+6oIVBy1U/VedMB5GddqhD3LM
         cln6DPrUnDQhiyi5vhboXLklmcr7o5JtK2kL7kOfy0PeZSNFlhfb9Re4Gf4Vihz9mv
         lHRW2GirAxlHKqUc/U3nW1jlQjlQpWkfZslp8ai02bxlodrclzFuu6nWxKjArgLu7y
         zDLZrBbiQgbtJxOd4J3SbyVFFzZXbcQASgAcBjkavW6dgY3w08MWp3qldid9INCFEL
         aFjN4yuBuj1TQ==
Date:   Wed, 11 Aug 2021 03:17:43 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Ahmad Fatoum <a.fatoum@pengutronix.de>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel@pengutronix.de,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        David Howells <dhowells@redhat.com>,
        linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] fscrypt: support trusted keys
Message-ID: <20210811001743.ofzkwdwa6rcjsf4d@kernel.org>
References: <20210806150928.27857-1-a.fatoum@pengutronix.de>
 <20210809094408.4iqwsx77u64usfx6@kernel.org>
 <YRGVcaquAJiuc8bp@gmail.com>
 <20210810180636.vqwaeftv7alsodgn@kernel.org>
 <YRLJmaafp941uOdA@gmail.com>
 <20210810212140.sdq5dq2wy5uaj7h7@kernel.org>
 <YRLvPJehAeMiYb2Z@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRLvPJehAeMiYb2Z@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 10, 2021 at 02:27:24PM -0700, Eric Biggers wrote:
> On Wed, Aug 11, 2021 at 12:21:40AM +0300, Jarkko Sakkinen wrote:
> > On Tue, Aug 10, 2021 at 11:46:49AM -0700, Eric Biggers wrote:
> > > On Tue, Aug 10, 2021 at 09:06:36PM +0300, Jarkko Sakkinen wrote:
> > > > > > 
> > > > > > I don't think this is right, or at least it does not follow the pattern
> > > > > > in [*]. I.e. you should rather use trusted key to seal your fscrypt key.
> > > > > 
> > > > > What's the benefit of the extra layer of indirection over just using a "trusted"
> > > > > key directly?  The use case for "encrypted" keys is not at all clear to me.
> > > > 
> > > > Because it is more robust to be able to use small amount of trusted keys,
> > > > which are not entirely software based.
> > > > 
> > > > And since it's also a pattern on existing kernel features utilizing trusted
> > > > keys, the pressure here to explain why break the pattern, should be on the
> > > > side of the one who breaks it.
> > > 
> > > This is a new feature, so it's on the person proposing the feature to explain
> > > why it's useful.  The purpose of "encrypted" keys is not at all clear, and the
> > > documentation for them is heavily misleading.  E.g.:
> > > 
> > >     "user space sees, stores, and loads only encrypted blobs"
> > >     (Not necessarily true, as I've explained previously.)
> > > 
> > >     "Encrypted keys do not depend on a trust source" ...  "The main disadvantage
> > >     of encrypted keys is that if they are not rooted in a trusted key"
> > >     (Not necessarily true, and in fact it seems they're only useful when they
> > >     *do* depend on a trust source.  At least that's the use case that is being
> > >     proposed here, IIUC.)
> > > 
> > > I do see a possible use for the layer of indirection that "encrypted" keys are,
> > > which is that it would reduce the overhead of having lots of keys be directly
> > > encrypted by the TPM/TEE/CAAM.  Is this the use case?  If so, it needs to be
> > > explained.
> > 
> > If trusted keys are used directly, it's an introduction of a bottleneck.
> > If they are used indirectly, you can still choose to have one trusted
> > key per fscrypt key.
> > 
> > Thus, it's obviously a bad idea to use them directly.
> > 
> 
> So actually explain that in the documentation.  It's not obvious at all.  And
> does this imply that the support for trusted keys in dm-crypt is a mistake?

Looking at dm-crypt implementation, you can choose to use 'encrypted' key
type, which you can seal with a trusted key.

Note: I have not been involved when the feature was added to dm-crypt.

/Jarkko
