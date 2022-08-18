Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BC9F598CB6
	for <lists+linux-fscrypt@lfdr.de>; Thu, 18 Aug 2022 21:38:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243147AbiHRTig (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 18 Aug 2022 15:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242246AbiHRTif (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 18 Aug 2022 15:38:35 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB5AF218;
        Thu, 18 Aug 2022 12:38:31 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 6882C5C034F;
        Thu, 18 Aug 2022 15:38:30 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Thu, 18 Aug 2022 15:38:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1660851510; x=1660937910; bh=8UR0J8zJ1L
        jrrZyH8NmqHF4AKk5Fq/v8NXgw69Gnw6I=; b=P6FxC4XxgNI7WqncuE01WRxaID
        jOYilaQMfT0g9RCdHfuRMUBQVmrXsYv6MD8/qI2FnXEQDT125PjJ+CokQn8j0qL1
        PAhYRGDS0caHCVwl3xPtnnl5XN+U9mrJBvSeAF7pzzZyWCyfDwr8X7Lb9lPQIOQp
        34JoBO8qblnY6Hj54ifQ1jhxaxq7NrpkRJiWzezJubXKL4p/EUqbNAvFDpoeqfhI
        OvGNh4psy6SouH7OfdOHX2LdGgXqRnLzHAb2Hjhl44512GG+tuQbggRNe66Fm78I
        WkV2EeEbAPqKuMc5fbdepL6istNZvPS/MZahlyclFognVB/hvx3Z2BgM12Pw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm1; t=1660851510; x=1660937910; bh=8UR0J8zJ1LjrrZyH8NmqHF4AKk5F
        q/v8NXgw69Gnw6I=; b=KTygfi890PsD+nDPpk/IACeD0Y81m+WsNr9+dYAre4UD
        gp1UrUnMtm8FJEw94fLjy57i/G90w/iJPXFh1emtZDf0HjYE+/ImM3BLnf2NizPR
        hTxrZnT3PxXuExV0Xvm0OFSC7esp27yV02rcd+e1MaCOlr8GUyqjhvg+vRtgeD/G
        DLh5wF6koAX+mhwwiMikdVkXqdFbtJPMZHdjancjsi3+qQzB4F7ccduuHowo+61p
        wcngbdQwZ2BbiwbmCEH3yIqG79j2YQ5WXGTYn8h1cNqeJeJSBbqqZhJhzbO2aK4C
        sJM8q7vvihOMMUDcxdTup6ERvFhW4PcWAc2t6GMtqw==
X-ME-Sender: <xms:NpX-Yj-6p5qew4QWyxbNdAB3uMtVqY5gTjajCd5W-e2nXHhFMqG9Bg>
    <xme:NpX-YvsCySapFvAqLZuGoehkcTn8ea_LbazWoW5v5Zpw57G1GhdKdOnmtciHggjD0
    kBHz_1YcvrZ4g3t7Nk>
X-ME-Received: <xmr:NpX-YhAfCH25QVMJUJI7r0YF0dlrz3De4DYSAKJnnSEvazeFzJPIDi8tdpqDMz5GebK23qA9wN8xX5ib1A3fhD8k3_OrYQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehledguddufecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhr
    ihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnh
    epkedvkeffjeellefhveehvdejudfhjedthfdvveeiieeiudfguefgtdejgfefleejnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhish
    essghurhdrihho
X-ME-Proxy: <xmx:NpX-YvcFAVBbrNGRnE1hHL5hqikhMmZgZ-w194GSd9HOGMiANpTnXQ>
    <xmx:NpX-YoM4w-nnnLGB0Xj4IlYXx5FtE0UDh3LSK8ZEAEbh_VKvXbS0_w>
    <xmx:NpX-YhlejyBjeug-_42EXteevfr2-pV_krt5KhMOMCEm05undZ-Xog>
    <xmx:NpX-YtoNMkTQWEnh57IzK4T8Mo3RJvl7QhJEVGYEUA33NJLG_7pXCA>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Aug 2022 15:38:29 -0400 (EDT)
Date:   Thu, 18 Aug 2022 12:38:28 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@fb.com, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] fstests: add btrfs fs-verity send/recv test
Message-ID: <Yv6VNA3ZxnscnKh0@zen>
References: <9e0ee6345a406765cf06594b805cb3568de16acc.1660596985.git.boris@bur.io>
 <Yv3KJtM7L1CsIkVz@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv3KJtM7L1CsIkVz@sol.localdomain>
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

On Wed, Aug 17, 2022 at 10:12:06PM -0700, Eric Biggers wrote:
> On Mon, Aug 15, 2022 at 01:57:56PM -0700, Boris Burkov wrote:
> > diff --git a/tests/btrfs/271 b/tests/btrfs/271
> > new file mode 100755
> > index 00000000..93b34540
> > --- /dev/null
> > +++ b/tests/btrfs/271
> 
> There is already a btrfs/271, so this patch doesn't apply anymore.  Best to use
> a higher number and let the maintainer renumber the test when applying.

I thought that, but now it looks like we have btrfs/290 and 291 from the
last tests I added :/

Will fix, though!

> 
> > @@ -0,0 +1,114 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2022 YOUR NAME HERE.  All Rights Reserved.
> 
> YOUR NAME HERE is a great company to work for :-)
> 
> > +_require_test
> 
> I don't see where this uses the test filesystem; it seems to use scratch only.
> 
> > +	if [ $salt -eq 1 ]; then
> > +		extra_args+=" --salt=deadbeef"
> > +	fi
> 
> I like to use true and false for this sort of thing so you can just do:
> 
> 	if $salt; then
> 
> > +	echo "check received subvolume..."
> > +	echo 3 > /proc/sys/vm/drop_caches
> 
> A comment explaining why the drop_caches is needed would be helpful.
> And should there be a sync before it, and should it be _scratch_cycle_mount?
> 
> > +	_fsv_measure $fsv_file > $tmp.digest-after
> > +	$GETCAP_PROG $fsv_file > $tmp.cap-after
> > +	diff $tmp.digest-before $tmp.digest-after
> > +	diff $tmp.cap-before $tmp.cap-after
> > +	_scratch_unmount
> > +	echo OK
> 
> Should this compare the file's contents too?
> 
> - Eric
