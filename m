Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC3D4073D9
	for <lists+linux-fscrypt@lfdr.de>; Sat, 11 Sep 2021 01:26:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234835AbhIJX16 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 10 Sep 2021 19:27:58 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:53831 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234809AbhIJX15 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 10 Sep 2021 19:27:57 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 3FE8A32009EB;
        Fri, 10 Sep 2021 19:26:45 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Fri, 10 Sep 2021 19:26:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=blysUmnk2XTW/TcdYRg10520RuM
        YXczWb4Fb1H+ji+Q=; b=a6+oZwa55tSlX/+a1ck2zfg3gGmtrUTVP6SuaI+MqQP
        2RJSK7XdKUyBg+DyBy+IpdzaostZHcb/bpxu3J5ooqfZpubVI8kR60iGsO5v3XXY
        V3+obo9vHODJYzITqFbxZp/E8N4k1q0RquQSo3yS76KnWBcE3d9aFx2158lvCpIX
        L5zc/Ygak15RHkwpBlB3NbDOnN2LprLOzI1Yd4NP6acA5CXflI12cH3HabLMDqY5
        QpoVjsfHD8hPq5Oc3VlwNOwMhjZkbs6zLBK5IxERjRbejvrd3fcBbrT6f6foE+NG
        miZobD+C3eQ3+/vFUCvNVaA7FYLd1z7QRSIqCnusDyA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=blysUm
        nk2XTW/TcdYRg10520RuMYXczWb4Fb1H+ji+Q=; b=aSje/wGSO72gt2Us5+tBP0
        xu4oJT2hMqEo/JrffJyU8AU0IgkX5zeUd7Lw3I9P1j5ydL1KPchffkZUb7xBXbP8
        4VshRHDGrgl3mdWEEKMSz7BGsKa7kMEppaQOT+ZHdj6O/NyOzMRaXCvPRP/MXf49
        Spj23bwbwRSCpj+oe+gDnN06YOy3ADlsPoNxQ80tyQ5Vr8v5t5ED2TU27WRttBOu
        7ktlUsxKec4bsSw4U4NzeaxNWleHoMndwBGdzhhvDOh+4l/BI7pH92Maht1kgyKh
        pmVtTPvCXXt6Y7KrIu1tMsZeNCbIGUcmXj33vINrZHetsCHpWMFj7aEOWcgWybrg
        ==
X-ME-Sender: <xms:tOk7YQXYkyQFiWOS4gSODo6zUrQZhpeNVQqLr623yjLiPUDO0YJfIw>
    <xme:tOk7YUmUmSk3Fx2hScYtUnDhgrsD88TmNjWt3swj9xDPCjejvmSLEArJ4qaCJWd8T
    5CDpnArESmNb-w6pI4>
X-ME-Received: <xmr:tOk7YUYRSqrFXE2EhNaer8LhsvOm0LVGLwJUlX8KYWJFHX7s_cU8tGjoQlL0jo89SYxNZt_RvEefX0Yf59U4D6TJOYMFQw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegvddgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhephe
    duveelkeeiteelveeiuefhudehtdeigfehkeeffeegledvueevgefgudeuveefnecuvehl
    uhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessg
    hurhdrihho
X-ME-Proxy: <xmx:tOk7YfWqefIZ6hDP8z53dgjyIY9xC0tKSpQ1u9jdH_Tri63qotKmKw>
    <xmx:tOk7YamshdnAQHixhZ85tzlwhBDhwSW5X78i4CSi31tg4OrWXX4lww>
    <xmx:tOk7YUf2vPF7aDma20Dq0vUBdsKra0yV3vf8Fw-YVhQKpp9dR4dC4w>
    <xmx:tOk7Ycg9PR3izqXkUfY66gJoZM1O-EiK_ViM2w18EV04HV9-W8NhzA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 10 Sep 2021 19:26:44 -0400 (EDT)
Date:   Fri, 10 Sep 2021 16:26:42 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 4/4] generic: test fs-verity EFBIG scenarios
Message-ID: <YTvpsib6hrp/9ZPY@zen>
References: <cover.1620248200.git.boris@bur.io>
 <508058f805a45808764a477e9ad04353a841cf53.1620248200.git.boris@bur.io>
 <YK1c62bh1WQ/h45O@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YK1c62bh1WQ/h45O@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, May 25, 2021 at 01:24:11PM -0700, Eric Biggers wrote:
> On Wed, May 05, 2021 at 02:04:46PM -0700, Boris Burkov wrote:
> > diff --git a/tests/generic/632 b/tests/generic/632
> > new file mode 100755
> > index 00000000..5a5ed576
> > --- /dev/null
> > +++ b/tests/generic/632
> > @@ -0,0 +1,86 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2021 Facebook, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test 632
> > +#
> > +# Test some EFBIG scenarios with very large files.
> > +# To create the files, use pwrite with an offset close to the
> > +# file system's max file size.
> 
> Can you please make this comment properly describe the purpose of this test?
> As-is it doesn't mention that it is related to fs-verity at all, let alone to
> specific filesystems' implementations of fs-verity.

Sorry for disappearing on this one for a while.

Oops, good point. In addressing your and Eryu's points, I realized that
this isn't really a generic test, since as you say, it assumes the
filesystem's implementation. Further, I think it is plausible for an fs
to cache the Merkle tree pages some other way which wouldn't need to
EFBIG for large files. With that said, I do think it's a useful test of
an edge case I got wrong several times in the btrfs implementation.

I am leaning towards making this a btrfs specific test. Just wanted to
double check with you if you think ext4 and f2fs would benefit from
running this test too..

> 
> > +max_sz=$(_get_max_file_size)
> > +_fsv_scratch_begin_subtest "way too big: fail on first merkle block"
> > +# have to go back by 4096 from max to not hit the fsverity MAX_DEPTH check.
> 
> What is meant by the "fsverity MAX_DEPTH" check?

If you use $max_sz or $max_sz-1 (or anything bigger than $max_sz-4096)
the vfs fsverity code will conclude the tree will exceed MAX_LEVELS. I
got LEVELS and DEPTH mixed up.

> 
> > +$XFS_IO_PROG -fc "pwrite -q $(($max_sz - 4096)) 1" $fsv_file
> > +_fsv_enable $fsv_file |& _filter_scratch
> 
> Using the "truncate" xfs_io command instead of "pwrite" would probably make more
> sense here, as the goal is to just create a file of a specific size.

In my memory, truncate didn't work for btrfs, but it took me a while to
get this to work, so I might have made some silly mistake early on with
truncate. I'll try again to be sure.

> 
> > +
> > +# The goal of this second test is to make a big enough file that we trip the
> > +# EFBIG codepath, but not so big that we hit it immediately as soon as we try
> > +# to write a Merkle leaf. Because of the layout of the Merkle tree that
> > +# fs-verity uses, this is a bit complicated to compute dynamically.
> > +
> > +# The layout of the Merkle tree has the leaf nodes last, but writes them first.
> > +# To get an interesting overflow, we need the start of L0 to be < MAX but the
> > +# end of the merkle tree (EOM) to be past MAX. Ideally, the start of L0 is only
> > +# just smaller than MAX, so that we don't have to write many blocks to blow up.
> > +
> > +# 0                        EOF round-to-64k L7L6L5 L4   L3    L2    L1  L0 MAX  EOM
> > +# |-------------------------|               ||-|--|---|----|-----|------|--|!!!!!|
> > +
> > +# Given this structure, we can compute the size of the file that yields the
> > +# desired properties:
> > +# sz + 64k + sz/128^8 + sz/128^7 + ... + sz/128^2 < MAX
> > +# (128^8)sz + (128^8)64k + sz + (128)sz + (128^2)sz + ... + (128^6)sz < (128^8)MAX
> > +# sz(128^8 + 128^6 + 128^5 + 128^4 + 128^3 + 128^2 + 128 + 1) < (128^8)(MAX - 64k)
> > +# sz < (128^8/(128^8 + (128^6 + ... 1))(MAX - 64k)
> > +#
> > +# Do the actual caclulation with 'bc' and 20 digits of precision.
> 
> This calculation isn't completely accurate because it doesn't round the levels
> to a block boundary.  Nor does it consider that the 64K is an alignment rather
> than a fixed amount added.
> 
> But for the test you don't need the absolute largest file whose level 1 doesn't
> exceed the limit, but rather just one almost that large.
> 
> So it would be okay to add 64K as a fixed amount, along with 4K for every level
> on top of the 'sz/128^(level+1)' you already have, to get an over-estimate of
> the amount of extra space needed to cache the Merkle tree.
> 
> But please make it clear that it's an over-estimate, and hence an under-estimate
> of the file size desired for the test.
> 
> Also please document that this is all assuming SHA-256 with 4K blocks, and also
> that the maximum file size is assumed to fit in 64 bits; hence the consideration
> of 8 levels is sufficient.

Agreed with all of this, will do.

> 
> - Eric
