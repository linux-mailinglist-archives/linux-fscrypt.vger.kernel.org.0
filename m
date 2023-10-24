Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3DF627D4639
	for <lists+linux-fscrypt@lfdr.de>; Tue, 24 Oct 2023 05:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232320AbjJXDwr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 23 Oct 2023 23:52:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232222AbjJXDwf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 23 Oct 2023 23:52:35 -0400
Received: from mail-qk1-x72e.google.com (mail-qk1-x72e.google.com [IPv6:2607:f8b0:4864:20::72e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F58010D5
        for <linux-fscrypt@vger.kernel.org>; Mon, 23 Oct 2023 20:52:27 -0700 (PDT)
Received: by mail-qk1-x72e.google.com with SMTP id af79cd13be357-77891c236fcso312570085a.3
        for <linux-fscrypt@vger.kernel.org>; Mon, 23 Oct 2023 20:52:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1698119546; x=1698724346; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:message-id:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=GnPZt7wTu5bHl+yZIdMyk9dSEtxPVy94lr+8pKkfEn4=;
        b=Qk2NAnk+d3PS2nhphbsNh4pXDwIkiF/OEugwNqtX8DEU03CEfroRIc3UcQKLCx0RJB
         c/SnoKoKs7NXwkEjbsod/f2u8PP3uqJdYiRs/R2l+++7jXOlKo3J8QMLftlSgdlmrf+S
         WDpNm7dOHUoRzJI8nxhDZADh7OPpxVkCdKQNTLwgNHsnyxbj6+fDjztk56ap664Rh+ph
         GiJ4k5abmtn8z0O2bAg5QoevXeJcBa4b8IMwN9UzkCbNXv5BiYWoCajzAoBQt0a80b5Z
         nchL+39mHH0b1gi98t637zPu3o3WUyn7fI3B9Y99ScaMgRAxoK5C1XdyDLO4ci0w0AAU
         IysA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698119546; x=1698724346;
        h=in-reply-to:references:subject:cc:to:from:message-id:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GnPZt7wTu5bHl+yZIdMyk9dSEtxPVy94lr+8pKkfEn4=;
        b=IHr40uIPWjb/UgoFLt66qVp76wwzxKclBfnZmlm3UaROIQzi0rpLIP8uY+U83TUna+
         pN5A2EVLaPofG54eFCRbgn+/BNV1XsD8rGkN1kT9KuehUgRdkRIcAkVmLFhA2j4fbGRL
         pSyasDeUqylcDtu9+f1phQ8+9zC3lpOWa1OHdxg0a0M9949PCVXwaOsX+nlwm6zctjLl
         oNHUTI46mu4+3vSDuXRzhpQZK1GSTOWciEoLpnaA4GyG22Rcd0hXK44inG/cqf/L+Riz
         dra4U6qpLDQtZk6ICeVPWVvg7+XehrFIq4S6YaTmYkDQwKcI/LqzRafE1W7s/mqzNvuS
         RfYA==
X-Gm-Message-State: AOJu0YwsgCLNtDUpbKGM1FR1K+BAtaz5r+GMlD9YtB1xOtLMFgvhUTWe
        05lSDZmyqf+DuHT3ocrMb08m
X-Google-Smtp-Source: AGHT+IFvSV+EXgEeBKXX2Mm2c4Pu+xlgfjLQsVDGRnKVVxJUbzV3yBw9uUXEzF2i2rsqjzOaeFEfJQ==
X-Received: by 2002:a05:620a:4049:b0:778:9232:a564 with SMTP id i9-20020a05620a404900b007789232a564mr13553158qko.47.1698119546060;
        Mon, 23 Oct 2023 20:52:26 -0700 (PDT)
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id w12-20020ae9e50c000000b0077407e3d68asm3162408qkf.111.2023.10.23.20.52.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 23 Oct 2023 20:52:25 -0700 (PDT)
Date:   Mon, 23 Oct 2023 23:52:25 -0400
Message-ID: <c53599e9d278fc55be30e3bac9411328.paul@paul-moore.com>
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
Subject: Re: [PATCH RFC v11 5/19] ipe: introduce 'boot_verified' as a trust  provider
References: <1696457386-3010-6-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1696457386-3010-6-git-send-email-wufan@linux.microsoft.com>
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
> IPE is designed to provide system level trust guarantees, this usually
> implies that trust starts from bootup with a hardware root of trust,
> which validates the bootloader. After this, the bootloader verifies the
> kernel and the initramfs.
> 
> As there's no currently supported integrity method for initramfs, and
> it's typically already verified by the bootloader, introduce a property
> that causes the first superblock to have an execution to be "pinned",
> which is typically initramfs.
> 
> When the "pinned" device is unmounted, it will be "unpinned" and
> `boot_verified` property will always evaluate to false afterward.
> 
> We use a pointer with a spin_lock to "pin" the device instead of rcu
> because rcu synchronization may sleep, which is not allowed when
> unmounting a device.
>
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v2:
>   +No Changes
> 
> v3:
>   + Remove useless caching system
>   + Move ipe_load_properties to this match
>   + Minor changes from checkpatch --strict warnings
> 
> v4:
>   + Remove comments from headers that was missed previously.
>   + Grammatical corrections.
> 
> v5:
>   + No significant changes
> 
> v6:
>   + No changes
> 
> v7:
>   + Reword and refactor patch 04/12 to [09/16], based on changes in the underlying system.
>   + Add common audit function for boolean values
>   + Use common audit function as implementation.
> 
> v8:
>   + No changes
> 
> v9:
>   + No changes
> 
> v10:
>   + Replace struct file with struct super_block
> 
> v11:
>   + Fix code style issues
> ---
>  security/ipe/eval.c          | 72 +++++++++++++++++++++++++++++++++++-
>  security/ipe/eval.h          |  2 +
>  security/ipe/hooks.c         | 12 ++++++
>  security/ipe/hooks.h         |  2 +
>  security/ipe/ipe.c           |  1 +
>  security/ipe/policy.h        |  2 +
>  security/ipe/policy_parser.c | 35 +++++++++++++++++-
>  7 files changed, 124 insertions(+), 2 deletions(-)
> 
> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> index 8a8bcc5c7d7f..bdac4abc0ddb 100644
> --- a/security/ipe/eval.c
> +++ b/security/ipe/eval.c
> @@ -9,6 +9,7 @@
>  #include <linux/file.h>
>  #include <linux/sched.h>
>  #include <linux/rcupdate.h>
> +#include <linux/spinlock.h>
>  
>  #include "ipe.h"
>  #include "eval.h"
> @@ -16,6 +17,44 @@
>  
>  struct ipe_policy __rcu *ipe_active_policy;
>  
> +static const struct super_block *pinned_sb;
> +static DEFINE_SPINLOCK(pin_lock);
> +#define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
> +
> +/**
> + * pin_sb - Pin the underlying superblock of @f, marking it as trusted.
> + * @sb: Supplies a super_block structure to be pinned.
> + */
> +static void pin_sb(const struct super_block *sb)
> +{
> +	if (!sb)
> +		return;
> +	spin_lock(&pin_lock);
> +	if (!pinned_sb)
> +		pinned_sb = sb;
> +	spin_unlock(&pin_lock);
> +}
> +
> +/**
> + * from_pinned - Determine whether @sb is the pinned super_block.
> + * @sb: Supplies a super_block to check against the pinned super_block.
> + *
> + * Return:
> + * * true	- @sb is the pinned super_block
> + * * false	- @sb is not the pinned super_block
> + */
> +static bool from_pinned(const struct super_block *sb)
> +{
> +	bool rv;
> +
> +	if (!sb)
> +		return false;
> +	spin_lock(&pin_lock);
> +	rv = !IS_ERR_OR_NULL(pinned_sb) && pinned_sb == sb;
> +	spin_unlock(&pin_lock);

It's okay for an initial version, but I still think you need to get
away from this spinlock in from_pinned() as quickly as possible.
Maybe I'm wrong, but this looks like a major source of lock contention.

I understand the issue around RCU and the potential for matching on
a reused buffer/address, but if you modified IPE to have its own LSM
security blob in super_block::security you could mark the superblock
when it was mounted and do a lockless lookup here in from_pinned().

> +	return rv;
> +}

--
paul-moore.com
