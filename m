Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19BDD77663E
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Aug 2023 19:19:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232762AbjHIRTH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 9 Aug 2023 13:19:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232454AbjHIRTG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 9 Aug 2023 13:19:06 -0400
Received: from mail-qv1-xf2b.google.com (mail-qv1-xf2b.google.com [IPv6:2607:f8b0:4864:20::f2b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0D73DA
        for <linux-fscrypt@vger.kernel.org>; Wed,  9 Aug 2023 10:19:05 -0700 (PDT)
Received: by mail-qv1-xf2b.google.com with SMTP id 6a1803df08f44-63d2b7d77bfso260716d6.3
        for <linux-fscrypt@vger.kernel.org>; Wed, 09 Aug 2023 10:19:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1691601545; x=1692206345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9b9SMoRtXupRCNfvXSYhKQd36Pc89PcRPCZmseAcJDo=;
        b=VoXp7TFoh+4wAT7ea8VQP58r1AbWSGY0rK8pqgXq2iwJbA/GJJ7Az3J5JvUbzv9gHI
         E+esBvGywJRHNHxlQG5iUM54gYfvscEBLaNEwaJup1uQgWEnUyYm8Iu+dIlIa3C4SwN3
         mcOAt+CTjkP/USHFtAuebfP8w1HjromNckh09anYMPo2CWmZqKxmIawUyRTmEL4pLe4c
         atFN6SICKeZWHbpm/z9oG+6+dUCqMpjlpq4Urq3bOHGDI65yvtxEnqc+zcv4+pVV3zTS
         /Q3tFJhKFct19S1q05VUQKCXloJZNJeWD8kzjUjKcAn48QtO3p+IDAKHkgIoOvZnO9Ja
         YH8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691601545; x=1692206345;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9b9SMoRtXupRCNfvXSYhKQd36Pc89PcRPCZmseAcJDo=;
        b=JhQY45H4EvfGi8VHpgkdRgXjtKRA0VJA+s4Tgw3DDPpsC2RTUPtRgCySgnJK7siGKZ
         /8KbVPuHpFN5THeMfpk9US4oZuSFGOb+U3EmXg/3W8PismSr1DLcK/YES9md9f3yuYwn
         bh1khr1ViKKdxSz4r5BZPXzAkCOTzB7e9dV28bKUWxZsK64xulPvSUqjBSUjhoKe7Rfc
         xJrB5L64+kuBM5a+0GfYsQDLseaHDShvUNq6p/nGllYgOZjByTS0+pS7tCYxD+kOtULA
         RDDrSnKfTSfJA/2rRn1u7YaN96o99w/bw7QjVYsV/e11/uzSNeSi3aFADbf3f9/DMKs/
         N4vA==
X-Gm-Message-State: AOJu0YwbuqHtrMxRVjg1z9Fjn+3Wglc4E0lgRLMgOnEbqmn1qcl9E/Bl
        yaj/yzdRHbVrJBzeVljFuXf9Mw==
X-Google-Smtp-Source: AGHT+IHlHYHA9e/OyOP0CRML60MFpsCscix/jEiEo1jkjD+l2NqOMIG9LqFZNeOJDXSUvydHrT/Iyw==
X-Received: by 2002:a0c:c707:0:b0:636:e56c:eedb with SMTP id w7-20020a0cc707000000b00636e56ceedbmr3189240qvi.34.1691601544776;
        Wed, 09 Aug 2023 10:19:04 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id g12-20020a0cdf0c000000b0062de51d8a12sm4546259qvl.26.2023.08.09.10.19.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 10:19:04 -0700 (PDT)
Date:   Wed, 9 Aug 2023 13:19:03 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v6 2/8] fscrypt: split and rename
 setup_file_encryption_key()
Message-ID: <20230809171903.GA2516732@perftesting>
References: <cover.1691505830.git.sweettea-kernel@dorminy.me>
 <5d9a09398c5432545db73d8f91d6b63cbfd0ee6f.1691505830.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d9a09398c5432545db73d8f91d6b63cbfd0ee6f.1691505830.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 08, 2023 at 01:08:02PM -0400, Sweet Tea Dorminy wrote:
> At present, setup_file_encryption_key() does several things: it finds
> and locks the master key, and then calls into the appropriate functions
> to setup the prepared key for the fscrypt_info. The code is clearer to
> follow if these functions are divided.
> 
> Thus, move calling the appropriate file key setup function into a new
> fscrypt_setup_file_key() function. After the file key setup functions
> are moved, the remaining function can take a const fscrypt_info, and is
> renamed find_and_lock_master_key() to precisely describe its action.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/keysetup.c | 77 ++++++++++++++++++++++++++++++--------------
>  1 file changed, 52 insertions(+), 25 deletions(-)
> 
> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
> index b89c32ad19fb..727d473b6b03 100644
> --- a/fs/crypto/keysetup.c
> +++ b/fs/crypto/keysetup.c
> @@ -386,6 +386,43 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
>  	return 0;
>  }
>  
> +/*
> + * Find or create the appropriate prepared key for an info.
> + */
> +static int fscrypt_setup_file_key(struct fscrypt_info *ci,
> +				  struct fscrypt_master_key *mk,
> +				  bool need_dirhash_key)
> +{
> +	int err;
> +
> +	if (!mk) {
> +		if (ci->ci_policy.version != FSCRYPT_POLICY_V1)
> +			return -ENOKEY;
> +
> +		/*
> +		 * As a legacy fallback for v1 policies, search for the key in
> +		 * the current task's subscribed keyrings too.  Don't move this
> +		 * to before the search of ->s_master_keys, since users
> +		 * shouldn't be able to override filesystem-level keys.
> +		 */
> +		return fscrypt_setup_v1_file_key_via_subscribed_keyrings(ci);
> +	}
> +
> +	switch (ci->ci_policy.version) {
> +	case FSCRYPT_POLICY_V1:
> +		err = fscrypt_setup_v1_file_key(ci, mk->mk_secret.raw);
> +		break;
> +	case FSCRYPT_POLICY_V2:
> +		err = fscrypt_setup_v2_file_key(ci, mk, need_dirhash_key);
> +		break;
> +	default:
> +		WARN_ON_ONCE(1);
> +		err = -EINVAL;
> +		break;
> +	}
> +	return err;
> +}
> +
>  /*
>   * Check whether the size of the given master key (@mk) is appropriate for the
>   * encryption settings which a particular file will use (@ci).
> @@ -426,7 +463,7 @@ static bool fscrypt_valid_master_key_size(const struct fscrypt_master_key *mk,
>  }
>  
>  /*
> - * Find the master key, then set up the inode's actual encryption key.
> + * Find and lock the master key.
>   *
>   * If the master key is found in the filesystem-level keyring, then it is
>   * returned in *mk_ret with its semaphore read-locked.  This is needed to ensure
> @@ -434,9 +471,8 @@ static bool fscrypt_valid_master_key_size(const struct fscrypt_master_key *mk,
>   * multiple tasks may race to create an fscrypt_info for the same inode), and to
>   * synchronize the master key being removed with a new inode starting to use it.
>   */
> -static int setup_file_encryption_key(struct fscrypt_info *ci,
> -				     bool need_dirhash_key,
> -				     struct fscrypt_master_key **mk_ret)
> +static int find_and_lock_master_key(const struct fscrypt_info *ci,
> +				    struct fscrypt_master_key **mk_ret)
>  {
>  	struct super_block *sb = ci->ci_inode->i_sb;
>  	struct fscrypt_key_specifier mk_spec;
> @@ -466,17 +502,19 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
>  			mk = fscrypt_find_master_key(sb, &mk_spec);
>  		}
>  	}
> +

Random newline, you can add

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

once you fix it up.  Thanks,

Josef
