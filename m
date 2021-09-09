Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B58E3404249
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Sep 2021 02:28:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348637AbhIIA3Y (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Sep 2021 20:29:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:42330 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235458AbhIIA3Y (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Sep 2021 20:29:24 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E7E06113A;
        Thu,  9 Sep 2021 00:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631147295;
        bh=o7dDzyzTD7A48l1BiDii/W1+pWfOaNDQtuu4Ei94ivA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TXsJWGK7O3nHB7g2lB7Y3sFFAthFjm9qJ4vuVhzcWSFfDYc55JGp9tTrvbBJwcaU0
         hZCbDKKtfhugZUNTS2t0/wEFwJgWXh5jlQoqFnqfN8xCkzOVVHsqCVKkTD+uBhFbb6
         NuvzPCjJyulO236OP0B0OclqzRrLiOWcfOeb/RHNjON30aL+XUc5IQmPzPtlrW3QPz
         Caf7rF7OC2omJRcQxH4kb+sg41LakpNEBkLjo6W/Q+aqxYmbbVAjpBUCxneK/E1HDb
         3nnNoQclQZKqLPodFTSxxVDZXmJ5Yf609XKBljv0iy3PV9ey/dxMMtQIc2h0dhkf4e
         yMDLKg4lKgl0w==
Date:   Wed, 8 Sep 2021 17:28:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Aleksander Adamowski <olo@fb.com>
Cc:     "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: [fsverity-utils PATCH v2] Implement PKCS#11 opaque keys support
 through OpenSSL pkcs11 engine
Message-ID: <YTlVHtvjuCxsI0DS@gmail.com>
References: <20210828013037.2250639-1-olo@fb.com>
 <YTk806ahPPcuz9gl@gmail.com>
 <SA1PR15MB48240CCB6C38535A022ACADBDDD49@SA1PR15MB4824.namprd15.prod.outlook.com>
 <YTlL6Josq+79r/ia@gmail.com>
 <SA1PR15MB48244271F45CF01744C5074EDDD59@SA1PR15MB4824.namprd15.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <SA1PR15MB48244271F45CF01744C5074EDDD59@SA1PR15MB4824.namprd15.prod.outlook.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Sep 09, 2021 at 12:20:35AM +0000, Aleksander Adamowski wrote:
> On Wednesday, September 8, 2021 4:48 PM, Eric Biggers wrote:
> > Regarding struct libfsverity_signature_params, I wrote "Please write a comment
> > that clearly explains which parameters must be specified and when.".
> 
> Got it. I assumed that the detailed explanation in the manpage covering the
> same parameters would be sufficient, as repeating it in struct comments would
> make the information redundant and require reformatting that part to multi-line
> comments.
> 
> I can add it to the struct comments, but this will mean I'll need to change
> them to multi-line comments (above each struct member) and add empty lines
> between members (following the same commenting style as in struct
> libfsverity_merkle_tree_params). Are you okay with that change?

The fsverity.1 man page documents the fsverity tool, whereas the comments in
libfsverity.h document the interface to libfsverity.  These are different
things, so the documentation for one doesn't really apply to the other, unless
they explicitly reference each other.  (Which you can do if it would avoid
redundancy.  The point is, if the documentation is somewhere else, people
actually need to be told where to find it.)

It's fine to reformat the comments and code if necessary.

> 
> > Also I mentioned "The !OPENSSL_IS_BORINGSSL case no longer returns an error if
> > sig_params->keyfile or sig_params->certfile is unset".  That wasn't addressed
> > for sig_params->certfile.
> 
> Ah, I see. In my patch V2, after your suggestion, there's a new NULL check for
> certfile in lib/sign_digest.c:87 that I intended as a replacement for the
> previous check in lib/sign_digest.c:337. I think it's a better place for that
> check, as it's in the place of actual use.
> 
> Do you want me to place that check back in the pre-check logic in
> libfsverity_sign_digest()?

Your patch has:

	if (!certfile) {
		libfsverity_error_msg("certfile must be specified");
	}

It needs to be:

	if (!certfile) {
		libfsverity_error_msg("certfile must be specified");
		return -EINVAL;
	}

- Eric
