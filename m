Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE9D777078
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Aug 2023 08:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229540AbjHJGfC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Aug 2023 02:35:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232463AbjHJGfB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Aug 2023 02:35:01 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCDDD2702;
        Wed,  9 Aug 2023 23:34:46 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 50A9A65034;
        Thu, 10 Aug 2023 06:34:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6AFEAC433C7;
        Thu, 10 Aug 2023 06:34:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691649273;
        bh=aaessh7BSN/IH0dGvb+m2fd29dghT/V+so7ytv3wcLA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jpb60/OTTcipk0Y3o/tcqrwaFAVz8Gym+UnpAc2dQG70XIHJI+yz2h4C7t1XnbLL0
         2bOiGvdxpJOrDvdVDd2hLEZIGo/0SECfc9bCVIYeFhKLLHfzaGNdV3O+iMKlvA5Wya
         2saH07hGu8DR++9iUOdhFB6e8QnX4bZvGBQLIFi0RKaYelkDVXqauIz19KlBhc+j0x
         mpXfkjJC99azZhna3MKomQlgAgJbAG2NAXJQb6Ydk+Z1BRrEf8yLIRzT9Zm/xyMTHZ
         yO/N0jq/hSArA+KVmA6x/oMERmtCRqOiyEW6zLeAqkGwSLlsDYTiSxlXSn+H8Ec/kf
         YyO17jQbv9nxw==
Date:   Wed, 9 Aug 2023 23:34:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v6 2/8] fscrypt: split and rename
 setup_file_encryption_key()
Message-ID: <20230810063431.GE923@sol.localdomain>
References: <cover.1691505830.git.sweettea-kernel@dorminy.me>
 <5d9a09398c5432545db73d8f91d6b63cbfd0ee6f.1691505830.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5d9a09398c5432545db73d8f91d6b63cbfd0ee6f.1691505830.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 08, 2023 at 01:08:02PM -0400, Sweet Tea Dorminy wrote:
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

'err' is not needed.  The switch statement should look like:

	switch (ci->ci_policy.version) {
	case FSCRYPT_POLICY_V1:
		return fscrypt_setup_v1_file_key(ci, mk->mk_secret.raw);
	case FSCRYPT_POLICY_V2:
		return fscrypt_setup_v2_file_key(ci, mk, need_dirhash_key);
	default:
		WARN_ON_ONCE(1);
		return -EINVAL;
	}

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

I think it would be a bit cleaner if this returned
'struct fscrypt_master_key *'.  Use NULL for not found, ERR_PTR() for errors.

>  {
>  	struct super_block *sb = ci->ci_inode->i_sb;
>  	struct fscrypt_key_specifier mk_spec;
> @@ -466,17 +502,19 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
>  			mk = fscrypt_find_master_key(sb, &mk_spec);
>  		}
>  	}
> +
>  	if (unlikely(!mk)) {
>  		if (ci->ci_policy.version != FSCRYPT_POLICY_V1)
>  			return -ENOKEY;
>  
>  		/*
> -		 * As a legacy fallback for v1 policies, search for the key in
> -		 * the current task's subscribed keyrings too.  Don't move this
> -		 * to before the search of ->s_master_keys, since users
> -		 * shouldn't be able to override filesystem-level keys.
> +		 * This might be the case of a v1 policy using a process
> +		 * subscribed keyring to get the key, so there may not be
> +		 * a relevant master key.
>  		 */
> -		return fscrypt_setup_v1_file_key_via_subscribed_keyrings(ci);
> +
> +		*mk_ret = NULL;
> +		return 0;
>  	}

'ci->ci_policy.version != FSCRYPT_POLICY_V1' is duplicated with
fscrypt_setup_file_key().  The problem is really that this patch makes the
handling of "master key not found" happen in two different places.

I think find_and_lock_master_key() should just return NULL for the master key
when it's not found.  Then fscrypt_setup_file_key() decides what to do about it.

Also, the comment for find_and_lock_master_key() needs to be updated.  The last
sentence in particular is not necessary anymore.  I think your refactoring fixes
the reason why that explanation was needed in the first place.  With my
suggestion to return a pointer, I think a good comment would be:

/*
 * Find the master key for ci_policy in the filesystem-level keyring.  Returns
 * the read-locked key if found, NULL if not found, or an ERR_PTR on error.  The
 * caller is responsible for unlocking and putting the key if found.
 */

- Eric
