Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA0F9580840
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Jul 2022 01:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230141AbiGYXcp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 25 Jul 2022 19:32:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236962AbiGYXck (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 25 Jul 2022 19:32:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BA1E26AED;
        Mon, 25 Jul 2022 16:32:39 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 21F4DB81132;
        Mon, 25 Jul 2022 23:32:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B008C341C6;
        Mon, 25 Jul 2022 23:32:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658791956;
        bh=1tejZmWDuNXl6aR2gHoHOd9iCro8YmNKxvebSOMVZdo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=R212uXmZJl2rILmNuC9ZMVrmEckKHe6EFoEoRf0Jljo8l5zzBbu0wxXScJVWkaR0z
         ATZ52M0qt6X3KPrpNmr5Wq+xCTP6nAnLsx91g6amkeiZhyQnmvQnx5rgFsSN1vRiAl
         cUoBD8QLoB/+w+UM67T0FvD06PxVFzpSYrg3zMwFF2/MIqgx/BpznJQZIRSoqRxR5w
         l/k0lSbH5Gcwk6giufHM668fcQWRX6UIENsktKAm2GDOib9NVcZvcTuebWLCKFsAiz
         SfOZIKu9iTemDh6+i2jYQ4T/Gw05nVIKRW6t/9znmD2G6NV9V99Ihr7+nhZSsXeh5h
         h+Ck129aMwE5A==
Date:   Mon, 25 Jul 2022 16:32:34 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y . Ts'o " <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, osandov@osandov.com,
        kernel-team@fb.com
Subject: Re: [PATCH RFC 4/4] fscrypt: Add new encryption policy for btrfs.
Message-ID: <Yt8oEiN6AkglKfIc@sol.localdomain>
References: <cover.1658623235.git.sweettea-kernel@dorminy.me>
 <675dd03f1a4498b09925fbf93cc38b8430cb7a59.1658623235.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <675dd03f1a4498b09925fbf93cc38b8430cb7a59.1658623235.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Jul 23, 2022 at 08:52:28PM -0400, Sweet Tea Dorminy wrote:
> Certain filesystems may want to use IVs generated and stored outside of
> fscrypt's inode-based IV generation policies.  In particular, btrfs can
> have multiple inodes referencing a single block of data, and moves
> logical data blocks to different physical locations on disk; these two
> features mean inode or physical-location-based IV generation policies
> will not work for btrfs. For these or similar reasons, such filesystems
> may want to implement their own IV generation and storage for data
> blocks.
> 
> Plumbing each such filesystem's internals into fscrypt for IV generation
> would be ungainly and fragile. Thus, this change adds a new policy,
> IV_FROM_FS, and a new operation function pointer, get_fs_derived_iv.  If
> this policy is selected, the filesystem is required to provide the
> function pointer, which populates the IV for a particular data block.
> The IV buffer passed to get_fs_derived_iv() is pre-populated with the
> inode contexts' nonce, in case the filesystem would like to use this
> information; for btrfs, this is used for filename encryption.  Any
> filesystem using this policy is expected to appropriately generate and
> store a persistent random IV for each block of data.

This is changed from the original proposal to store just a random "starting IV"
per extent, right?  Given that this new proposal uses per-block metadata, has
support for authenticated encryption been considered?  Has space been reserved
in the per-block metadata for authentication tags so that authenticated
encryption support could be added later even if it's not in the initial version?

Also, could the new IV generation method just be defined as RANDOM_IV instead of
IV_FROM_FS?  Why do individual filesystems have to generate the IVs?  Shouldn't
IV generation happen in common code, with filesystems just storing and
retrieving the IVs?

> diff --git a/fs/crypto/inline_crypt.c b/fs/crypto/inline_crypt.c
> index 90f3e68f166e..8a8330caadfa 100644
> --- a/fs/crypto/inline_crypt.c
> +++ b/fs/crypto/inline_crypt.c
> @@ -476,14 +476,22 @@ u64 fscrypt_limit_io_blocks(const struct inode *inode, u64 lblk, u64 nr_blocks)
>  		return nr_blocks;
>  
>  	ci = inode->i_crypt_info;
> -	if (!(fscrypt_policy_flags(&ci->ci_policy) &
> -	      FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32))
> -		return nr_blocks;
>  
> -	/* With IV_INO_LBLK_32, the DUN can wrap around from U32_MAX to 0. */
> +	if (fscrypt_policy_flags(&ci->ci_policy) &
> +	    FSCRYPT_POLICY_FLAG_IV_FROM_FS) {
> +		return 1;
> +	}

This effectively means that this IV generation method is incompatible with
inline encryption.  I assume this is okay with you?

- Eric
