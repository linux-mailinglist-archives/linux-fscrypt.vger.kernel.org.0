Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E53167D462D
	for <lists+linux-fscrypt@lfdr.de>; Tue, 24 Oct 2023 05:52:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232229AbjJXDwf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 23 Oct 2023 23:52:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229510AbjJXDwa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 23 Oct 2023 23:52:30 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E39ED7D
        for <linux-fscrypt@vger.kernel.org>; Mon, 23 Oct 2023 20:52:26 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id 6a1803df08f44-66d190a8f87so25649716d6.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 23 Oct 2023 20:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1698119545; x=1698724345; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=pxmiAw9v0MVA3JaImbhJkd/ZdwTT2GQ+ukfNRy8bQak=;
        b=F3/vT25hmHA76WeDtuGfbPgSaAHSq/UEQQQWZOr1F7Z3nly0BylwsIcgJVh1r9wUEz
         CNdNa3twMJZ64Aow2/1mGEsTbfpuQaGnWpoPjUJJsbU+Op9n4EkXQgfZcj4q9uPNzE5X
         URUmcC113w1MHpjnIAwcfW5ZV6W0LdAT+C35BJzg6cFVhr8ifvciiPJruJDvmMM0NNvU
         QTXgaVCcyXy/qODEAQH/EbV9oxVOyhh1oYm+bFAxIgbvIK3Ub6Nkz8RXmWydrIzbw3G+
         LoRfb/6MTk3xtttBwtBLSHUapQizVCwWqQi4gD+U31h1TTua0ZnSeDnl/P7ggxOfpDmM
         6itg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698119545; x=1698724345;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=pxmiAw9v0MVA3JaImbhJkd/ZdwTT2GQ+ukfNRy8bQak=;
        b=eNAI3XPZn4wBjvFIEOFOEZ6eyqZGx0UKFwqzXeHPahelxBKNk//OdhsGZF5YJQKvd3
         BGJgqYymvGO7j8bAIY2iqQNBn4byYgnxBbP0XQvVFkaKP6F1ytneAWt0O28UvF2qvyeR
         rw7p86yQPTPFSDYS1harz57mU3++4INfupCz2XxGT51eulusIkCciGq2W32WqWi1vun5
         DBdmulrMwbNnDsp29xCwxgtUYHQZ+y9abh55S+MNVVMAz0fGYHONClOFq79QvjWNO0Gd
         KBXqmFP+JU1maqv4mXjkk3LT3bVv74ptEoZVbBw6s6ZaKELNO95OLocCiq7/fwRX1IwJ
         HQvw==
X-Gm-Message-State: AOJu0YznHMRheu/zi+YgJ2rQRhNzDJp6U8M38S97hSgsqbeOXsVYsWxh
        1vNFGhdrovTjObDDCHl9GhfP
X-Google-Smtp-Source: AGHT+IGtwY2oz/wgwv3J5Ra2yN8YlTA/mtD64ScMKcClxTGhlmWa8YZM7v6uqs3IwKjvRFLtsuevkA==
X-Received: by 2002:ad4:4ee1:0:b0:656:4a21:2c5a with SMTP id dv1-20020ad44ee1000000b006564a212c5amr15142920qvb.9.1698119545121;
        Mon, 23 Oct 2023 20:52:25 -0700 (PDT)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id ep5-20020a05621418e500b0065afedf3aabsm3342527qvb.48.2023.10.23.20.52.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 20:52:24 -0700 (PDT)
Date:   Mon, 23 Oct 2023 23:52:24 -0400
Message-ID: <46922873bd020f8cd443b7fca59ef802.paul@paul-moore.com>
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
        Deven Bowers <deven.desai@linux.microsoft.com>,
        Fan Wu <wufan@linux.microsoft.com>
Subject: Re: [PATCH RFC v11 4/19] ipe: add LSM hooks on execution and kernel  read
References: <1696457386-3010-5-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-5-git-send-email-wufan@linux.microsoft.com>
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
> IPE's initial goal is to control both execution and the loading of
> kernel modules based on the system's definition of trust. It
> accomplishes this by plugging into the security hooks for
> bprm_check_security, file_mprotect, mmap_file, kernel_load_data,
> and kernel_read_data.
> 
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v2:
>   + Split evaluation loop, access control hooks,
>     and evaluation loop from policy parser and userspace
>     interface to pass mailing list character limit
> 
> v3:
>   + Move ipe_load_properties to patch 04.
>   + Remove useless 0-initializations
>   + Prefix extern variables with ipe_
>   + Remove kernel module parameters, as these are
>     exposed through sysctls.
>   + Add more prose to the IPE base config option
>     help text.
>   + Use GFP_KERNEL for audit_log_start.
>   + Remove unnecessary caching system.
>   + Remove comments from headers
>   + Use rcu_access_pointer for rcu-pointer null check
>   + Remove usage of reqprot; use prot only.
>   + Move policy load and activation audit event to 03/12
> 
> v4:
>   + Remove sysctls in favor of securityfs nodes
>   + Re-add kernel module parameters, as these are now
>     exposed through securityfs.
>   + Refactor property audit loop to a separate function.
> 
> v5:
>   + fix minor grammatical errors
>   + do not group rule by curly-brace in audit record,
>     reconstruct the exact rule.
> 
> v6:
>   + No changes
> 
> v7:
>   + Further split lsm creation, the audit system, the evaluation loop
>     and access control hooks into separate commits.
> 
> v8:
>   + Rename hook functions to follow the lsmname_hook_name convention
>   + Remove ipe_hook enumeration, can be derived from correlation with
>     syscall audit record.
> 
> v9:
>   + Minor changes for adapting to the new parser
> 
> v10:
>   + Remove @reqprot part
> 
> v11:
>   + Fix code style issues
> ---
>  security/ipe/Makefile |   1 +
>  security/ipe/eval.c   |  14 ++++
>  security/ipe/eval.h   |   3 +
>  security/ipe/hooks.c  | 183 ++++++++++++++++++++++++++++++++++++++++++
>  security/ipe/hooks.h  |  25 ++++++
>  security/ipe/ipe.c    |   6 ++
>  6 files changed, 232 insertions(+)
>  create mode 100644 security/ipe/hooks.c
>  create mode 100644 security/ipe/hooks.h

...

> diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
> new file mode 100644
> index 000000000000..6164a9b53361
> --- /dev/null
> +++ b/security/ipe/hooks.c
> @@ -0,0 +1,183 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */

...

> +/**
> + * ipe_kernel_read_file - ipe security hook function for kernel read.
> + * @file: Supplies a pointer to the file structure being read in from disk.
> + * @id: Supplies the enumeration identifying the purpose of the read.
> + * @contents: Unused.
> + *
> + * This LSM hook is called when a file is being read in from disk from
> + * the kernel.
> + *
> + * Return:
> + * 0 - OK
> + * !0 - Error
> + */
> +int ipe_kernel_read_file(struct file *file, enum kernel_read_file_id id,
> +			 bool contents)
> +{
> +	enum ipe_op_type op;
> +	struct ipe_eval_ctx ctx = IPE_EVAL_CTX_INIT;
> +
> +	switch (id) {
> +	case READING_FIRMWARE:
> +		op = IPE_OP_FIRMWARE;
> +		break;
> +	case READING_MODULE:
> +		op = IPE_OP_KERNEL_MODULE;
> +		break;
> +	case READING_KEXEC_INITRAMFS:
> +		op = IPE_OP_KEXEC_INITRAMFS;
> +		break;
> +	case READING_KEXEC_IMAGE:
> +		op = IPE_OP_KEXEC_IMAGE;
> +		break;
> +	case READING_POLICY:
> +		op = IPE_OP_IMA_POLICY;
> +		break;
> +	case READING_X509_CERTIFICATE:
> +		op = IPE_OP_IMA_X509;
> +		break;
> +	default:
> +		op = IPE_OP_INVALID;
> +		WARN(op == IPE_OP_INVALID, "no rule setup for enum %d", id);

I'm not sure you need to test @op above since you set @op on the line
above, just use true/1 to simplify things.  It also seems like it
might be helpful to provice some context for the enum above in the
WARN() message.  For example:

  WARN(1, "no rule setup for kernel_read_file %d", id);

> +	}
> +
> +	build_eval_ctx(&ctx, file, op);
> +	return ipe_evaluate_event(&ctx);
> +}
> +
> +/**
> + * ipe_kernel_load_data - ipe security hook function for kernel load data.
> + * @id: Supplies the enumeration identifying the purpose of the read.
> + * @contents: Unused.
> + *
> + * This LSM hook is called when a buffer is being read in from disk.
> + *
> + * Return:
> + * * 0	- OK
> + * * !0	- Error
> + */
> +int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents)
> +{
> +	enum ipe_op_type op;
> +	struct ipe_eval_ctx ctx = IPE_EVAL_CTX_INIT;
> +
> +	switch (id) {
> +	case LOADING_FIRMWARE:
> +		op = IPE_OP_FIRMWARE;
> +		break;
> +	case LOADING_MODULE:
> +		op = IPE_OP_KERNEL_MODULE;
> +		break;
> +	case LOADING_KEXEC_INITRAMFS:
> +		op = IPE_OP_KEXEC_INITRAMFS;
> +		break;
> +	case LOADING_KEXEC_IMAGE:
> +		op = IPE_OP_KEXEC_IMAGE;
> +		break;
> +	case LOADING_POLICY:
> +		op = IPE_OP_IMA_POLICY;
> +		break;
> +	case LOADING_X509_CERTIFICATE:
> +		op = IPE_OP_IMA_X509;
> +		break;
> +	default:
> +		op = IPE_OP_INVALID;
> +		WARN(op == IPE_OP_INVALID, "no rule setup for enum %d", id);

See my comments in ipe_kernel_read_file(), they also apply here.

> +	}
> +
> +	build_eval_ctx(&ctx, NULL, op);
> +	return ipe_evaluate_event(&ctx);
> +}

--
paul-moore.com
