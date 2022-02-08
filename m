Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1CB84AE544
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Feb 2022 00:11:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235138AbiBHXK5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Feb 2022 18:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235850AbiBHXKw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Feb 2022 18:10:52 -0500
X-Greylist: delayed 1200 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 08 Feb 2022 15:10:51 PST
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD5F0C06129A;
        Tue,  8 Feb 2022 15:10:50 -0800 (PST)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 608305C0198;
        Tue,  8 Feb 2022 17:34:47 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Tue, 08 Feb 2022 17:34:47 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=JoRj4KWGRRiDl7x/HIg/xpnWE1dDQsbDkYCgUu
        piVa0=; b=wd1s1fSKrA8BETJ2QjQ2vdhDB5CuPwalpNhJ/4LPx/Y4uWRmMAuZ5G
        Pph2S/mn0YJ/eQVu+3M8XQW7Zyvw5Yx8ZVIo+J/nTbkqZ7xbIx6+bKt05yI+2JzZ
        O0EOktEsAiEljbUNWfdXVDdtctwgkLhohzT6hcgSAbvH1T0/8QMJXeeyzyaMIFmI
        xWgGrKzuV2UfO3IsTk5N3dpVHSHEhdEuiqfZcbXPBcb45XDtUZzLOeVpWG5mNHPh
        hQ21wXgrpJjHXYhsmM6fY5DBCv5WD4rpQK3YHKBW/dJfD7JMttbwSjQU6+k6AnkN
        KcQ+0d6TsLfq1FnaLIFG49K11RA7pbYw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=JoRj4KWGRRiDl7x/H
        Ig/xpnWE1dDQsbDkYCgUupiVa0=; b=GlM2R7HBnt1AtgQH0nr4xz6zTLej54Oz/
        cfa/zdGVMdDrMaD/HR3oqbGXC/CujgK2ww5pDdlg+FQ4Cz7G5concmN7BDcSSn+D
        P8tyTdL7teREWvRpYT05J9WXAcn8w4vXGriC3s46Ww5qGiwHSUVpgBDghNqPecg5
        o5Gj0Y3wCTumiLljXOjlOeyz5tSbcTOErtfF38fD2vW9rEQXK0OsQ9WeDC3QTqs2
        f5Z2XMyOojN7oJJvliOX3hmn3g/gsWenmjpnuU9JKnYfuoi3AXxgBsmYrwxYBX8f
        j54St8s/J0hwQszTioAyGn8gOJENa2cQNCgFhzuCcPgJJKibeKsyQ==
X-ME-Sender: <xms:B_ACYtwQjlNPKnFofg9QFUni6U3QH7ToBWH7asa0YQrsGxOA0KNQCA>
    <xme:B_ACYtTxaNFiFD91DVxiNeIIfUmmtYTvtxBw_x1bhBuIuuLILP0pDyzouj2c3SYSg
    W0XSktT7KmrkLKtI7Y>
X-ME-Received: <xmr:B_ACYnXHwzEURgV2ZmCXrEGrr5Fhn4-CVfV3OV5JYk8BXIBa-FhlhU-_-ZkE8uPizuMBsxjvlcstCLWJ0crbAlSt_SQRKg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrheejgdduheekucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhephe
    duveelkeeiteelveeiuefhudehtdeigfehkeeffeegledvueevgefgudeuveefnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessg
    hurhdrihho
X-ME-Proxy: <xmx:B_ACYvh2TrDvK7BYX8E_r28VBoPny9bujbMtvVpAJr5kXewFuCaa1g>
    <xmx:B_ACYvA7L4nVc-3q6RHhtl-1k0eZSSGooLc6PqzmAMxUHqtUDlnJrA>
    <xmx:B_ACYoLBHLs8KUrGfERTHcFAsQ30G50aK-KWVJZDdG2GP99OkqyfOg>
    <xmx:B_ACYmMVV5aluu7zqoW2BLrnsFXxZiKStT-gyyaq-2weNClqklz3XA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 8 Feb 2022 17:34:46 -0500 (EST)
Date:   Tue, 8 Feb 2022 14:34:45 -0800
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v5 0/4] tests for btrfs fsverity
Message-ID: <YgLwBeFkkYK15j1+@zen>
References: <cover.1631558495.git.boris@bur.io>
 <YgHTeMETyYlatbuM@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YgHTeMETyYlatbuM@sol.localdomain>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Feb 07, 2022 at 06:20:40PM -0800, Eric Biggers wrote:
> On Mon, Sep 13, 2021 at 11:44:33AM -0700, Boris Burkov wrote:
> > This patchset provides tests for fsverity support in btrfs.
> > 
> > It includes modifications for generic tests to pass with btrfs as well
> > as new tests.
> > 
> 
> Hi Boris, there's been no activity on this patchset in a while.  Are you
> planning to keep working on it?  I'd like to see it finished so that I can start
> including btrfs in the fs-verity testing I do.

Hi Eric,

Sorry for not following through on this. I just lost momentum and got
carried off focusing on other more pressing things. I do want to get
this (and the verity kill-switch I started and abandoned...) in, and
will make time to do so soon.

Hopefully this week, but if not, then definitely next week.

Thanks for following up,
Boris

> 
> - Eric
