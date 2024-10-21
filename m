Return-Path: <linux-fscrypt+bounces-507-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DAC1E9A670E
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Oct 2024 13:53:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 081371C217F5
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Oct 2024 11:53:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E467C1E7C03;
	Mon, 21 Oct 2024 11:53:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="YrkGjsBp"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0A6D1E7C05
	for <linux-fscrypt@vger.kernel.org>; Mon, 21 Oct 2024 11:53:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729511594; cv=none; b=SH6JWKzoqhZifZ2lXYZ9TUotG9Gmu/7jW9fdDmmn6tEGsybmceJSv1ZdgLVmel0nKz3jZkW8bWcD1bVoA81xSF08PuwBoQILy7O2hg7WIGB1spxYin3hnpQBFP0xZZbhhXaefWvIq9ueX/8GQhVHR/kAf7rxYHxO1gIXgFuHl9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729511594; c=relaxed/simple;
	bh=C3SttAleNRdX+kbEry1Q63ZTLfxG+GRL8Io3dhLyU9o=;
	h=Date:From:To:cc:Subject:In-Reply-To:Message-ID:References:
	 MIME-Version:Content-Type; b=RcAx4MNeYpOPFWgahG2WhLmZfttL6W8esYIgHVI7IbIkkeUOkriKc/+iKwpSTV+wGqR9DhwN9NOzEVWqVHeBuAnutdhWBcDjJprXD0fs8waAM7JPmsDEFHMnWPLBhFRhBRUf32AiSywUH5RfXGM7+hfIPSNIo1t21ou+3mBqfGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=YrkGjsBp; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1729511591;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=SNCQhHzFd1NUHzGxH9c1VqwwdqX/nhUWNke4YanTciI=;
	b=YrkGjsBp9UEjwqLnOqglm7elzRa+A8eL1ntWuO678QiszE/jOB8ruiL9cP33qNitWprfEs
	TYcqF2ogkdGx0uSU6RV4f4eL/E1B5Yndmzq3DhPUnbtHD0YEdKchvGwKeSU2Jqt2ICv4Y/
	A8p+op101hTEXfYd0WrQmI5zyyMtHTs=
Received: from mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-351-YKvOEUpcMDKgFALrgs2VdQ-1; Mon,
 21 Oct 2024 07:53:08 -0400
X-MC-Unique: YKvOEUpcMDKgFALrgs2VdQ-1
Received: from mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.17])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 42C7619560AF;
	Mon, 21 Oct 2024 11:53:06 +0000 (UTC)
Received: from [10.45.226.64] (unknown [10.45.226.64])
	by mx-prod-int-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 1339E1956052;
	Mon, 21 Oct 2024 11:53:02 +0000 (UTC)
Date: Mon, 21 Oct 2024 13:52:58 +0200 (CEST)
From: Mikulas Patocka <mpatocka@redhat.com>
To: Eric Biggers <ebiggers@kernel.org>
cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org, 
    linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
    linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net, 
    Md Sadre Alam <quic_mdalam@quicinc.com>, 
    Israel Rukshin <israelr@nvidia.com>, Milan Broz <gmazyland@gmail.com>, 
    Adrian Vovk <adrianvovk@gmail.com>
Subject: Re: [RFC PATCH 0/4] dm-default-key: target for filesystem metadata
 encryption
In-Reply-To: <20241018184339.66601-1-ebiggers@kernel.org>
Message-ID: <b56689c6-c0cd-c44e-16fb-8a73c460aa87@redhat.com>
References: <20241018184339.66601-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.17



On Fri, 18 Oct 2024, Eric Biggers wrote:

> This series adds "metadata encryption" support to ext4 and f2fs via a
> new device-mapper target dm-default-key.  dm-default-key encrypts all
> data on a block device that isn't already encrypted by the filesystem.
> 
> Except for the passthrough support, dm-default-key is basically the same
> as the proposed dm-inlinecrypt which omits that feature
> (https://lore.kernel.org/dm-devel/20241016232748.134211-1-ebiggers@kernel.org/).
> 
> I am sending this out for reference, as dm-default-key (which Android
> has been using for a while) hasn't previously been sent to the lists in
> full, and there has been interest in it.  However, my current impression
> is that this feature will need to be redesigned as a filesystem native
> feature in order to make it upstream.  If that is indeed the case, then
> IMO it would make sense to merge dm-inlinecrypt in the mean time instead
> (or add its functionality to dm-crypt) so that anyone who just wants
> "dm-crypt + inline encryption hardware" gets a solution for that.

I we merge dm-inlinecrypt, we can't remove it later because users will 
depend on it. I think it is not sensible to have two targets 
(dm-inlinecrypt and dm-default-key) that do almost the same thing.

I've got another idea - what about a new target "dm-metadata-switch" that 
will take two block devices as arguments and it will pass metadata bios to 
the first device and data bios to the second device - so that the logic 
to decide where the bio will go would be decoupled from the encryption. 
Then, you can put dm-crypt or dm-inlinecrypt underneath 
"dm-metadata-switch".

----------------------
|     filesystem     |
----------------------
          |
          V
----------------------
| dm-metadata-switch |
----------------------
      |           |
      V           |
------------      |
| dm-crypt |      |
------------      |
      |           |
      V           V
-------------------------
| physical block device |
-------------------------

Mikulas


