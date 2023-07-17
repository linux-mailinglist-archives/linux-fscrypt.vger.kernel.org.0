Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 72C26756AEB
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 19:46:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230130AbjGQRqq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jul 2023 13:46:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229670AbjGQRqp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jul 2023 13:46:45 -0400
Received: from mail-qv1-xf32.google.com (mail-qv1-xf32.google.com [IPv6:2607:f8b0:4864:20::f32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E7761A8
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 10:46:44 -0700 (PDT)
Received: by mail-qv1-xf32.google.com with SMTP id 6a1803df08f44-635e54e22d6so33158966d6.2
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 10:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1689616003; x=1692208003;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=NSjTGufRcF11GNkReUys5ziCSGxlh+o8DY7lEbj9Ao8=;
        b=lt03CBo9cwwD2zVS8/EQnsVhQ/8+EKJJoS/g+oyGANqP66op3OdABuUVKjbVGp1BbR
         SRc5jTYRjCjRLB3N7YfnDY1gABmHdtE2cGXYx3OHbYRg87MCKJPjqtlcjCacjOhnZco8
         f9VhceAejsS2gzKzMmB5ahAY9RQwhWAjHU2My0G793liw9pH5th1pvOYUau/JIgW+j00
         KCU9+YMjyzaTZgs1F9pgRil+GU+jF51uvppUL8rzT8cGjt4WlLS/+KH8lMPYPf2UfhoO
         pP+5F/zyY4/wEcRqyYqaSpylfnXbJoMNzvJSGOJN6wbqXMVroRZUG904IbzB+QSHKEs2
         b2pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689616003; x=1692208003;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=NSjTGufRcF11GNkReUys5ziCSGxlh+o8DY7lEbj9Ao8=;
        b=iMSF03dnK4ZP8LEZMuKZd9Q18LBrsWM7wticMw/qSkODJA3dJOVZQp0H3SCyfKiMeE
         KCcud5rfXBoE0/vKq8lThS4RKMgDhGMN2p6rvR7ibCt2ng1vQolR8nflag3x7K9s1yvm
         /l9JhwhLhYRFdxtYnIcxdEQgcsZNsvcmby1eG3OvRt0khUENG2X723vhcwWcFhCWooqp
         0vpdttgatfzNMySBEkVai2yiSbmu7WLdY0Sa3DJGMHJSygU59TxDAQHrQIg4rBgPrC8R
         dFZqsElKPuXDjHvf9XmNWs2B8xXIuQKr3N0RjgnH9GYbpK55cj/Mq7VXK/DqDJV/4O2I
         jc/w==
X-Gm-Message-State: ABy/qLYWjjUzoOxuUA0rtu8BKptaQYOrq9SkD4RqhLCUINvdHPuUt4lN
        q/A4nysHf367F9iiB7cIkYHcxg==
X-Google-Smtp-Source: APBJJlHlsTru1G39D2V2QucJ9ja5Ee9kkBPG3tleHuCy73gPTh7uDUDgcXK8pFdtKWwVvRGLLrWrUQ==
X-Received: by 2002:a0c:aad4:0:b0:636:10ce:5203 with SMTP id g20-20020a0caad4000000b0063610ce5203mr11480215qvb.38.1689616003040;
        Mon, 17 Jul 2023 10:46:43 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id b14-20020a0ccd0e000000b006301d3caba8sm70345qvm.50.2023.07.17.10.46.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 10:46:42 -0700 (PDT)
Date:   Mon, 17 Jul 2023 13:46:41 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 07/17] btrfs: adapt readdir for encrypted and nokey
 names
Message-ID: <20230717174641.GK691303@perftesting>
References: <cover.1689564024.git.sweettea-kernel@dorminy.me>
 <ba4d9065b8109ea74fc1c5bed788e45c95a07e75.1689564024.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ba4d9065b8109ea74fc1c5bed788e45c95a07e75.1689564024.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jul 16, 2023 at 11:52:38PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> Deleting an encrypted file must always be permitted, even if the user
> does not have the appropriate key. Therefore, for listing an encrypted
> directory, so-called 'nokey' names are provided, and these nokey names
> must be sufficient to look up and delete the appropriate encrypted
> files. See 'struct fscrypt_nokey_name' for more information on the
> format of these names.
> 
> The first part of supporting nokey names is allowing lookups by nokey
> name. Only a few entry points need to support these: deleting a
> directory, file, or subvolume -- each of these call
> fscrypt_setup_filename() with a '1' argument, indicating that the key is
> not required and therefore a nokey name may be provided. If a nokey name
> is provided, the fscrypt_name returned by fscrypt_setup_filename() will
> not have its disk_name field populated, but will have various other
> fields set.
> 
> This change alters the relevant codepaths to pass a complete
> fscrypt_name anywhere that it might contain a nokey name. When it does
> contain a nokey name, the first time the name is successfully matched to
> a stored name populates the disk name field of the fscrypt_name,
> allowing the caller to use the normal disk name codepaths afterward.
> Otherwise, the matching functionality is in close analogue to the
> function fscrypt_match_name().
> 
> Functions where most callers are providing a fscrypt_str are duplicated
> and adapted for a fscrypt_name, and functions where most callers are
> providing a fscrypt_name are changed to so require at all callsites.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/btrfs_inode.h   |   2 +-
>  fs/btrfs/delayed-inode.c |  30 +++++++-
>  fs/btrfs/delayed-inode.h |   4 +-
>  fs/btrfs/dir-item.c      |  77 ++++++++++++++++++---
>  fs/btrfs/dir-item.h      |  13 +++-
>  fs/btrfs/extent_io.c     |  38 +++++++++++
>  fs/btrfs/extent_io.h     |   3 +
>  fs/btrfs/fscrypt.c       |  46 +++++++++++++
>  fs/btrfs/fscrypt.h       |  19 ++++++
>  fs/btrfs/inode.c         | 143 ++++++++++++++++++++++++++-------------
>  fs/btrfs/root-tree.c     |   8 ++-
>  fs/btrfs/root-tree.h     |   2 +-
>  fs/btrfs/tree-log.c      |   3 +-
>  13 files changed, 320 insertions(+), 68 deletions(-)
> 
> diff --git a/fs/btrfs/btrfs_inode.h b/fs/btrfs/btrfs_inode.h
> index ec4a06a78aff..464059674ae5 100644
> --- a/fs/btrfs/btrfs_inode.h
> +++ b/fs/btrfs/btrfs_inode.h
> @@ -421,7 +421,7 @@ struct inode *btrfs_lookup_dentry(struct inode *dir, struct dentry *dentry);
>  int btrfs_set_inode_index(struct btrfs_inode *dir, u64 *index);
>  int btrfs_unlink_inode(struct btrfs_trans_handle *trans,
>  		       struct btrfs_inode *dir, struct btrfs_inode *inode,
> -		       const struct fscrypt_str *name);
> +		       struct fscrypt_name *name);
>  int btrfs_add_link(struct btrfs_trans_handle *trans,
>  		   struct btrfs_inode *parent_inode, struct btrfs_inode *inode,
>  		   const struct fscrypt_str *name, int add_backref, u64 index);
> diff --git a/fs/btrfs/delayed-inode.c b/fs/btrfs/delayed-inode.c
> index 6b457b010cbc..919303d29b76 100644
> --- a/fs/btrfs/delayed-inode.c
> +++ b/fs/btrfs/delayed-inode.c
> @@ -1497,6 +1497,7 @@ int btrfs_insert_delayed_dir_index(struct btrfs_trans_handle *trans,
>  
>  	ret = __btrfs_add_delayed_item(delayed_node, delayed_item);
>  	if (unlikely(ret)) {
> +		// TODO: It would be nice to print the base64encoded name here maybe?

Generally we don't leve TODO's around unless they're big, additionally wrong
comment format.

<snip>

> +/*
> + * This function is extremely similar to fscrypt_match_name() but uses an
> + * extent_buffer. Also, it edits the provided argument to populate the disk_name
> + * if we successfully match and previously were using a nokey name.
> + */
> +bool btrfs_fscrypt_match_name(struct fscrypt_name *fname,
> +			      struct extent_buffer *leaf, unsigned long de_name,
> +			      u32 de_name_len)
> +{
> +	const struct fscrypt_nokey_name *nokey_name =
> +		(const void *)fname->crypto_buf.name;

Cast it to the thing it's going to be, als this whol function needs more
newlines.

> +	u8 digest[SHA256_DIGEST_SIZE];
> +
> +	if (likely(fname->disk_name.name)) {
> +		if (de_name_len != fname->disk_name.len)
> +			return false;
> +		return !memcmp_extent_buffer(leaf, fname->disk_name.name,
> +					     de_name, de_name_len);
> +	}
> +	if (de_name_len <= sizeof(nokey_name->bytes))
> +		return false;
> +	if (memcmp_extent_buffer(leaf, nokey_name->bytes, de_name,
> +				 sizeof(nokey_name->bytes)))
> +		return false;
> +	extent_buffer_sha256(leaf, de_name + sizeof(nokey_name->bytes),
> +			     de_name_len - sizeof(nokey_name->bytes), digest);
> +	if (!memcmp(digest, nokey_name->sha256, sizeof(digest))) {
> +		/*
> +		 * For no-key names, we use this opportunity to find the disk
> +		 * name, so future searches don't need to deal with nokey names
> +		 * and we know what the encrypted size is.
> +		 */
> +		fname->disk_name.name = kmalloc(de_name_len, GFP_KERNEL | GFP_NOFS);

GFP_NOFS is sufficient.

> +		if (!fname->disk_name.name)
> +			fname->disk_name.name = ERR_PTR(-ENOMEM);

This part worries me, we use this code everywhere and it's just screaming for a
gotcha, I'd rather return an error in this case.  Thanks,

Josef
