Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B9A93E8263
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Aug 2021 20:07:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234023AbhHJSH1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Aug 2021 14:07:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:41000 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239360AbhHJSFK (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Aug 2021 14:05:10 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1E0756044F;
        Tue, 10 Aug 2021 18:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1628618573;
        bh=CliTSJM3KgHfirPfmC/pFeaaa3Zs4kVGiq7MtSbj8lg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Qa5ffquXhY7PmT28/lxox3tcAtLD+RlXr+lLx0Sa9LdTuvzvQaaKVXyyYKBlUyGZc
         RJf8tUO8K0Iukb717vDRMamLTLOYSighxonSn8xfFQgMNxUCBgNuM8LHpqKraQyPsT
         VeGnikeqL4dzmbT0tJ09SG/01gLAYbnNmHLCnbj/TSnSWuxVc/qeMG8F/SutX6AKYh
         2AnjdvGDVnhMgCJFO7HWT4EXgBmH9OuQzb+nv133npaTvLv9LaKpAJoHHcRKllywzz
         X/fBK7Us9da2+o4zY8xUJQ+vOssg5ti9M7vA5dxUCWARzkSbxOrGnPAP6IUfcKmOMv
         /PPcYeH4wFozQ==
Date:   Tue, 10 Aug 2021 21:02:51 +0300
From:   Jarkko Sakkinen <jarkko@kernel.org>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, kernel@pengutronix.de,
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
Message-ID: <20210810180251.vwxxcoeivnwfxxtd@kernel.org>
References: <20210806150928.27857-1-a.fatoum@pengutronix.de>
 <20210809094408.4iqwsx77u64usfx6@kernel.org>
 <10dac5c6-4530-217c-e1ea-a7e2e3572f43@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <10dac5c6-4530-217c-e1ea-a7e2e3572f43@pengutronix.de>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 09, 2021 at 12:00:40PM +0200, Ahmad Fatoum wrote:
> Hello Jarkko,
> 
> On 09.08.21 11:44, Jarkko Sakkinen wrote:
> > On Fri, Aug 06, 2021 at 05:09:28PM +0200, Ahmad Fatoum wrote:
> >> Kernel trusted keys don't require userspace knowledge of the raw key
> >> material and instead export a sealed blob, which can be persisted to
> >> unencrypted storage. Userspace can then load this blob into the kernel,
> >> where it's unsealed and from there on usable for kernel crypto.
> >>
> >> This is incompatible with fscrypt, where userspace is supposed to supply
> >> the raw key material. For TPMs, a work around is to do key unsealing in
> >> userspace, but this may not be feasible for other trusted key backends.
> >>
> >> Make it possible to benefit from both fscrypt and trusted key sealing
> >> by extending fscrypt_add_key_arg::key_id to hold either the ID of a
> >> fscrypt-provisioning or a trusted key.
> >>
> >> A non fscrypt-provisioning key_id was so far prohibited, so additionally
> >> allowing trusted keys won't break backwards compatibility.
> >>
> >> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
> >> ---
> >> Tested with:
> >> https://github.com/google/fscryptctl/pull/23
> >> -	if (key->type != &key_type_fscrypt_provisioning)
> >> -		goto bad_key;
> >> -	payload = key->payload.data[0];
> >> +	if (key->type == &key_type_fscrypt_provisioning) {
> > 
> > Why does fscrypt have own key type, and does not extend 'encrypted' with a
> > new format [*]?
> 
> See the commit[1] adding it for more information. TL;DR:
> 
> fscrypt maintainers would've preferred keys to be associated with
> a "domain". So an encrypted key generated for fscrypt use couldn't be reused
> for e.g. dm-crypt. They are wary of fscrypt users being more exposed if their
> keys can be used with weaker ciphers via other kernel functionality that could
> be used to extract information about the raw key material.
> 
> Eric also mentioned dislike of the possibility of rooting encrypted keys to
> user keys. v2 is only restricted to v2, so we didn't discuss this further.
> 
> Restricting the key to fscrypt-only precludes this reuse.
> 
> My commit makes no attempts in changing that. It just adds a new way to pass
> raw key material into fscrypt. For more information, see the commit[1] adding
> that key type.
> 
> > [*] https://www.kernel.org/doc/html/v5.13/security/keys/trusted-encrypted.html
> 
> [1]: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=93edd392ca

OK, so why does the trusted key does not seal a fscrypt key, but instead
its key material is directly used?

> Cheers,
> Ahmad

/Jarkko
