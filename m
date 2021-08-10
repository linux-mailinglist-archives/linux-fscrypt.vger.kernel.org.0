Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0867B3E852E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Aug 2021 23:22:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233962AbhHJVWT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Aug 2021 17:22:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:42766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229582AbhHJVWF (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Aug 2021 17:22:05 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1587A60F55;
        Tue, 10 Aug 2021 21:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628630502;
        bh=iVvg4eXWATfBowatoEqO01nKR8TgnDFtwpnbkcC33Vw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pWOoSAptpa5ZeDPi61Kt+iATARj1dzr2RHRhwaYyZJd2xxiVKnzUqIpysX6Y+ohbB
         /kPXbPI5MYne5Y8jhGfZDpQF/KfDWptAN4JHIMFPqHwX50XJSmycZr4K9/dcDBBU0D
         XXqwrZvcHmnqpwd3tOOvVZiWGJJ0Hy1her2Z2olFLcsS6twf8q56RA5oZL6TTF33O/
         bhtzAGPzKigsTVemQMSto6es93NVV1finGwW4K5saCFUA2NOUI1sxdQ2NnRyzhZXJB
         vw5p0CsVWMxVgbHL4zM09tUDMbq/y9azZYzlAPRFcgINpqEeQRegMrTGUjL2lsD+Lb
         65tBJl5dHl2Tg==
Date:   Wed, 11 Aug 2021 00:21:40 +0300
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
Message-ID: <20210810212140.sdq5dq2wy5uaj7h7@kernel.org>
References: <20210806150928.27857-1-a.fatoum@pengutronix.de>
 <20210809094408.4iqwsx77u64usfx6@kernel.org>
 <YRGVcaquAJiuc8bp@gmail.com>
 <20210810180636.vqwaeftv7alsodgn@kernel.org>
 <YRLJmaafp941uOdA@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YRLJmaafp941uOdA@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 10, 2021 at 11:46:49AM -0700, Eric Biggers wrote:
> On Tue, Aug 10, 2021 at 09:06:36PM +0300, Jarkko Sakkinen wrote:
> > > > 
> > > > I don't think this is right, or at least it does not follow the pattern
> > > > in [*]. I.e. you should rather use trusted key to seal your fscrypt key.
> > > 
> > > What's the benefit of the extra layer of indirection over just using a "trusted"
> > > key directly?  The use case for "encrypted" keys is not at all clear to me.
> > 
> > Because it is more robust to be able to use small amount of trusted keys,
> > which are not entirely software based.
> > 
> > And since it's also a pattern on existing kernel features utilizing trusted
> > keys, the pressure here to explain why break the pattern, should be on the
> > side of the one who breaks it.
> 
> This is a new feature, so it's on the person proposing the feature to explain
> why it's useful.  The purpose of "encrypted" keys is not at all clear, and the
> documentation for them is heavily misleading.  E.g.:
> 
>     "user space sees, stores, and loads only encrypted blobs"
>     (Not necessarily true, as I've explained previously.)
> 
>     "Encrypted keys do not depend on a trust source" ...  "The main disadvantage
>     of encrypted keys is that if they are not rooted in a trusted key"
>     (Not necessarily true, and in fact it seems they're only useful when they
>     *do* depend on a trust source.  At least that's the use case that is being
>     proposed here, IIUC.)
> 
> I do see a possible use for the layer of indirection that "encrypted" keys are,
> which is that it would reduce the overhead of having lots of keys be directly
> encrypted by the TPM/TEE/CAAM.  Is this the use case?  If so, it needs to be
> explained.

If trusted keys are used directly, it's an introduction of a bottleneck.
If they are used indirectly, you can still choose to have one trusted
key per fscrypt key.

Thus, it's obviously a bad idea to use them directly.

/Jarkko
