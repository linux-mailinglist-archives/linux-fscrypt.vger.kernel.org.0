Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0DD752C1D5
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 May 2022 20:09:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231394AbiERSFS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 18 May 2022 14:05:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35708 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231655AbiERSFS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 18 May 2022 14:05:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42A908FF85;
        Wed, 18 May 2022 11:05:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F084BB8218B;
        Wed, 18 May 2022 18:05:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 993FBC385A9;
        Wed, 18 May 2022 18:05:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652897114;
        bh=7JkC24Mot9/5obk1Xa7+1SZC4yCnyweiTY9ppx9XqPs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RqyhLIqxmeJ+mdhUIOaArmC+9csITjggykFkseyU7Drhn5URq06lwNCO2tcY79S6u
         Z5e86vA0MdBP7k4TQPvEjuJQ6PVZfD0xwcPdzM9VPwrPh+ZRKPDO4XoCLU2duFYLHO
         jI3vQ7wK642u1TzXArO+p7vrEg85SY/Ypf4BRvrheIcKWRhpAIxnhtypaA2adpa0NB
         zLWnhuPb6B9FpQfFhkPodpZJVo8SGoKxZv7Uww8V/pUF/446wBkgcfS1I21AwKAtEi
         e4aLASPYtWK4A6o7XlMOzlnCK+Xkx/p9DeDgtnIgnza9Uihg+Pak4SCig6mld5OXTZ
         uo6kCQREHS8WQ==
Date:   Wed, 18 May 2022 11:05:12 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Zhang Jianhua <chris.zjh@huawei.com>
Cc:     tytso@mit.edu, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next] fs-verity: remove unused parameter desc_size in
 fsverity_create_info()
Message-ID: <YoU1WP8c0n6AlYGM@sol.localdomain>
References: <20220518132256.2297655-1-chris.zjh@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518132256.2297655-1-chris.zjh@huawei.com>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 18, 2022 at 09:22:56PM +0800, Zhang Jianhua wrote:
> The parameter desc_size in fsverity_create_info() is useless and it is
> not referenced anywhere. The greatest meaning of desc_size here is to
> indecate the size of struct fsverity_descriptor and futher calculate the
> size of signature. However, the desc->sig_size can do it also and it is
> indeed, so remove it.
> 
> Therefore, it is no need to acquire desc_size by fsverity_get_descriptor()
> in ensure_verity_info(), so remove the parameter desc_ret in
> fsverity_get_descriptor() too.
> 
> Signed-off-by: Zhang Jianhua <chris.zjh@huawei.com>
> ---
>  fs/verity/enable.c           |  2 +-
>  fs/verity/fsverity_private.h |  6 ++----
>  fs/verity/open.c             | 12 ++++--------
>  fs/verity/read_metadata.c    |  5 ++---
>  4 files changed, 9 insertions(+), 16 deletions(-)

Applied, thanks!

- Eric
