Return-Path: <linux-fscrypt+bounces-237-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id CE93C8744E5
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Mar 2024 01:02:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0C91F1C21FC8
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 Mar 2024 00:02:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C146ED9;
	Thu,  7 Mar 2024 00:02:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="UiBIGKli"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from bombadil.infradead.org (bombadil.infradead.org [198.137.202.133])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36B9800;
	Thu,  7 Mar 2024 00:02:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=198.137.202.133
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709769753; cv=none; b=hFwDq3vCI+4RQpsF4w4Twvhk8BWRRb829I591SVLiLzdghgQr/hrftEG9pJWmR+zlX0BtyYPYIoFUxRzKcVk2a+HbsaNQViz2+JdZ6yizzxoZIDcdsOe09AAhyk/oYYmWZTP5FkwI7PTbp1Bp7x3w2yIeY/HfBiilVcTRSeBpHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709769753; c=relaxed/simple;
	bh=nNdfSfVmh1rMkyb8bpupDBkIG5hU918qZygMFKcOavs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=onKK5THqAT9dS9IA0BNTYEJviU4YO51BChU60KqieadBEaE4bxNiPWOugGac4wGoF78Ok/g7z1bhs8N0j0V1gKmGaVCfge5+xZZ/Zd++ZK4rBe7d/0kP5KNPBXzgP8PcxGRI83/DiiWfKcLk5XhobE3lK8srXhZEOqDtmLnMwZ4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=UiBIGKli; arc=none smtp.client-ip=198.137.202.133
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
	Content-Type:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:
	Message-ID:Sender:Reply-To:Content-ID:Content-Description;
	bh=amr/+e1tSpALZHXPu4iiTw245Vf6YVli5H5FIkFLKbY=; b=UiBIGKliaJ+r6aDitzeQxrEZ/a
	yaifwhhLhkQcCBl8qincQNEBlg5BnSQP1MB8osaNu0ervdcvOVtPp7yfCcpWNSx7Xqo69bfmSEufX
	ziIvmV857FbtseNJlUo/96UY6TnK7s+NqvxBPyV5F291+NTVbiodWBfzEwav+6sq4VCjaL5uK5RbN
	Qb7ttZrn2WYc8cv5yHNKWKLdQugEDUIt9BRko3qyl5nzNbqZSNXoj2xI+cyHG19bfb/4sKPEkUWNP
	g8Pv4A5GfT2FRMOfcWB4zvD7FlRDoicGlWhrVdzp7fNhMq5VNuXGxqH92H9n774vYo01cIZ0wlu17
	YYndfbGw==;
Received: from [50.53.50.0] (helo=[192.168.254.15])
	by bombadil.infradead.org with esmtpsa (Exim 4.97.1 #2 (Red Hat Linux))
	id 1ri1DP-00000002KmQ-1nhw;
	Thu, 07 Mar 2024 00:02:27 +0000
Message-ID: <cb5c1c98-3502-401b-b554-bc141c73f835@infradead.org>
Date: Wed, 6 Mar 2024 16:02:26 -0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v14 16/19] ipe: enable support for fs-verity as a
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
References: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
 <1709768084-22539-17-git-send-email-wufan@linux.microsoft.com>
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <1709768084-22539-17-git-send-email-wufan@linux.microsoft.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 3/6/24 15:34, Fan Wu wrote:
> +config IPE_PROP_FS_VERITY
> +	bool "Enable property for fs-verity files"
> +	depends on FS_VERITY && FS_VERITY_BUILTIN_SIGNATURES
> +	help
> +	  This option enables the usage of properties "fsverity_signature"
> +	  and "fsverity_digest". These properties evaluates to TRUE when

	                                          evaluate

> +	  a file is fsverity enabled and with a signed digest or its
> +	  digest matches the supplied value in the policy.

-- 
#Randy

