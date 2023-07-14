Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B817275446B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 14 Jul 2023 23:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229691AbjGNVrI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 14 Jul 2023 17:47:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjGNVrG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 14 Jul 2023 17:47:06 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 514B335A8;
        Fri, 14 Jul 2023 14:47:03 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id B253220ABD64; Fri, 14 Jul 2023 14:47:02 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B253220ABD64
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1689371222;
        bh=217tuDpVmoLrkkGoJqoyVlAua3WGHBs8gt+hDtlnBd4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ussi8JyOA+xtDdpRzNY9B5oZVy3yuTvi/fnM4AOv1VV3uHn6NlSKNB5+9JxM4ruvn
         jo/kQBU8khVpAFaOcEwhkjZfkxwjHKzZc/B/xDo9kfU1d0QD0MrsJe2TZ2nrmWxgmf
         mjNf6BZjR3nnivTzw6I8BsijyiefH+c8Evc1/DS4=
Date:   Fri, 14 Jul 2023 14:47:02 -0700
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [PATCH RFC v10 4/17] ipe: add LSM hooks on execution and kernel
  read
Message-ID: <20230714214702.GC15267@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-5-git-send-email-wufan@linux.microsoft.com>
 <cbe877b3905033d2b8c7c92e6d0cad4e.paul@paul-moore.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cbe877b3905033d2b8c7c92e6d0cad4e.paul@paul-moore.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
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

On Sat, Jul 08, 2023 at 12:23:02AM -0400, Paul Moore wrote:
> On Jun 28, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
> > 
> > IPE's initial goal is to control both execution and the loading of
> > kernel modules based on the system's definition of trust. It
> > accomplishes this by plugging into the security hooks for
> > bprm_check_security, file_mprotect, mmap_file, kernel_load_data,
> > and kernel_read_data.
> > 
> > Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> > Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> > ---
> >  security/ipe/eval.c  |  14 ++++
> >  security/ipe/eval.h  |   1 +
> >  security/ipe/hooks.c | 182 +++++++++++++++++++++++++++++++++++++++++++
> >  security/ipe/hooks.h |  25 ++++++
> >  security/ipe/ipe.c   |   6 ++
> >  5 files changed, 228 insertions(+)
> >  create mode 100644 security/ipe/hooks.c
> >  create mode 100644 security/ipe/hooks.h
> 
> Adding the 'hooks.h' header allows for much of code added in the
> previous patches to finally compile and there are a number of errors,
> too many to include here.  Please fix those and ensure that each
> point in the patchset compiles cleanly.
> 
Sorry again for the mistake I made here.

> > diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
> > new file mode 100644
> > index 000000000000..d896a5a474bc
> > --- /dev/null
> > +++ b/security/ipe/hooks.c
> > @@ -0,0 +1,182 @@
> > +// SPDX-License-Identifier: GPL-2.0
> > +/*
> > + * Copyright (C) Microsoft Corporation. All rights reserved.
> > + */
> > +
> > +#include <linux/fs.h>
> > +#include <linux/types.h>
> > +#include <linux/binfmts.h>
> > +#include <linux/mman.h>
> > +
> > +#include "ipe.h"
> > +#include "hooks.h"
> > +#include "eval.h"
> > +
> > +/**
> > + * ipe_bprm_check_security - ipe security hook function for bprm check.
> > + * @bprm: Supplies a pointer to a linux_binprm structure to source the file
> > + *	  being evaluated.
> > + *
> > + * This LSM hook is called when a binary is loaded through the exec
> > + * family of system calls.
> > + * Return:
> > + * *0	- OK
> > + * *!0	- Error
> > + */
> > +int ipe_bprm_check_security(struct linux_binprm *bprm)
> > +{
> > +	struct ipe_eval_ctx ctx = { 0 };
> 
> It's up to you, but when you have a fequently used initializer like
> this it is often wrapped in a macro:
> 
>   #define IPE_EVAL_CTX_INIT ((struct ipe_eval_ctx){ 0 })
> 
> ... so that you can write the variable decalaration like this:
> 
>   struct ipe_eval_ctx ctx = IPE_EVAL_CTX_INIT;
> 
> It's not a requirement, it just tends to look a little cleaner and
> should you ever need to change the initializer it makes your life
> a lot easier.
> 
Yes I agree this looks way better, I will update all the context init.

> > +	build_eval_ctx(&ctx, bprm->file, __IPE_OP_EXEC);
> > +	return ipe_evaluate_event(&ctx);
> > +}
> > +
> > +/**
> > + * ipe_mmap_file - ipe security hook function for mmap check.
> > + * @f: File being mmap'd. Can be NULL in the case of anonymous memory.
> > + * @reqprot: The requested protection on the mmap, passed from usermode.
> > + * @prot: The effective protection on the mmap, resolved from reqprot and
> > + *	  system configuration.
> > + * @flags: Unused.
> > + *
> > + * This hook is called when a file is loaded through the mmap
> > + * family of system calls.
> > + *
> > + * Return:
> > + * * 0	- OK
> > + * * !0	- Error
> > + */
> > +int ipe_mmap_file(struct file *f, unsigned long reqprot, unsigned long prot,
> > +		  unsigned long flags)
> 
> Since @reqprot is always going to be unused in this function, you
> might want to mark it as such to help prevent compiler
> warnings/errors, for example:
> 
>  unsigned long reqprot __always_unused
> 
Thanks for telling me this useful mark! I will add it.

-Fan
> > +{
> > +	struct ipe_eval_ctx ctx = { 0 };
> > +
> > +	if (prot & PROT_EXEC) {
> > +		build_eval_ctx(&ctx, f, __IPE_OP_EXEC);
> > +		return ipe_evaluate_event(&ctx);
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +/**
> > + * ipe_file_mprotect - ipe security hook function for mprotect check.
> > + * @vma: Existing virtual memory area created by mmap or similar.
> > + * @reqprot: The requested protection on the mmap, passed from usermode.
> > + * @prot: The effective protection on the mmap, resolved from reqprot and
> > + *	  system configuration.
> > + *
> > + * This LSM hook is called when a mmap'd region of memory is changing
> > + * its protections via mprotect.
> > + *
> > + * Return:
> > + * * 0	- OK
> > + * * !0	- Error
> > + */
> > +int ipe_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
> 
> See my comment above about @reqprot.
> 
> > +		      unsigned long prot)
> > +{
> > +	struct ipe_eval_ctx ctx = { 0 };
> > +
> > +	/* Already Executable */
> > +	if (vma->vm_flags & VM_EXEC)
> > +		return 0;
> > +
> > +	if (prot & PROT_EXEC) {
> > +		build_eval_ctx(&ctx, vma->vm_file, __IPE_OP_EXEC);
> > +		return ipe_evaluate_event(&ctx);
> > +	}
> > +
> > +	return 0;
> > +}
> 
> --
> paul-moore.com
