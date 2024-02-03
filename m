Return-Path: <linux-fscrypt+bounces-168-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E7B82848933
	for <lists+linux-fscrypt@lfdr.de>; Sat,  3 Feb 2024 23:25:52 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 1893F1C22C92
	for <lists+linux-fscrypt@lfdr.de>; Sat,  3 Feb 2024 22:25:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6A13C182B5;
	Sat,  3 Feb 2024 22:25:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="djY+nsLr"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0AC11756F
	for <linux-fscrypt@vger.kernel.org>; Sat,  3 Feb 2024 22:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706999117; cv=none; b=ZJuGuPS4kVilr4FF+ZrpUcTgEET5kGxZP5STmI6cEDcOtnp4SNSdxbAFiH5WbcmA5X5zogqm95FqM3mHhepX4HEBNpGwlhuvBiDrMsBM90j4DsWW1Ktp6smvuNaT68Z+lY2HoO7xdx2zIxV60eD/C5cvGrPgA0/wp9XdtzBXSCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706999117; c=relaxed/simple;
	bh=+fSeNkwdSlLWMIl3lzfyk6Ik8ik57S7jL/iU5RejReE=;
	h=Date:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 From:To:Cc:Subject:References:In-Reply-To; b=gAaQNBpw2UloHGEciRbCo1x74WvMRQCzpQQMKg8WCioC+s7XjLxGf2CMPSRWIEg9JCTlrKdYM/HQf1OVQm13JRpEfGXpV9gOsORr6LByBtC95YLSb63l0QdWha2nPcqrH77UmB08hYrQa2rsjglkcA6H6BrVEs0y9MThf8A0h9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=djY+nsLr; arc=none smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-42ab4f89bdbso19603961cf.0
        for <linux-fscrypt@vger.kernel.org>; Sat, 03 Feb 2024 14:25:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1706999113; x=1707603913; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=gzyXztQxdq2bE3Xby4PIQ2YJXTmtNHMMsda74TWMo30=;
        b=djY+nsLrurbaI1YTk9k5Ftj2c5nHXwTI1TjcLUK2gX9bBQ7ZsNWTstow2a2VxfnSQx
         ovAsxJAOVb5Xagd2H7w/ujsD72cWkw2MzTbVxXImn+tLxraGp0K4gkElA3AUwaSVioEw
         cU/C6oqd5uJqZTaDIw8YjiyqaOTLhUdojq5Q9AY6sa6r5SKCsIDP8U4nwzo24tOOOMGT
         zbD6V9Ktqh6AnZTq6u9r0TI0WKRM46zgbF2PGPgkNnWpLGZW+bHNaWhitYsI9qKe+OV3
         tCAG6TKh2WR/fbDGDhSzy/n9WiJGW22io82DeQMpE7X7X4tTpUsIKcf5J1ljiCrkhi1c
         z5pw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706999113; x=1707603913;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gzyXztQxdq2bE3Xby4PIQ2YJXTmtNHMMsda74TWMo30=;
        b=LRA0t3i2yzdaEatUgO9T3zV4lMYfveRDgLUB3+drkQaJmqqBYleMCWfbOLc9bI67do
         eFdC24YVh/XOH6F2pxOQ9EPcpMBwg5/vL4GkYOhZi1ezNzkBQZIZxp6UCpKLWpdCUOjV
         yNPMnKYH9fAv5CD9E/EwCVsdElSw8o5PPqlmMdcdNSu41V4xhlSoL2oGHKHJI4WuF9Yg
         u7zBXhqJ6mxaHwI3LYyLKROHyclC3GQpp0SZ8kpf2gYU7Sv98lZlxrBAUJTXtNNhavFe
         BZLWntq4G7AhwUGCqSO4FZHd1RPiiRHXno/zoShi53RlDuwNokmsxHFmFFtBuZI5qFm7
         zkTw==
X-Gm-Message-State: AOJu0YzzJg7Gb6OrNWmNiptGhcQpktAEqJsyOip+0vseSQxdxEtIrEhk
	t2FTBfTcYyXkc+5roa1sl4kMnCQZO+deiT6NmCC2HhhMHc5Ddd+GLmVhuO1vBQ==
X-Google-Smtp-Source: AGHT+IHeV0TTBdPvDJGP0j5TZ9xTE9saBj3M/xPKvbrqZXiCbyvSYP52bdso1f7HHS95Gz7TqHO/GA==
X-Received: by 2002:a05:622a:24f:b0:42c:c26:78f5 with SMTP id c15-20020a05622a024f00b0042c0c2678f5mr2911367qtx.46.1706999113409;
        Sat, 03 Feb 2024 14:25:13 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCVuY0T3ip8Fsoc4YOXsxEiSML+PXXAj7BdcQERzWW7YMnNONZ7M6to4B/uXE6/Q2IM9ijQ16YLuMXfn6iwWxGIX1ywdnqnYWflhqV1XouK2Irav754ejbgfiIVI2DLhZQPNulUp9qVHD8e+4B2fq+atfCTExNLldLSVwSGfyMIvarJJTv30NFr3ntoR3iqHnex23Jm7vWUEAddJXXnlITb6S9PKA625NAXJfBa/iBszvAsCpgg1O7m9MP1rsTT+qYHN6TsNkLFIlUpfWsCo6hF3kYwVjCMWh0zzqqfG6hM0+cCI7mRqZKZRdbo0f57rmoX8x4usfqtgebxmGD0+bmGLeFqdaMVJSV7ADTG1asx+XPfamgIMQae75XkpYXrNAu6/4o+eHD1J746/OiQIpMJwhz8C/6fHh+bL+cBWQ8qoIr5Cx1Hd6rswKRawTC0U95+t0O+DIO4SUeO7nzDW8NIQp5leTSzNkIlPH4y4ZBGmgZYseDBvFSxuIVQcL+yH5tOyDeW7sGBFRkyup+3VY/OQ3ihjS1empZSwya8w5sKY5Mp8UZebToJ7jsHYmBxKjwzgk2S9874rUdk6CwfUbOJ2GKoQUhjX8UBpJ9vzOvTP5AbOjb/ZvJfH
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id j13-20020ac84f8d000000b0042ab59ccd6csm2163130qtw.4.2024.02.03.14.25.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Feb 2024 14:25:13 -0800 (PST)
Date: Sat, 03 Feb 2024 17:25:12 -0500
Message-ID: <1e8f6bbac94d62da330262af871aaa98@paul-moore.com>
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
Cc: linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org, linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org, dm-devel@lists.linux.dev, audit@vger.kernel.org, linux-kernel@vger.kernel.org, Deven Bowers <deven.desai@linux.microsoft.com>, Fan Wu <wufan@linux.microsoft.com>
Subject: Re: [PATCH RFC v12 10/20] ipe: add permissive toggle
References: <1706654228-17180-11-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1706654228-17180-11-git-send-email-wufan@linux.microsoft.com>

On Jan 30, 2024 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> IPE, like SELinux, supports a permissive mode. This mode allows policy
> authors to test and evaluate IPE policy without it effecting their
> programs. When the mode is changed, a 1404 AUDIT_MAC_STATUS
> be reported.
> 
> This patch adds the following audit records:
> 
>     audit: MAC_STATUS enforcing=0 old_enforcing=1 auid=4294967295
>       ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
>     audit: MAC_STATUS enforcing=1 old_enforcing=0 auid=4294967295
>       ses=4294967295 enabled=1 old-enabled=1 lsm=ipe res=1
> 
> The audit record only emit when the value from the user input is
> different from the current enforce value.
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
>   + Further split lsm creation into a separate commit from the
>     evaluation loop and audit system, for easier review.
>   + Propagating changes to support the new ipe_context structure in the
>     evaluation loop.
>   + Split out permissive functionality into a separate patch for easier
>     review.
>   + Remove permissive switch compile-time configuration option - this
>     is trivial to add later.
> 
> v8:
>   + Remove "IPE" prefix from permissive audit record
>   + align fields to the linux-audit field dictionary. This causes the
>     following fields to change:
>       enforce -> permissive
> 
>   + Remove duplicated information correlated with syscall record, that
>     will always be present in the audit event.
>   + Change audit types:
>     + AUDIT_TRUST_STATUS -> AUDIT_MAC_STATUS
>       + There is no significant difference in meaning between
>         these types.
> 
> v9:
>   + Clean up ipe_context related code
> 
> v10:
>   + Change audit format to comform with the existing format selinux is
>     using
>   + Remove the audit record emission during init to align with selinux,
>     which does not perform this action.
> 
> v11:
>   + Remove redundant code
> 
> v12:
>   + Remove redundant code
> ---
>  security/ipe/audit.c | 27 ++++++++++++++++--
>  security/ipe/audit.h |  1 +
>  security/ipe/eval.c  | 11 +++++--
>  security/ipe/eval.h  |  1 +
>  security/ipe/fs.c    | 68 ++++++++++++++++++++++++++++++++++++++++++++
>  5 files changed, 104 insertions(+), 4 deletions(-)
> 
> diff --git a/security/ipe/audit.c b/security/ipe/audit.c
> index 79b7af25085c..ed390d32c641 100644
> --- a/security/ipe/audit.c
> +++ b/security/ipe/audit.c
> @@ -27,6 +27,9 @@
>  				    "new_active_pol_version=%hu.%hu.%hu "\
>  				    "new_policy_digest=" IPE_AUDIT_HASH_ALG ":"
>  
> +#define AUDIT_ENFORCE_CHANGE_FMT "enforcing=%d old_enforcing=%d auid=%u ses=%u "\
> +				 "enabled=1 old-enabled=1 lsm=ipe res=1"

It looks like you only ever use this in one place, it would probably be
better to skip the macro definition in this case as it can make it
easier to have a disconnect between the format string and the data.

>  static const char *const audit_op_names[__IPE_OP_MAX + 1] = {
>  	"EXECUTE",
>  	"FIRMWARE",
> @@ -95,8 +98,8 @@ void ipe_audit_match(const struct ipe_eval_ctx *const ctx,
>  	if (!ab)
>  		return;
>  
> -	audit_log_format(ab, "ipe_op=%s ipe_hook=%s pid=%d comm=",
> -			 op, audit_hook_names[ctx->hook],
> +	audit_log_format(ab, "ipe_op=%s ipe_hook=%s enforcing=%d pid=%d comm=",
> +			 op, audit_hook_names[ctx->hook], READ_ONCE(enforce),
>  			 task_tgid_nr(current));
>  	audit_log_untrustedstring(ab, get_task_comm(comm, current));
>  
> @@ -210,3 +213,23 @@ void ipe_audit_policy_load(const struct ipe_policy *const p)
>  
>  	audit_log_end(ab);
>  }
> +
> +/**
> + * ipe_audit_enforce - Audit a change in IPE's enforcement state.
> + * @new_enforce: The new value enforce to be set.
> + * @old_enforce: The old value currently in enforce.
> + */
> +void ipe_audit_enforce(bool new_enforce, bool old_enforce)
> +{
> +	struct audit_buffer *ab;
> +
> +	ab = audit_log_start(audit_context(), GFP_KERNEL, AUDIT_MAC_STATUS);
> +	if (!ab)
> +		return;
> +
> +	audit_log_format(ab, AUDIT_ENFORCE_CHANGE_FMT, new_enforce, old_enforce,
> +			 from_kuid(&init_user_ns, audit_get_loginuid(current)),
> +			 audit_get_sessionid(current));
> +
> +	audit_log_end(ab);
> +}

--
paul-moore.com

