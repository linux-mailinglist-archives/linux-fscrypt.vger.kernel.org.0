Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94FC87770D1
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Aug 2023 08:57:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231371AbjHJG5n (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Aug 2023 02:57:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230212AbjHJG5m (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Aug 2023 02:57:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56969E7E;
        Wed,  9 Aug 2023 23:57:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC23964BB3;
        Thu, 10 Aug 2023 06:57:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED4F1C433C8;
        Thu, 10 Aug 2023 06:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691650660;
        bh=SCGhAcb5cyj4A8gUAY16fIefe5OOenWcnMsh0ypDB/c=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gpo9B2a3vC4UIIibiDNOR/CvLau3uwzOvyDyB9zuskUDEEWiZz24huYL9hhilnC8e
         4p6WpHhOx0lFFDarzEmaz4cMgPbHgiZJ+V2kkfSkB5T+mvV+Vko1sjKNnEa6R59G0s
         8e0bSaEAAvj0PFVNbuJDvKP8AWVnlpdwkRRtY232xaaCHIlGsXnIvqrFE/q2+t9Sxt
         UiPviYGBKIWAmpTeWR3AnVHcMlcnKVLV0IBh964DXtqfdlg95Bv0X5xR1oPbZ9RXub
         gf2SIrA19J7h0U9+XNfEagqWnwSzl3wZVBNWscqYfOtcMFQXrkgWd02rFlOqxPXj2K
         r2i/Dbmlegwvw==
Date:   Wed, 9 Aug 2023 23:57:38 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v6 5/8] fscrypt: reduce special-casing of IV_INO_LBLK_32
Message-ID: <20230810065738.GG923@sol.localdomain>
References: <cover.1691505830.git.sweettea-kernel@dorminy.me>
 <542ea134771e2caa3043dfe48c2825d93495c626.1691505830.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <542ea134771e2caa3043dfe48c2825d93495c626.1691505830.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 08, 2023 at 01:08:05PM -0400, Sweet Tea Dorminy wrote:
> Right now, the IV_INO_LBLK_32 policy is handled by its own function
> called in fscrypt_setup_v2_file_key(), different from all other policies
> which just call find_mode_prepared_key() with various parameters. The
> function additionally sets up the relevant inode hashing key in the
> master key, and uses it to hash the inode number if possible. This is
> not particularly relevant to setting up a prepared key, so this change
> tries to make it clear that every non-default policy uses basically the
> same setup mechanism for its prepared key. The other setup is moved to
> be called from the top crypt_info setup function.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

It seems the goal of this patch is to finish the refactoring started by patches
2 and 4 of making fscrypt_setup_file_key() only set up the I/O key ("prepared
key").  The title and description don't make it very clear, though.  I think a
better title would be the following which is analogous to patch 4:

    fscrypt: move ino hashing setup away from IO key setup

BTW, it seems patch 3 should not be where it is in the series, since 2, 4, and 5
seem to be on one topic.

> +static int fscrypt_setup_ino_hash_key(struct fscrypt_master_key *mk)
>  {
>  	int err;

err needs to be initialized to 0.

> +	/*
> +	 * The IV_INO_LBLK_32 policy needs a hashed inode number, but new
> +	 * inodes may not have an inode number assigned yet.
> +	 */
> +	if (policy->version == FSCRYPT_POLICY_V2 &&
> +	    (policy->v2.flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32)) {
> +		res = fscrypt_setup_ino_hash_key(mk);
> +		if (res)
> +			goto out;
> +
> +		if (inode->i_ino)
> +			fscrypt_hash_inode_number(crypt_info, mk);
> +	}

This seems to be another case where a comment was copied but it doesn't make as
much sense in the new context.  How about the following:

	/* 
	 * If the file is using an IV_INO_LBLK_32 policy, derive the inode hash
	 * key if it wasn't done already.  Then hash the inode number and cache
         * the resulting hash.  New inodes might not have an inode number
         * assigned yet; hashing their inode number is delayed until later.
	 */

- Eric
