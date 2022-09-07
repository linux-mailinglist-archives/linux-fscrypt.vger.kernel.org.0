Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8450E5B0DC5
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Sep 2022 22:09:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229445AbiIGUJl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Sep 2022 16:09:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiIGUJk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Sep 2022 16:09:40 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C7CBDF4B;
        Wed,  7 Sep 2022 13:09:37 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id E77A52078D;
        Wed,  7 Sep 2022 20:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662581375;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EgB7BkrIr3736Ez1yx7slg7kuAdT7bIsetRYj0Zrcb0=;
        b=k+01TYRiR1s9Tbq71ty+Ri7yukbBM/SHXI1NGhxQcqSDSgZnSCmJ68o/iLafdpEg+spSoy
        dOvpVzYZdycPqqkclqDnf7UZdtd6hV8TBzD/fy0AOnuPgBRSUf3vkI5ZejumD5QB/lqgU9
        RnpK3LhUw/u5ClWKHwUUkCOlCxwjNoE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662581375;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=EgB7BkrIr3736Ez1yx7slg7kuAdT7bIsetRYj0Zrcb0=;
        b=ZB9nQJ8uod5cIf3fgU7gTjv4fjeLEKFIqHpWpBl1NF15bn3/q48QRMaKHaTUOpcQd0TCtw
        1N+PW/VXoK+BCoAQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A390713486;
        Wed,  7 Sep 2022 20:09:35 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id SLkHJ3/6GGOAPAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 07 Sep 2022 20:09:35 +0000
Date:   Wed, 7 Sep 2022 22:04:12 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 08/20] btrfs: use fscrypt_names instead of name/len
 everywhere.
Message-ID: <20220907200412.GI32411@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <2b32b14368c67eb8591ccc4b0cf9d19358dfae23.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b32b14368c67eb8591ccc4b0cf9d19358dfae23.1662420176.git.sweettea-kernel@dorminy.me>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:23PM -0400, Sweet Tea Dorminy wrote:
> For encryption, the plaintext filenames provided by the VFS will need to
> be translated to ciphertext filenames on disk. Fscrypt provides a struct
> to encapsulate a potentially encrypted filename, struct fscrypt_name.
> This change converts every (name, len) pair to be a struct fscrypt_name,
> statically initialized, for ease of review and uniformity.

Is there some clear boundary where the name needs to be encoded or
decoded? I don't think we should use fscrypt_name in so many functions,
namely internal helpers that really only care about the plain name +
length. Such widespread use fscrypt structure would make it hard to
synchronize with the user space sources.

What we could do to ease the integragtion with the fscrypt name is to
use the qstr structure, ie. something that's easily convertible to the
fscrypt_name::usr_fname.

> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -21,11 +21,13 @@
>  #include <linux/pagemap.h>
>  #include <linux/btrfs.h>
>  #include <linux/btrfs_tree.h>
> +#include <linux/fscrypt.h>
>  #include <linux/workqueue.h>
>  #include <linux/security.h>
>  #include <linux/sizes.h>
>  #include <linux/dynamic_debug.h>
>  #include <linux/refcount.h>
> +#include <linux/crc32.h>
>  #include <linux/crc32c.h>
>  #include <linux/iomap.h>
>  #include "extent-io-tree.h"
> @@ -2803,18 +2805,19 @@ static inline void btrfs_crc32c_final(u32 crc, u8 *result)
>  	put_unaligned_le32(~crc, result);
>  }
>  
> -static inline u64 btrfs_name_hash(const char *name, int len)
> +static inline u64 btrfs_name_hash(const struct fscrypt_name *name)
>  {
> -       return crc32c((u32)~1, name, len);
> +	return crc32c((u32)~1, fname_name(name), fname_len(name));

This for example is a primitive helper that just hashes the correct
bytes and does not need to know anything about whether it's encrypted or
not. That should be set up higher in the call chain.

> --- a/fs/btrfs/inode.c
> +++ b/fs/btrfs/inode.c
> @@ -3863,11 +3863,19 @@ static noinline int acls_after_inode_item(struct extent_buffer *leaf,
>  	static u64 xattr_default = 0;
>  	int scanned = 0;
>  
> +	struct fscrypt_name name_access = {
> +		.disk_name = FSTR_INIT(XATTR_NAME_POSIX_ACL_ACCESS,
> +				       strlen(XATTR_NAME_POSIX_ACL_ACCESS))
> +	};
> +
> +	struct fscrypt_name name_default = {
> +		.disk_name = FSTR_INIT(XATTR_NAME_POSIX_ACL_DEFAULT,
> +				       strlen(XATTR_NAME_POSIX_ACL_DEFAULT))
> +	};
> +
>  	if (!xattr_access) {
> -		xattr_access = btrfs_name_hash(XATTR_NAME_POSIX_ACL_ACCESS,
> -					strlen(XATTR_NAME_POSIX_ACL_ACCESS));
> -		xattr_default = btrfs_name_hash(XATTR_NAME_POSIX_ACL_DEFAULT,
> -					strlen(XATTR_NAME_POSIX_ACL_DEFAULT));
> +		xattr_access = btrfs_name_hash(&name_access);
> +		xattr_default = btrfs_name_hash(&name_default);

And here it needs extra structure just to pass plain strings.

> +			   __func__, fname_name(&fname), btrfs_ino(BTRFS_I(dir)),
>  			   location->objectid, location->type, location->offset);
>  	}
>  	if (!ret)
> @@ -6243,6 +6258,14 @@ int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
>  	if (ret)
>  		return ret;
>  
> +	if (!args->orphan) {
> +		char *name = (char *) args->dentry->d_name.name;
> +		int name_len = args->dentry->d_name.len;

Please put a newline between declaration and statement block.

> +		args->fname = (struct fscrypt_name) {
> +			.disk_name = FSTR_INIT(name, name_len),
> +		};

Please don't use this construct to intialize compounds, we don't use it
anywhere. There are more examples for other structures too.

> +	}
> +
>  	/* 1 to add inode item */
>  	*trans_num_items = 1;
>  	/* 1 to add compression property */
> --- a/fs/btrfs/transaction.c
> +++ b/fs/btrfs/transaction.c
> @@ -1596,8 +1596,9 @@ static int qgroup_account_snapshot(struct btrfs_trans_handle *trans,
>   * happens, we should return the error number. If the error which just affect
>   * the creation of the pending snapshots, just return 0.
>   */
> -static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
> -				   struct btrfs_pending_snapshot *pending)
> +static noinline int
> +create_pending_snapshot(struct btrfs_trans_handle *trans,
> +			struct btrfs_pending_snapshot *pending)

Please keep the specifiers and type on the same line as the function
name, the parameters can slightly overfrlow the 80 char limit if it
avoids a line break, otherwise the patameters go on the next line.
