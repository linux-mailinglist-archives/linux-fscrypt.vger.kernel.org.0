Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ED9776A8912
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Mar 2023 20:08:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229758AbjCBTIF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Mar 2023 14:08:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229568AbjCBTIE (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Mar 2023 14:08:04 -0500
Received: from mail-pl1-x632.google.com (mail-pl1-x632.google.com [IPv6:2607:f8b0:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 432F858482
        for <linux-fscrypt@vger.kernel.org>; Thu,  2 Mar 2023 11:07:40 -0800 (PST)
Received: by mail-pl1-x632.google.com with SMTP id ky4so325818plb.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 02 Mar 2023 11:07:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1677784058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sXmdCYS8uUA/QelUv6yyIq1avb/Bwhi6mEnWSJfU5vs=;
        b=RV6/nmHp6arv1X0ChTQMSQBMTmO7T5IWwIgTqkxXh1iOST9W4qi/ekPTAIyRVO+FUi
         QuQNWmRn01leWdoSSpVJh5YxIrHAFZeO3LNVw9X/l2x+tJHVN41xXqTzzcmMqwZhH9/C
         aGrXvIoN9GK0Y+tu7zMT87BGyl5WcfJ2WUeWv6ikOKefFL7M/dxmjhuO79grKmcTYQv2
         hBEDD6oO6cQyboHzJ07DIZ08TtRpxidM4l9pAqqLduW4H7scY1XX4aY/ILxeAlIRrN+5
         ZdHQfPpmf/a4zKt12YArGn5NY+unc92qQiBVxa3aDTvoUJNlHMKGvLYQ3BktOaO7Gsti
         OUWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1677784058;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sXmdCYS8uUA/QelUv6yyIq1avb/Bwhi6mEnWSJfU5vs=;
        b=dl7HmlG/96qdyVNN8HJ/IE9tDeUevhT0bNiRDVBPqKcUBmNWtztD9is49tW5OO9KM8
         XB0m1AEcdxVP5qQHFVmKAJvEeXZOfBUcm2k5MLH2Zjew75IedadzjikHZG7NGsU3lQR4
         +ZI+RS1C/x8rH/ouERl8Ruxuelii0KiWGcYHl0RDal3uIKDR4/M6WQdJDLw4beUAdCK+
         mAgWyCpdbVzfQjPQ4DoYKtLGENUi7py7fdpaDYr2p3UaHFRjtZsyYnBrnChL7WOrdMS1
         AHbK7gAazRHoZNuHFEM6cXS22ffsEEDyRykCkxHwFKass2zQFeLp8o1ZAunyzTMU2BVN
         ieCw==
X-Gm-Message-State: AO0yUKWcxs7bTFahTUFIZ0j/DTcSxX4erOZGRkHVKvMy6AgiOtSmJECk
        zFt6LxNwph3qN+/T2DY8MpspWNiLsoEUv7Pd6XLf
X-Google-Smtp-Source: AK7set/Db7WZZKl0taW3exwY3q/1lycmaTlq+aBJLdP6HP+tCJ31sSnx8gcIjQrgxrfxLNkQEq4WjDmVJRupdw5mfEM=
X-Received: by 2002:a17:90a:df8e:b0:234:87a7:f180 with SMTP id
 p14-20020a17090adf8e00b0023487a7f180mr4514483pjv.0.1677784058098; Thu, 02 Mar
 2023 11:07:38 -0800 (PST)
MIME-Version: 1.0
References: <1675119451-23180-1-git-send-email-wufan@linux.microsoft.com> <1675119451-23180-10-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1675119451-23180-10-git-send-email-wufan@linux.microsoft.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 2 Mar 2023 14:07:27 -0500
Message-ID: <CAHC9VhTiLafboxni2z01mxs=QNZFjgJ7EMJL33RWPpTqJKgfgA@mail.gmail.com>
Subject: Re: [RFC PATCH v9 09/16] block|security: add LSM blob to block_device
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

On Mon, Jan 30, 2023 at 5:58=E2=80=AFPM Fan Wu <wufan@linux.microsoft.com> =
wrote:
>
> From: Deven Bowers <deven.desai@linux.microsoft.com>
>
> block_device structures can have valuable security properties,
> based on how they are created, and what subsystem manages them.
>
> By adding LSM storage to this structure, this data can be accessed
> at the LSM layer.
>
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>

...

> ---
>  block/bdev.c                  |  7 ++++
>  include/linux/blk_types.h     |  3 ++
>  include/linux/lsm_hook_defs.h |  5 +++
>  include/linux/lsm_hooks.h     | 12 ++++++
>  include/linux/security.h      | 22 +++++++++++
>  security/security.c           | 70 +++++++++++++++++++++++++++++++++++
>  6 files changed, 119 insertions(+)
>
> diff --git a/block/bdev.c b/block/bdev.c
> index edc110d90df4..f8db53b47c00 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -24,6 +24,7 @@
>  #include <linux/pseudo_fs.h>
>  #include <linux/uio.h>
>  #include <linux/namei.h>
> +#include <linux/security.h>
>  #include <linux/part_stat.h>
>  #include <linux/uaccess.h>
>  #include <linux/stat.h>
> @@ -396,6 +397,11 @@ static struct inode *bdev_alloc_inode(struct super_b=
lock *sb)
>         if (!ei)
>                 return NULL;
>         memset(&ei->bdev, 0, sizeof(ei->bdev));
> +
> +       if (security_bdev_alloc(&ei->bdev)) {
> +               kmem_cache_free(bdev_cachep, ei);
> +               return NULL;
> +       }
>         return &ei->vfs_inode;
>  }
>
> @@ -405,6 +411,7 @@ static void bdev_free_inode(struct inode *inode)
>
>         free_percpu(bdev->bd_stats);
>         kfree(bdev->bd_meta_info);
> +       security_bdev_free(bdev);
>
>         if (!bdev_is_partition(bdev)) {
>                 if (bdev->bd_disk && bdev->bd_disk->bdi)
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index 99be590f952f..137a04f45c17 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -68,6 +68,9 @@ struct block_device {
>  #ifdef CONFIG_FAIL_MAKE_REQUEST
>         bool                    bd_make_it_fail;
>  #endif
> +#ifdef CONFIG_SECURITY
> +       void                    *security;
> +#endif
>  } __randomize_layout;
>
>  #define bdev_whole(_bdev) \
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.=
h
> index ed6cb2ac55fa..1f79029c9e28 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -417,3 +417,8 @@ LSM_HOOK(int, 0, uring_override_creds, const struct c=
red *new)
>  LSM_HOOK(int, 0, uring_sqpoll, void)
>  LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
>  #endif /* CONFIG_IO_URING */
> +
> +LSM_HOOK(int, 0, bdev_alloc_security, struct block_device *bdev)
> +LSM_HOOK(void, LSM_RET_VOID, bdev_free_security, struct block_device *bd=
ev)
> +LSM_HOOK(int, 0, bdev_setsecurity, struct block_device *bdev, const char=
 *name,
> +        const void *value, size_t size)
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 0a5ba81f7367..b622ceb57d83 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1618,6 +1618,17 @@
>   *     @what: kernel feature being accessed.
>   *     Return 0 if permission is granted.
>   *
> + * @bdev_alloc_security:
> + *     Initialize the security field inside a block_device structure.
> + *
> + * @bdev_free_security:
> + *     Cleanup the security information stored inside a block_device str=
ucture.
> + *
> + * @bdev_setsecurity:
> + *     Set a security property associated with @name for @bdev with
> + *     value @value. @size indicates the size of @value in bytes.
> + *     If a @name is not implemented, return -EOPNOTSUPP.
> + *

Just a heads-up that the LSM hook comment blocks are moving to
security/security.c very soon now (if they are not already there by
the time you read this).

https://lore.kernel.org/linux-security-module/20230217032625.678457-1-paul@=
paul-moore.com

> diff --git a/security/security.c b/security/security.c
> index d1571900a8c7..5c81dd3b1350 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -2705,6 +2730,51 @@ int security_locked_down(enum lockdown_reason what=
)
>  }
>  EXPORT_SYMBOL(security_locked_down);
>
> +int security_bdev_alloc(struct block_device *bdev)
> +{
> +       int rc =3D 0;
> +
> +       rc =3D lsm_bdev_alloc(bdev);
> +       if (unlikely(rc))
> +               return rc;
> +
> +       rc =3D call_int_hook(bdev_alloc_security, 0, bdev);
> +       if (unlikely(rc))
> +               security_bdev_free(bdev);
> +
> +       return LSM_RET_DEFAULT(bdev_alloc_security);
> +}
> +EXPORT_SYMBOL(security_bdev_alloc);
> +
> +void security_bdev_free(struct block_device *bdev)
> +{
> +       if (!bdev->security)
> +               return;
> +
> +       call_void_hook(bdev_free_security, bdev);
> +
> +       kfree(bdev->security);
> +       bdev->security =3D NULL;
> +}
> +EXPORT_SYMBOL(security_bdev_free);
> +
> +int security_bdev_setsecurity(struct block_device *bdev,
> +                             const char *name, const void *value,
> +                             size_t size)
> +{
> +       int rc =3D 0;
> +       struct security_hook_list *p;
> +
> +       hlist_for_each_entry(p, &security_hook_heads.bdev_setsecurity, li=
st) {
> +               rc =3D p->hook.bdev_setsecurity(bdev, name, value, size);
> +               if (rc && rc !=3D -EOPNOTSUPP)
> +                       return rc;
> +       }
> +
> +       return LSM_RET_DEFAULT(bdev_setsecurity);
> +}
> +EXPORT_SYMBOL(security_bdev_setsecurity);

I think we need to see the `security_bdev_setsecurity()` hook actually
used by a caller in this patch.

>  #ifdef CONFIG_PERF_EVENTS
>  int security_perf_event_open(struct perf_event_attr *attr, int type)
>  {
> --
> 2.39.0

--
paul-moore.com
