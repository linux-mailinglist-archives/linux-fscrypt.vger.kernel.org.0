Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 137ED6DD027
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Apr 2023 05:24:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbjDKDYe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 23:24:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229722AbjDKDYc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 23:24:32 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66D3B1BC1
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 20:24:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id ED4D561ACA
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 03:24:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E8AC433EF;
        Tue, 11 Apr 2023 03:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681183470;
        bh=RJmNRGBrs1Af0IGCAiXWDmPWm/AThvRIGUSZDKG7qx4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rWEGVz4uLEAkQ9NfLA5XkPqEbhDOX9iXg17Z9dSPgHbejx+ymXcQtyDCiGoKFXdpk
         W4WHThCgjoONnPwDzZqoCDWs+Jlhb9U6PMOz5lQF365QNCBVyuCN0+Gy8mLsNUjdAp
         tiMn2oGIerXe1mShVpQgMYtBYmxdY9s1S9wEctpM+PtcJYzOdqNeLaIcVL1bxtQG9w
         FfwKnJ2rZNLNQFIWTuahzq10072g4RcnVkGFW9vlI+dfb44ASpemIKn31aqWH0WsAf
         pWDALLeyfRXCZwA5xBusHqjDnEfP3O/m1jVF0XYh5iuvzgplnLgBm0Fuq2euySNLJn
         7fKtt5a2hoQ2w==
Date:   Mon, 10 Apr 2023 20:24:28 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 02/11] fscrypt: split and rename
 setup_file_encryption_key()
Message-ID: <20230411032428.GB47625@sol.localdomain>
References: <cover.1681155143.git.sweettea-kernel@dorminy.me>
 <81adddca05362d0f4401dbc114f6ac7ad1f56645.1681155143.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <81adddca05362d0f4401dbc114f6ac7ad1f56645.1681155143.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Apr 10, 2023 at 03:39:55PM -0400, Sweet Tea Dorminy wrote:
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
> @@ -466,17 +502,13 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
>  			mk = fscrypt_find_master_key(sb, &mk_spec);
>  		}
>  	}
> +
>  	if (unlikely(!mk)) {
>  		if (ci->ci_policy.version != FSCRYPT_POLICY_V1)
>  			return -ENOKEY;
>  
> -		/*
> -		 * As a legacy fallback for v1 policies, search for the key in
> -		 * the current task's subscribed keyrings too.  Don't move this
> -		 * to before the search of ->s_master_keys, since users
> -		 * shouldn't be able to override filesystem-level keys.
> -		 */
> -		return fscrypt_setup_v1_file_key_via_subscribed_keyrings(ci);
> +		*mk_ret = NULL;
> +		return 0;

While this change may be a benefit overall, it does split the code that handles
the legacy case of "v1 policy using process-subscribed keyrings" into two
places.  That makes it a little more difficult to understand.  I think a comment
would be helpful here, at least?

- Eric
