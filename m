Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 77A46606A73
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Oct 2022 23:46:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229596AbiJTVqB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 17:46:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36734 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229498AbiJTVqA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 17:46:00 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88E14186798;
        Thu, 20 Oct 2022 14:45:59 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 493B4B82929;
        Thu, 20 Oct 2022 21:45:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A721AC433D6;
        Thu, 20 Oct 2022 21:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666302357;
        bh=09uvNF5Sr9n3QZOMnVNgfVN86W2apYnMzLbEB/jQio8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I8A4tQQc/QEYVd694XEQa5iOhsI75LLGmTz3ZWWcBB9f0JdZFOtO3Uar+Y2EfYTYA
         MfWdyZngvHxCuFH2DZ8xulxGpqnS5oYZgpJ1ppeXWAQiAB4Y+TGK3MWJbyE6gS19b8
         Noe7ACTFsNQCrZ3b8DU5jr+zVBmh9uSRhsHxBii3EOLfZWvkw5N5kHL3lS739DFHER
         VBhTgoGHURC3/lCJo044on3vnjfTPjhzQnOIDYf0sTCMFjCJMMkudYBFJPyQNRCrJa
         kQHtmdDbsHLLuio6NHLKilIGreKFuNVVDf/drI7JnYRYICCg7fRoDjQda/FA2TlQ+d
         pJvqPemxHyWcQ==
Date:   Thu, 20 Oct 2022 14:45:54 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 04/22] fscrypt: add extent-based encryption
Message-ID: <Y1HBkva6fzSMpm+P@sol.localdomain>
References: <cover.1666281276.git.sweettea-kernel@dorminy.me>
 <d7246959ee0b8d2eeb7d6eb8cf40240374c6035c.1666281277.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7246959ee0b8d2eeb7d6eb8cf40240374c6035c.1666281277.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 20, 2022 at 12:58:23PM -0400, Sweet Tea Dorminy wrote:
> Some filesystems need to encrypt data based on extents, rather than on
> inodes, due to features incompatible with inode-based encryption. For
> instance, btrfs can have multiple inodes referencing a single block of
> data, and moves logical data blocks to different physical locations on
> disk in the background; these two features mean traditional inode-based
> file contents encryption will not work for btrfs.
> 
> This change introduces fscrypt_extent_context objects, in analogy to
> existing context objects based on inodes. For a filesystem which opts to
> use extent-based encryption, a new hook provides a new
> fscrypt_extent_context, generated in close analogy to the IVs generated
> with existing policies. During file content encryption/decryption, the
> existing fscrypt_context object provides key information, while the new
> fscrypt_extent_context provides IV information. For filename encryption,
> the existing IV generation methods are still used, since filenames are
> not stored in extents.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/crypto.c          | 20 ++++++++--
>  fs/crypto/fscrypt_private.h | 25 +++++++++++-
>  fs/crypto/inline_crypt.c    | 28 ++++++++++---
>  fs/crypto/policy.c          | 79 +++++++++++++++++++++++++++++++++++++
>  include/linux/fscrypt.h     | 47 ++++++++++++++++++++++
>  5 files changed, 189 insertions(+), 10 deletions(-)
> 
> diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> index 7fe5979fbea2..08b495dc5c0c 100644
> --- a/fs/crypto/crypto.c
> +++ b/fs/crypto/crypto.c
> @@ -81,8 +81,22 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
>  			 const struct fscrypt_info *ci)
>  {
>  	u8 flags = fscrypt_policy_flags(&ci->ci_policy);
> +	struct inode *inode = ci->ci_inode;
> +	const struct fscrypt_operations *s_cop = inode->i_sb->s_cop;
>  
> -	memset(iv, 0, ci->ci_mode->ivsize);
> +	memset(iv, 0, sizeof(*iv));
> +	if (s_cop->get_extent_context && lblk_num != U64_MAX) {
> +		size_t extent_offset;
> +		union fscrypt_extent_context ctx;
> +		int ret;
> +
> +		ret = fscrypt_get_extent_context(inode, lblk_num, &ctx,
> +						 &extent_offset, NULL);
> +		WARN_ON_ONCE(ret);
> +		memcpy(iv->raw, ctx.v1.iv.raw, sizeof(*iv));
> +		iv->lblk_num += cpu_to_le64(extent_offset);
> +		return;
> +	}

Please read through my review comment
https://lore.kernel.org/linux-fscrypt/Yx6MnaUqUTdjCmX+@quark/ again, as it
doesn't seem that you've addressed it.

- Eric
