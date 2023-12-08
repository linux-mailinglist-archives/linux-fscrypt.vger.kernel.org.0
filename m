Return-Path: <linux-fscrypt+bounces-59-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 455F7809AA2
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 04:47:17 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 7651E1C20A60
	for <lists+linux-fscrypt@lfdr.de>; Fri,  8 Dec 2023 03:47:16 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2C39D4A24;
	Fri,  8 Dec 2023 03:47:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nOK+z3iH"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02D8F46B4;
	Fri,  8 Dec 2023 03:47:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BB41C433CC;
	Fri,  8 Dec 2023 03:47:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1702007230;
	bh=94tchSDYuOJuR9WzLVdslB+vEjc/Lmq8PQ0nzq14wD0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=nOK+z3iH1TfEWmIaQGdwj4Ez+jByWLha5CQ8K1y0da1EscgZ3J4DolwFZwlerOanc
	 VIaItoespH1Vt61wwCBiAE2hqrHcQpeH7P1C4/i3BSdvsB53ZLd9jnrh1Uv6J1seOU
	 3H57qVAK5ACNwyfzSmcglVGyZls4gGVUCWlB5hIs/r0H+UfXXwxPw5hi70WyOAOQFe
	 kPFZMkYLLBJgiGeCV4kQPyHzw1/zcwJbscMSMadla77ryHRW2zGTqZUHv4ABObd73k
	 0BQfa7+hjNp/LT7t5HFLJPGqA8NGI9aeaeHfm4t0xUH3Jcc6r4FocAna1NXMAb0rMD
	 h2SUVBAuRIVwQ==
Date: Thu, 7 Dec 2023 19:51:46 -0800
From: Bjorn Andersson <andersson@kernel.org>
To: Gaurav Kashyap <quic_gaurkash@quicinc.com>
Cc: linux-scsi@vger.kernel.org, linux-arm-msm@vger.kernel.org, 
	ebiggers@google.com, neil.armstrong@linaro.org, srinivas.kandagatla@linaro.org, 
	linux-mmc@vger.kernel.org, linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org, 
	omprsing@qti.qualcomm.com, quic_psodagud@quicinc.com, abel.vesa@linaro.org, 
	quic_spuppala@quicinc.com, kernel@quicinc.com
Subject: Re: [PATCH v3 11/12] arm64: dts: qcom: sm8650: add hwkm support to
 ufs ice
Message-ID: <blzia6asujby2xsfg2na6piwcgfkorodugebvflstjfexeyfvj@t5ifq3kxquhw>
References: <20231122053817.3401748-1-quic_gaurkash@quicinc.com>
 <20231122053817.3401748-12-quic_gaurkash@quicinc.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231122053817.3401748-12-quic_gaurkash@quicinc.com>

On Tue, Nov 21, 2023 at 09:38:16PM -0800, Gaurav Kashyap wrote:
> The Inline Crypto Engine (ICE) for UFS supports the
> Hardware Key Manager (hwkm) to securely manage storage
> keys. Enable using this hardware on sm8650.

I'm unable to understand why the size of the reg changes based on this
motivation.

Regards,
Bjorn

> 
> Signed-off-by: Gaurav Kashyap <quic_gaurkash@quicinc.com>
> ---
>  arch/arm64/boot/dts/qcom/sm8650.dtsi | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
> 
> diff --git a/arch/arm64/boot/dts/qcom/sm8650.dtsi b/arch/arm64/boot/dts/qcom/sm8650.dtsi
> index bbebe15437aa..b61066210e09 100644
> --- a/arch/arm64/boot/dts/qcom/sm8650.dtsi
> +++ b/arch/arm64/boot/dts/qcom/sm8650.dtsi
> @@ -763,7 +763,8 @@ rng: rng@10c3000 {
>  		ice: crypto@1d88000 {
>  			compatible = "qcom,sm8650-inline-crypto-engine",
>  				     "qcom,inline-crypto-engine";
> -			reg = <0 0x01d88000 0 0x8000>;
> +			reg = <0 0x01d88000 0 0x10000>;
> +			qcom,ice-use-hwkm;
>  
>  			clocks = <&gcc GCC_UFS_PHY_ICE_CORE_CLK>;
>  		};
> -- 
> 2.25.1
> 
> 

