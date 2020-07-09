Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1021921A72C
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jul 2020 20:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgGISlr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jul 2020 14:41:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:40034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726275AbgGISlr (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jul 2020 14:41:47 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7FB4D20775;
        Thu,  9 Jul 2020 18:41:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594320106;
        bh=ax/DveaR9ze8ppvrRAirvnkjIa/FB7zb9R14pb72k80=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Fxcdsn6fZeVFet62dc0AaLkXzl0M9NqgCUgrMHRwqJXOrUmj0Qjml6czMcLhXM77c
         peoRrb4WpVLPj8ATp0ZKMBG6ET+2D7dTBsh1W/IZqFQYW+8FAZJ7cf1IYmuadEWIOo
         sAjE2Sqwh/EOIEtX/8avootBPOfhNrkML2oa/62U=
Date:   Thu, 9 Jul 2020 11:41:45 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     Theodore Ts'o <tytso@mit.edu>, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [xfstests-bld PATCH] test-appliance: exclude generic/587 from
 the encrypt tests
Message-ID: <20200709184145.GA3855682@gmail.com>
References: <20200709183701.2564213-1-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200709183701.2564213-1-satyat@google.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jul 09, 2020 at 06:37:01PM +0000, Satya Tangirala wrote:
> The encryption feature doesn't play well with quota, and generic/587
> tests quota functionality.
> 
> Signed-off-by: Satya Tangirala <satyat@google.com>
> ---
>  .../test-appliance/files/root/fs/ext4/cfg/encrypt.exclude        | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt.exclude b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt.exclude
> index 47c26e7..07111c2 100644
> --- a/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt.exclude
> +++ b/kvm-xfstests/test-appliance/files/root/fs/ext4/cfg/encrypt.exclude
> @@ -24,6 +24,7 @@ generic/270
>  generic/381
>  generic/382
>  generic/566
> +generic/587
>  
>  # encryption doesn't play well with casefold (at least not yet)
>  generic/556
> -- 

Can you update encrypt_1k.exclude as well?

- Eric
