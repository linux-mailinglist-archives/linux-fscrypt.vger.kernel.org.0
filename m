Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5797375D993
	for <lists+linux-fscrypt@lfdr.de>; Sat, 22 Jul 2023 06:11:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229887AbjGVELS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 22 Jul 2023 00:11:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229529AbjGVELR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 22 Jul 2023 00:11:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 98A462D58;
        Fri, 21 Jul 2023 21:11:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2212C6093C;
        Sat, 22 Jul 2023 04:11:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3196CC433C7;
        Sat, 22 Jul 2023 04:11:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1689999075;
        bh=vEMCopt3uphHxQCeixFe3W9oElfAQnJtSfNsi9hH+28=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=J4fjj57UD+LMoJ+P3xBynwk/zSZ2OjmKdRpMgoDOAHDuJH3iaI9FK3HPNEtEmLiiq
         dXNeRHwJx2mh5fVIJEgfegdnLRtN9Usc8i88k5WOUTwWw4xCkrbxbYDYKHOC7XJEXZ
         7gxT3WUjdve71uo6IBtN3H/zCyt6OXOZrtJP+mSUGJRIQoqMsoO6/Ue3tCpE+Rvr1u
         Tf6lK1JMdecxBY+PXNU0LrKFxVICPq32NK+e3ZvtsJ2AS8HMVgXp/HV1ZjYAPcKDeG
         FQPvwkAaKEvp1NGJhX1SWRfuHHCEHY3Mqg943A2mkpvFnmbOg9tyHY68bGuqDIVcSR
         eFpjnD01S2BNw==
Date:   Fri, 21 Jul 2023 21:11:13 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Bjorn Andersson <andersson@kernel.org>
Cc:     Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, omprsing@qti.qualcomm.com,
        quic_psodagud@quicinc.com, avmenon@quicinc.com,
        abel.vesa@linaro.org, quic_spuppala@quicinc.com
Subject: Re: [PATCH v2 07/10] qcom_scm: scm call for create, prepare and
 import keys
Message-ID: <20230722041113.GA5660@sol.localdomain>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <20230719170423.220033-8-quic_gaurkash@quicinc.com>
 <uezt2yq7i4msohz27g2j6apngjp6frvxlj2qt46vg7hnds5hrs@quyhskyzui4b>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <uezt2yq7i4msohz27g2j6apngjp6frvxlj2qt46vg7hnds5hrs@quyhskyzui4b>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jul 21, 2023 at 08:40:32PM -0700, Bjorn Andersson wrote:
> On Wed, Jul 19, 2023 at 10:04:21AM -0700, Gaurav Kashyap wrote:
> > Storage encryption has two IOCTLs for creating, importing
> > and preparing keys for encryption. For wrapped keys, these
> > IOCTLs need to interface with the secure environment, which
> > require these SCM calls.
> > 
> > generate_key: This is used to generate and return a longterm
> >               wrapped key. Trustzone achieves this by generating
> > 	      a key and then wrapping it using hwkm, returning
> > 	      a wrapped keyblob.
> > import_key:   The functionality is similar to generate, but here,
> >               a raw key is imported into hwkm and a longterm wrapped
> > 	      keyblob is returned.
> > prepare_key:  The longterm wrapped key from import or generate
> >               is made further secure by rewrapping it with a per-boot
> > 	      ephemeral wrapped key before installing it to the linux
> > 	      kernel for programming to ICE.
> > 
> > Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> > ---
> >  drivers/firmware/qcom_scm.c            | 222 +++++++++++++++++++++++++
> >  drivers/firmware/qcom_scm.h            |   3 +
> >  include/linux/firmware/qcom/qcom_scm.h |  10 ++
> >  3 files changed, 235 insertions(+)
> > 
> > diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
> > index 51062d5c7f7b..44dd1857747b 100644
> > --- a/drivers/firmware/qcom_scm.c
> > +++ b/drivers/firmware/qcom_scm.c
> > @@ -1210,6 +1210,228 @@ int qcom_scm_derive_sw_secret(const u8 *wrapped_key, u32 wrapped_key_size,
> >  }
> >  EXPORT_SYMBOL(qcom_scm_derive_sw_secret);
> >  
> > +/**
> > + * qcom_scm_generate_ice_key() - Generate a wrapped key for encryption.
> > + * @longterm_wrapped_key: the wrapped key returned after key generation
> 
> "longterm" was long enough that you didn't feel it made sense in the
> description ;)
> 
> Jokes aside, please follow the convention described in:
> https://www.kernel.org/doc/html/v4.10/process/coding-style.html#naming
> 
> "key" or "wrapped_key" sounds sufficient to me.

The naming I use in my most recent patchset that adds support for
hardware-wrapped inline encryption keys to the block layer and fscrypt
(https://lore.kernel.org/linux-block/20221216203636.81491-1-ebiggers@kernel.org/),
which this patchset is based on, is 'lt_key' for a longterm wrapped key and
'eph_key' for an ephemerally-wrapped key.

> > +int qcom_scm_prepare_ice_key(const u8 *longterm_wrapped_key,
> > +			     u32 longterm_wrapped_key_size,
> > +			     u8 *ephemeral_wrapped_key,
> > +			     u32 ephemeral_wrapped_key_size)
> 
> wrapped, wrapped_size, ephemeral, ephemeral_size perhaps?

lt_key, lt_key_size, eph_key, eph_key_size.

- Eric
