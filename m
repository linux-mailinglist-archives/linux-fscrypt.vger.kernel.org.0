Return-Path: <linux-fscrypt+bounces-169-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 259E084893C
	for <lists+linux-fscrypt@lfdr.de>; Sat,  3 Feb 2024 23:26:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D303B284877
	for <lists+linux-fscrypt@lfdr.de>; Sat,  3 Feb 2024 22:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 172E01CD0B;
	Sat,  3 Feb 2024 22:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b="PFIFmNHR"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-qv1-f52.google.com (mail-qv1-f52.google.com [209.85.219.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2273217551
	for <linux-fscrypt@vger.kernel.org>; Sat,  3 Feb 2024 22:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706999118; cv=none; b=t3CCq4zK73UezxEIVIpDOK7U9Lc1THV0iAEQMvEAE7StI8gTOniQ5otnfWKsusv9lz2IJEXmSkmyTpSD7CUlx2xZWdAB8xklzm+UH5dz+LCRynI1L6SDZcs9hmzARO7T+pt17TTI274mOVC6DwCbms1wzy5q2z4GceFiI/8kNNs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706999118; c=relaxed/simple;
	bh=3ztzxjwdFWo2aRQAJna3nsAel/RLxGtTJmcBQeDLi5E=;
	h=Date:Message-ID:MIME-Version:Content-Type:Content-Disposition:
	 From:To:Cc:Subject:References:In-Reply-To; b=fubSwHLKwG2jeG9p/KWYSr+f19z2nxDWieVJnkXf03/amYwDK/pys8fw+CgbFHIZzQ8clBLLCAmITtqud7wE34Zxy7clUEyyeGi64jLExWTsAQWeIZ8TOFxGf1dan5rHc5sks3T2bFAGqWMRdzXxm0a2UFycwVw5uKcxHU5mQ5g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com; spf=pass smtp.mailfrom=paul-moore.com; dkim=pass (2048-bit key) header.d=paul-moore.com header.i=@paul-moore.com header.b=PFIFmNHR; arc=none smtp.client-ip=209.85.219.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=paul-moore.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=paul-moore.com
Received: by mail-qv1-f52.google.com with SMTP id 6a1803df08f44-68c3a14c6e7so15720786d6.1
        for <linux-fscrypt@vger.kernel.org>; Sat, 03 Feb 2024 14:25:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google; t=1706999112; x=1707603912; darn=vger.kernel.org;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:from:to:cc:subject
         :date:message-id:reply-to;
        bh=36T6G7nLsBOPlZbJneB+42xI8//a+iMUkv+sIps39Ns=;
        b=PFIFmNHRQVsDOjgxOw0eRqS8/JR/KcuKUN59gY0xApdxCIJ/wN4Ea2yMOKWJ3BuYD7
         j17VpHt5yf0r/PeySeisaMbFebOs3SWYOBCOBMg9ASR/NmJ1UxYVgALyb31SYuwG7UL0
         3l64WaUKXMA45+vFyeSXYwYmYCZAEAUmF9ExEozoNFTFtAUAK3qo2+BtusRmKCDGTab7
         4RUp1tzq9ZMFfDKonCgdQARMf8LUuwfpXUz8ouqhmje9Ai4qve/F9QFzgWMbiSQ8TR1X
         MOhhIypa5RbYfCqI09yyOPKmlTjLobjNSbqQXGxEkfrmSoyvgu/e2Lk7WpmrJezysMpz
         tp4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1706999112; x=1707603912;
        h=in-reply-to:references:subject:cc:to:from:content-transfer-encoding
         :content-disposition:mime-version:message-id:date:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=36T6G7nLsBOPlZbJneB+42xI8//a+iMUkv+sIps39Ns=;
        b=NQZuuzoPPcScjrjfWTQ0rdhYKS/gwTIQgc3WVrkreEAebdxcZlZ7FR8DOzcCc+RbNt
         ChS+XuJn8pVEODAiBEpG3dknO9lCfNhm7RvrymhNA60SOKvwGfk7HJvc1Fp6bgbY4siI
         zPPzkYCqMwujcEPu5fxJIwYILMTXsvfM9MdRutH6guVeJTRSAQ/8C42kQ6XxEEi7vOUC
         vfINiRg9mUGupGx2JUciAV/Z4ZuCciQHeZ5mhZWUH5WmZL0vUCovlMTRS5+nyfO6+k+B
         Bc2E3Mx4fI+ogtPbSM+UG/jmhhZ2MmX7oR7juFno75/XMif0YAEj+FooN5migb8PAL+B
         LafA==
X-Gm-Message-State: AOJu0YwIppMBa9ikvgw7o6kjRSYg7XvMY2emq2DzCWPQbuIU6GLSrzP/
	5XAscFKgSCj7lwOLHty2uNRzduWKfKWl42dSj6QylJkTHjEp5e0AyWnnZaD8PA==
X-Google-Smtp-Source: AGHT+IEv2CnIOKuawGLYE6rFGzRj31eo5OuqlybxY/nrKh3BNB267rYsEu0rttRMA+E0ociy47JtyQ==
X-Received: by 2002:a05:6214:21ef:b0:686:a11d:5ce9 with SMTP id p15-20020a05621421ef00b00686a11d5ce9mr3312489qvj.15.1706999112535;
        Sat, 03 Feb 2024 14:25:12 -0800 (PST)
X-Forwarded-Encrypted: i=0; AJvYcCWAk0yDn7F4VJHF5IfNpmK+ESq2SxZxJ5XrPfe7jcavhA0CIEVgQZ1s4GE7ad9cEUM/aJkj+pwp8sjzsU6Pq8ZDZIN7WpJRlbM5+NZuiSq9PxoDERFGH6fU8qohxz7P0HwfM1Dz2qGLyBaLd0c6n3waGIFyQuKIx989ydja5+AlQUZjkDIWZW8CoyEzW1NQB5QKyaeFU+M8D4xr+/tpsfGx3ToJHCF56auQ937tsQ3b3zlYSOYJdpQvv4UU72xM3Hi+nFCQhBGmNeyJ0eQ2p4MC0RfRjkb/kAdoimJ8lC95Ze1Wo9eBNB1AC9gAW3bE46iXWvNAIw0Jm6j/GDdabUZey0C0pDhgSMpwup+tREvmwDFRflsp3jfVJR2U8Ef5bg9l/dLlKEhOHD8Hi/Q/kvDthXFVTyhL1EphyK64A3E8F+xFRiwf7lyDY82Xcl5V/9zobljW3JexJM3V9qtKYoEoA7OqeL3sKFprsgQlNTtPnXiogFrxoDav4lizdx9BRVaUZERhg35z9OCMoQja3gVuhT4gYjkqFlBK2rr7dhfFJzuQBUrIf7rz8IJ1AqYCGBgFgum+xiufoBJSiGBWU7CgMhTrtdSpb8Jo8x1LyhS9cnJSjOV2E+JB
Received: from localhost ([70.22.175.108])
        by smtp.gmail.com with ESMTPSA id nh17-20020a056214391100b0068509353fb6sm2169488qvb.133.2024.02.03.14.25.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 03 Feb 2024 14:25:12 -0800 (PST)
Date: Sat, 03 Feb 2024 17:25:11 -0500
Message-ID: <16ecd49f9528749e288c8a4cc73c4425@paul-moore.com>
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
Subject: Re: [PATCH RFC v12 9/20] uapi|audit|ipe: add ipe auditing support
References: <1706654228-17180-10-git-send-email-wufan@linux.microsoft.com>
In-Reply-To: <1706654228-17180-10-git-send-email-wufan@linux.microsoft.com>

On Jan 30, 2024 Fan Wu <wufan@linux.microsoft.com> wrote:
> 
> Users of IPE require a way to identify when and why an operation fails,
> allowing them to both respond to violations of policy and be notified
> of potentially malicious actions on their systems with respect to IPE
> itself.
> 
> This patch introduces 3 new audit events.
> 
> AUDIT_IPE_ACCESS(1420) indicates the result of an IPE policy evaluation
> of a resource.
> AUDIT_IPE_CONFIG_CHANGE(1421) indicates the current active IPE policy
> has been changed to another loaded policy.
> AUDIT_IPE_POLICY_LOAD(1422) indicates a new IPE policy has been loaded
> into the kernel.
> 
> This patch also adds support for success auditing, allowing users to
> identify why an allow decision was made for a resource. However, it is
> recommended to use this option with caution, as it is quite noisy.
> 
> Here are some examples of the new audit record types:
> 
> AUDIT_IPE_ACCESS(1420):
> 
>     audit: AUDIT1420 ipe_op=EXECUTE ipe_hook=BPRM_CHECK enforcing=1
>       pid=297 comm="sh" path="/root/vol/bin/hello" dev="tmpfs"
>       ino=3897 rule="op=EXECUTE boot_verified=TRUE action=ALLOW"
> 
>     audit: AUDIT1420 ipe_op=EXECUTE ipe_hook=BPRM_CHECK enforcing=1
>       pid=299 comm="sh" path="/mnt/ipe/bin/hello" dev="dm-0"
>       ino=2 rule="DEFAULT action=DENY"
> 
>     audit: AUDIT1420 ipe_op=EXECUTE ipe_hook=BPRM_CHECK enforcing=1
>      pid=300 path="/tmp/tmpdp2h1lub/deny/bin/hello" dev="tmpfs"
>       ino=131 rule="DEFAULT action=DENY"
> 
> The above three records were generated when the active IPE policy only
> allows binaries from the initramfs to run. The three identical `hello`
> binary were placed at different locations, only the first hello from
> the rootfs(initramfs) was allowed.
> 
> Field ipe_op followed by the IPE operation name associated with the log.
> 
> Field ipe_hook followed by the name of the LSM hook that triggered the IPE
> event.
> 
> Field enforcing followed by the enforcement state of IPE. (it will be
> introduced in the next commit)
> 
> Field pid followed by the pid of the process that triggered the IPE
> event.
> 
> Field comm followed by the command line program name of the process that
> triggered the IPE event.
> 
> Field path followed by the file's path name.
> 
> Field dev followed by the device name as found in /dev where the file is
> from.
> Note that for device mappers it will use the name `dm-X` instead of
> the name in /dev/mapper.
> For a file in a temp file system, which is not from a device, it will use
> `tmpfs` for the field.
> The implementation of this part is following another existing use case
> LSM_AUDIT_DATA_INODE in security/lsm_audit.c
> 
> Field ino followed by the file's inode number.
> 
> Field rule followed by the IPE rule made the access decision. The whole
> rule must be audited because the decision is based on the combination of
> all property conditions in the rule.
> 
> Along with the syscall audit event, user can know why a blocked
> happened. For example:
> 
>     audit: AUDIT1420 ipe_op=EXECUTE ipe_hook=BPRM_CHECK enforcing=1
>       pid=2138 comm="bash" path="/mnt/ipe/bin/hello" dev="dm-0"
>       ino=2 rule="DEFAULT action=DENY"
>     audit[1956]: SYSCALL arch=c000003e syscall=59
>       success=no exit=-13 a0=556790138df0 a1=556790135390 a2=5567901338b0
>       a3=ab2a41a67f4f1f4e items=1 ppid=147 pid=1956 auid=4294967295 uid=0
>       gid=0 euid=0 suid=0 fsuid=0 egid=0 sgid=0 fsgid=0 tty=pts0
>       ses=4294967295 comm="bash" exe="/usr/bin/bash" key=(null)
> 
> The above two records showed bash used execve to run "hello" and got
> blocked by IPE. Note that the IPE records are always prior to a SYSCALL
> record.
> 
> AUDIT_IPE_CONFIG_CHANGE(1421):
> 
>     audit: AUDIT1421
>       old_active_pol_name="Allow_All" old_active_pol_version=0.0.0
>       old_policy_digest=sha256:E3B0C44298FC1C149AFBF4C8996FB92427AE41E4649
>       new_active_pol_name="boot_verified" new_active_pol_version=0.0.0
>       new_policy_digest=sha256:820EEA5B40CA42B51F68962354BA083122A20BB846F
>       auid=4294967295 ses=4294967295 lsm=ipe res=1
> 
> The above record showed the current IPE active policy switch from
> `Allow_All` to `boot_verified` along with the version and the hash
> digest of the two policies. Note IPE can only have one policy active
> at a time, all access decision evaluation is based on the current active
> policy.
> The normal procedure to deploy a policy is loading the policy to deploy
> into the kernel first, then switch the active policy to it.
> 
> AUDIT_IPE_POLICY_LOAD(1422):
> 
>     audit: AUDIT1422 policy_name="boot_verified" policy_version=0.0.0
>       policy_digest=sha256:820EEA5B40CA42B51F68962354BA083122A20BB846F2676
>       auid=4294967295 ses=4294967295 lsm=ipe res=1
> 
> The above record showed a new policy has been loaded into the kernel
> with the policy name, policy version and policy hash.
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
>   + Further split lsm creation, the audit system, the evaluation loop,
>     and access control hooks into separate patches.
>   + Further split audit system patch into two separate patches; one
>     for include/uapi, and the usage of the new defines.
>   + Split out the permissive functionality into another separate patch,
>     for easier review.
>   + Correct misuse of audit_log_n_untrusted string to audit_log_format
>   + Use get_task_comm instead of comm directly.
>   + Quote certain audit values
>   + Remove unnecessary help text on choice options - these were
>     previously indented at the wrong level
>   + Correct a stale string constant (ctx_ns_enforce to ctx_enforce)
> 
> v8:
> 
>   + Change dependency for CONFIG_AUDIT to CONFIG_AUDITSYSCALL
>   + Drop ctx_* prefix
>   + Reuse, where appropriate, the audit fields from the field
>     dictionary. This transforms:
>       ctx_pathname  -> path
>       ctx_ino       -> ino
>       ctx_dev       -> dev
> 
>   + Add audit records and event examples to commit description.
>   + Remove new_audit_ctx, replace with audit_log_start. All data that
>     would provided by new_audit_ctx is already present in the syscall
>     audit record, that is always emitted on these actions. The audit
>     records should be correlated as such.
>   + Change audit types:
>     + AUDIT_TRUST_RESULT                -> AUDIT_IPE_ACCESS
>       +  This prevents overloading of the AVC type.
>     + AUDIT_TRUST_POLICY_ACTIVATE       -> AUDIT_MAC_CONFIG_CHANGE
>     + AUDIT_TRUST_POLICY_LOAD           -> AUDIT_MAC_POLICY_LOAD
>       + There were no significant difference in meaning between
>         these types.
> 
>   + Remove enforcing parameter passed from the context structure
>     for AUDIT_IPE_ACCESS.
>     +  This field can be inferred from the SYSCALL audit event,
>        based on the success field.
> 
>   + Remove all fields already captured in the syscall record. "hook",
>     an IPE specific field, can be determined via the syscall field in
>     the syscall record itself, so it has been removed.
>       + ino, path, and dev in IPE's record refer to the subject of the
>         syscall, while the syscall record refers to the calling process.
> 
>   + remove IPE prefix from policy load/policy activation events
>   + fix a bug wherein a policy change audit record was not fired when
>     updating a policy
> 
> v9:
>   + Merge the AUDIT_IPE_ACCESS definition with the audit support commit
>   + Change the audit format of policy load and switch
>   + Remove the ipe audit kernel switch
> 
> v10:
>   + Create AUDIT_IPE_CONFIG_CHANGE and AUDIT_IPE_POLICY_LOAD
>   + Change field names per upstream feedback
> 
> v11:
>   + Fix style issues
> 
> v12:
>   + Add ipe_op, ipe_hook, and enforcing fields to AUDIT_IPE_ACCESS
> ---
>  include/uapi/linux/audit.h |   3 +
>  security/ipe/Kconfig       |   2 +-
>  security/ipe/Makefile      |   1 +
>  security/ipe/audit.c       | 212 +++++++++++++++++++++++++++++++++++++
>  security/ipe/audit.h       |  18 ++++
>  security/ipe/eval.c        |  44 ++++++--
>  security/ipe/eval.h        |  13 ++-
>  security/ipe/fs.c          |  70 ++++++++++++
>  security/ipe/hooks.c       |  10 +-
>  security/ipe/hooks.h       |  11 ++
>  security/ipe/policy.c      |   5 +
>  11 files changed, 372 insertions(+), 17 deletions(-)
>  create mode 100644 security/ipe/audit.c
>  create mode 100644 security/ipe/audit.h

...

> diff --git a/security/ipe/audit.c b/security/ipe/audit.c
> new file mode 100644
> index 000000000000..79b7af25085c
> --- /dev/null
> +++ b/security/ipe/audit.c
> @@ -0,0 +1,212 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#include <linux/slab.h>
> +#include <linux/audit.h>
> +#include <linux/types.h>
> +#include <crypto/hash.h>
> +
> +#include "ipe.h"
> +#include "eval.h"
> +#include "hooks.h"
> +#include "policy.h"
> +#include "audit.h"
> +
> +#define ACTSTR(x) ((x) == IPE_ACTION_ALLOW ? "ALLOW" : "DENY")
> +
> +#define IPE_AUDIT_HASH_ALG "sha256"
> +
> +#define AUDIT_POLICY_LOAD_FMT "policy_name=\"%s\" policy_version=%hu.%hu.%hu "\
> +			      "policy_digest=" IPE_AUDIT_HASH_ALG ":"
> +#define AUDIT_OLD_ACTIVE_POLICY_FMT "old_active_pol_name=\"%s\" "\
> +				    "old_active_pol_version=%hu.%hu.%hu "\
> +				    "old_policy_digest=" IPE_AUDIT_HASH_ALG ":"
> +#define AUDIT_NEW_ACTIVE_POLICY_FMT "new_active_pol_name=\"%s\" "\
> +				    "new_active_pol_version=%hu.%hu.%hu "\
> +				    "new_policy_digest=" IPE_AUDIT_HASH_ALG ":"
> +
> +static const char *const audit_op_names[__IPE_OP_MAX + 1] = {
> +	"EXECUTE",
> +	"FIRMWARE",
> +	"KMODULE",
> +	"KEXEC_IMAGE",
> +	"KEXEC_INITRAMFS",
> +	"POLICY",
> +	"X509_CERT",
> +	"UNKNOWN",
> +};
> +
> +static const char *const audit_hook_names[__IPE_HOOK_MAX] = {
> +	"BPRM_CHECK",
> +	"MMAP",
> +	"MPROTECT",
> +	"KERNEL_READ",
> +	"KERNEL_LOAD",
> +};
> +
> +static const char *const audit_prop_names[__IPE_PROP_MAX] = {
> +#ifdef CONFIG_BLK_DEV_INITRD
> +	"boot_verified=FALSE",
> +	"boot_verified=TRUE",
> +#endif /* CONFIG_BLK_DEV_INITRD */
> +};

I think we can get rid of the preprocessor checks here.

--
paul-moore.com

