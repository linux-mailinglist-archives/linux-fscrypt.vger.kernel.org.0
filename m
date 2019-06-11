Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CC6A03C126
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jun 2019 04:09:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728747AbfFKCJT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Jun 2019 22:09:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:37766 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728685AbfFKCJT (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Jun 2019 22:09:19 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1284F206E0
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Jun 2019 02:09:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1560218958;
        bh=OZZnHmKOxjmwCjFfrdFQbmyEaaZlBzZMhcvDmHmkNn4=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=r0db4wdzC5oanLuPhtyPUstowF3Vx6lZe5zJoqPD9ZcMLMuwIOevyS+2wbUhX9SN3
         69XtAwuFfqlQuQYiAp3uXmDdkc4MrQ4B6b8NUCWfr/pWsuqjgvwP9mGB7dLwsNLNNM
         WoFVet7VB7txGP9mn5vu972NO22nc68YAvgwlXaM=
Date:   Mon, 10 Jun 2019 19:09:16 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] fscrypt: remove unnecessary includes of ratelimit.h
Message-ID: <20190611020916.GA4255@sol.localdomain>
References: <20190528195908.77031-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528195908.77031-1-ebiggers@kernel.org>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, May 28, 2019 at 12:59:08PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> These should have been removed during commit 544d08fde258 ("fscrypt: use
> a common logging function"), but I missed them.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/fname.c   | 1 -
>  fs/crypto/hooks.c   | 1 -
>  fs/crypto/keyinfo.c | 1 -
>  3 files changed, 3 deletions(-)
> 
> diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
> index eccea3d8f9234..00d150ff30332 100644
> --- a/fs/crypto/fname.c
> +++ b/fs/crypto/fname.c
> @@ -12,7 +12,6 @@
>   */
>  
>  #include <linux/scatterlist.h>
> -#include <linux/ratelimit.h>
>  #include <crypto/skcipher.h>
>  #include "fscrypt_private.h"
>  
> diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
> index bd525f7573a49..c1d6715d88e93 100644
> --- a/fs/crypto/hooks.c
> +++ b/fs/crypto/hooks.c
> @@ -5,7 +5,6 @@
>   * Encryption hooks for higher-level filesystem operations.
>   */
>  
> -#include <linux/ratelimit.h>
>  #include "fscrypt_private.h"
>  
>  /**
> diff --git a/fs/crypto/keyinfo.c b/fs/crypto/keyinfo.c
> index dcd91a3fbe49a..207ebed918c15 100644
> --- a/fs/crypto/keyinfo.c
> +++ b/fs/crypto/keyinfo.c
> @@ -12,7 +12,6 @@
>  #include <keys/user-type.h>
>  #include <linux/hashtable.h>
>  #include <linux/scatterlist.h>
> -#include <linux/ratelimit.h>
>  #include <crypto/aes.h>
>  #include <crypto/algapi.h>
>  #include <crypto/sha.h>
> -- 
> 2.22.0.rc1.257.g3120a18244-goog
> 

Applied to fscrypt.git for v5.3.

- Eric
