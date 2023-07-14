Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04CAB75426B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Jul 2023 20:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235553AbjGNSQR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 14 Jul 2023 14:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236403AbjGNSQO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 14 Jul 2023 14:16:14 -0400
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78E9C173F
        for <linux-fscrypt@vger.kernel.org>; Fri, 14 Jul 2023 11:16:13 -0700 (PDT)
Received: by mail-ot1-x332.google.com with SMTP id 46e09a7af769-6b73c2b6dcfso1478139a34.2
        for <linux-fscrypt@vger.kernel.org>; Fri, 14 Jul 2023 11:16:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1689358573; x=1691950573;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sd6bFmgytpFgRSYJA+uE0lCqoVsMdgxQuCSuSk1ecmY=;
        b=zco8UvuGput+Md5p9zIqDtkaB7jkaDUQGSd0DHETB+Q2ElzqJ2DzPNalVNUjiIEeQg
         PbTCGuE2VHI+IbmjZFf4v1MRrj0Ulc4SglXCMVn67+VsLrdJbc+dRADJLg92tVzjSbLv
         qes+eGo4VDS6thOf5gD+eItCk4cATgluHB44WxGNwDXD3vcYrfQAixM/jWOYIA2jUBzP
         RWpS8VV5vcX6qAdnlmRXT2aPBm6Grzx7pll9rfLkNG5I5+Syw2SX7NTtRw+xdM0UmL78
         Bd4JsCYY3RF1rETgG6Zm6Pu84VihfXJ7tSaxW6AdZ60I0dc2KAn4tSX/HTjtkd4lMq6j
         E43A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689358573; x=1691950573;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sd6bFmgytpFgRSYJA+uE0lCqoVsMdgxQuCSuSk1ecmY=;
        b=Dn9lF4BnU/Dcza963TM7Wxxscyfgs0gVAv5qgJpqkkRTjMqnCceQc1g21TL5gYuwcf
         osnftdgyP4EWELXikufqG0WD5HL4cVmTwbS8KWMC8upE6F+IeBuG1eDK0Mw/G9fJbJ8U
         r9YDqTvQ11K7MoTfup+sxTu4izalgeNIaGLuKNahrjgbqrOMFlmANN4gX8eLxI72eR3T
         00ISuBhtyL/eCe7UzVIGhg4uegHG5udkizql6aM4U7Mnzd1irwAwDVo/teza7FxvogLF
         ia35ts9KwzvBxoZd/kkcJARew67QMDF4dgylzZTYU7xAbGMJ+i1u2FKo6vxKZJjdCqRu
         UAHw==
X-Gm-Message-State: ABy/qLa0VtzZj7Ms1C99+UB+/eJunb3bOZ0i7GFRJSJvLn9YfcyxN3Ul
        +xzNa3gKBA/zHmaH7c91htLxpg==
X-Google-Smtp-Source: APBJJlHI82uGd3rgWXvp8jtm7XJKPLalTiaHwSmkE/YIwmb/w8wzPFK0slRAATx+Uh1sEtXlC9JSEQ==
X-Received: by 2002:a05:6870:5ba3:b0:1b0:81eb:ac9e with SMTP id em35-20020a0568705ba300b001b081ebac9emr5382169oab.20.1689358572556;
        Fri, 14 Jul 2023 11:16:12 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id y66-20020a0def45000000b00565d056a74bsm2450042ywe.139.2023.07.14.11.16.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Jul 2023 11:16:12 -0700 (PDT)
Date:   Fri, 14 Jul 2023 14:16:11 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 05/14] fscrypt: setup leaf inodes for extent encryption
Message-ID: <20230714181611.GB510453@perftesting>
References: <cover.1688927487.git.sweettea-kernel@dorminy.me>
 <9a4890026719e5d6dc16ee9338f309f3fa452d16.1688927487.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9a4890026719e5d6dc16ee9338f309f3fa452d16.1688927487.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jul 09, 2023 at 02:53:38PM -0400, Sweet Tea Dorminy wrote:
> For extent-based encryption, leaf/regular file inodes are special: it's
> useful to set their i_crypt_info field so that it's easy to inherit
> their encryption policy for a new extent, but they never need to do any
> encyption themselves. Additionally, since encryption can only be set up
> on a directory, not a single file, their encryption policy can always
> duplicate their parent inode's policy.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/fscrypt_private.h | 17 +++++++++++++
>  fs/crypto/keysetup.c        | 49 ++++++++++++++++++++++++++-----------
>  2 files changed, 52 insertions(+), 14 deletions(-)
> 
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index c04454c289fd..260635e8b558 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -308,6 +308,23 @@ fscrypt_get_lblk_info(const struct inode *inode, u64 lblk, u64 *offset,
>  	return inode->i_crypt_info;
>  }
>  
> +/**
> + * fscrypt_uses_extent_encryption() -- whether an inode uses per-extent
> + *				       encryption
> + *
> + * @inode: the inode in question
> + *
> + * Return: true if the inode uses per-extent fscrypt_infos, false otherwise
> + */
> +static inline bool fscrypt_uses_extent_encryption(const struct inode *inode)
> +{
> +	// Non-regular files don't have extents
> +	if (!S_ISREG(inode->i_mode))
> +		return false;
> +
> +	// No filesystems currently use per-extent infos
> +	return false;

Wrong comment format.

> +}
>  
>  /* crypto.c */
>  extern struct kmem_cache *fscrypt_info_cachep;
> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
> index c5f68cf65a6f..7469b2d8ac87 100644
> --- a/fs/crypto/keysetup.c
> +++ b/fs/crypto/keysetup.c
> @@ -747,27 +747,48 @@ fscrypt_setup_encryption_info(struct inode *inode,
>  int fscrypt_get_encryption_info(struct inode *inode, bool allow_unsupported)
>  {
>  	int res;
> -	union fscrypt_context ctx;
> +	union fscrypt_context ctx = { 0 };
>  	union fscrypt_policy policy;
>  
>  	if (fscrypt_has_encryption_key(inode))
>  		return 0;
>  
> -	res = inode->i_sb->s_cop->get_context(inode, &ctx, sizeof(ctx));
> -	if (res < 0) {
> -		if (res == -ERANGE && allow_unsupported)
> -			return 0;
> -		fscrypt_warn(inode, "Error %d getting encryption context", res);
> -		return res;
> -	}
> +	if (fscrypt_uses_extent_encryption(inode)) {
> +		/*
> +		 * Nothing will be encrypted with this info, so we can borrow
> +		 * the parent (dir) inode's policy and use a zero nonce.
> +		 */
> +		struct dentry *dentry = d_find_any_alias(inode);
> +		struct dentry *parent_dentry = dget_parent(dentry);
> +		struct inode *dir = parent_dentry->d_inode;
> +		bool found = false;
>  

Can this be extracted to a helper to keep this function cleaner?  Thanks,

Josef
