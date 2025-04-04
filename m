Return-Path: <linux-fscrypt+bounces-635-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 07F5BA7C2B5
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Apr 2025 19:45:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A24083BAE27
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Apr 2025 17:43:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D87A9219307;
	Fri,  4 Apr 2025 17:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="J4KPLgyY"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 835D619CCF5;
	Fri,  4 Apr 2025 17:43:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743788623; cv=none; b=ZIjGgTCCVJJ4yO9uZwoboJKySKATo+ZHdYyilMUxjB0WNa8c6PdlhDrh1prlfIdo+np1fhZFiK509HFHeIpUGlYWbfN1b86nZUQtDpO3diVOkzN1rolVy3nYlmdalwpXaoDq1Ic6buPootePHPqt2i74xOQHTUmspCbIFzEN/h4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743788623; c=relaxed/simple;
	bh=WJeqcUtnD+JvPCp95BzhzODUCYYMvFFmmq3rDIUcqSs=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version:Content-Type; b=tcy7qLBtxFanZuQO/YCGtlDU6pFXFAlFAQaN7fi1jDecrzrYbjsVxDNdgyN7ElQJVXNW6GCm7Lkx+xphD+eNGe5S0Z0TpImreVVLbJcLTV7Nr7+C3OC4KT/cq3NBn6R639rFiJpwzFAXl/sp3qbXQmTp1VKVlVeYbY/PaA+cxls=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=J4KPLgyY; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C47B2C4CEDD;
	Fri,  4 Apr 2025 17:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743788622;
	bh=WJeqcUtnD+JvPCp95BzhzODUCYYMvFFmmq3rDIUcqSs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=J4KPLgyY3xGfSNoxx05BGJCDtfOgYphVQM1ZoldOdeeso2SYhM1km51rPHKPwB/pQ
	 GJ06NvvjBNhsMQzJIvUMvXMETtTXsO0LWkcjP7CtqBfxJSSCZoye7qjPeoiOx1kiDt
	 ZWKMHiBmHZU27kWXOQI7fbYGkDq4pvMtkkRYR1VoVIR6ij5Gkg20gJVinnvxc+4Hln
	 0pLMb4KNxVCrO46a7TfFtjc086KPWG07DJC5spzimeJtmGzO94ULDmiHBAOlWDVvJp
	 ZHbUkDK/UYEW9K0mv7yvUZ5RZIpRiMCeq9pji34ELH1v5T9ZN5jyVg1V4+LWXJ2tCM
	 WVxxdgswoKZSw==
From: SeongJae Park <sj@kernel.org>
To: =?UTF-8?q?N=C3=ADcolas=20F=20=2E=20R=20=2E=20A=20=2E=20Prado?= <nfraprado@collabora.com>
Cc: SeongJae Park <sj@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jonathan Corbet <corbet@lwn.net>,
	Vinod Koul <vkoul@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jonathan Cameron <jic23@kernel.org>,
	Lars-Peter Clausen <lars@metafoo.de>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>,
	Simon Horman <horms@kernel.org>,
	Maxime Chevallier <maxime.chevallier@bootlin.com>,
	James Bottomley <James.Bottomley@HansenPartnership.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	Mimi Zohar <zohar@linux.ibm.com>,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Richard Weinberger <richard@nod.at>,
	Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>,
	kernel@collabora.com,
	linux-mm@kvack.org,
	linux-doc@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	dmaengine@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-iio@vger.kernel.org,
	netdev@vger.kernel.org,
	workflows@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	keyrings@vger.kernel.org,
	linux-sound@vger.kernel.org,
	linux-media@vger.kernel.org,
	linux-um@lists.infradead.org
Subject: Re: [PATCH] docs: Remove literal markup from Documentation/ paths
Date: Fri,  4 Apr 2025 10:43:39 -0700
Message-Id: <20250404174339.59650-1-sj@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250404-doc-paths-unliteral-v1-1-74718785444e@collabora.com>
References: 
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On Fri, 04 Apr 2025 11:37:28 -0400 Nícolas F. R. A. Prado <nfraprado@collabora.com> wrote:

> Given that the automarkup Sphinx plugin cross-references
> "Documentation/*.rst" strings in the text to the corresponding
> documents, surrounding those strings with the literal markup (``) not
> only adds unnecessary markup in the source files, but actually prevents
> the automatic cross-referencing to happen (as it doesn't happen in
> literal blocks).
> 
> Remove all the occurrences of the literal markup in
> "Documentation/*.rst" paths, except when the actual source file is being
> referred. Also change the surrounding text when needed so it reads well
> both in the source and the web page (eg. 'see file Doc...' -> 'see
> Doc...').
> 
> Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>

Acked-by: SeongJae Park <sj@kernel.org>


Thanks,
SJ

[...]

