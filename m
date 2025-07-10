Return-Path: <linux-fscrypt+bounces-702-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 4FE1FB00035
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Jul 2025 13:11:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 28B583AA905
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Jul 2025 11:10:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 778BB288C22;
	Thu, 10 Jul 2025 11:11:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="E2IXUq+R"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E4E4248F55
	for <linux-fscrypt@vger.kernel.org>; Thu, 10 Jul 2025 11:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752145863; cv=none; b=FEYvMq8rRgou3HMoVpfYmyjsH/P2SLDewEh6SKDCwwYNNAk9QtP1Jg7FLWskxVh+1/1HHzAFPrRDlFlT3Yby3ienSJDteXe0SSSeMrJy6xJYnzeTS18WNVP2wHbRba9PO2q+I1nm8KjYobkqG7U6T2LGvbtWIkh5/pO3WqxUwoc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752145863; c=relaxed/simple;
	bh=scW7lpt9t3K9ITJWzum5EA9tDSAFygNR1A3VRJqSD3A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gL16PI08kYd/QkFjpVXjBcX2KAkgw2cG4WSabBCOP1xbwJzqXOR1ewAGTxu9+RVGW30KSG/VORZ27vDIA/g/YWGYuujnXybSNk5orDSsa6VKdJneCpC+yx7j1nG97TPHh64vOmek0Jh03/1OC/LvApqB3/xDoEbeBfK+9XSMWsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=E2IXUq+R; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1752145860;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=oRr959tgklYlTSJNtT9cIXr3gOx1P9lsAQr8MZhrUds=;
	b=E2IXUq+RZjt+NzDoxHHvan8i9wC6JLPhmTpE2GKVrDdbjPIZ+JqEDmjkYsG+3PygvYJqtY
	iB3mTA/I1VyKskDPxvIeb7C0MqEbLgt5ZM2JkZ0ciKmV2VmaCkvgjEGrcMpplxQYGVeAIv
	uCQfJ2RaY7UXmAssuSR4nMje5h7Gu74=
Received: from mail-vk1-f197.google.com (mail-vk1-f197.google.com
 [209.85.221.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-353--46Vh4mIOVGkxs-ovjZ7xQ-1; Thu, 10 Jul 2025 07:08:03 -0400
X-MC-Unique: -46Vh4mIOVGkxs-ovjZ7xQ-1
X-Mimecast-MFC-AGG-ID: -46Vh4mIOVGkxs-ovjZ7xQ_1752145683
Received: by mail-vk1-f197.google.com with SMTP id 71dfb90a1353d-532f90a1cadso1296522e0c.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 10 Jul 2025 04:08:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1752145682; x=1752750482;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oRr959tgklYlTSJNtT9cIXr3gOx1P9lsAQr8MZhrUds=;
        b=oHuS1ot9xZ5goIbFbsIgA24tKhZUkO+THvgedSsKrmpBI7LMYRJqZqoFtyZIXaWxaw
         SbBEzPXE+0UihM8gUBnXGTWDNW+OVSVywsoXur+LiTmsJCIYo/8xkmqxl0gjKfRXovn0
         7YkeH/jdYTuk6COnFTBL2xTPFDCyt+uI/mAC6OJTBBeKujuxzxXzSvxkcR+E5uXO7I13
         ZWYtQg58MFKmDFKxj5f6Edtzxw6cMotVoSP02+z6dDdnYC573jCriqR3gCjIuEscP3IE
         LU2gTfjFVNgrPJf+8sm3dIJkZ4iYicT/yzU0+AFXGR+8yTOPE7JohPuXyA2kJoJ68Pxn
         g5Cg==
X-Gm-Message-State: AOJu0YzU1sO7VGL61XR0fjbPoFyjGTeH0CcQpnKANtCgMmcFhnmjzVZj
	3Bxyz07MBautoz52Frhb4zZxuIcA91gsRWK+Tkw71iCyc8F5OTAlXgAxG1mu0XmHWV1EIHmz1r6
	3Od//5YyjZHC2znClLOsosbDu+VdgiZlFeVO69dv8Roao+uWat9wqlbAXNuWuevoJsev/bigCqH
	WETZ7Yo0J80TH02YvTylUcKSGThLVcmRun3GAgDzbqWA==
X-Gm-Gg: ASbGnctTmgcAWh1GDN46Q/o+o7LnK1z5bnzDnjpFNkUr8eyHR/KhIMRmbPTXwRi1alU
	Zhx2crQV8pmWO3MO+xvMQVQc+3N27THXn58H7Vg8P88Kb78nTmAp+/ab6u+6WmP0HcWq/a5ReBV
	kHUVO+
X-Received: by 2002:a05:6122:788:b0:531:1314:618d with SMTP id 71dfb90a1353d-535e3dc3141mr2472007e0c.0.1752145681118;
        Thu, 10 Jul 2025 04:08:01 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IGrFIvf+c9gCePlhiHZ18anazjvea9C/s5gsteYaCXiPys9MekY2/pYF44bBTHRs6JXyKOEgCbgxmRUYU9jd9A=
X-Received: by 2002:a05:6122:788:b0:531:1314:618d with SMTP id
 71dfb90a1353d-535e3dc3141mr2471772e0c.0.1752145679323; Thu, 10 Jul 2025
 04:07:59 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20250710060754.637098-1-ebiggers@kernel.org> <20250710060754.637098-7-ebiggers@kernel.org>
In-Reply-To: <20250710060754.637098-7-ebiggers@kernel.org>
From: Alex Markuze <amarkuze@redhat.com>
Date: Thu, 10 Jul 2025 14:07:47 +0300
X-Gm-Features: Ac12FXxqiJxLMMlU9cjfbI_3W3ee5EBVwZqxnp4Ks340mDQ4Yybgshbv8UUr1rw
Message-ID: <CAO8a2Sivm00NRM9Z-Fwp=FzcmkAP8m1uQR24-avT-tUug4VgmQ@mail.gmail.com>
Subject: Re: [PATCH v2 6/6] ceph: Remove gfp_t argument from ceph_fscrypt_encrypt_*()
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org, 
	Yuwen Chen <ywen.chen@foxmail.com>, linux-mtd@lists.infradead.org, 
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Reviewed-by: Alex Markuze amarkuze@redhat.com

On Thu, Jul 10, 2025 at 9:15=E2=80=AFAM Eric Biggers <ebiggers@kernel.org> =
wrote:
>
> This argument is no longer used, so remove it.
>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
>  fs/ceph/crypto.c | 10 ++++------
>  fs/ceph/crypto.h | 10 ++++------
>  fs/ceph/file.c   |  3 +--
>  fs/ceph/inode.c  |  3 +--
>  4 files changed, 10 insertions(+), 16 deletions(-)
>
> diff --git a/fs/ceph/crypto.c b/fs/ceph/crypto.c
> index 6d04d528ed038..91e62db0c2050 100644
> --- a/fs/ceph/crypto.c
> +++ b/fs/ceph/crypto.c
> @@ -514,12 +514,11 @@ int ceph_fscrypt_decrypt_block_inplace(const struct=
 inode *inode,
>         return fscrypt_decrypt_block_inplace(inode, page, len, offs, lblk=
_num);
>  }
>
>  int ceph_fscrypt_encrypt_block_inplace(const struct inode *inode,
>                                   struct page *page, unsigned int len,
> -                                 unsigned int offs, u64 lblk_num,
> -                                 gfp_t gfp_flags)
> +                                 unsigned int offs, u64 lblk_num)
>  {
>         struct ceph_client *cl =3D ceph_inode_to_client(inode);
>
>         doutc(cl, "%p %llx.%llx len %u offs %u blk %llu\n", inode,
>               ceph_vinop(inode), len, offs, lblk_num);
> @@ -639,21 +638,20 @@ int ceph_fscrypt_decrypt_extents(struct inode *inod=
e, struct page **page,
>   * ceph_fscrypt_encrypt_pages - encrypt an array of pages
>   * @inode: pointer to inode associated with these pages
>   * @page: pointer to page array
>   * @off: offset into the file that the data starts
>   * @len: max length to encrypt
> - * @gfp: gfp flags to use for allocation
>   *
> - * Decrypt an array of cleartext pages and return the amount of
> + * Encrypt an array of cleartext pages and return the amount of
>   * data encrypted. Any data in the page prior to the start of the
>   * first complete block in the read is ignored. Any incomplete
>   * crypto blocks at the end of the array are ignored.
>   *
>   * Returns the length of the encrypted data or a negative errno.
>   */
>  int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page, =
u64 off,
> -                               int len, gfp_t gfp)
> +                               int len)
>  {
>         int i, num_blocks;
>         u64 baseblk =3D off >> CEPH_FSCRYPT_BLOCK_SHIFT;
>         int ret =3D 0;
>
> @@ -670,11 +668,11 @@ int ceph_fscrypt_encrypt_pages(struct inode *inode,=
 struct page **page, u64 off,
>                 unsigned int pgoffs =3D offset_in_page(blkoff);
>                 int fret;
>
>                 fret =3D ceph_fscrypt_encrypt_block_inplace(inode, page[p=
gidx],
>                                 CEPH_FSCRYPT_BLOCK_SIZE, pgoffs,
> -                               baseblk + i, gfp);
> +                               baseblk + i);
>                 if (fret < 0) {
>                         if (ret =3D=3D 0)
>                                 ret =3D fret;
>                         break;
>                 }
> diff --git a/fs/ceph/crypto.h b/fs/ceph/crypto.h
> index d0768239a1c9c..6db28464ff803 100644
> --- a/fs/ceph/crypto.h
> +++ b/fs/ceph/crypto.h
> @@ -153,19 +153,18 @@ static inline void ceph_fscrypt_adjust_off_and_len(=
struct inode *inode,
>  int ceph_fscrypt_decrypt_block_inplace(const struct inode *inode,
>                                   struct page *page, unsigned int len,
>                                   unsigned int offs, u64 lblk_num);
>  int ceph_fscrypt_encrypt_block_inplace(const struct inode *inode,
>                                   struct page *page, unsigned int len,
> -                                 unsigned int offs, u64 lblk_num,
> -                                 gfp_t gfp_flags);
> +                                 unsigned int offs, u64 lblk_num);
>  int ceph_fscrypt_decrypt_pages(struct inode *inode, struct page **page,
>                                u64 off, int len);
>  int ceph_fscrypt_decrypt_extents(struct inode *inode, struct page **page=
,
>                                  u64 off, struct ceph_sparse_extent *map,
>                                  u32 ext_cnt);
>  int ceph_fscrypt_encrypt_pages(struct inode *inode, struct page **page, =
u64 off,
> -                              int len, gfp_t gfp);
> +                              int len);
>
>  static inline struct page *ceph_fscrypt_pagecache_page(struct page *page=
)
>  {
>         return fscrypt_is_bounce_page(page) ? fscrypt_pagecache_page(page=
) : page;
>  }
> @@ -244,12 +243,11 @@ static inline int ceph_fscrypt_decrypt_block_inplac=
e(const struct inode *inode,
>         return 0;
>  }
>
>  static inline int ceph_fscrypt_encrypt_block_inplace(const struct inode =
*inode,
>                                           struct page *page, unsigned int=
 len,
> -                                         unsigned int offs, u64 lblk_num=
,
> -                                         gfp_t gfp_flags)
> +                                         unsigned int offs, u64 lblk_num=
)
>  {
>         return 0;
>  }
>
>  static inline int ceph_fscrypt_decrypt_pages(struct inode *inode,
> @@ -267,11 +265,11 @@ static inline int ceph_fscrypt_decrypt_extents(stru=
ct inode *inode,
>         return 0;
>  }
>
>  static inline int ceph_fscrypt_encrypt_pages(struct inode *inode,
>                                              struct page **page, u64 off,
> -                                            int len, gfp_t gfp)
> +                                            int len)
>  {
>         return 0;
>  }
>
>  static inline struct page *ceph_fscrypt_pagecache_page(struct page *page=
)
> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
> index a7254cab44cc2..9b79da6d1aee7 100644
> --- a/fs/ceph/file.c
> +++ b/fs/ceph/file.c
> @@ -1990,12 +1990,11 @@ ceph_sync_write(struct kiocb *iocb, struct iov_it=
er *from, loff_t pos,
>                         break;
>                 }
>
>                 if (IS_ENCRYPTED(inode)) {
>                         ret =3D ceph_fscrypt_encrypt_pages(inode, pages,
> -                                                        write_pos, write=
_len,
> -                                                        GFP_KERNEL);
> +                                                        write_pos, write=
_len);
>                         if (ret < 0) {
>                                 doutc(cl, "encryption failed with %d\n", =
ret);
>                                 ceph_release_page_vector(pages, num_pages=
);
>                                 break;
>                         }
> diff --git a/fs/ceph/inode.c b/fs/ceph/inode.c
> index 06cd2963e41ee..fc543075b827a 100644
> --- a/fs/ceph/inode.c
> +++ b/fs/ceph/inode.c
> @@ -2434,12 +2434,11 @@ static int fill_fscrypt_truncate(struct inode *in=
ode,
>                 memset(iov.iov_base + boff, 0, PAGE_SIZE - boff);
>
>                 /* encrypt the last block */
>                 ret =3D ceph_fscrypt_encrypt_block_inplace(inode, page,
>                                                     CEPH_FSCRYPT_BLOCK_SI=
ZE,
> -                                                   0, block,
> -                                                   GFP_KERNEL);
> +                                                   0, block);
>                 if (ret)
>                         goto out;
>         }
>
>         /* Insert the header */
> --
> 2.50.1
>
>


