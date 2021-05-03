Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 99FCC371FDB
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 May 2021 20:46:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbhECSrN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 3 May 2021 14:47:13 -0400
Received: from wout1-smtp.messagingengine.com ([64.147.123.24]:47821 "EHLO
        wout1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229520AbhECSrM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 3 May 2021 14:47:12 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.west.internal (Postfix) with ESMTP id 5AC4820D9;
        Mon,  3 May 2021 14:46:18 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 03 May 2021 14:46:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=4Ses/utxDL3oIDwD2o1wOuufQ4w
        zqGtxnXGhfxM/Qyo=; b=Sasn6jHsPsG+lm0yaRKJbmkOVViGUmOksF9AVyTTpt3
        BBQIfLv5U7bi6TPeKDLMDozvHlJTvwYds3mCu3fSSaSvYRHujeF6On4napSBzFYC
        gX5ET+pYrjyGhSPunM0y44LbdZE+2bFMRS/y2i7ccQQhDXDSMypIQRf6fWpdsCyY
        K1MBJmFClaZQ7UXhGAtLw5HPfbUxHWDOFT4nVpot72sOAFcvwg7owXCO6MJJdyzX
        wHqXu0+xWtQRAb2Iqp3uK5vyZCwJWbVkcwK9LSHM57GsVWgxqzicxliMLie/YeOp
        1fF8Awcwy4cyEQgroywvvFdawx1FhMvXB+iiiu1Tqvg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=4Ses/u
        txDL3oIDwD2o1wOuufQ4wzqGtxnXGhfxM/Qyo=; b=JF46qZtECtaHapq6dOYGA2
        S5eQTTDYst6zkttBncFTslZ5YZeeQ8pN6UQY9bmaOJPVLWhzN5Tg3NxFK8GBU32A
        nkVjgzHPDTVchYGc/rG+VU5FdjuHabo2DAmky/49RbEqOA6gDD1ihKD0BhgBwg0c
        2BQ+L2IlDqL/PVhy1HwGq8dF8t4hs7xMy2he7xvvbZNjmFVNEE2UM5zQ8b495wsi
        HV+BWnoNyqL2vzEc0aGCH2jug0W3Jq0cgDMmAxDox1FYLbLu8/ly65A3yU1I+H6w
        PcKnW9HAGMWaU+BomvtURt5hqM0mb5ijgitbH0G4P6leVq8+U6HVvzh3yAy5dGQQ
        ==
X-ME-Sender: <xms:-USQYPV5x6Ge1J-UbUPGQ4TXG3wS-d1Z3u4J5HX3BIdxO7c6QKoAAw>
    <xme:-USQYHknU0XXYYCd_3HpjBI65KQqtu6hvCoWQ5CLkL8vCBIWRlxPLlXPaVstqzbQ6
    Ps_BGt2ILCn_QeWubQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdefgedgudefudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    ehudevleekieetleevieeuhfduhedtiefgheekfeefgeelvdeuveeggfduueevfeenucfk
    phepvddtjedrheefrddvheefrdejnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrg
    hmpehmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:-USQYLbcyoITcLsS_3b_Lem4TPxhmn24Ia26hEIgkp5K2KVkUdne2w>
    <xmx:-USQYKXpVoOES4yBlE6scCeqTv5oPDDC0iF322vBykrXsmesZpyJew>
    <xmx:-USQYJl9S7jqvLjw0pWioX9y-ccWm9_1t-F8-ES7IF5-WyBao4QXZA>
    <xmx:-kSQYJukgUTHKUHjtXDAIbc9oAW0QjXvxkvkgXZinN-Ac5XpqjBNXg>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Mon,  3 May 2021 14:46:17 -0400 (EDT)
Date:   Mon, 3 May 2021 11:46:15 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 2/5] btrfs: initial fsverity support
Message-ID: <YJBE9/hJgd7rf2sU@zen>
References: <cover.1617900170.git.boris@bur.io>
 <c9335d862ee4ddc1f7193bbb06ca7313d9ff1b30.1617900170.git.boris@bur.io>
 <YG+IoOqvDNtkwWQf@sol.localdomain>
 <YHDY/ekYdxHhvHRW@zen>
 <YHDkK9W9N2UWEEyv@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHDkK9W9N2UWEEyv@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Apr 09, 2021 at 04:32:59PM -0700, Eric Biggers wrote:
> On Fri, Apr 09, 2021 at 03:45:17PM -0700, Boris Burkov wrote:
> > On Thu, Apr 08, 2021 at 03:50:08PM -0700, Eric Biggers wrote:
> > > On Thu, Apr 08, 2021 at 11:33:53AM -0700, Boris Burkov wrote:
> > > > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > > > index f7a4ad86adee..e5282a8f566a 100644
> > > > --- a/fs/btrfs/super.c
> > > > +++ b/fs/btrfs/super.c
> > > > @@ -1339,6 +1339,7 @@ static int btrfs_fill_super(struct super_block *sb,
> > > >  	sb->s_op = &btrfs_super_ops;
> > > >  	sb->s_d_op = &btrfs_dentry_operations;
> > > >  	sb->s_export_op = &btrfs_export_ops;
> > > > +	sb->s_vop = &btrfs_verityops;
> > > >  	sb->s_xattr = btrfs_xattr_handlers;
> > > >  	sb->s_time_gran = 1;
> > > 
> > > As the kernel test robot has hinted at, this line needs to be conditional on
> > > CONFIG_FS_VERITY.
> > > 
> > > > +/*
> > > > + * Helper function for computing cache index for Merkle tree pages
> > > > + * @inode: verity file whose Merkle items we want.
> > > > + * @merkle_index: index of the page in the Merkle tree (as in
> > > > + *                read_merkle_tree_page).
> > > > + * @ret_index: returned index in the inode's mapping
> > > > + *
> > > > + * Returns: 0 on success, -EFBIG if the location in the file would be beyond
> > > > + * sb->s_maxbytes.
> > > > + */
> > > > +static int get_verity_mapping_index(struct inode *inode,
> > > > +				    pgoff_t merkle_index,
> > > > +				    pgoff_t *ret_index)
> > > > +{
> > > > +	/*
> > > > +	 * the file is readonly, so i_size can't change here.  We jump
> > > > +	 * some pages past the last page to cache our merkles.  The goal
> > > > +	 * is just to jump past any hugepages that might be mapped in.
> > > > +	 */
> > > > +	pgoff_t merkle_offset = 2048;
> > > > +	u64 index = (i_size_read(inode) >> PAGE_SHIFT) + merkle_offset + merkle_index;
> > > 
> > > Would it make more sense to align the page index to 2048, rather than adding
> > > 2048?  Or are huge pages not necessarily aligned in the page cache?
> > > 
> > 
> > What advantages are there to aligning? I don't have any objection to
> > doing it besides keeping things as simple as possible.
> 
> It just seems like the logical thing to do, and it's what ext4 and f2fs do; they
> align the start of the verity metadata to 65536 bytes so that it's page-aligned
> on all architectures.
> 
> Actually, you might want to choose a fixed value like that as well (rather than
> some constant multiple of PAGE_SIZE) so that your maximum file size isn't
> different on different architectures.
> 
> Can you elaborate on what sort of huge page scenario you have in mind here?
> 

The concern was a transparent hugepage at the end of the file that would
interact negatively with these false pages past the end of the file.
Since the indexing was pretty arbitrary, we just wanted it to be past
any final hugepage.

However, I looked into it more closely and it looks like khugepaged's
collapse_file will not collapse pages that would leave a hugepage
hanging out past EOF, so it wasn't a real issue. For consistency, when I
send V4, it will use the same "round to 65536" logic.

> > 
> > > > +
> > > > +	if (index > inode->i_sb->s_maxbytes >> PAGE_SHIFT)
> > > > +		return -EFBIG;
> > > 
> > > There's an off-by-one error here; it's considering the beginning of the page
> > > rather than the end of the page.
> > > 
> > 
> > I can't see the error myself, yet..
> > 
> > read_merkle_tree_page is what interacts with the page cache and does it
> > with read_key_bytes in PAGE_SIZE chunks. So if index == maxbytes >>
> > PAGE_SHIFT, I take that to mean we match on the start of the last
> > possible page, which seems fine to read in all of. The next index will
> > fail.
> 
> The maximum number of pages is s_maxbytes >> PAGE_SHIFT, and you're allowing the
> page with that index, which means you're allowing one too many pages.  Hence, an
> off-by-one-error.

Thinking on it further, I'm not convinced that this is wrong for the
64 bit long case. s_maxbytes is at the end of the last page, and I don't
see any reason you couldn't index it (i.e., xarray doesn't seem opposed
to that index). My rough argument for this is:

"What if maxbytes was 4095? Then maxbytes >> PAGE_SHIFT is 0, and 0 is
the valid index of the last and only page."

However, that logic falls apart for the 32 bit long case where max is
ULONG_MAX << PAGE_SHIFT, which is at the beginning of a page, and that
last index only works for exactly one byte. My code would wrongly
try to read the whole page.

To make the logic uniform for the two cases, I have found things work a
lot nicer if I operate in "file position space" rather than "page index
space" the way that ext4 does.

Have I understood it correctly now, or am I still missing something?

Thanks again for your help.

> 
> > 
> > I think the weird thing is I called get_verity_merkle_index to
> > write_merkle_tree_block. It doesn't do much there since we aren't
> > affecting the page cache till we read.
> > 
> > As far as I can see, to make the btrfs implementation behave as
> > similarly as possible to ext4, it should either interact with the page
> > cache on the write path, or if that is undesirable (haven't thought it
> > through carefully yet), it should accurately fail writes with EFBIG that
> > would later fail as reads.
> > 
> 
> Yes, you need to enforce the limit at write time, not just at read time.  But
> make sure you're using the page index, not the block index (to be ready for
> Merkle tree block size != PAGE_SIZE in the future).
> 
> - Eric
