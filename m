Return-Path: <linux-fscrypt+bounces-240-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3615E8781E0
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Mar 2024 15:43:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 3A3BCB2326A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Mar 2024 14:43:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 718873FE4C;
	Mon, 11 Mar 2024 14:43:15 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBAF4174A;
	Mon, 11 Mar 2024 14:43:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=14.137.139.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710168195; cv=none; b=Dlsj766YBMPivh+XWKPpNBU8qqkYLWZDLczIjhhcKEO5HvzmuIJztXV/d+h89g1wyu10Bw4QoTUDwpTT4sRrKbehEECE2mv7oVZdMJqeKqZ0aLJr2/4S2M28o14KjkVRm24BRf2tE6tllYRXigKkX3Kja0ffi9hD02np/yY/2qE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710168195; c=relaxed/simple;
	bh=2pVTHbPFDAj+SIeIHGyAcE5S11BpmIs+2eQRS+qWt1U=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=oLwY0t6n2kmxbEta9DNG0A+pep2f8JlfFeHsnHjZBER+NF7QFwwAJ7zrvoq3sp6urqSRhZR9SwBgbVeGe27QczjrCGqFEVXuJOfv+A0r4uy84eZYzVr1uA1fbr6ucT7BXJbmWF+neURi7mWLJcutsBYETIYEBsCPyPptsxU+G80=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=14.137.139.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.18.186.51])
	by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4TtdqN5nWhz9xrN0;
	Mon, 11 Mar 2024 22:06:24 +0800 (CST)
Received: from mail02.huawei.com (unknown [7.182.16.47])
	by mail.maildlp.com (Postfix) with ESMTP id 7A0B614064D;
	Mon, 11 Mar 2024 22:26:13 +0800 (CST)
Received: from [127.0.0.1] (unknown [10.204.63.22])
	by APP1 (Coremail) with SMTP id LxC2BwBHPhd3FO9lMookBA--.19094S2;
	Mon, 11 Mar 2024 15:26:12 +0100 (CET)
Message-ID: <21597a6e143e4110d0103ef1421ac87fa98b7f32.camel@huaweicloud.com>
Subject: Re: [RFC PATCH v14 01/19] security: add ipe lsm
From: Roberto Sassu <roberto.sassu@huaweicloud.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
  jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org, 
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com, 
 paul@paul-moore.com
Cc: linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 audit@vger.kernel.org,  linux-kernel@vger.kernel.org, Deven Bowers
 <deven.desai@linux.microsoft.com>
Date: Mon, 11 Mar 2024 15:25:55 +0100
In-Reply-To: <1709768084-22539-2-git-send-email-wufan@linux.microsoft.com>
References: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
	 <1709768084-22539-2-git-send-email-wufan@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CM-TRANSID:LxC2BwBHPhd3FO9lMookBA--.19094S2
X-Coremail-Antispam: 1UD129KBjvJXoW3WrW8Zw4DCw48GrW7Aw45GFg_yoWDJw48pF
	4kKF4fGFsrXFy3Wrs3CF1xGF1Sg395Gry5CwsxWw1jyFn0vw10qr42kryUCF15XrsrArW8
	K3ZF9w4a93Wqv3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUkmb4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYY7kG6xAYrwCIc40Y0x0E
	wIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVW8JV
	WxJwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI
	42IY6I8E87Iv6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUgEksDUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgATBF1jj5c3xAAAsA

On Wed, 2024-03-06 at 15:34 -0800, Fan Wu wrote:
> From: Deven Bowers <deven.desai@linux.microsoft.com>
>=20
> Integrity Policy Enforcement (IPE) is an LSM that provides an
> complimentary approach to Mandatory Access Control than existing LSMs
> today.
>=20
> Existing LSMs have centered around the concept of access to a resource
> should be controlled by the current user's credentials. IPE's approach,
> is that access to a resource should be controlled by the system's trust
> of a current resource.
>=20
> The basis of this approach is defining a global policy to specify which
> resource can be trusted.
>=20
> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
> ---
> v2:
>   + Split evaluation loop, access control hooks,
>     and evaluation loop from policy parser and userspace
>     interface to pass mailing list character limit
>=20
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
>=20
> v4:
>   + Remove sysctls in favor of securityfs nodes
>   + Re-add kernel module parameters, as these are now
>     exposed through securityfs.
>   + Refactor property audit loop to a separate function.
>=20
> v5:
>   + fix minor grammatical errors
>   + do not group rule by curly-brace in audit record,
>     reconstruct the exact rule.
>=20
> v6:
>   + No changes
>=20
> v7:
>   + Further split lsm creation into a separate commit from the
>     evaluation loop and audit system, for easier review.
>=20
>   + Introduce the concept of an ipe_context, a scoped way to
>     introduce execution policies, used initially for allowing for
>     kunit tests in isolation.
>=20
> v8:
>   + Follow lsmname_hook_name convention for lsm hooks.
>   + Move LSM blob accessors to ipe.c and mark LSM blobs as static.
>=20
> v9:
>   + Remove ipe_context for simplification
>=20
> v10:
>   + Add github url
>=20
> v11:
>   + Correct github url
>   + Move ipe before bpf
>=20
> v12:
>   + Switch to use lsm_id instead of string for lsm name
>=20
> v13:
>   + No changes
>=20
> v14:
>   + No changes
> ---
>  MAINTAINERS              |  7 +++++++
>  include/uapi/linux/lsm.h |  1 +
>  security/Kconfig         | 11 ++++++-----
>  security/Makefile        |  1 +
>  security/ipe/Kconfig     | 17 +++++++++++++++++
>  security/ipe/Makefile    |  9 +++++++++
>  security/ipe/ipe.c       | 41 ++++++++++++++++++++++++++++++++++++++++
>  security/ipe/ipe.h       | 16 ++++++++++++++++
>  security/security.c      |  3 ++-
>  9 files changed, 100 insertions(+), 6 deletions(-)
>  create mode 100644 security/ipe/Kconfig
>  create mode 100644 security/ipe/Makefile
>  create mode 100644 security/ipe/ipe.c
>  create mode 100644 security/ipe/ipe.h
>=20
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 13158047f2af..8517011f88ff 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -10650,6 +10650,13 @@ T:	git git://git.kernel.org/pub/scm/linux/kernel=
/git/zohar/linux-integrity.git
>  F:	security/integrity/
>  F:	security/integrity/ima/
> =20
> +INTEGRITY POLICY ENFORCEMENT (IPE)
> +M:	Fan Wu <wufan@linux.microsoft.com>
> +L:	linux-security-module@vger.kernel.org
> +S:	Supported
> +T:	git https://github.com/microsoft/ipe.git
> +F:	security/ipe/
> +
>  INTEL 810/815 FRAMEBUFFER DRIVER
>  M:	Antonino Daplas <adaplas@gmail.com>
>  L:	linux-fbdev@vger.kernel.org
> diff --git a/include/uapi/linux/lsm.h b/include/uapi/linux/lsm.h
> index f8aef9ade549..43e2fb32745a 100644
> --- a/include/uapi/linux/lsm.h
> +++ b/include/uapi/linux/lsm.h
> @@ -62,6 +62,7 @@ struct lsm_ctx {
>  #define LSM_ID_LOCKDOWN		108
>  #define LSM_ID_BPF		109
>  #define LSM_ID_LANDLOCK		110
> +#define LSM_ID_IPE		111
> =20
>  /*
>   * LSM_ATTR_XXX definitions identify different LSM attributes
> diff --git a/security/Kconfig b/security/Kconfig
> index 52c9af08ad35..cc7adfbb6b96 100644
> --- a/security/Kconfig
> +++ b/security/Kconfig
> @@ -194,6 +194,7 @@ source "security/yama/Kconfig"
>  source "security/safesetid/Kconfig"
>  source "security/lockdown/Kconfig"
>  source "security/landlock/Kconfig"
> +source "security/ipe/Kconfig"
> =20
>  source "security/integrity/Kconfig"
> =20
> @@ -233,11 +234,11 @@ endchoice
> =20
>  config LSM
>  	string "Ordered list of enabled LSMs"
> -	default "landlock,lockdown,yama,loadpin,safesetid,smack,selinux,tomoyo,=
apparmor,bpf" if DEFAULT_SECURITY_SMACK
> -	default "landlock,lockdown,yama,loadpin,safesetid,apparmor,selinux,smac=
k,tomoyo,bpf" if DEFAULT_SECURITY_APPARMOR
> -	default "landlock,lockdown,yama,loadpin,safesetid,tomoyo,bpf" if DEFAUL=
T_SECURITY_TOMOYO
> -	default "landlock,lockdown,yama,loadpin,safesetid,bpf" if DEFAULT_SECUR=
ITY_DAC
> -	default "landlock,lockdown,yama,loadpin,safesetid,selinux,smack,tomoyo,=
apparmor,bpf"
> +	default "landlock,lockdown,yama,loadpin,safesetid,smack,selinux,tomoyo,=
apparmor,ipe,bpf" if DEFAULT_SECURITY_SMACK
> +	default "landlock,lockdown,yama,loadpin,safesetid,apparmor,selinux,smac=
k,tomoyo,ipe,bpf" if DEFAULT_SECURITY_APPARMOR
> +	default "landlock,lockdown,yama,loadpin,safesetid,tomoyo,ipe,bpf" if DE=
FAULT_SECURITY_TOMOYO
> +	default "landlock,lockdown,yama,loadpin,safesetid,ipe,bpf" if DEFAULT_S=
ECURITY_DAC
> +	default "landlock,lockdown,yama,loadpin,safesetid,selinux,smack,tomoyo,=
apparmor,ipe,bpf"
>  	help
>  	  A comma-separated list of LSMs, in initialization order.
>  	  Any LSMs left off this list, except for those with order
> diff --git a/security/Makefile b/security/Makefile
> index 59f238490665..cc0982214b84 100644
> --- a/security/Makefile
> +++ b/security/Makefile
> @@ -25,6 +25,7 @@ obj-$(CONFIG_SECURITY_LOCKDOWN_LSM)	+=3D lockdown/
>  obj-$(CONFIG_CGROUPS)			+=3D device_cgroup.o
>  obj-$(CONFIG_BPF_LSM)			+=3D bpf/
>  obj-$(CONFIG_SECURITY_LANDLOCK)		+=3D landlock/
> +obj-$(CONFIG_SECURITY_IPE)		+=3D ipe/
> =20
>  # Object integrity file lists
>  obj-$(CONFIG_INTEGRITY)			+=3D integrity/
> diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
> new file mode 100644
> index 000000000000..e4875fb04883
> --- /dev/null
> +++ b/security/ipe/Kconfig
> @@ -0,0 +1,17 @@
> +# SPDX-License-Identifier: GPL-2.0-only
> +#
> +# Integrity Policy Enforcement (IPE) configuration
> +#
> +
> +menuconfig SECURITY_IPE
> +	bool "Integrity Policy Enforcement (IPE)"
> +	depends on SECURITY && SECURITYFS
> +	select PKCS7_MESSAGE_PARSER
> +	select SYSTEM_DATA_VERIFICATION
> +	help
> +	  This option enables the Integrity Policy Enforcement LSM
> +	  allowing users to define a policy to enforce a trust-based access
> +	  control. A key feature of IPE is a customizable policy to allow
> +	  admins to reconfigure trust requirements on the fly.
> +
> +	  If unsure, answer N.
> diff --git a/security/ipe/Makefile b/security/ipe/Makefile
> new file mode 100644
> index 000000000000..f7a80d0f18f8
> --- /dev/null
> +++ b/security/ipe/Makefile
> @@ -0,0 +1,9 @@
> +# SPDX-License-Identifier: GPL-2.0
> +#
> +# Copyright (C) Microsoft Corporation. All rights reserved.
> +#
> +# Makefile for building the IPE module as part of the kernel tree.
> +#
> +
> +obj-$(CONFIG_SECURITY_IPE) +=3D \
> +	ipe.o \
> diff --git a/security/ipe/ipe.c b/security/ipe/ipe.c
> new file mode 100644
> index 000000000000..b013aed15e73
> --- /dev/null
> +++ b/security/ipe/ipe.c
> @@ -0,0 +1,41 @@
> +// SPDX-License-Identifier: GPL-2.0
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +#include <uapi/linux/lsm.h>
> +
> +#include "ipe.h"
> +
> +static struct lsm_blob_sizes ipe_blobs __ro_after_init =3D {
> +};
> +
> +static const struct lsm_id ipe_lsmid =3D {
> +	.name =3D "ipe",
> +	.id =3D LSM_ID_IPE,
> +};
> +
> +static struct security_hook_list ipe_hooks[] __ro_after_init =3D {
> +};
> +
> +/**
> + * ipe_init - Entry point of IPE.
> + *
> + * This is called at LSM init, which happens occurs early during kernel
> + * start up. During this phase, IPE registers its hooks and loads the
> + * builtin boot policy.
> + * Return:
> + * * 0		- OK
> + * * -ENOMEM	- Out of memory
> + */
> +static int __init ipe_init(void)
> +{
> +	security_add_hooks(ipe_hooks, ARRAY_SIZE(ipe_hooks), &ipe_lsmid);
> +
> +	return 0;
> +}
> +
> +DEFINE_LSM(ipe) =3D {
> +	.name =3D "ipe",
> +	.init =3D ipe_init,
> +	.blobs =3D &ipe_blobs,
> +};
> diff --git a/security/ipe/ipe.h b/security/ipe/ipe.h
> new file mode 100644
> index 000000000000..a1c68d0fc2e0
> --- /dev/null
> +++ b/security/ipe/ipe.h
> @@ -0,0 +1,16 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/*
> + * Copyright (C) Microsoft Corporation. All rights reserved.
> + */
> +
> +#ifndef _IPE_H
> +#define _IPE_H
> +
> +#ifdef pr_fmt
> +#undef pr_fmt
> +#endif
> +#define pr_fmt(fmt) "IPE: " fmt
> +
> +#include <linux/lsm_hooks.h>
> +
> +#endif /* _IPE_H */
> diff --git a/security/security.c b/security/security.c
> index 7035ee35a393..f168bc30a60d 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -51,7 +51,8 @@
>  	(IS_ENABLED(CONFIG_SECURITY_SAFESETID) ? 1 : 0) + \
>  	(IS_ENABLED(CONFIG_SECURITY_LOCKDOWN_LSM) ? 1 : 0) + \
>  	(IS_ENABLED(CONFIG_BPF_LSM) ? 1 : 0) + \
> -	(IS_ENABLED(CONFIG_SECURITY_LANDLOCK) ? 1 : 0))
> +	(IS_ENABLED(CONFIG_SECURITY_LANDLOCK) ? 1 : 0) + \
> +	(IS_ENABLED(CONFIG_SECURITY_IPE) ? 1 : 0))

Hi Fan

you would also need to update
tools/testing/selftests/lsm/lsm_list_modules_test.c.

Roberto
=20
>  /*
>   * These are descriptions of the reasons that can be passed to the


