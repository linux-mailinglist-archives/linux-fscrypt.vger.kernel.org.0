Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02BA6462C66
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Nov 2021 06:56:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238457AbhK3F7w (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 30 Nov 2021 00:59:52 -0500
Received: from linux.microsoft.com ([13.77.154.182]:48636 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238424AbhK3F7o (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 30 Nov 2021 00:59:44 -0500
Received: from [10.137.112.111] (unknown [131.107.147.111])
        by linux.microsoft.com (Postfix) with ESMTPSA id 6C92B20E0BEE;
        Mon, 29 Nov 2021 21:56:25 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 6C92B20E0BEE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1638251785;
        bh=uMBmE3bjaIo2UVqChPb9heTUoiSYJ/dDZTM6CXO3MnE=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=VJfNG527hZNB2KZoohoHHtKvt3AD4y3O0e0gVPsXIamdYqoJGvaO8DM6rDno7Ypaq
         R+hSJB01nbIqRLq6IzYYF0TKjkfra1P7ipNrJgz2H/azwo/kdh/L2rCoeEl1TXHSFB
         kiwyvZIZ9iSVIDE4RlW5QD5a9J0lWametgvkTovw=
Message-ID: <7dfa283e-13b2-40de-158d-8642778d74cc@linux.microsoft.com>
Date:   Mon, 29 Nov 2021 21:56:25 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 4/4] ima: support fs-verity file digest based signatures
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, linux-integrity@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
References: <20211129170057.243127-1-zohar@linux.ibm.com>
 <20211129170057.243127-5-zohar@linux.ibm.com>
From:   Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
In-Reply-To: <20211129170057.243127-5-zohar@linux.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Mimi,

On 11/29/2021 9:00 AM, Mimi Zohar wrote:
> Instead of calculating a file hash and verifying the signature stored
> in the security.ima xattr against the calculated file hash, verify the
> signature of the fs-verity's file digest.  The fs-verity file digest is
> a hash that includes the Merkle tree root hash.
This patch is reading the fs-verity signature for the given file using 
the new function fsverity_measure() that was defined in [Patch 1/4]. Is 
it also verifying the fs-verity signature here?

> 
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>   security/integrity/ima/ima_api.c | 20 ++++++++++++++++++++
>   1 file changed, 20 insertions(+)
> 
> diff --git a/security/integrity/ima/ima_api.c b/security/integrity/ima/ima_api.c
> index 179c7f0364c2..ee1701f8c0f3 100644
> --- a/security/integrity/ima/ima_api.c
> +++ b/security/integrity/ima/ima_api.c
> @@ -16,6 +16,7 @@
>   #include <linux/xattr.h>
>   #include <linux/evm.h>
>   #include <linux/iversion.h>
> +#include <linux/fsverity.h>
>   
>   #include "ima.h"
>   
> @@ -205,6 +206,23 @@ int ima_get_action(struct user_namespace *mnt_userns, struct inode *inode,
>   				allowed_algos);
>   }
>   
> +static int ima_collect_verity_measurement(struct integrity_iint_cache *iint,
> +					  struct ima_digest_data *hash)
> +{
> +	u8 verity_digest[FS_VERITY_MAX_DIGEST_SIZE];
> +	enum hash_algo verity_alg;
> +	int rc;
> +
> +	rc = fsverity_measure(iint->inode, verity_digest, &verity_alg);
nit: fsverity_collect_measurement() may be more appropriate for this 
function (defined in [PATCH 1/4]).

thanks,
  -lakshmi

> +	if (rc)
> +		return -EINVAL;
> +	if (hash->algo != verity_alg)
> +		return -EINVAL;
> +	hash->length = hash_digest_size[verity_alg];
> +	memcpy(hash->digest, verity_digest, hash->length);
> +	return 0;
> +}
> +
>   /*
>    * ima_collect_measurement - collect file measurement
>    *
> @@ -256,6 +274,8 @@ int ima_collect_measurement(struct integrity_iint_cache *iint,
>   
>   	if (buf)
>   		result = ima_calc_buffer_hash(buf, size, &hash.hdr);
> +	else if (veritysig)
> +		result = ima_collect_verity_measurement(iint, &hash.hdr);
>   	else
>   		result = ima_calc_file_hash(file, &hash.hdr);
>   
> 
