Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AB3252C196
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 May 2022 19:51:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240950AbiERRsV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 18 May 2022 13:48:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241006AbiERRsU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 18 May 2022 13:48:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A789D219C1F;
        Wed, 18 May 2022 10:48:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 69720B81F31;
        Wed, 18 May 2022 17:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F4F8C385A9;
        Wed, 18 May 2022 17:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652896097;
        bh=XnOSY/YWP/OcJnztugs91qjWrXuN8mOlfPqK9qsZjd0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ie3JiPoAx1hbI3cG/vRTzx2XlMNlsoEGVcxmuEY2S3MqzNQ5wERZ6TIsmcYfQb5le
         vd1Hu/CInDcejHu01Fwfq9iC795FjQKIz9OXYareDzgcURmHvh2IZuUElUBBamYeDI
         VPV2K+EnuEG8ppBWZ6XE1CXtQ3qAtYdK5eNhjzHtJJVnZuDmG5JGROD33YkWgnhBy9
         NHAWV++vvXKXzXxNVJ29xBBypCrgj6QlsVEypachZ09KY3HJuv0gcUu0EhnndgB8pj
         BZsCbtTha6jWoRFo/C4sRYohCqoFRLVfkRcVZ/EkowTx3HH+MJC7dlPv8+5Ax9V9iL
         kV1YktTGLyKvg==
Date:   Wed, 18 May 2022 10:48:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Zhang Jianhua <chris.zjh@huawei.com>
Cc:     tytso@mit.edu, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] fs-verity: Use struct_size() helper in
 fsverity_ioctl_measure()
Message-ID: <YoUxX7iDBczYwGHC@sol.localdomain>
References: <20220518093829.2248801-1-chris.zjh@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518093829.2248801-1-chris.zjh@huawei.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 18, 2022 at 05:38:29PM +0800, Zhang Jianhua wrote:
> Make use of the struct_size() helper instead of an open-coded version,
> in order to avoid any potential type mistakes or integer overflows that,
> in the worst scenario, could lead to heap overflows.
> 
> Also, address the following sparse warnings:
> fs/verity/measure.c:48:9: warning: using sizeof on a flexible structure
> fs/verity/measure.c:52:38: warning: using sizeof on a flexible structure
> 
> Signed-off-by: Zhang Jianhua <chris.zjh@huawei.com>
> ---
>  fs/verity/measure.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/verity/measure.c b/fs/verity/measure.c
> index e99c00350c28..4a388116d0de 100644
> --- a/fs/verity/measure.c
> +++ b/fs/verity/measure.c
> @@ -27,6 +27,7 @@ int fsverity_ioctl_measure(struct file *filp, void __user *_uarg)
>  	const struct fsverity_info *vi;
>  	const struct fsverity_hash_alg *hash_alg;
>  	struct fsverity_digest arg;
> +	size_t arg_size = struct_size(&arg, digest, 0);
>  
>  	vi = fsverity_get_info(inode);
>  	if (!vi)
> @@ -44,11 +45,11 @@ int fsverity_ioctl_measure(struct file *filp, void __user *_uarg)
>  	if (arg.digest_size < hash_alg->digest_size)
>  		return -EOVERFLOW;
>  
> -	memset(&arg, 0, sizeof(arg));
> +	memset(&arg, 0, arg_size);
>  	arg.digest_algorithm = hash_alg - fsverity_hash_algs;
>  	arg.digest_size = hash_alg->digest_size;
>  
> -	if (copy_to_user(uarg, &arg, sizeof(arg)))
> +	if (copy_to_user(uarg, &arg, arg_size))
>  		return -EFAULT;

'arg' is just a stack variable that doesn't use the flexible array field.  So
this change on its own is pretty pointless and just obfuscates the code.

If it's nevertheless worth it to get rid of the sparse warning, to make the
wider codebase clean of this class of warning, we could still do it anyway.  But
please make the commit message correctly say that the purpose is just to
eliminate the sparse warning, and don't incorrectly claim that the code "could
lead to heap overflows".

- Eric
