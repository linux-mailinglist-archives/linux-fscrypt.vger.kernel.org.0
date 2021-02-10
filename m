Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3D77B3170F1
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Feb 2021 21:14:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbhBJUOD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 10 Feb 2021 15:14:03 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:21227 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230229AbhBJUN5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 10 Feb 2021 15:13:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612987950;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=+5/q4KkbWaJxW0y9Vqi+SxrEmbHPTS66VfFtaay3Qw8=;
        b=FXBfxST3DfyK8eCtjXCqwrljkY95OET4eS8DD8Twr+uNfV7sWJHF4WaUnVfAV9N8PPfNMC
        QqvxioiYMyrczGnKtDJNboMTLa8fWK3hkY3W+VYLU5ZtbPO6PP/Rb6u4AkhE/ueENLqbtU
        lvNlxF0xfdcZ2xcAbsOGd3R7DBRTA/o=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-542-NIke8i8dP_SXgVy8Ee4X4A-1; Wed, 10 Feb 2021 15:12:26 -0500
X-MC-Unique: NIke8i8dP_SXgVy8Ee4X4A-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8D56380199B;
        Wed, 10 Feb 2021 20:12:25 +0000 (UTC)
Received: from ovpn-113-105.phx2.redhat.com (ovpn-113-105.phx2.redhat.com [10.3.113.105])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0E3675D9DC;
        Wed, 10 Feb 2021 20:12:24 +0000 (UTC)
Message-ID: <45359a0121a3cb20dbdf217a1e96bd7263610913.camel@redhat.com>
Subject: Re: fscrypt and FIPS
From:   Simo Sorce <ssorce@redhat.com>
To:     Thibaud Ecarot <thibaud.ecarot@gmail.com>,
        Jeff Layton <jlayton@redhat.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt <linux-fscrypt@vger.kernel.org>
Date:   Wed, 10 Feb 2021 15:12:24 -0500
In-Reply-To: <CA+XEK3nU1jPHJ=FsJf+0rZ=KkNuuGZvo7WeBSpXUu3ytuFQEvw@mail.gmail.com>
References: <c311c77131d0b146f00ab000104bd38e6fbc6b94.camel@redhat.com>
         <YCQcj0jQ5/sywDgT@sol.localdomain>
         <7fa8fc3ac6e15015df1ce5f3213e9901d98ffedd.camel@redhat.com>
         <CA+XEK3nU1jPHJ=FsJf+0rZ=KkNuuGZvo7WeBSpXUu3ytuFQEvw@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Very quickly,
our current assessment is that HKDF is approved to be used only within
the protocols explicitly approved in FIPS 140-3 IG and 800-135r1, which
include TLS 1.3 but not generally.

I will come back with more info an pointers asap.

Simo.

On Wed, 2021-02-10 at 15:07 -0500, Thibaud Ecarot wrote:
> Hi folks,
> 
> HKDF is widely used in various HSM so this is necessarily compliant
> with FIPS 140-3 or 140-2. I have in mind Thales Luna HSM. I am curious
> why this statement was made on your side.
> 
> Thanks Jeff.
> 
> Thibaud
> 
> 
> Le mer. 10 févr. 2021, à 14 h 30, Jeff Layton <jlayton@redhat.com> a écrit :
> > On Wed, 2021-02-10 at 09:49 -0800, Eric Biggers wrote:
> > > On Wed, Feb 10, 2021 at 08:14:08AM -0500, Jeff Layton wrote:
> > > > Hi Eric,
> > > > 
> > > > I'm still working on the ceph+fscrypt patches (it's been slow going, but
> > > > I am making progress). Eventually RH would like to ship this as a
> > > > feature, but there is one potential snag that  -- a lot of our customers
> > > > need their boxes to be FIPS-enabled [1].
> > > > 
> > > > Most of the algorithms and implementations that fscrypt use are OK, but
> > > > HKDF is not approved outside of TLS 1.3. The quote from our lab folks
> > > > is:
> > > > 
> > > > "HKDF is not approved as a general-purpose KDF, but only for SP800-56C
> > > > rev2 compliant use. That means that HKDF is only to be used to derive a
> > > > key from a ECDH/DH or RSA-wrapped shared secret. This includes TLS 1.3."
> > > > 
> > > > Would you be amenable to allowing the KDF to be pluggable in some
> > > > fashion, like the filename and content encryption algorithms are? It
> > > > would be nice if we didn't have to disable this feature on FIPS-enabled
> > > > boxes.
> > > > 
> > > > [1]: https://www.nist.gov/itl/fips-general-information
> > > > 
> > > > Thanks!
> > > > --
> > > > Jeff Layton <jlayton@redhat.com>
> > > 
> > > Can you elaborate on why you think that HKDF isn't FIPS approved?  It's been
> > > recommended by NIST 800-56C since 2011, and almost any cryptographic application
> > > developed within the last 10 years is likely to be using HKDF, if it needs a
> > > non-passphrase based KDF.
> > > 
> > > In fact one of the reasons for switching from the weird AES-ECB-based KDF used
> > > in v1 encryption policies to HKDF-SHA512 is that HKDF is much more standard.
> > > 
> > > Are you sure you're looking at the latest version of FIPS?
> > > 
> > > And if HKDF isn't approved, what *is* approved, exactly?
> > > 
> > > As far as supporting a new KDF if it were necessary, one of the reserved fields
> > > in fscrypt_add_key_arg, fscrypt_policy_v2, fscrypt_context_v2, and
> > > fscrypt_provisioning_key_payload could be used to specify the KDF.  This would
> > > the first time someone has done so, so there would also be work required to add
> > > a '--kdf' parameter to the userspace tools, and make the kernel keep track of
> > > the keys for each KDF version separately.  Plus maybe some other things too.
> > > 
> > > I did figure that a new KDF might have to be supported eventually, but not to
> > > replace the HKDF construction (which is provably secure), but rather if someone
> > > wants to use something other than SHA-512 (which isn't provably secure).  I'm
> > > not too enthusiastic about adding another KDF that uses the same underlying hash
> > > function, as there would be no technical reason for this.
> > > 
> > > Note that the fscrypt userspace tool (https://github.com/google/fscrypt) also
> > > uses HKDF for a key derivation step in userspace, separately from the kernel.
> > > I suppose you'd want to change that too?
> > > 
> > > 
> > 
> > Bah, I meant to cc Simo on this since he's the one who brought it up. I
> > know just enough to be dangerous.
> > 
> > Simo, can you answer Eric's questions, or loop in someone who can?
> > 
> > Thanks,
> > --
> > Jeff Layton <jlayton@redhat.com>
> > 
> 
> 


