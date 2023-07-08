Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3219074BC19
	for <lists+linux-fscrypt@lfdr.de>; Sat,  8 Jul 2023 07:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233053AbjGHFhd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 8 Jul 2023 01:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232978AbjGHFhM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 8 Jul 2023 01:37:12 -0400
Received: from mail-qv1-xf2f.google.com (mail-qv1-xf2f.google.com [IPv6:2607:f8b0:4864:20::f2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5169F2107
        for <linux-fscrypt@vger.kernel.org>; Fri,  7 Jul 2023 22:36:59 -0700 (PDT)
Received: by mail-qv1-xf2f.google.com with SMTP id 6a1803df08f44-635e54e22d6so18681366d6.2
        for <linux-fscrypt@vger.kernel.org>; Fri, 07 Jul 2023 22:36:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1688794618; x=1691386618;
        h=in-reply-to:references:subject:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=v2wkHCwd4vm+IEtkc2nWyRw52RwR9sbRYqSY91RfFRQ=;
        b=A7TKcyKu/VPh1w1ZbiKg9Zg8sW+vFmOPtftfVKls4QKi1M9IgsF8i1dgygecNhfMRT
         bZZFCNiIqk77Dhtmm6iE2NgepkEBGBg8woAvioe8aSqCgRmg+4CALt4wUCcdM+OgLOTF
         tach2LhZStFkxdBYb+Ax/Cx4yB7i7LbshVj0UppsZAor1ljGkqBGcXcVsaD/nQQbASyX
         ttuPnodpcVGe9Bi/7EE50fSWAPJAnxSdR20LnmhWTIX1atn5eYqFd5X0F4udA5Ue37GS
         A86+hBiG20f6mEIa37Le0ZYAqWEnzIN2ZqZpg6/30pWeIxxIZpF7ZpkS/VmjEAx8+qgK
         nwQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688794618; x=1691386618;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=v2wkHCwd4vm+IEtkc2nWyRw52RwR9sbRYqSY91RfFRQ=;
        b=IEZWhdCGJy/Df40arL0NoENtJkmpSbSnqgvFbmIVHfOaYSXHy2+5wUvefKUd9umK3D
         0vwnf0kuTd/vjjCmykNRmDkIaf7JiRpCBko2dmvkj5vpsp/eLBUTo9nUbIwjDTO8enak
         n/2iXNOed/vi3qBXWfK/eN14VNj0u1m4Dho4RgN3/HuEfuVPsBqluFfmh9JDbK2rvfzG
         6lJfGP8U49tLcIViulu23y96Wh7f/SOx2xNSP47XF68v5KdbnZxjzmdBtWcfbZiH/Inr
         XGILLv/wi4lZDGnVJ6+fNtVvN6BkGDCI+Uof0Pww5YDP/s3TiIyMfbEIo6t4huF040dL
         hcXg==
X-Gm-Message-State: ABy/qLbPHEM36NuArR2jp/e2EYxMIZdt+Z1MC2Xh/wn5twD9BqgDlCUl
        OmRazZXHTCO7yAIBANeMkkd7
X-Google-Smtp-Source: APBJJlENhuCNF416DPzzrczcaxPIqtcSiA8/0DJvKcPv9Rl2z24HcHNBuekQRsoH+kaIbBJgTJf8+w==
X-Received: by 2002:a0c:b24a:0:b0:635:abf1:e93e with SMTP id k10-20020a0cb24a000000b00635abf1e93emr5908682qve.29.1688794617762;
        Fri, 07 Jul 2023 22:36:57 -0700 (PDT)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id y12-20020a0c8ecc000000b006360778f314sm2940646qvb.105.2023.07.07.22.36.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Jul 2023 22:36:57 -0700 (PDT)
Date:   Sat, 08 Jul 2023 01:36:57 -0400
Message-ID: <007992aec442cda5d5866e89b0ed5c69.paul@paul-moore.com>
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
Subject: Re: [PATCH RFC v10 4/17] ipe: add LSM hooks on execution and kernel  read
References: <1687986571-16823-5-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1687986571-16823-5-git-send-email-wufan@linux.microsoft.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
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
>  security/ipe/eval.c  |  14 ++++
>  security/ipe/eval.h  |   1 +
>  security/ipe/hooks.c | 182 +++++++++++++++++++++++++++++++++++++++++++
>  security/ipe/hooks.h |  25 ++++++
>  security/ipe/ipe.c   |   6 ++
>  5 files changed, 228 insertions(+)
>  create mode 100644 security/ipe/hooks.c
>  create mode 100644 security/ipe/hooks.h

Adding the 'hooks.h' header allows for much of code added in the
previous patches to finally compile and there are a number of errors,
too many to include here.  Please fix those and ensure that each
point in the patchset compiles cleanly.

> diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
> new file mode 100644
> index 000000000000..d896a5a474bc
> --- /dev/null
> +++ b/security/ipe/hooks.c
> @@ -0,0 +1,182 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#include <linux/fs.h>
> +#include <linux/types.h>
> +#include <linux/binfmts.h>
> +#include <linux/mman.h>
> +
> +#include "ipe.h"
> +#include "hooks.h"
> +#include "eval.h"
> +
> +/**
> + * ipe_bprm_check_security - ipe security hook function for bprm check.
> + * @bprm: Supplies a pointer to a linux_binprm structure to source the file
> + *	  being evaluated.
> + *
> + * This LSM hook is called when a binary is loaded through the exec
> + * family of system calls.
> + * Return:
> + * *0	- OK
> + * *!0	- Error
> + */
> +int ipe_bprm_check_security(struct linux_binprm *bprm)
> +{
> +	struct ipe_eval_ctx ctx = { 0 };

It's up to you, but when you have a fequently used initializer like
this it is often wrapped in a macro:

  #define IPE_EVAL_CTX_INIT ((struct ipe_eval_ctx){ 0 })

... so that you can write the variable decalaration like this:

  struct ipe_eval_ctx ctx = IPE_EVAL_CTX_INIT;

It's not a requirement, it just tends to look a little cleaner and
should you ever need to change the initializer it makes your life
a lot easier.

> +	build_eval_ctx(&ctx, bprm->file, __IPE_OP_EXEC);
> +	return ipe_evaluate_event(&ctx);
> +}
> +
> +/**
> + * ipe_mmap_file - ipe security hook function for mmap check.
> + * @f: File being mmap'd. Can be NULL in the case of anonymous memory.
> + * @reqprot: The requested protection on the mmap, passed from usermode.
> + * @prot: The effective protection on the mmap, resolved from reqprot and
> + *	  system configuration.
> + * @flags: Unused.
> + *
> + * This hook is called when a file is loaded through the mmap
> + * family of system calls.
> + *
> + * Return:
> + * * 0	- OK
> + * * !0	- Error
> + */
> +int ipe_mmap_file(struct file *f, unsigned long reqprot, unsigned long prot,
> +		  unsigned long flags)

Since @reqprot is always going to be unused in this function, you
might want to mark it as such to help prevent compiler
warnings/errors, for example:

 unsigned long reqprot __always_unused

> +{
> +	struct ipe_eval_ctx ctx = { 0 };
> +
> +	if (prot & PROT_EXEC) {
> +		build_eval_ctx(&ctx, f, __IPE_OP_EXEC);
> +		return ipe_evaluate_event(&ctx);
> +	}
> +
> +	return 0;
> +}
> +
> +/**
> + * ipe_file_mprotect - ipe security hook function for mprotect check.
> + * @vma: Existing virtual memory area created by mmap or similar.
> + * @reqprot: The requested protection on the mmap, passed from usermode.
> + * @prot: The effective protection on the mmap, resolved from reqprot and
> + *	  system configuration.
> + *
> + * This LSM hook is called when a mmap'd region of memory is changing
> + * its protections via mprotect.
> + *
> + * Return:
> + * * 0	- OK
> + * * !0	- Error
> + */
> +int ipe_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,

See my comment above about @reqprot.

> +		      unsigned long prot)
> +{
> +	struct ipe_eval_ctx ctx = { 0 };
> +
> +	/* Already Executable */
> +	if (vma->vm_flags & VM_EXEC)
> +		return 0;
> +
> +	if (prot & PROT_EXEC) {
> +		build_eval_ctx(&ctx, vma->vm_file, __IPE_OP_EXEC);
> +		return ipe_evaluate_event(&ctx);
> +	}
> +
> +	return 0;
> +}

--
paul-moore.com
