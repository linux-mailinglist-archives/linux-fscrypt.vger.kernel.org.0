Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1253750C50E
	for <lists+linux-fscrypt@lfdr.de>; Sat, 23 Apr 2022 01:46:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229500AbiDVXj6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 22 Apr 2022 19:39:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230294AbiDVXjS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 22 Apr 2022 19:39:18 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC16FEA368;
        Fri, 22 Apr 2022 16:27:34 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 8E5575C02A2;
        Fri, 22 Apr 2022 19:27:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Fri, 22 Apr 2022 19:27:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1650670051; x=1650756451; bh=rJIu+Ovt6f
        P+dAw+EBOmNDStx5QJ708nxegqnirSQww=; b=s0gtDiCmGDfo1ooAcuZIZA/kzp
        ylrCaVjk+zpz/kuY6MafHCYnLesbrwndSgUnqJvvdumBQfFaSmI93Ygw5cmdG+CE
        pfMLaGy5Pf6+OFAUfzMya0J8K1MiYKVPS04tPLtLblMDLkW8Fe3GiTuwp7cQofGy
        7MYDKatx8YtgYdMjUw4m1M2FG5o0C2iqlwRQ7SmF/ARh97KZgHAZs6uLhGd9ILjL
        lZYSuJjf8hEBNffFMVuOvun9Gfrszl7ATbO6x8OsKiYwEJMZKofEhGk0o9dg1Ygl
        cZ8qicF2GPGvGCUkfYd60YmdH9cZ1gIZ3PwesoW8CEpGHoa3bZETXjBgQ2+A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1650670051; x=
        1650756451; bh=rJIu+Ovt6fP+dAw+EBOmNDStx5QJ708nxegqnirSQww=; b=w
        HG5UKy4vE9v3e9Mt1QmiDmhp+L2331GGrzHfA66ZI/Hz7VIQeA6bb0rntJr4YxaP
        5oa9yg00TnZd5XoCI/fVgPjUun81apW9PH47oTuGGF0vILfVq5EnCJAFw99e99Ji
        rKM5eH4FjKlL0Bspe+pHW8e5+8E86XhonLgP8+fu/Mmb/ZfxHbrYak7VhwvWNyfz
        w1XWSrmR/s/qyKRKbDMW+DDSQtCJ75EJrj1P1wGaUyedqpZmLZZin5LCV+Zn5IXH
        +hfoeohJ3V2Sacsr666uOqnNeX8GEcALiXyniH91rFm5ZtxW5PdiqX/vFAkdWywf
        t3StmLtqauYFoQ4tlP2Bw==
X-ME-Sender: <xms:4zljYshl9ckbzSRSiBqtmyhFmk3ebqVeDJwUgT_zjw48YByp3bG_kw>
    <xme:4zljYlAiRAPIjHVf9a6cNS_gi18RC2C1ojjJ8F2h8alxdNLPu50hxHMP3MErqAkQo
    348xG4PeE1j2wPvNhE>
X-ME-Received: <xmr:4zljYkHU9pM46LNnJBHgCN5bxxh8LPDHS3jmtM8im6kLWTYEmHHsg3lw63UB4voBLOzYdNQ3jUjSW-vn4P-FUvdMz2ucVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrtdehgddvfecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhepke
    dvkeffjeellefhveehvdejudfhjedthfdvveeiieeiudfguefgtdejgfefleejnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessg
    hurhdrihho
X-ME-Proxy: <xmx:4zljYtQxmhGwmLADUuOsTwkl6MkxTtdd7nS0RCDpI0pbbQsaoudm6g>
    <xmx:4zljYpxzHwtuyADBYyigmmVlZzfjtrS_XCHRbU371AJKGZHk-GC4Tg>
    <xmx:4zljYr79-FofUmJtcqX6zKDLqf0X0-kl--Ahufst-nCCUlzXs0v-kg>
    <xmx:4zljYh8d0PMffg1X2mRpOPCivHzMPtCdY3vdyZD7SUq_U2-JAxnwDA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 22 Apr 2022 19:27:31 -0400 (EDT)
Date:   Fri, 22 Apr 2022 16:27:29 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v8 2/5] common/verity: support btrfs in generic fsverity
 tests
Message-ID: <YmM54bCgX6Kz2XVX@zen>
References: <cover.1647461985.git.boris@bur.io>
 <9c64fbf9ad37dc84a31caf91762edd64b33d59db.1647461985.git.boris@bur.io>
 <YjN7Dc9aTD2FHTTO@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YjN7Dc9aTD2FHTTO@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Mar 17, 2022 at 06:16:45PM +0000, Eric Biggers wrote:
> On Wed, Mar 16, 2022 at 01:25:12PM -0700, Boris Burkov wrote:
> > generic/572-579 have tests for fsverity. Now that btrfs supports
> > fsverity, make these tests function as well. For a majority of the tests
> > that pass, simply adding the case to mkfs a btrfs filesystem with no
> > extra options is sufficient.
> > 
> > However, generic/574 has tests for corrupting the merkle tree itself.
> > Since btrfs uses a different scheme from ext4 and f2fs for storing this
> > data, the existing logic for corrupting it doesn't work out of the box.
> > Adapt it to properly corrupt btrfs merkle items.
> > 
> > 576 does not run because btrfs does not support transparent encryption.
> > 
> > This test relies on the btrfs implementation of fsverity in the patch:
> > btrfs: initial fsverity support
> > 
> > and on btrfs-corrupt-block for corruption in the patches titled:
> > btrfs-progs: corrupt generic item data with btrfs-corrupt-block
> > btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block
> > 
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> >  common/btrfs  |  5 +++++
> >  common/config |  1 +
> >  common/verity | 23 +++++++++++++++++++++++
> >  3 files changed, 29 insertions(+)
> 
> Reviewed-by: Eric Biggers <ebiggers@google.com>
> 
> - Eric

Eric,

Unfortunately, I think I found a more serious problem with the
compatibility of generic/574 and btrfs while working on testing the
enable/disable sysctls.

I realized that I had forgotten to customize the mount options for btrfs
to use "nodatasum" and as a result, this test was passing for btrfs
inappropriately, since we were getting EIOs for failing data checksums,
not verity checks.

I fixed the mount option issue only to realize that some of the test
cases make assumptions that don't apply to btrfs. For example:
"corruption_test 130999 131000 72"

Btrfs zeros pages past EOF in readpage before they make it to the user
via read or mmap, and the fsverity check is done at that point, so
corrupting the disk past EOF does not cause a verity failure (or get
leaked to the user) but it does cause csum failures since those are done
on bios, like verity checks in ext4. I verified that removing that
zeroing in readpage makes the test case pass.

Do you have a preference for how I might fix this? My first thought is
to try to factor out any such test cases into a new test with a new
requires clause that btrfs fails but ext4/f2fs pass, kind of like what
we did for the EFBIG test for future FSes that might not logically
address the Merkle tree in the past-EOF space.

Thanks,
Boris
