Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31AB64E01A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Jun 2019 07:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726121AbfFUFjd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Jun 2019 01:39:33 -0400
Received: from mail-io1-f65.google.com ([209.85.166.65]:36811 "EHLO
        mail-io1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725989AbfFUFjd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Jun 2019 01:39:33 -0400
Received: by mail-io1-f65.google.com with SMTP id h6so46979ioh.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 20 Jun 2019 22:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mELfp6zRiexEAAqmgN6eWetdKn6WzfvAuPTZHTzVDWY=;
        b=svF7VF+qCnzPwCwMCoZ+RtNCIB1W6c/EC80WLwt1DlIaQ9mlIgSqUyd8LrbJcvpAk7
         /kPVCZGWvfvbEeW4rOawCrCoDamBpdmjQ3qHOQ9vfopNyJY6YVu4m/R/PvxGSKt6s3DK
         hjKsD7ews8DXFV8COLiSZXxI609fkYzy+qTzZCpe7klu1yK6YzEuuMtz6f+2UYq73vSi
         NW1xE60yZmMXXy1e9Rnncyr0dQXgRMffhuOtaUufcrvaEysR64Cz3jiN6gp3lGeB6E6T
         gph/8QO05dZ/DIZqI7DCQworhTWlWwx+W4b7juW7Orui4vGIs2K45AHOfbXXHi16kNNS
         ymCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mELfp6zRiexEAAqmgN6eWetdKn6WzfvAuPTZHTzVDWY=;
        b=Kgi5jyYpBRPxJTtkouajdlCCmmCYD0aMPCoIpueFDXujdaCFGYqT4hCE+sM7IxmX7F
         7Fpd19wzwxu0mz2plIwmlfUSlUCs29YcZsDgO67U2mIt1e2UfwyIq0oJ4KUZfuJ84/kY
         /IYkL0NJkPqODIN7ya+6FySKnu3VUkCVTesuZjbDHzskftxPITC6q1zDv3QkjkdjG1TI
         VZiq0f79GKUwnVUccyx7G1eVs0RN232kVO1NcUavokx5OulBtEZJykQM9K7Kf85q7AP4
         ui4HXGAXzdvhaEoA51dSsJGhbQjsve5WcCeaWL6CHZVHgOO4KxymDAa8Qf0CJH3dRCUN
         nQhg==
X-Gm-Message-State: APjAAAXuedaOhdxP7NYBdQWj5ypfe+pviD5ppV7cdGxHbgxP8nud7kGw
        joIUBR2BZdPds54q4th08YJ7L+9Hb7u0R2+XbkdO0A==
X-Google-Smtp-Source: APXvYqwqwaQdBl4xxaWd9W0wXDLMctP1dBqHsxmbtoY+rcrFS2Ha4qhnpo3ck9WLvMCF2o0xS8ZfyOMWRx02fDNfqZk=
X-Received: by 2002:a02:6597:: with SMTP id u145mr9933869jab.26.1561095572685;
 Thu, 20 Jun 2019 22:39:32 -0700 (PDT)
MIME-Version: 1.0
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-2-ard.biesheuvel@linaro.org> <20190620010417.GA722@sol.localdomain>
 <20190620011325.phmxmeqnv2o3wqtr@gondor.apana.org.au> <CAKv+Gu-OwzmoYR5uymSNghEVc9xbkkt5C8MxAYA48UE=yBgb5g@mail.gmail.com>
 <20190620125339.gqup5623sw4xrsmi@gondor.apana.org.au> <CAKv+Gu_z3oMB-XBHRrNWpXNbSmb4CFC8VNn8s+8bOd-JjiakqQ@mail.gmail.com>
 <20190620134045.fncibzc7eyufd5sj@gondor.apana.org.au> <CAKv+Gu8OFbDJGoYw_DHresF5HJDSamtw1YtZ13gpOVJCYV+22Q@mail.gmail.com>
 <20190621010657.foscl7aaxlx7tfuy@gondor.apana.org.au>
In-Reply-To: <20190621010657.foscl7aaxlx7tfuy@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Fri, 21 Jun 2019 07:39:21 +0200
Message-ID: <CAKv+Gu9DuYvMA7yOTT3p75hvNHY_LOaDBE_oCdxB=SRFZ7U-kA@mail.gmail.com>
Subject: Re: [PATCH v3 1/6] crypto: essiv - create wrapper template for ESSIV generation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 21 Jun 2019 at 03:07, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Jun 20, 2019 at 03:53:45PM +0200, Ard Biesheuvel wrote:
> >
> > We'd need at least 512 and 4k for dm-crypt, but I don't think the
> > sector size is limited at all tbh
>
> In that case my preference would be to encode this into the key
> and hardware that encounters unsupported sector sizes can use a
> fallback.
>

OTOH, it also depends on what makes sense to implement in practice.

Gilad, I suppose sector size 512 is an obvious win, since the OS
always fetches at least 8 consective ones at a time. Do you see a
benefit for other sector sizes as well?
