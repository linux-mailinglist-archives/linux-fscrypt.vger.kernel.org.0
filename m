Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697E395CCD
	for <lists+linux-fscrypt@lfdr.de>; Tue, 20 Aug 2019 13:03:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729409AbfHTLDS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 20 Aug 2019 07:03:18 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:34799 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728409AbfHTLDR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 20 Aug 2019 07:03:17 -0400
Received: by mail-wr1-f67.google.com with SMTP id s18so11947050wrn.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 20 Aug 2019 04:03:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PYetcWjVc7vdSwtXssMSvg418r+8X4MgNhcaW/l2Leo=;
        b=DOrFw9r0hM88VSDUNv4XPUF8FQuOn1Tbru5+f8U0usSQcwdLnstfltZSH0d8/CLFmW
         zsjrLaCUTr36kZ3ZqK7iCs5NCovMAMExkBSaVCCcnDZ3QhRD5ppm5x3py7r20aRfPYLQ
         zD8RCtM0hDkqSHJwbEFRadyQ4WaTLz80AjVBwFExy++q8x8CjfMjOsQ+aPd/at7qoUWL
         kfBIYyKoI+ZPDQySwrjXDAyNvt92RQqpin7+1JSxin+dPz0+H+aKxjit0PbmA5L05deo
         0XNn66WVCUU3GuTb203wcmJD2NwPmIZ/KCc5MVZZq/nOpQGwZ9m8GsFJtvEGpGD6/tth
         E7Ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PYetcWjVc7vdSwtXssMSvg418r+8X4MgNhcaW/l2Leo=;
        b=fL1sNwYtaM036RVHY8oRYlxzck8JG+6E8YyIRDTGY++IPTre+qJrmfv/KLlMfejgyL
         9B7+m40RCGM5AQ+RJVT2WsrThgy+1I/wErK/kqwFj7I2O4k1gZI6nmJKhPaFneqavV2T
         kdCIKh8OFDdBDtQjdJsAkfDo6RLSm3o9rrt5r1HsYn33OjuTEZxx7XEFGnzoL0i9CeSA
         g0vHu/Nv5tO97XzKFbRiKF/q1jZzn4f8dDvz/nv26EzJsBTfkHE0Clu+RTkZLHMNo/en
         s3ySVrmOSlgp6CunEHXt6ZCKNsYSCXrvCJPuLHH+YTAL2zYrl4Dt+f1OGMePvi+2oucS
         FNFw==
X-Gm-Message-State: APjAAAUbktTTLq3OlI4kSCzV98+dHXYes07BlLQ7pcvi3BuyEjvnmQuG
        1LmH1hYvGrbuWLvcuBtWACvG4EGuSOO/GxpnPfoDfg==
X-Google-Smtp-Source: APXvYqzvZ8hgDgAwzcvz4UxyqiwEffyiB3lMMfCJYWOzWCNzFhIU5+8kaDYYixTIzGlFuczUg/+fNNI/HFx5ihOZ5AI=
X-Received: by 2002:a05:6000:128d:: with SMTP id f13mr959362wrx.241.1566298993670;
 Tue, 20 Aug 2019 04:03:13 -0700 (PDT)
MIME-Version: 1.0
References: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
In-Reply-To: <20190819141738.1231-1-ard.biesheuvel@linaro.org>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Tue, 20 Aug 2019 14:03:02 +0300
Message-ID: <CAKv+Gu_ZoQ+mfchJMigoy32DtAMbzRU3fOZS4YjBMS-2ZMvebg@mail.gmail.com>
Subject: Re: [PATCH v13 0/6] crypto: switch to crypto API for ESSIV generation
To:     "open list:HARDWARE RANDOM NUMBER GENERATOR CORE" 
        <linux-crypto@vger.kernel.org>
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>,
        device-mapper development <dm-devel@redhat.com>,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Milan Broz <gmazyland@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 19 Aug 2019 at 17:17, Ard Biesheuvel <ard.biesheuvel@linaro.org> wrote:
>
> This series creates an ESSIV template that produces a skcipher or AEAD
> transform based on a tuple of the form '<skcipher>,<shash>' (or '<aead>,<shash>'
> for the AEAD case). It exposes the encapsulated sync or async skcipher/aead by
> passing through all operations, while using the cipher/shash pair to transform
> the input IV into an ESSIV output IV.
>
> Changes since v12:
> - don't use a per-instance shash but only record the cra_driver_name of the
>   shash when instantiating the template, and allocate the shash for each
>   allocated transform instead
> - add back the dm-crypt patch -> as Milan has indicated, his preference would
>   be to queue these changes for v5.4 (with the first patch shared between the
>   cryptodev and md trees on a stable branch based on v5.3-rc1 - if needed,
>   I can provide a signed tag)
>

Actually, since Eric has indicated that he does not want to take the
associated fscrypt change for v5.4 anyway, patch #1 could simply be
routed through the md tree instead, while the others are taken through
cryptodev.
