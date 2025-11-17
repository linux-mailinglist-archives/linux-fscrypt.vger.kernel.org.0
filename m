Return-Path: <linux-fscrypt+bounces-970-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A2C6EC6597B
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Nov 2025 18:46:59 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sea.lore.kernel.org (Postfix) with ESMTPS id 5FE9428A48
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Nov 2025 17:46:58 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3CA972C08B6;
	Mon, 17 Nov 2025 17:46:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="rsgCdPZ3"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01E9B29B78D;
	Mon, 17 Nov 2025 17:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763401616; cv=none; b=HCQMN7dklyuVHoqjGhV1EcMkI/8rk1LaR3C2C55NJaZnvL3BRnInBBAV4WoaDnxvYbNCjvQy6nNiVWCBeRCDeHafovJ1iyGmi3vJ0Truf8b74U6ZBefY4YDVm1OExGlsRYpaw/fQZyXiEydhDAMIHRyT0p/ORm8RaCIkVm3lKK8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763401616; c=relaxed/simple;
	bh=8fQeAXFxhDLHZ8XWH5bVVIvjxQoz0qNlME78SIkpr88=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=m/aDdOr5iLChgXlIFvwT6wq5z7E9Nnu1Tzbz8NLsvUOGa8E3b2ORR7/VBh0tMw5DyJZ+y9LzMBf5P1qKIgVd8NvjIi9D7OZo9swy/RNWUhu2YPfIqkrpnWDNGat7TRE9FQSDy/OXC5VtUS+kWi1SldI+U8gkCwI/X4R61oXQvlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=rsgCdPZ3; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4C1C2BCB6;
	Mon, 17 Nov 2025 17:46:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763401615;
	bh=8fQeAXFxhDLHZ8XWH5bVVIvjxQoz0qNlME78SIkpr88=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=rsgCdPZ36Z3bVe/8qCb1BmS51FkMU+kCpPEgDGsqknMmPH4I1YAoorVLzSplynX4z
	 PzjCrDLx8f447Xr/nHhHMUBIsEvWZ8KfOv44mjgvdYldPsKDE9N0Fvza28ZufnyX2u
	 Me+X470C5QBNVCLTm9wZhmJBU2XW0OE2nNlnmouw=
Date: Mon, 17 Nov 2025 09:46:52 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: David Laight <david.laight.linux@gmail.com>,
 andriy.shevchenko@intel.com, axboe@kernel.dk, ceph-devel@vger.kernel.org,
 ebiggers@kernel.org, hch@lst.de, home7438072@gmail.com, idryomov@gmail.com,
 jaegeuk@kernel.org, kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v5 3/6] lib/base64: rework encode/decode for speed and
 stricter validation
Message-Id: <20251117094652.b04c6cf841d6426f70f23d22@linux-foundation.org>
In-Reply-To: <aRmnYTHmfPi1lyix@wu-Pro-E500-G6-WS720T>
References: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
	<20251114060132.89279-1-409411716@gms.tku.edu.tw>
	<20251114091830.5325eed3@pumpkin>
	<aRmnYTHmfPi1lyix@wu-Pro-E500-G6-WS720T>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Sun, 16 Nov 2025 18:28:49 +0800 Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:

> > Reviewed-by: David Laight <david.laight.linux@gmail.com>
> > 
> > But see minor nit below.
> 
> Hi David,
> 
> Thanks for the review and for pointing this out.
> 
> Andrew, would it be possible for you to fold this small change 
> (removing the redundant casts) directly when updating the patch?
> If that’s not convenient, I can resend an updated version of the
> series instead. 

Sure, I added this:


--- a/lib/base64.c~lib-base64-rework-encode-decode-for-speed-and-stricter-validation-fix
+++ a/lib/base64.c
@@ -83,7 +83,7 @@ int base64_encode(const u8 *src, int src
 	const char *base64_table = base64_tables[variant];
 
 	while (srclen >= 3) {
-		ac = (u32)src[0] << 16 | (u32)src[1] << 8 | (u32)src[2];
+		ac = src[0] << 16 | src[1] << 8 | src[2];
 		*cp++ = base64_table[ac >> 18];
 		*cp++ = base64_table[(ac >> 12) & 0x3f];
 		*cp++ = base64_table[(ac >> 6) & 0x3f];
@@ -95,7 +95,7 @@ int base64_encode(const u8 *src, int src
 
 	switch (srclen) {
 	case 2:
-		ac = (u32)src[0] << 16 | (u32)src[1] << 8;
+		ac = src[0] << 16 | src[1] << 8;
 		*cp++ = base64_table[ac >> 18];
 		*cp++ = base64_table[(ac >> 12) & 0x3f];
 		*cp++ = base64_table[(ac >> 6) & 0x3f];
@@ -103,7 +103,7 @@ int base64_encode(const u8 *src, int src
 			*cp++ = '=';
 		break;
 	case 1:
-		ac = (u32)src[0] << 16;
+		ac = src[0] << 16;
 		*cp++ = base64_table[ac >> 18];
 		*cp++ = base64_table[(ac >> 12) & 0x3f];
 		if (padding) {
_


