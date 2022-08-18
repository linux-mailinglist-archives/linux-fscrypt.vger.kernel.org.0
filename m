Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEFA8598BFC
	for <lists+linux-fscrypt@lfdr.de>; Thu, 18 Aug 2022 20:49:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239422AbiHRSti (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 18 Aug 2022 14:49:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238851AbiHRSth (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 18 Aug 2022 14:49:37 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9821167448;
        Thu, 18 Aug 2022 11:49:36 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 061B65C0369;
        Thu, 18 Aug 2022 14:49:36 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 18 Aug 2022 14:49:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1660848576; x=1660934976; bh=3ySdJpV1XZ
        At+PUgbfOUVIheS6JYL2NC7K8b56PaHiM=; b=La9ZQG+k4FPb59cqAbWvcOCjwO
        AJLbls9Dje+YE5jXZX1gTCOl0MmKfc9M40JKmZW+IKZIeRXw+uzd5TNcT5xYuYoL
        NE5vP4bkqAzXx+4lXbTsAugjoJozXgUzZdrDQj1edpibM0VvhITiuedEpKU+f1pe
        5WXgTARB6y3Dov1++6iJQKnEVYT15GgcArzGQ9ecltUJ8ExvSd60jp/pzqV5eC3k
        WkWUimyYhV840cI+1tNVq2TAc+lhmg0Den5RnKNjuEfhIfbOKtD7k8kFj2a8/kLz
        XswrDk/XhS56Z2UzbHAuR3PM+1jVE3x1ZfZ7yN8eAoWaN89IJ4Y9gfQDJKaw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660848576; x=1660934976; bh=3ySdJpV1XZAt+PUgbfOUVIheS6JY
        L2NC7K8b56PaHiM=; b=hK5GKw1l6CCkM1vj763xrZqQLjYDdPlT/PgcBNbKxH7s
        3W3fGk+2SnVykRUWZujwUflToc7JeElRggOXWhrT0rQNdR5/VlSSRpPi3v/ZHOEI
        6MJLkMuKJhY9DZ/2XTCn91KIOzjttC+vjcVpUnkduO8J2HAYBBwH+kmsYI1Ce3u2
        OvFZVT6YmJapeSbOm/8Y3Uh3Sjyu4pHxN7BeHh54pQRZ0Z0vXDzCBvTIiPXHzk2O
        gxA5TgZ/aqzXHzFkfSzmexTVpB6uMjFz8/Mzx9xDXEqpdAYNb+OE0+CrWhIFwsqB
        4plHzXzYY32kXnDN+fmMCyX43u49CHstlZVgrP+YMw==
X-ME-Sender: <xms:v4n-YkOevTCGx4TwcMYE1Ic58EyRtKPxxHnBeJHRJvBVuWG1-_D8hw>
    <xme:v4n-Yq-wpmSvNK7M9x0PdJOSms9_KQBby7vUytSg5eXH_qRShc_U7AweZ_U15Ux8F
    4eiv7lHryTtZTph0Ag>
X-ME-Received: <xmr:v4n-YrTMajjm4Uj8xY0_w-DNFpm7_1XF1mqXkxvOkDdd6Z6IovocWAlJ472hDDPdf362HPc2MWxR8WPVLERftpkvn_C-FA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehledguddtgecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepheduveelkeeiteelveeiuefhudehtdeigfehke
    effeegledvueevgefgudeuveefnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:v4n-YstMNgy8Rb6fxqh59tYbja1JCuVny-DAT8JRV9HRnCn1xdnweQ>
    <xmx:v4n-YsfYhA1xm5PRshrDn-t1tKhllwO7ZXF487NjPpngTarfBmvXbg>
    <xmx:v4n-Yg2zrQYxS0hoEbMZUZw-1ssNGzNM8fVeRTJ7U_jOxI4lAqGm4w>
    <xmx:wIn-YtqXUeuVizcJgjgKhyU-c9qTix_HV-pkyxlGShHpGlwyEuM7eg>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Aug 2022 14:49:35 -0400 (EDT)
Date:   Thu, 18 Aug 2022 11:49:33 -0700
From:   Boris Burkov <boris@bur.io>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v4] btrfs: send: add support for fs-verity
Message-ID: <Yv6JvbDZDL/5/7Y6@zen>
References: <0561e8a33f991fa15053054b7b089d176fde6523.1660596577.git.boris@bur.io>
 <20220818173254.GN13489@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818173254.GN13489@twin.jikos.cz>
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

On Thu, Aug 18, 2022 at 07:32:54PM +0200, David Sterba wrote:
> On Mon, Aug 15, 2022 at 01:54:28PM -0700, Boris Burkov wrote:
> > Preserve the fs-verity status of a btrfs file across send/recv.
> > 
> > There is no facility for installing the Merkle tree contents directly on
> > the receiving filesystem, so we package up the parameters used to enable
> > verity found in the verity descriptor. This gives the receive side
> > enough information to properly enable verity again. Note that this means
> > that receive will have to re-compute the whole Merkle tree, similar to
> > how compression worked before encoded_write.
> > 
> > Since the file becomes read-only after verity is enabled, it is
> > important that verity is added to the send stream after any file writes.
> > Therefore, when we process a verity item, merely note that it happened,
> > then actually create the command in the send stream during
> > 'finish_inode_if_needed'.
> > 
> > This also creates V3 of the send stream format, without any format
> > changes besides adding the new commands and attributes.
> > 
> > Signed-off-by: Boris Burkov <boris@bur.io>
> 
> As for the merge target, a realistic one seems to be 6.2, we have too
> many pending patches everywhere else. There's a todo list for v3 that
> I'd really like to get done.
> 
> To be able to test things incrementally until then we can add v3 support
> under debug config.

That all sounds good and reasonable to me. Would you like me to re-send
with gating V3 behind debug, or will you do it as part of taking it?

Also, this just popped in my head, but could we acheive what we want
with the "--proto" feature of the send CLI, and having a notion of a
provisional version that is not yet hardened and properly named/fixed
for future compatibility? For extra fanciness, we can do sub-versions
or hashes of the commands or something. Maybe proto=(u64)-1 means
experimental.

Anyway, I'm totally fine with putting it behind debug till it's done,
but figured I'd share that thought.

> 
> > --
> > Changes in v4:
> > - Use btrfs_get_verity_descriptor instead of verity ops get descriptor.
> >   Move that definition to ctree.h for conditional building. This cleaned
> >   up most of the conditional building issues, in my opinion.
> 
> Yes, that way it's ok.
> 
> > - Rename process_new_verity to process_verity.
> > - Use le-to-cpu conversion for all fsverity descriptor fields.
> > - Don't check NULL for kvfree of the send descriptor.
> 
> > --- a/fs/btrfs/ctree.h
> > +++ b/fs/btrfs/ctree.h
> > --- a/fs/btrfs/send.c
> > +++ b/fs/btrfs/send.c
> > @@ -3,6 +3,7 @@
> >   * Copyright (C) 2012 Alexander Block.  All rights reserved.
> >   */
> >  
> > +#include "linux/compiler_attributes.h"
> 
> As Eric pointed out, this is not necessary, I'll delete the line, no
> need to resend just for that.
