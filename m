Return-Path: <linux-fscrypt+bounces-805-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id E820DB3D19C
	for <lists+linux-fscrypt@lfdr.de>; Sun, 31 Aug 2025 11:25:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 420187AC519
	for <lists+linux-fscrypt@lfdr.de>; Sun, 31 Aug 2025 09:24:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 833C7246782;
	Sun, 31 Aug 2025 09:25:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b="jmXEALcl"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from todd.t-8ch.de (todd.t-8ch.de [159.69.126.157])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CD5B35959;
	Sun, 31 Aug 2025 09:25:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=159.69.126.157
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756632351; cv=none; b=iCyx7O4Cswdjnc2vQ517+pf/SFSabqNQVa0wKz5haf2U94fGJglyh2Xgrf/DbMPaL/whKnoJai/r3HhA4krjckC9vymKWwdih0UQORI5Pf0MOn6T06UXX7BPm2GyWIADl14S7t9nTl6d0ofYRWoygFgf/+5OOXKoGkJ60MaZGdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756632351; c=relaxed/simple;
	bh=yuEbaNU+/rxm70h9KnvKRcUSDxvBfJjr3tgfNsbyxNM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WLBoJoUGHoh98Q1HxFwpp0VEt9d6Pn/i0iSmWAVAIEetwskGDUdVnpslu1TO8DFbyK0FUv8MtWmoOWXgnmN7cPLQV7ZhzpB23m1bcm9/WdB/4pPbmIQH80z6QaqtqkGxCBLvRjnCaCf7G6DGTsovbZm+x0LrZ3g/2jKIfSb4dmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net; spf=pass smtp.mailfrom=weissschuh.net; dkim=pass (1024-bit key) header.d=weissschuh.net header.i=@weissschuh.net header.b=jmXEALcl; arc=none smtp.client-ip=159.69.126.157
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=weissschuh.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=weissschuh.net
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=weissschuh.net;
	s=mail; t=1756632024;
	bh=yuEbaNU+/rxm70h9KnvKRcUSDxvBfJjr3tgfNsbyxNM=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=jmXEALclS2I7F+0f6KYpHjNg2tOcq3U2xGdRoGw2zWJsr1rrTJapdvygKNtgvuelN
	 EloqhXl8iksmdTTQRPHYfcZu0izLF1WE+eEzFoq799ylfyfHrgmmkd/oBYAG7DX/hf
	 J1veg3bf/Fygal3tSSPv+GKqwfMET0f3yrvJK0Hs=
Date: Sun, 31 Aug 2025 11:20:23 +0200
From: Thomas =?utf-8?Q?Wei=C3=9Fschuh?= <linux@weissschuh.net>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: ebiggers@kernel.org, tytso@mit.edu, jaegeuk@kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: optimize fscrypt_base64url_encode() with block
 processing
Message-ID: <38753d95-8503-4b72-9590-cb129aa49a41@t-8ch.de>
References: <20250830132832.7911-1-409411716@gms.tku.edu.tw>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250830132832.7911-1-409411716@gms.tku.edu.tw>

On 2025-08-30 21:28:32+0800, Guan-Chun Wu wrote:
> Previously, fscrypt_base64url_encode() processed input one byte at a
> time, using a bitstream, accumulating bits and emitting characters when
> 6 bits were available. This was correct but added extra computation.

Can't the custom base64 implementations in fs/ not pass a custom table
and padding to the generic algorithm in lib/? Then we only need to maintain
this code once.


Thomas

