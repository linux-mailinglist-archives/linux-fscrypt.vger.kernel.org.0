Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC40756762
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 17:18:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230192AbjGQPSX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jul 2023 11:18:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231239AbjGQPSW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jul 2023 11:18:22 -0400
Received: from mail-vs1-xe31.google.com (mail-vs1-xe31.google.com [IPv6:2607:f8b0:4864:20::e31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D662DA
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 08:18:20 -0700 (PDT)
Received: by mail-vs1-xe31.google.com with SMTP id ada2fe7eead31-440c14d6a5eso1309128137.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 08:18:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1689607099; x=1692199099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=Sb/TjCgoxCkEaq1liZdeE851FNOZqm93xdsJzWuf9Ko=;
        b=K4VxzGmZWiSZ7sVjmn3AxXL8f5/4si/EUv4sbrnaW9bL/H/559ObPYc0BMA8hWGTXW
         KS+TFR7KFohuldw7m0H1/OjuwJF16y9PLK60mq5StHqHaQid/lxmXdgCZ0jSBrmuaXP4
         Ws9uVpxyBoA+5jbpjbCACrfyDTPtsF+15+UWs2eZl1JDs+Nd72RfBtqj7+MWFggjiJO3
         3hIMAl/6FIF56f5piEuaqU480+XjM9PgnkGhxf0JxRbHO95BNV5g4pwAOSjHRhdAqryB
         PGSRfsntU9h8tGVo4mc5jY81XUBirtbnBZcdtyTddKSQnVzvS57Mm2eQGjhn/MH9KkR9
         Xa1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689607099; x=1692199099;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Sb/TjCgoxCkEaq1liZdeE851FNOZqm93xdsJzWuf9Ko=;
        b=epNIccE4SgXkxb9T/zEe/WANJzC3rOmh24iLpcFG2AuEIgltc1T66l8tW5LmuFfr2w
         GwZgXjSXnXw+tx4LU1bBrMRpfRXJI5pqIOr5LCKs63Yu9Y+Xip2XWAYXO/s/OUxAm287
         cDlGRRqQkToTF1j7xtyiRArNMdhYrWDHUzps0/UMA1L46IWqnS5NVW+aRpxawLJF6Kgy
         E09LjwFSx8bZdq1DzG2FVn3KP8Ayao/iZ7E7KuNkVFh8g1g76VjaRlhVUn5ZE89WUFtp
         SYKdMTteI1rD8JKdo08LPR8wkuVa1Wfotixle07Ubb9znYpqsV7QUXzaI67hFyuNuOJV
         mpFg==
X-Gm-Message-State: ABy/qLYkknQt9ULQ8PD60AiooOO4s7EWRMEz10ZeKdVDzrGO06ELrOVb
        QIJxvyqNugN4VjmAP8qFCOfPZ+3NdMfNe5qq5OfPtA==
X-Google-Smtp-Source: APBJJlEdPvve/MgjCiunH+IDI13ACNRfTHt0pS728K2NcplXyAjr8kgowJy4N55qk7kq5cA3Fzbp3A==
X-Received: by 2002:a05:6102:1d3:b0:445:a48:aae4 with SMTP id s19-20020a05610201d300b004450a48aae4mr5169201vsq.0.1689607099462;
        Mon, 17 Jul 2023 08:18:19 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id b14-20020a0ccd0e000000b0063627a022b0sm6478356qvm.49.2023.07.17.08.18.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 08:18:19 -0700 (PDT)
Date:   Mon, 17 Jul 2023 11:18:18 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 10/14] fscrypt: revamp key removal for extent
 encryption
Message-ID: <20230717151818.GE691303@perftesting>
References: <cover.1688927487.git.sweettea-kernel@dorminy.me>
 <c17187f7c9bb9a995ec8b428508bd62728b8de30.1688927487.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c17187f7c9bb9a995ec8b428508bd62728b8de30.1688927487.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jul 09, 2023 at 02:53:43PM -0400, Sweet Tea Dorminy wrote:
> Currently, for inode encryption, once an inode is open IO will not fail
> due to lack of key until the inode is closed. Even if the key is
> removed, open inodes will continue to use the key.
> 
> For extent encryption, it's a little harder, since the extent may not be
> createdi/loaded until well after the REMOVE_KEY ioctl is called. To be
> as similar to inode based encryption as plausible, this changes key
> removal to be 'soft' for extent-based encryption, allowing new extents
> to use keys which were in use by open inodes at the time of removal;
> this hopefully follows the discussion at [1].
> 
> [1] https://lore.kernel.org/linux-fscrypt/248eac32-96cc-eb2e-85da-422a8d75a376@dorminy.me/T/#m48f43837cf98e0212de2e70aa6435320e3532d6e
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/fscrypt_private.h | 37 ++++++++++++++++++++++++++++-----
>  fs/crypto/keyring.c         | 41 ++++++++++++++++++++++++++++---------
>  fs/crypto/keysetup.c        | 32 ++++++++++++++++++++++++++++-
>  3 files changed, 94 insertions(+), 16 deletions(-)
> 
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index 8bf27ceeecd1..926531597e7b 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -332,6 +332,21 @@ static inline bool fscrypt_uses_extent_encryption(const struct inode *inode)
>  	return false;
>  }
>  
> +/**
> + * fscrypt_fs_uses_extent_encryption() -- whether a filesystem uses per-extent
> + *				          encryption
> + *
> + * @sb: the superblock of the filesystem in question
> + *
> + * Return: true if the fs uses per-extent fscrypt_infos, false otherwise
> + */
> +static inline bool
> +fscrypt_fs_uses_extent_encryption(const struct super_block *sb)
> +{
> +	// No filesystems currently use per-extent infos
> +	return false;

Wrong comment format.

> +}
> +
>  /**
>   * fscrypt_get_info_ino() - get the ino or ino equivalent for an info
>   *
> @@ -556,11 +571,14 @@ struct fscrypt_master_key {
>  
>  	/*
>  	 * The secret key material.  After FS_IOC_REMOVE_ENCRYPTION_KEY is
> -	 * executed, this is wiped and no new inodes can be unlocked with this
> -	 * key; however, there may still be inodes in ->mk_decrypted_inodes
> -	 * which could not be evicted.  As long as some inodes still remain,
> -	 * FS_IOC_REMOVE_ENCRYPTION_KEY can be retried, or
> -	 * FS_IOC_ADD_ENCRYPTION_KEY can add the secret again.
> +	 * executed, no new inodes can be unlocked with this key; however,
> +	 * there may still be inodes in ->mk_decrypted_inodes which could not
> +	 * be evicted. For inode-based encryption, the secret is wiped; for
> +	 * extent-based encryption, the secret is preserved while inodes still
> +	 * reference it, as they may need to create new extents using the
> +	 * secret to service IO; @soft_deleted is set to true then. As long as
> +	 * some inodes still remain, FS_IOC_REMOVE_ENCRYPTION_KEY can be
> +	 * retried, or FS_IOC_ADD_ENCRYPTION_KEY can add the secret again.
>  	 *
>  	 * While ->mk_secret is present, one ref in ->mk_active_refs is held.
>  	 *
> @@ -599,6 +617,13 @@ struct fscrypt_master_key {
>  	struct list_head	mk_decrypted_inodes;
>  	spinlock_t		mk_decrypted_inodes_lock;
>  
> +	/*
> +	 * Whether the key is unavailable to new inodes, but still available
> +	 * to new extents within decrypted inodes. Protected by
> +	 * ->mk_decrypted_inodes_lock.
> +	 */
> +	bool			mk_soft_deleted;
> +

You say this is protected by mk_decrypted_inodes_lock, but you only ever take it
when you set it to false.  It looks like it's more used to gate behavior, so the
locking is sort of inconsistent and doesn't appear to be needed?  Can you just
do READ_ONCE()/WRITE_ONCE() and it's fine?  If not you need to wrap it in the
lock where you're accessing it.  Thanks,

Josef
