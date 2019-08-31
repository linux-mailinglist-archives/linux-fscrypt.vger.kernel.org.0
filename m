Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92A8EA440F
	for <lists+linux-fscrypt@lfdr.de>; Sat, 31 Aug 2019 12:32:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728095AbfHaKcb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 31 Aug 2019 06:32:31 -0400
Received: from szxga06-in.huawei.com ([45.249.212.32]:40354 "EHLO huawei.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1727404AbfHaKcb (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 31 Aug 2019 06:32:31 -0400
Received: from DGGEMS413-HUB.china.huawei.com (unknown [172.30.72.58])
        by Forcepoint Email with ESMTP id E7011FF38C00B8F8B49E;
        Sat, 31 Aug 2019 18:32:29 +0800 (CST)
Received: from [10.134.22.195] (10.134.22.195) by smtp.huawei.com
 (10.3.19.213) with Microsoft SMTP Server (TLS) id 14.3.439.0; Sat, 31 Aug
 2019 18:32:29 +0800
Subject: Re: [PATCH] ext4 crypto: fix to check feature status before get
 policy
To:     <tytso@mit.edu>, <adilger.kernel@dilger.ca>, <ebiggers@kernel.org>
CC:     Chao Yu <chao@kernel.org>, <linux-ext4@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-fscrypt@vger.kernel.org>
References: <20190804095643.7393-1-chao@kernel.org>
From:   Chao Yu <yuchao0@huawei.com>
Message-ID: <f5186fae-ac58-a5f5-f9dc-b749ade7285d@huawei.com>
Date:   Sat, 31 Aug 2019 18:32:28 +0800
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:52.0) Gecko/20100101
 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <20190804095643.7393-1-chao@kernel.org>
Content-Type: text/plain; charset="windows-1252"
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.134.22.195]
X-CFilter-Loop: Reflected
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi,

Is this change not necessary? A month has passed...

Thanks,

On 2019/8/4 17:56, Chao Yu wrote:
> From: Chao Yu <yuchao0@huawei.com>
> 
> When getting fscrypto policy via EXT4_IOC_GET_ENCRYPTION_POLICY, if
> encryption feature is off, it's better to return EOPNOTSUPP instead
> of ENODATA, so let's add ext4_has_feature_encrypt() to do the check
> for that.
> 
> Signed-off-by: Chao Yu <yuchao0@huawei.com>
> ---
>  fs/ext4/ioctl.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
> index 442f7ef873fc..bf87835c1237 100644
> --- a/fs/ext4/ioctl.c
> +++ b/fs/ext4/ioctl.c
> @@ -1112,9 +1112,11 @@ long ext4_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
>  		return -EOPNOTSUPP;
>  #endif
>  	}
> -	case EXT4_IOC_GET_ENCRYPTION_POLICY:
> +	case EXT4_IOC_GET_ENCRYPTION_POLICY: {
> +		if (!ext4_has_feature_encrypt(sb))
> +			return -EOPNOTSUPP;
>  		return fscrypt_ioctl_get_policy(filp, (void __user *)arg);
> -
> +	}
>  	case EXT4_IOC_FSGETXATTR:
>  	{
>  		struct fsxattr fa;
> 
