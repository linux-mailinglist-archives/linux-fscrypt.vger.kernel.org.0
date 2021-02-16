Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1F1631D0A3
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Feb 2021 20:05:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231151AbhBPTF1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 16 Feb 2021 14:05:27 -0500
Received: from mail.kernel.org ([198.145.29.99]:49336 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229874AbhBPTFZ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 16 Feb 2021 14:05:25 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 092FF64E76;
        Tue, 16 Feb 2021 19:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613502285;
        bh=BH/T/uOJmOoOsyfso56jRG0qSv/DM//rMhmpY/Oufy4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=dwi76d7s2Rb9P9KP4KoUu3UF0fteIoxw/4Ru0wGF9BKmXXSs1neBy6PZ5SfgLsfhz
         SX7EK5scXq53crSP5pml7hXyO17S1zvL8Dq09wy7t3Ol36Hd8VSvQ9+hWeNb+o2dR2
         SKH0fbuzDL4dXSQM7wTrlHG8Zm4DSdMQ9CspnY2VxtxFX8+4pfia3TqP2DmGsd4vvs
         H8uJM2V1jri0KrOU/EGR5GfWFeo73V9pefUGB+87jgnaczn3cHlmEyIxTyBz8t4WXX
         NfD+NS9IF27dZ3pl5EmPksHSofgTn3oPtg4v8SFXaVWROcoMO+/Dic5jQb0TeS2F8A
         k7iH27FTmmeiA==
Date:   Tue, 16 Feb 2021 11:04:43 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Simo Sorce <simo@redhat.com>
Cc:     Thibaud Ecarot <thibaud.ecarot@gmail.com>,
        Jeff Layton <jlayton@redhat.com>,
        linux-fscrypt <linux-fscrypt@vger.kernel.org>
Subject: Re: fscrypt and FIPS
Message-ID: <YCwXSwseAoMdkXGG@gmail.com>
References: <c311c77131d0b146f00ab000104bd38e6fbc6b94.camel@redhat.com>
 <YCQcj0jQ5/sywDgT@sol.localdomain>
 <7fa8fc3ac6e15015df1ce5f3213e9901d98ffedd.camel@redhat.com>
 <CA+XEK3nU1jPHJ=FsJf+0rZ=KkNuuGZvo7WeBSpXUu3ytuFQEvw@mail.gmail.com>
 <45359a0121a3cb20dbdf217a1e96bd7263610913.camel@redhat.com>
 <29e4defba658cae99faccef451d7873b4cc056d9.camel@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <29e4defba658cae99faccef451d7873b4cc056d9.camel@redhat.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Feb 16, 2021 at 12:47:05PM -0500, Simo Sorce wrote:
> Some more info, sorry for the delay.
> 
> Currently, as epxlained eralier, the HKDF is approved only in specific
> cases (from SP.800-56C rev 2), which is why I asked Jeff to inquire if
> KDF agility was possible for fscrypt.
> 
> That said, we are also trying to get NIST to approve HKDF for use in
> SP800-133 covered scenarios (Symmetric Keys Derived from Pre-Existing
> Key), which is the case applicable to fscrypt (afaict).
> 
> SP.800-133 currently only allows KDFs as defined in SP.800-108, but
> there is hope that SP.800-56C rev 2 KDFs can be alloed also, after all
> they are already allowed for key-agreement schemes.
> 
> Hope this clears a bit why we inquired, it is just in case, for
> whatever reason, NIST decided not to approve or delays a decision; to
> be clear, there is nothing wrong in HKDF itself that we know of.
> 

Just getting HKDF properly approved seems like a much better approach than doing
a lot of work for nothing.  Not just for fscrypt but also for everything else
using HKDF.

- Eric
