Return-Path: <linux-fscrypt+bounces-165-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 42163848920
	for <lists+linux-fscrypt@lfdr.de>; Sat,  3 Feb 2024 23:25:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40ACE1C20D4F
	for <lists+linux-fscrypt@lfdr.de>; Sat,  3 Feb 2024 22:25:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8C4BC168CD;
	Sat,  3 Feb 2024 22:25:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="UslhFOVg"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F51516423
	for <linux-fscrypt@vger.kernel.org>; Sat,  3 Feb 2024 22:25:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.222.177
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706999112; cv=none; b=ObtKovbBzl1lmJR5lsNoGjg3a/FYAabl0NQa1SQ28FE1NNId2fQzmIPILesDbvZs53QptXimHRJu/ZmgVIKqWczccptAMY8t2+H4VYji+dNQNoOjjSuJCBP2Q2qs6ptUKzkS9qYLCisRalyCwxKDFzrNsb9i+shmZjKsqf2ioy0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706999112; c=relaxed/simple;
	bh=Akk3yfd0skBsyfpDvBuTijI4DTSE1uDMrPs5axVSpcY=;
	h=Date:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 From:To:Cc:Subject:References:In-Reply-To; b=fYdnHq/LfuPA2FZ5wJlniTJdTXmV6m3IzQNXMho4+4azVxPM1N34yAF9Ye5C2seI01vr9HxpVZRlExhvstNd9Qp+pObJPBKWrha3MfMe19ctInSRvBLvt8u0FXzyAsKAaWR317iXFnrMEkDTbrY1MDd3wpURlU7oKx7zhzpxaX0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=UslhFOVg; arc=none smtp.client-ip=209.85.222.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-7853fcc314bso218478885a.1
        for <linux-fscrypt@vger.kernel.org>; Sat, 03 Feb 2024 14:25:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1706999109; x=1707603909; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=DnWesDs8xRNqrKgsSJ7fCUj/XnlBG4IvaiEQPBxCK/I=;
        b=UslhFOVg8WFUzqld2FRyTxItmLSnj0ByEQAtAEokRfNrtL65h4jolouj4Q0KaXgy7I
         dwWBbtq75NLmwEzjqHnxX6ovf74HGb/+eQ1u5u3cDuR962nRMBIQAHO2pklMJs5VEtFF
         J2KCZKGZqiH1GAnqMx/jR6Kw1zADG154LUO/sPqRF9z5CqmPx0YjEUQsIW35qgmWb16q
         3UaVjFXAR/V/Ibmrl6bz95E4lv1HC+gW2jdbko6h6uNedJrm2Y8zlf0v1gBV7qgbdbqz
         HidKBzGH5j3uX3pnyQRpaiw5EN+leF/d42mepu7qrwQGlfYFPxBsNV0AKjK0W8M46hI/
         AMkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706999109; x=1707603909;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=DnWesDs8xRNqrKgsSJ7fCUj/XnlBG4IvaiEQPBxCK/I=;
        b=nz9JdTyvvnCqxCgxxRm/KWnwsgV8e/eDaWyabrZsRSHSjwBkw0I8Q6goi6Y9E+rxVw
         gm3P3fVAvst/vWc8+gxoJiah857wtm60AhKwbV1LQfZqAfzeU6tukapP2mKb4amh2uFX
         DyYMBLb28rKGs6fA53Z9xZniRxWakk+Gkelaknp6P3SC82tcDIRcIRB0MzwTvYgqCiRb
         a4K3FJoHN4ClvKm2wzhkXtvGykFgDx994CXru2cyTn2l2NKcfY0WDrdXjTduLyOz4W+F
         TOMBzuuFFj3JZrGQeLohT3HbmzJgZ09W+Rc81HEVzeIXkpehRruRzWIOSRLsFSRgtpTV
         2Sag==
X-Gm-Message-State: AOJu0YyyhIoKncrFUmCIUq8cCvsn0kIiWLVr0JC3P3nOejpL5UVQrtvU
	7JcWtGygeBBmjSz/6gYic+NetfZrfphaRZj5Z7PFNn/m8rPj4RUBmXsaGCqZLg==
X-Google-Smtp-Source: AGHT+IFtZe+Q8W1ePYytw7UeC4Jf2MOnkQ6RcSuccAbbwyK+ZuVbp0rOxBJSIWscsGRZX7r4oaJh+g==
X-Received: by 2002:a05:620a:2e3:b0:783:b038:d1a1 with SMTP id a3-20020a05620a02e300b00783b038d1a1mr9095773qko.39.1706999109324;
        Sat, 03 Feb 2024 14:25:09 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVwYaZbKyqip0VIR8GONQxXUcX8op8aMPNo2Ap1p+jdcI0F9O4QdFtfkXUh2izlay/UPxQX4uTdUnml1eWFaVIu3sl4cZN0o9MEZYPtDzuPUBt8ISFeQUgk//7oOgSqTo+LWz7pHI783WZUe7avWlFl2g4RV0ALfs6fSYnt9PmcP3V5e5UUC9OHfUN1hGOhFCEIHdwZdid79pfUdFyuN0HQ1asimEWyLDwYPGdfmyK0n3vX204PQ6L6I7qS+XYcc2+4FDbFfrLjHojE/EkYwAYSDsPcTayfqX5R0GGth4PTwEABerphUsn9JY6Cz1DdD0rhuTOjEi/XLpHp1AvDca0BRlY13p7V9uUBl5XxTmPDaaLTbmdbuj1e2I3b+GHRn4+Guw1TVTp0wlUYUAdXRnJPf1jp9/Mte8sgyYSGDJVgBLodRU8oGcMpA5MLWsHMPY5+8w5xv6eKGe3vsfBvHJH92nrGbL7ODZl7dWe1CNUDc7uQPTJqnToEqjD5Yl1fzWFBuCEy7dobme80FhUuQ9F8QqZX8GC19w5DGqXnrHRf6FF81Ob58I7Z4V+OoQ0FbylAMRBpa+pH
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id g4-20020a37e204000000b00783f534706esm1734412qki.61.2024.02.03.14.25.08
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Feb 2024 14:25:08 -0800 (PST)
Date: Sat, 03 Feb 2024 17:25:08 -0500
Message-ID: <b9ca171301d5abeb78922dd79d65136a@paul-moore.com>
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
Cc: linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, linux-kernel@vger.kernel.org, Fan Wu <wufan@linux.microsoft.com>
Subject: Re: [PATCH RFC v12 5/20] initramfs|security: Add security hook to  initramfs unpack
References: <1706654228-17180-6-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1706654228-17180-6-git-send-email-wufan@linux.microsoft.com>

On Jan 30, 2024 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> This patch introduces a new hook to notify security system that the
> content of initramfs has been unpacked into the rootfs.
> 
> Upon receiving this notification, the security system can activate
> a policy to allow only files that originated from the initramfs to
> execute or load into kernel during the early stages of booting.
> 
> This approach is crucial for minimizing the attack surface by
> ensuring that only trusted files from the initramfs are operational
> in the critical boot phase.
> 
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v1-v11:
>   + Not present
> 
> v12:
>   + Introduced
> ---
>  include/linux/lsm_hook_defs.h |  4 ++++
>  include/linux/security.h      | 10 ++++++++++
>  init/initramfs.c              |  3 +++
>  security/security.c           | 12 ++++++++++++
>  4 files changed, 29 insertions(+)
> 
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.h
> index 185924c56378..b247388786a9 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -425,3 +425,7 @@ LSM_HOOK(int, 0, uring_override_creds, const struct cred *new)
>  LSM_HOOK(int, 0, uring_sqpoll, void)
>  LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
>  #endif /* CONFIG_IO_URING */
> +
> +#ifdef CONFIG_BLK_DEV_INITRD
> +LSM_HOOK(void, LSM_RET_VOID, unpack_initramfs_security, void)
> +#endif /* CONFIG_BLK_DEV_INITRD */

Let's just call it "unpack_initramfs", the "_security" part is somewhat
implied since we are talking about a LSM hook ;)

> diff --git a/init/initramfs.c b/init/initramfs.c
> index 76deb48c38cb..075a5794cde5 100644
> --- a/init/initramfs.c
> +++ b/init/initramfs.c
> @@ -18,6 +18,7 @@
>  #include <linux/init_syscalls.h>
>  #include <linux/task_work.h>
>  #include <linux/umh.h>
> +#include <linux/security.h>
>  
>  static __initdata bool csum_present;
>  static __initdata u32 io_csum;
> @@ -720,6 +721,8 @@ static void __init do_populate_rootfs(void *unused, async_cookie_t cookie)
>  #endif
>  	}
>  
> +	security_unpack_initramfs();

Given the caller, what do you think of changing the hook name to
"security_initramfs_populated()"?  I think this not only matches up
better with the caller, "do_populate_rootfs()", but since in using the
past tense we help indicate that this hook happens *after* the rootfs
is populated with the initramfs data.

>  done:
>  	/*
>  	 * If the initrd region is overlapped with crashkernel reserved region,
> diff --git a/security/security.c b/security/security.c
> index ddf2e69cf8f2..2a527d4c69bc 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -5581,3 +5581,15 @@ int security_uring_cmd(struct io_uring_cmd *ioucmd)
>  	return call_int_hook(uring_cmd, 0, ioucmd);
>  }
>  #endif /* CONFIG_IO_URING */
> +
> +#ifdef CONFIG_BLK_DEV_INITRD
> +/**
> + * security_unpack_initramfs() - Notify LSM that initramfs has been loaded
> + *
> + * Tells the LSM the initramfs has been unpacked into the rootfs.
> + */
> +void security_unpack_initramfs(void)
> +{
> +	call_void_hook(unpack_initramfs_security);
> +}
> +#endif /* CONFIG_BLK_DEV_INITRD */
> -- 
> 2.43.0

--
paul-moore.com

