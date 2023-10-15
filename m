Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BB747C982A
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 Oct 2023 08:27:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230217AbjJOG10 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 15 Oct 2023 02:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjJOG1Z (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 15 Oct 2023 02:27:25 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 630C6C5;
        Sat, 14 Oct 2023 23:27:24 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E841CC433C8;
        Sun, 15 Oct 2023 06:27:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697351244;
        bh=LO+VQUZjGQnM9K3AYXKc0ZDmmWX8UnX+a624Am9tvrQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p57Vo2g2tU9OhtsAL3yz95Xu3TioCqAn1yUsuMDoE7eYdrdoW7D7JRzoH/8ResAmi
         5nBWWQJEUthScMUbKi4UMnfDrcyO2gfLEOuxVG2Ie879Jv148Q5C58Yra8/jqVvm7O
         rxCEZo8hS6QrRUzSv+Nygay3727pE0FVfnMHOS+CaCI9hv0d3v91GlWxgKLBR8w053
         XO5UXTogFXb6gdZ/CAEB8MG8UvtvpGn1Pzp4NTtlkU9y4pLMwOQEi4el/5aEz/2Gqd
         oFIcUea+5bvDXDHrS0BpXnWPMbTHHmLnftgJSKZQu3yd1SX6pX0gJMywiLnb6xl+Sa
         Y37fS36ewttHA==
Date:   Sat, 14 Oct 2023 23:27:22 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 04/36] fscrypt: disable all but standard v2 policies
 for extent encryption
Message-ID: <20231015062722.GC10525@sol.localdomain>
References: <cover.1696970227.git.josef@toxicpanda.com>
 <39faa5d97713d44564249b50518c0212e5bf04cc.1696970227.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <39faa5d97713d44564249b50518c0212e5bf04cc.1696970227.git.josef@toxicpanda.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 10, 2023 at 04:40:19PM -0400, Josef Bacik wrote:
> The different encryption related options for fscrypt are too numerous to
> support for extent based encryption.  Support for a few of these options
> could possibly be added, but since they're niche options simply reject
> them for file systems using extent based encryption.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/crypto/policy.c | 12 ++++++++++++
>  1 file changed, 12 insertions(+)
> 
> diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
> index 4729f21e21d8..75a69f02f11d 100644
> --- a/fs/crypto/policy.c
> +++ b/fs/crypto/policy.c
> @@ -209,6 +209,12 @@ static bool fscrypt_supported_v1_policy(const struct fscrypt_policy_v1 *policy,
>  		return false;
>  	}
>  
> +	if (inode->i_sb->s_cop->has_per_extent_encryption) {
> +		fscrypt_warn(inode,
> +			     "v1 policies can't be used on file systems that use extent encryption");
> +		return false;
> +	}
> +
>  	return true;
>  }
>  
> @@ -269,6 +275,12 @@ static bool fscrypt_supported_v2_policy(const struct fscrypt_policy_v2 *policy,
>  		}
>  	}
>  
> +	if ((inode->i_sb->s_cop->has_per_extent_encryption) && count) {
> +		fscrypt_warn(inode,
> +			     "Encryption flags aren't supported on file systems that use extent encryption");
> +		return false;
> +	}
> +

Perhaps this should just be folded into patch 3?

- Eric
