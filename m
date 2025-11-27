Return-Path: <linux-fscrypt+bounces-993-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 0B24CC8C860
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Nov 2025 02:16:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BDE303A7CDF
	for <lists+linux-fscrypt@lfdr.de>; Thu, 27 Nov 2025 01:16:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 636A319D08F;
	Thu, 27 Nov 2025 01:16:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nFOJHP61"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 366DE1862A;
	Thu, 27 Nov 2025 01:16:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764206195; cv=none; b=HqDVsWDoWZ5zR8mogl3yLcJ8MSPXJpkEo5Fg6MSdwrF3aiX+5cPpVW7MJd48t16ZoDty4XkVY+Kv8xm1GOs38oKzOft/jgcJna8DAhxXuxeymMtywAEiy3e2w5QiXs4LFHKqhaAjYcoNS+GguggzjVlIRd5Ma5ySJeQOPQtGuZI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764206195; c=relaxed/simple;
	bh=Mm4d8sgWM/bwoIOYBVbzEMdINLQqvtM8Ah4aTx1ffzQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=j8nNYOlC7JvsQYXkXapBo+Bzf7v1ol/x72oGRWd82JZxVZjOKl7/O10bPRR6sFbXIDR34qw6hqRWzOD1lPDj2qR/SnHxGdqoqr80topk1hz/zWt1cgdSKVpjcCwFLGBDdt1kK9Spzkk6wHVwnmUCFdruQGKaCb2zSFGcUN22zxE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nFOJHP61; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 731F8C4CEF7;
	Thu, 27 Nov 2025 01:16:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1764206194;
	bh=Mm4d8sgWM/bwoIOYBVbzEMdINLQqvtM8Ah4aTx1ffzQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nFOJHP61MmPR7T+vA4l3aw5a/El3eZsXIgo4Y5GvYJARUQg0AYQ/osSJHKmrgDH9p
	 IZ7+PydSRCrE02/WM/sWksFcqebHELkFwMXvC0X7OD5nH6kW5sVF36mgjOXbCgD+rp
	 ig6YkcKAh12s/Ci2C1tVUbR9Ta954RmN1I71bRd7bBQWGUbXCnBzGPwXd461Y5B42w
	 l+3KLzSBBzTXWzd8jio3FPJay1eIpFOOrAceLucaot7aulVAmaIcTnCF6m8qk95RRl
	 Olwdz7/REXyaFS8ZJEd9M9omPK0nwRT9d4wJGpXO6a3Locwadsykz+2LG28oLvMgSj
	 bHDdJZIQBKuXg==
Date: Wed, 26 Nov 2025 17:14:46 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Li Tian <litian@redhat.com>
Cc: linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	Herbert Xu <herbert@gondor.apana.org.au>,
	"David S . Miller" <davem@davemloft.net>,
	"Theodore Y . Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH RFC] crypto/hkdf: Fix salt length short issue in FIPS mode
Message-ID: <20251127011446.GA1548@sol>
References: <20251126134222.22083-1-litian@redhat.com>
 <20251126174158.GA71370@quark>
 <CAHhBTWuOy1nC1rYqye8BzE+unoC+3M9Dsw+Mj54=3eeFwqyTXw@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHhBTWuOy1nC1rYqye8BzE+unoC+3M9Dsw+Mj54=3eeFwqyTXw@mail.gmail.com>

On Thu, Nov 27, 2025 at 09:10:45AM +0800, Li Tian wrote:
> Eric,
> 
> Thanks for reviewing. Not just the salt_size=0 case, but several cases with
> salt < 32 from my tests.
> So simply skip those then?
> 
> BR,
> Li Tian

Why do you think the salt needs to be at least 32 bytes?

- Eric

