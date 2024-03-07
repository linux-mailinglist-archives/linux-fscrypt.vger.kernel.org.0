Return-Path: <linux-fscrypt+bounces-238-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id A398D8744FD
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Mar 2024 01:05:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 9DFE4B2137E
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Mar 2024 00:05:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 137B137E;
	Thu,  7 Mar 2024 00:05:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="lyaXguPs"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AE9195;
	Thu,  7 Mar 2024 00:05:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709769933; cv=none; b=HmuhsL9xNQ2ovOJGzrRE0DNt2Z8I+IqcVmSotoJmuiPndXPJEcT9rUlkNdb6kIPGvPBEoAmqEmiEGQPjY2NcHTaa53YDONB/nwIP8EdkptJp0JZ5D6BiFVODkolHH9Gv3YyayN6VLNjCcGRWPhDwarNTwGM8y1dTbmiviWQ/wBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709769933; c=relaxed/simple;
	bh=TJ8+IzB+9C90XJ+2dzw39zog9VyaMRkZYRKOTYYvkKY=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=sO6QaXp0/9nI5i0dPBloELeqcb7hw4MgUqUGB6cVCJ5uEuDJ7MyIjh1UohvsI6L6iKvIvZofRBD3eKLMyHJwiEQyOQTD8sg7Ilzqtpetoyfv8NjmfBJj17OGqtPqs+ADH6LItiywElHuGBnIdD3VYSL7Y2qPhC4lfeUQtHUn68E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=lyaXguPs; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=DjyHBAlETyyG4Qr9GeB7lOlryT9zi8nmLMiWMox5uDQ=; b=lyaXguPsLdj8TZ3Ge2MrUqrwX9
	uAWMOQwzGqHTksc6F2yTd06wApmkllMcydlx7jdDm+VgzEeqzd6Yl+4hmgzoIrGWXK39lcXyZDC8m
	RMcURacG5kWTjEX/C0L3t42mMzuJ1pGKGv/fiSBZgCI143zdmjn/jVWtIGEEkFNkSzHhTlHAIRmhF
	991xnFaoZ+7kjBxq4zrUbHHU2fbZokIzdGZjN/UMjqtgRXOAiV1G4zk4tbQI3dqRW3g2MnPmdxH6Y
	gratT+c5yFRb+ik6xBN/5buFp/UyQ6RI49ZasE4mRJAs0SfUl+CWAoLBu1rdcZK0CZyoXyqXhZasb
	fEzA3ulA==;
Received: from [50.53.50.0] (helo=[192.168.254.15])
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ri1GJ-00000002LTs-0N9L;
	Thu, 07 Mar 2024 00:05:27 +0000
Message-ID: <cdf0ef59-9a21-45d5-9572-cbf2c63aa083@infradead.org>
Date: Wed, 6 Mar 2024 16:05:23 -0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v14 17/19] scripts: add boot policy generation program
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
 <1709768084-22539-18-git-send-email-wufan@linux.microsoft.com>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <1709768084-22539-18-git-send-email-wufan@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/6/24 15:34, Fan Wu wrote:
>  if SECURITY_IPE
> +config IPE_BOOT_POLICY
> +	string "Integrity policy to apply on system startup"
> +	help
> +	  This option specifies a filepath to a IPE policy that is compiled

	                                      an IPE

> +	  into the kernel. This policy will be enforced until a policy update
> +	  is deployed via the $securityfs/ipe/policies/$policy_name/active
> +	  interface.

-- 
#Randy

