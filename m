Return-Path: <linux-fscrypt+bounces-606-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id F3772A2FACF
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Feb 2025 21:40:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 9E489160A3D
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Feb 2025 20:40:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EF643264605;
	Mon, 10 Feb 2025 20:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eeyefSIA"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B04264601;
	Mon, 10 Feb 2025 20:40:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739220041; cv=none; b=R8LuzKVtklxY+/GkmQJWMX+OTIatkOUx1JC7umNTqf+NZUWYW+MYbYXxvOEzxKNd8fIH03z5EHfcyUcwu9j6H3CO9GDWUjGLEdEm38WkRFlTKsr1I/Dbyyf7l/EgDQaf7WzjHq3taTpR/mUvAr7qVTmidwZhDMCxqQMZjQyZx8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739220041; c=relaxed/simple;
	bh=0wnetRN+jRy6jUsc8cAkPnNSFjqYwlnTVz0IZ1qf2Fg=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UrZkvPsld67GPuOGNtRALgwFYjuTweGff/qUuBfHzyKcmaa2AeVdsqjMlZUNEFXE+V8uClzBt0PDuhyR1/JgUQlbacZKSZiXUu2LA9iJ0DCUsGYYtlm3jkMD28ahs0bfuqXOJk0bav69S3NXYagCv+I6s82hVC1jhyFMx0myQHk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eeyefSIA; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0306C4CED1;
	Mon, 10 Feb 2025 20:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1739220041;
	bh=0wnetRN+jRy6jUsc8cAkPnNSFjqYwlnTVz0IZ1qf2Fg=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eeyefSIA5Z0Njw/2L0qAWk9FzWQge34LQ7iIET64jIABFUggb9Yv3RGub8e5AaiVo
	 hqd8DsFXZ7C6KfVJvEXJUJ05N5q/HTp3ZuF9qROk+Q8mFtKnYe4xP+/QLqHd2aDT6Y
	 RNZilLiWVsNfAmH3e/AXS99D7/xXcm6VxHLoc9K+VgGS2dDE2SQVGgW+FEYHsnxMfQ
	 AnHwH/d8Lq+NOWTZaVypY0KO6iTNvo/L9h3SFar7qH+SfQUzK0PGMrCLdLd/5XKJUz
	 UX+Zpfq+jKvpdNGlvxii6aHGvrev6qcn0b04diOc1zQveT90XzPX5QMRI7DkHBVuDO
	 kwY5mIc03DXmg==
Date: Mon, 10 Feb 2025 12:40:39 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: fstests@vger.kernel.org, Zorro Lang <zlang@kernel.org>
Cc: linux-fscrypt@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: Re: [xfstests PATCH] fscrypt-crypt-util: fix KDF contexts for SM8650
Message-ID: <20250210204039.GB348261@sol.localdomain>
References: <20250118072336.605023-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250118072336.605023-1-ebiggers@kernel.org>

On Fri, Jan 17, 2025 at 11:23:36PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Update the KDF contexts to match those actually used on SM8650.  This
> turns out to be needed for the hardware-wrapped key tests generic/368
> and generic/369 to pass on the SM8650 HDK (now that I have one to
> actually test it).  Apparently the contexts changed between the
> prototype version I tested a couple years ago and the final version.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  src/fscrypt-crypt-util.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Ping.  Zorro, could you apply this please?  Thanks!

- Eric

