Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E9317566DD
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 16:54:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229701AbjGQOyZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 17 Jul 2023 10:54:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229999AbjGQOyX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 17 Jul 2023 10:54:23 -0400
Received: from mail-qk1-x731.google.com (mail-qk1-x731.google.com [IPv6:2607:f8b0:4864:20::731])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20435E76
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 07:54:21 -0700 (PDT)
Received: by mail-qk1-x731.google.com with SMTP id af79cd13be357-7659c6cae2cso297973085a.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 17 Jul 2023 07:54:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1689605660; x=1692197660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=ESU6Ch0fhKaj9eUPDOJ++s+X/EI2awoMvsiqscv3U/8=;
        b=tbbycmLYM/4v/P1TBpSE6mqgDnd3GWTYQ/2VahnLlqfzQ4OS8828xKIEOEMcDu7JcN
         PLK0Aw53kIR53OlS9SrHoyzIjJbGsWcIknazIMoGayg75yHGpwrAJ8PE3+gbB2yoL/Sk
         QeeH5kAm7tAPdcXbCVDHI2uHV2NEe07BaAixVpY4F0cS5cWww4HjkYEL3ylhud6PlGVr
         j8mO0stlTCMyeYfDmyUWTKzyrJ+TIz6JRZivboRmVSHZffOGNTomHNf3NqpSQ1gnuyHy
         +5j/+X+kJbLIq23H7o6hPHvfbwMHS9OpRiR/ZIZQ16ibsqYLo+NnblLKT2M7WNbhNrR4
         xX0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689605660; x=1692197660;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ESU6Ch0fhKaj9eUPDOJ++s+X/EI2awoMvsiqscv3U/8=;
        b=Zp2YMmpMGmjAICkNTYUOmM7hG4JnAAdkVOTotYTVwQumOVtVSOlj6JaM8OV3wYo+8B
         Mv6CFQcrH8dDZVpqBvXKwTs0/RiKRNN/SQPy/fGTY6Fl968hmOArHsACpuM6YvE1N+6Z
         4iQF5+P1n3v93P7ewK9OPhwnGtvxP9OUkCAH1+ERRxjejR73SX/7WZooq1d3qFPElEGO
         ySjXw29buzkhEbGn9kmSqljutXHwkgEvC9s1vMsH84apvBAgHuYgNuCvxeP0SPtkxqFU
         XYwMIvaLBrJbveGCHu1N3akKi98FtENX9190nWjA6trHYjn/RD4Ayq98hRVLK9H34Btg
         y2jg==
X-Gm-Message-State: ABy/qLZof62qGHHKUNCWH1b66r0SlDRbvxQS2l9+aArsceTYwW1Ok8Je
        D0bI2gD9yOoM2k2CVpVem6aOgg==
X-Google-Smtp-Source: APBJJlHGT3M5oJwDZJKlrieIbx7u6CUvCCnfp2XjFtXeOjIIQZ0jt1PmNF2Ch4o3Q+C58M38epK+vQ==
X-Received: by 2002:a05:620a:959:b0:75e:bdee:367e with SMTP id w25-20020a05620a095900b0075ebdee367emr10097319qkw.47.1689605659996;
        Mon, 17 Jul 2023 07:54:19 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id z11-20020ae9c10b000000b007682757a65esm221494qki.45.2023.07.17.07.54.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 Jul 2023 07:54:19 -0700 (PDT)
Date:   Mon, 17 Jul 2023 10:54:18 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 07/14] fscrypt: notify per-extent infos if master key
 vanishes
Message-ID: <20230717145418.GC691303@perftesting>
References: <cover.1688927487.git.sweettea-kernel@dorminy.me>
 <6fa7d32a149f91be04ce1517ec6987318220ccbd.1688927487.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6fa7d32a149f91be04ce1517ec6987318220ccbd.1688927487.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jul 09, 2023 at 02:53:40PM -0400, Sweet Tea Dorminy wrote:
> When fscrypt_infos can be owned by an extent, we need some way to
> attempt to evict the extent infos in the same way we evict inodes.
> This change adds a function pointer to allow a filesystem to optionally
> provide a way to evict extents; locking if needed must be handled by the
> filesystem.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/keyring.c     | 11 ++++++++++-
>  include/linux/fscrypt.h |  9 +++++++++
>  2 files changed, 19 insertions(+), 1 deletion(-)
> 
> diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
> index 7cbb1fd872ac..0aad825087c1 100644
> --- a/fs/crypto/keyring.c
> +++ b/fs/crypto/keyring.c
> @@ -875,6 +875,16 @@ static void evict_dentries_for_decrypted_inodes(struct fscrypt_master_key *mk)
>  
>  	list_for_each_entry(ci, &mk->mk_decrypted_inodes, ci_master_key_link) {
>  		inode = ci->ci_inode;
> +		if (!inode) {
> +			if (!ci->ci_sb->s_cop->forget_extent_info)
> +				continue;
> +
> +			spin_unlock(&mk->mk_decrypted_inodes_lock);
> +			ci->ci_sb->s_cop->forget_extent_info(ci->ci_info_ptr);
> +			spin_lock(&mk->mk_decrypted_inodes_lock);
> +			continue;
> +		}
> +
>  		spin_lock(&inode->i_lock);
>  		if (inode->i_state & (I_FREEING | I_WILL_FREE | I_NEW)) {
>  			spin_unlock(&inode->i_lock);
> @@ -887,7 +897,6 @@ static void evict_dentries_for_decrypted_inodes(struct fscrypt_master_key *mk)
>  		shrink_dcache_inode(inode);
>  		iput(toput_inode);
>  		toput_inode = inode;
> -

Errant whitespace change.  Thanks,

Josef
