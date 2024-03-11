Return-Path: <linux-fscrypt+bounces-241-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id D0F7687828E
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Mar 2024 15:58:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 475A6B21F0C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Mar 2024 14:58:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 7B8CA41C79;
	Mon, 11 Mar 2024 14:53:40 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from frasgout12.his.huawei.com (frasgout12.his.huawei.com [14.137.139.154])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8B7C24642B;
	Mon, 11 Mar 2024 14:53:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=14.137.139.154
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710168820; cv=none; b=p3xPzi79tAZGUR19J+R2JPoIGasK5cSd3VCMqb5isNcbdTXWb3QhXzYTj7Yi6stATvdjgqhb5uxJ8TI7TTatLOC/ceevQ88qBGgEq2CH26Izr0cUSihMAd6TwTtRC3n8H9Bws1RbBH0cxU5gnUp2NJzzkw0HVlQBOQjn5dMOaD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710168820; c=relaxed/simple;
	bh=PMoGFhLyp3YjG8q6lz6vCYFDE3yIaeLIe7vPuylvNAw=;
	h=Message-ID:Subject:From:To:Cc:Date:In-Reply-To:References:
	 Content-Type:MIME-Version; b=BsvDsDcRJ5ToRTvEgMQS+IdySl2y8Z49HtkPEx1uEywdlrWw3jy4HlusOUXhYSCk2wzOVhJ1Wpw+sRtfjuap8p+oKdUn5Xi2DP9UmnrnRjm+zP6pGJhlaH48QwLzdsfVrwpEqxBN19Sin6CCZQKAz0unT5Qs7evk7wLRO8aeBWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=pass smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=14.137.139.154
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.18.186.51])
	by frasgout12.his.huawei.com (SkyGuard) with ESMTP id 4TtfQr6zsVz9xrMR;
	Mon, 11 Mar 2024 22:33:40 +0800 (CST)
Received: from mail02.huawei.com (unknown [7.182.16.27])
	by mail.maildlp.com (Postfix) with ESMTP id 4A127140496;
	Mon, 11 Mar 2024 22:53:23 +0800 (CST)
Received: from [127.0.0.1] (unknown [10.204.63.22])
	by APP2 (Coremail) with SMTP id GxC2BwBnoCTVGu9l72MbBA--.32227S2;
	Mon, 11 Mar 2024 15:53:22 +0100 (CET)
Message-ID: <cff886eef84ced5b4dfac1be7572dc8d06b63792.camel@huaweicloud.com>
Subject: Re: [RFC PATCH v14 05/19] initramfs|security: Add a security hook
 to do_populate_rootfs()
From: Roberto Sassu <roberto.sassu@huaweicloud.com>
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
  jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org, 
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com, 
 paul@paul-moore.com
Cc: linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org, 
 linux-security-module@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 audit@vger.kernel.org,  linux-kernel@vger.kernel.org
Date: Mon, 11 Mar 2024 15:53:06 +0100
In-Reply-To: <1709768084-22539-6-git-send-email-wufan@linux.microsoft.com>
References: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
	 <1709768084-22539-6-git-send-email-wufan@linux.microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.44.4-0ubuntu2 
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-CM-TRANSID:GxC2BwBnoCTVGu9l72MbBA--.32227S2
X-Coremail-Antispam: 1UD129KBjvJXoWxurWxWFW8urW7ury3CrWDXFb_yoW5Kw4DpF
	Wq9F13GF4kAF47W3yvk3W7Ca1aq395K3W7JrWDu3W8tF1akrn2qr43Kryqkrs7WrW7Ca1I
	qF4avrW3Cw1Dt3DanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
	9KBjDU0xBIdaVrnRJUUUk0b4IE77IF4wAFF20E14v26ryj6rWUM7CY07I20VC2zVCF04k2
	6cxKx2IYs7xG6rWj6s0DM7CIcVAFz4kK6r1j6r18M28lY4IEw2IIxxk0rwA2F7IY1VAKz4
	vEj48ve4kI8wA2z4x0Y4vE2Ix0cI8IcVAFwI0_Jr0_JF4l84ACjcxK6xIIjxv20xvEc7Cj
	xVAFwI0_Gr0_Cr1l84ACjcxK6I8E87Iv67AKxVW8JVWxJwA2z4x0Y4vEx4A2jsIEc7CjxV
	AFwI0_Gr0_Gr1UM2AIxVAIcxkEcVAq07x20xvEncxIr21l5I8CrVACY4xI64kE6c02F40E
	x7xfMcIj6xIIjxv20xvE14v26r1j6r18McIj6I8E87Iv67AKxVWUJVW8JwAm72CE4IkC6x
	0Yz7v_Jr0_Gr1lF7xvr2IY64vIr41lFIxGxcIEc7CjxVA2Y2ka0xkIwI1l42xK82IYc2Ij
	64vIr41l4I8I3I0E4IkC6x0Yz7v_Jr0_Gr1lx2IqxVAqx4xG67AKxVWUJVWUGwC20s026x
	8GjcxK67AKxVWUGVWUWwC2zVAF1VAY17CE14v26r4a6rW5MIIYrxkI7VAKI48JMIIF0xvE
	2Ix0cI8IcVAFwI0_Jr0_JF4lIxAIcVC0I7IYx2IY6xkF7I0E14v26r4j6F4UMIIF0xvE42
	xK8VAvwI8IcIk0rVWrJr0_WFyUJwCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv
	6xkF7I0E14v26r4j6r4UJbIYCTnIWIevJa73UjIFyTuYvjxUFDGOUUUUU
X-CM-SenderInfo: purev21wro2thvvxqx5xdzvxpfor3voofrz/1tbiAgATBF1jj5c4TAAAsH

On Wed, 2024-03-06 at 15:34 -0800, Fan Wu wrote:
> This patch introduces a new hook to notify security system that the
> content of initramfs has been unpacked into the rootfs.
>=20
> Upon receiving this notification, the security system can activate
> a policy to allow only files that originated from the initramfs to
> execute or load into kernel during the early stages of booting.
>=20
> This approach is crucial for minimizing the attack surface by
> ensuring that only trusted files from the initramfs are operational
> in the critical boot phase.
>=20
> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
>=20
> ---
> v1-v11:
>   + Not present
>=20
> v12:
>   + Introduced
>=20
> v13:
>   + Rename the hook name to initramfs_populated()
>=20
> v14:
>   + No changes
> ---
>  include/linux/lsm_hook_defs.h |  2 ++
>  include/linux/security.h      |  8 ++++++++
>  init/initramfs.c              |  3 +++
>  security/security.c           | 10 ++++++++++
>  4 files changed, 23 insertions(+)
>=20
> diff --git a/include/linux/lsm_hook_defs.h b/include/linux/lsm_hook_defs.=
h
> index 76458b6d53da..e0f50789a18f 100644
> --- a/include/linux/lsm_hook_defs.h
> +++ b/include/linux/lsm_hook_defs.h
> @@ -425,3 +425,5 @@ LSM_HOOK(int, 0, uring_override_creds, const struct c=
red *new)
>  LSM_HOOK(int, 0, uring_sqpoll, void)
>  LSM_HOOK(int, 0, uring_cmd, struct io_uring_cmd *ioucmd)
>  #endif /* CONFIG_IO_URING */
> +
> +LSM_HOOK(void, LSM_RET_VOID, initramfs_populated, void)

I don't know, but why there is no super_block as parameter?

And, wouldn't be better to rely on existing hooks to identify inodes in
the initial ram disk?

(gdb) p *file->f_path.dentry->d_inode->i_sb->s_type
$3 =3D {name =3D 0xffffffff826058a9 "rootfs"

That could also help if you want to enforce action based on the
filesystem name (and why not on the UUID too).

Roberto

> diff --git a/include/linux/security.h b/include/linux/security.h
> index d0eb20f90b26..619e17e59532 100644
> --- a/include/linux/security.h
> +++ b/include/linux/security.h
> @@ -2167,4 +2167,12 @@ static inline int security_uring_cmd(struct io_uri=
ng_cmd *ioucmd)
>  #endif /* CONFIG_SECURITY */
>  #endif /* CONFIG_IO_URING */
> =20
> +#ifdef CONFIG_SECURITY
> +extern void security_initramfs_populated(void);
> +#else
> +static inline void security_initramfs_populated(void)
> +{
> +}
> +#endif /* CONFIG_SECURITY */
> +
>  #endif /* ! __LINUX_SECURITY_H */
> diff --git a/init/initramfs.c b/init/initramfs.c
> index 76deb48c38cb..140619a583ff 100644
> --- a/init/initramfs.c
> +++ b/init/initramfs.c
> @@ -18,6 +18,7 @@
>  #include <linux/init_syscalls.h>
>  #include <linux/task_work.h>
>  #include <linux/umh.h>
> +#include <linux/security.h>
> =20
>  static __initdata bool csum_present;
>  static __initdata u32 io_csum;
> @@ -720,6 +721,8 @@ static void __init do_populate_rootfs(void *unused, a=
sync_cookie_t cookie)
>  #endif
>  	}
> =20
> +	security_initramfs_populated();
> +
>  done:
>  	/*
>  	 * If the initrd region is overlapped with crashkernel reserved region,
> diff --git a/security/security.c b/security/security.c
> index f168bc30a60d..26c28db211fd 100644
> --- a/security/security.c
> +++ b/security/security.c
> @@ -5619,3 +5619,13 @@ int security_uring_cmd(struct io_uring_cmd *ioucmd=
)
>  	return call_int_hook(uring_cmd, 0, ioucmd);
>  }
>  #endif /* CONFIG_IO_URING */
> +
> +/**
> + * security_initramfs_populated() - Notify LSMs that initramfs has been =
loaded
> + *
> + * Tells the LSMs the initramfs has been unpacked into the rootfs.
> + */
> +void security_initramfs_populated(void)
> +{
> +	call_void_hook(initramfs_populated);
> +}


