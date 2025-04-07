Return-Path: <linux-fscrypt+bounces-644-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 0AA7FA7D850
	for <lists+linux-fscrypt@lfdr.de>; Mon,  7 Apr 2025 10:44:12 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id A3476189004F
	for <lists+linux-fscrypt@lfdr.de>; Mon,  7 Apr 2025 08:44:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C0F3522A1ED;
	Mon,  7 Apr 2025 08:43:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b="eskuvMgP"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mx0a-0031df01.pphosted.com (mx0a-0031df01.pphosted.com [205.220.168.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48E7228C86
	for <linux-fscrypt@vger.kernel.org>; Mon,  7 Apr 2025 08:43:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=205.220.168.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744015432; cv=none; b=WLSzJo1VrtrLEO45eKNxdJcIgv9BN+ExLIN7esCQOa63yAbQ6CoH5GeH8CaS1zTNUS0JOSImk//E3HGYcv4h7IZRCb9/jVODxTuQoclJex9nrMq4WKgs81JVaNkH8Mug+6mrkQqfZv0hZWUMX8PWaLUI2JXqIGQTtd9a+H8e1yk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744015432; c=relaxed/simple;
	bh=keeF2gzO1BG5TWSeisN2mF/28JltLtP+6/MPGcZqXK0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ioY9YzXa95J395fMrAf91NfkKU9L8bjljmsplawAt07gTGulQ82l4AXKiV6Kf7FGncP3bF43n8ZfKnwkdZyyz8s8uvyi4uFo1YUkp9DVD9kpcTzm40+JplWfM6HxFzF7piR3wmGx0be8TB54r4CD9l6koJasENuAcu0HUAaKuwg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com; spf=pass smtp.mailfrom=oss.qualcomm.com; dkim=pass (2048-bit key) header.d=qualcomm.com header.i=@qualcomm.com header.b=eskuvMgP; arc=none smtp.client-ip=205.220.168.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=oss.qualcomm.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=oss.qualcomm.com
Received: from pps.filterd (m0279867.ppops.net [127.0.0.1])
	by mx0a-0031df01.pphosted.com (8.18.1.2/8.18.1.2) with ESMTP id 5378doSo015632
	for <linux-fscrypt@vger.kernel.org>; Mon, 7 Apr 2025 08:43:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=qualcomm.com; h=
	cc:content-transfer-encoding:content-type:date:from:in-reply-to
	:message-id:mime-version:references:subject:to; s=qcppdkim1; bh=
	3LBZTe8by3wdJUm3j4TfqVrMn6/WCYmbjyVJqI9BVQI=; b=eskuvMgPTq/478q1
	aQrcm1nxa4BmpCqiMspO3aan+oaX57dgYk8O3sZaJSJ/GfvuXof7lncClX/UqrLE
	i7LggPpgmUzsg+cILKjgk6TbgDvXNEzqD/K+hVjjnSxD3LcIZhrta09w6OG/yL7h
	FeEUUwtyrQepSTHAyZd/zD5ItJVRoPKQ/mpqNnW4nMS6jcr1g+0DFZaOv9hLsSoh
	3ViF+iGeWObcIeLR5UJEio7DAHMcJfAUak/5EUgJABMyzlIkwnvvAu+IairodlNd
	QoYecjWf9Mq1DTw07kU/jroJLWRBOVk/hVnhnJWFUIdWKRB9o8lnV4PD7ZeTzxU2
	FSzYag==
Received: from mail-qv1-f72.google.com (mail-qv1-f72.google.com [209.85.219.72])
	by mx0a-0031df01.pphosted.com (PPS) with ESMTPS id 45twbe3mtk-1
	(version=TLSv1.2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128 verify=NOT)
	for <linux-fscrypt@vger.kernel.org>; Mon, 07 Apr 2025 08:43:49 +0000 (GMT)
Received: by mail-qv1-f72.google.com with SMTP id 6a1803df08f44-6eeeb7cbd40so2762696d6.3
        for <linux-fscrypt@vger.kernel.org>; Mon, 07 Apr 2025 01:43:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1744015428; x=1744620228;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=3LBZTe8by3wdJUm3j4TfqVrMn6/WCYmbjyVJqI9BVQI=;
        b=UtQobJqh6vlgRJ1J31RtgC44D34jrJaYHHxGD71IhLU9/CzUdB3KYKujjfqfZ20M9w
         OdT/1w0hp9CjrFFFD670oZheKoSYRjpuaGxEaAa+F+c4euWsivekJiDplv1M2hsOWOMQ
         On2KEmgmoYlHFqHUweonjT6ho/oZ8iMcBNKZKn1drUEkZK8YV7XhTJaUCNui8ijI/Jye
         wlpr2memU6A8CUhhL9EJhsa0v2w6ZM9A/xhsnX1MTLdKBaKLMF7h/sTtd7TkRPyDtguj
         D05kBg+AQ7rH6fmuLjR4BTEwXPJjvPVsiVjBRKRGHgsSS1yBeKs4xAXr3QAh48sZKv0A
         f8WQ==
X-Forwarded-Encrypted: i=1; AJvYcCVfwrQqTWc9l9ZttKJe1s7oQitUmw1rT3vq9dJmIt6qQfnO9ahMbddNe7yr/cr06o0RcBv5Cgp7GjOitY9T@vger.kernel.org
X-Gm-Message-State: AOJu0Yw3LgEZTMfv+YTry4kn08JtR2JyAbNyqDQ+dyw9n6a1/i0LP/nJ
	GnJGN7NlEgOfXEqy5e15au7DviqbsS2DaGwR5OxpgoL5O8e5JqAWD/eMfZlDKkGh7PEpD7tnHb7
	en+yZW5HROPeVCBDhwQ7nbeWgQohjYNusIaU83yKj9Ry+foqdD0pIQOE2nttkfswy
X-Gm-Gg: ASbGncuEwk77aXlYci10rveudjZxTwCDEMfmU9BmgnNKmhtvbT81SQ943t3yDi23VQT
	l4MzTHZ92M7GQn9hq6SMytrvKCgSOGdUWUIwUb+uA7clCb/BQq2nyC7cM1fjahsVqRXLfVHegZs
	uo8qRKKkR7b4IJHpp2G/Nx7lYnUg+Yn+E5LxKso78DqXOeE5TL7l5tT3bzJrK3YuWYwJv7etYCu
	b9vXOADmKXT1jK6WQdCNmTgnujpGv64KLlgRLTAcqM5KgxEmEBJm05FIw1Dz31d9G2vnK/yKK9h
	z5SfoerAT1Qv86YqvUoDF5Y/KfBfSXyqlAdbZB3OiaZSXAyqx+69b/uqd7o08hinTXhcfg==
X-Received: by 2002:a05:6214:e8e:b0:6e4:29f8:1e9e with SMTP id 6a1803df08f44-6f00214d08fmr68496676d6.0.1744015427729;
        Mon, 07 Apr 2025 01:43:47 -0700 (PDT)
X-Google-Smtp-Source: AGHT+IEFebGzNDRB0fY7+hPc7f12BLxECnTU/bMrpcOZJhMDdfXfqIZ/Ci0T8pDYTDUbni8F9lrsXA==
X-Received: by 2002:a05:6214:e8e:b0:6e4:29f8:1e9e with SMTP id 6a1803df08f44-6f00214d08fmr68496546d6.0.1744015427351;
        Mon, 07 Apr 2025 01:43:47 -0700 (PDT)
Received: from [192.168.65.90] (078088045245.garwolin.vectranet.pl. [78.88.45.245])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-ac7c013f34dsm701813966b.87.2025.04.07.01.43.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Apr 2025 01:43:46 -0700 (PDT)
Message-ID: <9eb0b21c-6830-4636-8a92-e174e34d779a@oss.qualcomm.com>
Date: Mon, 7 Apr 2025 10:43:43 +0200
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v13 1/3] soc: qcom: ice: make qcom_ice_program_key() take
 struct blk_crypto_key
To: Eric Biggers <ebiggers@kernel.org>, linux-scsi@vger.kernel.org
Cc: linux-block@vger.kernel.org, linux-mmc@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, Bartosz Golaszewski <brgl@bgdev.pl>,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>,
        Bjorn Andersson <andersson@kernel.org>,
        Dmitry Baryshkov <dmitry.baryshkov@oss.qualcomm.com>,
        Jens Axboe <axboe@kernel.dk>, Konrad Dybcio <konradybcio@kernel.org>,
        Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
        Bartosz Golaszewski <bartosz.golaszewski@linaro.org>
References: <20250404231533.174419-1-ebiggers@kernel.org>
 <20250404231533.174419-2-ebiggers@kernel.org>
Content-Language: en-US
From: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>
In-Reply-To: <20250404231533.174419-2-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Proofpoint-GUID: jLTAkTCYwc0-fGVEwvuk6Fuimcozuqv-
X-Authority-Analysis: v=2.4 cv=T7OMT+KQ c=1 sm=1 tr=0 ts=67f39045 cx=c_pps a=7E5Bxpl4vBhpaufnMqZlrw==:117 a=FpWmc02/iXfjRdCD7H54yg==:17 a=IkcTkHD0fZMA:10 a=XR8D0OoHHMoA:10 a=1XWaLZrsAAAA:8 a=COk6AnOGAAAA:8 a=KKAkSRfTAAAA:8 a=EUspDBNiAAAA:8
 a=frSOPK2eQqz-eahEfmcA:9 a=QEXdDO2ut3YA:10 a=pJ04lnu7RYOZP9TFuWaZ:22 a=TjNXssC_j7lpFel5tvFf:22 a=cvBusfyB2V15izCimMoJ:22
X-Proofpoint-ORIG-GUID: jLTAkTCYwc0-fGVEwvuk6Fuimcozuqv-
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.293,Aquarius:18.0.1095,Hydra:6.0.680,FMLib:17.12.68.34
 definitions=2025-04-07_02,2025-04-03_03,2024-11-22_01
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 impostorscore=0
 mlxlogscore=999 lowpriorityscore=0 adultscore=0 phishscore=0 bulkscore=0
 mlxscore=0 malwarescore=0 suspectscore=0 priorityscore=1501 spamscore=0
 clxscore=1011 classifier=spam authscore=0 authtc=n/a authcc=
 route=outbound adjust=0 reason=mlx scancount=1 engine=8.19.0-2502280000
 definitions=main-2504070062

On 4/5/25 1:15 AM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> qcom_ice_program_key() currently accepts the key as an array of bytes,
> algorithm ID, key size enum, and data unit size.  However both callers
> have a struct blk_crypto_key which contains all that information.  Thus
> they both have similar code that converts the blk_crypto_key into the
> form that qcom_ice_program_key() wants.  Once wrapped key support is
> added, the key type would need to be added to the arguments too.
> 
> Therefore, this patch changes qcom_ice_program_key() to take in all this
> information as a struct blk_crypto_key directly.  The calling code is
> updated accordingly.  This ends up being much simpler, and it makes the
> key type be passed down automatically once wrapped key support is added.
> 
> Based on a patch by Gaurav Kashyap <quic_gaurkash@quicinc.com> that
> replaced the byte array argument only.  This patch makes the
> blk_crypto_key replace other arguments like the algorithm ID too,
> ensuring that there remains only one source of truth.
> 
> Acked-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
> Tested-by: Bartosz Golaszewski <bartosz.golaszewski@linaro.org> # sm8650
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Acked-by: Konrad Dybcio <konrad.dybcio@oss.qualcomm.com>

Konrad

