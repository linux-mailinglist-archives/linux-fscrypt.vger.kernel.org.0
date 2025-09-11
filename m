Return-Path: <linux-fscrypt+bounces-827-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 43C12B53BD9
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 20:48:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id F0BFA16C42F
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Sep 2025 18:48:29 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 8D01B2DC792;
	Thu, 11 Sep 2025 18:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eGb+0Be7"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED1C2DC778;
	Thu, 11 Sep 2025 18:48:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757616507; cv=none; b=u6okuTmPtWpw0AjsEl+BTChIu5IPes7UDHumSSIx6pV5/6Mm6epm0wRBcqPcWjTDhrtHxRfSvdxu7NXcTqbhd8QiaBXuXbK/jrwCLKgUuhiC1mg2LZwPWznMZB1wBttcjwghmxXoR/FuwTOZIMmrQDTPwghgjIg35rabmOh+WOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757616507; c=relaxed/simple;
	bh=H8UUZOCJhz1KPH1y8ZlpmxMWu4oKmdFcyuOQUpaI34U=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nH/Zu39+rWmHNOjYHeLF/mCbPGObAVORybT4e+p8BTmHvBOfmcsb7c43t8w/0NWHj/n9d5g8huLFx3vPdtTTJhxEOwFQEkUK3VQ7U7GoBcf1y7XgSILUavzAfLEIsig0onjma1oftYtRRr7ENYNwJ6gQB1HRukVwLc0eorfz05E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eGb+0Be7; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59500C4CEF0;
	Thu, 11 Sep 2025 18:48:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757616506;
	bh=H8UUZOCJhz1KPH1y8ZlpmxMWu4oKmdFcyuOQUpaI34U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=eGb+0Be7x0x2MrgZS7iOKqb5O54rXDuJziKq17eARe44Xax1DD62wgxvA+y2vdrjp
	 Dh+h6UI9HghSBHF1jFiFWFd8QBk5IrIL+RumjHo7/ByFad3/IrzdMff6fnJav/fv3z
	 tPNqq7BdZQ/7/SKngHj8xJkucqj1ZHvDbu7NRqvBwfaNk7snbjRSoi6p9jJls6I4F6
	 JvrmMfLHR6LRHn9Ph+wm8w+TaSgBu2B8FT51TuaFSlz4BbRk4aOGHFF9o0NhfBW48A
	 wWXSevMFTzJwka7NEboPEZc7xlT06QfHduCAf7+E8TKaYCnWEVIR7yoq1p2wFMPn1u
	 bxgFDk9gzm0SA==
Date: Thu, 11 Sep 2025 11:47:05 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: akpm@linux-foundation.org, axboe@kernel.dk, ceph-devel@vger.kernel.org,
	hch@lst.de, home7438072@gmail.com, idryomov@gmail.com,
	jaegeuk@kernel.org, kbusch@kernel.org,
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-nvme@lists.infradead.org, sagi@grimberg.me, tytso@mit.edu,
	visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v2 4/5] fscrypt: replace local base64url helpers with
 generic lib/base64 helpers
Message-ID: <20250911184705.GD1376@sol>
References: <20250911072925.547163-1-409411716@gms.tku.edu.tw>
 <20250911074556.691401-1-409411716@gms.tku.edu.tw>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250911074556.691401-1-409411716@gms.tku.edu.tw>

On Thu, Sep 11, 2025 at 03:45:56PM +0800, Guan-Chun Wu wrote:
> Replace the existing local base64url encoding and decoding functions in
> fscrypt with the generic base64_encode_custom and base64_decode_custom
> helpers from the kernel's lib/base64 library.

But those aren't the functions that are actually used.

> This removes custom implementations in fscrypt, reduces code duplication,
> and leverages the well-maintained,

Who is maintaining lib/base64.c?  I guess Andrew?

> standard base64 code within the kernel.

fscrypt uses "base64url", not "base64".

>  /* Encoded size of max-size no-key name */
>  #define FSCRYPT_NOKEY_NAME_MAX_ENCODED \
> -		FSCRYPT_BASE64URL_CHARS(FSCRYPT_NOKEY_NAME_MAX)
> +		BASE64_CHARS(FSCRYPT_NOKEY_NAME_MAX)

Does BASE64_CHARS() include '=' padding or not?

- Eric

