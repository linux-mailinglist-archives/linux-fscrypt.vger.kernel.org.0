Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5345C682E9F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 31 Jan 2023 15:01:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232477AbjAaOB2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 31 Jan 2023 09:01:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232479AbjAaOBW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 31 Jan 2023 09:01:22 -0500
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F730460BA;
        Tue, 31 Jan 2023 06:00:54 -0800 (PST)
Received: from mail02.huawei.com (unknown [172.18.147.227])
        by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4P5mhP1RlLz9xFmy;
        Tue, 31 Jan 2023 21:52:37 +0800 (CST)
Received: from roberto-ThinkStation-P620 (unknown [10.204.63.22])
        by APP1 (Coremail) with SMTP id LxC2BwAHjQjyHtlj0zLhAA--.10979S2;
        Tue, 31 Jan 2023 15:00:31 +0100 (CET)
Message-ID: <d62907da62b5e0b25c9d7bd4b3119a3d1827bd29.camel@huaweicloud.com>
Subject: Re: [RFC PATCH v9 13/16] ipe: enable support for fs-verity as a
 trust provider
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
Date:   Tue, 31 Jan 2023 15:00:08 +0100
In-Reply-To: <1675119451-23180-14-git-send-email-wufan@linux.microsoft.com>
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com>
         <1675119451-23180-14-git-send-email-wufan@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-CM-TRANSID: LxC2BwAHjQjyHtlj0zLhAA--.10979S2
X-Coremail-Antispam: 1UD129KBjvAXoW3ZFWkWw1UuFy7Gw1ftw13Jwb_yoW8Wr1xKo
        WSqa1xuF4jgr13Aw4F93W7AFW29wsYgw4xJF4qqrZrWF1Sq345Gw4UA3WfAF48Xr98Gr98
        C3s2vayrZF45twn8n29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73VFW2AGmfu7bjvjm3
        AaLaJ3UjIYCTnIWjp_UUUY17kC6x804xWl14x267AKxVW5JVWrJwAFc2x0x2IEx4CE42xK
        8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII0Yj41l84x0c7CEw4
        AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26r1j6r1xM28EF7xvwVC0I7IYx2IY6xkF
        7I0E14v26r4j6F4UM28EF7xvwVC2z280aVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv6xkF7I
        0E14v26r4UJVWxJr1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG64xvF2IEw4CE5I8C
        rVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r4j6F4UMcvjeVCFs4
        IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwACI402YVCY1x02628vn2kIc2xKxwCF04k20xvY
        0x0EwIxGrwCFx2IqxVCFs4IE7xkEbVWUJVW8JwC20s026c02F40E14v26r1j6r18MI8I3I
        0E7480Y4vE14v26r106r1rMI8E67AF67kF1VAFwI0_GFv_WrylIxkGc2Ij64vIr41lIxAI
        cVC0I7IYx2IY67AKxVWUJVWUCwCI42IY6xIIjxv20xvEc7CjxVAFwI0_Gr0_Cr1lIxAIcV
        CF04k26cxKx2IYs7xG6rWUJVWrZr1UMIIF0xvEx4A2jsIE14v26r1j6r4UMIIF0xvEx4A2
        jsIEc7CjxVAFwI0_Gr1j6F4UJbIYCTnIWIevJa73UjIFyTuYvjxU7OJ5UUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAQAOBF1jj4hViAAFsq
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2023-01-30 at 14:57 -0800, Fan Wu wrote:
> Enable IPE policy authors to indicate trust for a singular fsverity
> file, identified by the digest information, through "fsverity_digest"
> and all files using fsverity's builtin signatures via
> "fsverity_signature".
> 
> This enables file-level integrity claims to be expressed in IPE,
> allowing individual files to be authorized, giving some flexibility
> for policy authors. Such file-level claims are important to be expressed
> for enforcing the integrity of packages, as well as address some of the
> scalability issues in a sole dm-verity based solution (# of loop back
> devices, etc).
> 
> This solution cannot be done in userspace as the minimum threat that
> IPE should mitigate is an attacker downloads malicious payload with
> all required dependencies. These dependencies can lack the userspace
> check, bypassing the protection entirely. A similar attack succeeds if
> the userspace component is replaced with a version that does not
> perform the check. As a result, this can only be done in the common
> entry point - the kernel.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v1-v6:
>   + Not present
> 
> v7:
>   Introduced
> 
> v8:
>   * Undo squash of 08/12, 10/12 - separating drivers/md/ from security/
>   * Use common-audit function for fsverity_signature.
>   + Change fsverity implementation to use fsverity_get_digest
>   + prevent unnecessary copy of fs-verity signature data, instead
>     just check for presence of signature data.
>   + Remove free_inode_security hook, as the digest is now acquired
>     at runtime instead of via LSM blob.
> 
> v9:
>   + Adapt to the new parser
> ---
>  security/ipe/Kconfig         |  11 ++++
>  security/ipe/audit.c         |  23 +++++++
>  security/ipe/eval.c          | 112 +++++++++++++++++++++++++++++++++++
>  security/ipe/eval.h          |  10 ++++
>  security/ipe/hooks.c         |  30 ++++++++++
>  security/ipe/hooks.h         |   7 +++
>  security/ipe/ipe.c           |  13 ++++
>  security/ipe/ipe.h           |   3 +
>  security/ipe/policy.h        |   3 +
>  security/ipe/policy_parser.c |   8 +++
>  10 files changed, 220 insertions(+)
> 
> diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
> index 16e835ce61b0..dd9a066dd35a 100644
> --- a/security/ipe/Kconfig
> +++ b/security/ipe/Kconfig
> @@ -32,6 +32,17 @@ config IPE_PROP_DM_VERITY
>  
>  	  If unsure, answer Y.
>  
> +config IPE_PROP_FS_VERITY
> +	bool "Enable property for fs-verity files"
> +	depends on FS_VERITY && FS_VERITY_BUILTIN_SIGNATURES
> +	help
> +	  This option enables the usage of properties "fsverity_signature"
> +	  and "fsverity_digest". These properties evaluates to TRUE when
> +	  a file is fsverity enabled and with a signed digest or its
> +	  diegst matches the supplied value in the policy.
> +
> +	  if unsure, answer Y.
> +
>  endmenu
>  
>  endif
> diff --git a/security/ipe/audit.c b/security/ipe/audit.c
> index 769ba95d9b0d..16d81645e53c 100644
> --- a/security/ipe/audit.c
> +++ b/security/ipe/audit.c
> @@ -46,6 +46,11 @@ static const char *const audit_prop_names[ipe_prop_max] = {
>  	"dmverity_signature=FALSE",
>  	"dmverity_signature=TRUE",
>  #endif /* CONFIG_IPE_PROP_DM_VERITY */
> +#ifdef CONFIG_IPE_PROP_FS_VERITY
> +	"fsverity_digest=",
> +	"fsverity_signature=FALSE",
> +	"fsverity_signature=TRUE"
> +#endif /* CONFIG_IPE_PROP_FS_VERITY */
>  };
>  
>  #ifdef CONFIG_IPE_PROP_DM_VERITY
> @@ -64,6 +69,22 @@ static void audit_dmv_roothash(struct audit_buffer *ab, const void *rh)
>  }
>  #endif /* CONFIG_IPE_PROP_DM_VERITY */
>  
> +#ifdef CONFIG_IPE_PROP_FS_VERITY
> +/**
> + * audit_fsv_digest - audit a digest of a fsverity file.
> + * @ab: Supplies a poniter to the audit_buffer to append to.
> + * @d: Supplies a pointer to the digest structure.
> + */
> +static void audit_fsv_digest(struct audit_buffer *ab, const void *d)
> +{
> +	ipe_digest_audit(ab, d);
> +}
> +#else
> +static void audit_fsv_digest(struct audit_buffer *ab, const void *d)
> +{
> +}
> +#endif /* CONFIG_IPE_PROP_DM_VERITY */
> +
>  /**
>   * audit_rule - audit an IPE policy rule approximation.
>   * @ab: Supplies a poniter to the audit_buffer to append to.
> @@ -79,6 +100,8 @@ static void audit_rule(struct audit_buffer *ab, const struct ipe_rule *r)
>  		audit_log_format(ab, "%s", audit_prop_names[ptr->type]);
>  		if (ptr->type == ipe_prop_dmv_roothash)
>  			audit_dmv_roothash(ab, ptr->value);
> +		if (ptr->type == ipe_prop_fsv_digest)
> +			audit_fsv_digest(ab, ptr->value);
>  
>  		audit_log_format(ab, " ");
>  	}
> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> index 538af4195ba7..210d3926c0a8 100644
> --- a/security/ipe/eval.c
> +++ b/security/ipe/eval.c
> @@ -81,6 +81,23 @@ static void build_ipe_bdev_ctx(struct ipe_eval_ctx *ctx, const struct inode *con
>  }
>  #endif /* CONFIG_IPE_PROP_DM_VERITY */
>  
> +#ifdef CONFIG_IPE_PROP_FS_VERITY
> +/**
> + * build_ipe_inode_ctx - Build inode fields of an evaluation context.
> + * @ctx: Supplies a pointer to the context to be populdated.
> + * @ino: Supplies the inode struct of the file triggered IPE event.
> + */
> +static void build_ipe_inode_ctx(struct ipe_eval_ctx *ctx, const struct inode *const ino)
> +{
> +	ctx->ino = ino;
> +	ctx->ipe_inode = ipe_inode(ctx->ino);
> +}
> +#else
> +static void build_ipe_inode_ctx(struct ipe_eval_ctx *ctx, const struct inode *const ino)
> +{
> +}
> +#endif /* CONFIG_IPE_PROP_FS_VERITY */
> +
>  /**
>   * build_eval_ctx - Build an evaluation context.
>   * @ctx: Supplies a pointer to the context to be populdated.
> @@ -99,6 +116,7 @@ void build_eval_ctx(struct ipe_eval_ctx *ctx,
>  	if (file) {
>  		ino = d_real_inode(file->f_path.dentry);
>  		build_ipe_bdev_ctx(ctx, ino);
> +		build_ipe_inode_ctx(ctx, ino);
>  	}
>  }
>  
> @@ -171,6 +189,91 @@ static bool evaluate_dmv_sig_true(const struct ipe_eval_ctx *const ctx,
>  }
>  #endif /* CONFIG_IPE_PROP_DM_VERITY */
>  
> +#ifdef CONFIG_IPE_PROP_FS_VERITY
> +/**
> + * evaluate_fsv_digest - Analyze @ctx against a fsv digest property.
> + * @ctx: Supplies a pointer to the context being evaluated.
> + * @p: Supplies a pointer to the property being evaluated.
> + *
> + * Return:
> + * * true	- The current @ctx match the @p
> + * * false	- The current @ctx doesn't match the @p
> + */
> +static bool evaluate_fsv_digest(const struct ipe_eval_ctx *const ctx,
> +				struct ipe_prop *p)
> +{
> +	enum hash_algo alg;
> +	u8 digest[FS_VERITY_MAX_DIGEST_SIZE];
> +
> +	if (!ctx->ino)
> +		return false;
> +	if (fsverity_get_digest((struct inode *)ctx->ino,
> +				digest,
> +				&alg)) {
> +		return false;
> +	}
> +
> +	return ipe_digest_eval(p->value,
> +			       digest,
> +			       hash_digest_size[alg],
> +			       hash_algo_name[alg]);
> +}
> +
> +/**
> + * evaluate_fsv_sig_false - Analyze @ctx against a fsv sig false property.
> + * @ctx: Supplies a pointer to the context being evaluated.
> + * @p: Supplies a pointer to the property being evaluated.
> + *
> + * Return:
> + * * true	- The current @ctx match the @p
> + * * false	- The current @ctx doesn't match the @p
> + */
> +static bool evaluate_fsv_sig_false(const struct ipe_eval_ctx *const ctx,
> +				   struct ipe_prop *p)
> +{
> +	return !ctx->ino ||
> +	       !IS_VERITY(ctx->ino) ||
> +	       !ctx->ipe_inode ||
> +	       !ctx->ipe_inode->fs_verity_signed;
> +}
> +
> +/**
> + * evaluate_fsv_sig_true - Analyze @ctx against a fsv sig true property.
> + * @ctx: Supplies a pointer to the context being evaluated.
> + * @p: Supplies a pointer to the property being evaluated.
> + *
> + * Return:
> + * * true - The current @ctx match the @p
> + * * false - The current @ctx doesn't match the @p
> + */
> +static bool evaluate_fsv_sig_true(const struct ipe_eval_ctx *const ctx,
> +				  struct ipe_prop *p)
> +{
> +	return ctx->ino &&
> +	       IS_VERITY(ctx->ino) &&
> +	       ctx->ipe_inode &&
> +	       ctx->ipe_inode->fs_verity_signed;
> +}

Isn't better to just define one function and prepend a ! in
evaluate_property()?

Not sure about the usefulness of the fsverity_signature= property as it
is. I would at minimum allow to specify which keyring signatures are
verified against, and ensure that the keyring has a restriction.

And maybe I would call fsverity_verify_signature() directly, after
extending it to pass the desired keyring.

I would also split this patch in two, one for fsverity_digest= and one
for fsverity_signature=.

Roberto

> +#else
> +static bool evaluate_fsv_digest(const struct ipe_eval_ctx *const ctx,
> +				struct ipe_prop *p)
> +{
> +	return false;
> +}
> +
> +static bool evaluate_fsv_sig_false(const struct ipe_eval_ctx *const ctx,
> +				   struct ipe_prop *p)
> +{
> +	return false;
> +}
> +
> +static bool evaluate_fsv_sig_true(const struct ipe_eval_ctx *const ctx,
> +				  struct ipe_prop *p)
> +{
> +	return false;
> +}
> +#endif /* CONFIG_IPE_PROP_FS_VERITY */
> +
>  /**
>   * evaluate_property - Analyze @ctx against a property.
>   * @ctx: Supplies a pointer to the context to be evaluated.
> @@ -201,6 +304,15 @@ static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
>  	case ipe_prop_dmv_sig_true:
>  		eval = evaluate_dmv_sig_true(ctx, p);
>  		break;
> +	case ipe_prop_fsv_digest:
> +		eval = evaluate_fsv_digest(ctx, p);
> +		break;
> +	case ipe_prop_fsv_sig_false:
> +		eval = evaluate_fsv_sig_false(ctx, p);
> +		break;
> +	case ipe_prop_fsv_sig_true:
> +		eval = evaluate_fsv_sig_true(ctx, p);
> +		break;
>  	default:
>  		eval = false;
>  	}
> diff --git a/security/ipe/eval.h b/security/ipe/eval.h
> index 4fd832c6893e..d3dce4f04cb4 100644
> --- a/security/ipe/eval.h
> +++ b/security/ipe/eval.h
> @@ -26,6 +26,12 @@ struct ipe_bdev {
>  };
>  #endif /* CONFIG_IPE_PROP_DM_VERITY */
>  
> +#ifdef CONFIG_IPE_PROP_FS_VERITY
> +struct ipe_inode {
> +	bool fs_verity_signed;
> +};
> +#endif /* CONFIG_IPE_PROP_FS_VERITY */
> +
>  struct ipe_eval_ctx {
>  	enum ipe_op_type op;
>  
> @@ -34,6 +40,10 @@ struct ipe_eval_ctx {
>  #ifdef CONFIG_IPE_PROP_DM_VERITY
>  	const struct ipe_bdev *ipe_bdev;
>  #endif /* CONFIG_IPE_PROP_DM_VERITY */
> +#ifdef CONFIG_IPE_PROP_FS_VERITY
> +	const struct inode *ino;
> +	const struct ipe_inode *ipe_inode;
> +#endif /* CONFIG_IPE_PROP_FS_VERITY */
>  };
>  
>  enum ipe_match {
> diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
> index 735375d2f858..836f08240372 100644
> --- a/security/ipe/hooks.c
> +++ b/security/ipe/hooks.c
> @@ -243,3 +243,33 @@ int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
>  	return -EOPNOTSUPP;
>  }
>  #endif /* CONFIG_IPE_PROP_DM_VERITY */
> +
> +#ifdef CONFIG_IPE_PROP_FS_VERITY
> +/**
> + * ipe_inode_setsecurity - Sets fields of a inode security blob from @key.
> + * @inode: The inode to source the security blob from.
> + * @name: The name representing the information to be stored.
> + * @value: The value to be stored.
> + * @size: The size of @value.
> + * @flags: unused
> + *
> + * Saves fsverity signature & digest into inode security blob
> + *
> + * Return:
> + * * 0	- OK
> + * * !0	- Error
> + */
> +int ipe_inode_setsecurity(struct inode *inode, const char *name,
> +			  const void *value, size_t size,
> +			  int flags)
> +{
> +	struct ipe_inode *inode_sec = ipe_inode(inode);
> +
> +	if (!strcmp(name, FS_VERITY_INODE_SEC_NAME)) {
> +		inode_sec->fs_verity_signed = size > 0 && value;
> +		return 0;
> +	}
> +
> +	return -EOPNOTSUPP;
> +}
> +#endif /* CONFIG_CONFIG_IPE_PROP_FS_VERITY */
> diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
> index 16611a149158..654aba584a44 100644
> --- a/security/ipe/hooks.h
> +++ b/security/ipe/hooks.h
> @@ -8,6 +8,7 @@
>  #include <linux/fs.h>
>  #include <linux/binfmts.h>
>  #include <linux/security.h>
> +#include <linux/fsverity.h>
>  #include <linux/device-mapper.h>
>  
>  void ipe_sb_free_security(struct super_block *mnt_sb);
> @@ -32,4 +33,10 @@ int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
>  			 const void *value, size_t len);
>  #endif /* CONFIG_IPE_PROP_DM_VERITY */
>  
> +#ifdef CONFIG_IPE_PROP_FS_VERITY
> +int ipe_inode_setsecurity(struct inode *inode, const char *name,
> +			  const void *value, size_t size,
> +			  int flags);
> +#endif /* CONFIG_IPE_PROP_FS_VERITY */
> +
>  #endif /* IPE_HOOKS_H */
> diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
> index 5612cb3cf1e5..705ce9a003de 100644
> --- a/security/ipe/ipe.c
> +++ b/security/ipe/ipe.c
> @@ -13,6 +13,9 @@ static struct lsm_blob_sizes ipe_blobs __lsm_ro_after_init = {
>  #ifdef CONFIG_IPE_PROP_DM_VERITY
>  		.lbs_bdev = sizeof(struct ipe_bdev),
>  #endif /* CONFIG_IPE_PROP_DM_VERITY */
> +#ifdef CONFIG_IPE_PROP_FS_VERITY
> +		.lbs_inode = sizeof(struct ipe_inode),
> +#endif /* CONFIG_IPE_PROP_FS_VERITY */
>  };
>  
>  #ifdef CONFIG_IPE_PROP_DM_VERITY
> @@ -22,6 +25,13 @@ struct ipe_bdev *ipe_bdev(struct block_device *b)
>  }
>  #endif /* CONFIG_IPE_PROP_DM_VERITY */
>  
> +#ifdef CONFIG_IPE_PROP_FS_VERITY
> +struct ipe_inode *ipe_inode(const struct inode *inode)
> +{
> +	return inode->i_security + ipe_blobs.lbs_inode;
> +}
> +#endif /* CONFIG_IPE_PROP_FS_VERITY */
> +
>  static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
>  	LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
>  	LSM_HOOK_INIT(bprm_check_security, ipe_bprm_check_security),
> @@ -33,6 +43,9 @@ static struct security_hook_list ipe_hooks[] __lsm_ro_after_init = {
>  	LSM_HOOK_INIT(bdev_free_security, ipe_bdev_free_security),
>  	LSM_HOOK_INIT(bdev_setsecurity, ipe_bdev_setsecurity),
>  #endif
> +#ifdef CONFIG_IPE_PROP_FS_VERITY
> +	LSM_HOOK_INIT(inode_setsecurity, ipe_inode_setsecurity),
> +#endif /* CONFIG_IPE_PROP_FS_VERITY */
>  };
>  
>  /**
> diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
> index c2594a45b8f2..138fda645ecf 100644
> --- a/security/ipe/ipe.h
> +++ b/security/ipe/ipe.h
> @@ -15,5 +15,8 @@ extern bool ipe_enabled;
>  #ifdef CONFIG_IPE_PROP_DM_VERITY
>  struct ipe_bdev *ipe_bdev(struct block_device *b);
>  #endif /* CONFIG_IPE_PROP_DM_VERITY */
> +#ifdef CONFIG_IPE_PROP_FS_VERITY
> +struct ipe_inode *ipe_inode(const struct inode *inode);
> +#endif /* CONFIG_IPE_PROP_FS_VERITY */
>  
>  #endif /* IPE_H */
> diff --git a/security/ipe/policy.h b/security/ipe/policy.h
> index 324eb76c6067..50b8f4c49bc7 100644
> --- a/security/ipe/policy.h
> +++ b/security/ipe/policy.h
> @@ -31,6 +31,9 @@ enum ipe_prop_type {
>  	ipe_prop_dmv_roothash,
>  	ipe_prop_dmv_sig_false,
>  	ipe_prop_dmv_sig_true,
> +	ipe_prop_fsv_digest,
> +	ipe_prop_fsv_sig_false,
> +	ipe_prop_fsv_sig_true,
>  	ipe_prop_max
>  };
>  
> diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
> index 50a6a763e842..799ee7fda974 100644
> --- a/security/ipe/policy_parser.c
> +++ b/security/ipe/policy_parser.c
> @@ -273,6 +273,11 @@ static const match_table_t property_tokens = {
>  	{ipe_prop_dmv_sig_false,	"dmverity_signature=FALSE"},
>  	{ipe_prop_dmv_sig_true,		"dmverity_signature=TRUE"},
>  #endif /* CONFIG_IPE_PROP_DM_VERITY */
> +#ifdef CONFIG_IPE_PROP_FS_VERITY
> +	{ipe_prop_fsv_digest,		"fsverity_digest=%s"},
> +	{ipe_prop_fsv_sig_false,	"fsverity_signature=FALSE"},
> +	{ipe_prop_fsv_sig_true,		"fsverity_signature=TRUE"},
> +#endif /* CONFIG_IPE_PROP_FS_VERITY */
>  	{ipe_prop_max,			NULL}
>  };
>  
> @@ -304,6 +309,7 @@ int parse_property(char *t, struct ipe_rule *r)
>  
>  	switch (token) {
>  	case ipe_prop_dmv_roothash:
> +	case ipe_prop_fsv_digest:
>  		dup = match_strdup(&args[0]);
>  		if (!dup) {
>  			rc = -ENOMEM;
> @@ -315,6 +321,8 @@ int parse_property(char *t, struct ipe_rule *r)
>  	case ipe_prop_boot_verified_true:
>  	case ipe_prop_dmv_sig_false:
>  	case ipe_prop_dmv_sig_true:
> +	case ipe_prop_fsv_sig_false:
> +	case ipe_prop_fsv_sig_true:
>  		p->type = token;
>  		break;
>  	case ipe_prop_max:

