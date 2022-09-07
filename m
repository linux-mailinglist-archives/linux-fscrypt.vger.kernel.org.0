Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CAE975B0E0D
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Sep 2022 22:22:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiIGUWo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Sep 2022 16:22:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229522AbiIGUWn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Sep 2022 16:22:43 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B4B1C0E49;
        Wed,  7 Sep 2022 13:22:42 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 1821E1FAFE;
        Wed,  7 Sep 2022 20:22:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662582161;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=paBRVM65BwgXxhyP90ZlfEIopEuCsj1pFD679G/sKVA=;
        b=S4B3Bg1IZYXkZwbL3ygBp8YJ2tbgLiLRugkapFzHSHfMG3g/pK2wOJb1CKbR9UZdUIJ8sk
        I9ecqmQMgZ/lpO0kR5KbwrmFgp4cUlsssrKJDIJG8Bz5/ccmm/P/aiMSJ0CS1+zVbSitrx
        Jlejqult41/+l9HpWLY9eP7MirPPaBk=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662582161;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=paBRVM65BwgXxhyP90ZlfEIopEuCsj1pFD679G/sKVA=;
        b=hcnAk0Z1e+RAbuuyT0BfYe99WpdcJ0xMyUx4h1LAXX9DgGQvYwPMxTcilb/jV4qELGlgzI
        qAZxULtsD2yvg+AA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id CBFFB13486;
        Wed,  7 Sep 2022 20:22:40 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 0SziMJD9GGNTQAAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 07 Sep 2022 20:22:40 +0000
Date:   Wed, 7 Sep 2022 22:17:17 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 12/20] btrfs: start using fscrypt hooks.
Message-ID: <20220907201717.GK32411@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <4b27b127a4048a58af965634436b562ec1217c82.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4b27b127a4048a58af965634436b562ec1217c82.1662420176.git.sweettea-kernel@dorminy.me>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:27PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> In order to appropriately encrypt, create, open, rename, and various symlink
> operations must call fscrypt hooks. These determine whether the inode
> should be encrypted and do other preparatory actions. The superblock
> must have fscrypt operations registered, so implement the minimal set
> also.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/ctree.h   |  1 +
>  fs/btrfs/file.c    |  3 ++
>  fs/btrfs/fscrypt.c |  3 ++
>  fs/btrfs/fscrypt.h |  1 +
>  fs/btrfs/inode.c   | 91 ++++++++++++++++++++++++++++++++++++++++------
>  fs/btrfs/super.c   |  3 ++
>  6 files changed, 90 insertions(+), 12 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index 230537a007b6..2b9ba8d77861 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -3416,6 +3416,7 @@ struct btrfs_new_inode_args {
>  	 */
>  	struct posix_acl *default_acl;
>  	struct posix_acl *acl;
> +	bool encrypt;
>  };
>  int btrfs_new_inode_prepare(struct btrfs_new_inode_args *args,
>  			    unsigned int *trans_num_items);
> diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> index 7216ac1f860c..929a0308676c 100644
> --- a/fs/btrfs/file.c
> +++ b/fs/btrfs/file.c
> @@ -3695,6 +3695,9 @@ static int btrfs_file_open(struct inode *inode, struct file *filp)
>  	int ret;
>  
>  	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
> +	ret = fscrypt_file_open(inode, filp);
> +	if (ret)
> +		return ret;
>  
>  	ret = fsverity_file_open(inode, filp);

Can fsverity and fscrypt can be used at the same time?

>  	if (ret)
> --- a/fs/btrfs/fscrypt.h
> +++ b/fs/btrfs/fscrypt.h
> @@ -22,4 +22,5 @@ static bool btrfs_fscrypt_match_name(const struct fscrypt_name *fname,
>  }
>  #endif
>  
> +extern const struct fscrypt_operations btrfs_fscrypt_ops;

Please keep a blank line before the last #endif

>  #endif /* BTRFS_FSCRYPT_H */
> @@ -9907,15 +9927,22 @@ static int btrfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
>  	};
>  	unsigned int trans_num_items;
>  	int err;
> -	int name_len;
>  	int datasize;
>  	unsigned long ptr;
>  	struct btrfs_file_extent_item *ei;
>  	struct extent_buffer *leaf;
> +	struct fscrypt_str disk_link;
> +	u32 name_len = strlen(symname);
>  
> -	name_len = strlen(symname);
> -	if (name_len > BTRFS_MAX_INLINE_DATA_SIZE(fs_info))
> -		return -ENAMETOOLONG;
> +	/*
> +	 * fscrypt sets disk_link.len to be len + 1, including a NULL terminator, but we
> +	 * don't store that NULL.

I think it should be referred to as NUL character, or as '\0'.

> +	 */
> +	err = fscrypt_prepare_symlink(dir, symname, name_len,
> +				      BTRFS_MAX_INLINE_DATA_SIZE(fs_info) + 1,
> +				      &disk_link);
> +	if (err)
> +		return err;
>  
>  	inode = new_inode(dir->i_sb);
>  	if (!inode)
> @@ -9994,6 +10035,29 @@ static int btrfs_symlink(struct user_namespace *mnt_userns, struct inode *dir,
> --- a/fs/btrfs/super.c
> +++ b/fs/btrfs/super.c
> @@ -47,6 +47,8 @@
>  #include "tests/btrfs-tests.h"
>  #include "block-group.h"
>  #include "discard.h"
> +#include "fscrypt.h"

No newline please

> +
>  #include "qgroup.h"
>  #include "raid56.h"
>  #define CREATE_TRACE_POINTS
