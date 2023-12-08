Return-Path: <linux-fscrypt+bounces-58-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id 04153809A9E
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 04:44:37 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 99BC71F212E0
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 03:44:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5F954442E;
	Fri,  8 Dec 2023 03:44:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="cF1x/k43"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B30A3C23;
	Fri,  8 Dec 2023 03:44:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0A82C433C7;
	Fri,  8 Dec 2023 03:44:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702007072;
	bh=dku30mhDTDb4o+DAwxMGgJ1Qt5skSX0FrRwVkVwTJN4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=cF1x/k43lEYU9H2QaFoxJ/HXFoA9olvQHgvzZ+t7mIqjdNnPgTUPDrBIQU7bFRUT5
	 /RDpaTgrjAvoo2jec8GnxTMFjE9ZK1EDSzgvXJ9Vpts3SJoBTV4Sz+0Umitac1/39w
	 YNUF0zD/AHgQdcutaDVWtMIfHhs4Fopaq8gjRUE2jHPiu5lcghKL7pDcdDS3pd95vV
	 9HkqGi2sk8iwkfiAicwXqbZfk2qyYjiVV4RvfsU7icv6l/2KPfQ7ltIXcrAHbKFcle
	 +murZ2M0wPMbefMi1Omei2s5wmrmBJtIxsMHNpR0haxOSXAHyTUmupgrv9Sq0ZnWxV
	 5wYjn3L3X/Y4A==
Date: Thu, 7 Dec 2023 19:49:07 -0800
From: Bjorn Andersson <andersson@kernel.org>
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	ebiggers@google.com, neil.armstrong@linaro.org, srinivas.kandagatla@linaro.org, 
	linux-mmc@vger.kernel.org, linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	omprsing@qti.qualcomm.com, quic_psodagud@quicinc.com, abel.vesa@linaro.org, 
	quic_spuppala@quicinc.com, kernel@quicinc.com
Subject: Re: [PATCH v3 08/12] ufs: core: add support for generate, import and
 prepare keys
Message-ID: <2pxw646bkcqyycrdey3ucw3xcbzxzfp4h6njetol5phf25da3y@7jpqkghdpjno>
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
 <20231122053817.3401748-9-quic_gaurkash@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231122053817.3401748-9-quic_gaurkash@quicinc.com>

On Tue, Nov 21, 2023 at 09:38:13PM -0800, Gaurav Kashyap wrote:
> This patch contains two changes in UFS for wrapped keys.

The code in this patch isn't two different changes, it just add the new
variant_ops and tie these to the blk crypto ops. That is one logical
change.

> 1. Implements the blk_crypto_profile ops for generate, import
>    and prepare key apis.
> 2. Defines UFS vops for generate, import and prepare keys so
>    that vendors can hook into them.

Please describe why this code is needed. Something like "Key management
is vendor specific, so add new variant ops and tie these to the block
crypto ops"...

Thanks,
Bjorn

