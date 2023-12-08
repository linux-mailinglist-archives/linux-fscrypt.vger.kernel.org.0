Return-Path: <linux-fscrypt+bounces-57-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E05CF809A8E
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 04:37:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 4CA1CB20D79
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 03:37:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4921E3FDB;
	Fri,  8 Dec 2023 03:37:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="caxNvew2"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 141CD3C23;
	Fri,  8 Dec 2023 03:37:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C5E3C433C8;
	Fri,  8 Dec 2023 03:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702006652;
	bh=kpAT+d4+IhcmASzgjNp1OSaMudov7UxgDV5u+BY/y3U=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=caxNvew2IdSOrs/FGsmMdQoYOMBwyGA/uAYvzDVLClSbSYennFI0u18Zv2NnaisaM
	 lw58W4RYJiCOI4HQ1Fl1W7X+thV2yFFK3ilnDGuisCkYQ8J1LgSS2aqQXKrbkKh4ad
	 l2ZFznIKVhTp+rk5LBaFIgH/vMjrJBH/FXEyvcFWUTXWCC8sf9A1e0aN8l2CFX8l6s
	 v4lucc0DOiJelPJDtiqz5mI3Rzv3EfEGYojM2KX/1ajJXEBm/aW1TtrBITLBCNlKB/
	 VeWZmP3Vd8i2KiFeOJA6fencKWolBacRODXD1InPdNmIaA9mksoDy0R8pjW5U/0WTP
	 1brKjlfCNBdRA==
Date: Thu, 7 Dec 2023 19:42:07 -0800
From: Bjorn Andersson <andersson@kernel.org>
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	ebiggers@google.com, neil.armstrong@linaro.org, srinivas.kandagatla@linaro.org, 
	linux-mmc@vger.kernel.org, linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	omprsing@qti.qualcomm.com, quic_psodagud@quicinc.com, abel.vesa@linaro.org, 
	quic_spuppala@quicinc.com, kernel@quicinc.com
Subject: Re: [PATCH v3 05/12] ufs: core: support wrapped keys in ufs core
Message-ID: <d7g5i3rdlpfx2pl37xwa6xwa55w2pi4o7bgkhixr53mgjhl6hx@vunwcrg5th3f>
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
 <20231122053817.3401748-6-quic_gaurkash@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231122053817.3401748-6-quic_gaurkash@quicinc.com>

On Tue, Nov 21, 2023 at 09:38:10PM -0800, Gaurav Kashyap wrote:
> 1. Add a new quirk in UFS when wrapped keys are supported. Since
>    wrapped keys are not part of the UFS spec, treat it as a
>    supported quirk.
> 2. Add derive_sw_secret crypto profile op implementation in ufshcd
>    crypto.

Please read:

https://docs.kernel.org/process/submitting-patches.html#separate-your-changes
https://docs.kernel.org/process/submitting-patches.html#describe-your-changes

Thank you,
Bjorn

