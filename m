Return-Path: <linux-fscrypt+bounces-1541-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id +ERaE7z7xGny5QQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1541-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Mar 2026 10:26:20 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id ACD4633249A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Mar 2026 10:26:19 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 58F0331A075B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 26 Mar 2026 09:13:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 193BD3BAD98;
	Thu, 26 Mar 2026 09:13:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b="fmY0N3nv"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from abb.hmeau.com (abb.hmeau.com [180.181.231.80])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A0B3BA240;
	Thu, 26 Mar 2026 09:13:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=180.181.231.80
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774516397; cv=none; b=if9+A8/AlUiReiBNS1gXPY9rHflzPDSRGTxE7AkBZpIKuI5EIqh8YPAGRiaNzmU/u/ARHDhvH4B0s+Hq8UAO4f65PU8U8npWjI/uFddx6lenWRBn/mdY4KgQloTrtij2PLKMQAeIG5EJetqtkKiCJohTdQC4eMo+JKN9a/Y2Jeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774516397; c=relaxed/simple;
	bh=hint5GgHxMIQ02zA8RdtL+NcbCotYoFlkHa+WVfCdac=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=G6NPJl1zLA1pVgdwT+6QDQVkkPAZH5GUmJt+tmR6TEIJscKSSiunIO8Gcho9jK2q6gaKo3kkd/wsAGS2GDsRsYxTbMSmXrtnp4/JiNS+atN98L+nuEkMGxkQ4BATM0+4QCZvmrmqxN6YHSwCAV/XELeUS4rgqYBfM9062srucXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au; spf=pass smtp.mailfrom=gondor.apana.org.au; dkim=pass (2048-bit key) header.d=gondor.apana.org.au header.i=@gondor.apana.org.au header.b=fmY0N3nv; arc=none smtp.client-ip=180.181.231.80
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=gondor.apana.org.au
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gondor.apana.org.au
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=gondor.apana.org.au; s=h01; h=In-Reply-To:Content-Type:MIME-Version:
	References:Message-ID:Subject:Cc:To:From:Date:cc:to:subject:message-id:date:
	from:content-type:reply-to; bh=nzLsyzPmerOoZxU39vp3ZR2pOob3tan7VXeaMuN/gYQ=; 
	b=fmY0N3nvpfyKiq9cu68/CKPt7FuEZ7pq1HvzKFsA2/A/UVmMy3c+MSyRogAUsHN5gt0ub9QvXId
	LnlVR0BBb2rpxYGYKt5EGvQM6Af4KPhqasBgnXQhSMIdhx6GqososTRuy/4HQlZosIda1FJHIJUCD
	CWQDaQaN54CvH8ocVp1dIl3RoMxiDOM7deXoNvoJ/68Cxoeo2uCLb6Z7Xrxl6ihN3jMDeH+zgh13q
	mj3bUonxtPgbjNcNQErflN3Sa8OnPbieRm/NSip6DpiuG1U5Ss0WhA5VCdlq+f1dgVeeH1NBAVMwa
	fPelXFY8cGNw5cebvyy6JpzaFwDSCDLrJ9Lw==;
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
	by formenos.hmeau.com with smtp (Exim 4.96 #2 (Debian))
	id 1w5gMY-001FpR-1P;
	Thu, 26 Mar 2026 17:13:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 26 Mar 2026 18:13:05 +0900
Date: Thu, 26 Mar 2026 18:13:05 +0900
From: Herbert Xu <herbert@gondor.apana.org.au>
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-crypto@vger.kernel.org, linux-ext4@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Zorro Lang <zlang@redhat.com>, stable@vger.kernel.org,
	Akhil R <akhilrajeev@nvidia.com>
Subject: Re: [PATCH v2] crypto: tegra - Add missing CRYPTO_ALG_ASYNC
Message-ID: <acT4ocMTLlNLfxcK@gondor.apana.org.au>
References: <20260316202119.13934-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260316202119.13934-1-ebiggers@kernel.org>
X-Spamd-Result: default: False [-0.66 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	DMARC_POLICY_ALLOW(-0.50)[apana.org.au,quarantine];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[gondor.apana.org.au:s=h01];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,nvidia.com,redhat.com];
	FROM_HAS_DN(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	DKIM_TRACE(0.00)[gondor.apana.org.au:+];
	TAGGED_FROM(0.00)[bounces-1541-lists,linux-fscrypt=lfdr.de];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	RCVD_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[herbert@gondor.apana.org.au,linux-fscrypt@vger.kernel.org];
	MISSING_XM_UA(0.00)[];
	NEURAL_HAM(-0.00)[-1.000];
	RCPT_COUNT_SEVEN(0.00)[9];
	MID_RHS_MATCH_FROM(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[gondor.apana.org.au:dkim,gondor.apana.org.au:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,apana.org.au:email,apana.org.au:url,nvidia.com:email]
X-Rspamd-Queue-Id: ACD4633249A
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

On Mon, Mar 16, 2026 at 01:21:19PM -0700, Eric Biggers wrote:
> The tegra crypto driver failed to set the CRYPTO_ALG_ASYNC on its
> asynchronous algorithms, causing the crypto API to select them for users
> that request only synchronous algorithms.  This causes crashes (at
> least).  Fix this by adding the flag like what the other drivers do.
> Also remove the unnecessary CRYPTO_ALG_TYPE_* flags, since those just
> get ignored and overridden by the registration function anyway.
> 
> Reported-by: Zorro Lang <zlang@redhat.com>
> Closes: https://lore.kernel.org/r/20260314080937.pghb4aa7d4je3mhh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com
> Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
> Cc: stable@vger.kernel.org
> Cc: Akhil R <akhilrajeev@nvidia.com>
> Signed-off-by: Eric Biggers <ebiggers@kernel.org>
> ---
> 
> This patch is targeting crypto/master.
> 
> v2: fix tegra-se-hash.c as well, and remove unnecessary type flags
> 
>  drivers/crypto/tegra/tegra-se-aes.c  | 11 ++++++----
>  drivers/crypto/tegra/tegra-se-hash.c | 30 ++++++++++++++++------------
>  2 files changed, 24 insertions(+), 17 deletions(-)

Patch applied.  Thanks.
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt

