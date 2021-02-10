Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A21CF317021
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Feb 2021 20:29:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232891AbhBJT3y (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 10 Feb 2021 14:29:54 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:39882 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231543AbhBJT3t (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 10 Feb 2021 14:29:49 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612985302;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=DWTgkH9mhtODl+Z26viJz6YrVg7Jfgv/azcbHy28PV4=;
        b=Ql5F1XjuTW5bgnOJm3l/hStz91TwLmoKGI+ivQd3JLztkZiID/k+IHe82gnkLmaOZTafNV
        dAtKkQfWz7bvoPh2+LQiWP0zYZeAgFh+jXySjMPGJuHlSZeY4sym6I6VYPdqvFW/rG+dEh
        V/qzDdt/hvNRDvgt+iwK56Q6zDbHw3M=
Received: from mail-qk1-f198.google.com (mail-qk1-f198.google.com
 [209.85.222.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-429-zDgdaW9lOTizPEDuqARfbA-1; Wed, 10 Feb 2021 14:28:18 -0500
X-MC-Unique: zDgdaW9lOTizPEDuqARfbA-1
Received: by mail-qk1-f198.google.com with SMTP id i5so2422111qkk.22
        for <linux-fscrypt@vger.kernel.org>; Wed, 10 Feb 2021 11:28:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=DWTgkH9mhtODl+Z26viJz6YrVg7Jfgv/azcbHy28PV4=;
        b=beCtEi9gWASpfNzGRMgdGlW9aP2sn3ygpfZbJOac1kICilDIGcPdv+vYuyucJaDqGK
         cQWiI6udQc6J3OiyILEcoRKqM9Ww+RfzgKeo0I48m3fcAjMGnB2EgeL7rgIYC5fa1Fdh
         4H5V8YLTqwXF2mO31Ba+Ze/fWHnczXLtKECitTWUXlZCjUXM5gVP0cicB3RUVAYsPpLG
         98OEoFjwR1xZQ7ndaL+Efx1+SJgIQbYBeSCpDPJH0HgbZWIhs5X2CHvPm76dSueoubib
         EkMsxCd+GJjEfxMEAlwWJOXf+HAOkRzg11l85xZbzierIL/h4LyHb+dBMN0F12G4gym6
         qZoQ==
X-Gm-Message-State: AOAM530nIM1f5RxOu8zD0pGZyvndNjojIjQkB5cPcMxHP+V4r2DtKzfb
        i/X+ijyR13VurPVOIhOK8D/hfwwhhhPRcpQrsnR3Ln4SHhObp+VYan3+vuL88RXbuefwGKb3JWc
        U8lBN+53sUJhPMoLnLx7+nQi8IA==
X-Received: by 2002:ac8:4a0b:: with SMTP id x11mr4083674qtq.147.1612985297540;
        Wed, 10 Feb 2021 11:28:17 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwW9riKEFshrqLU40msOM5UQR4vHpvHWUxcH4w+e3zs56LTmDlZ3EiW6CszHAbckiDPb9CYxQ==
X-Received: by 2002:ac8:4a0b:: with SMTP id x11mr4083652qtq.147.1612985297252;
        Wed, 10 Feb 2021 11:28:17 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id w28sm1839868qtv.93.2021.02.10.11.28.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 11:28:16 -0800 (PST)
Message-ID: <7fa8fc3ac6e15015df1ce5f3213e9901d98ffedd.camel@redhat.com>
Subject: Re: fscrypt and FIPS
From:   Jeff Layton <jlayton@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>, Simo Sorce <ssorce@redhat.com>
Cc:     linux-fscrypt <linux-fscrypt@vger.kernel.org>
Date:   Wed, 10 Feb 2021 14:28:15 -0500
In-Reply-To: <YCQcj0jQ5/sywDgT@sol.localdomain>
References: <c311c77131d0b146f00ab000104bd38e6fbc6b94.camel@redhat.com>
         <YCQcj0jQ5/sywDgT@sol.localdomain>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 2021-02-10 at 09:49 -0800, Eric Biggers wrote:
> On Wed, Feb 10, 2021 at 08:14:08AM -0500, Jeff Layton wrote:
> > Hi Eric,
> > 
> > I'm still working on the ceph+fscrypt patches (it's been slow going, but
> > I am making progress). Eventually RH would like to ship this as a
> > feature, but there is one potential snag that  -- a lot of our customers
> > need their boxes to be FIPS-enabled [1].
> > 
> > Most of the algorithms and implementations that fscrypt use are OK, but
> > HKDF is not approved outside of TLS 1.3. The quote from our lab folks
> > is:
> > 
> > "HKDF is not approved as a general-purpose KDF, but only for SP800-56C
> > rev2 compliant use. That means that HKDF is only to be used to derive a
> > key from a ECDH/DH or RSA-wrapped shared secret. This includes TLS 1.3."
> > 
> > Would you be amenable to allowing the KDF to be pluggable in some
> > fashion, like the filename and content encryption algorithms are? It
> > would be nice if we didn't have to disable this feature on FIPS-enabled
> > boxes.
> > 
> > [1]: https://www.nist.gov/itl/fips-general-information
> > 
> > Thanks!
> > -- 
> > Jeff Layton <jlayton@redhat.com>
> 
> Can you elaborate on why you think that HKDF isn't FIPS approved?  It's been
> recommended by NIST 800-56C since 2011, and almost any cryptographic application
> developed within the last 10 years is likely to be using HKDF, if it needs a
> non-passphrase based KDF.
> 
> In fact one of the reasons for switching from the weird AES-ECB-based KDF used
> in v1 encryption policies to HKDF-SHA512 is that HKDF is much more standard.
> 
> Are you sure you're looking at the latest version of FIPS?
> 
> And if HKDF isn't approved, what *is* approved, exactly?
> 
> As far as supporting a new KDF if it were necessary, one of the reserved fields
> in fscrypt_add_key_arg, fscrypt_policy_v2, fscrypt_context_v2, and
> fscrypt_provisioning_key_payload could be used to specify the KDF.  This would
> the first time someone has done so, so there would also be work required to add
> a '--kdf' parameter to the userspace tools, and make the kernel keep track of
> the keys for each KDF version separately.  Plus maybe some other things too.
> 
> I did figure that a new KDF might have to be supported eventually, but not to
> replace the HKDF construction (which is provably secure), but rather if someone
> wants to use something other than SHA-512 (which isn't provably secure).  I'm
> not too enthusiastic about adding another KDF that uses the same underlying hash
> function, as there would be no technical reason for this.
> 
> Note that the fscrypt userspace tool (https://github.com/google/fscrypt) also
> uses HKDF for a key derivation step in userspace, separately from the kernel.
> I suppose you'd want to change that too?
> 
> 

Bah, I meant to cc Simo on this since he's the one who brought it up. I
know just enough to be dangerous. 

Simo, can you answer Eric's questions, or loop in someone who can?

Thanks,
-- 
Jeff Layton <jlayton@redhat.com>

