Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 615445B0E79
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Sep 2022 22:48:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229777AbiIGUsv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Sep 2022 16:48:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230089AbiIGUsu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Sep 2022 16:48:50 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F421BD4DF;
        Wed,  7 Sep 2022 13:48:49 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 22E9C3414D;
        Wed,  7 Sep 2022 20:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662583728;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aHEaEAKRwavSIAayvx0qqQofw6QcD+TRdd1lvOvf8YU=;
        b=FVnkne86xfID/0+i1hIuy+dNcwKj0xYnctIuP6NFtX8sxG7cfEgHxWv94qsDfc14Z0fgJy
        m+YvB5jG5FxReCGFMRawHCNzJ8dWRIWzdyUErUAhHSuG0ACpjSgrR2mlMURimWAs1jEcwN
        MCi8AWNvoSyLIFS2acIpW/Y5z4IUTss=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662583728;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=aHEaEAKRwavSIAayvx0qqQofw6QcD+TRdd1lvOvf8YU=;
        b=RFcP9qd28jHX1q1CbtShGmJtOqbNkYzRoikyUdDeNv4qCKIMf29rE/1hCdEWGNSlcKv8Ca
        u1G4jr18f3q9tgBw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CBB2A13486;
        Wed,  7 Sep 2022 20:48:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id LmLJMK8DGWPKRwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 07 Sep 2022 20:48:47 +0000
Date:   Wed, 7 Sep 2022 22:43:24 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 13/20] btrfs: add fscrypt_context items.
Message-ID: <20220907204324.GL32411@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <827a00815cb4a9a91ff3977d71f40ff765728f04.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <827a00815cb4a9a91ff3977d71f40ff765728f04.1662420176.git.sweettea-kernel@dorminy.me>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:28PM -0400, Sweet Tea Dorminy wrote:
> +static int btrfs_fscrypt_get_context(struct inode *inode, void *ctx, size_t len)
> +{
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct inode *put_inode = NULL;
> +	struct btrfs_key key;
> +	struct btrfs_path *path;
> +	struct extent_buffer *leaf;
> +	unsigned long ptr;
> +	int ret;
> +
> +	if (btrfs_root_flags(&root->root_item) & BTRFS_ROOT_SUBVOL_FSCRYPT) {
> +		inode = btrfs_iget(inode->i_sb, BTRFS_FIRST_FREE_OBJECTID,
> +				   root);
> +		if (IS_ERR(inode))
> +			return PTR_ERR(inode);
> +		put_inode = inode;
> +	}
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +
> +	key = (struct btrfs_key) {
> +		.objectid = btrfs_ino(BTRFS_I(inode)),
> +		.type = BTRFS_FSCRYPT_CTXT_ITEM_KEY,
> +		.offset = 0,
> +	};

Please use the following for key initialization.

	key.objectid = ...;
	key.type = ...;
	key.offset = ...;

> +static int btrfs_fscrypt_set_context(struct inode *inode, const void *ctx,
> +				     size_t len, void *fs_data)
> +{
> +	struct btrfs_root *root = BTRFS_I(inode)->root;
> +	struct btrfs_trans_handle *trans;
> +	int is_subvolume = inode->i_ino == BTRFS_FIRST_FREE_OBJECTID;
> +	int ret;
> +	struct btrfs_path *path;
> +	struct btrfs_key key = {
> +		.objectid = btrfs_ino(BTRFS_I(inode)),
> +		.type = BTRFS_FSCRYPT_CTXT_ITEM_KEY,
> +		.offset = 0,
> +	};

This kind of initialization in the declaration block is ok, possibly
with only the simple initializers like btrfs_ino or normal constants.

> +	if (btrfs_root_flags(&root->root_item) & BTRFS_ROOT_SUBVOL_FSCRYPT) {
> +		bool same_policy;
> +		struct inode *root_inode = NULL;

Newlines between declrataions and statements

> +		root_inode = btrfs_iget(inode->i_sb, BTRFS_FIRST_FREE_OBJECTID,
> +				   root);
> +		if (IS_ERR(inode))
> +			return PTR_ERR(inode);
> +		same_policy = fscrypt_have_same_policy(inode, root_inode);
> +		iput(root_inode);
> +		if (same_policy)
> +			return 0;
> +	}
> +
> +	if (fs_data) {
> +		/*
> +		 * We are setting the context as part of an existing
> +		 * transaction. This happens when we are inheriting the context
> +		 * for a new inode.
> +		 */
> +		trans = fs_data;
> +	} else {
> +		/*
> +		 * 1 for the inode item
> +		 * 1 for the fscrypt item
> +		 * 1 for the root item if the inode is a subvolume
> +		 */
> +		trans = btrfs_start_transaction(root, 2 + is_subvolume);
> +		if (IS_ERR(trans))
> +			return PTR_ERR(trans);
> +	}
> +
> +	path = btrfs_alloc_path();
> +	if (!path)
> +		return -ENOMEM;
> +	ret = btrfs_search_slot(trans, BTRFS_I(inode)->root, &key, path, 0, 1);
> +	if (ret == 0) {
> +		struct extent_buffer *leaf = path->nodes[0];
> +		unsigned long ptr = btrfs_item_ptr_offset(leaf, path->slots[0]);

Newlines between declrataions and statements, you'll find the rest

> +		len = min_t(size_t, len, btrfs_item_size(leaf, path->slots[0]));
> +		write_extent_buffer(leaf, ctx, ptr, len);
> +		btrfs_mark_buffer_dirty(leaf);
> +		btrfs_free_path(path);
> +		goto out;
> +	} else if (ret < 0) {
> +		goto out;
> +	}
> +	btrfs_free_path(path);
> +
> +	ret = btrfs_insert_item(trans, BTRFS_I(inode)->root, &key, (void *) ctx, len);
> +	if (ret)
> +		goto out;
> +
> +	BTRFS_I(inode)->flags |= BTRFS_INODE_FSCRYPT_CONTEXT;
> +	btrfs_sync_inode_flags_to_i_flags(inode);
> +	inode_inc_iversion(inode);
> +	inode->i_ctime = current_time(inode);
> +	ret = btrfs_update_inode(trans, root, BTRFS_I(inode));
> +	if (ret)
> +		goto out;
> +
> +	/*
> +	 * For new subvolumes, the root item is already initialized with
> +	 * the BTRFS_ROOT_SUBVOL_FSCRYPT flag.
> +	 */
> +	if (!fs_data && is_subvolume) {
> +		u64 root_flags = btrfs_root_flags(&root->root_item);
> +
> +		btrfs_set_root_flags(&root->root_item,
> +				     root_flags |
> +				     BTRFS_ROOT_SUBVOL_FSCRYPT);
> +		ret = btrfs_update_root(trans, root->fs_info->tree_root,
> +					&root->root_key,
> +					&root->root_item);
> +	}
> +out:
> +	if (fs_data)
> +		return ret;
> +
> +	if (ret)
> +		btrfs_abort_transaction(trans, ret);
> +	else
> +		btrfs_end_transaction(trans);
> +	return ret;
> +}
> +
> +	if (args->encrypt)
> +		(*trans_num_items)++; /* 1 to add fscrypt item */

Please put the comment on a separate line, like it's on the lines below.

>  	if (args->orphan) {
>  		/* 1 to add orphan item */
>  		(*trans_num_items)++;
> @@ -787,6 +788,13 @@ static int create_snapshot(struct btrfs_root *root, struct inode *dir,
>  		return -ETXTBSY;
>  	}
>  
> +	if ((btrfs_root_flags(&root->root_item) & BTRFS_ROOT_SUBVOL_FSCRYPT) &&
> +	    !IS_ENCRYPTED(dir)) {
> +		btrfs_warn(fs_info,
> +			   "cannot snapshot encrypted volume to unencrypted destination");

Do we want to print that to the log? There are several EXDEV causes,
only another one prints a message and I think it should not.

> +		return -EXDEV;
> +	}
> +
>  	pending_snapshot = kzalloc(sizeof(*pending_snapshot), GFP_KERNEL);
>  	if (!pending_snapshot)
>  		return -ENOMEM;
> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -144,6 +144,8 @@
>  #define BTRFS_VERITY_DESC_ITEM_KEY	36
>  #define BTRFS_VERITY_MERKLE_ITEM_KEY	37
>  
> +#define BTRFS_FSCRYPT_CTXT_ITEM_KEY	41

The context is per inode, so OK the key is needed and the number is
leaving enough space in case we'd need to add more.
