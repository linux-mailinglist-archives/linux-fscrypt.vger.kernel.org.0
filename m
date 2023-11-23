Return-Path: <linux-fscrypt+bounces-33-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9AF477F6887
	for <lists+linux-fscrypt@lfdr.de>; Thu, 23 Nov 2023 21:46:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 1F61CB20D48
	for <lists+linux-fscrypt@lfdr.de>; Thu, 23 Nov 2023 20:46:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1687D11C81;
	Thu, 23 Nov 2023 20:46:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D1VACNqg"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2D67D54;
	Thu, 23 Nov 2023 12:46:25 -0800 (PST)
Received: by mail-oo1-xc33.google.com with SMTP id 006d021491bc7-58d26808c0cso377761eaf.0;
        Thu, 23 Nov 2023 12:46:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1700772385; x=1701377185; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hmi2ZZptlGD8jWl5fmw9s/Qi1QCFiZAILpkynqKKJDc=;
        b=D1VACNqgS5g9FaNCJFV4RQvNmXdxnWf3e9mGym8p9aQpo4OOtJnMMUVCFe6yHYBeKa
         yCvrgOU+c0WRY5AH2ue03PKq1pKz8h7OijZZeEJ2pS0HDIUOEqpjv/jv+CkagsgLgU6q
         loxqyHAIU0V9VLmAiQd+IGbSKVd1Niv7STAPUUmZaCGZgwsQPu9m/XVtNE7zn6tRsBu+
         vHvxKLmrFIhk6MNBNm4Znq/2DUFLwzHpRC4L1XtT5+WjV6h2hz0iqBzQb4mDNOOi+xGH
         g4PTYN4IOxxD8sRNa7osNkF4husz9pZ0wvLU/Sdw2NRnbrzLPgl7DmJfb17K8fJO4KLV
         miNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700772385; x=1701377185;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hmi2ZZptlGD8jWl5fmw9s/Qi1QCFiZAILpkynqKKJDc=;
        b=kebKkq0NyQemafv4Yj5nXlqq0ga4XEYrZVb20mh32KsYcuthH/O3GE1XyUSYbo6Uc8
         eLFSmCk77UtaO8mg0T/43VJl1bUsrwOt1TCjjelbsvWMYry36w/Uz10RxWZBK2EdmcdH
         JJ1UywKVK/J648Fv/+K6lolHq4gmi7JQq7Y7OtDpSvVEvrJSrxko9sXdbMOVRnFwXFny
         p6YsJAE2L56kuvbhD4LAF2pRd6OhhpM7niK6VCB38dnc+ftxLXqpo0+CXdDsyy5Kal2e
         wkQ/IbeMuj1j855amu6KzzdVc9xnXyRYeikBGMn27q9hHvhykbt/0uZNPzvyRPghYYFg
         UzvA==
X-Gm-Message-State: AOJu0YxlHMRl5x5MdqUMtpg7oT7z5NX4b3cr2adOO6zdbSIViXVGhL/g
	qyWl7KGtxUylgiPYNAUjOdBrEr0kkcpvcMNo+yQ=
X-Google-Smtp-Source: AGHT+IFosH156j+hwgsIfTA+AcmCQxhOJnCWseaSONNiW6tXcdViJapGXbh7zTFDjyxipX37PBLVLKgJJhyQKjod/Rs=
X-Received: by 2002:a05:6820:2204:b0:581:ea96:f800 with SMTP id
 cj4-20020a056820220400b00581ea96f800mr606085oob.6.1700772385183; Thu, 23 Nov
 2023 12:46:25 -0800 (PST)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20231123030838.46158-1-ebiggers@kernel.org> <9df30dc2-bc1c-b0fc-156f-baad37def05b@redhat.com>
In-Reply-To: <9df30dc2-bc1c-b0fc-156f-baad37def05b@redhat.com>
From: Ilya Dryomov <idryomov@gmail.com>
Date: Thu, 23 Nov 2023 21:46:13 +0100
Message-ID: <CAOi1vP89X18T3oPWqhQqkpN-MY2LJJAhX2ms-OFTaV7dn8G8Zg@mail.gmail.com>
Subject: Re: [PATCH] ceph: select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
To: Xiubo Li <xiubli@redhat.com>
Cc: Eric Biggers <ebiggers@kernel.org>, ceph-devel@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Nov 23, 2023 at 5:32=E2=80=AFAM Xiubo Li <xiubli@redhat.com> wrote:
>
>
> On 11/23/23 11:08, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > The kconfig options for filesystems that support FS_ENCRYPTION are
> > supposed to select FS_ENCRYPTION_ALGS.  This is needed to ensure that
> > required crypto algorithms get enabled as loadable modules or builtin a=
s
> > is appropriate for the set of enabled filesystems.  Do this for CEPH_FS
> > so that there aren't any missing algorithms if someone happens to have
> > CEPH_FS as their only enabled filesystem that supports encryption.
> >
> > Fixes: f061feda6c54 ("ceph: add fscrypt ioctls and ceph.fscrypt.auth vx=
attr")
> > Cc: stable@vger.kernel.org
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >   fs/ceph/Kconfig | 1 +
> >   1 file changed, 1 insertion(+)
> >
> > diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
> > index 94df854147d35..7249d70e1a43f 100644
> > --- a/fs/ceph/Kconfig
> > +++ b/fs/ceph/Kconfig
> > @@ -1,19 +1,20 @@
> >   # SPDX-License-Identifier: GPL-2.0-only
> >   config CEPH_FS
> >       tristate "Ceph distributed file system"
> >       depends on INET
> >       select CEPH_LIB
> >       select LIBCRC32C
> >       select CRYPTO_AES
> >       select CRYPTO
> >       select NETFS_SUPPORT
> > +     select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
> >       default n
> >       help
> >         Choose Y or M here to include support for mounting the
> >         experimental Ceph distributed file system.  Ceph is an extremel=
y
> >         scalable file system designed to provide high performance,
> >         reliable access to petabytes of storage.
> >
> >         More information at https://ceph.io/.
> >
> >         If unsure, say N.
> >
> > base-commit: 9b6de136b5f0158c60844f85286a593cb70fb364
>
> Thanks Eric. This looks good to me.
>
> Reviewed-by: Xiubo Li <xiubli@redhat.com>

Applied.

Thanks,

                Ilya

