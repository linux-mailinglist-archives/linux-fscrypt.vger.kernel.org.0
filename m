Return-Path: <linux-fscrypt+bounces-673-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EACAADBFD5
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Jun 2025 05:25:58 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 98A243B471C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Jun 2025 03:25:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CC3AA194A65;
	Tue, 17 Jun 2025 03:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VKOIvpCG"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A76D6143C61
	for <linux-fscrypt@vger.kernel.org>; Tue, 17 Jun 2025 03:25:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750130755; cv=none; b=vAHA6LGdt1BT5D7QyzkzQzdnWPzKhveNoyGlOmBfTEZJ8yZj/ReKbSEtlR8zocVxX9qj5bLJn5sA7p1API04OrEECmeTI+nuXU9IaQCBA9lPVFjgHKwQ7eNcaJn8/1jo8cGj0hxPmWwQK1BVb/H0355zLI8ZxrHxoCtOdJf2aT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750130755; c=relaxed/simple;
	bh=n7GUS/C4C+uqwt/whTfcDFpi79egd2Un4QOqhOT8CX4=;
	h=Date:From:To:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XhbuzUTnzCyfeCkvGCeXJpeooeqWCgBEWnRPGDa8hoGtwr30gW7N53EPOXMbNSxSz4RxsYMhmP+yBb00iIOHBOvzyDZef6dwl12r5YLcCfMsR036ALTv/zZwEUMFrBFQTmepQ/tjDkZ66b4OgjLUI1UBrNBNkBp8YhSd6Vz1oTg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VKOIvpCG; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1E32FC4CEEA
	for <linux-fscrypt@vger.kernel.org>; Tue, 17 Jun 2025 03:25:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750130755;
	bh=n7GUS/C4C+uqwt/whTfcDFpi79egd2Un4QOqhOT8CX4=;
	h=Date:From:To:Subject:References:In-Reply-To:From;
	b=VKOIvpCGiXRDx9h5HA5nV/82FxJ6+EG29ZQlhS/lZDVnU3GnIsUAXtWNinuZez48g
	 UcZnFt7telC6Qvw6WNbatbparo903tvRbp0pgtThZtfMsqSGmPpCAx7+TbbWASg0gQ
	 wWTsoIHaHtPBGcU+Vrx3jr5ARSpmgbfGCyqsNbdHhUmVWZDfxnUCBWa/vYkYaa7nFB
	 z4/IluUadL3uNCiL1/ZLb4vQCImctHKIr+XFZzqKcGAx+hF3/dd59ocfT4ulKcrlXg
	 FhKAzGg4u2+Hxn1PJwFjttVeoiKUZY0TIVEC5QuoeCSe87sV56UitXns5E2SpH/W1L
	 j4SgegNzJUSjw==
Date: Mon, 16 Jun 2025 20:25:25 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] fscrypt: explicitly include <linux/export.h>
Message-ID: <20250617032525.GB8289@sol>
References: <20250614221301.100803-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20250614221301.100803-1-ebiggers@kernel.org>

On Sat, Jun 14, 2025 at 03:13:01PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Fix build warnings with W=1 that started appearing after
> commit a934a57a42f6 ("scripts/misc-check: check missing #include
> <linux/export.h> when W=1").
> 
> While at it, also sort the include lists alphabetically.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> This patch applies to v6.16-rc1 and is targeting fscrypt/for-next.

Applied to https://git.kernel.org/pub/scm/fs/fscrypt/linux.git/log/?h=for-next

- Eric

