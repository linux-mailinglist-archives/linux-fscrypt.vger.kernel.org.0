Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD011543D59
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Jun 2022 22:07:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231326AbiFHUHs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Jun 2022 16:07:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiFHUHq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Jun 2022 16:07:46 -0400
Received: from sonic316-27.consmr.mail.ne1.yahoo.com (sonic316-27.consmr.mail.ne1.yahoo.com [66.163.187.153])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14AF147AC3
        for <linux-fscrypt@vger.kernel.org>; Wed,  8 Jun 2022 13:07:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1654718863; bh=hub+1Ql+9bmqzWvOpTjSrtiRj7Uh/8eexA50RoMXcfY=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=ip9RT2AEvBdvI/aFs7BYExrcViENdjPrXLZtwhxK3GqOYyqTQ40wrZZ5XEAQhKzeA1uzoWplwReg0IFC+a5miiq8FUbwHmR/vNjoUUQI8EVgtsqmHq6MwkBDu9ng7JDcyE6TdIyqfRNgElWvnnon0GucvC8AyjjoGGsi9suTFKNfyhNnCc825Y+PHm0gwui7d9bE6Hu3+n3/QJOkTCp++wN5TFDI4VINgN5/49jiwMQiuz6A/eNp2B+k+4NpENHWMRP5pmEMx3bEPZ/FuNhfon4mhDNx/DS7+O4nkAwh1fFF+vJtjw5Ve+GMTJjx1I1jTKtRUz8pUNT/GJbL7m4Ogg==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1654718863; bh=V+nEq7hUxz6mmiobMsksRcQVZ6mnNf4DmtkyAwOeoLr=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=F+owDEWahm64mSBxbcypT4y3+IMBnRIVJfkANeJAXAJ6W1wTj7BUIpmfz8/MGuuZxF6MidF4qxY6qghgJce2/OuQCJoBcACb2KCQD0QwkG2++J682/dhu/Td690OD4gLIqPL/NQ4j/iCUUfyBDi5PAFjmwXEAR5iADjVY9nQ20s69RicDQi5piFdWLI1vBcuPa7xNHNEnOqoPGgflSHg9JeUgqNnTHFGgcwBd1Z3HSiYDtxF5CeSmERU9IbslcV8eMD3M92B32lV/+9IE6CyDSmQ6uS7EGUNYRIIc+hkXF+E+tBg5+CmNRKNmjo78ot+34bHEegIXHqBTJJsSdLK+g==
X-YMail-OSG: dZcRtWQVM1nyBTimftEuB2S_m_h3PQ5bNx5T_9kfq7lZ9rRgiCkM4FFE.WaaKr8
 528cRFeLC8Oilwgqq1D7Tx51ekyMFzD6NBKn7fhEZvIRsdAQWdqgZ1M26K1._UuJYdxnHQnR0zUK
 JtIg35duXBQi.FJ_sLWf48EduPYmuDn1J4gZmQj79IUI.RmAKu_iepMcwpg7gXJOBlszvJZSq4LU
 qzCEve1w_hnikqQzInvkhNTGPkQGonBFDiIV9CakJtokfwpl.j0UTLrGeC8AYvy_.YEsxSR.xC9e
 AA69CyddTuR.ISWCTuZ4TOa4Bq7Jt.1iv8q3qCXlVY0U0kxhF2FFGGA8PlZA6S0yJCAEXgvxkxWe
 8gcCdnSiU3Un5JgvSWuZU87LxYdj4qRay7mxNQkaL5dpYVa9cy3EzK7c3dUIiy38y7wMmY9znRLL
 MBMJKE9YfH_VxNOR_8SvF7ovizMp8RDrMLbr8JAsVaS09Z.N9kLPuUO4W3c70adCjdaEr5y4b0qM
 pnlUGaX5rjtB_cld7Qiqs59p8yQGzVq5cY3qTq0SCL_onN4FRFKWTKQRyUVZs4tjCZpwsdEIsc24
 OPO9IUVxq1pKx0q7UTFxEYEqJ0.l6oMgvbZCbVWrFQawk93jbZMBKE1Nn_c7fo_XfSfcxP9KGayi
 pMFBDSpWyqf0j0tXZm..CjTQ_uZNhl1ChVO1jmLP_iNGbYW99dho8.Yddpdcc82H5yiG.F3vrYBd
 zwDyrbIV4NlkRZAnMXsVy_KenBWNDUKhvJyiIWKLXIuuHvuBkGXkouQZlNp0MqRcwulDkiDahNvT
 XHQFb6DmzKMTsicifu_WsSeLIRxhQitqED1hXMIm9RSiq1Si.HAcbohuqY5DAI1yAxlnX3qh2bY9
 sT46ItfYPNH7feJX4pjspfUIr7iUmhf08s_qop9aiNSIWeOSAO1y9iPUm_joE1YJihaAM.8xHMdI
 .rzcaJxZ7iRuyLLrzoEVuWjOoGE.vnw6bpcNFLBw2pAq57F1cF5xxOF6AgljliReMbm7LcOAukev
 4j5y8y.FQBJ8OyvbdnFXoLv5tu_5Vd3M9HfzjeHhgOxUErpagl2eq57Vvq6gQaQJzyEp7NQQxfEG
 cYvfyL_KwqS1zMaT2xs9fBlkntp.ubBen6wzG94_wCR9viWNxVYNd.xtOxVs4VD8XKpzTEVdUY9i
 QL4x5UcL3LUeiZ8jx_ZRJ9oCLKi1fJ6wQCnblpllBk8LK2Lp28IjxO6MiZ1UX9Pyu_vdfhQF2X1s
 1fZNA_i4tY1dJu51lZU4UJVzMM8l2JcpYXCeYrWPKR04RYxdL0LDuOg6kw5i9F9evGJ8.OTxZVfp
 CI_BTNyG3aomz4gGMzc_Yt0ZvlU6hpCvk88BSSjQ9amPkfSqzEAow8.ubW_yUeeDPA0P1sMeeeG1
 lM_xzcH_XOtzZd87LtBs7uGtAl5UpLN8XZQ668altct0mm6p9SejI1Piq4YcydjgkpQ4j9hwdvjG
 Jm_6HZSL6ieA5D.aVnn7v4QCxEkD8P6ENlyBc96eXAvYTEZOw4zXkqPOS3uTkxIutwsdNE6McSZ2
 JCwH4ID12G58NL_IjXhSNTHHYLa3FwETJBLa1PRUQUp5PzHC.piM1r3BrqYfLUIjm55WelHOsZUb
 wXlMAHw4wpbx811YUACU2GJNItuih_fWHliCKtZ4qcOAlJ_.cgs21p6jgZlgTgEhmM0bqGgkg33y
 DdxiuGQvUHiayF7d.X0pTVboCGQbHuKydPBOikbXT0BlSRJnKt2A0aQtMJp2rX8m7wo.mrwXjcNU
 7HGyBVZ_mo0Zyo_dRyiSolc3jLUwmuJfWuERMnDxkXA9Jb0w.coUNOxdFCliNu17aroPAhOppA8C
 SzxlcJHeHXcxCSAYGVVBPFYXVWkErFCw07xqEiYjI3NlWAIks.8fkEEO.6i_.EI6kLS_gC82mxbf
 e.8Lfxt5vTffi7OIST7KOwA8Yz3aGDBiqZvf8xjwq0XXZG7aqzS2GY6UYvjiuqBMPuvnKPO4ABsS
 ykC4T0rQoZsXkzN5kx3frCZZ.20zlK_ahUIixPNb3aaW1n0LT57I7GuyzOOH.NLhniPKrQs4XcCs
 RZO.Kk9IpQmzF5Zx6k5Hr5wvJyVSVD4l45P1COg77VP16uTWr8OlwTxr43MErogBmUMc7AByP8sx
 ZJr2BHjJpilJc9EnKez3Iufq.Sw2dxP6ZqnbcIeJ1hwyJqQknothjdWH__mIYjV_YsKSnR962XsB
 SVKDGWFMdep3DCHXT7RTwphwE7n5x54eRBeHOA3uXyUChelcUUVc-
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic316.consmr.mail.ne1.yahoo.com with HTTP; Wed, 8 Jun 2022 20:07:43 +0000
Received: by hermes--canary-production-gq1-54945cc758-2bxrx (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID 8903af1c4cc348265e8151c3d14fc543;
          Wed, 08 Jun 2022 20:07:41 +0000 (UTC)
Message-ID: <14754d16-75ae-cc92-cfc5-adce0628d9d9@schaufler-ca.com>
Date:   Wed, 8 Jun 2022 13:07:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [RFC PATCH v8 10/17] block|security: add LSM blob to block_device
Content-Language: en-US
To:     Deven Bowers <deven.desai@linux.microsoft.com>, corbet@lwn.net,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk,
        agk@redhat.com, snitzer@kernel.org, eparis@redhat.com,
        paul@paul-moore.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, linux-audit@redhat.com,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Casey Schaufler <casey@schaufler-ca.com>
References: <1654714889-26728-1-git-send-email-deven.desai@linux.microsoft.com>
 <1654714889-26728-11-git-send-email-deven.desai@linux.microsoft.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <1654714889-26728-11-git-send-email-deven.desai@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20280 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 6/8/2022 12:01 PM, Deven Bowers wrote:
> block_device structures can have valuable security properties,
> based on how they are created, and what subsystem manages them.
>
> By adding LSM storage to this structure, this data can be accessed
> at the LSM layer.
>
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>

Reviewed-by: Casey Schaufler <casey@schaufler-ca.com>

Not everyone is going to appreciate the infrastructure allocation
of the block_device security blob, but I do.

>
> ---
> v2:
>    + No Changes
>
> v3:
>    + Minor style changes from checkpatch --strict
>
> v4:
>    + No Changes
>
> v5:
>    + Allow multiple callers to call security_bdev_setsecurity
>
> v6:
>    + Simplify security_bdev_setsecurity break condition
>
> v7:
>    + Squash all dm-verity related patches to two patches,
>      the additions to dm-verity/fs, and the consumption of
>      the additions.
>
> v8:
>    + Split dm-verity related patches squashed in v7 to 3 commits based on
>      topic:
>        + New LSM hook
>        + Consumption of hook outside LSM
>        + Consumption of hook inside LSM.
>
>    + change return of security_bdev_alloc / security_bdev_setsecurity
>      to LSM_RET_DEFAULT instead of 0.
>
>    + Change return code to -EOPNOTSUPP, bring inline with other
>      setsecurity hooks.
> ---
>   block/bdev.c                  |  7 ++++
>   include/linux/blk_types.h     |  1 +
>   include/linux/lsm_hook_defs.h |  5 +++
>   include/linux/lsm_hooks.h     | 12 ++++++
>   include/linux/security.h      | 22 +++++++++++
>   security/security.c           | 70 +++++++++++++++++++++++++++++++++++
>   6 files changed, 117 insertions(+)
>
> diff --git a/block/bdev.c b/block/bdev.c
> index 5fe06c1f2def..e7ef2c7a22c9 100644
> --- a/block/bdev.c
> +++ b/block/bdev.c
> @@ -24,6 +24,7 @@
>   #include <linux/pseudo_fs.h>
>   #include <linux/uio.h>
>   #include <linux/namei.h>
> +#include <linux/security.h>
>   #include <linux/part_stat.h>
>   #include <linux/uaccess.h>
>   #include "../fs/internal.h"
> @@ -397,6 +398,11 @@ static struct inode *bdev_alloc_inode(struct super_block *sb)
>   	if (!ei)
>   		return NULL;
>   	memset(&ei->bdev, 0, sizeof(ei->bdev));
> +
> +	if (unlikely(security_bdev_alloc(&ei->bdev))) {
> +		kmem_cache_free(bdev_cachep, ei);
> +		return NULL;
> +	}
>   	return &ei->vfs_inode;
>   }
>   
> @@ -406,6 +412,7 @@ static void bdev_free_inode(struct inode *inode)
>   
>   	free_percpu(bdev->bd_stats);
>   	kfree(bdev->bd_meta_info);
> +	security_bdev_free(bdev);
>   
>   	if (!bdev_is_partition(bdev)) {
>   		if (bdev->bd_disk && bdev->bd_disk->bdi)
> diff --git a/include/linux/blk_types.h b/include/linux/blk_types.h
> index a24d4078fb21..a014ffa14b2d 100644
> --- a/include/linux/blk_types.h
> +++ b/include/linux/blk_types.h
> @@ -68,6 +68,7 @@ struct block_device {
>   #ifdef CONFIG_FAIL_MAKE_REQUEST
>   	bool			bd_make_it_fail;
>   #endif
> +	void			*security;
>   } __randomize_layout;
>   
>   #define bdev_whole(_bdev) \
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index eafa1d2489fd..3449c004bd84 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -407,3 +407,8 @@ LSM_HOOK(int, 0, perf_event_write, struct perf_event *event)
>   LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
>   LSM_HOOK(int, 0, uring_sqpoll, void)
>   #endif /* CONFIG_IO_URING */
> +
> +LSM_HOOK(int, 0, bdev_alloc_security, struct block_device *bdev)
> +LSM_HOOK(void, LSM_RET_VOID, bdev_free_security, struct block_device *bdev)
> +LSM_HOOK(int, 0, bdev_setsecurity, struct block_device *bdev, const char *name,
> +	 const void *value, size_t size)
> diff --git a/include/linux/lsm_hooks.h b/include/linux/lsm_hooks.h
> index 91c8146649f5..9f011d705ea8 100644
> --- a/include/linux/lsm_hooks.h
> +++ b/include/linux/lsm_hooks.h
> @@ -1550,6 +1550,17 @@
>    *
>    *     @what: kernel feature being accessed
>    *
> + * @bdev_alloc_security:
> + *	Initialize the security field inside a block_device structure.
> + *
> + * @bdev_free_security:
> + *	Cleanup the security information stored inside a block_device structure.
> + *
> + * @bdev_setsecurity:
> + *	Set a security property associated with @name for @bdev with
> + *	value @value. @size indicates the size of @value in bytes.
> + *	If a @name is not implemented, return -EOPNOTSUPP.
> + *
>    * Security hooks for perf events
>    *
>    * @perf_event_open:
> @@ -1610,6 +1621,7 @@ struct lsm_blob_sizes {
>   	int	lbs_ipc;
>   	int	lbs_msg_msg;
>   	int	lbs_task;
> +	int	lbs_bdev;
>   };
>   
>   /*
> diff --git a/include/linux/security.h b/include/linux/security.h
> index 7fc4e9f49f54..30b663de301f 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -473,6 +473,11 @@ int security_inode_notifysecctx(struct inode *inode, void *ctx, u32 ctxlen);
>   int security_inode_setsecctx(struct dentry *dentry, void *ctx, u32 ctxlen);
>   int security_inode_getsecctx(struct inode *inode, void **ctx, u32 *ctxlen);
>   int security_locked_down(enum lockdown_reason what);
> +int security_bdev_alloc(struct block_device *bdev);
> +void security_bdev_free(struct block_device *bdev);
> +int security_bdev_setsecurity(struct block_device *bdev,
> +			      const char *name, const void *value,
> +			      size_t size);
>   #else /* CONFIG_SECURITY */
>   
>   static inline int call_blocking_lsm_notifier(enum lsm_event event, void *data)
> @@ -1349,6 +1354,23 @@ static inline int security_locked_down(enum lockdown_reason what)
>   {
>   	return 0;
>   }
> +
> +static inline int security_bdev_alloc(struct block_device *bdev)
> +{
> +	return 0;
> +}
> +
> +static inline void security_bdev_free(struct block_device *bdev)
> +{
> +}
> +
> +static inline int security_bdev_setsecurity(struct block_device *bdev,
> +					    const char *name,
> +					    const void *value, size_t size)
> +{
> +	return 0;
> +}
> +
>   #endif	/* CONFIG_SECURITY */
>   
>   #if defined(CONFIG_SECURITY) && defined(CONFIG_WATCH_QUEUE)
> diff --git a/security/security.c b/security/security.c
> index 188b8f782220..59ec336788e8 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -29,6 +29,7 @@
>   #include <linux/string.h>
>   #include <linux/msg.h>
>   #include <net/flow.h>
> +#include <linux/fs.h>
>   
>   #define MAX_LSM_EVM_XATTR	2
>   
> @@ -208,6 +209,7 @@ static void __init lsm_set_blob_sizes(struct lsm_blob_sizes *needed)
>   	lsm_set_blob_size(&needed->lbs_msg_msg, &blob_sizes.lbs_msg_msg);
>   	lsm_set_blob_size(&needed->lbs_superblock, &blob_sizes.lbs_superblock);
>   	lsm_set_blob_size(&needed->lbs_task, &blob_sizes.lbs_task);
> +	lsm_set_blob_size(&needed->lbs_bdev, &blob_sizes.lbs_bdev);
>   }
>   
>   /* Prepare LSM for initialization. */
> @@ -344,6 +346,7 @@ static void __init ordered_lsm_init(void)
>   	init_debug("msg_msg blob size    = %d\n", blob_sizes.lbs_msg_msg);
>   	init_debug("superblock blob size = %d\n", blob_sizes.lbs_superblock);
>   	init_debug("task blob size       = %d\n", blob_sizes.lbs_task);
> +	init_debug("bdev blob size       = %d\n", blob_sizes.lbs_bdev);
>   
>   	/*
>   	 * Create any kmem_caches needed for blobs
> @@ -660,6 +663,28 @@ static int lsm_msg_msg_alloc(struct msg_msg *mp)
>   	return 0;
>   }
>   
> +/**
> + * lsm_bdev_alloc - allocate a composite block_device blob
> + * @bdev: the block_device that needs a blob
> + *
> + * Allocate the block_device blob for all the modules
> + *
> + * Returns 0, or -ENOMEM if memory can't be allocated.
> + */
> +static int lsm_bdev_alloc(struct block_device *bdev)
> +{
> +	if (blob_sizes.lbs_bdev == 0) {
> +		bdev->security = NULL;
> +		return 0;
> +	}
> +
> +	bdev->security = kzalloc(blob_sizes.lbs_bdev, GFP_KERNEL);
> +	if (!bdev->security)
> +		return -ENOMEM;
> +
> +	return 0;
> +}
> +
>   /**
>    * lsm_early_task - during initialization allocate a composite task blob
>    * @task: the task that needs a blob
> @@ -2617,6 +2642,51 @@ int security_locked_down(enum lockdown_reason what)
>   }
>   EXPORT_SYMBOL(security_locked_down);
>   
> +int security_bdev_alloc(struct block_device *bdev)
> +{
> +	int rc = 0;
> +
> +	rc = lsm_bdev_alloc(bdev);
> +	if (unlikely(rc))
> +		return rc;
> +
> +	rc = call_int_hook(bdev_alloc_security, 0, bdev);
> +	if (unlikely(rc))
> +		security_bdev_free(bdev);
> +
> +	return LSM_RET_DEFAULT(bdev_alloc_security);
> +}
> +EXPORT_SYMBOL(security_bdev_alloc);
> +
> +void security_bdev_free(struct block_device *bdev)
> +{
> +	if (!bdev->security)
> +		return;
> +
> +	call_void_hook(bdev_free_security, bdev);
> +
> +	kfree(bdev->security);
> +	bdev->security = NULL;
> +}
> +EXPORT_SYMBOL(security_bdev_free);
> +
> +int security_bdev_setsecurity(struct block_device *bdev,
> +			      const char *name, const void *value,
> +			      size_t size)
> +{
> +	int rc = 0;
> +	struct security_hook_list *p;
> +
> +	hlist_for_each_entry(p, &security_hook_heads.bdev_setsecurity, list) {
> +		rc = p->hook.bdev_setsecurity(bdev, name, value, size);
> +		if (rc && rc != -EOPNOTSUPP)
> +			return rc;
> +	}
> +
> +	return LSM_RET_DEFAULT(bdev_setsecurity);
> +}
> +EXPORT_SYMBOL(security_bdev_setsecurity);
> +
>   #ifdef CONFIG_PERF_EVENTS
>   int security_perf_event_open(struct perf_event_attr *attr, int type)
>   {
