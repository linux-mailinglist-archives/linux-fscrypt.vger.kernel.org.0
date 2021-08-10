Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F1773E8334
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Aug 2021 20:46:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231671AbhHJSrP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Aug 2021 14:47:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:60310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231221AbhHJSrP (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Aug 2021 14:47:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 669DC60EB9;
        Tue, 10 Aug 2021 18:46:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628621211;
        bh=ZerG9ye3QrY9ea4A77UJpFKD2UzPAh9muW0NUHyjOAw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l1Rt9QxHC6wZEhya68OxA5XzIdmNieElZTJLUGQucOgjQEU5wyP3DkbEQEwzVqrB9
         DEvPrkxIx8u1VURhaRjYSBXGAleiEZihH/xyU1UN9+JDhgTFVyycVo20+dDeCke2It
         ng0JMSA4ZwCoGBpSNMG1DmQNukqBNhT4CQey1LTQUs1cqSEDvRgJ8NIgkcR2rawF2e
         nel2oiBZNdFq9I+LhT/7QwvL3Thi9reuBL82YyStIi026qQ0fIpfPcI3TPLJETIvxt
         8uS5i+pyOeHAbaQ9mAwGEAcsuJtzcULNYfSIzG2Sz3/08L1ozoWG31MKKSQo9TNFcm
         j3IgBKAwXhU6g==
Date:   Tue, 10 Aug 2021 11:46:49 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jarkko Sakkinen <jarkko@kernel.org>
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
Message-ID: <YRLJmaafp941uOdA@gmail.com>
References: <20210806150928.27857-1-a.fatoum@pengutronix.de>
 <20210809094408.4iqwsx77u64usfx6@kernel.org>
 <YRGVcaquAJiuc8bp@gmail.com>
 <20210810180636.vqwaeftv7alsodgn@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210810180636.vqwaeftv7alsodgn@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 10, 2021 at 09:06:36PM +0300, Jarkko Sakkinen wrote:
> > > 
> > > I don't think this is right, or at least it does not follow the pattern
> > > in [*]. I.e. you should rather use trusted key to seal your fscrypt key.
> > 
> > What's the benefit of the extra layer of indirection over just using a "trusted"
> > key directly?  The use case for "encrypted" keys is not at all clear to me.
> 
> Because it is more robust to be able to use small amount of trusted keys,
> which are not entirely software based.
> 
> And since it's also a pattern on existing kernel features utilizing trusted
> keys, the pressure here to explain why break the pattern, should be on the
> side of the one who breaks it.

This is a new feature, so it's on the person proposing the feature to explain
why it's useful.  The purpose of "encrypted" keys is not at all clear, and the
documentation for them is heavily misleading.  E.g.:

    "user space sees, stores, and loads only encrypted blobs"
    (Not necessarily true, as I've explained previously.)

    "Encrypted keys do not depend on a trust source" ...  "The main disadvantage
    of encrypted keys is that if they are not rooted in a trusted key"
    (Not necessarily true, and in fact it seems they're only useful when they
    *do* depend on a trust source.  At least that's the use case that is being
    proposed here, IIUC.)

I do see a possible use for the layer of indirection that "encrypted" keys are,
which is that it would reduce the overhead of having lots of keys be directly
encrypted by the TPM/TEE/CAAM.  Is this the use case?  If so, it needs to be
explained.

- Eric
