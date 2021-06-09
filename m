Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BAB63A0A2D
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Jun 2021 04:46:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235693AbhFICsI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Jun 2021 22:48:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231668AbhFICsI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Jun 2021 22:48:08 -0400
Received: from mail-oi1-x236.google.com (mail-oi1-x236.google.com [IPv6:2607:f8b0:4864:20::236])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96E0CC061574;
        Tue,  8 Jun 2021 19:46:02 -0700 (PDT)
Received: by mail-oi1-x236.google.com with SMTP id z3so23694074oib.5;
        Tue, 08 Jun 2021 19:46:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=szkL7ncrfM2hy/BvMWM0s5Huh4IFZhuvbwx23L8o1dE=;
        b=kRNocKu1gPoPbfo4iolUj+fUN0EREEirmiGidoFnX3OlcUGENGem6uJtuermuHDLWl
         6NTwsp+KT6DHNDCsSdJIcjSB2O3cYDLvKnx7AjE8sFF4f1TPUY83x51r4OB1Iv+CelCy
         REVQJkeVw8tUSiE2z/fkU4vtmyD/SdARACmZusH5g6vo3dKMJE9v7ybhtX1wBtzkXzlI
         ChJVBvgn3wklKGiXtJglbRGRQ48pfXa6RDTfcqZetBdcx2dXTrFfnvJqssiamvm+Da55
         R0dgapnLGDX/4EoCRPOZ5CcVkixn0ZJbf8wKGM+o0TrgUfzpX/WgytOvdxlIqmnNqqr5
         9ZKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=szkL7ncrfM2hy/BvMWM0s5Huh4IFZhuvbwx23L8o1dE=;
        b=Mll6tG4RtOKl0865dgXcdeYgLp91tRG03Mh8frO3EtRyrAPquelGU2vymYI1h/rtRj
         qdSmWpk6lxv5TJ/cmOVJ4f0DRw8FHOUFkgvVXAdEaATIX0Giaj7U8HezhBFHXxUySD9Y
         4xhZldMmC4r9ecmXl9SJW/Oax5fYEaJ1tauPia6mDH4JmJmyVOiqAKGaQfvEcjtIwj/R
         INVJ+peN/gktNslb/PO+kGfZAzVXKIwr/WwamfLc4Ih7pxKhF1VrNN2J11/Ps/Woz+vP
         WP2HRx4elzfop/DPqz63oJl6tXPLrpFZWorxFwfKknPieZSP8OS4dD3jGBEQV7mIzcC7
         KKEQ==
X-Gm-Message-State: AOAM530KQv31+tg2D2Y1CvWwHPhzyrMnVEvUVINcm1DlreHTBXvt/yeD
        k0nVqVGKG6SP3bLbsF99eogivJckPiCrGQ==
X-Google-Smtp-Source: ABdhPJwZLlD+UF6khW8UPly7po2FnFZ1ZDLO7TRTFA1MvABfjVFHSawElsb+ga6K3tgio2dxAtVyTg==
X-Received: by 2002:a05:6808:14d0:: with SMTP id f16mr4819978oiw.156.1623206759340;
        Tue, 08 Jun 2021 19:45:59 -0700 (PDT)
Received: from fractal ([2600:1700:1151:2380:53e3:3a03:bcf3:da13])
        by smtp.gmail.com with ESMTPSA id d136sm444959oib.4.2021.06.08.19.45.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Jun 2021 19:45:58 -0700 (PDT)
Date:   Tue, 8 Jun 2021 19:45:56 -0700
From:   Satya Tangirala <satyaprateek2357@gmail.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     Satya Tangirala <satyat@google.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        open list <linux-kernel@vger.kernel.org>,
        linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v8 0/8] add support for direct I/O with fscrypt using
 blk-crypto
Message-ID: <20210609024556.GA11153@fractal>
References: <20210121230336.1373726-1-satyat@google.com>
 <CAF2Aj3jbEnnG1-bHARSt6xF12VKttg7Bt52gV=bEQUkaspDC9w@mail.gmail.com>
 <YK09eG0xm9dphL/1@google.com>
 <20210526080224.GI4005783@dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210526080224.GI4005783@dell>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 26, 2021 at 09:02:24AM +0100, Lee Jones wrote:
> On Tue, 25 May 2021, Satya Tangirala wrote:
> 65;6200;1c
> > On Tue, May 25, 2021 at 01:57:28PM +0100, Lee Jones wrote:
> > > On Thu, 21 Jan 2021 at 23:06, Satya Tangirala <satyat@google.com> wrote:
> > > 
> > > > This patch series adds support for direct I/O with fscrypt using
> > > > blk-crypto.
> > > >
> > > 
> > > Is there an update on this set please?
> > > 
> > > I can't seem to find any reviews or follow-up since v8 was posted back in
> > > January.
> > > 
> > This patchset relies on the block layer fixes patchset here
> > https://lore.kernel.org/linux-block/20210325212609.492188-1-satyat@google.com/
> > That said, I haven't been able to actively work on both the patchsets
> > for a while, but I'll send out updates for both patchsets over the
> > next week or so.
> 
> Thanks Satya, I'd appreciate that.
FYI I sent out an updated patch series last week at
https://lore.kernel.org/linux-fscrypt/20210604210908.2105870-1-satyat@google.com/
