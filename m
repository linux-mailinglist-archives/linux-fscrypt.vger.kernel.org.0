Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A7DD682DB3
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Jan 2023 14:22:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231907AbjAaNWu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Jan 2023 08:22:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231585AbjAaNWu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Jan 2023 08:22:50 -0500
Received: from frasgout13.his.huawei.com (frasgout13.his.huawei.com [14.137.139.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3258810DD;
        Tue, 31 Jan 2023 05:22:47 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout13.his.huawei.com (SkyGuard) with ESMTP id 4P5lrb6snhz9v7ZH;
        Tue, 31 Jan 2023 21:14:39 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwAnqQQDFtlj3RPhAA--.10866S2;
        Tue, 31 Jan 2023 14:22:23 +0100 (CET)
Message-ID: <4f029a41d80d883d9b4729cbc85211955c9efe8e.camel@huaweicloud.com>
Subject: Re: [RFC PATCH v9 10/16] dm-verity: consume root hash digest and
 signature data via LSM hook
From:   Roberto Sassu <roberto.sassu@huaweicloud.com>
To:     Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk,
        agk@redhat.com, snitzer@kernel.org, eparis@redhat.com,
        paul@paul-moore.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Date:   Tue, 31 Jan 2023 14:22:01 +0100
In-Reply-To: <1675119451-23180-11-git-send-email-wufan@linux.microsoft.com>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
         <1675119451-23180-11-git-send-email-wufan@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LxC2BwAnqQQDFtlj3RPhAA--.10866S2
X-Coremail-Antispam: 1UD129KBjvJXoW3WrW5KF1xuw43XrWUCF1Utrb_yoWfGw4UpF
        Wq9Fy5KrW5JF47G3WxAF129F4Yy340kry7Kry29w18uF1ktw10q3yvyrW7ZrWxAr97JFyI
        gFs7Gr45ur1qy3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUUkFb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
        6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
        vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
        xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
        AFwI0_Gr1j6F4UJwAS0I0E0xvYzxvE52x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG
        6I80ewAv7VC0I7IYx2IY67AKxVWUJVWUGwAv7VC2z280aVAFwI0_Jr0_Gr1lOx8S6xCaFV
        Cjc4AY6r1j6r4UM4x0Y48IcVAKI48JM4IIrI8v6xkF7I0E8cxan2IY04v7MxAIw28IcxkI
        7VAKI48JMxC20s026xCaFVCjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxV
        Cjr7xvwVAFwI0_JrI_JrWlx4CE17CEb7AF67AKxVW8ZVWrXwCIc40Y0x0EwIxGrwCI42IY
        6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JVWxJwCI42IY6x
        AIw20EY4v20xvaj40_Wr1j6rW3Jr1lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280
        aVCY1x0267AKxVW8Jr0_Cr1UYxBIdaVFxhVjvjDU0xZFpf9x07UZ18PUUUUU=
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgAOBF1jj4RYzQAAso
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> From: Deven Bowers <deven.desai@linux.microsoft.com>
> 
> dm-verity provides a strong guarantee of a block device's integrity. As
> a generic way to check the integrity of a block device, it provides
> those integrity guarantees to its higher layers, including the filesystem
> level.

I think you could reuse most of is_trusted_verity_target(), in
particular dm_verity_get_root_digest().

And probably, the previous patch is not necessary.

Roberto

> An LSM that control access to a resource on the system based on the
> available integrity claims can use this transitive property of
> dm-verity, by querying the underlying block_device of a particular
> file.
> 
> The digest and signature information need to be stored in the block
> device to fulfill the next requirement of authorization via LSM policy.
> This will enable the LSM  to perform revocation of devices that are still
> mounted, prohibiting execution of files that are no longer authorized
> by the LSM in question.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v2:
>   + No Changes
> 
> v3:
>   + No changes
> 
> v4:
>   + No changes
> 
> v5:
>   + No changes
> 
> v6:
>   + Fix an improper cleanup that can result in
>     a leak
> 
> v7:
>   + Squash patch 08/12, 10/12 to [11/16]
>   + Use part0 for block_device, to retrieve the block_device, when
>     calling security_bdev_setsecurity
> 
> v8:
>   + Undo squash of 08/12, 10/12 - separating drivers/md/ from
>     security/ & block/
>   + Use common-audit function for dmverity_signature.
>   + Change implementation for storing the dm-verity digest to use the
>     newly introduced dm_verity_digest structure introduced in patch
>     14/20.
>   + Create new structure, dm_verity_digest, containing digest algorithm,
>     size, and digest itself to pass to the LSM layer. V7 was missing the
>     algorithm.
>   + Create an associated public header containing this new structure and
>     the key values for the LSM hook, specific to dm-verity.
>   + Additional information added to commit, discussing the layering of
>     the changes and how the information passed will be used.
> 
> v9:
>   + No changes
> ---
>  drivers/md/dm-verity-target.c     | 25 +++++++++++++++++++++++--
>  drivers/md/dm-verity-verify-sig.c | 16 +++++++++++++---
>  drivers/md/dm-verity-verify-sig.h | 10 ++++++----
>  include/linux/dm-verity.h         | 19 +++++++++++++++++++
>  4 files changed, 61 insertions(+), 9 deletions(-)
>  create mode 100644 include/linux/dm-verity.h
> 
> diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
> index ccf5b852fbf7..afea61eed4ec 100644
> --- a/drivers/md/dm-verity-target.c
> +++ b/drivers/md/dm-verity-target.c
> @@ -13,6 +13,7 @@
>   * access behavior.
>   */
>  
> +#include "dm-core.h"
>  #include "dm-verity.h"
>  #include "dm-verity-fec.h"
>  #include "dm-verity-verify-sig.h"
> @@ -21,6 +22,9 @@
>  #include <linux/scatterlist.h>
>  #include <linux/string.h>
>  #include <linux/jump_label.h>
> +#include <linux/security.h>
> +#include <linux/dm-verity.h>
> +#include <crypto/hash_info.h>
>  
>  #define DM_MSG_PREFIX			"verity"
>  
> @@ -1169,6 +1173,8 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  	sector_t hash_position;
>  	char dummy;
>  	char *root_hash_digest_to_validate;
> +	struct block_device *bdev;
> +	struct dm_verity_digest root_digest;
>  
>  	v = kzalloc(sizeof(struct dm_verity), GFP_KERNEL);
>  	if (!v) {
> @@ -1211,6 +1217,13 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  	}
>  	v->version = num;
>  
> +	bdev = dm_table_get_md(ti->table)->disk->part0;
> +	if (!bdev) {
> +		ti->error = "Mapped device lookup failed";
> +		r = -ENOMEM;
> +		goto bad;
> +	}
> +
>  	r = dm_get_device(ti, argv[1], FMODE_READ, &v->data_dev);
>  	if (r) {
>  		ti->error = "Data device lookup failed";
> @@ -1343,7 +1356,7 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  	}
>  
>  	/* Root hash signature is  a optional parameter*/
> -	r = verity_verify_root_hash(root_hash_digest_to_validate,
> +	r = verity_verify_root_hash(bdev, root_hash_digest_to_validate,
>  				    strlen(root_hash_digest_to_validate),
>  				    verify_args.sig,
>  				    verify_args.sig_size);
> @@ -1428,12 +1441,20 @@ static int verity_ctr(struct dm_target *ti, unsigned argc, char **argv)
>  	ti->per_io_data_size = roundup(ti->per_io_data_size,
>  				       __alignof__(struct dm_verity_io));
>  
> +	root_digest.digest = v->root_digest;
> +	root_digest.digest_len = v->digest_size;
> +	root_digest.algo = v->alg_name;
> +
> +	r = security_bdev_setsecurity(bdev, DM_VERITY_ROOTHASH_SEC_NAME, &root_digest,
> +				      sizeof(root_digest));
> +	if (r)
> +		goto bad;
> +
>  	verity_verify_sig_opts_cleanup(&verify_args);
>  
>  	return 0;
>  
>  bad:
> -
>  	verity_verify_sig_opts_cleanup(&verify_args);
>  	verity_dtr(ti);
>  
> diff --git a/drivers/md/dm-verity-verify-sig.c b/drivers/md/dm-verity-verify-sig.c
> index db61a1f43ae9..5a73b91157d5 100644
> --- a/drivers/md/dm-verity-verify-sig.c
> +++ b/drivers/md/dm-verity-verify-sig.c
> @@ -9,6 +9,9 @@
>  #include <linux/verification.h>
>  #include <keys/user-type.h>
>  #include <linux/module.h>
> +#include <linux/security.h>
> +#include <linux/dm-verity.h>
> +#include "dm-core.h"
>  #include "dm-verity.h"
>  #include "dm-verity-verify-sig.h"
>  
> @@ -97,14 +100,17 @@ int verity_verify_sig_parse_opt_args(struct dm_arg_set *as,
>   * verify_verify_roothash - Verify the root hash of the verity hash device
>   *			     using builtin trusted keys.
>   *
> + * @bdev: block_device representing the device-mapper created block device.
> + *	  Used by the security hook, to set information about the block_device.
>   * @root_hash: For verity, the roothash/data to be verified.
>   * @root_hash_len: Size of the roothash/data to be verified.
>   * @sig_data: The trusted signature that verifies the roothash/data.
>   * @sig_len: Size of the signature.
>   *
>   */
> -int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
> -			    const void *sig_data, size_t sig_len)
> +int verity_verify_root_hash(struct block_device *bdev, const void *root_hash,
> +			    size_t root_hash_len, const void *sig_data,
> +			    size_t sig_len)
>  {
>  	int ret;
>  
> @@ -126,8 +132,12 @@ int verity_verify_root_hash(const void *root_hash, size_t root_hash_len,
>  				NULL,
>  #endif
>  				VERIFYING_UNSPECIFIED_SIGNATURE, NULL, NULL);
> +	if (ret)
> +		return ret;
>  
> -	return ret;
> +	return security_bdev_setsecurity(bdev,
> +					 DM_VERITY_SIGNATURE_SEC_NAME,
> +					 sig_data, sig_len);
>  }
>  
>  void verity_verify_sig_opts_cleanup(struct dm_verity_sig_opts *sig_opts)
> diff --git a/drivers/md/dm-verity-verify-sig.h b/drivers/md/dm-verity-verify-sig.h
> index 3987c7141f79..31692fff92e4 100644
> --- a/drivers/md/dm-verity-verify-sig.h
> +++ b/drivers/md/dm-verity-verify-sig.h
> @@ -20,8 +20,9 @@ struct dm_verity_sig_opts {
>  
>  #define DM_VERITY_ROOT_HASH_VERIFICATION_OPTS 2
>  
> -int verity_verify_root_hash(const void *data, size_t data_len,
> -			    const void *sig_data, size_t sig_len);
> +int verity_verify_root_hash(struct block_device *bdev, const void *data,
> +			    size_t data_len, const void *sig_data,
> +			    size_t sig_len);
>  bool verity_verify_is_sig_opt_arg(const char *arg_name);
>  
>  int verity_verify_sig_parse_opt_args(struct dm_arg_set *as, struct dm_verity *v,
> @@ -34,8 +35,9 @@ void verity_verify_sig_opts_cleanup(struct dm_verity_sig_opts *sig_opts);
>  
>  #define DM_VERITY_ROOT_HASH_VERIFICATION_OPTS 0
>  
> -static inline int verity_verify_root_hash(const void *data, size_t data_len,
> -					  const void *sig_data, size_t sig_len)
> +int verity_verify_root_hash(struct block_device *bdev, const void *data,
> +			    size_t data_len, const void *sig_data,
> +			    size_t sig_len)
>  {
>  	return 0;
>  }
> diff --git a/include/linux/dm-verity.h b/include/linux/dm-verity.h
> new file mode 100644
> index 000000000000..bb0413d55d72
> --- /dev/null
> +++ b/include/linux/dm-verity.h
> @@ -0,0 +1,19 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +
> +#ifndef _LINUX_DM_VERITY_H
> +#define _LINUX_DM_VERITY_H
> +
> +#include <linux/types.h>
> +#include <crypto/hash_info.h>
> +#include <linux/device-mapper.h>
> +
> +struct dm_verity_digest {
> +	const char *algo;
> +	const u8 *digest;
> +	size_t digest_len;
> +};
> +
> +#define DM_VERITY_SIGNATURE_SEC_NAME DM_NAME	".verity-signature"
> +#define DM_VERITY_ROOTHASH_SEC_NAME  DM_NAME	".verity-roothash"
> +
> +#endif /* _LINUX_DM_VERITY_H */

