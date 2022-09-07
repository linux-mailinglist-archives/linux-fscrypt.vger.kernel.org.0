Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 238655B0F21
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Sep 2022 23:29:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230144AbiIGV3i (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Sep 2022 17:29:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229660AbiIGV3g (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Sep 2022 17:29:36 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [IPv6:2001:67c:2178:6::1d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF4FF101D5;
        Wed,  7 Sep 2022 14:29:33 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 0479120830;
        Wed,  7 Sep 2022 21:29:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1662586172;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iXgSScS7XVYz9iW2idA+n0ZJV33niVLLEmFqLGY6MFU=;
        b=XNpNfwVFSqoBC8aSEjFXKIR50mN83l7kq/aTtivhBcEK02Fk0WSzZxp+wIV3t3ngx1JpbL
        ShhDXB7/CdKP3i+4ZPxccHd0N6AJiGDGS6PSYMqxLTiKATLaEYupRPvA62bL5UT8dKkUaJ
        7Ndz+yuhischu4RjE+gf8G950w8k3Eg=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1662586172;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=iXgSScS7XVYz9iW2idA+n0ZJV33niVLLEmFqLGY6MFU=;
        b=tszUjC6bGb6EYc9KT9Q2S8mGptUIGmste6RmSwc0wdVWFtRPi5ACzDfNikaWicBRSoE9Oq
        dFSrIKJTsLZAcyBQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id A3E9913A66;
        Wed,  7 Sep 2022 21:29:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id vXwJJzsNGWOyUgAAMHmgww
        (envelope-from <dsterba@suse.cz>); Wed, 07 Sep 2022 21:29:31 +0000
Date:   Wed, 7 Sep 2022 23:24:08 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 17/20] btrfs: reuse encrypted filename hash when
 possible.
Message-ID: <20220907212408.GN32411@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <d0957b6aa0847fed100765d9268e4919265fabe9.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d0957b6aa0847fed100765d9268e4919265fabe9.1662420176.git.sweettea-kernel@dorminy.me>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 05, 2022 at 08:35:32PM -0400, Sweet Tea Dorminy wrote:
> From: Omar Sandoval <osandov@osandov.com>
> 
> For encrypted fscrypt_names, we can reuse fscrypt's precomputed hash of
> the encrypted name to generate our own hash, instead of rehashing the
> unencrypted name (which may not be possible if it's a nokey name).

Can you please describe how this works when the key is not available?

> Signed-off-by: Omar Sandoval <osandov@osandov.com>
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/btrfs/ctree.h | 21 ++++++++++++++++++---
>  1 file changed, 18 insertions(+), 3 deletions(-)
> 
> diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
> index e8d000fcc85d..aa599518c057 100644
> --- a/fs/btrfs/ctree.h
> +++ b/fs/btrfs/ctree.h
> @@ -2842,7 +2842,10 @@ static inline void btrfs_crc32c_final(u32 crc, u8 *result)
>  
>  static inline u64 btrfs_name_hash(const struct fscrypt_name *name)
>  {
> -	return crc32c((u32)~1, fname_name(name), fname_len(name));
> +	if (fname_name(name))
> +		return crc32c((u32)~1, fname_name(name), fname_len(name));
> +	else
> +		return name->hash | ((u64)name->minor_hash << 32);

So this is another on-disk format change.

>  }
>  
>  /*
> @@ -2851,8 +2854,20 @@ static inline u64 btrfs_name_hash(const struct fscrypt_name *name)
>  static inline u64 btrfs_extref_hash(u64 parent_objectid,
>  				    const struct fscrypt_name *name)
>  {
> -	return (u64) crc32c(parent_objectid, fname_name(name),
> -			    fname_len(name));
> +	/*
> +	 * If the name is encrypted and we don't have the key, we can use the
> +	 * fscrypt-provided hash instead of the normal name, and do the steps
> +	 * of crc32c() manually. Else, just hash the name, parent objectid,
> +	 * and name length.
> +	 */
> +	if (fname_name(name))
> +		return (u64) crc32c(parent_objectid, fname_name(name),
> +				    fname_len(name));
> +	else
> +		return (__crc32c_le_combine(parent_objectid,
> +					    name->hash,
> +					    fname_len(name)) ^
> +			__crc32c_le_shift(~1, fname_len(name)));

How stable is the __crc32c_le_* API?

>  }
>  
>  static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
> -- 
> 2.35.1
