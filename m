Return-Path: <linux-fscrypt+bounces-703-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id A01A4B00C24
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Jul 2025 21:32:59 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EE87B5C4F7A
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Jul 2025 19:32:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DF8BC2EF9D6;
	Thu, 10 Jul 2025 19:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="d4KrJlDa"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A767221A43D;
	Thu, 10 Jul 2025 19:32:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752175974; cv=none; b=uLyUKuptasCLek73Isy9r65Q7dPq2CZLf/NFbFeawn4MvzfG2yDIhd3uGt+BIUcRZCpK4MZcZhG3t/ILMabxU1pLIPhZRjMz7NoUfC1XvbKHL+Jt5JSmYRz/59htoYwgVka0+T9G+PKkglZtrtyVYlmn4N4cX2svS0HfxDduhz8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752175974; c=relaxed/simple;
	bh=5iv/ybBT1EWpCtzUTeH7jOisZdpjTSxsHX5LZWaBTBs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Q6eSwtEnOD1JVKS/F6DpSYaMiPoVkkpPIvxTVClsZbDEypJh9+k6VPTwhH/BlPLVHuzIdspVvn3MC0oc3utoq/luGYAIGJXkWEn8ud75Q0VWGbJfGflHMmGQERO/ntR5H27LmP3EDStX1vPsJQXS+2KdHTS9e6P5x6ecmTV4QBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=d4KrJlDa; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2C0BC4CEE3;
	Thu, 10 Jul 2025 19:32:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752175974;
	bh=5iv/ybBT1EWpCtzUTeH7jOisZdpjTSxsHX5LZWaBTBs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=d4KrJlDa0wqJNg3kV/Aycs4TlPYrAsCJRXY7pEr0yFXtTSr5FEeZGUF/jPySl86L0
	 G2Wj3h88lJib/AeFNTfE55CceP6Z8QDP3lBTDwYqHHQju5mqPUOCa4/3mGS9h9fWN2
	 8BE0kCRE4pggOceAMSsqBVWRr1gs6zAWJaNhtudIagRE9mkIDpF/mwipXJeEkW+oCM
	 p3QbqdTQJ6FoWgjFXP97kQGwHc4BgJnkex2oGRmglmd2Gq6jytbt8BcKjvG56TNzdm
	 tbQ0dW+FgZY3oL6JitibiLFuzcpQ3/iHOi8JgP4kOgyIMABWv4q4DV/rHXa0LiV7Mx
	 Uwez3iX6QZFgw==
Date: Thu, 10 Jul 2025 12:32:52 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Alex Markuze <amarkuze@redhat.com>
Cc: linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org,
	Yuwen Chen <ywen.chen@foxmail.com>, linux-mtd@lists.infradead.org,
	ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 6/6] ceph: Remove gfp_t argument from
 ceph_fscrypt_encrypt_*()
Message-ID: <20250710193252.GA20579@quark>
References: <20250710060754.637098-1-ebiggers@kernel.org>
 <20250710060754.637098-7-ebiggers@kernel.org>
 <CAO8a2Sivm00NRM9Z-Fwp=FzcmkAP8m1uQR24-avT-tUug4VgmQ@mail.gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAO8a2Sivm00NRM9Z-Fwp=FzcmkAP8m1uQR24-avT-tUug4VgmQ@mail.gmail.com>

On Thu, Jul 10, 2025 at 02:07:47PM +0300, Alex Markuze wrote:
> Reviewed-by: Alex Markuze amarkuze@redhat.com

Thanks!  In the future, when sending a tag, please include brackets around your
email address, like Reviewed-by: Alex Markuze <amarkuze@redhat.com>.  Otherwise,
when applying the patch, b4 skips the tag:

    NOTE: some trailers ignored due to from/email mismatches:
        ! Trailer: Reviewed-by: Alex Markuze amarkuze@redhat.com
         Msg From: Alex Markuze <amarkuze@redhat.com>
    NOTE: Rerun with -S to apply them anyway

I'll add the brackets, so no need to resend anything.  But other maintainers
could miss this, which would result in your review tags not being applied.

- Eric

