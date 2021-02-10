Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A81F5316D46
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Feb 2021 18:50:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233348AbhBJRtz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 10 Feb 2021 12:49:55 -0500
Received: from mail.kernel.org ([198.145.29.99]:49940 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233311AbhBJRtq (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 10 Feb 2021 12:49:46 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 70B4B64E7A;
        Wed, 10 Feb 2021 17:49:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1612979345;
        bh=4DLIfyCuCT7vol+PrHeiE31bFndKqD51tDoDLHL04X0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rnHrhrsA59v3aEbfpKd1lGjnyaB/8OZHHXROEgofdH+PSy38FF4cb32zve3P3MDOL
         rs4DfWr+12w+LXN4Au9JiRbZYhWqE1+bBiMlk1NmqOSPB8+WoIpiNrY8kCPG5tG6hx
         Tx1Hm2coRHcMDpshtY+vP0WprRCUijoV0/mTd/GA3Uqfd+XyIqPYne0BDhbonpF7bn
         l70HgBGY0cYoxTbznOLpEks+f3yLoL7kVIYhMvtJuBDtZL38PVpWEjhv2q4CLl+xH4
         UcI09aQzrh3+Y3BFqGISkggaytm0at7AOPecMr8QP7JCUp9pm3WlvI1g3tyXBiuCP+
         0byCl8Q63VA5w==
Date:   Wed, 10 Feb 2021 09:49:03 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jeff Layton <jlayton@redhat.com>
Cc:     linux-fscrypt <linux-fscrypt@vger.kernel.org>
Subject: Re: fscrypt and FIPS
Message-ID: <YCQcj0jQ5/sywDgT@sol.localdomain>
References: <c311c77131d0b146f00ab000104bd38e6fbc6b94.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c311c77131d0b146f00ab000104bd38e6fbc6b94.camel@redhat.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Feb 10, 2021 at 08:14:08AM -0500, Jeff Layton wrote:
> Hi Eric,
> 
> I'm still working on the ceph+fscrypt patches (it's been slow going, but
> I am making progress). Eventually RH would like to ship this as a
> feature, but there is one potential snag that  -- a lot of our customers
> need their boxes to be FIPS-enabled [1].
> 
> Most of the algorithms and implementations that fscrypt use are OK, but
> HKDF is not approved outside of TLS 1.3. The quote from our lab folks
> is:
> 
> "HKDF is not approved as a general-purpose KDF, but only for SP800-56C
> rev2 compliant use. That means that HKDF is only to be used to derive a
> key from a ECDH/DH or RSA-wrapped shared secret. This includes TLS 1.3."
> 
> Would you be amenable to allowing the KDF to be pluggable in some
> fashion, like the filename and content encryption algorithms are? It
> would be nice if we didn't have to disable this feature on FIPS-enabled
> boxes.
> 
> [1]: https://www.nist.gov/itl/fips-general-information
> 
> Thanks!
> -- 
> Jeff Layton <jlayton@redhat.com>

Can you elaborate on why you think that HKDF isn't FIPS approved?  It's been
recommended by NIST 800-56C since 2011, and almost any cryptographic application
developed within the last 10 years is likely to be using HKDF, if it needs a
non-passphrase based KDF.

In fact one of the reasons for switching from the weird AES-ECB-based KDF used
in v1 encryption policies to HKDF-SHA512 is that HKDF is much more standard.

Are you sure you're looking at the latest version of FIPS?

And if HKDF isn't approved, what *is* approved, exactly?

As far as supporting a new KDF if it were necessary, one of the reserved fields
in fscrypt_add_key_arg, fscrypt_policy_v2, fscrypt_context_v2, and
fscrypt_provisioning_key_payload could be used to specify the KDF.  This would
the first time someone has done so, so there would also be work required to add
a '--kdf' parameter to the userspace tools, and make the kernel keep track of
the keys for each KDF version separately.  Plus maybe some other things too.

I did figure that a new KDF might have to be supported eventually, but not to
replace the HKDF construction (which is provably secure), but rather if someone
wants to use something other than SHA-512 (which isn't provably secure).  I'm
not too enthusiastic about adding another KDF that uses the same underlying hash
function, as there would be no technical reason for this.

Note that the fscrypt userspace tool (https://github.com/google/fscrypt) also
uses HKDF for a key derivation step in userspace, separately from the kernel.
I suppose you'd want to change that too?

- Eric
