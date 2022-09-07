Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97A7E5B0F01
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Sep 2022 23:16:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbiIGVQV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Sep 2022 17:16:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229502AbiIGVQT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Sep 2022 17:16:19 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D92418B38;
        Wed,  7 Sep 2022 14:16:18 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id CA7923416F;
        Wed,  7 Sep 2022 21:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662585376;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7CMsU1GQnU3lq/he5KDB4Tg9Cv/BOe0FtaA8szJgAT0=;
        b=c0Bp/Od+P8Ze69Rb/i2wVmp71wkaRaDVvQpkQld2DSyt2k4GkclzM77q7IaI8Xxti/5meW
        fNWtgKXSA1Z943eacIB5fkoZ2Aqij9NSh0pmFt6tHo5URHSSxVMtnrg+KDLQGMSKDgHyYB
        0NAcvG0GqUE7ehDNHQr9Lee3f8GeSNo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662585376;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7CMsU1GQnU3lq/he5KDB4Tg9Cv/BOe0FtaA8szJgAT0=;
        b=UJnMu036+/ZQFwiYONz6emNAW9l6F+xC8seLoPvPiNv6zWoGl5FdrM0/y7r7NU+bKhQev2
        8WnAlW0yN9WyK2AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 84B1F13A66;
        Wed,  7 Sep 2022 21:16:16 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id cJR0HyAKGWNvTwAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 07 Sep 2022 21:16:16 +0000
Date:   Wed, 7 Sep 2022 23:10:53 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 15/20] btrfs: store a fscrypt extent context per
 normal file extent
Message-ID: <20220907211053.GM32411@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <460baa45489be139b48e7b152852bda919363b4c.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <460baa45489be139b48e7b152852bda919363b4c.1662420176.git.sweettea-kernel@dorminy.me>
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

On Mon, Sep 05, 2022 at 08:35:30PM -0400, Sweet Tea Dorminy wrote:
> In order to encrypt data, each file extent must have its own persistent
> fscrypt_extent_context, which is then provided to fscrypt upon request.
> This is only needed for encrypted extents and is of variable size on
> disk, so file extents must additionally keep track of their actual
> length.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/ctree.h                | 30 +++++++++++
>  fs/btrfs/extent_map.h           |  4 ++
>  fs/btrfs/file-item.c            | 13 +++++
>  fs/btrfs/file.c                 |  4 +-
>  fs/btrfs/fscrypt.c              | 21 ++++++++
>  fs/btrfs/fscrypt.h              | 23 +++++++++
>  fs/btrfs/inode.c                | 89 +++++++++++++++++++++++++--------
>  fs/btrfs/ordered-data.c         |  9 +++-
>  fs/btrfs/ordered-data.h         |  4 +-
>  fs/btrfs/reflink.c              |  1 +
>  fs/btrfs/tree-checker.c         | 36 ++++++++++---
>  fs/btrfs/tree-log.c             | 11 +++-
>  include/uapi/linux/btrfs_tree.h |  9 ++++
>  13 files changed, 220 insertions(+), 34 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index f0a16c32110d..38927a867028 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -37,6 +37,7 @@
>  #include "async-thread.h"
>  #include "block-rsv.h"
>  #include "locking.h"
> +#include "fscrypt.h"
>  
>  struct btrfs_trans_handle;
>  struct btrfs_transaction;
> @@ -1437,6 +1438,7 @@ struct btrfs_replace_extent_info {
>  	u64 file_offset;
>  	/* Pointer to a file extent item of type regular or prealloc. */
>  	char *extent_buf;
> +	u32 extent_buf_size;

Please add a comment

>  	/*
>  	 * Set to true when attempting to replace a file range with a new extent
>  	 * described by this structure, set to false when attempting to clone an
> @@ -2659,6 +2661,16 @@ BTRFS_SETGET_STACK_FUNCS(stack_file_extent_disk_num_bytes,
>  			 struct btrfs_file_extent_item, disk_num_bytes, 64);
>  BTRFS_SETGET_STACK_FUNCS(stack_file_extent_compression,
>  			 struct btrfs_file_extent_item, compression, 8);
> +BTRFS_SETGET_STACK_FUNCS(stack_file_extent_encryption,
> +			 struct btrfs_file_extent_item, encryption, 8);
> +
> +static inline u8
> +btrfs_stack_file_extent_encryption_ctxsize(struct btrfs_file_extent_item *e)

type name(...) on the same line

> +{
> +	u8 ctxsize;
> +	btrfs_unpack_encryption(e->encryption, NULL, &ctxsize);
> +	return ctxsize;
> +}
>  
>  static inline unsigned long
>  btrfs_file_extent_inline_start(const struct btrfs_file_extent_item *e)
> --- a/fs/btrfs/fscrypt.h
> +++ b/fs/btrfs/fscrypt.h
> @@ -5,6 +5,14 @@
>  
>  #include <linux/fscrypt.h>
>  
> +#define BTRFS_ENCRYPTION_POLICY_MASK 0x03
> +#define BTRFS_ENCRYPTION_CTXSIZE_MASK 0xfc

Where do the numbers come from?

> +
> +struct btrfs_fscrypt_extent_context {
> +	u8 buffer[FSCRYPT_EXTENT_CONTEXT_MAX_SIZE];

FSCRYPT_EXTENT_CONTEXT_MAX_SIZE is 33 and btrfs_fscrypt_extent_context
is part of extent_map, that's quite common object. Random sample from my
desktop right now is around 800k objects so this is noticeable. Needs a
second look.

> +	size_t len;
> +};
> +
>  #ifdef CONFIG_FS_ENCRYPTION
>  bool btrfs_fscrypt_match_name(const struct fscrypt_name *fname,
>  			      struct extent_buffer *leaf,
> @@ -22,5 +30,20 @@ static bool btrfs_fscrypt_match_name(const struct fscrypt_name *fname,
>  }
>  #endif
>  
> +static inline void btrfs_unpack_encryption(u8 encryption,
> +					   u8 *policy,
> +					   u8 *ctxsize)
> +{
> +	if (policy)
> +		*policy = encryption & BTRFS_ENCRYPTION_POLICY_MASK;
> +	if (ctxsize)
> +		*ctxsize = (encryption & BTRFS_ENCRYPTION_CTXSIZE_MASK) >> 2;
> +}
> +
> +static inline u8 btrfs_pack_encryption(u8 policy, u8 ctxsize)
> +{
> +	return policy | (ctxsize << 2);

What does 2 mean? It should be some symbolic define with explanation as
it's defining on-disk format.

> +}
> +
>  extern const struct fscrypt_operations btrfs_fscrypt_ops;
>  #endif /* BTRFS_FSCRYPT_H */
> --- a/fs/btrfs/ordered-data.h
> +++ b/fs/btrfs/ordered-data.h
> @@ -99,6 +99,7 @@ struct btrfs_ordered_extent {
>  	u64 disk_bytenr;
>  	u64 disk_num_bytes;
>  	u64 offset;
> +	struct btrfs_fscrypt_extent_context fscrypt_context;

And another embedded btrfs_fscrypt_extent_context, that can also get a
lot of slab objects.

>  	/* number of bytes that still need writing */
>  	u64 bytes_left;
> --- a/include/uapi/linux/btrfs_tree.h
> +++ b/include/uapi/linux/btrfs_tree.h
> @@ -820,6 +820,10 @@ struct btrfs_file_extent_item {
>  	 * but not for stat.
>  	 */
>  	__u8 compression;
> +	/*
> +	 * This field contains 4 bits of encryption type in the lower bits,
> +	 * 4 bits of ivsize in the upper bits. The unencrypted value is 0.

Is there some rationale for this format? Can the encryption bytes be
used only for the type and the other_encoding for the IV?

> +	 */
>  	__u8 encryption;
>  	__le16 other_encoding; /* spare for later use */
>  
