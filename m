Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 76CC113B468
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Jan 2020 22:33:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728656AbgANVdP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Jan 2020 16:33:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:43932 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726491AbgANVdO (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Jan 2020 16:33:14 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 0FF4724656
        for <linux-fscrypt@vger.kernel.org>; Tue, 14 Jan 2020 21:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1579037594;
        bh=o+XsSGUnLsqrxWstmvWYMEPb2ta3cAkVawxg26TlZa4=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=y7dij+DF//CZGZhdP3UrtYWfURPmIV3DUYghQfDEq87eIBgXKGIGJch069wOJp6/S
         HuWutwfiQL1waSp0wkNwMT3tMUMG/3hO8wLdhQI3bdXOCgB0AeVNpOcicAK6RyXR++
         ksIo34wNz1Ulv+zwjAlpt7g8cGURn6InCRe1eJAo=
Date:   Tue, 14 Jan 2020 13:33:12 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] fs-verity: use u64_to_user_ptr()
Message-ID: <20200114213312.GJ41220@gmail.com>
References: <20191231175408.20524-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191231175408.20524-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Dec 31, 2019 at 11:54:08AM -0600, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> <linux/kernel.h> already provides a macro u64_to_user_ptr().
> Use it instead of open-coding the two casts.
> 
> No change in behavior.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/verity/enable.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 
> diff --git a/fs/verity/enable.c b/fs/verity/enable.c
> index 1645d6326e32..520db12e2945 100644
> --- a/fs/verity/enable.c
> +++ b/fs/verity/enable.c
> @@ -216,8 +216,7 @@ static int enable_verity(struct file *filp,
>  
>  	/* Get the salt if the user provided one */
>  	if (arg->salt_size &&
> -	    copy_from_user(desc->salt,
> -			   (const u8 __user *)(uintptr_t)arg->salt_ptr,
> +	    copy_from_user(desc->salt, u64_to_user_ptr(arg->salt_ptr),
>  			   arg->salt_size)) {
>  		err = -EFAULT;
>  		goto out;
> @@ -226,8 +225,7 @@ static int enable_verity(struct file *filp,
>  
>  	/* Get the signature if the user provided one */
>  	if (arg->sig_size &&
> -	    copy_from_user(desc->signature,
> -			   (const u8 __user *)(uintptr_t)arg->sig_ptr,
> +	    copy_from_user(desc->signature, u64_to_user_ptr(arg->sig_ptr),
>  			   arg->sig_size)) {
>  		err = -EFAULT;
>  		goto out;

Applied to fscrypt.git#fsverity for 5.6.

- Eric
