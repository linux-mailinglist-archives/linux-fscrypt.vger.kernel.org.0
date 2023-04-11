Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9742F6DD050
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Apr 2023 05:38:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbjDKDi4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 23:38:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229764AbjDKDiz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 23:38:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9C811BC9
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 20:38:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8356B613E2
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 03:38:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9134C433D2;
        Tue, 11 Apr 2023 03:38:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681184333;
        bh=yD10ynxXzvhcVctuvVLO9e2ekjB3fDDVw9MKpLpB0rM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KUjrm0EVZcvZ1i99jgNFhY6UzCumJXgfCZ5GVA+eYRPhnYudkcGlapRYN13xD8jSQ
         XwwnmUbyjyqR435MEOwvK3ekehMd+rJeG39+OYPi7PeU1tZC6uuH6HFLjL39+kTYL9
         s1A+Bc3YL/OOE7J3DmxNstirx1zzbK7jLY6WcjSmoOvHGF7it0xkjwhWG9yleK7UK8
         LZ/pR/jiDyF0OPaFgfLULZLjUERINz4GAs+KbwCWGGD6cwVxMVwzFtAC1YE5vFkFDm
         PEPlqZ6i+dEQkRW2ulMQw9g14DPm/+hlVXSatOSD9KXIRknC8tAnEpltXSLe/NOz6o
         LsYApRjGLgRGA==
Date:   Mon, 10 Apr 2023 20:38:52 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 05/11] fscrypt: reduce special-casing of IV_INO_LBLK_32
Message-ID: <20230411033852.GE47625@sol.localdomain>
References: <cover.1681155143.git.sweettea-kernel@dorminy.me>
 <b041415c3dd69c2c93e3f4cabecafdbacbfe10ac.1681155143.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b041415c3dd69c2c93e3f4cabecafdbacbfe10ac.1681155143.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Apr 10, 2023 at 03:39:58PM -0400, Sweet Tea Dorminy wrote:
> +static int fscrypt_setup_ino_hash_key(struct fscrypt_master_key *mk)
>  {
>  	int err;
>  
> -	err = find_mode_prepared_key(ci, mk, mk->mk_iv_ino_lblk_32_keys,
> -				     HKDF_CONTEXT_IV_INO_LBLK_32_KEY, true);
> -	if (err)
> -		return err;
> -
>  	/* pairs with smp_store_release() below */
>  	if (!smp_load_acquire(&mk->mk_ino_hash_key_initialized)) {
>  
> @@ -335,12 +329,6 @@ static int fscrypt_setup_iv_ino_lblk_32_key(struct fscrypt_info *ci,
>  			return err;
>  	}
>  
> -	/*
> -	 * New inodes may not have an inode number assigned yet.
> -	 * Hashing their inode number is delayed until later.
> -	 */
> -	if (ci->ci_inode->i_ino)
> -		fscrypt_hash_inode_number(ci, mk);
>  	return 0;
>  }

Now that this function just does one thing, maybe change it to use an early
return and remove a level of indentation?

        if (smp_load_acquire(&mk->mk_ino_hash_key_initialized))
                return 0;

- Eric
