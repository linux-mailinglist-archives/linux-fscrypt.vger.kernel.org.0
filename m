Return-Path: <linux-fscrypt+bounces-112-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 75B6682A6AE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Jan 2024 04:54:57 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F0671C21F87
	for <lists+linux-fscrypt@lfdr.de>; Thu, 11 Jan 2024 03:54:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1EA1310F3;
	Thu, 11 Jan 2024 03:54:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N00HjlJa"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E17D110E1;
	Thu, 11 Jan 2024 03:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BBC5C433F1;
	Thu, 11 Jan 2024 03:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1704945286;
	bh=72ivCjl5dJtBmZbh/NqHldmjpyUkgHUjTtMsl2+EJXQ=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=N00HjlJaqIIpwtxvgkzp1hc0w21pAr2mfxFbAOOBJ4+tUE+wv3INEvh2zAPy147Hu
	 fYLnEsF1lSJPmdtwP3v6F7IBCAINb6p6T/gGpzSHcmna9TsDGPNe+ZVMFJozQivHHD
	 esEWMTYeAi0AI/S1x70TE1XwuljaYHVxXBM6zGjouG1P2JlP+S00vYnrlk/XQ3dfnX
	 N2GOjDKVdmSwl8tcm7SkIc0dyAM9czqe7MOoCQUVoGy2O/yn/nllKYM8BODCivrapH
	 d5QdAU7Zk0GWZGCtJq3bI1yMK9KTPQ9zvfItD4jvkMrPJVbh5klhgI+cGNFp5JpYxo
	 D2UerbxU2uc2Q==
Date: Wed, 10 Jan 2024 19:54:44 -0800
From: Eric Biggers <ebiggers@kernel.org>
To: Zorro Lang <zlang@kernel.org>
Cc: fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	Daniel Rosenberg <drosen@google.com>
Subject: Re: [PATCH v2 0/4] xfstests: test custom crypto data unit size
Message-ID: <20240111035444.GA3453@sol.localdomain>
References: <20231121223909.4617-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231121223909.4617-1-ebiggers@kernel.org>

On Tue, Nov 21, 2023 at 02:39:05PM -0800, Eric Biggers wrote:
> This series adds a test that verifies the on-disk format of encrypted
> files that use a crypto data unit size that differs from the filesystem
> block size.  This tests the functionality that was introduced in Linux
> 6.7 by kernel commit 5b1188847180 ("fscrypt: support crypto data unit
> size less than filesystem block size").

Hi Zorro, can you consider applying this series?  It's been out for review for
3 months, so I don't think reviews are going to come in.  The prerequisite
xfsprogs patch is already present on the for-next branch of xfsprogs.

Thanks!

- Eric

