Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 986FA7566F8
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 16:59:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230293AbjGQO7j (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jul 2023 10:59:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40666 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229844AbjGQO7j (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jul 2023 10:59:39 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EF22110CF
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 07:59:37 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id af79cd13be357-76754b9eac0so447375685a.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 07:59:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1689605977; x=1692197977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=VXsqIY5baDadd/cbgt/XjCUDb85wvHlb5bHAuEVZNcg=;
        b=UzdnHF+tlKkQeCDum2I1s3LpmdGDOSLiR/Gcrjk5FRw5HLavvl0XYbHvKNmdI+fldC
         RoDwFECwgVmtomxwtwvMbtiE60JXf5iZWFUab+V1lN/NzClVaaAqAyYcoJFFimZAuCFg
         LtOiLZZNlhnaJ+YFBIqnPL5pSR240ws/FVFLGQYyaTykwHiccKk3F9bsy476UvH8QE/A
         HvmWhp7qW/rj0a100D+7Ojk9LLqIxXJ3smxDu2j3ao5i7m9U+z34EkBhw3HANYTz+v6p
         hVsBbFy9VRT9Ba8uxXM7/BUxt2wPC1otyxgxLVwHNq0mWIhF4lD913U6uktq1JLvVVf2
         5cZQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689605977; x=1692197977;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=VXsqIY5baDadd/cbgt/XjCUDb85wvHlb5bHAuEVZNcg=;
        b=gSlLoklNLh9vOMzsgzqYNJIYwme+RL/oeEuTc3FzR+rWO7FBmZR7q8BlGaAMWgQ+p4
         zvemm4+qCe1enp3E+1qNeFtu6TuY8I9a+QWNmi6DYR9UvluCwd6yi8kp5CtDw8DB/lQj
         d6gQq5JBEeuDV0Nv/II+dprDjIj3D9nuzukmwt6dTqI4X+xIIocHm+XbA/Hq9OXuMmdQ
         xwXfktsU+otjLUW8MAlaE8XkFvduCXDep+OwiiYlkhudFJdEhrMb0HTg4oi/47DWYUEI
         V5pfrDWq2NBArGHGHPIRcFau5RU/0CRLdHHDmR3yVIZhqWqdEqhMHA2Ub9IEZvLeKiex
         lMAA==
X-Gm-Message-State: ABy/qLZHlXCD1KT+aAVPxUR8k+35/Z2xb5o1vCiLXevVQ3pYd0UfhLCK
        ds987vpkIz8l71kuNUigmAjhTw==
X-Google-Smtp-Source: APBJJlHabjhjvrnzc1Rq8UQ7ovNKqlVBHIdX/4VvmMGJmdDCNZ3XMD4aBEBgRAD/Q6uac4UGgi4NbA==
X-Received: by 2002:a0c:8c4c:0:b0:63c:b1a6:2a39 with SMTP id o12-20020a0c8c4c000000b0063cb1a62a39mr24600qvb.63.1689605976933;
        Mon, 17 Jul 2023 07:59:36 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id k23-20020a0cb257000000b00630228acc45sm6393627qve.145.2023.07.17.07.59.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 07:59:36 -0700 (PDT)
Date:   Mon, 17 Jul 2023 10:59:35 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 09/14] fscrypt: move function call warning of busy
 inodes
Message-ID: <20230717145935.GD691303@perftesting>
References: <cover.1688927487.git.sweettea-kernel@dorminy.me>
 <cde56d55c6546a7861165acb8299e413d815e794.1688927487.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cde56d55c6546a7861165acb8299e413d815e794.1688927487.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jul 09, 2023 at 02:53:42PM -0400, Sweet Tea Dorminy wrote:
> Extent encryption will want to attempt to evict inodes, and not warn of
> busy ones, before removing the key instead of after as it is at present.
> Therefore pull the call for check_for_busy_inodes() out of
> try_to_lock_encrypted_files() into its only callsite.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/keyring.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
> index bfcd2ecbe481..c4499248b6cc 100644
> --- a/fs/crypto/keyring.c
> +++ b/fs/crypto/keyring.c
> @@ -947,8 +947,7 @@ static int check_for_busy_inodes(struct super_block *sb,
>  static int try_to_lock_encrypted_files(struct super_block *sb,
>  				       struct fscrypt_master_key *mk)
>  {
> -	int err1;
> -	int err2;
> +	int err;
>  
>  	/*
>  	 * An inode can't be evicted while it is dirty or has dirty pages.
> @@ -960,7 +959,7 @@ static int try_to_lock_encrypted_files(struct super_block *sb,
>  	 * already call sync_filesystem() via sys_syncfs() or sys_sync().
>  	 */
>  	down_read(&sb->s_umount);
> -	err1 = sync_filesystem(sb);
> +	err = sync_filesystem(sb);
>  	up_read(&sb->s_umount);
>  	/* If a sync error occurs, still try to evict as much as possible. */
>  
> @@ -972,16 +971,7 @@ static int try_to_lock_encrypted_files(struct super_block *sb,
>  	 */
>  	evict_dentries_for_decrypted_inodes(mk);
>  
> -	/*
> -	 * evict_dentries_for_decrypted_inodes() already iput() each inode in
> -	 * the list; any inodes for which that dropped the last reference will
> -	 * have been evicted due to fscrypt_drop_inode() detecting the key
> -	 * removal and telling the VFS to evict the inode.  So to finish, we
> -	 * just need to check whether any inodes couldn't be evicted.
> -	 */
> -	err2 = check_for_busy_inodes(sb, mk);
> -
> -	return err1 ?: err2;
> +	return err;
>  }
>  
>  /*
> @@ -1073,14 +1063,24 @@ static int do_remove_key(struct file *filp, void __user *_uarg, bool all_users)
>  	up_write(&mk->mk_sem);
>  
>  	if (inodes_remain) {
> +		int err2;
>  		/* Some inodes still reference this key; try to evict them. */
>  		err = try_to_lock_encrypted_files(sb, mk);
> +		/* We already tried to iput() each inode referencing this key
> +		 * which would cause the inode to be evicted if that was the
> +		 * last reference (since fscrypt_drop_inode() would see the
> +		 * key removal). So the only remaining inodes referencing this
> +		 * key are still busy and couldn't be evicted; check for them.
> +		 */
> +		err2 = check_for_busy_inodes(sb, mk);
> +		err = err ?: err2;
>  		if (err == -EBUSY) {
>  			status_flags |=
>  				FSCRYPT_KEY_REMOVAL_STATUS_FLAG_FILES_BUSY;
>  			err = 0;
>  		}
>  	}
> +

Extra whitespace.  Thanks,

Josef
