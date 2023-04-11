Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35A1E6DD08E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Apr 2023 05:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229711AbjDKD5Q (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 23:57:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229701AbjDKD5O (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 23:57:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CCA3F26BE
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 20:57:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 48A57619F4
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 03:57:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F0C5C433EF;
        Tue, 11 Apr 2023 03:57:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681185432;
        bh=Z0J68mqWXqHJ5n94z30OImLo29S482T43fwuGODKhFQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hcgtvp2FHhu2w2VZe8rr+BHDiaxc8VWZ3P8J+FqdEFsvxT8hzmKbHGsMolT08r4hg
         svw1byZ89+VSkOH0GpAnaSfq3Rk+ZPr7vVadpSlCHmTH+7kw8SVhy9kRLVZytfrJK0
         261CIjHMeqg76GZwgveWjpa/ouc1PqpBw+D7eJCi7ePiBJ0m+4kq4nnaCd0ZtmUPOj
         7oJbonUJWs1d80609cYfgCYFToTpj0YuShGo6fW9wUBe0uNM052fCLxulWWwZxT2zW
         oyGDrjDl4ohBkISAq06BxNeQxXlurkrH33p71cIsgAMQv3ymrjEm5dcT+lPryjG4F4
         H5ZgkxGJjilpQ==
Date:   Mon, 10 Apr 2023 20:57:10 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 08/11] fscrypt: make ci->ci_direct_key a bool not a
 pointer
Message-ID: <20230411035710.GH47625@sol.localdomain>
References: <cover.1681155143.git.sweettea-kernel@dorminy.me>
 <ae5cc986b52b950ee81d613093310a52be3972d9.1681155143.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ae5cc986b52b950ee81d613093310a52be3972d9.1681155143.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Apr 10, 2023 at 03:40:01PM -0400, Sweet Tea Dorminy wrote:
> The ci_direct_key field is only used for v1 direct key policies,
> recording the direct key that needs to have its refcount reduced when
> the crypt_info is freed. However, now that crypt_info->ci_enc_key is a
> pointer to the authoritative prepared key -- embedded in the direct key,
> in this case, we no longer need to keep a full pointer to the direct key
> -- we can use container_of() to go from the prepared key to its
> surrounding direct key. Thus we can make ci_direct_key a bool instead of
> a pointer, saving a few bytes.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/fscrypt_private.h | 7 +++----
>  fs/crypto/keysetup.c        | 2 +-
>  fs/crypto/keysetup_v1.c     | 7 +++++--
>  3 files changed, 9 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
> index 5011737b60b3..b575fb58a506 100644
> --- a/fs/crypto/fscrypt_private.h
> +++ b/fs/crypto/fscrypt_private.h
> @@ -234,10 +234,9 @@ struct fscrypt_info {
>  	struct list_head ci_master_key_link;
>  
>  	/*
> -	 * If non-NULL, then encryption is done using the master key directly
> -	 * and ci_enc_key will equal ci_direct_key->dk_key.
> +	 * If true, then encryption is done using the master key directly.
>  	 */
> -	struct fscrypt_direct_key *ci_direct_key;
> +	bool ci_direct_key;

This just gets deleted by the next patch.  Should they be folded together?

- Eric
