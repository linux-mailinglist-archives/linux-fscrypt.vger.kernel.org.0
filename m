Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2566100DF
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Oct 2022 20:58:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236284AbiJ0S6I (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 27 Oct 2022 14:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235822AbiJ0S6C (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 27 Oct 2022 14:58:02 -0400
Received: from mail-pf1-x42f.google.com (mail-pf1-x42f.google.com [IPv6:2607:f8b0:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCCA314032
        for <linux-fscrypt@vger.kernel.org>; Thu, 27 Oct 2022 11:58:00 -0700 (PDT)
Received: by mail-pf1-x42f.google.com with SMTP id k22so2556070pfd.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 27 Oct 2022 11:58:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=osandov-com.20210112.gappssmtp.com; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=nCCGidingdoKWEeqRtj/np51Fz1PO0iQgrxybXuPPe4=;
        b=K40mZ7HimthjTwd2X0EHFXZvucVwZdLnEWvUUOJen5fYNAp+CFjdOLyIJ5JTUaxC8/
         MdGxDtts/q+km3YIs/XWTN7DkfZGNy7cSPlt+DL6oYgs/sIyi9AloBNMIVckuO3uMXJr
         ueQUafzCTZ9T8d6ichS/zsrlnVKAUkc0bh+qBlzH5FNtB6gRFe9bCD0GTzcKL0ydi2db
         suQ+rTM1MB0G4hWa9O9QWlt3111WGXlJbTPjwnF9mL+RltehyXa8nldbRAnbTXGhA5Bm
         3QUrFrcE5DU0A2KWSK5Vz/zWIzfwANcPlPZRMrnxU/Tq9nadeDh9foJiC9UAMlFPJ6q5
         O1qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nCCGidingdoKWEeqRtj/np51Fz1PO0iQgrxybXuPPe4=;
        b=7/Wvt/7zwnjPJH9uD1ycbWpZNwThj+istxvPz8JpUfQpYdjGtfDljjWKd+t9BelQHJ
         fSOf+jXbJCzttZM3BFaHO3gtPwgVijiP6Ro5o1kF73PKfrBdMAS5TZ6MlBYb3jSaLlDE
         9C/LGI0UZSF8Z+mgQ+XUSIkRo2cACUt86FrAvBS4aGw5XAEfGADguFgm+NKmWX5/GJFs
         MH2MEQf0BM0IdxJ9SxLHJWKn6CEZJ0LCm47gJaIT83uEtFpGDiO//kA9Fo+cmj9VcqbN
         Os68g93GrMUdmRD+C36W6tQVvX0Kt8249b4lsC52DY4G3JWsCL7IIfUf+zveaeRl5oOs
         0j1Q==
X-Gm-Message-State: ACrzQf0KnDJlVnh7dEQwbpngEG4gZV6ae2Kqc4RIm+dTwgQvqPb8DT7s
        2gFXSt6xolMXljODN2yxceO+hA==
X-Google-Smtp-Source: AMsMyM7niJVi0t36m41TvFr2W1n1ZOE5fV1yqwpWOFFWd52z9O3pTs4wMfu6OEsti8Sfy9Kth5BqwA==
X-Received: by 2002:a63:28c:0:b0:46e:9da9:80f8 with SMTP id 134-20020a63028c000000b0046e9da980f8mr34359467pgc.373.1666897080110;
        Thu, 27 Oct 2022 11:58:00 -0700 (PDT)
Received: from relinquished.localdomain ([2620:10d:c090:500::6:a158])
        by smtp.gmail.com with ESMTPSA id s7-20020a170902988700b001869b988d93sm1495562plp.187.2022.10.27.11.57.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 27 Oct 2022 11:57:59 -0700 (PDT)
Date:   Thu, 27 Oct 2022 11:57:57 -0700
From:   Omar Sandoval <osandov@osandov.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v4 02/21] fscrypt: add fscrypt_have_same_policy() to
 check inode compatibility
Message-ID: <Y1rUtR+6kzZnhA2r@relinquished.localdomain>
References: <cover.1666651724.git.sweettea-kernel@dorminy.me>
 <aa40bc0b110601d20cd49e1db1d2435d07da26b2.1666651724.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <aa40bc0b110601d20cd49e1db1d2435d07da26b2.1666651724.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Oct 24, 2022 at 07:13:12PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> Btrfs will need to check whether inode policies are identical for
> various purposes: if two inodes want to share an extent, they must have
> the same policy, including key identifier; symlinks must not span the
> encrypted/unencrypted border; and certain encryption policies will allow
> btrfs to store one fscrypt_context for multiple objects. Therefore, add
> a function which allows checking the encryption policies of two inodes
> to ensure they are identical.
> 
> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/policy.c      | 26 ++++++++++++++++++++++++++
>  include/linux/fscrypt.h |  7 +++++++
>  2 files changed, 33 insertions(+)
> 
> diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
> index 46757c3052ef..b7c4820a8001 100644
> --- a/fs/crypto/policy.c
> +++ b/fs/crypto/policy.c
> @@ -415,6 +415,32 @@ static int fscrypt_get_policy(struct inode *inode, union fscrypt_policy *policy)
>  	return fscrypt_policy_from_context(policy, &ctx, ret);
>  }
>  
> +/**
> + * fscrypt_have_same_policy() - check whether two inodes have the same policy
> + * @inode1: the first inode
> + * @inode2: the second inode
> + *
> + * Return: %true if they are definitely equal, else %false
> + */
> +int fscrypt_have_same_policy(struct inode *inode1, struct inode *inode2)
> +{
> +	union fscrypt_policy policy1, policy2;
> +	int err;
> +
> +	if (!IS_ENCRYPTED(inode1) && !IS_ENCRYPTED(inode2))
> +		return true;
> +	else if (!IS_ENCRYPTED(inode1) || !IS_ENCRYPTED(inode2))
> +		return false;
> +	err = fscrypt_get_policy(inode1, &policy1);
> +	if (err)
> +		return false;
> +	err = fscrypt_get_policy(inode2, &policy2);
> +	if (err)
> +		return false;

Should we bubble up the errors here instead of squashing them down to
false? (I noticed this because Josef had another comment about returning
int vs bool in this function.)

> +	return fscrypt_policies_equal(&policy1, &policy2);
> +}
> +EXPORT_SYMBOL(fscrypt_have_same_policy);
