Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EFD34E8CAB
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Mar 2022 05:45:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237851AbiC1DrT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 27 Mar 2022 23:47:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54858 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232101AbiC1DrS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 27 Mar 2022 23:47:18 -0400
Received: from szxga03-in.huawei.com (szxga03-in.huawei.com [45.249.212.189])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D8BCFD26;
        Sun, 27 Mar 2022 20:45:38 -0700 (PDT)
Received: from dggpemm500024.china.huawei.com (unknown [172.30.72.57])
        by szxga03-in.huawei.com (SkyGuard) with ESMTP id 4KRdlz1654zBrny;
        Mon, 28 Mar 2022 11:41:35 +0800 (CST)
Received: from [10.67.110.173] (10.67.110.173) by
 dggpemm500024.china.huawei.com (7.185.36.203) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Mon, 28 Mar 2022 11:45:35 +0800
Message-ID: <0e803aad-5ae6-349b-b17e-89a832306925@huawei.com>
Date:   Mon, 28 Mar 2022 11:45:24 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v7 1/5] fs-verity: define a function to return the
 integrity protected file digest
Content-Language: en-US
To:     Mimi Zohar <zohar@linux.ibm.com>, <linux-integrity@vger.kernel.org>
CC:     Eric Biggers <ebiggers@kernel.org>,
        Stefan Berger <stefanb@linux.ibm.com>,
        <linux-fscrypt@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Eric Biggers <ebiggers@google.com>
References: <20220325223824.310119-1-zohar@linux.ibm.com>
 <20220325223824.310119-2-zohar@linux.ibm.com>
From:   "Guozihua (Scott)" <guozihua@huawei.com>
In-Reply-To: <20220325223824.310119-2-zohar@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.67.110.173]
X-ClientProxiedBy: dggems706-chm.china.huawei.com (10.3.19.183) To
 dggpemm500024.china.huawei.com (7.185.36.203)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-5.2 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 2022/3/26 6:38, Mimi Zohar wrote:
> Define a function named fsverity_get_digest() to return the verity file
> digest and the associated hash algorithm (enum hash_algo).
> 
> This assumes that before calling fsverity_get_digest() the file must have
> been opened, which is even true for the IMA measure/appraise on file
> open policy rule use case (func=FILE_CHECK).  do_open() calls vfs_open()
> immediately prior to ima_file_check().
> 
> Acked-by: Eric Biggers <ebiggers@google.com>
> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
> ---
>   fs/verity/Kconfig            |  1 +
>   fs/verity/fsverity_private.h |  7 ------
>   fs/verity/measure.c          | 43 ++++++++++++++++++++++++++++++++++++
>   include/linux/fsverity.h     | 18 +++++++++++++++
>   4 files changed, 62 insertions(+), 7 deletions(-)
> 
> diff --git a/fs/verity/Kconfig b/fs/verity/Kconfig
> index 24d1b54de807..54598cd80145 100644
> --- a/fs/verity/Kconfig
> +++ b/fs/verity/Kconfig
> @@ -3,6 +3,7 @@
>   config FS_VERITY
>   	bool "FS Verity (read-only file-based authenticity protection)"
>   	select CRYPTO
> +	select CRYPTO_HASH_INFO
>   	# SHA-256 is implied as it's intended to be the default hash algorithm.
>   	# To avoid bloat, other wanted algorithms must be selected explicitly.
>   	# Note that CRYPTO_SHA256 denotes the generic C implementation, but
> diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
> index a7920434bae5..c6fb62e0ef1a 100644
> --- a/fs/verity/fsverity_private.h
> +++ b/fs/verity/fsverity_private.h
> @@ -14,7 +14,6 @@
>   
>   #define pr_fmt(fmt) "fs-verity: " fmt
>   
> -#include <crypto/sha2.h>
>   #include <linux/fsverity.h>
>   #include <linux/mempool.h>
>   
> @@ -26,12 +25,6 @@ struct ahash_request;
>    */
>   #define FS_VERITY_MAX_LEVELS		8
>   
> -/*
> - * Largest digest size among all hash algorithms supported by fs-verity.
> - * Currently assumed to be <= size of fsverity_descriptor::root_hash.
> - */
> -#define FS_VERITY_MAX_DIGEST_SIZE	SHA512_DIGEST_SIZE
> -
>   /* A hash algorithm supported by fs-verity */
>   struct fsverity_hash_alg {
>   	struct crypto_ahash *tfm; /* hash tfm, allocated on demand */
> diff --git a/fs/verity/measure.c b/fs/verity/measure.c
> index f0d7b30c62db..e99c00350c28 100644
> --- a/fs/verity/measure.c
> +++ b/fs/verity/measure.c
> @@ -57,3 +57,46 @@ int fsverity_ioctl_measure(struct file *filp, void __user *_uarg)
>   	return 0;
>   }
>   EXPORT_SYMBOL_GPL(fsverity_ioctl_measure);
> +
> +/**
> + * fsverity_get_digest() - get a verity file's digest
> + * @inode: inode to get digest of
> + * @digest: (out) pointer to the digest
> + * @alg: (out) pointer to the hash algorithm enumeration
> + *
> + * Return the file hash algorithm and digest of an fsverity protected file.
> + * Assumption: before calling fsverity_get_digest(), the file must have been
> + * opened.
> + *
> + * Return: 0 on success, -errno on failure
> + */
> +int fsverity_get_digest(struct inode *inode,
> +			u8 digest[FS_VERITY_MAX_DIGEST_SIZE],
> +			enum hash_algo *alg)
> +{
> +	const struct fsverity_info *vi;
> +	const struct fsverity_hash_alg *hash_alg;
> +	int i;
> +
> +	vi = fsverity_get_info(inode);
> +	if (!vi)
> +		return -ENODATA; /* not a verity file */
> +
> +	hash_alg = vi->tree_params.hash_alg;
> +	memset(digest, 0, FS_VERITY_MAX_DIGEST_SIZE);

Hi Mimi,

I would suggest moving this memset downward right before the memcpy.

> +
> +	/* convert the verity hash algorithm name to a hash_algo_name enum */
> +	i = match_string(hash_algo_name, HASH_ALGO__LAST, hash_alg->name);
> +	if (i < 0)
> +		return -EINVAL;
> +	*alg = i;
> +
> +	if (WARN_ON_ONCE(hash_alg->digest_size != hash_digest_size[*alg]))
> +		return -EINVAL;
> +	memcpy(digest, vi->file_digest, hash_alg->digest_size);
> +
> +	pr_debug("file digest %s:%*phN\n", hash_algo_name[*alg],
> +		 hash_digest_size[*alg], digest);
> +
> +	return 0;
> +}
-- 
Best
GUO Zihua
