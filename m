Return-Path: <linux-fscrypt+bounces-248-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7A61B879B11
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Mar 2024 19:14:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 361FE2841B9
	for <lists+linux-fscrypt@lfdr.de>; Tue, 12 Mar 2024 18:14:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D2AC13956D;
	Tue, 12 Mar 2024 18:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="AwsfC1qr"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DC8311386D1;
	Tue, 12 Mar 2024 18:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710267268; cv=none; b=ii6o9wR6T65P0zZx966Y/WiySMhdoCoA7KxmgoB7GTtnGB1N+YrrPLAVdYGNwQPu2x6XKffh8p9ZPig73ta4iIpXSdUKEozS8Wnqr8kPB0LNamzHFAb0BEYmr8VzW/6P88G1OFSD0xGaMbz4v1TRugz/vVEVagC43Ys8q4YlL7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710267268; c=relaxed/simple;
	bh=+Nv8FE2GFtnryYnuFjMt1J6p/3YJi1lq7lWALWFCNLU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nbeMscGtO2pS7tzkLpR05Jywxs2MDt5HsSKG67uBqgrwl4Ehq6JI2wWw4RaDB7L/0N06tKjolxDsvWm5BnFVuqFNNSfjfZOGnla4KzcYtlp+fUT8bzOVP6ezKZn64lYFmp0zwAE9KUP+o4o3VMesMnkJzviG+NjUpqCVr96FRv0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=AwsfC1qr; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [10.137.106.151] (unknown [167.220.2.23])
	by linux.microsoft.com (Postfix) with ESMTPSA id 4696020B74C0;
	Tue, 12 Mar 2024 11:14:26 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4696020B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1710267266;
	bh=7A1zrZAVHXKGttwPdOtLQCc2bRvvqSB12WrZItI5omI=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=AwsfC1qrQaxGBl/fdJD2faD0hl9FFmeBlCLlRgyTQvlkdWZDaVw25t2K6lGQPegFI
	 ykP/qN5yTVNTrsLADx0NdOTg2ngKpt+eyntjyybMaNeHjRlIHLVMavUDIz0AnD7mpo
	 jkZW9SEWeZfy1Nfhg8NaYxMEU0DhvLjCIcb3CkWY=
Message-ID: <51810153-eb6e-40f7-b5d0-5f72c2f4ee9b@linux.microsoft.com>
Date: Tue, 12 Mar 2024 11:14:26 -0700
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v14 15/19] fsverity: consume builtin signature via LSM
 hook
Content-Language: en-CA
To: Eric Biggers <ebiggers@kernel.org>
Cc: corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
 tytso@mit.edu, axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
 eparis@redhat.com, paul@paul-moore.com, linux-doc@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-security-module@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
 dm-devel@lists.linux.dev, audit@vger.kernel.org,
 linux-kernel@vger.kernel.org, Deven Bowers <deven.desai@linux.microsoft.com>
References: <1709768084-22539-1-git-send-email-wufan@linux.microsoft.com>
 <1709768084-22539-16-git-send-email-wufan@linux.microsoft.com>
 <20240312025712.GE1182@sol.localdomain>
 <20240312030712.GF1182@sol.localdomain>
From: Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <20240312030712.GF1182@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 3/11/2024 8:07 PM, Eric Biggers wrote:
> On Mon, Mar 11, 2024 at 07:57:12PM -0700, Eric Biggers wrote:
>>
>> As I've said before, this commit message needs some work.  It currently doesn't
>> say anything about what the patch actually does.
>>
>> BTW, please make sure you're Cc'ing the fsverity mailing list
>> (fsverity@lists.linux.dev), not fscrypt (linux-fscrypt@vger.kernel.org).
> 
> Also, I thought this patch was using a new LSM hook, but I now see that you're
> actually abusing the existing security_inode_setsecurity() LSM hook.  Currently
> that hook is called when an xattr is set.  I don't see any precedent for
> overloading it for other purposes.  This seems problematic, as it means that a
> request to set an xattr with the name you chose ("fsverity.builtin-sig") will be
> interpreted by LSMs as the fsverity builtin signature.  A dedicated LSM hook may
> be necessary to avoid issues with overloading the existing xattr hook like this.
> 
> - Eric

Thanks for the suggestion. I found that using 
security_inode_setsecurity() causes issues with SMACK's 
inode_setsecurity() hook. I will crate a dedicated new hook like 
security_inode_setsig() in the next version.

-Fan

