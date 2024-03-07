Return-Path: <linux-fscrypt+bounces-236-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id C06D38744DF
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Mar 2024 01:01:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 71310284A51
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Mar 2024 00:01:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6AC5C3FC2;
	Thu,  7 Mar 2024 00:01:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="dOlLT0Y6"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 702CF184D;
	Thu,  7 Mar 2024 00:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709769695; cv=none; b=U6KGU7ogHZNX7064w4wK2MqWc7iL+D0dKfhkEI/7VmLIFhUXIDzhRA0Hg0uCPfIhKkGLz0MeQpbbYfsDGuYJSDeTOkwo3IIeg7DeSoDIqsO/XXyW2odVEjPJuVjznIesjFRoz/1HmDTINKHAAtaSey9ZiIbvcFnVxIj9B0QTohc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709769695; c=relaxed/simple;
	bh=E7W8VrToc9Q5zjwjAAez4HTRXB8IgFqG35utX+R/ung=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cSSjTXL+kHy8/+78x3KaXTQWIWAaCf728Ms+KEuYhN+1BUsyAYPPeBAzF9/rWbsMf7EKzo7qTH299Lgjo3pqhS/JhsNnRc1C6ApwIV1KVbe77fKkZLrLxa4oh82R7fIox3tPdJqudbKxnj2//s/TnVX2oK+9kX+lekEIZU0BEtk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=dOlLT0Y6; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=1fP13XQGUEfz1z7SMhLWWPsjALtv3SoNoV1WXE/0viY=; b=dOlLT0Y60dLj52Jqb5i+7q/tLR
	5J103CbDkkxLZE4ZyPj9e94ePa3KiMmc422jy2N0sOYqk9jk9MIeR8ry4EOp+N1DRyb42X7Ce9+F3
	UeME+hDMDBt4WrLLZiQW2q7ZL6ZiIrJOK1DpMmletKXUYdoeMwTqDGy834xmZVhbLshyQbUzrE4U1
	GuoaL/+yU2XVCX/eONZYqwmZn1N+tcsBmQAcIyV+ZvLAaNvb8tGpLjGkJDQRyYpzzQoVJasXWoyWC
	qM6SEAuWJ0n52IHcRqvOe01dVxLaWenALzuvbqHjyz4w/GsEdagAZ7a6DJHjeIcVgDsKvDcDUOVib
	VerE1RNQ==;
Received: from [50.53.50.0] (helo=[192.168.254.15])
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ri1CQ-00000002KmQ-2WTN;
	Thu, 07 Mar 2024 00:01:26 +0000
Message-ID: <4729647d-3c62-414a-8bce-bb4d3d12a811@infradead.org>
Date: Wed, 6 Mar 2024 16:01:23 -0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v14 14/19] ipe: add support for dm-verity as a trust
 provider
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
References: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
 <1709768084-22539-15-git-send-email-wufan@linux.microsoft.com>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <1709768084-22539-15-git-send-email-wufan@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/6/24 15:34, Fan Wu wrote:
> +if SECURITY_IPE
> +menu "IPE Trust Providers"
> +
> +config IPE_PROP_DM_VERITY
> +	bool "Enable support for dm-verity volumes"
> +	depends on DM_VERITY && DM_VERITY_VERIFY_ROOTHASH_SIG
> +	help
> +	  This option enables the properties 'dmverity_signature' and
> +	  'dmverity_roothash' in IPE policy. These properties evaluates

	                                                      evaluate

> +	  to TRUE when a file is evaluated against a dm-verity volume
> +	  that was mounted with a signed root-hash or the volume's
> +	  root hash matches the supplied value in the policy.

-- 
#Randy

