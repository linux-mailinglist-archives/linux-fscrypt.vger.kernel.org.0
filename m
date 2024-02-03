Return-Path: <linux-fscrypt+bounces-166-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2F080848927
	for <lists+linux-fscrypt@lfdr.de>; Sat,  3 Feb 2024 23:25:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 891B82847F0
	for <lists+linux-fscrypt@lfdr.de>; Sat,  3 Feb 2024 22:25:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 199F8156E4;
	Sat,  3 Feb 2024 22:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="SFDtr5q9"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEDD168A9
	for <linux-fscrypt@vger.kernel.org>; Sat,  3 Feb 2024 22:25:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706999114; cv=none; b=jhzxEAVUNvrqSlNGY7j1VA/67SfidjdBhGNFbnAhdNOXVvbdtz1i3UD4sXdkSo7yOYRY4WKta/kQYxyzWA2GUZ0uYb6XN/16Ortwewd3SwVizPVtL3U2FI0eAdzS6OXw4DkKWjJG8hxKLfG+Bp/28G1rjInmj/NyUj3lF1aSweo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706999114; c=relaxed/simple;
	bh=MKmLXZMrJ1wiSwqJ1VzXPKnFW9BC0ErTaacJqGnGYMM=;
	h=Date:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 From:To:Cc:Subject:References:In-Reply-To; b=EWiut43TDR8CsQKUyRDuzfJbHtfMs7jWQ0NueuSMEHrA3RWY0pKH+qZ+4U+tWsaBfFN43ncIAQXkYOV7GHHTodJTMbE8J5B+auVaiEhlqQGeCt5NEoP9CZ0yv8r2TontH8RZGHOEvLwePjkhLz9eqhj2FAgeDqdm2/oES+Kgf18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=SFDtr5q9; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-68c86cc0df0so8642206d6.0
        for <linux-fscrypt@vger.kernel.org>; Sat, 03 Feb 2024 14:25:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1706999110; x=1707603910; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=HxqeVTrlhX3yEoHrEHTleq0PuEMSnGt11wiOYIkzcNw=;
        b=SFDtr5q9F700354KpAFL4Ej/gfeL4lMT5NuGcbjVdU+qtZjCVvMWzTkqd20hbOH2Em
         i9D/CBTHXLSw7ElYkiPGPBAf7oR2HdyfGVts+GL+cPSPFNzpP7fYuBY/Bz9Dv0919LV9
         Sd0OPo+dtcTaEug0ac8LlwCY8R+2WnHz1X4vpEde6wYFaLvMIe5kQ0ZTqUGafEqqNcVP
         tico4tTHFvrPCqZ228GUTYiDFno1rI3U845EJ4Q799/iW4enaqjNKRKhRzlNZmCN7Xdw
         mNnHeBBY9Hc4tqhzmjtygKnGf4OCYTff5CQsFjRfR67TIJ4Yj066zpLBUk9GdQ3Q6i0D
         XSmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706999110; x=1707603910;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=HxqeVTrlhX3yEoHrEHTleq0PuEMSnGt11wiOYIkzcNw=;
        b=aXUK1cY2T1Uq5dcGmenXCDzSNxpMweHJJ23PRBw9eFoMewCP5dbf83ZzREnZNJwOOo
         CtIIP59YAJmkMk1zOEKZWMjT0jvGkO1b3kryOve3uozFK0Hf7dJdsGadOYvEMHcBTw1m
         0+FBV4H6D+kgBQQ7aaNL/Fn1oPme1lGaXmCvY738TgAnFq5q+AI5Rz/IANtPob15a4/Z
         xum8nc3twFeXXl7xlsnOXSXzazwVzZRegJTe8ZsxthS/jh8UHtgrDBHfXdfTmfrcaKXE
         xQZaa/CdLQESbcf6+uHcbaw9NV9EG/8VMPE+aNmlvr1D1TCzYERQ0OnvsO2z1aZXSnyG
         bSmQ==
X-Gm-Message-State: AOJu0Yz9zIzeQ09e5n1040F3y7tiUrB+z4dA3K10YoEE12pULg7GvF4t
	HVAtSAzc3mad7EZEn0FzrLejX8EcsWkBc0cmHWukllg2D7+3hCXfskvXMlUPNQ==
X-Google-Smtp-Source: AGHT+IEx4K2dPSOjAx9Hgsk0nrPlx89yHukHJP8vzYQLg/LIr1zgwxkCRVUHmmp8Wn0+Im7mUNWYnw==
X-Received: by 2002:a05:6214:2622:b0:68c:5c39:5f15 with SMTP id gv2-20020a056214262200b0068c5c395f15mr3714534qvb.34.1706999110377;
        Sat, 03 Feb 2024 14:25:10 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCV6ig5NUZB5VduOEkXT+5VnRcIvatsV7bvjQtvLQp1QM74Ps13S8xj4uVXHbq7WSITZ+gVG/XPnU2S3jYRSnj+t6j9cIL8rTKGPXDFgo11YiFfzu1gf13qCsKzUQBu3WspNEIRQKrFlHnIQ6MJ/tXJruD2eovRyL1jkY4gY21BDbnOR82Hnm/yZRw+TUDjrFvOyNru33dWonqvhViSBUTOdl9va6907AcodbMJeu68vq+TJ7X8E2Xu6OoM2QD2RbrRI1DMjI1hIIu9/1ZwaPCtWQkqsk/CUlrCS3zfrKa8T0yC4KRXgP3OO1PfC2Hjc+wD8cCcDkGrE9jyinNwSIVdy1iIO5zkTM+5qbyG15+xncFigOtnCSge1w8zvlTfTsHRnKiLApmREocrcI+fDKAHX4RmNAIzad2+iidNITgkyecLr1Vud7M7eIJOScxBGHX7zPQaE+sBAiOqFXufcJL5npOs0w+LPOU+WfcuzwAPc4fC9jvAwpCdv/5vBl8ZxsysMkgEtu1jwF2GXWOkkYOU5eXNnrzHxEW/8s2H9pRUHm4PA9ZjPo/VfdZck+gycrtWIpSb24+tvomFrD3bOefs4qfXyzk+zv5U6v9bXK7g05s2fqiC2YEFv
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id u14-20020a0cf88e000000b006848cc2817esm2185250qvn.33.2024.02.03.14.25.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Feb 2024 14:25:09 -0800 (PST)
Date: Sat, 03 Feb 2024 17:25:09 -0500
Message-ID: <44f88fef412127a795f4219ad9f9c6b8@paul-moore.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0 
Content-Type: text/plain; charset=utf-8 
Content-Disposition: inline 
Content-Transfer-Encoding: 8bit
From: Paul Moore <paul@paul-moore.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Cc: linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, linux-kernel@vger.kernel.org, Fan Wu <wufan@linux.microsoft.com>, Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [PATCH RFC v12 6/20] ipe: introduce 'boot_verified' as a trust  provider
References: <1706654228-17180-7-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1706654228-17180-7-git-send-email-wufan@linux.microsoft.com>

On Jan 30, 2024 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> IPE is designed to provide system level trust guarantees, this usually
> implies that trust starts from bootup with a hardware root of trust,
> which validates the bootloader. After this, the bootloader verifies
> the kernel and the initramfs.
> 
> As there's no currently supported integrity method for initramfs, and
> it's typically already verified by the bootloader. This patch introduces
> a new IPE property `boot_verified` which allows author of IPE policy to
> indicate trust for files from initramfs.
> 
> The implementation of this feature utilizes the newly added
> `unpack_initramfs` hook. This hook marks the superblock of the rootfs
> after the initramfs has been unpacked into it.
> 
> Since the rootfs is never unmounted during system operation, it is
> advised to switch to a different policy that doesn't rely on the
> `boot_verified` property after the real rootfs is in charge.
> This ensures that the trust policies remain relevant and effective
> throughout the system's operation.

To be clear, most (all?) init systems cleanup the initial rootfs and
mount another filesystem on top of it during the boot process, correct?
That should probably be mentioned in the commit description, perhaps
with references to the pivot_root(2) and switch_root(8) docs.

While I don't disagree with your recommendation above, I do believe
it is unnecessarily scary sounding.

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
>   + Reword and refactor patch 04/12 to [09/16], based on changes in
> the underlying system.
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
> 
> v12:
>   + Switch to use unpack_initramfs hook and security blob
> ---
>  security/ipe/eval.c          | 68 +++++++++++++++++++++++++++++++++++-
>  security/ipe/eval.h          |  9 +++++
>  security/ipe/hooks.c         |  8 +++++
>  security/ipe/hooks.h         |  4 +++
>  security/ipe/ipe.c           | 14 ++++++++
>  security/ipe/ipe.h           |  3 ++
>  security/ipe/policy.h        |  2 ++
>  security/ipe/policy_parser.c | 37 +++++++++++++++++++-
>  8 files changed, 143 insertions(+), 2 deletions(-)

More comments below, but one thing I wanted to mention at the top is
that I believe there is too much conditional compilation depending on
the state of CONFIG_BLK_DEV_INITRD.  While there is noting wrong about
this from a correctness perspective, I believe the reality is that
the vast majority of systems these days are built with this enabled,
and having all these pre-processor checks adds to the complexity of
the code.  Additional comments about this below ...

> diff --git a/security/ipe/eval.c b/security/ipe/eval.c
> index 4f425afffcad..546bbc52a071 100644
> --- a/security/ipe/eval.c
> +++ b/security/ipe/eval.c
> @@ -16,6 +16,24 @@
>  
>  struct ipe_policy __rcu *ipe_active_policy;
>  
> +#define FILE_SUPERBLOCK(f) ((f)->f_path.mnt->mnt_sb)
> +
> +#ifdef CONFIG_BLK_DEV_INITRD
> +/**
> + * build_ipe_sb_ctx - Build from_initramfs field of an evaluation context.
> + * @ctx: Supplies a pointer to the context to be populated.
> + * @file: Supplies the file struct of the file triggered IPE event.
> + */
> +static void build_ipe_sb_ctx(struct ipe_eval_ctx *ctx, const struct file *const file)
> +{
> +	ctx->from_initramfs = ipe_sb(FILE_SUPERBLOCK(file))->is_initramfs;
> +}
> +#else
> +static void build_ipe_sb_ctx(struct ipe_eval_ctx *ctx, const struct file *const file)
> +{
> +}
> +#endif /* CONFIG_BLK_DEV_INITRD */

If you move the @file NULL check into build_ipe_sb_ctx() you can save
a comparison in the !CONFIG_BLK_DEV_INITRD case:

#ifdef CONFIG_BLK_DEV_INITRD
void build(...)
{
  if (file)
    ctx->initramfs = ipe_sb(file);
  else
    ctx->initramfs = false;
}
#else
void build(...)
{
  ctx->initramfs = false;
}
#endif

NOTE: see my comment below about always enabling the initramfs boolean
in @ipe_eval_ctx and other structs.

>  /**
>   * build_eval_ctx - Build an evaluation context.
>   * @ctx: Supplies a pointer to the context to be populated.
> @@ -28,8 +46,49 @@ void build_eval_ctx(struct ipe_eval_ctx *ctx,
>  {
>  	ctx->file = file;
>  	ctx->op = op;
> +
> +	if (file)
> +		build_ipe_sb_ctx(ctx, file);
> +}

See my comment above regarding the @file NULL check.

> +#ifdef CONFIG_BLK_DEV_INITRD
> +/**
> + * evaluate_boot_verified_true - Evaluate @ctx for the boot verified property.
> + * @ctx: Supplies a pointer to the context being evaluated.
> + *
> + * Return:
> + * * true	- The current @ctx match the @p
> + * * false	- The current @ctx doesn't match the @p
> + */
> +static bool evaluate_boot_verified_true(const struct ipe_eval_ctx *const ctx)
> +{
> +	return ctx->from_initramfs;
>  }
>  
> +/**
> + * evaluate_boot_verified_false - Evaluate @ctx for the boot verified property.
> + * @ctx: Supplies a pointer to the context being evaluated.
> + *
> + * Return:
> + * * true	- The current @ctx match the @p
> + * * false	- The current @ctx doesn't match the @p
> + */
> +static bool evaluate_boot_verified_false(const struct ipe_eval_ctx *const ctx)
> +{
> +	return !evaluate_boot_verified_true(ctx);
> +}
> +#else
> +static bool evaluate_boot_verified_true(const struct ipe_eval_ctx *const ctx)
> +{
> +	return false;
> +}
> +
> +static bool evaluate_boot_verified_false(const struct ipe_eval_ctx *const ctx)
> +{
> +	return false;
> +}
> +#endif /* CONFIG_BLK_DEV_INITRD */

That is a lot of lines of code just to check a single boolean value.
I understand the layers of abstraction, but this looks a bit excessive
to me.  Assuming you agree with the other comments in this email
regarding always including an initramfs flag in @ipe_eval_ctx, I think
you could reduce all of the above into one single line function as shown
below, and just negate it as needed in evaluate_property().

static bool evaluate_boot_verified(ctx)
{
  return ctx->initramfs;
}

>  /**
>   * evaluate_property - Analyze @ctx against a property.
>   * @ctx: Supplies a pointer to the context to be evaluated.
> @@ -42,7 +101,14 @@ void build_eval_ctx(struct ipe_eval_ctx *ctx,
>  static bool evaluate_property(const struct ipe_eval_ctx *const ctx,
>  			      struct ipe_prop *p)
>  {
> -	return false;
> +	switch (p->type) {
> +	case IPE_PROP_BOOT_VERIFIED_FALSE:
> +		return evaluate_boot_verified_false(ctx);
> +	case IPE_PROP_BOOT_VERIFIED_TRUE:
> +		return evaluate_boot_verified_true(ctx);

According to my comment above:

  case IPE_PROP_BOOT_VERIFIED_FALSE:
    return !evaludate_boot_verified(ctx);
  case IPE_PROP_BOOT_VERIFIED_TRUE:
    return evaludate_boot_verified(ctx);

> +	default:
> +		return false;
> +	}
>  }
>  
>  /**
> diff --git a/security/ipe/eval.h b/security/ipe/eval.h
> index cfdf3c8dfe8a..7d79fdb63bbf 100644
> --- a/security/ipe/eval.h
> +++ b/security/ipe/eval.h
> @@ -15,10 +15,19 @@
>  
>  extern struct ipe_policy __rcu *ipe_active_policy;
>  
> +#ifdef CONFIG_BLK_DEV_INITRD
> +struct ipe_sb {
> +	bool is_initramfs;
> +}

You've already got a function named "ipe_sb()", I would suggest saving
us all some headaches by renaming the above to "ipe_superblock" or
something similar.  The point is to not have a struct and a function
with the same name.

I also think you can shorten the field name to "initramfs", it's
defined as a boolean flag so I'm not sure the "is_" prefix lends any
useful hints but does make for longer lines, more typing, etc.

> +#endif /* CONFIG_BLK_DEV_INITRD */
> +
>  struct ipe_eval_ctx {
>  	enum ipe_op_type op;
>  
>  	const struct file *file;
> +#ifdef CONFIG_BLK_DEV_INITRD
> +	bool from_initramfs;
> +#endif /* CONFIG_BLK_DEV_INITRD */
>  };

I suppose I understand the desire to make the @from_initramfs
conditional to potentially reduce the size of @ipe_eval_ctx when it is
not needed, however, I believe in the vast majority of systems we are
going to see CONFIG_BLK_DEV_INITRD enabled so I believe this adds a lot
extra code noise for little practical benefit.

Similarly to ipe_sb::is_initramfs, I think you can rename this field to
"initramfs" and we would all be better for the change.

>  void build_eval_ctx(struct ipe_eval_ctx *ctx, const struct file *file, enum ipe_op_type op);
> diff --git a/security/ipe/hooks.c b/security/ipe/hooks.c
> index 3aec88c074e1..8ee105bf7bad 100644
> --- a/security/ipe/hooks.c
> +++ b/security/ipe/hooks.c
> @@ -4,6 +4,7 @@
>   */
>  
>  #include <linux/fs.h>
> +#include <linux/fs_struct.h>
>  #include <linux/types.h>
>  #include <linux/binfmts.h>
>  #include <linux/mman.h>
> @@ -181,3 +182,10 @@ int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents)
>  	build_eval_ctx(&ctx, NULL, op);
>  	return ipe_evaluate_event(&ctx);
>  }
> +
> +#ifdef CONFIG_BLK_DEV_INITRD
> +void ipe_unpack_initramfs(void)
> +{
> +	ipe_sb(current->fs->root.mnt->mnt_sb)->is_initramfs = true;
> +}
> +#endif /* CONFIG_BLK_DEV_INITRD */
> diff --git a/security/ipe/hooks.h b/security/ipe/hooks.h
> index 23205452f758..3b1bb0a6e89c 100644
> --- a/security/ipe/hooks.h
> +++ b/security/ipe/hooks.h
> @@ -22,4 +22,8 @@ int ipe_kernel_read_file(struct file *file, enum kernel_read_file_id id,
>  
>  int ipe_kernel_load_data(enum kernel_load_data_id id, bool contents);
>  
> +#ifdef CONFIG_BLK_DEV_INITRD
> +void ipe_unpack_initramfs(void);
> +#endif /* CONFIG_BLK_DEV_INITRD */
> +
>  #endif /* _IPE_HOOKS_H */
> diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
> index 22bd95116087..ed3acf6174d8 100644
> --- a/security/ipe/ipe.c
> +++ b/security/ipe/ipe.c
> @@ -5,9 +5,13 @@
>  #include <uapi/linux/lsm.h>
>  
>  #include "ipe.h"
> +#include "eval.h"
>  #include "hooks.h"
>  
>  static struct lsm_blob_sizes ipe_blobs __ro_after_init = {
> +#ifdef CONFIG_BLK_DEV_INITRD
> +	.lbs_superblock = sizeof(struct ipe_sb),
> +#endif /* CONFIG_BLK_DEV_INITRD */
>  };

I would drop the CONFIG_BLK_DEV_INITRD conditional above for reasons
already mentioned, it's also not like a running system has that many
superblocks allocated.  The increase in memory usage should be
trivial.

>  static const struct lsm_id ipe_lsmid = {
> @@ -15,12 +19,22 @@ static const struct lsm_id ipe_lsmid = {
>  	.id = LSM_ID_IPE,
>  };
>  
> +#ifdef CONFIG_BLK_DEV_INITRD
> +struct ipe_sb *ipe_sb(const struct super_block *sb)
> +{
> +	return sb->s_security + ipe_blobs.lbs_superblock;
> +}
> +#endif /* CONFIG_BLK_DEV_INITRD */

If we always have an IPE slot in the superblock's security blob, there
is not need to make the above conditional.

>  static struct security_hook_list ipe_hooks[] __ro_after_init = {
>  	LSM_HOOK_INIT(bprm_check_security, ipe_bprm_check_security),
>  	LSM_HOOK_INIT(mmap_file, ipe_mmap_file),
>  	LSM_HOOK_INIT(file_mprotect, ipe_file_mprotect),
>  	LSM_HOOK_INIT(kernel_read_file, ipe_kernel_read_file),
>  	LSM_HOOK_INIT(kernel_load_data, ipe_kernel_load_data),
> +#ifdef CONFIG_BLK_DEV_INITRD
> +	LSM_HOOK_INIT(unpack_initramfs_security, ipe_unpack_initramfs),
> +#endif /* CONFIG_BLK_DEV_INITRD */
>  };
>  
>  /**
> diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
> index a1c68d0fc2e0..f1e7c3222b6d 100644
> --- a/security/ipe/ipe.h
> +++ b/security/ipe/ipe.h
> @@ -12,5 +12,8 @@
>  #define pr_fmt(fmt) "IPE: " fmt
>  
>  #include <linux/lsm_hooks.h>
> +#ifdef CONFIG_BLK_DEV_INITRD
> +struct ipe_sb *ipe_sb(const struct super_block *sb);
> +#endif /* CONFIG_BLK_DEV_INITRD */
>  
>  #endif /* _IPE_H */
> diff --git a/security/ipe/policy.h b/security/ipe/policy.h
> index fb906f41522b..fb48024bb63e 100644
> --- a/security/ipe/policy.h
> +++ b/security/ipe/policy.h
> @@ -30,6 +30,8 @@ enum ipe_action_type {
>  #define IPE_ACTION_INVALID __IPE_ACTION_MAX
>  
>  enum ipe_prop_type {
> +	IPE_PROP_BOOT_VERIFIED_FALSE,
> +	IPE_PROP_BOOT_VERIFIED_TRUE,
>  	__IPE_PROP_MAX
>  };
>  
> diff --git a/security/ipe/policy_parser.c b/security/ipe/policy_parser.c
> index 612839b405f4..cce15f0eb645 100644
> --- a/security/ipe/policy_parser.c
> +++ b/security/ipe/policy_parser.c
> @@ -265,6 +265,14 @@ static enum ipe_action_type parse_action(char *t)
>  	return match_token(t, action_tokens, args);
>  }
>  
> +static const match_table_t property_tokens = {
> +#ifdef CONFIG_BLK_DEV_INITRD
> +	{IPE_PROP_BOOT_VERIFIED_FALSE,	"boot_verified=FALSE"},
> +	{IPE_PROP_BOOT_VERIFIED_TRUE,	"boot_verified=TRUE"},
> +#endif /* CONFIG_BLK_DEV_INITRD */

You want the "boot_verified" field to be part of the IPE policy
regardless of the state of CONFIG_BLK_DEV_INITRD, yes?  On a system
without _INITRD the TRUE case would never trigger, only the FALSE
case, which seems like the Right Thing.

It just seems wrong to me to have the policy grammar change depending
on what the kernel supports, it seems like IPE should parse and enforce
the policy regardless of the kernel's config, with the understanding
that some rules might never be satisfied as it would be impossible
for a given kernel config, e.g. "boot_verified=TRUE" on a non-initramfs
system.

I probably should have thought of this sooner, but I believe the same
applies to the dm-verity and fs-verity policy tokens.

> +	{IPE_PROP_INVALID,		NULL}
> +};
> +
>  /**
>   * parse_property - Parse the property type given a token string.
>   * @t: Supplies the token string to be parsed.
> @@ -277,7 +285,34 @@ static enum ipe_action_type parse_action(char *t)
>   */
>  static int parse_property(char *t, struct ipe_rule *r)
>  {
> -	return -EBADMSG;
> +	substring_t args[MAX_OPT_ARGS];
> +	struct ipe_prop *p = NULL;
> +	int rc = 0;
> +	int token;
> +
> +	p = kzalloc(sizeof(*p), GFP_KERNEL);
> +	if (!p)
> +		return -ENOMEM;
> +
> +	token = match_token(t, property_tokens, args);
> +
> +	switch (token) {
> +	case IPE_PROP_BOOT_VERIFIED_FALSE:
> +	case IPE_PROP_BOOT_VERIFIED_TRUE:
> +		p->type = token;
> +		break;
> +	default:
> +		rc = -EBADMSG;
> +		break;
> +	}
> +	if (rc)
> +		goto err;
> +	list_add_tail(&p->next, &r->props);
> +
> +	return rc;
> +err:
> +	kfree(p);
> +	return rc;
>  }
>  
>  /**
> -- 
> 2.43.0

--
paul-moore.com

