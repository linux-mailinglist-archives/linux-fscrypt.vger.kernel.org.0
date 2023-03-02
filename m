Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1006A88FE
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Mar 2023 20:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjCBTF4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Mar 2023 14:05:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229738AbjCBTFz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Mar 2023 14:05:55 -0500
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDE0557D3A
        for <linux-fscrypt@vger.kernel.org>; Thu,  2 Mar 2023 11:05:32 -0800 (PST)
Received: by mail-pl1-x62e.google.com with SMTP id p6so373230plf.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 02 Mar 2023 11:05:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1677783931;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QnhBhuu5u3111j+U4J6Z/QRCIPFOsE3mv47xPRagllg=;
        b=Zemp5Sp+0xLGBEacUsanwrenN6MR373zw3vqQ/jduJ6qY240leWruglPk+Jzqx2Ogh
         57dP+gjkeLdU79WIXzZCgcIz6Pm00g4I7/6gFmForH9BgtzRTt8MHniADEWMXssFLyU9
         QqkWZYQo6KK/tpFLd/u8P0YqNOsphVix1BDu9iM3ortn/E3BT/DNHtPW6bI2lxKkkcMc
         pULhgzUP+y6vQIw4gj7dBGn7m/ohjCkE88o1zGvmm4UvoyvjhwlaKTkaSBRunOE2yICa
         58Kql9xrd/PVaN+0mvSFVmKKxNKAAEe4lTNLVFWSUH42Ovdpoz7b+FF9WlXhtmDZxFTo
         97Ew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677783931;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=QnhBhuu5u3111j+U4J6Z/QRCIPFOsE3mv47xPRagllg=;
        b=IS7CWOVSzbpv+dt42p7DaJ6fgrobUdUzqmxGHh3WSsnX5w07EmbQdHDpm4rojj7dHx
         5imw+uBsTg20fq6TeM67P3M6FqEbInJOnOp1Xiun6BS/Mu7q5MPON/WfsNK5aRPJB0Ah
         yj+ps8aXVSV9PVLVo+OE7Kb2SOGrumwlL95Kvw0RTkMXcKY0XZAnOvlW7U4IbCfgseCn
         pqFVXPgp/OY9kXbTQu7mz95ALz7Mif0/cIE04T9MEzTcRjcSwbXNY9beCkqGmiKG0UpG
         l8jlzWKHo8qw+cpZWev85x+Z2kKQI7WjU2nsx3s/rrMPYbGVgDWbh8+RBOZ9DGU1EseR
         hRlQ==
X-Gm-Message-State: AO0yUKUAZG0agm1AOKyp3hAkRI/H6P19kJS0HW8Zjxyj+qgQJyk/qR+C
        IgA2CGPOmAzu8XMAOztmeFBgt+6/4BeHytXgyRUU
X-Google-Smtp-Source: AK7set/XS9jRR+6EF6IY3vm76Q2PHUWnK1NbNkCZYFR//uZb4fUxerwZUrRoCcoXY64QVS6QX+Rtdxycn0TiTPZ+YRk=
X-Received: by 2002:a17:902:ef8a:b0:199:2451:feaf with SMTP id
 iz10-20020a170902ef8a00b001992451feafmr4215912plb.3.1677783931149; Thu, 02
 Mar 2023 11:05:31 -0800 (PST)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com> <1675119451-23180-7-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1675119451-23180-7-git-send-email-wufan@linux.microsoft.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 2 Mar 2023 14:05:20 -0500
Message-ID: <CAHC9VhRX4-=SSAkb0f2722dJ9JGudTyT-B=t8uoRqA8efwcoSg@mail.gmail.com>
Subject: Re: [RFC PATCH v9 06/16] ipe: add LSM hooks on execution and kernel read
To:     Fan Wu <wufan@linux.microsoft.com>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jan 30, 2023 at 5:59=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> =
wrote:
>
> From: Deven Bowers <deven.desai@linux.microsoft.com>
>
> IPE's initial goal is to control both execution and the loading of
> kernel modules based on the system's definition of trust. It
> accomplishes this by plugging into the security hooks for
> bprm_check_security, file_mprotect, mmap_file, kernel_load_data,
> and kernel_read_data.
>
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

...

> ---
>  security/ipe/hooks.c | 169 +++++++++++++++++++++++++++++++++++++++++++
>  security/ipe/hooks.h |  13 ++++
>  security/ipe/ipe.c   |   6 ++
>  3 files changed, 188 insertions(+)
>
> diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
> index 335b773c7ae1..fd5109e29c76 100644
> --- a/security/ipe/hooks.c
> +++ b/security/ipe/hooks.c
> @@ -23,3 +23,172 @@ void ipe_sb_free_security(struct super_block *mnt_sb)
>  {
>         ipe_invalidate_pinned_sb(mnt_sb);
>  }
> +
> +/**
> + * ipe_bprm_check_security - ipe security hook function for bprm check.
> + * @bprm: Supplies a pointer to a linux_binprm structure to source the f=
ile
> + *       being evaluated.
> + *
> + * This LSM hook is called when a binary is loaded through the exec
> + * family of system calls.
> + * Return:
> + * *0  - OK
> + * *!0 - Error
> + */
> +int ipe_bprm_check_security(struct linux_binprm *bprm)
> +{
> +       struct ipe_eval_ctx ctx =3D { 0 };
> +
> +       build_eval_ctx(&ctx, bprm->file, ipe_op_exec);
> +       return ipe_evaluate_event(&ctx);
> +}
> +
> +/**
> + * ipe_mmap_file - ipe security hook function for mmap check.
> + * @f: File being mmap'd. Can be NULL in the case of anonymous memory.
> + * @reqprot: The requested protection on the mmap, passed from usermode.
> + * @prot: The effective protection on the mmap, resolved from reqprot an=
d
> + *       system configuration.
> + * @flags: Unused.
> + *
> + * This hook is called when a file is loaded through the mmap
> + * family of system calls.
> + *
> + * Return:
> + * * 0 - OK
> + * * !0        - Error
> + */
> +int ipe_mmap_file(struct file *f, unsigned long reqprot, unsigned long p=
rot,
> +                 unsigned long flags)
> +{
> +       struct ipe_eval_ctx ctx =3D { 0 };
> +
> +       if (prot & PROT_EXEC || reqprot & PROT_EXEC) {

Is there a reason why you care about @reqprot?  It seems like IPE
would only be interested in the protection flags that the kernel is
actually using.

I notice that in the `ipe_file_mprotect()` hook you ignore @reqprot,
which I believe is the right thing to do.

> +               build_eval_ctx(&ctx, f, ipe_op_exec);
> +               return ipe_evaluate_event(&ctx);
> +       }
> +
> +       return 0;
> +}
> +
> +/**
> + * ipe_file_mprotect - ipe security hook function for mprotect check.
> + * @vma: Existing virtual memory area created by mmap or similar.
> + * @reqprot: The requested protection on the mmap, passed from usermode.
> + * @prot: The effective protection on the mmap, resolved from reqprot an=
d
> + *       system configuration.
> + *
> + * This LSM hook is called when a mmap'd region of memory is changing
> + * its protections via mprotect.
> + *
> + * Return:
> + * * 0 - OK
> + * * !0        - Error
> + */
> +int ipe_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
> +                     unsigned long prot)
> +{
> +       struct ipe_eval_ctx ctx =3D { 0 };
> +
> +       /* Already Executable */
> +       if (vma->vm_flags & VM_EXEC)
> +               return 0;
> +
> +       if (prot & PROT_EXEC) {
> +               build_eval_ctx(&ctx, vma->vm_file, ipe_op_exec);
> +               return ipe_evaluate_event(&ctx);
> +       }
> +
> +       return 0;
> +}
> +
> +/**
> + * ipe_kernel_read_file - ipe security hook function for kernel read.
> + * @file: Supplies a pointer to the file structure being read in from di=
sk.
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
> +                        bool contents)
> +{
> +       enum ipe_op_type op;
> +       struct ipe_eval_ctx ctx;
> +
> +       switch (id) {
> +       case READING_FIRMWARE:
> +               op =3D ipe_op_firmware;
> +               break;
> +       case READING_MODULE:
> +               op =3D ipe_op_kernel_module;
> +               break;
> +       case READING_KEXEC_INITRAMFS:
> +               op =3D ipe_op_kexec_initramfs;
> +               break;
> +       case READING_KEXEC_IMAGE:
> +               op =3D ipe_op_kexec_image;
> +               break;
> +       case READING_POLICY:
> +               op =3D ipe_op_ima_policy;
> +               break;
> +       case READING_X509_CERTIFICATE:
> +               op =3D ipe_op_ima_x509;
> +               break;
> +       default:
> +               op =3D ipe_op_max;
> +               WARN(op =3D=3D ipe_op_max, "no rule setup for enum %d", i=
d);
> +       }
> +
> +       build_eval_ctx(&ctx, file, op);
> +       return ipe_evaluate_event(&ctx);
> +}
> +
> +/**
> + * ipe_kernel_load_data - ipe security hook function for kernel load dat=
a.
> + * @id: Supplies the enumeration identifying the purpose of the read.
> + * @contents: Unused.
> + *
> + * This LSM hook is called when a buffer is being read in from disk.
> + *
> + * Return:
> + * * 0 - OK
> + * * !0        - Error
> + */
> +int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents)
> +{
> +       enum ipe_op_type op;
> +       struct ipe_eval_ctx ctx =3D { 0 };
> +
> +       switch (id) {
> +       case LOADING_FIRMWARE:
> +               op =3D ipe_op_firmware;
> +               break;
> +       case LOADING_MODULE:
> +               op =3D ipe_op_kernel_module;
> +               break;
> +       case LOADING_KEXEC_INITRAMFS:
> +               op =3D ipe_op_kexec_initramfs;
> +               break;
> +       case LOADING_KEXEC_IMAGE:
> +               op =3D ipe_op_kexec_image;
> +               break;
> +       case LOADING_POLICY:
> +               op =3D ipe_op_ima_policy;
> +               break;
> +       case LOADING_X509_CERTIFICATE:
> +               op =3D ipe_op_ima_x509;
> +               break;
> +       default:
> +               op =3D ipe_op_max;
> +               WARN(op =3D=3D ipe_op_max, "no rule setup for enum %d", i=
d);
> +       }
> +
> +       build_eval_ctx(&ctx, NULL, op);
> +       return ipe_evaluate_event(&ctx);
> +}
> diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
> index 30fe455389bf..857cae69678c 100644
> --- a/security/ipe/hooks.h
> +++ b/security/ipe/hooks.h
> @@ -11,4 +11,17 @@
>
>  void ipe_sb_free_security(struct super_block *mnt_sb);
>
> +int ipe_bprm_check_security(struct linux_binprm *bprm);
> +
> +int ipe_mmap_file(struct file *f, unsigned long reqprot, unsigned long p=
rot,
> +                 unsigned long flags);
> +
> +int ipe_file_mprotect(struct vm_area_struct *vma, unsigned long reqprot,
> +                     unsigned long prot);
> +
> +int ipe_kernel_read_file(struct file *file, enum kernel_read_file_id id,
> +                        bool contents);
> +
> +int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents);
> +
>  #endif /* IPE_HOOKS_H */
> diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
> index bef923026b50..7af2f942decd 100644
> --- a/security/ipe/ipe.c
> +++ b/security/ipe/ipe.c
> @@ -4,6 +4,7 @@
>   */
>
>  #include "ipe.h"
> +#include "hooks.h"
>
>  bool ipe_enabled;
>
> @@ -12,6 +13,11 @@ static struct lsm_blob_sizes ipe_blobs __lsm_ro_after_=
init =3D {
>
>  static struct security_hook_list ipe_hooks[] __lsm_ro_after_init =3D {
>         LSM_HOOK_INIT(sb_free_security, ipe_sb_free_security),
> +       LSM_HOOK_INIT(bprm_check_security, ipe_bprm_check_security),
> +       LSM_HOOK_INIT(mmap_file, ipe_mmap_file),
> +       LSM_HOOK_INIT(file_mprotect, ipe_file_mprotect),
> +       LSM_HOOK_INIT(kernel_read_file, ipe_kernel_read_file),
> +       LSM_HOOK_INIT(kernel_load_data, ipe_kernel_load_data),
>  };
>
>  /**
> --
> 2.39.0

--
paul-moore.com
