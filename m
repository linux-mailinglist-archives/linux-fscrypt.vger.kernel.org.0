Return-Path: <linux-fscrypt+bounces-32-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id D63727F5769
	for <lists+linux-fscrypt@lfdr.de>; Thu, 23 Nov 2023 05:32:45 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7CD11281744
	for <lists+linux-fscrypt@lfdr.de>; Thu, 23 Nov 2023 04:32:44 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4532EBE64;
	Thu, 23 Nov 2023 04:32:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="K+q6FtFg"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 992B5199
	for <linux-fscrypt@vger.kernel.org>; Wed, 22 Nov 2023 20:32:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1700713955;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=p/RxEdVo2tTEZY1l5idatcfPWUNnH5H6CT5tTe4WQUs=;
	b=K+q6FtFg+cnRc2X/AnBQ6eEqpfCzjYg/+JoeEEDjU2AE9fbAO6QpicTCqMPDSYiD+1oP94
	LnyG0OOJX4XujfYnTETgCfxnL1nBaGfkdejcX8EIM0xm53z4NorPBvVWpZPxXzotZrvNuo
	y0lC6EgbvOWZJfygkwnxje5LOxcsol8=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-62-nUXsmbycNL-JIfkczBMghQ-1; Wed, 22 Nov 2023 23:32:32 -0500
X-MC-Unique: nUXsmbycNL-JIfkczBMghQ-1
Received: by mail-pl1-f199.google.com with SMTP id d9443c01a7336-1cf62ae2df2so6544955ad.0
        for <linux-fscrypt@vger.kernel.org>; Wed, 22 Nov 2023 20:32:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1700713951; x=1701318751;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=p/RxEdVo2tTEZY1l5idatcfPWUNnH5H6CT5tTe4WQUs=;
        b=IfpSCUPJ8+A2HiTwBVyfVoykT+MF/Da+laPswLvKa7MMeiFH8MBPGZuvebMZRhVsOX
         FmJ5OxBE9NAiu0qXn+Y4LkUHsVFZtx/nABcKV921Bn982XfoWenbxFGrO5NBzSIXSn/Z
         sRaS/I1cNH2Ns0mGReUe+P1VvNSaAyXpejoxh/OhDFOiD0w9wb9lkCbyZvODp4OWVHZB
         VM7gILrtMYQrBUfa3vJJ8Ara7boZ+c9V+0m+Fc7A6fEYlRg8RdUi9jjzK+qDoYX1H4Hb
         HPqSEYSSqjOx+wk8bNyAaDQ6LT2A5CGea7nFylkGU/a8/U9U/3u86chHKvPsnG4RMA5J
         rojA==
X-Gm-Message-State: AOJu0Yy3GW72P3yzBAS3NbOHNPgn9Y7W2S8abiKTpbEQl8pQl25EUQR3
	Q3okDAfSGtpHIGawhfQqqJn/IpMlho2L3RHmmQnDmMQQVbfOMCBCgYqu/Ws/tFXUpfKItWTHeov
	jcJilWIa4JzyJOgKq1PAYMVAI3g==
X-Received: by 2002:a17:903:428b:b0:1c3:4b24:d89d with SMTP id ju11-20020a170903428b00b001c34b24d89dmr4875224plb.40.1700713951178;
        Wed, 22 Nov 2023 20:32:31 -0800 (PST)
X-Google-Smtp-Source: AGHT+IGQx5QnyMOtAGiy5FcvtpmUEdGNjAQiaQOFyix6Z/4HvNl6UhF7Ywdql+khXKEwVycn23klaA==
X-Received: by 2002:a17:903:428b:b0:1c3:4b24:d89d with SMTP id ju11-20020a170903428b00b001c34b24d89dmr4875211plb.40.1700713950895;
        Wed, 22 Nov 2023 20:32:30 -0800 (PST)
Received: from [10.72.112.224] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id v3-20020a1709029a0300b001bf044dc1a6sm257314plp.39.2023.11.22.20.32.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 22 Nov 2023 20:32:30 -0800 (PST)
Message-ID: <9df30dc2-bc1c-b0fc-156f-baad37def05b@redhat.com>
Date: Thu, 23 Nov 2023 12:32:27 +0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] ceph: select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
Content-Language: en-US
To: Eric Biggers <ebiggers@kernel.org>, ceph-devel@vger.kernel.org
Cc: linux-fscrypt@vger.kernel.org, stable@vger.kernel.org
References: <20231123030838.46158-1-ebiggers@kernel.org>
From: Xiubo Li <xiubli@redhat.com>
In-Reply-To: <20231123030838.46158-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit


On 11/23/23 11:08, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
>
> The kconfig options for filesystems that support FS_ENCRYPTION are
> supposed to select FS_ENCRYPTION_ALGS.  This is needed to ensure that
> required crypto algorithms get enabled as loadable modules or builtin as
> is appropriate for the set of enabled filesystems.  Do this for CEPH_FS
> so that there aren't any missing algorithms if someone happens to have
> CEPH_FS as their only enabled filesystem that supports encryption.
>
> Fixes: f061feda6c54 ("ceph: add fscrypt ioctls and ceph.fscrypt.auth vxattr")
> Cc: stable@vger.kernel.org
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>   fs/ceph/Kconfig | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/fs/ceph/Kconfig b/fs/ceph/Kconfig
> index 94df854147d35..7249d70e1a43f 100644
> --- a/fs/ceph/Kconfig
> +++ b/fs/ceph/Kconfig
> @@ -1,19 +1,20 @@
>   # SPDX-License-Identifier: GPL-2.0-only
>   config CEPH_FS
>   	tristate "Ceph distributed file system"
>   	depends on INET
>   	select CEPH_LIB
>   	select LIBCRC32C
>   	select CRYPTO_AES
>   	select CRYPTO
>   	select NETFS_SUPPORT
> +	select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
>   	default n
>   	help
>   	  Choose Y or M here to include support for mounting the
>   	  experimental Ceph distributed file system.  Ceph is an extremely
>   	  scalable file system designed to provide high performance,
>   	  reliable access to petabytes of storage.
>   
>   	  More information at https://ceph.io/.
>   
>   	  If unsure, say N.
>
> base-commit: 9b6de136b5f0158c60844f85286a593cb70fb364

Thanks Eric. This looks good to me.

Reviewed-by: Xiubo Li <xiubli@redhat.com>


