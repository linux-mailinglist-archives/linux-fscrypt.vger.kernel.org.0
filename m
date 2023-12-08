Return-Path: <linux-fscrypt+bounces-61-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6444E809AE5
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 05:11:44 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 1D5D0280F51
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 04:11:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66D5B46BF;
	Fri,  8 Dec 2023 04:11:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="finRIQ9B"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33E50210F;
	Fri,  8 Dec 2023 04:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5B43C433C7;
	Fri,  8 Dec 2023 04:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702008699;
	bh=ktjNMQpMYtdJCKarfnmQ4//u4lA2bh0L2sHT+n1iYMc=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=finRIQ9Bf8AJ+mDczCtQMdDDYaw38VmxHog5pEqKlLnjvtusm/N/oBFJnRHgkmV0X
	 7iluK/V+o31w8Zy+9N4rUQvesAYWpjyAReS/Ah/mi0y6yOT7OXpnzISH9+a06nSX45
	 cftGcVv547pDT3gqkMsO0Zl4dXVWbGTpscZj/h6s7I1Tvcpi0TJ7MHQZca/780Phng
	 gptYed53AAUpXOLEYnKYa0DMfaoL0K6FwFuleURqVsONZ1XnHOG3XIrXtGIyCufu8/
	 iD+3Y4qC3r8m+jIvUooyup2y3N+PxYVy3DgK5fC6ox5OeeQMeb9IZvNkxxL7sv/B+o
	 TKm/IggJ7Qdyw==
Date: Thu, 7 Dec 2023 20:16:15 -0800
From: Bjorn Andersson <andersson@kernel.org>
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	ebiggers@google.com, neil.armstrong@linaro.org, srinivas.kandagatla@linaro.org, 
	linux-mmc@vger.kernel.org, linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	omprsing@qti.qualcomm.com, quic_psodagud@quicinc.com, abel.vesa@linaro.org, 
	quic_spuppala@quicinc.com, kernel@quicinc.com
Subject: Re: [PATCH v3 12/12] dt-bindings: crypto: ice: document the hwkm
 property
Message-ID: <hyy22eypnkvpcnykxbvelvt7gsejfdrjwh567wus6fgmdyvg74@ygm3oflkkv3d>
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
 <20231122053817.3401748-13-quic_gaurkash@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231122053817.3401748-13-quic_gaurkash@quicinc.com>

On Tue, Nov 21, 2023 at 09:38:17PM -0800, Gaurav Kashyap wrote:
> Add documentation for the ice-use-hwkm property in
> qcom ice.

Please describe the problem that you're solving by adding this property
to the binding (the description of hardware/firmware).

> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>  .../bindings/crypto/qcom,inline-crypto-engine.yaml         | 7 +++++++
>  1 file changed, 7 insertions(+)
> 
> diff --git a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> index ca4f7d1cefaa..93e017dddc9d 100644
> --- a/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> +++ b/Documentation/devicetree/bindings/crypto/qcom,inline-crypto-engine.yaml
> @@ -24,6 +24,13 @@ properties:
>    clocks:
>      maxItems: 1
>  
> +  qcom,ice-use-hwkm:
> +    type: boolean
> +    description:
> +      Use the supported Hardware Key Manager (HWKM) in Qualcomm
> +      ICE to support wrapped keys. This dictates if wrapped keys
> +      have to be used by ICE.

As described it sounds like software configuration, rather than a
description of the capabilities of the hardware/firmware.

In what cases would we, and would we not, specify this property?

Regards,
Bjorn

> +
>  required:
>    - compatible
>    - reg
> -- 
> 2.25.1
> 
> 

