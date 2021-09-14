Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1069A40B638
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Sep 2021 19:49:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229785AbhINRux (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Sep 2021 13:50:53 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:44351 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229526AbhINRux (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Sep 2021 13:50:53 -0400
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id 34B4F5C01C4;
        Tue, 14 Sep 2021 13:49:35 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 14 Sep 2021 13:49:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=rPjVKCsD7wTfn7nrkasUNdxNuqH
        L56Jg5drfN/Ntaos=; b=JXfv2d/TmGy2UhWZ6w5NsFIpZqQBl+po2U5JX3jdzUC
        2uM91J+1qXXt9jl8oZkWPf9LjjEngNwka4u7oFnj5wjqTtxBVuSZyNf1mk3QIaT/
        oidzhAZ38GGHi550jiFJpkmfIkLp+qo7wBc00jJABe63uH0PEm2t3L+rhkyIBycr
        TKuZDnJNyjniZyHVV9DWmRcn7cpkf/lh3oOVMTbEm1MyJkguclP4vO+gmM0aMbzN
        +um36YP6kHIMuMbk6cQTLe6xEkjpQxtOB3LqC1ZtMvBgK9bIh0S2FkpAZLNeyve0
        I898mzeU/btusZfPbf0p08qOqmk54voS63nyIQCBMXA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=rPjVKC
        sD7wTfn7nrkasUNdxNuqHL56Jg5drfN/Ntaos=; b=jgAfg+0gC3vW6Gx7a0iZqF
        8wOt7nAEW4+Rhpe/3hvrIANBL2/WzQvU9KSGiD/6wsIpdXeIZcl0hDA33c/YFULO
        Kb9BVcGMgjVLI3lVG4IZxkHClwdS5fmpnM5hDphPPdNCiqYVFDDwMwI2P8asHotp
        pQ/hRG+zX9GdbMn4zRj9Hj1C4Yl2WCt4cH/JUZNz5zExEmNr+jI6AMNEBmOxZymr
        RbbNLYL0LOSozXED2IZdqhX0/TUmHosoALjnDYRCNJqwsgIt/I/TdNpnhXTHUuvi
        KnfgRt+GdUVPpJg1nNTaSFMVcLvXkP+2QiOtmJxvfXquACH/CipS/bIn9rSlAH4A
        ==
X-ME-Sender: <xms:r-BAYaY6uaj4EjfqrFSDcZ1MZ_s6iuNleshJobfM_5EQ_Sdh3DxCiA>
    <xme:r-BAYdY4jY4r8Djk0YEd_0msyuS_ZEVFBqW5YkU0rKK6oAo6d5Rsa_6dz1icAidGh
    7en04sc2ZYxqh1R36M>
X-ME-Received: <xmr:r-BAYU_P2YMKdRQwFW3hIfZn4JxMpfq9bVAvg6PMc6mnrFad8JQZEfHjqEGN2x5u06cHt1JX57GaTjwu9LsXgje2SFoDjQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegledguddugecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    ehudevleekieetleevieeuhfduhedtiefgheekfeefgeelvdeuveeggfduueevfeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhsse
    gsuhhrrdhioh
X-ME-Proxy: <xmx:r-BAYcqqtbehn4EeTmxUHUA6G4G7CeFQ6xipmcSuA_ZNC-LzPYzHxA>
    <xmx:r-BAYVr4RkpoKLxOWr5HFgpdS7IG1VkFZIZMZS6z6z31_30jRK0OHw>
    <xmx:r-BAYaQ2N-OqhSSx-sXWJpZSG-lVGZNRcnpK3jPzcF1nyNJt_KtsTQ>
    <xmx:r-BAYc32Mi_pb_PzZJFlRs7vEvCuyRuOktdZzNEd4kElEG15d5r8iA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 13:49:34 -0400 (EDT)
Date:   Tue, 14 Sep 2021 10:49:33 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v6 2/3] btrfs: initial fsverity support
Message-ID: <YUDgmgq1Q5l5e/K4@zen>
References: <cover.1625083099.git.boris@bur.io>
 <797d6524e4e6386fc343cd5d0bcdd53878a6593e.1625083099.git.boris@bur.io>
 <YUDcy73zXVPneImG@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUDcy73zXVPneImG@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Sep 14, 2021 at 10:32:59AM -0700, Eric Biggers wrote:
> Hi Boris,
> 
> On Wed, Jun 30, 2021 at 01:01:49PM -0700, Boris Burkov wrote:
> > Add support for fsverity in btrfs. To support the generic interface in
> > fs/verity, we add two new item types in the fs tree for inodes with
> > verity enabled. One stores the per-file verity descriptor and btrfs
> > verity item and the other stores the Merkle tree data itself.
> > 
> > Verity checking is done in end_page_read just before a page is marked
> > uptodate. This naturally handles a variety of edge cases like holes,
> > preallocated extents, and inline extents. Some care needs to be taken to
> > not try to verity pages past the end of the file, which are accessed by
> > the generic buffered file reading code under some circumstances like
> > reading to the end of the last page and trying to read again. Direct IO
> > on a verity file falls back to buffered reads.
> > 
> > Verity relies on PageChecked for the Merkle tree data itself to avoid
> > re-walking up shared paths in the tree. For this reason, we need to
> > cache the Merkle tree data. Since the file is immutable after verity is
> > turned on, we can cache it at an index past EOF.
> > 
> > Use the new inode ro_flags to store verity on the inode item, so that we
> > can enable verity on a file, then rollback to an older kernel and still
> > mount the file system and read the file. Since we can't safely write the
> > file anymore without ruining the invariants of the Merkle tree, we mark
> > a ro_compat flag on the file system when a file has verity enabled.
> 
> I want to mention the btrfs verity support in
> Documentation/filesystems/fsverity.rst, and I have a couple questions:
> 
> 1. Is the ro_compat filesystem flag still a thing?  The commit message claims it
>    is, and BTRFS_FEATURE_COMPAT_RO_VERITY is defined in the code, but it doesn't
>    seem to actually be used.  It's not needed since you found a way to make the
>    inode flags ro_compat instead, right?

I believe it is still being used, unless I messed up the patch I sent in
the end. Taking a quick look, I think it's set at fs/btrfs/verity.c:558.

btrfs_set_fs_compat_ro(root->fs_info, VERITY);

I believe I still needed it because the tree checker doesn't scan every
inode on the filesystem when you mount, so it would only freak out about
a ro-compat inode later on if the inode didn't happen to be in a leaf
that was being checked at mount time.

> 
> 2. Is there a minimum version of btrfs-progs that is required to use btrfs
>    verity?  With ext4 and f2fs, the fsck tools had to be updated, so there were
>    minimum versions of the userspace tools required.

Hmm. I didn't update fsck, but now that you mention it, I think I need to...
I'll test it right away and get back to you, but I suspect I need to
hurry up and implement it.

Boris
> 
> Thanks,
> 
> - Eric
