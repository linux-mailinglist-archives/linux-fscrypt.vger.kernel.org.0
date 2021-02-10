Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 725853167B3
	for <lists+linux-fscrypt@lfdr.de>; Wed, 10 Feb 2021 14:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231321AbhBJNPp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 10 Feb 2021 08:15:45 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:60397 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230043AbhBJNPl (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 10 Feb 2021 08:15:41 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1612962853;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=CGRB/XWqAq/PmGv8940jW3g7hIjMWPELA3W2C+7aV60=;
        b=GN1uAnckbaTQsKGL3px/ShTeLFyP4Ui0Iw4YeYr4U3aKUwttPmNz/c8EeBgVq1ze0Gn2TC
        ZgdU/qm1/1e53zmYp4PCPfG7Y4xtDRtJ1Re6Q5JS+Ny+iRskr5PtF2uL9rGpD+63hJWEpf
        xtOSxvcLAZ4A6hz2mPi24SRbai5Fhuo=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-134-S_H7h5HkN-2nhPYyzlL7_g-1; Wed, 10 Feb 2021 08:14:12 -0500
X-MC-Unique: S_H7h5HkN-2nhPYyzlL7_g-1
Received: by mail-qk1-f197.google.com with SMTP id f16so1467703qkk.20
        for <linux-fscrypt@vger.kernel.org>; Wed, 10 Feb 2021 05:14:12 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:user-agent
         :mime-version:content-transfer-encoding;
        bh=CGRB/XWqAq/PmGv8940jW3g7hIjMWPELA3W2C+7aV60=;
        b=ZJSuFYqk2gCNdVE6Dvtnp+8+nNBj1zcPLsTALwnGeGFjP6Vrn+Lbeu8yU5VHAD/PO0
         TxjnTl/UvXg1YdIGSGgQROunp/LVPDCC4VCvgmxcmxrjgXx7QzCLWMAPoAQOoc55S9la
         LBjvftO/3jAXACBSk324mhtdr/JSmo/cGvJ4s8CerJaueqNpIOS2viqLVAZoyMGb3DaK
         p0wwYrPl1clla2fBeodQ3dmFHAhTiFxJa4WPfg/6327CPyfzvXfKxsIPwgl7MfNpSJOb
         GV6Nu09n7fT8uKGAmiTlST/qSvjp219eDgs63jOZ7oFMpR/k5u0C7tLKidu6Bs85pXHw
         aDZw==
X-Gm-Message-State: AOAM532jbetBV54UmTkh9JYCPC4qBN6iR4S8VzNErvqZdI58g/Od2HNb
        vXvF8U3BuekuwYB5eWHivUciNjjjq9IQ6CEMfet/sqD//i+Evc0wSb1mYrD31pspy7PCEiUOrhJ
        YHnc0DfNeUj4iyvAb/tnzUM87bA==
X-Received: by 2002:a05:622a:193:: with SMTP id s19mr2624502qtw.366.1612962851063;
        Wed, 10 Feb 2021 05:14:11 -0800 (PST)
X-Google-Smtp-Source: ABdhPJwYWSbkxdvV0pnjlN9UqikY2wuWQcEHbtHwVef1UfPr2r4YQscZRKW9LosvPfcEWQ4vJjin0Q==
X-Received: by 2002:a05:622a:193:: with SMTP id s19mr2624416qtw.366.1612962849850;
        Wed, 10 Feb 2021 05:14:09 -0800 (PST)
Received: from tleilax.poochiereds.net (68-20-15-154.lightspeed.rlghnc.sbcglobal.net. [68.20.15.154])
        by smtp.gmail.com with ESMTPSA id r17sm1171934qta.78.2021.02.10.05.14.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Feb 2021 05:14:09 -0800 (PST)
Message-ID: <c311c77131d0b146f00ab000104bd38e6fbc6b94.camel@redhat.com>
Subject: fscrypt and FIPS
From:   Jeff Layton <jlayton@redhat.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt <linux-fscrypt@vger.kernel.org>
Date:   Wed, 10 Feb 2021 08:14:08 -0500
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.3 (3.38.3-1.fc33) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

I'm still working on the ceph+fscrypt patches (it's been slow going, but
I am making progress). Eventually RH would like to ship this as a
feature, but there is one potential snag that  -- a lot of our customers
need their boxes to be FIPS-enabled [1].

Most of the algorithms and implementations that fscrypt use are OK, but
HKDF is not approved outside of TLS 1.3. The quote from our lab folks
is:

"HKDF is not approved as a general-purpose KDF, but only for SP800-56C
rev2 compliant use. That means that HKDF is only to be used to derive a
key from a ECDH/DH or RSA-wrapped shared secret. This includes TLS 1.3."

Would you be amenable to allowing the KDF to be pluggable in some
fashion, like the filename and content encryption algorithms are? It
would be nice if we didn't have to disable this feature on FIPS-enabled
boxes.

[1]: https://www.nist.gov/itl/fips-general-information

Thanks!
-- 
Jeff Layton <jlayton@redhat.com>



