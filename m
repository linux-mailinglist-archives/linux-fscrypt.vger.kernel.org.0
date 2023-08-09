Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DF5EE7767A4
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Aug 2023 20:51:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231449AbjHISve (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 9 Aug 2023 14:51:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232614AbjHISve (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 9 Aug 2023 14:51:34 -0400
Received: from mail-qk1-x733.google.com (mail-qk1-x733.google.com [IPv6:2607:f8b0:4864:20::733])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ED49213B
        for <linux-fscrypt@vger.kernel.org>; Wed,  9 Aug 2023 11:51:15 -0700 (PDT)
Received: by mail-qk1-x733.google.com with SMTP id af79cd13be357-76cdf055c64so10874285a.3
        for <linux-fscrypt@vger.kernel.org>; Wed, 09 Aug 2023 11:51:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1691607074; x=1692211874;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=RGP5u3WkOrozn/SGbM2yOPuLnrA0Q3aYp8unPGXTaak=;
        b=jM0wN/IopKQLXZ04s0joeBMlUX7MnxBaR2t2fqMhkPm/sO1ZSV4wS0nu/alCF2aZ7X
         uK48YrrakKWLHxjpkdjIwPlFHiWYthmnR8p5kqa0wKSgGP5T27pPR1PVFaC+5GPyj4Ad
         zDPqPl4m810nQXjhF6p5xQHXs+F0dZuqhq9p6dqPc2FVPFYOuXNUzZ9ZFjFmR8+J0Vsb
         5+RC7/O/0+qh8uhb2RdYhfsXh36bDzKqknCxDSapDjr/oJOGkFP85HyGYP1H7oFzotN2
         BvCla5IjkOkOJIlDedi7lvd3/Eexrsi+wT+coWW18emZnw3wK0CLZiFbJN3jmwQkPtcI
         FRYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691607074; x=1692211874;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=RGP5u3WkOrozn/SGbM2yOPuLnrA0Q3aYp8unPGXTaak=;
        b=T9kxWvlF01sx90Rw+iATTA10XkQ3bp/ulCStt5a34GZftFx0uir4gxs14jclcZHJvc
         A+azU6rWbL/Iu/eMQlWlYeQ6qSZvwomF8sLFnTDlUvs7sqKcd11mTa9tDH5FIkhL9FWC
         TZl1X+/snkYs0GukGqCaRsf7ehec6geIZ5fsoAeE74nfWGwQaNg5lDFPrAQlQfqesgg1
         ECgqYmkIa0tWR1A9IRgpD72cCj10dj32DMwazOnUwoOuj1TiqZTsOhE6BPGBHHOrfkhn
         N5DMjo2XzVmB3ri3KWT2SNsu9868bGvsrLuOWyOSGkZHiXaWXYTJbjBoje/sodqe0gnv
         hf1g==
X-Gm-Message-State: AOJu0Yzq0KVPMuZAXijs4bGPjbvVbBkr1l3pzP6atLSrBijCW9izcER8
        TI2oL8Yeg3USaAsGTSQZ10RSaw==
X-Google-Smtp-Source: AGHT+IFldRYewjU5XHfDhuAXDLpsmMRHcuhqbV3tXzJPlxo6d7nxAVICpxHhLH3RajOi8qQ1nTg18g==
X-Received: by 2002:a05:620a:4052:b0:76c:b0f3:d3f1 with SMTP id i18-20020a05620a405200b0076cb0f3d3f1mr4224960qko.64.1691607074213;
        Wed, 09 Aug 2023 11:51:14 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id g25-20020a37e219000000b00767cbd5e942sm4161348qki.72.2023.08.09.11.51.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 11:51:13 -0700 (PDT)
Date:   Wed, 9 Aug 2023 14:51:12 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v3 07/16] fscrypt: use an optional ino equivalent for
 per-extent infos
Message-ID: <20230809185112.GI2516732@perftesting>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
 <8c40d7b6897875be8f908ca4aabf280c2f15b8d4.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c40d7b6897875be8f908ca4aabf280c2f15b8d4.1691505882.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 08, 2023 at 01:08:24PM -0400, Sweet Tea Dorminy wrote:
> Since per-extent infos are not tied to inodes, an ino-based policy
> cannot access the inode's i_ino to get the necessary information.
> Instead, this adds an optional fscrypt_operation pointer to get the ino
> equivalent for an extent, adds a wrapper to get the ino for an info, and
> uses this wrapper everywhere where the ci's inode's i_ino is currently
> accessed.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/fscrypt_private.h | 18 ++++++++++++++++++
>  fs/crypto/keyring.c         |  8 ++++----
>  fs/crypto/keysetup.c        |  6 +++---
>  include/linux/fscrypt.h     |  9 +++++++++
>  4 files changed, 34 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index 1244797cd8a9..4fe79b774f1f 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -332,6 +332,24 @@ static inline bool fscrypt_uses_extent_encryption(const struct inode *inode)
>  	return false;
>  }
>  
> +/**
> + * fscrypt_get_info_ino() - get the ino or ino equivalent for an info
> + *
> + * @ci: the fscrypt_info in question
> + *
> + * Return: For inode-based encryption, this will return the info's inode's ino.
> + * For extent-based encryption, this will return the extent's ino equivalent
> + * or 0 if it is not implemented.
> + */
> +static inline u64 fscrypt_get_info_ino(const struct fscrypt_info *ci)
> +{
> +	if (ci->ci_inode)
> +		return ci->ci_inode->i_ino;
> +	if (!ci->ci_sb->s_cop->get_extent_ino_equivalent)
> +		return 0;
> +	return ci->ci_sb->s_cop->get_extent_ino_equivalent(ci->ci_info_ptr);
> +}
> +
>  /* crypto.c */
>  extern struct kmem_cache *fscrypt_info_cachep;
>  int fscrypt_initialize(struct super_block *sb);
> diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
> index 7cbb1fd872ac..53e37b8a822c 100644
> --- a/fs/crypto/keyring.c
> +++ b/fs/crypto/keyring.c
> @@ -914,12 +914,12 @@ static int check_for_busy_inodes(struct super_block *sb,
>  	}
>  
>  	{
> -		/* select an example file to show for debugging purposes */
> -		struct inode *inode =
> +		/* select an example info to show for debugging purposes */
> +		struct fscrypt_info *ci =
>  			list_first_entry(&mk->mk_decrypted_inodes,
>  					 struct fscrypt_info,
> -					 ci_master_key_link)->ci_inode;
> -		ino = inode->i_ino;
> +					 ci_master_key_link);
> +		ino = fscrypt_get_info_ino(ci);
>  	}
>  	spin_unlock(&mk->mk_decrypted_inodes_lock);
>  
> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
> index c72f9015ed35..32e62cc57708 100644
> --- a/fs/crypto/keysetup.c
> +++ b/fs/crypto/keysetup.c
> @@ -380,10 +380,10 @@ int fscrypt_derive_dirhash_key(struct fscrypt_info *ci,
>  void fscrypt_hash_inode_number(struct fscrypt_info *ci,
>  			       const struct fscrypt_master_key *mk)
>  {
> -	WARN_ON_ONCE(ci->ci_inode->i_ino == 0);
> +	WARN_ON_ONCE(fscrypt_get_info_ino(ci) == 0);
>  	WARN_ON_ONCE(!mk->mk_ino_hash_key_initialized);
>  
> -	ci->ci_hashed_ino = (u32)siphash_1u64(ci->ci_inode->i_ino,
> +	ci->ci_hashed_ino = (u32)siphash_1u64(fscrypt_get_info_ino(ci),
>  					      &mk->mk_ino_hash_key);
>  }
>  
> @@ -705,7 +705,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
>  		if (res)
>  			goto out;
>  
> -		if (inode->i_ino)
> +		if (fscrypt_get_info_ino(crypt_info))
>  			fscrypt_hash_inode_number(crypt_info, mk);
>  	}
>  
> diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
> index c895b12737a1..2a64e7a71a53 100644
> --- a/include/linux/fscrypt.h
> +++ b/include/linux/fscrypt.h
> @@ -160,6 +160,15 @@ struct fscrypt_operations {
>  	void (*get_ino_and_lblk_bits)(struct super_block *sb,
>  				      int *ino_bits_ret, int *lblk_bits_ret);
>  
> +	/*
> +	 * Get the inode number equivalent for filesystems using per-extent
> +	 * encryption keys.
> +	 *
> +	 * This function only needs to be implemented if support for one of the
> +	 * FSCRYPT_POLICY_FLAG_IV_INO_* flags is needed.
> +	 */
> +	u64 (*get_extent_ino_equivalent)(struct fscrypt_info **info_ptr);
> +

I went and looked at your tree and nobody actually uses this.  I understand
wanting to add something for future expansion, but we're just sort of adding
things and hoping they'll be useful one day.  I think it's best to leave this
off and if somebody needs it they can add it later.  Thanks,

Josef
