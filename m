Return-Path: <linux-fscrypt+bounces-995-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [IPv6:2a01:60a::1994:3:14])
	by mail.lfdr.de (Postfix) with ESMTPS id C7BB0C8CBFD
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Nov 2025 04:25:36 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 79A4234B0CE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Nov 2025 03:25:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08E7E2BF006;
	Thu, 27 Nov 2025 03:25:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ynk85J9t"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE965125A9;
	Thu, 27 Nov 2025 03:25:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764213932; cv=none; b=QBmNzh0ucxpUXJqeUpenBXVyA0T/OSzxTrnpZAvgPVZ/qKWQ9oqK9tFtGeVufAzSzKUFnq7fSnibhcMMH87r0s8/9EDuGbxtfVskH47Ovc1vTT3FhjxQYEpLdZQH6gSe6nNW+33GFO8UJeFFPRGM0GssoF/nw8h7Svh6GY0ofnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764213932; c=relaxed/simple;
	bh=L2d2NMOWG9lk1o/sFH9lobfJpwzbhYn824TIH9mqJfc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=b0pPXfRx1VEwA0aNRvXkukDjHIiFD6jfq79slGM1stbxBBbIi+wisee7M7VRouVpxMknY95Mm+ihAZllChBzR0o1wR2Rgqeic5thl6mJ9VNvSrX5fSxqG0jOoV3kzGlMUoxnGfUYAJXVhEf0mBxaugYcH3V0ZS0zfnAWEaICql0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ynk85J9t; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D6F1C4CEF7;
	Thu, 27 Nov 2025 03:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764213932;
	bh=L2d2NMOWG9lk1o/sFH9lobfJpwzbhYn824TIH9mqJfc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Ynk85J9ttTA+NO5GOYTFqBeDl2GXGqqMKo/Eou5+/mr0Px40jAm96YdKerCuS+5Zp
	 qtrdV7eQuHfrAowcEKMPgwVzGjYxybekSYdggJW+w4L5m4x32GC5jYTnde1jO7Acc9
	 OsaVHMP22+2wxvG++UX8oI2U5e32oMLudyfbNcTwVU0e+7+5q96eX8uyLoAyBkUlu6
	 +fqiEun8AF9nAyonB+F/Z3fAReAMZNVvjoNRji7tM5t9msfZ/tCKzxp9ZLjIsdgHqF
	 +1MCI7AQywRkj752MLHkKt1ARxtIMwuzXrVMVCvdyBs/0no3RTNTcWpBe94GVZMdgN
	 JjYmdBgAWtanA==
Date: Wed, 26 Nov 2025 19:23:43 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Li Tian <litian@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	"Theodore Y . Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH RFC] crypto/hkdf: Fix salt length short issue in FIPS mode
Message-ID: <20251127032343.GA60146@sol>
References: <20251126134222.22083-1-litian@redhat.com>
 <20251126174158.GA71370@quark>
 <CAHhBTWuOy1nC1rYqye8BzE+unoC+3M9Dsw+Mj54=3eeFwqyTXw@mail.gmail.com>
 <20251127011446.GA1548@sol>
 <CAHhBTWsTqP3LzJV+=_usvttJcMFoLYSY5Sqt2H-U-oki3Hu0Mw@mail.gmail.com>
 <20251127015141.GA29380@sol>
 <CAHhBTWs6rWq2huD8Ech79OVOxK3v3ijU3KFFOGLQ+pr7277Vew@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHhBTWs6rWq2huD8Ech79OVOxK3v3ijU3KFFOGLQ+pr7277Vew@mail.gmail.com>

On Thu, Nov 27, 2025 at 11:11:29AM +0800, Li Tian wrote:
> The error message I saw is `basic hdkf test(hmac(sha256-ni)): hkdf_extract
> failed with -22`.
> And I was looking at hmac.c that has `if (fips_enabled && (keylen < 112 /
> 8))...` So I got the impression `crypto_shash_setkey(hmac_tfm, salt,
> saltlen)` in hkdf_extract reached this failure.

112 / 8 is 14, not 32.

Also since v6.17, "hmac(sha256)" no longer uses crypto/hmac.c.  I forgot
to put the keylen < 14 check in the new version in crypto/sha256.c.
That means the test failure you're reporting was already fixed.

If you'd prefer that it be broken again, we can add the key length check
back in.  But this whole thing is just more evidence that it's incorrect
anyway, and it needs to be up to the caller to do a check if it needs
to.  In HKDF the secret is in the input keying material, not the salt.

- Eric

