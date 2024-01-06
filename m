Return-Path: <linux-fscrypt+bounces-106-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2FF388261F3
	for <lists+linux-fscrypt@lfdr.de>; Sat,  6 Jan 2024 23:34:30 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 2CFB31C20CF3
	for <lists+linux-fscrypt@lfdr.de>; Sat,  6 Jan 2024 22:34:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D65D1101CE;
	Sat,  6 Jan 2024 22:34:26 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10505101C6
	for <linux-fscrypt@vger.kernel.org>; Sat,  6 Jan 2024 22:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=nod.at
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=nod.at
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id A356264103F0;
	Sat,  6 Jan 2024 23:34:14 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
	with ESMTP id 6EOQKWiUuJHZ; Sat,  6 Jan 2024 23:34:13 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
	by lithops.sigma-star.at (Postfix) with ESMTP id 764AC64103F7;
	Sat,  6 Jan 2024 23:34:13 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
	by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
	with ESMTP id ITDqdefjUO7N; Sat,  6 Jan 2024 23:34:13 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
	by lithops.sigma-star.at (Postfix) with ESMTP id 56A0764103F0;
	Sat,  6 Jan 2024 23:34:13 +0100 (CET)
Date: Sat, 6 Jan 2024 23:34:13 +0100 (CET)
From: Richard Weinberger <richard@nod.at>
To: chengzhihao1 <chengzhihao1@huawei.com>
Cc: terrelln@fb.com, Eric Biggers <ebiggers@google.com>, 
	linux-fscrypt <linux-fscrypt@vger.kernel.org>, 
	linux-mtd <linux-mtd@lists.infradead.org>
Message-ID: <533956769.204398.1704580453236.JavaMail.zimbra@nod.at>
In-Reply-To: <20231222085446.781838-2-chengzhihao1@huawei.com>
References: <20231222085446.781838-1-chengzhihao1@huawei.com> <20231222085446.781838-2-chengzhihao1@huawei.com>
Subject: Re: [PATCH v2 1/2] ubifs: dbg_check_idx_size: Fix kmemleak if
 loading znode failed
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF97 (Linux)/8.8.12_GA_3809)
Thread-Topic: ubifs: dbg_check_idx_size: Fix kmemleak if loading znode failed
Thread-Index: qSQOXRqIT8PxNyX+dFCgPpVolDIDMQ==

----- Urspr=C3=BCngliche Mail -----
> Von: "chengzhihao1" <chengzhihao1@huawei.com>
> An: "richard" <richard@nod.at>, terrelln@fb.com, "Eric Biggers" <ebiggers=
@google.com>
> CC: "linux-fscrypt" <linux-fscrypt@vger.kernel.org>, "linux-mtd" <linux-m=
td@lists.infradead.org>
> Gesendet: Freitag, 22. Dezember 2023 09:54:45
> Betreff: [PATCH v2 1/2] ubifs: dbg_check_idx_size: Fix kmemleak if loadin=
g znode failed

> If function dbg_check_idx_size() failed by loading znode in mounting
> process, there are two problems:
>  1. Allocated znodes won't be freed, which causes kmemleak in kernel:
>     ubifs_mount
>      dbg_check_idx_size
>       dbg_walk_index
>        c->zroot.znode =3D ubifs_load_znode
>=09child =3D ubifs_load_znode // failed
>=09// Loaded znodes won't be freed in error handling path.
>  2. Global variable ubifs_clean_zn_cnt is not decreased, because
>     ubifs_tnc_close() is not invoked in error handling path, which
>     triggers a warning in ubifs_exit():
>      WARNING: CPU: 1 PID: 1576 at fs/ubifs/super.c:2486 ubifs_exit
>      Modules linked in: zstd ubifs(-) ubi nandsim
>      CPU: 1 PID: 1576 Comm: rmmod Not tainted 6.7.0-rc6
>      Call Trace:
>=09ubifs_exit+0xca/0xc70 [ubifs]
>=09__do_sys_delete_module+0x29a/0x4a0
>=09do_syscall_64+0x6f/0x140
>=20
> Fix it by invoking destroy_journal() if dbg_check_idx_size() failed.
>=20
> Fixes: 1e51764a3c2a ("UBIFS: add new flash file system")
> Signed-off-by: Zhihao Cheng <chengzhihao1@huawei.com>
> ---
> fs/ubifs/super.c | 2 +-
> 1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/fs/ubifs/super.c b/fs/ubifs/super.c
> index 09e270d6ed02..eabb0f44ea3e 100644
> --- a/fs/ubifs/super.c
> +++ b/fs/ubifs/super.c
> @@ -1449,7 +1449,7 @@ static int mount_ubifs(struct ubifs_info *c)
>=20
> =09err =3D dbg_check_idx_size(c, c->bi.old_idx_sz);
> =09if (err)
> -=09=09goto out_lpt;
> +=09=09goto out_journal;

While it is technically not wrong, calling destroy_journal() before ubifs_r=
eplay_journal() is highly confusing
to future readers of the source code.
It seem to work because ubifs_replay_journal() can deal with the fact the j=
ournal is not yet initialized.
I'd rather suggest to add a distinct function which undoes what dbg_check_i=
dx_size() did.
Alternatively, dbg_check_idx_size() could also cleanup itself after failure=
.

Thanks,
//richard

