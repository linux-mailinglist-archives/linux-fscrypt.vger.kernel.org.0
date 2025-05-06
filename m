Return-Path: <linux-fscrypt+bounces-658-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 69293AACC06
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 May 2025 19:14:35 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 816771C40D4A
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 May 2025 17:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 69B30284B20;
	Tue,  6 May 2025 17:14:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="HfPzR2Jq"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B35C72836AB
	for <linux-fscrypt@vger.kernel.org>; Tue,  6 May 2025 17:14:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746551668; cv=none; b=t0jViIr8AzUvu0wjnWmT+8GBf6IHsO50MvHSKETe9pCtYPPaMqpxdjYCxLs7wXL9s4vllNvZD109NPc8WR0QlgsJy2QCnoJBJJuwKYoEycRZnLOT9oHQ0OcVqQG1tnGKPM+5//L3uACJWxaAK9qzzr9n0sWFd63AYL0zOiekWF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746551668; c=relaxed/simple;
	bh=YJlIiL2as+FQzRYLAmfyUw6lBk0apgvBss0amf+RMTg=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=ToxLoFRU3vHaRHCnkJ0AEivWpeVEQfVVzQZJqQrW+wiPuYaNTXqNOVwlJUhucrBFLwJPCvtzXh50+Pv4cAf5B1/Iio1MgTIByrlLmNl4zUv4kYyo7pT4i3+vM1fQoSvVIl2tlt+3Mixn/96N8IYWlALgBDPbaS/lmLjyYWxqBNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=HfPzR2Jq; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1746551665;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SDuv8z2Zer1kzmJsg6JfkCgHosBhI0/BOFDH4XiwtSw=;
	b=HfPzR2Jq8siNuSL8fZXFwIMKr6N6UTFm/f76cFU9vtObYjlX6Eh8Iv/8qioR/bg7KNouqZ
	lGnTfn/1/QLV9p+Z9h/b3V4gof+t3K76b+Oo7m83560hfDsJUpeI5I4w6ZMCm/38U+Xh+Q
	WKsCDvt7ScBJ1ypxHItziUYQk9rGU74=
Received: from mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-248-hZeuOhmVOcCR-ecxitQPig-1; Tue,
 06 May 2025 13:14:17 -0400
X-MC-Unique: hZeuOhmVOcCR-ecxitQPig-1
X-Mimecast-MFC-AGG-ID: hZeuOhmVOcCR-ecxitQPig_1746551654
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id BCD0C1800ECA;
	Tue,  6 May 2025 17:14:13 +0000 (UTC)
Received: from [10.22.80.45] (unknown [10.22.80.45])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 03A30195608F;
	Tue,  6 May 2025 17:14:10 +0000 (UTC)
Date: Tue, 6 May 2025 19:14:06 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: dm-devel@lists.linux.dev, Alasdair Kergon <agk@redhat.com>, 
    Mike Snitzer <snitzer@kernel.org>, linux-block@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
    Bartosz Golaszewski <brgl@bgdev.pl>, 
    Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: Re: [PATCH v2 2/2] dm: pass through operations on wrapped inline
 crypto keys
In-Reply-To: <20250505211428.GA10047@google.com>
Message-ID: <3a0ef010-ec08-de32-134f-80286a3960c9@redhat.com>
References: <20250501212320.8281-1-ebiggers@kernel.org> <20250501212320.8281-3-ebiggers@kernel.org> <af9771ce-5e88-02d1-3595-fd18a6f2eb28@redhat.com> <20250505170336.GA197153@sol> <5ca7e728-96ed-4419-6689-f36081b7e2da@redhat.com>
 <20250505211428.GA10047@google.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17



On Mon, 5 May 2025, Eric Biggers wrote:

> We have to forward derive_sw_secret anyway, since that's invoked by the
> filesystem, not by the ioctls.
> 
> The other operations are for the ioctls, but I don't see a reason to make things
> harder for userspace by forcing userspace to implement logic like:
> 
>     if (is_dm(blkdev))
>         blkdev = underlying_device(blkdev)
>     ioctl(blkdev)
> 
> The device-mapper block device has a blk-crypto profile that declares wrapped
> key support.  We should just make the ioctls work on that block device, so that
> upper layers don't need to care whether it's device-mapper or native.
> 
> - Eric

OK, I accepted both patches for the next merge window.

Mikulas


