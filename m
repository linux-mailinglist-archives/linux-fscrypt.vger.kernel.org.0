Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C3558E46A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 15 Aug 2019 07:15:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730277AbfHOFPm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 15 Aug 2019 01:15:42 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:39465 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726008AbfHOFPm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 15 Aug 2019 01:15:42 -0400
Received: by mail-wm1-f65.google.com with SMTP id i63so281603wmg.4
        for <linux-fscrypt@vger.kernel.org>; Wed, 14 Aug 2019 22:15:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tZvl7hZAVmWv/+YDt5+Kq+rIGSJNDblM26jfYGFa+5Y=;
        b=ZKtwATa8tD6O8PODiFtAorn2s4xCi1sj40QhgWI7Dt9ueCHGTqKN3xj40Yhq9VCl0q
         hEJJ0umG9idpPvnyPM70Wy/wu2+ROGl6SdB9XfuMMSE2Bf0kFGRGa4gDLo9+TAE2zzqV
         8i+0tnQ1osbcWmUqXSnskXMbMEMUAluTGaJNOC4M8ZJf1tAkSiZ6vyAvkucEajTeowrJ
         GQV4+H+JZqvPFliqetxOAMtwGwkwBkzTtOx9EuMRqGkgKdjQ7oJS+sXGIXiHTS9GOTIL
         7nqXGPl1bJ8TWGmi4gP+N9GrfAccnzeAPlu/bpAOjh8moZgOrHOo9WL+WB9jOPbPpUlY
         ZPXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tZvl7hZAVmWv/+YDt5+Kq+rIGSJNDblM26jfYGFa+5Y=;
        b=Y7ibDz9OLGq7nNPGUSQAKCytaidYsji67tkJePr2j4qlNBR1BMqzdiUal9I6gbs2Vr
         CjNBvOCGiMROCrURDiIz2XAORtVL/1UG67/xYt1AVU2PvC3mYSv3wPnRHPSrw3DsmQk2
         r50EwkZ3VS0fJg8Rj4FqVwkdrYqRF7hVxZid3LRU5eLd7ITNmBCSbGPcQ52hdl23vYNb
         pM9KsmNG0fd4onecUi50Q7wr5kMPDb+HJuGLbHDCq8k5LYwHR1YS3xoKkaF3ynA2RcrT
         HQPX8/dLeTdiix/Znh2svPUiUPauLJ3qTSTL/zkt7t+Dl6HURp+my0ks2utknVuRU8U/
         P6cg==
X-Gm-Message-State: APjAAAXvLwhRqpB220scvuHXDk5HcR3/P4c5VTVZVXHHF12REiBDtAxd
        USma/1pFshaNj+lRuusovleEgxIeo4YTMsnGSQaCnw==
X-Google-Smtp-Source: APXvYqxSYK1gIzM7UQ19HMpn96OXM4qgebmodWy6UF/z594An7E0XMo09PI+9IgbQarmBDb87ls7X2nJ2fhMb76nvtI=
X-Received: by 2002:a05:600c:231a:: with SMTP id 26mr730899wmo.136.1565846139967;
 Wed, 14 Aug 2019 22:15:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190814163746.3525-1-ard.biesheuvel@linaro.org>
 <20190814163746.3525-2-ard.biesheuvel@linaro.org> <20190815023734.GB23782@gondor.apana.org.au>
 <CAKv+Gu_maif=kZk-HRMx7pP=ths1vuTgcu4kFpzz0tCkO2+DFA@mail.gmail.com> <20190815051320.GA24982@gondor.apana.org.au>
In-Reply-To: <20190815051320.GA24982@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 15 Aug 2019 08:15:29 +0300
Message-ID: <CAKv+Gu_OVUfXW6t+j1RHA4_Uc43o50Sspke2KkVw9djbFDd04g@mail.gmail.com>
Subject: Re: [PATCH v11 1/4] crypto: essiv - create wrapper template for ESSIV generation
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>, Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 15 Aug 2019 at 08:13, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Thu, Aug 15, 2019 at 07:59:34AM +0300, Ard Biesheuvel wrote:
> >
> > So how do I ensure that the cipher and shash are actually loaded at
> > create() time, and that they are still loaded at TFM init time?
>
> If they're not available at TFM init then you just fail the init
> and therefore the TFM allocation.  What is the problem?
>
> IOW the presence of the block cipher and unkeyed hash does not
> affect the creation of the instance object.
>

Right.

So what about checking that the cipher key size matches the shash
digest size, or that the cipher block size matches the skcipher IV
size? This all moves to the TFM init function?

Are there any existing templates that use this approach?
