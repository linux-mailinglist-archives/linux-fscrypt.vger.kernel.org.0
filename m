Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7073933CA75
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Mar 2021 01:43:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbhCPAmz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 15 Mar 2021 20:42:55 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:45573 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233624AbhCPAmy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 15 Mar 2021 20:42:54 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 6DFDA2A9;
        Mon, 15 Mar 2021 20:42:53 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 15 Mar 2021 20:42:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=5tDKhdlYBqNEAQci72FNBNgK661
        fXLkNHYeklQkSD/I=; b=j8Xayc5lRdri0uJyq2Nv5Y63iQ5a5q7gz/bqNPD43Cf
        BpixTEES73P+VqSeFrLavBAEKAsmNRCnmiqsB6aZTu+q3VMjghAnGjdHPn6Dk9Wc
        6hCIB8lEE+fipxRqDI0aAAYIsmhWJCILGtvO4rlR3PXmOqYporamPOx2JVmRlVsa
        0YthbWUEu/tUuCmFEQiziIh3gxGNm6rak39IwVxE+g0qyMIv5nyEo53qciYeF8nA
        XMVyyTvMzQtbbzj7LcBDS6OdBl9vuTfH+oANsXy7n7CkNfOEiYuzkqEkLPk3ssG4
        0+U5RvCf5AAUF51q1ZaS5AUr3cJHVmKTNhLqE1gFUgg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=5tDKhd
        lYBqNEAQci72FNBNgK661fXLkNHYeklQkSD/I=; b=BL9DQEF/opMrjvfc+aOlcU
        /rP8kIlCCMDicQpucBw39N3C6gOvUNmB6pjVlPbLg1HWt8+JAKVzWaaajz/zZpk5
        U5SU8vbz21DkPogNnbh57uRDrBUf3JOTkQeO0DAsuh0ss2KkFy1tQpHN6TEHFujK
        zWcQgjRIgOYV9o675fsVw+Tho2kJl37W/tv+K9XValtRS1wtdJKyDDKo8AiNQY7f
        BaLeQI40glEWqEpRcQ9FETzIkzGGosVgENdtzpAsYA08HKBeZSlTzwbLAF7I54KG
        5+RKYG9rz2mW8pomS6W6B5qG1nrOjqXTFrfLI6pMPbrgtHNVlbAhowvZwFZvaeRg
        ==
X-ME-Sender: <xms:DP9PYC5G41XJPLEQt20hlM-l5-ZVbv5_qhWTdCPVdb3StAsksxWAOw>
    <xme:DP9PYL22r8G-zcCJ7HFYMSSpSsErl5cQHkT77xCt5L5G0-y0bmoPjD1GV0L5IX8dj
    UcREeE62wdpM2wUiZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudefuddgvdegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    dvhffghfetueeggfdtgeduvedugeekgeeuvddvhfdugeduhfetkeevtdeitdegueenucfk
    phepudeifedruddugedrudefvddrudenucevlhhushhtvghrufhiiigvpedtnecurfgrrh
    grmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:DP9PYOWRX1MI-reI_iG7s0BA6_xw7HOp7_AO4JhF-E-baRsvX3R8eQ>
    <xmx:DP9PYG7JizN8NYwxmU0IP4aoyqRzdPB1sGv4Ih_Ijj0Ryns4aRBc-Q>
    <xmx:DP9PYFKh5K2KwtXioZjg4osy9Y63rBf5z0NeLuTFhwHEyfZ7ZMzPcQ>
    <xmx:Df9PYOl6rm0V4AXPiPzmzzHxHKUVyPp1tCtrz3g_wUC6EqQHal37Bw>
Received: from localhost (unknown [163.114.132.1])
        by mail.messagingengine.com (Postfix) with ESMTPA id 87EA51080066;
        Mon, 15 Mar 2021 20:42:51 -0400 (EDT)
Date:   Mon, 15 Mar 2021 17:42:48 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v2 2/5] btrfs: initial fsverity support
Message-ID: <20210316004248.GC3610049@devbig008.ftw2.facebook.com>
References: <cover.1614971203.git.boris@bur.io>
 <71249018efc661fdd3c43bda5d7cea271904ae1a.1614971203.git.boris@bur.io>
 <YE/q/bYckkAewbbl@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YE/q/bYckkAewbbl@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Mar 15, 2021 at 04:17:17PM -0700, Eric Biggers wrote:
> On Fri, Mar 05, 2021 at 11:26:30AM -0800, Boris Burkov wrote:
> > +static int end_page_read(struct page *page, bool uptodate, u64 start, u32 len)
> >  {
> > -	struct btrfs_fs_info *fs_info = btrfs_sb(page->mapping->host->i_sb);
> > +	int ret = 0;
> > +	struct inode *inode = page->mapping->host;
> > +	struct btrfs_fs_info *fs_info = btrfs_sb(inode->i_sb);
> >  
> >  	ASSERT(page_offset(page) <= start &&
> >  		start + len <= page_offset(page) + PAGE_SIZE);
> >  
> >  	if (uptodate) {
> > -		btrfs_page_set_uptodate(fs_info, page, start, len);
> > +		/*
> > +		 * buffered reads of a file with page alignment will issue a
> > +		 * 0 length read for one page past the end of file, so we must
> > +		 * explicitly skip checking verity on that page of zeros.
> > +		 */
> > +		if (!PageError(page) && !PageUptodate(page) &&
> > +		    start < i_size_read(inode) &&
> > +		    fsverity_active(inode) &&
> > +		    fsverity_verify_page(page) != true)
> > +			ret = -EIO;
> > +		else
> > +			btrfs_page_set_uptodate(fs_info, page, start, len);
> >  	} else {
> 
> 'fsverity_verify_page(page) != true' is better written as
> '!fsverity_verify_page(page)'.
> 
> > +/*
> > + * Just like ext4, we cache the merkle tree in pages after EOF in the page
> > + * cache.  Unlike ext4, we're storing these in dedicated btree items and
> > + * not just shoving them after EOF in the file.  This means we'll need to
> > + * do extra work to encrypt them once encryption is supported in btrfs,
> > + * but btrfs has a lot of careful code around i_size and it seems better
> > + * to make a new key type than try and adjust all of our expectations
> > + * for i_size.
> > + *
> > + * fs verity items are stored under two different key types on disk.
> > + *
> > + * The descriptor items:
> > + * [ inode objectid, BTRFS_VERITY_DESC_ITEM_KEY, offset ]
> > + *
> > + * At offset 0, we store a btrfs_verity_descriptor_item which tracks the
> > + * size of the descriptor item and some extra data for encryption.
> 
> Is the separate size field really needed?  It seems like the type of thing that
> would be redundant with information that btrfs already stores about the tree
> items.  Having two sources of truth is error-prone.

For the case where the user supplied signature is absent or fits in one
1K btrfs verity descriptor item, I believe you are right, and we could
infer that from the generic item size. Assuming arbitrary signature
lengths, we could still probably do it by searching for the last item
and computing the size from its key offset and item size. Though now
that we have a special meaning for offset 0, that gets a bit messier.

I believe we will need the special item no matter what for the eventual
encryption case, so I figured it wasn't a big deal to include the size
rather than try to come up with some computation to get it. I like the
argument about redundant representation, and saving 8 bytes per verity
enabled file isn't nothing either. I will see if I can compute it
efficiently without adding the extra field.

> 
> > +/*
> > + * Insert and write inode items with a given key type and offset.
> > + * @inode: The inode to insert for.
> > + * @key_type: The key type to insert.
> > + * @offset: The item offset to insert at.
> > + * @src: Source data to write.
> > + * @len: Length of source data to write.
> > + * @max_item_size: Break up the write into items of this size at most.
> > + *                 Useful for small leaf size file systems.
> > + *
> > + * Write len bytes from src into items of up to max_item_size length.
> > + * The inserted items will have key <ino, key_type, offset + off> where
> > + * off is consecutively increasing from 0 up to the last item ending at
> > + * offset + len.
> > + *
> > + * Returns 0 on success and a negative error code on failure.
> > + */
> > +static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
> > +			   const char *src, u64 len)
> 
> The max_item_size parameter is documented but doesn't exist.
> 
> > +/*
> > + * fsverity op that gets the struct fsverity_descriptor.
> > + * fsverity does a two pass setup for reading the descriptor, in the first pass
> > + * it calls with buf_size = 0 to query the size of the descriptor,
> > + * and then in the second pass it actually reads the descriptor off
> > + * disk.
> > + */
> > +static int btrfs_get_verity_descriptor(struct inode *inode, void *buf,
> > +				       size_t buf_size)
> > +{
> > +	size_t true_size;
> > +	ssize_t ret = 0;
> > +	struct btrfs_verity_descriptor_item item;
> > +
> > +	memset(&item, 0, sizeof(item));
> > +	ret = read_key_bytes(BTRFS_I(inode), BTRFS_VERITY_DESC_ITEM_KEY,
> > +			     0, (char *)&item, sizeof(item), NULL);
> > +	if (ret < 0)
> > +		return ret;
> > +
> > +	true_size = btrfs_stack_verity_descriptor_size(&item);
> > +	if (!buf_size)
> > +		return true_size;
> > +	if (buf_size < true_size)
> > +		return -ERANGE;
> 
> 
> It would be good to validate that true_size <= INT_MAX, as it's returned it an
> 'int'.
> 
> > +
> > +	ret = read_key_bytes(BTRFS_I(inode),
> > +			     BTRFS_VERITY_DESC_ITEM_KEY, 1,
> > +			     buf, buf_size, NULL);
> > +	if (ret < 0)
> > +		return ret;
> > +	if (ret != buf_size)
> > +		return -EIO;
> > +
> > +	return buf_size;
> 
> Shouldn't this part use true_size, not buf_size?

I felt this was clunky when writing it. If I'm not mistaken, it doesn't
really matter what we return since the actual key line is the
`ret != buf_size` check above.

I think it would be reasonable to allow too-large buffers and check
against/return true_size. If true_size is somehow wrong, then presumably
the signature check itself will still fail.

> 
> > +/*
> > + * fsverity op that writes a merkle tree block into the btree in 1k chunks.
> > + */
> > +static int btrfs_write_merkle_tree_block(struct inode *inode, const void *buf,
> > +					u64 index, int log_blocksize)
> > +{
> > +	u64 start = index << log_blocksize;
> > +	u64 len = 1 << log_blocksize;
> > +	unsigned long mapping_index = get_verity_mapping_index(inode, index);
> > +
> > +	if (mapping_index > inode->i_sb->s_maxbytes >> PAGE_SHIFT)
> > +		return -EFBIG;
> 
> I don't think this overflow check will work correctly, as 'mapping_index' can
> overflow a ULONG_MAX before the overflow check is done.

Oof, I had a bit of trouble with this, so it's not too surprising I got
it wrong. I misunderstood the maxbytes logic for systems with 32 bit
longs, and obviously only tested it my machine with 64 bit longs.
> 
> > +struct btrfs_verity_descriptor_item {
> > +	/* size of the verity descriptor in bytes */
> > +	__le64 size;
> > +	__le64 reserved[2];
> > +	__u8 encryption;
> > +} __attribute__ ((__packed__));
> 
> Should these reserved fields be strictly validated?  Currently they appear to be
> ignored.
> 
> - Eric

Thanks for the review,
Boris
