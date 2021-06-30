Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DAA603B8050
	for <lists+linux-fscrypt@lfdr.de>; Wed, 30 Jun 2021 11:47:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234101AbhF3Jtk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Jun 2021 05:49:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234111AbhF3Jti (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Jun 2021 05:49:38 -0400
Received: from mail-wm1-x333.google.com (mail-wm1-x333.google.com [IPv6:2a00:1450:4864:20::333])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 12BB6C0617A6
        for <linux-fscrypt@vger.kernel.org>; Wed, 30 Jun 2021 02:47:10 -0700 (PDT)
Received: by mail-wm1-x333.google.com with SMTP id p10-20020a05600c430ab02901df57d735f7so3932729wme.3
        for <linux-fscrypt@vger.kernel.org>; Wed, 30 Jun 2021 02:47:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Z6oz2a6snhnXVo8MXg6uFjLMjRtla/ZcY7D6SjSAauA=;
        b=zLTi5aCbnypPB5E3aUA0ZTW2QZ9ElWO1rUMChAnrYkbnv5R1HppvSR83sz83GmhmUA
         UMxwvrtyn70Zd9AoLodBjAgPxIMvZ1UB4cERbwNt9h4ezFzozjlRXTJceovl8itCNtkO
         ZHpCXotz6yp1b1LU/oBZfpMMbHJ9z37zfQLOhI93YEXu77Z1hvbdB1hXccB0ErO3BuRM
         2v2H3xdjL56voJXkKEkXOJouofN6tE6pWAPsziIGqT+x1uxsqXS8aHT7JlV4vp9xlNdX
         RRmNLJxKm6216ZAGJ10+La1loxmhKlUG8r/gC+MQIkg6soAQE9aR2vguk2YO28brVd4+
         UeDg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Z6oz2a6snhnXVo8MXg6uFjLMjRtla/ZcY7D6SjSAauA=;
        b=C80rdf8UnNDzIpvktRdsj4mwY6GvvjLoPm3vJ7tAsSmTCoemDViQHgnYexXevOlPWz
         s0XXFj2D6QTuK6cf8kprUY3MAZihXlqj1zYy65H7I8PnufhE4cCD1mCMwPtoASEb23c0
         aGK6iK+oLf/QRwdskgofNmMCFJkzcYXGlUBWnzDipNCUf6b5N9fJdnPTlIrsQfDcK/Xb
         7SrQAzMmMF0yWxZ//JVMYVObp5gOi+iJ5iQAZEeWP5HHNZ68jTNqG64nqRp4C6IerkxG
         qG9GcfmeduiTv5dQJSgdJtfXCoL/tciUayjjsw1W4wNvRzTPQ9ZcL5UtCjTgagBv6zu1
         Hj7A==
X-Gm-Message-State: AOAM530mbUwWqRwreEhVwT6RkWmdv3xLhYTmT/lFUPkxqPXQtDwlAWpQ
        ouJWodQEoo+lKwFM0T7DgqhK/A==
X-Google-Smtp-Source: ABdhPJysgaWNsxoQ1Ekn5yIfyUpjV6tLOTWrZta/4RIlCjFmHAXWqbWe870FTEuNbqmWvtd9IqJeZQ==
X-Received: by 2002:a1c:7f4a:: with SMTP id a71mr3558850wmd.33.1625046428092;
        Wed, 30 Jun 2021 02:47:08 -0700 (PDT)
Received: from dell ([95.144.13.171])
        by smtp.gmail.com with ESMTPSA id p7sm8990839wrr.68.2021.06.30.02.47.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Jun 2021 02:47:07 -0700 (PDT)
Date:   Wed, 30 Jun 2021 10:47:05 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     Satya Tangirala <satyaprateek2357@gmail.com>
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
Message-ID: <YNw9me1Fd6Siy18A@dell>
References: <20210121230336.1373726-1-satyat@google.com>
 <CAF2Aj3jbEnnG1-bHARSt6xF12VKttg7Bt52gV=bEQUkaspDC9w@mail.gmail.com>
 <YK09eG0xm9dphL/1@google.com>
 <20210526080224.GI4005783@dell>
 <20210609024556.GA11153@fractal>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210609024556.GA11153@fractal>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, 08 Jun 2021, Satya Tangirala wrote:

> On Wed, May 26, 2021 at 09:02:24AM +0100, Lee Jones wrote:
> > On Tue, 25 May 2021, Satya Tangirala wrote:
> > 65;6200;1c
> > > On Tue, May 25, 2021 at 01:57:28PM +0100, Lee Jones wrote:
> > > > On Thu, 21 Jan 2021 at 23:06, Satya Tangirala <satyat@google.com> wrote:
> > > > 
> > > > > This patch series adds support for direct I/O with fscrypt using
> > > > > blk-crypto.
> > > > >
> > > > 
> > > > Is there an update on this set please?
> > > > 
> > > > I can't seem to find any reviews or follow-up since v8 was posted back in
> > > > January.
> > > > 
> > > This patchset relies on the block layer fixes patchset here
> > > https://lore.kernel.org/linux-block/20210325212609.492188-1-satyat@google.com/
> > > That said, I haven't been able to actively work on both the patchsets
> > > for a while, but I'll send out updates for both patchsets over the
> > > next week or so.
> > 
> > Thanks Satya, I'd appreciate that.
> FYI I sent out an updated patch series last week at
> https://lore.kernel.org/linux-fscrypt/20210604210908.2105870-1-satyat@google.com/

If you end up [RESEND]ing this or submitting another version, would
you mind adding me on Cc please?

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
