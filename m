Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC73652C1C5
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 May 2022 20:08:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239263AbiERRzk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 18 May 2022 13:55:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231372AbiERRzj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 18 May 2022 13:55:39 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9DB533EBD;
        Wed, 18 May 2022 10:55:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 78ECAB82019;
        Wed, 18 May 2022 17:55:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1EBECC385A9;
        Wed, 18 May 2022 17:55:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652896536;
        bh=ZgCBLE1QWTMc6nvvCJgjubvC1o2zHVrOcytVV9+84lM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZYwLZO+d5qhEePDch/VRC7Pi0r/xbqOerZDdXv9gIU/cDR5Steo5WlDQJuHk1gNbO
         KondzmIdbI8v86jeJRL99+8VC3DSRRUkSkgshvlL7YHabzxuS35d7LEGCgmMrLj0pO
         IboCCpliexaKK1IPFzDpO/aKpc9IW1F/BHIKZCTSSMrYeU+NFcL8Ygv7tj/n00zTTZ
         /qNyEfWgoygSTuhijE5cN1yLGUEiTZMoM3rEKZ3NqHh0UdTyBHKuT6iFL3PTLZaJhn
         33EKYR0tM4R04X2+WVGffFx0H9HZ2vslPsKmbUaDy/To60Z08Mtc+AwOnMAnMIv8tm
         vBUuwNJqjJyOQ==
Date:   Wed, 18 May 2022 10:55:34 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Zhang Jianhua <chris.zjh@huawei.com>
Cc:     tytso@mit.edu, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] fs-verity: Use struct_size() helper in
 enable_verity()
Message-ID: <YoUzFm9kL13oQi0K@sol.localdomain>
References: <20220518061309.2179692-1-chris.zjh@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518061309.2179692-1-chris.zjh@huawei.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 18, 2022 at 02:13:09PM +0800, Zhang Jianhua wrote:
> Make use of the struct_size() helper instead of an open-coded version,
> in order to avoid any potential type mistakes or integer overflows
> that, in the worst scenario, could lead to heap overflows.
> 
> Also, address the following sparse warnings:
> fs/verity/enable.c:205:28: warning: using sizeof on a flexible structure
> 
> Signed-off-by: Zhang Jianhua <chris.zjh@huawei.com>
> ---
>  fs/verity/enable.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/verity/enable.c b/fs/verity/enable.c
> index f75d2c010f36..075dc0aa5416 100644
> --- a/fs/verity/enable.c
> +++ b/fs/verity/enable.c
> @@ -201,7 +201,7 @@ static int enable_verity(struct file *filp,
>  	const struct fsverity_operations *vops = inode->i_sb->s_vop;
>  	struct merkle_tree_params params = { };
>  	struct fsverity_descriptor *desc;
> -	size_t desc_size = sizeof(*desc) + arg->sig_size;
> +	size_t desc_size = struct_size(desc, signature, arg->sig_size);
>  	struct fsverity_info *vi;
>  	int err;

This patch is a bit more useful than the other one, as the validation of
->sig_size happens in a different function.  But it still happens.  So please
don't claim that this patch is fixing a heap overflow.  People use commit
messages to determine whether patches are fixing something, and how important
the fix is.  So if it's a cleanup (not a bug fix), write that.

- Eric
