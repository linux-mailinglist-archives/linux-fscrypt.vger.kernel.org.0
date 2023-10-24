Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A62EB7D4675
	for <lists+linux-fscrypt@lfdr.de>; Tue, 24 Oct 2023 05:53:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232251AbjJXDxt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 23 Oct 2023 23:53:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54176 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232448AbjJXDxD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 23 Oct 2023 23:53:03 -0400
Received: from mail-qk1-x72c.google.com (mail-qk1-x72c.google.com [IPv6:2607:f8b0:4864:20::72c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 136E310F4
        for <linux-fscrypt@vger.kernel.org>; Mon, 23 Oct 2023 20:52:36 -0700 (PDT)
Received: by mail-qk1-x72c.google.com with SMTP id af79cd13be357-7788fb06997so282735385a.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 23 Oct 2023 20:52:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1698119555; x=1698724355; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=55ZRJ15k5rlJjmFui052IxveaRjJKA9VJGl0uzNotB8=;
        b=NOsjfUsiwJ6iZkl1CzbXPwvgzAEyZ3ahiAQdcJtdRzTg1KxCLIflQ32IHGJXELMhe5
         XYZf6o62nBC47jGKfMuZhXz0tFU239x9gsK2mBXcfdav0bjk+8I5c+GYS1hYNieD0Cz+
         zpatyfzG0HJIRkkMc+BJAPtiG0N+2G1oWAnQ33ujxNuvs5QGupUEirFdGtFE7zJA5nwa
         fxgjJsU9y5d9HAAcnGSWHyjdv4A2FAqwC+h5Hz2z7gIG80oeDnprAdkDTZpl1pgEufGj
         cjObeC16eeFfiC6/mXIaWl1BUmjoVswgU5kOFiAANUcwpw2JSTd5cEGjqU1IXitMBtVS
         tNEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698119555; x=1698724355;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=55ZRJ15k5rlJjmFui052IxveaRjJKA9VJGl0uzNotB8=;
        b=BzComi/GO1y7bMeyesVhj3jFdsE56yaXZ35xcfWyHzdV3US1Fev9vt69iRpVeY+PT1
         NF9y2lvCasiy4d/1p8Vk98xWcDzQqK4Y6uewaZ0cQTE38co7MwG2GZ4SDPhteolIsaXH
         xYdWXm1a8l+jbH9cidP0cE+USzMhKujEbTXwGHUzJYQy5bt1vhKXUcTOv65ngNTsmf1p
         m3y8WanbDh65E+v/zG1YBwQHdGrKumCOlZ8xZ5JOPFjzwr5yM8J8kLW5q6kEHNtkDl6t
         mYFznVjqQDn6N3S95zhh7mNmgrfMoSoMoAjenMo7dBPxKWkwFgSV4Ts05/EHzh9n2j2d
         cMEA==
X-Gm-Message-State: AOJu0YxkzeqLYyuTIHiG/6epJdXkAg80CDYo51eFmnerY9Hn/mpY17as
        YszGkdJGd7kX6XhzsNHxp8S5
X-Google-Smtp-Source: AGHT+IFhehT5SBIN3u4k21hQKcqd9tt3cVRe5RSL6o1ZuOBt7dfMcEzUGFp3iEoi8dzbbuQJKBLFmg==
X-Received: by 2002:a05:6214:626:b0:66d:5dec:6099 with SMTP id a6-20020a056214062600b0066d5dec6099mr11383093qvx.41.1698119555528;
        Mon, 23 Oct 2023 20:52:35 -0700 (PDT)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id ee3-20020a0562140a4300b0065b260eafd9sm3357598qvb.87.2023.10.23.20.52.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 20:52:34 -0700 (PDT)
Date:   Mon, 23 Oct 2023 23:52:34 -0400
Message-ID: <c2a88a9292a6ce1e301ec2244657f385.paul@paul-moore.com>
From:   Paul Moore <paul@paul-moore.com>
To:     Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk,
        agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Fan Wu <wufan@linux.microsoft.com>,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [PATCH RFC v11 16/19] ipe: enable support for fs-verity as a trust  provider
References: <1696457386-3010-17-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-17-git-send-email-wufan@linux.microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
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
> 
> v10:
>   + Update the fsverity get digest call
> 
> v11:
>   + No changes
> ---
>  security/ipe/Kconfig         |  13 +++++
>  security/ipe/audit.c         |  23 ++++++++
>  security/ipe/eval.c          | 110 +++++++++++++++++++++++++++++++++++
>  security/ipe/eval.h          |  10 ++++
>  security/ipe/hooks.c         |  30 ++++++++++
>  security/ipe/hooks.h         |   7 +++
>  security/ipe/ipe.c           |  13 +++++
>  security/ipe/ipe.h           |   3 +
>  security/ipe/policy.h        |   3 +
>  security/ipe/policy_parser.c |   8 +++
>  10 files changed, 220 insertions(+)

...

> diff --git a/security/ipe/audit.c b/security/ipe/audit.c
> index b5c58655ac74..e3a8552a76a4 100644
> --- a/security/ipe/audit.c
> +++ b/security/ipe/audit.c
> @@ -79,6 +100,8 @@ static void audit_rule(struct audit_buffer *ab, const struct ipe_rule *r)
>  		audit_log_format(ab, "%s", audit_prop_names[ptr->type]);
>  		if (ptr->type == IPE_PROP_DMV_ROOTHASH)
>  			audit_dmv_roothash(ab, ptr->value);
> +		if (ptr->type == IPE_PROP_FSV_DIGEST)
> +			audit_fsv_digest(ab, ptr->value);

My comments on audit_dmv_roothash() also apply here.

>  		audit_log_format(ab, " ");
>  	}
> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> index 82ad48d7aa3d..f0194b0ca2ff 100644
> --- a/security/ipe/eval.c
> +++ b/security/ipe/eval.c
> @@ -172,6 +191,91 @@ static bool evaluate_dmv_sig_true(const struct ipe_eval_ctx *const ctx,
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
> +	if (!fsverity_get_digest((struct inode *)ctx->ino,
> +				 digest,
> +				 NULL,
> +				 &alg))
> +		return false;
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

See my previous comments about the false/true functions.

> +#else

--
paul-moore.com
