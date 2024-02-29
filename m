Return-Path: <linux-fscrypt+bounces-205-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 87F9386BFB5
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Feb 2024 05:01:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 42E66284F05
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Feb 2024 04:01:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B01E7376F1;
	Thu, 29 Feb 2024 04:01:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="kuP5Y7E0"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAA9E364D8;
	Thu, 29 Feb 2024 04:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709179288; cv=none; b=FZMkEqOMMWzfDzZrKtoZs0/LD4LwtfSFAJkHCuMGyFdxPam0x3y9hJhmWVQuHcKtmCtON5UCflpP9VpeXwJ2jBgmiSMDrXJEzc4S1yvHB4+kBb+Y4sl/o1raGBxhXFL86AUr5uVgsaF1a0wDN3JGTra3dSRWu/UYcg7E/Dg+pMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709179288; c=relaxed/simple;
	bh=jXQXz+PeGueyYtvLDE3yOIBci2d2WEXu0s/u7WCNEZ0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AXVm8+sd0RB/YFPifLc5fIIgfreezUSap/w/vqXzaLUGlaolZXqEmTdqyt5O4BQ0lwLHxazltDJrnIHD40/vYYXZLSNY5B6YAKD7dbPBvNdiq+BwvZ/4pQV4uNTvL3WGURtM081N3XVq5lYi+5z5g8IkU8RaCJCYqszPZmP0Oqs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=kuP5Y7E0; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=IkaDFHzSJFvHKVuhr/vGVExR1dL16usQzaOTDa83SZU=; b=kuP5Y7E0UEVVvoc4oBQW9X5uCp
	78BOH0TZU/YqS5GDK/mP3UJn1iH7u1777o24iLj1DiLnc+FW2KT1HTnoAZGjH/FLZ5Y5fq+04Dw/a
	8ARxAHD5MksdRmCRZKP6DTdwpNNS95g8cDLdt3d9P39iOFm8rNjlvcdCOopxiw8KBDKOl8WqcWXJr
	Y+iuI+pNr6CJ0noV1digXsts+JLu+IsxNjEl9Go0sRwhnsEHfLqi2Ldef34MzZ8HMhkqqKdDNimxU
	Fi+Wx2Rsx7JeVSNJH+m0ceaasHOXSIAi3QWLUOenkUToasyCVbNPctbeQu/U+2mSk8XWb5+Y4k3Cb
	290yUPhw==;
Received: from [50.53.50.0] (helo=[192.168.254.15])
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1rfXbh-0000000Bz2k-2ADm;
	Thu, 29 Feb 2024 04:01:17 +0000
Message-ID: <193bd5e5-2263-4e67-b7c6-bb25dc9a6854@infradead.org>
Date: Wed, 28 Feb 2024 20:01:16 -0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v13 17/20] ipe: enable support for fs-verity as a
 trust provider
Content-Language: en-US
To: Fan Wu <wufan@linux.microsoft.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com,
 paul@paul-moore.com
Cc: linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 audit@vger.kernel.org, linux-kernel@vger.kernel.org,
 Deven Bowers <deven.desai@linux.microsoft.com>
References: <1709168102-7677-1-git-send-email-wufan@linux.microsoft.com>
 <1709168102-7677-18-git-send-email-wufan@linux.microsoft.com>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <1709168102-7677-18-git-send-email-wufan@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 2/28/24 16:54, Fan Wu wrote:
> diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
> index 7afb1ce0cb99..9dd5c4769d79 100644
> --- a/security/ipe/Kconfig
> +++ b/security/ipe/Kconfig
> @@ -30,6 +30,19 @@ config IPE_PROP_DM_VERITY
>  	  that was mounted with a signed root-hash or the volume's
>  	  root hash matches the supplied value in the policy.
>  
> +	  If unsure, answer Y.
> +
> +config IPE_PROP_FS_VERITY
> +	bool "Enable property for fs-verity files"
> +	depends on FS_VERITY && FS_VERITY_BUILTIN_SIGNATURES
> +	help
> +	  This option enables the usage of properties "fsverity_signature"
> +	  and "fsverity_digest". These properties evaluates to TRUE when
> +	  a file is fsverity enabled and with a signed digest or its
> +	  diegst matches the supplied value in the policy.

	  digest

> +
> +	  if unsure, answer Y.

-- 
#Randy

