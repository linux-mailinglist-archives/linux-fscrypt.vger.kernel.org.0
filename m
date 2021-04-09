Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23251359127
	for <lists+linux-fscrypt@lfdr.de>; Fri,  9 Apr 2021 03:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233162AbhDIBLi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 21:11:38 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:38333 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233149AbhDIBLi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 21:11:38 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 28EFB5C00AC;
        Thu,  8 Apr 2021 21:11:26 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 08 Apr 2021 21:11:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=DAVrKFjBtJVmRGdvA64wLKkl3Ws
        z354cO0R/lhv+pgI=; b=jypXwNNhHip5WpCbgJNOmeLJppMMZkuxxGgEPer6fYy
        W+fymk93V0WU7Xk2XVWMeLBv95fVkJVVIQdnx64tkVkWZwwM2s2ZX5eZ1pg+MYk7
        Nl2uLADIZNhXJ2BflI03vgaB3PZhqHNoZzzGs7/YlrcWGC+pbmHILdbCdUI2LPi4
        YRVMFgr2V4K1EMTlHPxTm0zqB6hSlYhIjmBjs+LBcNKAimLhtcbWkgTjQYzG9VNj
        DS/xje3ed+KWibWdU9ZQ2BHwe47Cwx7/N8IAMMVxqvCsaur3OkWLa6pOLncLz3+T
        v4W4Gdw+qYceubkxC3BmvOVIbuxxaRhYFHKJllh2kHw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=DAVrKF
        jBtJVmRGdvA64wLKkl3Wsz354cO0R/lhv+pgI=; b=klogLmtu6a/L+a56QKgHwn
        chWu68gr7VmDxqjtrc3rHp+ph48OBHYrSEg4gogotuHRRqfERnTpkP4JsLTCHxB+
        uU0II5MipRdp14uKbCbf8vukZxJIgB9XLkQepULwTHxt9aDTjAQT8HMUEMktqdAK
        zTe3LW2D6yhHo/yrVCfSvx6dSC6x5oswQWBgxy3hHN3RL9hHG+IHKD1IA3gdpw1S
        BuPCMdgQM8gWDv7unb6HFqU6/uUYeTnpg6MJdfnKM82gnJUJPA+H+HMCNajJQHkG
        DpASM99O2ENaFnqB+EUDuBpD42HG+pakZZ7xqhSFD6wKJocf/bujEKwfDFIw7NHw
        ==
X-ME-Sender: <xms:valvYDyUbwDqtxTTLroKxGCJIRgdQOwxKAY6j-LRtaSGOF91xixaVg>
    <xme:valvYLQh9mW75txkVtr7BasB2-worrYfjmYxYMj0s3dl9YLaFOqLVhTUq7n_ELNu4
    mrfQ6nLtUojtCwJpA0>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudektddggedvucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhephe
    duveelkeeiteelveeiuefhudehtdeigfehkeeffeegledvueevgefgudeuveefnecukfhp
    pedvtdejrdehfedrvdehfedrjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:valvYNVpZK1t0Ki7lm5yBzRQWAyS7AkGOLdqErqURzwEXmajpso6oA>
    <xmx:valvYNjZFZYKsPBsjTKdxwA1gk_WXe1dBfo5Hh1NGrnqEPcbHNa3CQ>
    <xmx:valvYFCVaej17eiV0sddXzyl3axnCcLp9PBp3qhgQtPZDziMQ97lbQ>
    <xmx:vqlvYIP8s4oOJtBSC-Lk7mpCXxJ8R_mkLW9FJ8yA1EPEkxWt7-L4mg>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA id ACB69240057;
        Thu,  8 Apr 2021 21:11:25 -0400 (EDT)
Date:   Thu, 8 Apr 2021 18:11:24 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 2/3] generic/574: corrupt btrfs merkle tree data
Message-ID: <YG+pvMR57hJONugk@zen>
References: <cover.1617906318.git.boris@bur.io>
 <ca320cd0c8427458828cc36d5d5168bbe6b6bab2.1617906318.git.boris@bur.io>
 <YG9OZseq1nGv/wMk@sol.localdomain>
 <YG9QQUHzoA045Ngt@zen>
 <YG+OzCaTUvp20w2/@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YG+OzCaTUvp20w2/@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Apr 08, 2021 at 04:16:28PM -0700, Eric Biggers wrote:
> On Thu, Apr 08, 2021 at 11:49:37AM -0700, Boris Burkov wrote:
> > On Thu, Apr 08, 2021 at 11:41:42AM -0700, Eric Biggers wrote:
> > > On Thu, Apr 08, 2021 at 11:30:12AM -0700, Boris Burkov wrote:
> > > > 
> > > > Note that there is a bit of a kludge here: since btrfs_corrupt_block
> > > > doesn't handle streaming corruption bytes from stdin (I could change
> > > > that, but it feels like overkill for this purpose), I just read the
> > > > first corruption byte and duplicate it for the desired length. That is
> > > > how the test is using the interface in practice, anyway.
> > > 
> > > If that's the problem, couldn't you just write the data to a temporary file?
> > 
> > Sorry, I was a bit too vague. It doesn't have a file or stdin interface,
> > as far as I know.
> > 
> > btrfs-corrupt-block has your typical "kitchen sink of flags" interface and
> > doesn't currently read input from streams/files. I extended that
> > interface in the simplest way to support arbitrary corruption, which
> > didn't fit with the stream based corruption this test does.
> > 
> > my options seem to be:
> > shoehorn the "byte, length" interface into this test or
> > shoehorn the "stream corruption input in" interface into
> > btrfs-corrupt-block.
> > 
> > I have no problem with either, the former was just less work because I
> > already wrote it that way. If the junk I did here is a deal-breaker, I
> > don't mind modifying btrfs-corrupt-block.
> > 
> 
> If it's a lot of trouble to handle arbitrary data, then I think you should
> change _fsv_scratch_corrupt_merkle_tree() to actually take a (byte, length) pair
> instead of data on stdin.  Otherwise, _fsv_scratch_corrupt_merkle_tree() would
> claim to do one thing but actually would do a different thing on one specific
> filesystem.
> 
> - Eric

It's no trouble. I think reading in corruption bytes will be a better
interface for btrfs-corrupt-block so I'll go ahead and do it.
