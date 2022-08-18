Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A028598B2A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 18 Aug 2022 20:31:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345312AbiHRSaK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 18 Aug 2022 14:30:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345478AbiHRSaF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 18 Aug 2022 14:30:05 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF6A3A6C55;
        Thu, 18 Aug 2022 11:30:03 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 13C4F5C01DB;
        Thu, 18 Aug 2022 14:30:00 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Thu, 18 Aug 2022 14:30:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1660847400; x=1660933800; bh=q9xGVaPRHc
        jGOxHjsHcRXsNg0K3yKNM+JL1P6eT/+aQ=; b=DSa9Xw+LN1/9nBZQHijD0gxRlA
        48Dld5qroxxQSJwo2BH5dTteSGbv/UfDKRW6RPq4cZZnwTNWsZM1hfraAmfzXCS5
        2/qLvVKYJrjJ4jCKTGHhTRq8jMQwZMSY3InWdUIOsXONRtBwYmCq67zCAbzj/vja
        V+xPTkm7i1vtljcKE78As2wLIzHdHt9DMlSbkmsWyZN/WDHluiyD3hrgf+y0TsJz
        t0r+k0y/8GAm68d1qcJFENo3687igdHFMNcdBGPIIBYyD0F9bK2XBZyr9moOX9p+
        7KOGsy5WHbpyUVa6leHtfl7PYisUFJx7RjNUHLTFSubIRyiXf85I3B444dSw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660847400; x=1660933800; bh=q9xGVaPRHcjGOxHjsHcRXsNg0K3y
        KNM+JL1P6eT/+aQ=; b=lDaC2GYFYNFKgCkKBydGVnMtb6/3zBF7cSg6Z0pDbrFz
        Eo0X2pccyvXY4tt0w7jOoaLcRMGt0VgaTwjSwcHPUWGCaMVCXXB+GnDMPT427d6/
        7N/QV8qqZ+wuwNrfqXi/+GUdicCMl3WWB+Xq/LuijXBIlj+471fOQWc6ng8Bab5T
        axGNh+NbumrrS7YWl0+U+Z1hvAolNNTkA/CD1kaT1G4/LZPNB1smj3P6BKj0CaWo
        jhWf2ygFDufH9YKG2LJ4R/3D1jxomNvriQUV2StLfFSgaDlYvFkC1DfOn2pdfQw9
        vjEpvw3DMKIbKE3iXuvlFiY/fInPyO4+CRtAYMwQcw==
X-ME-Sender: <xms:J4X-YnRDptpp7S--FkAywlHfIdwIA1yRVRBfFQXOPpZ4N07YBEtBOA>
    <xme:J4X-YowMS4gv3xV8YqA9uy2AsmFGuoBS4Mqvq56e8XquAd8c1T8ndurz_sYmCKuA1
    _7JIcZLmX2SSLF6el8>
X-ME-Received: <xmr:J4X-Ys13qmX1epPBqCXImrYO6nN16_EAy1yF1E4EJK_JRmleROdYebYPCox1bIFPEfl6I2n8_3tNLjUpoCdzQXbzuN2zCw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehledgleelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    ekvdekffejleelhfevhedvjeduhfejtdfhvdevieeiiedugfeugfdtjefgfeeljeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhsse
    gsuhhrrdhioh
X-ME-Proxy: <xmx:J4X-YnCcFu0Vcu-KVKvJAI3-NSZcs4WRvW5jqr3tN-eopd3CKbTOQQ>
    <xmx:J4X-YggAsdbAHfHsY9p3ZO3QpkQNnJrOu61r_BIUseQjchm8p-HTxg>
    <xmx:J4X-YrrPque1Y2lkysGRhtmoYGBU4JZDqSkK_WGQrbfJ2bgSuf_V4w>
    <xmx:KIX-YjsGyVGV9e6aRPjLGL1-Bl-oF3eh5xeJBA8w8XN418tQnG-cKw>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Aug 2022 14:29:59 -0400 (EDT)
Date:   Thu, 18 Aug 2022 11:29:57 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v4] btrfs: send: add support for fs-verity
Message-ID: <Yv6FJf5Kf1dskUcz@zen>
References: <0561e8a33f991fa15053054b7b089d176fde6523.1660596577.git.boris@bur.io>
 <Yv3GssrE8hAFzGLJ@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv3GssrE8hAFzGLJ@sol.localdomain>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Aug 17, 2022 at 09:57:22PM -0700, Eric Biggers wrote:
> On Mon, Aug 15, 2022 at 01:54:28PM -0700, Boris Burkov wrote:
> > diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> > index e7671afcee4f..9e8679848d54 100644
> > --- a/fs/btrfs/send.c
> > +++ b/fs/btrfs/send.c
> > @@ -3,6 +3,7 @@
> >   * Copyright (C) 2012 Alexander Block.  All rights reserved.
> >   */
> >  
> > +#include "linux/compiler_attributes.h"
> 
> I don't understand the purpose of this include.  And why is it in quotes?

Sorry about that. I have this weird feeling that vim-lsp is "helpfully"
adding includes for me sometimes. I'll look out for it next time I send
a patch.

Thanks for the review.

> 
> Otherwise this patch looks good to me.
> 
> - Eric
