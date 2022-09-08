Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 80F745B268A
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Sep 2022 21:11:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230300AbiIHTLb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Sep 2022 15:11:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229986AbiIHTLa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Sep 2022 15:11:30 -0400
Received: from mail-qt1-x835.google.com (mail-qt1-x835.google.com [IPv6:2607:f8b0:4864:20::835])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5B562EC771
        for <linux-fscrypt@vger.kernel.org>; Thu,  8 Sep 2022 12:11:29 -0700 (PDT)
Received: by mail-qt1-x835.google.com with SMTP id r6so13669346qtx.6
        for <linux-fscrypt@vger.kernel.org>; Thu, 08 Sep 2022 12:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date;
        bh=QxnqVlxqtGJodT6yFH282ylz03SCDVQmV4f2aqWswBs=;
        b=iaM966+K2AFLebQEoWflFeq0FVhzIHaMUoxYUYHlqMGG5AjSSTJGD+Tf01p9y1Qtjh
         UcrODHgeJnXnZ5VXaDJJTfIw+rYD5QP87z0hqdewk3+2f/m8vF/y2vZ/Lj1rkVGq9+xl
         f+7M5KpCJpBIIhXQoskioj828MpgBJeLFFl/bBSByv/b18WolFMQ4KFUO3O0q8JRzkmx
         nK27R9JhxZaTckQKV/hYmNxokEyh+j8mnU3XUtlPLjDzICD0mDfc9pYf0AGxwutmoml5
         KyFzS8CMd18BOxUH/GV0neqgN65o4b4d7FwKO9wOSuQJL3pOctvjouZN3JvHpGavrCtc
         aUkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=QxnqVlxqtGJodT6yFH282ylz03SCDVQmV4f2aqWswBs=;
        b=feMnewuco5MSzjK3jIUiJPKDhZustBNYnKeLYpniGEicXeeBVcg4hxxjPbikLSy3WN
         uEUCMRXuXBeGxiwOurR2vz5HjcFrccZLI577cPxKlfmVTY2lAEwC28QsYkr1GOidW6Ig
         Z7HlDEO2o8dHX5NX8+l8rRIxQGERJp19Dr87keyXHzyvIqRZks+IUmdu7FEDlIJ53JMM
         WqTzTpiL1FUBvRnbc8mybPp4gcXsbNmQMdgm/dsemps/Xn7RcMqiOI591noZMSEPfvJm
         OYVhDIateY+Ceu82I1r7opqgnBn8b4TCJS6DxFO6O05MkDLMzdvfTgJVZm7zI7IxatZw
         oXtA==
X-Gm-Message-State: ACgBeo2akTiMmqAIcIChPdeJs+hRTtsYjueXg0TUwYt66k51bnCtKTBj
        DtNPTuyKVZY31EE4RW/4VI5RwA==
X-Google-Smtp-Source: AA6agR4GRV5QPPxgnt4eklLf9Zny+qDIXVz8kePOcaNKujGSRdlikEiuLKCynGR5vgmi6ysjht6FUA==
X-Received: by 2002:a05:622a:1aa2:b0:344:5ffd:3190 with SMTP id s34-20020a05622a1aa200b003445ffd3190mr9618088qtc.80.1662664288195;
        Thu, 08 Sep 2022 12:11:28 -0700 (PDT)
Received: from localhost (cpe-174-109-172-136.nc.res.rr.com. [174.109.172.136])
        by smtp.gmail.com with ESMTPSA id z7-20020ac86b87000000b0034035e73be0sm15055732qts.4.2022.09.08.12.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Sep 2022 12:11:27 -0700 (PDT)
Date:   Thu, 8 Sep 2022 15:11:26 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 09/20] btrfs: setup fscrypt_names from dentrys using
 helper
Message-ID: <Yxo+XuTwIQkVQxWL@localhost.localdomain>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <cebbedeab930ee9ea98d2c88ed41c3c56c9e7e27.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cebbedeab930ee9ea98d2c88ed41c3c56c9e7e27.1662420176.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:24PM -0400, Sweet Tea Dorminy wrote:
> Most places that we create fscrypt_names, we are doing so from a dentry.
> Fscrypt provides a helper for this common pattern:
> fscrypt_setup_filename() initializes a filename to search for from a
> dentry, performing encryption of the plaintext if it can and should be
> done. This converts each setup of a fscrypt_name from a dentry to use
> this helper; at present, since there are no encrypted directories,
> nothing goes down the filename encryption paths.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

<snip>

> diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
> index 40cfaa9feff3..53195cfe6a3d 100644
> --- a/fs/btrfs/tree-log.c
> +++ b/fs/btrfs/tree-log.c
> @@ -7443,13 +7443,13 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,
>  	if (old_dir && old_dir->logged_trans == trans->transid) {
>  		struct btrfs_root *log = old_dir->root->log_root;
>  		struct btrfs_path *path;
> -		struct fscrypt_name fname = {
> -			.disk_name = FSTR_INIT((char *) old_dentry->d_name.name,
> -					       old_dentry->d_name.len)
> -		};
> -
> +		struct fscrypt_name fname;
>  		ASSERT(old_dir_index >= BTRFS_DIR_START_INDEX);
>  
> +		ret = fscrypt_setup_filename(&old_dir->vfs_inode,
> +					     &old_dentry->d_name, 0, &fname);
> +		if (ret)
> +			goto out;
>  		/*
>  		 * We have two inodes to update in the log, the old directory and
>  		 * the inode that got renamed, so we must pin the log to prevent
> @@ -7469,6 +7469,7 @@ void btrfs_log_new_name(struct btrfs_trans_handle *trans,

There's another error case just above this that you missed.  Thanks,

Josef
