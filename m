Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5447F437A46
	for <lists+linux-fscrypt@lfdr.de>; Fri, 22 Oct 2021 17:47:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231453AbhJVPuB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 22 Oct 2021 11:50:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229484AbhJVPuB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 22 Oct 2021 11:50:01 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2463C061764;
        Fri, 22 Oct 2021 08:47:43 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id v200so7877749ybe.11;
        Fri, 22 Oct 2021 08:47:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4B2Sxn3pFr9dpJPSsVYpQ/bawvHk1JsUzzFwizQ4V+s=;
        b=MJm3TpdoyG0BKXSujIxivO2nZ4IKsfj9V+ipL6QkO0UB6Tn2fiyWbV9g2P0efYyd5s
         s9cIRFCFfvIvjc2wYOanl1hjVZI77332X1jUrlhj9alEb06jlgE7u04lnrheMSSlMGTp
         il+mGMd/p0Zl6MP6U9nU9X+Y0NL/ejlIr0kYSsDbIuVBSIvf0bVC9MC0Myu0KGFbpxOm
         t+8sX+KFOsMaTPzxR6ip2811LrMhFfljJ4Cxh1duXwS9pGW6P941WAqk92ON33i29TY5
         QYIu2w3S3aQ0MWwAiCBNeJifOSzevDD7LRn8KGRfPMzsq+eiA+loae5PzFnrF10+oQfz
         b/Og==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4B2Sxn3pFr9dpJPSsVYpQ/bawvHk1JsUzzFwizQ4V+s=;
        b=vZgr5BKfUygFT7VnuE++qD/DP0kcUyQFVJ4b77RYsT7MgPcBDPNysaNdXfCRS0deOn
         RiTQay5okxQWcUATY+k3dsAZRXlzO1phueBuUhopO5XLfMg72xuq0rT5IbLebHdMVuAw
         r2FamLsJyVuTGlcZNHgFvqaw/pBYtL1yqOeuv9ZiM0zPFb496Vv0LEI0XiBW2RqagcPK
         9+cJ+bk8Vqc+PlPHF6Lm0M6eEfO50wcjn1ir7D06RWhutbxAm8Y3NIsTA3VmvPq9l6Rh
         aYBEyj+sXzVp+S2zb7o7c/aFfK9c//ZxVXNA/SbHHsprcTyeeuWecgcxbKjCik3ijDq3
         jdBg==
X-Gm-Message-State: AOAM530PTqBiLQZ+XNjH3i27FBXlVLFNOVzV91EaOmexSDz1uKvb2HFO
        0LN1Cv49+dTXhM/kKyX3vl7ZWhpnCOdTwk/egW3wJXygtuo=
X-Google-Smtp-Source: ABdhPJww604WUYgiZANjXsreAgGpm5171zY5N0M3eiv8Q2XBoJ7jOf8znittxWM2VFPs1eOKP9y5kNblrG1mDh8/ZSk=
X-Received: by 2002:a25:ac21:: with SMTP id w33mr495733ybi.43.1634917662783;
 Fri, 22 Oct 2021 08:47:42 -0700 (PDT)
MIME-Version: 1.0
References: <YXGyq+buM79A1S0L@relinquished.localdomain>
In-Reply-To: <YXGyq+buM79A1S0L@relinquished.localdomain>
From:   Neal Gompa <ngompa13@gmail.com>
Date:   Fri, 22 Oct 2021 11:47:07 -0400
Message-ID: <CAEg-Je-r9uxAsFm427nGS+1pPJU-7Dw9NikUvZVLFvzg9PfC4Q@mail.gmail.com>
Subject: Re: Btrfs Fscrypt Design Document
To:     Omar Sandoval <osandov@osandov.com>
Cc:     Btrfs BTRFS <linux-btrfs@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org, "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, kernel-team@fb.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 21, 2021 at 2:35 PM Omar Sandoval <osandov@osandov.com> wrote:
>
> Hello,
>
> I've been working on adding fscrypt support to Btrfs. Btrfs has some
> features (namely, reflinks and snapshots) that don't work well with the
> existing fscrypt encryption policies. I've been discussing and
> prototyping how to support these Btrfs features with fscrypt, so I
> figured it was high time I write it down and loop in the fscrypt
> developers as well.
>
> Here is the Google Doc:
> https://docs.google.com/document/d/1iNnrqyZqJ2I5nfWKt7cd1T9xwU0iHhjhk9ALQ=
W3XuII/edit?usp=3Dsharing
>
> Please feel free to comment there or via email.
>

This looks great! I'm looking over it and leaving comments in the doc.


--=20
=E7=9C=9F=E5=AE=9F=E3=81=AF=E3=81=84=E3=81=A4=E3=82=82=E4=B8=80=E3=81=A4=EF=
=BC=81/ Always, there's only one truth!
