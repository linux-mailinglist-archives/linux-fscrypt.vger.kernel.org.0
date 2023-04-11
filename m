Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7E836DD02E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Apr 2023 05:29:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229849AbjDKD3k (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 23:29:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229800AbjDKD3j (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 23:29:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69554172B
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 20:29:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 04DA7620D1
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 03:29:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FBE1C4339B;
        Tue, 11 Apr 2023 03:29:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681183777;
        bh=9wLR8N0YB7SHs8hISHrIIwB+fxbde0laI6coSPeVPUU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qY9wkQ+O/7JyWABepXYgbNUoz4nJtKjrI5HvE2nZz/g6nSXSirQRrceb6EBYIKRSo
         2fpWdD4jvne2ewg/2gKxLFOiHG+K2kWJwwZLoreirOWTVusE5RItBJ212s6twKWkoe
         UN7l6EBGt3ssr5mTec7gIDV7QguL9RLL/zL8xCpBdpvl5h43ZwckSs23Jnt4Le8hoV
         qnpx+EzwaRdlfzYg/mO9BkV6rrhGKiUh7IiGpaOVIKspjcWdcmOFzKAAICFiv81P5X
         U3QvaND8K/6mX7A6CdoHOliBjVeWmqX6lyNCtS3+6aNAZ8istmxDoIE28ABeyRD2Aj
         nqXmwfrnZpImg==
Date:   Mon, 10 Apr 2023 20:29:35 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 03/11] fscrypt: split and rename
 setup_per_mode_enc_key()
Message-ID: <20230411032935.GC47625@sol.localdomain>
References: <cover.1681155143.git.sweettea-kernel@dorminy.me>
 <4f2bbef32f245f3c6b7e75f68c90faa1c3c096f1.1681155143.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4f2bbef32f245f3c6b7e75f68c90faa1c3c096f1.1681155143.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Apr 10, 2023 at 03:39:56PM -0400, Sweet Tea Dorminy wrote:
> @@ -231,14 +221,39 @@ static int setup_per_mode_enc_key(struct fscrypt_info *ci,
>  	memzero_explicit(mode_key, mode->keysize);
>  	if (err)
>  		goto out_unlock;
> -done_unlock:
> -	ci->ci_enc_key = *prep_key;
> -	err = 0;
> +
>  out_unlock:

The 'if (err)' block above is no longer needed.

> +static int find_mode_prepared_key(struct fscrypt_info *ci,
> +				  struct fscrypt_master_key *mk,
> +				  struct fscrypt_prepared_key *keys,
> +				  u8 hkdf_context, bool include_fs_uuid)
> +{
> +	struct fscrypt_mode *mode = ci->ci_mode;
> +	const u8 mode_num = mode - fscrypt_modes;
> +	struct fscrypt_prepared_key *prep_key;
> +	int err;
> +
> +	if (WARN_ON_ONCE(mode_num > FSCRYPT_MODE_MAX))
> +		return -EINVAL;
> +
> +	prep_key = &keys[mode_num];
> +	if (fscrypt_is_key_prepared(prep_key, ci)) {
> +		ci->ci_enc_key = *prep_key;
> +		return 0;
> +	}
> +	err = setup_new_mode_prepared_key(mk, prep_key, ci, hkdf_context,
> +					  include_fs_uuid);
> +	if (err)
> +		return err;
> +
> +	ci->ci_enc_key = *prep_key;
> +	return 0;
> +}

It actually should be find_or_create_mode_prepared_key(), right?  It's confusing
to have a function that just says "find" actually create the thing it is looking
for.

But, with how long these function names would get, maybe we should just stick
with setup_mode_prepared_key()?  Note that it has the same semantics (find or
create) as fscrypt_setup_ino_hash_key(), which this patchset doesn't change.

- Eric
