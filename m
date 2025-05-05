Return-Path: <linux-fscrypt+bounces-656-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 50B94AA9DB2
	for <lists+linux-fscrypt@lfdr.de>; Mon,  5 May 2025 23:01:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 51229188E218
	for <lists+linux-fscrypt@lfdr.de>; Mon,  5 May 2025 21:02:10 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 24D112701D2;
	Mon,  5 May 2025 21:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Y+KVArNz"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 813B4450F2
	for <linux-fscrypt@vger.kernel.org>; Mon,  5 May 2025 21:01:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746478913; cv=none; b=oIaxbPbboOP6uTyyVKjCZatzomfrfVNn/xzoX8spVZQMod+9W2aKAkew87gTv6kHMHOPCvUu6q8mNMN+idaJpBC3lvf2AKiDHHYcmzXJSXXBWAcZqs5FAWlqNSBQ9JKUI0oS9w6vcjvXyl1R8VQOM+med03o40rHURWGPYxDMKM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746478913; c=relaxed/simple;
	bh=rTFXvpoFOiDsJ0MIB+jbnVwtIFoe/zbuCTQ6dEySNdc=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=tMpSkCqYFqtK+PBDElDvCR+yGnT9wI/UpWCYMZHEG89FCzgG6gj6Su40iuGHzZ/4WCl66KqOw2AxuRjmN6SwR9W+IpXIsmFcsmCgbzU7yocnUhjUGeE3Cw25HCj7NCcePeEI/y1FstIeNF1Rytsb1hU/5KdQ36c0mRka2FAUU0k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=Y+KVArNz; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746478910;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=lkCRFfNqatPCh1SRs3dEvTgyEfbqqLQiDH+3i3waEkI=;
	b=Y+KVArNz/LLoNm5cVC2UU7ubiJrF1+8d7ByZls+bttoOGPbfCt3tV0gsdU29H4lHyo/V3E
	yUWp8P2Mj1PRZzXohEvDB12qeE+B6PPAZvCCmiRuF9SC+ywwzYVx/IFticgAIirblnGSqe
	ubuE0PkhjOQbGVeON6D1DAUNXB/RxNo=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-649-F1MtIffoMpi8p4RZ4ZYCEw-1; Mon,
 05 May 2025 17:01:47 -0400
X-MC-Unique: F1MtIffoMpi8p4RZ4ZYCEw-1
X-Mimecast-MFC-AGG-ID: F1MtIffoMpi8p4RZ4ZYCEw_1746478905
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 74CAE1955E8C;
	Mon,  5 May 2025 21:01:45 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9337430001A2;
	Mon,  5 May 2025 21:01:42 +0000 (UTC)
Date: Mon, 5 May 2025 23:01:38 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
    Bartosz Golaszewski <brgl@bgdev.pl>, 
    Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: Re: [PATCH v2 2/2] dm: pass through operations on wrapped inline
 crypto keys
In-Reply-To: <20250505170336.GA197153@sol>
Message-ID: <5ca7e728-96ed-4419-6689-f36081b7e2da@redhat.com>
References: <20250501212320.8281-1-ebiggers@kernel.org> <20250501212320.8281-3-ebiggers@kernel.org> <af9771ce-5e88-02d1-3595-fd18a6f2eb28@redhat.com> <20250505170336.GA197153@sol>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4



On Mon, 5 May 2025, Eric Biggers wrote:

> On Mon, May 05, 2025 at 06:15:01PM +0200, Mikulas Patocka wrote:
> > 
> > I have a dumb question - if it doesn't matter through which block device 
> > do you set up the keys, why do you set them up through a block device at 
> > all?
> > 
> > What about making functions that set up the keys without taking block 
> > device as an argument, calling these functions directly and bypassing 
> > device mapper entirely?
> 
> Userspace needs to direct the key setup operations, so we'd need a UAPI for it
> to do so.  We could add a custom syscall, or some hacked-up extension of
> add_key(), and add a custom registration mechanism to allow a single
> implementation of wrapped keys (e.g. from ufs-qcom) to register itself as the

What happens if there are multiple ufs-qcom controllers? Is it 
unsupported?

> system's wrapped key provider which the syscall would then use.
> 
> But it seemed cleaner to instead use block device ioctls and take advantage of
> the existing blk-crypto-profile.  That already handles registering and
> unregistering the implementation, and it also already handles things like
> locking, and resuming the UFS controller if it's in suspend.
> 
> It also keeps the door open to supporting the case where different
> wrapped-key-capable block devices don't necessarily accept the same keys, even
> if that isn't the case currently.
> 
> - Eric

I think that using ioctl on block device is ok.

But I don't see why do you need to perform the ioctl on device mapper 
device and let device mapper select a random underlying device where the 
ioctl is forwarded? You can as well select a random physical disk in your 
userspace application and call the ioctl on it.

Mikulas


