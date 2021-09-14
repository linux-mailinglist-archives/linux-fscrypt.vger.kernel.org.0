Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79DDB40B700
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Sep 2021 20:34:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229946AbhINSfu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Sep 2021 14:35:50 -0400
Received: from wout2-smtp.messagingengine.com ([64.147.123.25]:44043 "EHLO
        wout2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229728AbhINSft (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Sep 2021 14:35:49 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id B3B8F32009B2;
        Tue, 14 Sep 2021 14:34:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 14 Sep 2021 14:34:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=zPRPCoCwEd+r9kLxKM6N96s6FwA
        DbcSSHKQ2YSc+spc=; b=V4bJM2FMcCfjhpBrvF6JykskKEJIlPYsyGjyOWHswAR
        mRUCFeKQtfy21hjT+KO6uUMnojdfUEy4wqN6sy2KyQdKFuR7zI4jc74HTtD7Mx+Y
        T18+G4tP9RwAfnI9n+7utbM3jW6pFtCpMcIIB+urxGs5jRbLuFQwEnyQAVkm7xXn
        rZ5iHSnjT02efcTHr9Lohiy9fvXYIGjh/oYDplCEd/RBaCJilUezSiKTcp5xfeFT
        awDzYlNg7lrLg35+fNt9gDKyF2p5vHRodcW8jEV/GO3TEQfVjTI3Qq+9i/KwvnD8
        mFME6sXVTNuY7uhQkyY/Jj28s99JmU3ach8/wUSuu3Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=zPRPCo
        CwEd+r9kLxKM6N96s6FwADbcSSHKQ2YSc+spc=; b=iSnr+Uv0zrP6S8CKlEkk0Z
        AQIcbwC6LLgbgc+EeLMTxquUPa8CmAaMBytq7SUESWGWQPofo68SyaAhITo82CSu
        7tf1BOJz1O5g2JAIcxkve+7Iu2wnrEs6K9BKu8dWmpHYeUFjl6pIg0B1//PxmQsX
        yhcEXQyBNtAcTKCQWuRs4qdXIXKcNlU2ExvBcsfN/ZthGHnuItAyd6HmKkHF0TcP
        /VpKSqmIvK+Pv/DVkc6EqD0fAodpterwnJpmi8DUq0G2aFmpE/0FJurooPJ+GzpP
        EWs+JuWyHtnBF9BWNARHRFqRwCkV2l71NzCPLC0IoMRui45p6iQrL8Upg78ATIhw
        ==
X-ME-Sender: <xms:N-tAYfFUDGE4vOMJ0uOfbkFr4bjJAHvFHnwh_e11rgymbeexjm5EvA>
    <xme:N-tAYcXMsvpjidpJgKgAOtK0yz_s66A5SY_kp6SOmgrxHL6pGa_aG6RTUX2sWLnLd
    ElWBGRvSJeZg6DvNvs>
X-ME-Received: <xmr:N-tAYRKGFvUiUNKg8uCUkVoS0eRDqp5yWVygITZxb0xBvE-ZZMGJDK898mTvCZ5Z1Io3WV7ociiLpDKbXv8nHo5knt8rig>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegledguddvfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    ehudevleekieetleevieeuhfduhedtiefgheekfeefgeelvdeuveeggfduueevfeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhsse
    gsuhhrrdhioh
X-ME-Proxy: <xmx:N-tAYdGthhDBHOdLC-SNFL6A-arIjZjfcXYd5JC0rALMWYmByHjlQg>
    <xmx:N-tAYVWMccDjuFrf_0NatbxT0zHQTxwCN9rFHWdXp0B0UT6nLEPkUw>
    <xmx:N-tAYYO6r4laEGiAGQZ3ghlzsqQehPocKzhMj0JlrVNmAtZkehE_9A>
    <xmx:N-tAYSjv3yS9JJCtriaHlbHexxHDHdrWhiFx2TYRVMjsR7-zOziUOw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 14 Sep 2021 14:34:30 -0400 (EDT)
Date:   Tue, 14 Sep 2021 11:34:29 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v6 2/3] btrfs: initial fsverity support
Message-ID: <YUDrNR+72WMno10q@zen>
References: <cover.1625083099.git.boris@bur.io>
 <797d6524e4e6386fc343cd5d0bcdd53878a6593e.1625083099.git.boris@bur.io>
 <YUDcy73zXVPneImG@sol.localdomain>
 <YUDgmgq1Q5l5e/K4@zen>
 <YUDiTFvaVZ4INJOO@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUDiTFvaVZ4INJOO@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Sep 14, 2021 at 10:56:28AM -0700, Eric Biggers wrote:
> On Tue, Sep 14, 2021 at 10:49:33AM -0700, Boris Burkov wrote:
> > On Tue, Sep 14, 2021 at 10:32:59AM -0700, Eric Biggers wrote:
> > > Hi Boris,
> > > 
> > > On Wed, Jun 30, 2021 at 01:01:49PM -0700, Boris Burkov wrote:
> > > > Add support for fsverity in btrfs. To support the generic interface in
> > > > fs/verity, we add two new item types in the fs tree for inodes with
> > > > verity enabled. One stores the per-file verity descriptor and btrfs
> > > > verity item and the other stores the Merkle tree data itself.
> > > > 
> > > > Verity checking is done in end_page_read just before a page is marked
> > > > uptodate. This naturally handles a variety of edge cases like holes,
> > > > preallocated extents, and inline extents. Some care needs to be taken to
> > > > not try to verity pages past the end of the file, which are accessed by
> > > > the generic buffered file reading code under some circumstances like
> > > > reading to the end of the last page and trying to read again. Direct IO
> > > > on a verity file falls back to buffered reads.
> > > > 
> > > > Verity relies on PageChecked for the Merkle tree data itself to avoid
> > > > re-walking up shared paths in the tree. For this reason, we need to
> > > > cache the Merkle tree data. Since the file is immutable after verity is
> > > > turned on, we can cache it at an index past EOF.
> > > > 
> > > > Use the new inode ro_flags to store verity on the inode item, so that we
> > > > can enable verity on a file, then rollback to an older kernel and still
> > > > mount the file system and read the file. Since we can't safely write the
> > > > file anymore without ruining the invariants of the Merkle tree, we mark
> > > > a ro_compat flag on the file system when a file has verity enabled.
> > > 
> > > I want to mention the btrfs verity support in
> > > Documentation/filesystems/fsverity.rst, and I have a couple questions:
> > > 
> > > 1. Is the ro_compat filesystem flag still a thing?  The commit message claims it
> > >    is, and BTRFS_FEATURE_COMPAT_RO_VERITY is defined in the code, but it doesn't
> > >    seem to actually be used.  It's not needed since you found a way to make the
> > >    inode flags ro_compat instead, right?
> > 
> > I believe it is still being used, unless I messed up the patch I sent in
> > the end. Taking a quick look, I think it's set at fs/btrfs/verity.c:558.
> > 
> > btrfs_set_fs_compat_ro(root->fs_info, VERITY);
> > 
> > I believe I still needed it because the tree checker doesn't scan every
> > inode on the filesystem when you mount, so it would only freak out about
> > a ro-compat inode later on if the inode didn't happen to be in a leaf
> > that was being checked at mount time.
> > 
> 
> Okay, so it is used.  (Due to the macro, it didn't show up when grepping.)
> 
> Doesn't it defeat the purpose of a ro_compat inode flag if the whole filesystem
> is marked with a ro_compat feature flag, though?  I thought that the point of
> the ro_compat inode flag is to allow old kernels to mount the filesystem
> read-write, with only verity files being forced to read-only.  That would be
> more flexible than ext4's implementation of fs-verity which forces the whole
> filesystem to read-only.  But it seems you're forcing the whole filesystem to
> read-only anyway?
> 
> - Eric

I was thinking of it in terms of "RO compat is the goal" and having new
inode flags totally broke that and was treated as a corruption of the
inode regardless of the fs being ro/rw. I think a check on a live fs
would just flip the fs ro, which was the goal anyway, but a check that
happened during mount would fail the mount, even for a read-only fs. 

Making it fully per file would be pretty cool! The only thing
really missing as far as I can tell is a way to mark a file read only
with the same semantics fsverity uses from within btrfs.

Boris
