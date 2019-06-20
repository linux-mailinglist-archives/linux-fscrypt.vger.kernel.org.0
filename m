Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE9BA4C869
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 09:30:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725977AbfFTHaz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 03:30:55 -0400
Received: from mail-io1-f68.google.com ([209.85.166.68]:38159 "EHLO
        mail-io1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725912AbfFTHaz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 03:30:55 -0400
Received: by mail-io1-f68.google.com with SMTP id j6so650126ioa.5
        for <linux-fscrypt@vger.kernel.org>; Thu, 20 Jun 2019 00:30:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=OleUuoLJ/awB8gj1L9pb8+s5gnreN1ERy+tmQ30S79M=;
        b=lWtjdJMbHtOsAdidtW99iwblOZlLS7lxCFi7XVqidfsGH7qb6gFm1x0hpVEwGvkQTE
         5tDjTsctDn3ekC/PM5dU94f+GluSKlyWpw+2tFfWXPsqt7+tjWXTcX1dJw0lEVWkof4v
         q/DjDDZyP4UAIn9orVK4ykzsWhVqbI00cgiyENYTxVjzaJeh/SjuDVp+NSVMXVfZABb/
         J5AyKD6eEt8PVPDQvaaSAHU0DW2LxSyrANM513LYDUJb0UPwgnHhlps9GzQLPUxnrq8J
         pPFs15Q1UoAZ5/P0dWhYH4k8qRlnHusQLDrWanqHEeOdgW8c+Zmut7QSuLy7QFAn1rVE
         MwLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=OleUuoLJ/awB8gj1L9pb8+s5gnreN1ERy+tmQ30S79M=;
        b=SHK5cd6id0w4xfKyvyXkU48o7+jyEndM/rclakQ+vPn9ogdvwu67rE7UU0CAdtQB2L
         8rltNnL3XK0DePOEdQF4TjJP+ngBkXTEnXXxA5J6R7iyHhUd6a6Nhc3eXgNKNik7J9fw
         yAO0reY6bt0G6xF5oDJ4XkXa0GQ1382V0bN/aBZbOFDuYUv7tYoFRBXjtT67IVkNFXZV
         KJeLkUtIyKG2gwCCgxBbMFUMzxEk//B/7cASA34MzwgFg8J4ERssUAFnWi47i7u8H2dQ
         m79HZisWk36wYJJ1L/1JpNcJqIzEd3rLk9I1cXmS1KwSO8jcMnaNgY/knU00Gfw0pwdN
         2+sA==
X-Gm-Message-State: APjAAAXGLGecQOxAtNrZR25Bf1BBLNyk76MgN4dyPTeD7t/Xc8IT0koT
        tqG1m1e0lcEwS8mBCkVDF8Pg6xHLxLCAB7hhvRa2gw==
X-Google-Smtp-Source: APXvYqwSgQ+YlxCnDlNipKA4pfu+5Hf7BLz6A0G9Uf+9NCduJO3GV2r4HpYMlxNkkXOApFqe/S3lx05NWq74F7JQWKE=
X-Received: by 2002:a05:6602:98:: with SMTP id h24mr28401891iob.49.1561015854360;
 Thu, 20 Jun 2019 00:30:54 -0700 (PDT)
MIME-Version: 1.0
References: <20190619162921.12509-1-ard.biesheuvel@linaro.org>
 <20190619162921.12509-2-ard.biesheuvel@linaro.org> <20190620010417.GA722@sol.localdomain>
 <20190620011325.phmxmeqnv2o3wqtr@gondor.apana.org.au>
In-Reply-To: <20190620011325.phmxmeqnv2o3wqtr@gondor.apana.org.au>
From:   Ard Biesheuvel <ard.biesheuvel@linaro.org>
Date:   Thu, 20 Jun 2019 09:30:41 +0200
Message-ID: <CAKv+Gu-OwzmoYR5uymSNghEVc9xbkkt5C8MxAYA48UE=yBgb5g@mail.gmail.com>
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

On Thu, 20 Jun 2019 at 03:14, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> On Wed, Jun 19, 2019 at 06:04:17PM -0700, Eric Biggers wrote:
> >
> > > +#define ESSIV_IV_SIZE              sizeof(u64)     // IV size of the outer algo
> > > +#define MAX_INNER_IV_SIZE  16              // max IV size of inner algo
> >
> > Why does the outer algorithm declare a smaller IV size?  Shouldn't it just be
> > the same as the inner algorithm's?
>
> In general we allow outer algorithms to have distinct IV sizes
> compared to the inner algorithm.  For example, rfc4106 has a
> different IV size compared to gcm.
>
> In this case, the outer IV size is the block number so that's
> presumably why 64 bits is sufficient.  Do you forsee a case where
> we need 128-bit block numbers?
>

Indeed, the whole point of this template is that it turns a 64-bit
sector number into a n-bit IV, where n equals the block size of the
essiv cipher, and its min/max keysize covers the digest size of the
shash.

I don't think it makes sense to generalize this further, and if I
understand the feedback from Herbert and Gilad correctly, it would
even be better to define the input IV as a LE 64-bit counter
explicitly, so we can auto increment it between sectors.

But that leaves the question how to convey the sector size to the
template. Gilad suggests

essiv(cbc(aes),aes,sha256,xxx)

where xxx is the sector size, and incoming requests whose cryptlen is
an exact multiple of the sector size will have their LE counter auto
incremented between sectors. Note that we could make it optional for
now, and default to 4k, but I will at least have to parse the argument
if it is present and reject values != 4096

Is this the right approach? Or are there better ways to convey this
information when instantiating the template?
Also, it seems to me that the dm-crypt and fscrypt layers would
require major surgery in order to take advantage of this.
