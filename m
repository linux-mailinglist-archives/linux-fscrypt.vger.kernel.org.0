Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC7D67DFC7D
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Nov 2023 23:40:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234638AbjKBWkx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Nov 2023 18:40:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234752AbjKBWkv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Nov 2023 18:40:51 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D041519D;
        Thu,  2 Nov 2023 15:40:45 -0700 (PDT)
Received: from [10.137.106.151] (unknown [131.107.159.23])
        by linux.microsoft.com (Postfix) with ESMTPSA id EC72A20B74C0;
        Thu,  2 Nov 2023 15:40:44 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com EC72A20B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1698964845;
        bh=Tpi7d61woAHCsETT1wQdN/nd1eB0jEwpOpE522d45fA=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qTtOPVQiv0mrH1aShUW4Whtbdh/traifRf2kZ+oShm9ThBMi86/qZtbZy4ryzQ/FA
         3w4VTazf8oWkwia+tvX9eS6/xuWFab7jK1G1MCl1kTZW3L+I7UHOVyiisndhsK4ZEb
         Y8XC/x8ACWhdS2R0lfkmTnljtvDoQ1+9+AEsRj3o=
Message-ID: <60ab9d6a-6814-4612-9dc4-1b83f44336fe@linux.microsoft.com>
Date:   Thu, 2 Nov 2023 15:40:44 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v11 14/19] ipe: add support for dm-verity as a trust
 provider
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>, corbet@lwn.net,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk,
        agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
References: <1696457386-3010-15-git-send-email-wufan@linux.microsoft.com>
 <a864ebd8815e2e5822a61178e8a3da2c.paul@paul-moore.com>
From:   Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <a864ebd8815e2e5822a61178e8a3da2c.paul@paul-moore.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 10/23/2023 8:52 PM, Paul Moore wrote:
> On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
>>
>> Allows author of IPE policy to indicate trust for a singular dm-verity
>> volume, identified by roothash, through "dmverity_roothash" and all
>> signed dm-verity volumes, through "dmverity_signature".
>>
>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
>> ---
...
>>   security/ipe/Kconfig         |  18 +++++
>>   security/ipe/Makefile        |   1 +
>>   security/ipe/audit.c         |  31 +++++++-
>>   security/ipe/digest.c        | 142 +++++++++++++++++++++++++++++++++++
>>   security/ipe/digest.h        |  26 +++++++
>>   security/ipe/eval.c          | 101 ++++++++++++++++++++++++-
>>   security/ipe/eval.h          |  13 ++++
>>   security/ipe/hooks.c         |  51 +++++++++++++
>>   security/ipe/hooks.h         |   8 ++
>>   security/ipe/ipe.c           |  15 ++++
>>   security/ipe/ipe.h           |   4 +
>>   security/ipe/policy.h        |   3 +
>>   security/ipe/policy_parser.c |  24 +++++-
>>   13 files changed, 433 insertions(+), 4 deletions(-)
>>   create mode 100644 security/ipe/digest.c
>>   create mode 100644 security/ipe/digest.h
> 
> ...
> 
>> diff --git a/security/ipe/audit.c b/security/ipe/audit.c
>> index 0dd5f10c318f..b5c58655ac74 100644
>> --- a/security/ipe/audit.c
>> +++ b/security/ipe/audit.c
>> @@ -13,6 +13,7 @@
>>   #include "hooks.h"
>>   #include "policy.h"
>>   #include "audit.h"
>> +#include "digest.h"
>>   
>>   #define ACTSTR(x) ((x) == IPE_ACTION_ALLOW ? "ALLOW" : "DENY")
>>   
>> @@ -40,8 +41,29 @@ static const char *const audit_op_names[__IPE_OP_MAX] = {
>>   static const char *const audit_prop_names[__IPE_PROP_MAX] = {
>>   	"boot_verified=FALSE",
>>   	"boot_verified=TRUE",
>> +#ifdef CONFIG_IPE_PROP_DM_VERITY
>> +	"dmverity_roothash=",
>> +	"dmverity_signature=FALSE",
>> +	"dmverity_signature=TRUE",
>> +#endif /* CONFIG_IPE_PROP_DM_VERITY */
>>   };
>>   
>> +#ifdef CONFIG_IPE_PROP_DM_VERITY
>> +/**
>> + * audit_dmv_roothash - audit a roothash of a dmverity volume.
>> + * @ab: Supplies a pointer to the audit_buffer to append to.
>> + * @r: Supplies a pointer to the digest structure.
>> + */
>> +static void audit_dmv_roothash(struct audit_buffer *ab, const void *rh)
>> +{
>> +	ipe_digest_audit(ab, rh);
>> +}
>> +#else
>> +static void audit_dmv_roothash(struct audit_buffer *ab, const void *rh)
>> +{
>> +}
>> +#endif /* CONFIG_IPE_PROP_DM_VERITY */
> 
> Since the "dmverity_roothash=" field name is going to be written to
> the audit record regardless of CONFIG_IPE_PROP_DM_VERITY we should
> ensure that it has a value of "?" instead of nothing.  To fix that
> I would suggest something like this:
> 
>    #else
>    static void audit_dmv_roothash(struct audit_buffer *ab, const void *rh)
>    {
>      audit_log_format(ab, "?");
>    }
>    #endif /* CONFIG_IPE_PROP_DM_VERITY */
> 
>>   /**
>>    * audit_rule - audit an IPE policy rule approximation.
>>    * @ab: Supplies a pointer to the audit_buffer to append to.
>> @@ -53,8 +75,13 @@ static void audit_rule(struct audit_buffer *ab, const struct ipe_rule *r)
>>   
>>   	audit_log_format(ab, "rule=\"op=%s ", audit_op_names[r->op]);
>>   
>> -	list_for_each_entry(ptr, &r->props, next)
>> -		audit_log_format(ab, "%s ", audit_prop_names[ptr->type]);
>> +	list_for_each_entry(ptr, &r->props, next) {
>> +		audit_log_format(ab, "%s", audit_prop_names[ptr->type]);
>> +		if (ptr->type == IPE_PROP_DMV_ROOTHASH)
>> +			audit_dmv_roothash(ab, ptr->value);
> 
> If you wanted to avoid the roothash change above, you could change the
> code here so it didn't always write "dmverity_roothash=" into the audit
> record.
> 
Yes this sounds more reasonable to me, I will change this part to a 
switch case statement to avoid unnessary logging.

>> +		audit_log_format(ab, " ");
>> +	}
>>   
>>   	audit_log_format(ab, "action=%s\"", ACTSTR(r->action));
>>   }
>> diff --git a/security/ipe/digest.c b/security/ipe/digest.c
>> new file mode 100644
>> index 000000000000..7a42ca71880c
>> --- /dev/null
>> +++ b/security/ipe/digest.c
>> @@ -0,0 +1,142 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) Microsoft Corporation. All rights reserved.
>> + */
>> +
>> +#include "digest.h"
>> +
>> +/**
>> + * ipe_digest_parse - parse a digest in IPE's policy.
>> + * @valstr: Supplies the string parsed from the policy.
>> + * @value: Supplies a pointer to be populated with the result.
>> + *
>> + * Digests in IPE are defined in a standard way:
>> + *	<alg_name>:<hex>
>> + *
>> + * Use this function to create a property to parse the digest
>> + * consistently. The parsed digest will be saved in @value in IPE's
>> + * policy.
>> + *
>> + * Return:
>> + * * 0	- OK
>> + * * !0	- Error
>> + */
>> +int ipe_digest_parse(const char *valstr, void **value)
> 
> Why is @value void?  You should make it a digest_info type or simply
> skip the second parameter and return a digest_info pointer.
>
Yes it should better just return a digest_info type pointer. I will 
update this part.

>> +{
>> +	char *sep, *raw_digest;
>> +	size_t raw_digest_len;
>> +	int rc = 0;
>> +	u8 *digest = NULL;
>> +	struct digest_info *info = NULL;
>> +
>> +	info = kzalloc(sizeof(*info), GFP_KERNEL);
>> +	if (!info)
>> +		return -ENOMEM;
>> +
>> +	sep = strchr(valstr, ':');
>> +	if (!sep) {
>> +		rc = -EBADMSG;
>> +		goto err;
>> +	}
>> +
>> +	info->alg = kstrndup(valstr, sep - valstr, GFP_KERNEL);
>> +	if (!info->alg) {
>> +		rc = -ENOMEM;
>> +		goto err;
>> +	}
>> +
>> +	raw_digest = sep + 1;
>> +	raw_digest_len = strlen(raw_digest);
>> +	info->raw_digest = kstrndup(raw_digest, raw_digest_len, GFP_KERNEL);
> 
> Since you're running a strlen() over @raw_digest, you might as well
> just use kstrdup() instead of kstrndup().
>
Thanks I will update this part.

>> +	if (!info->raw_digest) {
>> +		rc = -ENOMEM;
>> +		goto err_free_alg;
>> +	}
>> +
>> +	info->digest_len = (raw_digest_len + 1) / 2;
>> +	digest = kzalloc(info->digest_len, GFP_KERNEL);
>> +	if (!digest) {
>> +		rc = -ENOMEM;
>> +		goto err_free_raw;
>> +	}
>> +
>> +	rc = hex2bin(digest, raw_digest, info->digest_len);
>> +	if (rc < 0) {
>> +		rc = -EINVAL;
>> +		goto err_free_raw;
>> +	}
>> +
>> +	info->digest = digest;
>> +	*value = info;
>> +	return 0;
>> +
>> +err_free_raw:
>> +	kfree(info->raw_digest);
>> +err_free_alg:
>> +	kfree(info->alg);
>> +err:
>> +	kfree(digest);
>> +	kfree(info);
>> +	return rc;
>> +}
>> +
>> +/**
>> + * ipe_digest_eval - evaluate an IPE digest against another digest.
>> + * @expect: Supplies the policy-provided digest value.
>> + * @digest: Supplies the digest to compare against the policy digest value.
>> + * @digest_len: The length of @digest.
>> + * @alg: Supplies the name of the algorithm used to calculated @digest.
>> + *
>> + * Return:
>> + * * true	- digests match
>> + * * false	- digests do not match
>> + */
>> +bool ipe_digest_eval(const void *expect, const u8 *digest, size_t digest_len,
>> +		     const char *alg)
> 
> Similar to the above, why not make the @expect parameter a digest_info
> type?  Also, why not pass a second digest_info parameter instead of
> a separate @digest, @digest_len, and @alg?
> 
The digest_info was inteneded to be used for policy only, which also 
contains a raw string of digest in the policy that can be used during 
audit. After second thought I start to think the raw_digest seems 
unnecessary and I can refactor them all to use digest_info instead.

>> +{
>> +	const struct digest_info *info = (struct digest_info *)expect;
>> +
>> +	return (digest_len == info->digest_len) && !strcmp(alg, info->alg) &&
>> +	       (!memcmp(info->digest, digest, info->digest_len));
>> +}
>> +
>> +/**
>> + * ipe_digest_free - free an IPE digest.
>> + * @value: Supplies a pointer the policy-provided digest value to free.
>> + */
>> +void ipe_digest_free(void **value)
> 
> Another digest_info parameter/type issue.
> 
>> +{
>> +	struct digest_info *info = (struct digest_info *)(*value);
>> +
>> +	if (IS_ERR_OR_NULL(info))
>> +		return;
>> +
>> +	kfree(info->alg);
>> +	kfree(info->raw_digest);
>> +	kfree(info->digest);
>> +	kfree(info);
>> +}
>> +
>> +/**
>> + * ipe_digest_audit - audit a digest that was sourced from IPE's policy.
>> + * @ab: Supplies the audit_buffer to append the formatted result.
>> + * @val: Supplies a pointer to source the audit record from.
>> + *
>> + * Digests in IPE are defined in a standard way:
>> + *	<alg_name>:<hex>
>> + *
>> + * Use this function to create a property to audit the digest
>> + * consistently.
>> + *
>> + * Return:
>> + * 0 - OK
>> + * !0 - Error
>> + */
>> +void ipe_digest_audit(struct audit_buffer *ab, const void *val)
> 
> Another digest_info parameter/type issue.
> 
>> +{
>> +	const struct digest_info *info = (struct digest_info *)val;
>> +
>> +	audit_log_untrustedstring(ab, info->alg);
>> +	audit_log_format(ab, ":");
>> +	audit_log_untrustedstring(ab, info->raw_digest);
>> +}
> 
> ...
> 
>> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
>> index 78c54ff1fdd3..82ad48d7aa3d 100644
>> --- a/security/ipe/eval.c
>> +++ b/security/ipe/eval.c
>> @@ -69,15 +88,89 @@ void build_eval_ctx(struct ipe_eval_ctx *ctx,
>>   		    const struct file *file,
>>   		    enum ipe_op_type op)
>>   {
>> +	struct inode *ino = NULL;
>> +
>>   	if (op == IPE_OP_EXEC && file)
>>   		pin_sb(FILE_SUPERBLOCK(file));
>>   
>>   	ctx->file = file;
>>   	ctx->op = op;
>>   
>> -	if (file)
>> +	if (file) {
>>   		ctx->from_init_sb = from_pinned(FILE_SUPERBLOCK(file));
>> +		ino = d_real_inode(file->f_path.dentry);
>> +		build_ipe_bdev_ctx(ctx, ino);
> 
> You don't need @ino.
> 
>    build_ipe_bdev_ctx(ctx, d_real_inode(file->f_path.dentry));
> 
This variable will make sense in the fsverity patch, I do agree it 
doesn't make sense for this one. Will remove it.

>> +	}
>> +}
>> +
>> +#ifdef CONFIG_IPE_PROP_DM_VERITY
>> +/**
>> + * evaluate_dmv_roothash - Evaluate @ctx against a dmv roothash property.
>> + * @ctx: Supplies a pointer to the context being evaluated.
>> + * @p: Supplies a pointer to the property being evaluated.
>> + *
>> + * Return:
>> + * * true	- The current @ctx match the @p
>> + * * false	- The current @ctx doesn't match the @p
>> + */
>> +static bool evaluate_dmv_roothash(const struct ipe_eval_ctx *const ctx,
>> +				  struct ipe_prop *p)
>> +{
>> +	return !!ctx->ipe_bdev &&
>> +	       ipe_digest_eval(p->value,
>> +			       ctx->ipe_bdev->digest,
>> +			       ctx->ipe_bdev->digest_len,
>> +			       ctx->ipe_bdev->digest_algo);
> 
> Building on my comments above in ipe_digest_eval(), if you convert it
> to use digest_info structs this is simplified:
> 
>    ipe_digest_eval(p->vlaue, ctx->ipe_bdev)
> 
Yep but the seucrity blob also contains signature information. I will 
make it like ipe_digest_eval(p->vlaue, ctx->ipe_bdev->dmv_digest_info)

>> +}
>> +
>> +/**
>> + * evaluate_dmv_sig_false: Analyze @ctx against a dmv sig false property.
>> + * @ctx: Supplies a pointer to the context being evaluated.
>> + * @p: Supplies a pointer to the property being evaluated.
>> + *
>> + * Return:
>> + * * true	- The current @ctx match the @p
>> + * * false	- The current @ctx doesn't match the @p
>> + */
>> +static bool evaluate_dmv_sig_false(const struct ipe_eval_ctx *const ctx,
>> +				   struct ipe_prop *p)
>> +{
>> +	return !ctx->ipe_bdev || (!ctx->ipe_bdev->dm_verity_signed);
>> +}
>> +
>> +/**
>> + * evaluate_dmv_sig_true: Analyze @ctx against a dmv sig true property.
>> + * @ctx: Supplies a pointer to the context being evaluated.
>> + * @p: Supplies a pointer to the property being evaluated.
>> + *
>> + * Return:
>> + * * true	- The current @ctx match the @p
>> + * * false	- The current @ctx doesn't match the @p
>> + */
>> +static bool evaluate_dmv_sig_true(const struct ipe_eval_ctx *const ctx,
>> +				  struct ipe_prop *p)
>> +{
>> +	return ctx->ipe_bdev && (!!ctx->ipe_bdev->dm_verity_signed);
>> +}
> 
> Do you need both evaluate_dmv_sig_true() and evaluate_dmv_sig_false()?
> If yes, you should make one call the other and return the inverse to
> help ensure there are no oddities.
>
Yes this code is redundant. I also found the ipe_prop *p variable is 
necssary. Will clean them up in the next version.

>> diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
>> index e9386762a597..8b8031e66f36 100644
>> --- a/security/ipe/hooks.c
>> +++ b/security/ipe/hooks.c
>> @@ -193,3 +196,51 @@ void ipe_sb_free_security(struct super_block *mnt_sb)
>>   {
>>   	ipe_invalidate_pinned_sb(mnt_sb);
>>   }
>> +
>> +#ifdef CONFIG_IPE_PROP_DM_VERITY
>> +/**
>> + * ipe_bdev_free_security - free IPE's LSM blob of block_devices.
>> + * @bdev: Supplies a pointer to a block_device that contains the structure
>> + *	  to free.
>> + */
>> +void ipe_bdev_free_security(struct block_device *bdev)
>> +{
>> +	struct ipe_bdev *blob = ipe_bdev(bdev);
>> +
>> +	kfree(blob->digest);
>> +	kfree(blob->digest_algo);
>> +}
>> +
>> +/**
>> + * ipe_bdev_setsecurity - save data from a bdev to IPE's LSM blob.
>> + * @bdev: Supplies a pointer to a block_device that contains the LSM blob.
>> + * @key: Supplies the string key that uniquely identifies the value.
>> + * @value: Supplies the value to store.
>> + * @len: The length of @value.
>> + */
>> +int ipe_bdev_setsecurity(struct block_device *bdev, const char *key,
>> +			 const void *value, size_t len)
>> +{
>> +	struct ipe_bdev *blob = ipe_bdev(bdev);
>> +
>> +	if (!strcmp(key, DM_VERITY_ROOTHASH_SEC_NAME)) {
>> +		const struct dm_verity_digest *digest = value;
>> +
>> +		blob->digest = kmemdup(digest->digest, digest->digest_len, GFP_KERNEL);
>> +		if (!blob->digest)
>> +			return -ENOMEM;
>> +
>> +		blob->digest_algo = kstrdup_const(digest->algo, GFP_KERNEL);
>> +		if (!blob->digest_algo)
>> +			return -ENOMEM;
> 
> You need to cleanup @blob on error so you don't leak ipe_bdev::digest.
>
Thanks for catching that. I will fix this.

-Fan
>> +		blob->digest_len = digest->digest_len;
>> +		return 0;
>> +	} else if (!strcmp(key, DM_VERITY_SIGNATURE_SEC_NAME)) {
>> +		blob->dm_verity_signed = true;
>> +		return 0;
>> +	}
>> +
>> +	return -EOPNOTSUPP;
>> +}
>> +#endif /* CONFIG_IPE_PROP_DM_VERITY */
> 
> --
> paul-moore.com
