Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF7424E437
	for <lists+linux-fscrypt@lfdr.de>; Sat, 22 Aug 2020 02:39:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726884AbgHVAjX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 21 Aug 2020 20:39:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:53072 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726772AbgHVAjW (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 21 Aug 2020 20:39:22 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1F842072D;
        Sat, 22 Aug 2020 00:39:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598056761;
        bh=kgzW/U0vYo5+4gTHpQ+QxzAHRLAw16yXwqxy22qgXCs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bAvrja+gNBI5K5j+LKDQ/EcvCtAcIPZFdYo6jLtF5xN/XG5FeC6uSYhqkOxRbjSaz
         nS/CzPn++pdl+uZ5a9QhTuV/crFJPPmaFKgTjVPQ+NrlG56lInGx6faMj7xltycaRR
         QGPasURPxZnBxFD1mLm62qVFu1/K0N1pHfsl/6xU=
Date:   Fri, 21 Aug 2020 17:39:20 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jeff Layton <jlayton@kernel.org>
Cc:     ceph-devel@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [RFC PATCH 06/14] ceph: add fscrypt ioctls
Message-ID: <20200822003920.GC834@sol.localdomain>
References: <20200821182813.52570-1-jlayton@kernel.org>
 <20200821182813.52570-7-jlayton@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200821182813.52570-7-jlayton@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Aug 21, 2020 at 02:28:05PM -0400, Jeff Layton wrote:
> Boilerplate ioctls for controlling encryption.
> 
> Signed-off-by: Jeff Layton <jlayton@kernel.org>
> ---
>  fs/ceph/ioctl.c | 26 ++++++++++++++++++++++++++
>  1 file changed, 26 insertions(+)
> 
> diff --git a/fs/ceph/ioctl.c b/fs/ceph/ioctl.c
> index 6e061bf62ad4..4400b170eca9 100644
> --- a/fs/ceph/ioctl.c
> +++ b/fs/ceph/ioctl.c
> @@ -6,6 +6,7 @@
>  #include "mds_client.h"
>  #include "ioctl.h"
>  #include <linux/ceph/striper.h>
> +#include <linux/fscrypt.h>
>  
>  /*
>   * ioctls
> @@ -289,6 +290,31 @@ long ceph_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
>  
>  	case CEPH_IOC_SYNCIO:
>  		return ceph_ioctl_syncio(file);
> +#ifdef CONFIG_FS_ENCRYPTION
> +	case FS_IOC_SET_ENCRYPTION_POLICY:
> +		return fscrypt_ioctl_set_policy(file, (const void __user *)arg);
> +
> +	case FS_IOC_GET_ENCRYPTION_POLICY:
> +		return fscrypt_ioctl_get_policy(file, (void __user *)arg);
> +
> +	case FS_IOC_GET_ENCRYPTION_POLICY_EX:
> +		return fscrypt_ioctl_get_policy_ex(file, (void __user *)arg);
> +
> +	case FS_IOC_ADD_ENCRYPTION_KEY:
> +		return fscrypt_ioctl_add_key(file, (void __user *)arg);
> +
> +	case FS_IOC_REMOVE_ENCRYPTION_KEY:
> +		return fscrypt_ioctl_remove_key(file, (void __user *)arg);
> +
> +	case FS_IOC_REMOVE_ENCRYPTION_KEY_ALL_USERS:
> +		return fscrypt_ioctl_remove_key_all_users(file, (void __user *)arg);
> +
> +	case FS_IOC_GET_ENCRYPTION_KEY_STATUS:
> +		return fscrypt_ioctl_get_key_status(file, (void __user *)arg);
> +
> +	case FS_IOC_GET_ENCRYPTION_NONCE:
> +		return fscrypt_ioctl_get_nonce(file, (void __user *)arg);
> +#endif /* CONFIG_FS_ENCRYPTION */
>  	}

The '#ifdef CONFIG_FS_ENCRYPTION' isn't needed here, since all the
fscrypt_ioctl_*() functions are stubbed out when !CONFIG_FS_ENCRYPTION.

- Eric
