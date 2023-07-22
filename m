Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3169B75DDCC
	for <lists+linux-fscrypt@lfdr.de>; Sat, 22 Jul 2023 19:28:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbjGVR2x (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 22 Jul 2023 13:28:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjGVR2w (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 22 Jul 2023 13:28:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A36B1BE4;
        Sat, 22 Jul 2023 10:28:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1E96260677;
        Sat, 22 Jul 2023 17:28:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A88A8C433C8;
        Sat, 22 Jul 2023 17:28:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1690046927;
        bh=wcFmUIMjwJZeiaQDW1AaPEaA+ItdJws367HkwgwmmUU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VN+o5Idy5pxttg3qLmqjT3ZQDwejlEsk/YDPmwEg4JVpkBW9BG5iF1qOjVV7deqfj
         egq7bZcdeANBw41yh9pv8DBSybCB7AnA5CALPr1mho3NITuc8rPeGJCeqBSfmFc4t9
         rccTQGyZntOm8LWektFk7zYEtqbHbXRQALZc7p8fH17gECD0OKRWZvZ4j4WDi4E6Ov
         nLBEi8DdZObfkrmPwOhS2tQI5xuylP9dmqztcvY4RXRw5l6TL0e9pEeg5rhMKT/JYE
         /7NBdgozSt5PRBp18o//jeBdjq0Cku4UHn8XPxoREDxGRv1EmPvsFMS+uLd4WznGBM
         xATAiAn+vwZ5Q==
Date:   Sat, 22 Jul 2023 10:32:05 -0700
From:   Bjorn Andersson <andersson@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mmc@vger.kernel.org, linux-block@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, omprsing@qti.qualcomm.com,
        quic_psodagud@quicinc.com, avmenon@quicinc.com,
        abel.vesa@linaro.org, quic_spuppala@quicinc.com
Subject: Re: [PATCH v2 07/10] qcom_scm: scm call for create, prepare and
 import keys
Message-ID: <tt32ddxngmobvvqcnl7jhwtgl7l7pptdmyieidoq6hmzi3ywvi@z67jsuowq5lb>
References: <20230719170423.220033-1-quic_gaurkash@quicinc.com>
 <20230719170423.220033-8-quic_gaurkash@quicinc.com>
 <uezt2yq7i4msohz27g2j6apngjp6frvxlj2qt46vg7hnds5hrs@quyhskyzui4b>
 <20230722041113.GA5660@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230722041113.GA5660@sol.localdomain>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jul 21, 2023 at 09:11:13PM -0700, Eric Biggers wrote:
> On Fri, Jul 21, 2023 at 08:40:32PM -0700, Bjorn Andersson wrote:
> > On Wed, Jul 19, 2023 at 10:04:21AM -0700, Gaurav Kashyap wrote:
> > > Storage encryption has two IOCTLs for creating, importing
> > > and preparing keys for encryption. For wrapped keys, these
> > > IOCTLs need to interface with the secure environment, which
> > > require these SCM calls.
> > > 
> > > generate_key: This is used to generate and return a longterm
> > >               wrapped key. Trustzone achieves this by generating
> > > 	      a key and then wrapping it using hwkm, returning
> > > 	      a wrapped keyblob.
> > > import_key:   The functionality is similar to generate, but here,
> > >               a raw key is imported into hwkm and a longterm wrapped
> > > 	      keyblob is returned.
> > > prepare_key:  The longterm wrapped key from import or generate
> > >               is made further secure by rewrapping it with a per-boot
> > > 	      ephemeral wrapped key before installing it to the linux
> > > 	      kernel for programming to ICE.
> > > 
> > > Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> > > ---
> > >  drivers/firmware/qcom_scm.c            | 222 +++++++++++++++++++++++++
> > >  drivers/firmware/qcom_scm.h            |   3 +
> > >  include/linux/firmware/qcom/qcom_scm.h |  10 ++
> > >  3 files changed, 235 insertions(+)
> > > 
> > > diff --git a/drivers/firmware/qcom_scm.c b/drivers/firmware/qcom_scm.c
> > > index 51062d5c7f7b..44dd1857747b 100644
> > > --- a/drivers/firmware/qcom_scm.c
> > > +++ b/drivers/firmware/qcom_scm.c
> > > @@ -1210,6 +1210,228 @@ int qcom_scm_derive_sw_secret(const u8 *wrapped_key, u32 wrapped_key_size,
> > >  }
> > >  EXPORT_SYMBOL(qcom_scm_derive_sw_secret);
> > >  
> > > +/**
> > > + * qcom_scm_generate_ice_key() - Generate a wrapped key for encryption.
> > > + * @longterm_wrapped_key: the wrapped key returned after key generation
> > 
> > "longterm" was long enough that you didn't feel it made sense in the
> > description ;)
> > 
> > Jokes aside, please follow the convention described in:
> > https://www.kernel.org/doc/html/v4.10/process/coding-style.html#naming
> > 
> > "key" or "wrapped_key" sounds sufficient to me.
> 
> The naming I use in my most recent patchset that adds support for
> hardware-wrapped inline encryption keys to the block layer and fscrypt
> (https://lore.kernel.org/linux-block/20221216203636.81491-1-ebiggers@kernel.org/),
> which this patchset is based on, is 'lt_key' for a longterm wrapped key and
> 'eph_key' for an ephemerally-wrapped key.
> 

Excellent, using familiar names is good!

Regards,
Bjorn
