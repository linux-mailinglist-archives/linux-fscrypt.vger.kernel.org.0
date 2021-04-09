Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 19D4635A8EF
	for <lists+linux-fscrypt@lfdr.de>; Sat, 10 Apr 2021 00:50:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235053AbhDIWpd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 9 Apr 2021 18:45:33 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:49073 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234880AbhDIWpd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 9 Apr 2021 18:45:33 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.nyi.internal (Postfix) with ESMTP id 2CA6F5C00E9;
        Fri,  9 Apr 2021 18:45:19 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Fri, 09 Apr 2021 18:45:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=OYjmJRHllS2Gy4zmX+Daft+eXQ5
        IFCcvaqd14V22T14=; b=SCFtvS8ECses/Ox4gyk4Oi2Es8Y6DWBHLXRBj0xN74M
        QX+m4h7cn4eSha71EajfYEKf2oOALNBx7TzzO6mB1gr/LrtbkNkoVI0h6f23nh8G
        1gmCDFt72gXId6NSVwDayYraYrKUgXyPwxukzPqTK4pbFFAJDmhzqWNP4r0Lkuc9
        48E3wW6BrXi3HbX5n14rvD674/e+7DxgWX/AA2dXr8MqNsb1d4QEvmdPQsWbuBWv
        syCsWTYRjqzbp2mu9g7YJQWulgxyMLqSKt9Rl3qjn2Hvp1QjMIfadGC55QcgkCb4
        dDygeLd+adV6NmBP+HJ9N4Tew+lmCX2bhYAaO7zhAGQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=OYjmJR
        HllS2Gy4zmX+Daft+eXQ5IFCcvaqd14V22T14=; b=C5EPWvWCDJHeX6me/108QR
        jXfKsvBb5wPSbPV9fO8TSVekvGTgKdZVZeW6PkAkYJdS8TF0qMIgn6Jfb8hf9emK
        n9qSUW0iOFXK38qSp5ppZQCNiTqfhguWczZEAAiXfZ2Uf7TV/ICVbGlbgwTyja8p
        PHYEwUn57cf2Er8XXb0BRodOJRzN0vDqivwtd5yckl1lUNRPsTP5jRy7Hal68daa
        ye8S/zhMs2EjQjg9rhew/FVK0jw19K9KX+B3ZQfTvbG7FhPGJ1ykoUtRf02TH5UI
        K2+ri0BO4N125zzeEbutFi90Xm7NhTqhPItOdaa/GMPUYAw+sq2+hxKNh5PCxr1g
        ==
X-ME-Sender: <xms:_thwYLlKGJwAzoI4K4hUX53h2D2BQQvoaEiWmXc_3B_oCGJVwHb5EQ>
    <xme:_thwYO0i_OGgmnIp1CpMEpRvlot_xv9b3c40nt_Fngj8K3cVjpwKb0znHIYijhpKd
    1Jb0nx7e9Y5vSgQlTk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudekvddguddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhrihhs
    uceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnhephe
    duveelkeeiteelveeiuefhudehtdeigfehkeeffeegledvueevgefgudeuveefnecukfhp
    pedvtdejrdehfedrvdehfedrjeenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmh
    epmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:_thwYBolmG-eEsO9LI0SPB-rOMnmaZFkxoAzHCVQHnJGktVXh5-OOQ>
    <xmx:_thwYDmU-DkMl_j_LiLsmQD9LDZO9l-xx-JvqVyMwCTpTTSCit_z7Q>
    <xmx:_thwYJ0W0lLQaf1CqPsDt7koWgdb6s2zs3nMfd1QcF8xBTcTLtAq2Q>
    <xmx:_9hwYK-NrsvyjxLeqETqIi5XnVP59Ww4ayhdyFieAWytz_5TDw09nw>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA id 9DDE71080063;
        Fri,  9 Apr 2021 18:45:18 -0400 (EDT)
Date:   Fri, 9 Apr 2021 15:45:17 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 2/5] btrfs: initial fsverity support
Message-ID: <YHDY/ekYdxHhvHRW@zen>
References: <cover.1617900170.git.boris@bur.io>
 <c9335d862ee4ddc1f7193bbb06ca7313d9ff1b30.1617900170.git.boris@bur.io>
 <YG+IoOqvDNtkwWQf@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YG+IoOqvDNtkwWQf@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Apr 08, 2021 at 03:50:08PM -0700, Eric Biggers wrote:
> On Thu, Apr 08, 2021 at 11:33:53AM -0700, Boris Burkov wrote:
> > diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
> > index f7a4ad86adee..e5282a8f566a 100644
> > --- a/fs/btrfs/super.c
> > +++ b/fs/btrfs/super.c
> > @@ -1339,6 +1339,7 @@ static int btrfs_fill_super(struct super_block *sb,
> >  	sb->s_op = &btrfs_super_ops;
> >  	sb->s_d_op = &btrfs_dentry_operations;
> >  	sb->s_export_op = &btrfs_export_ops;
> > +	sb->s_vop = &btrfs_verityops;
> >  	sb->s_xattr = btrfs_xattr_handlers;
> >  	sb->s_time_gran = 1;
> 
> As the kernel test robot has hinted at, this line needs to be conditional on
> CONFIG_FS_VERITY.
> 
> > +/*
> > + * Helper function for computing cache index for Merkle tree pages
> > + * @inode: verity file whose Merkle items we want.
> > + * @merkle_index: index of the page in the Merkle tree (as in
> > + *                read_merkle_tree_page).
> > + * @ret_index: returned index in the inode's mapping
> > + *
> > + * Returns: 0 on success, -EFBIG if the location in the file would be beyond
> > + * sb->s_maxbytes.
> > + */
> > +static int get_verity_mapping_index(struct inode *inode,
> > +				    pgoff_t merkle_index,
> > +				    pgoff_t *ret_index)
> > +{
> > +	/*
> > +	 * the file is readonly, so i_size can't change here.  We jump
> > +	 * some pages past the last page to cache our merkles.  The goal
> > +	 * is just to jump past any hugepages that might be mapped in.
> > +	 */
> > +	pgoff_t merkle_offset = 2048;
> > +	u64 index = (i_size_read(inode) >> PAGE_SHIFT) + merkle_offset + merkle_index;
> 
> Would it make more sense to align the page index to 2048, rather than adding
> 2048?  Or are huge pages not necessarily aligned in the page cache?
> 

What advantages are there to aligning? I don't have any objection to
doing it besides keeping things as simple as possible.

> > +
> > +	if (index > inode->i_sb->s_maxbytes >> PAGE_SHIFT)
> > +		return -EFBIG;
> 
> There's an off-by-one error here; it's considering the beginning of the page
> rather than the end of the page.
> 

I can't see the error myself, yet..

read_merkle_tree_page is what interacts with the page cache and does it
with read_key_bytes in PAGE_SIZE chunks. So if index == maxbytes >>
PAGE_SHIFT, I take that to mean we match on the start of the last
possible page, which seems fine to read in all of. The next index will
fail.

I think the weird thing is I called get_verity_merkle_index to
write_merkle_tree_block. It doesn't do much there since we aren't
affecting the page cache till we read.

As far as I can see, to make the btrfs implementation behave as
similarly as possible to ext4, it should either interact with the page
cache on the write path, or if that is undesirable (haven't thought it
through carefully yet), it should accurately fail writes with EFBIG that
would later fail as reads.

> > +/*
> > + * Insert and write inode items with a given key type and offset.
> > + * @inode: The inode to insert for.
> > + * @key_type: The key type to insert.
> > + * @offset: The item offset to insert at.
> > + * @src: Source data to write.
> > + * @len: Length of source data to write.
> > + *
> > + * Write len bytes from src into items of up to 1k length.
> > + * The inserted items will have key <ino, key_type, offset + off> where
> > + * off is consecutively increasing from 0 up to the last item ending at
> > + * offset + len.
> > + *
> > + * Returns 0 on success and a negative error code on failure.
> > + */
> > +static int write_key_bytes(struct btrfs_inode *inode, u8 key_type, u64 offset,
> > +			   const char *src, u64 len)
> > +{
> > +	struct btrfs_trans_handle *trans;
> > +	struct btrfs_path *path;
> > +	struct btrfs_root *root = inode->root;
> > +	struct extent_buffer *leaf;
> > +	struct btrfs_key key;
> > +	u64 orig_len = len;
> > +	u64 copied = 0;
> > +	unsigned long copy_bytes;
> > +	unsigned long src_offset = 0;
> > +	void *data;
> > +	int ret;
> > +
> > +	path = btrfs_alloc_path();
> > +	if (!path)
> > +		return -ENOMEM;
> > +
> > +	while (len > 0) {
> > +		trans = btrfs_start_transaction(root, 1);
> > +		if (IS_ERR(trans)) {
> > +			ret = PTR_ERR(trans);
> > +			break;
> > +		}
> > +
> > +		key.objectid = btrfs_ino(inode);
> > +		key.offset = offset;
> > +		key.type = key_type;
> > +
> > +		/*
> > +		 * insert 1K at a time mostly to be friendly for smaller
> > +		 * leaf size filesystems
> > +		 */
> > +		copy_bytes = min_t(u64, len, 1024);
> > +
> > +		ret = btrfs_insert_empty_item(trans, root, path, &key, copy_bytes);
> > +		if (ret) {
> > +			btrfs_end_transaction(trans);
> > +			break;
> > +		}
> > +
> > +		leaf = path->nodes[0];
> > +
> > +		data = btrfs_item_ptr(leaf, path->slots[0], void);
> > +		write_extent_buffer(leaf, src + src_offset,
> > +				    (unsigned long)data, copy_bytes);
> > +		offset += copy_bytes;
> > +		src_offset += copy_bytes;
> > +		len -= copy_bytes;
> > +		copied += copy_bytes;
> > +
> > +		btrfs_release_path(path);
> > +		btrfs_end_transaction(trans);
> > +	}
> > +
> > +	btrfs_free_path(path);
> > +
> > +	if (!ret && copied != orig_len)
> > +		ret = -EIO;
> 
> The condition '!ret && copied != orig_len' at the end appears to be unnecessary,
> since this function doesn't do short writes.
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
> > +	if (true_size > INT_MAX)
> 
> true_size is a __le64 on-disk, so it technically should be __u64 here; otherwise
> its high 32 bits might be ignored.
> 
> > +struct btrfs_verity_descriptor_item {
> > +	/* size of the verity descriptor in bytes */
> > +	__le64 size;
> > +	__le64 reserved[2];
> > +	__u8 encryption;
> > +} __attribute__ ((__packed__));
> 
> The 'reserved' field still isn't validated to be 0 before going ahead and using
> the descriptor.  Is that still intentional?  If so, it might be clearer to call
> this field 'unused'.
> 
> - Eric
