Return-Path: <linux-fscrypt+bounces-641-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A5FBAA7C736
	for <lists+linux-fscrypt@lfdr.de>; Sat,  5 Apr 2025 03:17:45 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A464517BF04
	for <lists+linux-fscrypt@lfdr.de>; Sat,  5 Apr 2025 01:17:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BD947125B2;
	Sat,  5 Apr 2025 01:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YRnurKuH"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1155F2E62C1;
	Sat,  5 Apr 2025 01:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743815848; cv=none; b=Sc8gzpWqGIh2GS44P+bmhBD5J/psYQwr1jz92yZbcmmnpAzHY4TIA2mTTH0+slwtKLeVykYubqD4PJUwmjbmKcxxdkgkNKA9Z3okfAVKGfApwo82BOLVjxXzuQep/xMofsjOckYNx8FdO/VJuafemIGBlJ/v7VPxTxt5tNkqJqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743815848; c=relaxed/simple;
	bh=f3i7y9qJZMSTYCRTNPf2EJF6SHSdbXnOdImAqF1W99g=;
	h=Message-ID:Date:MIME-Version:To:Cc:References:Subject:From:
	 In-Reply-To:Content-Type; b=KwPRGuLq/r+uRRcMvlsTrxmbpue912LVugJGBSjOPteHARpxK9tWjQv5yEweZEvtSe8MIHzH7gzFDjanseh9fQjpegP717+rSbRtzZOBNFSI31ZgZNlDPIIndWyY+wRdeBt0BR32l7XrDg101n5CzI8Fu7VyRomrYH8+S8UsRRk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YRnurKuH; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-2243803b776so37806955ad.0;
        Fri, 04 Apr 2025 18:17:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1743815846; x=1744420646; darn=vger.kernel.org;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id:from:to:cc
         :subject:date:message-id:reply-to;
        bh=NRiuL4Sy1s+c/lXgB3vFyCUJTB29r4cpXB4vQmrcmqI=;
        b=YRnurKuH0qf8QZ1KCUwm5y0Za2vb8zsJBV5R9jIeOPcHdOS2Y1x2cC9u18+sOLLm3V
         Vgao4vJjL7NF1PUiRYzGDDwSvbsJr4iEgNRAvvUwKQQFPg4FDRGXPwf9vwatDsYut9RP
         r2RgB7tx8Pm3ecjNlusVzcWtgXYg2tisennGcVuDQt64BV4jGjFT8ebw3CJ6k7/fTscF
         5p0rHmXQd3P0JUGdGGtvjjYZeeALHHVJoHFSa8Xdpy+8IULCU2KrSfJp6fPSLbhmaYRd
         Pr9jo7SrBt3qoQ24Bf4Oi48YcL6Lu5sXehSxcZmBDNkR7kRLSt2c+dow5tDaUrr/TFNg
         bZLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1743815846; x=1744420646;
        h=content-transfer-encoding:in-reply-to:from:content-language:subject
         :references:cc:to:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=NRiuL4Sy1s+c/lXgB3vFyCUJTB29r4cpXB4vQmrcmqI=;
        b=JHLrp3NVp/SMPJ1GTJaDcfNB78Xr9OvSse6kWADJGEKlTf+RjJA4Fkah4epIGQigGH
         juqh0LlakK+D162kGm6hXKSfssMM2WiN7E9f85+2WcGqghwhZOlmBUGpE5FkozdTA16G
         qALNOwgIk0ImH9vVPCXQ75LvqAhnBwwOpnC+Ob8J7+VIA/r0KXSB7EzwBczecF9l5wSi
         0vmu/KbwAK/u78Vi8gm84GIsrn6ACreBXE/a9J/YeA5fTkEJj9mGawIz+yvzy62ZqP3t
         /82nn5WLqy+h2roZoTvsAlzFq/TLSW1RrwrwRJJAyF6e1OFAM8RMNvRwlP2lOg9JOo8r
         6OwA==
X-Forwarded-Encrypted: i=1; AJvYcCUWlDFizJ72L4JaLpGMGIXwPVkkry0CxprxOxHRciM+kbDmneQ/BvwS/4Z9t6b6hHswwZsZIhEUcr66SQ9s@vger.kernel.org, AJvYcCV5YymNw437k3DF6kKFAwfK3U2exxJWUISpUaX+DQIMatGKsTnW7b51mOoli9iXf8Jm6BVqH9MY483MU/YGLg==@vger.kernel.org, AJvYcCV73uF6MlopNrW2+1X8virrsE1CN1EbJ82LQ3FfZSkFJ+ek2Ms0nesputnSByKTAhpkx+yT0XK/@vger.kernel.org, AJvYcCVMi0tnSlpsyUu9NCHb33HIHlEWwl25WXGtTP0H5l19Gh81q5ug1vd/CfdjApdJoCuSvRjAiSm7Zw4tAssV6DBY@vger.kernel.org, AJvYcCVNCQVqTlSFPXisH9bZc4eTOctWFTgsksSkc3GHeu/NuKsr3Qzkgwi2Te2fYJKcQ5BaPZ+1wgdVWCLw@vger.kernel.org, AJvYcCWhZFY9l4lNdSkHoLCWyE3EuOFxfqkiLQah38cNgKePAtSELcneThA51vDR3UHagmV8RSQZaQfCGSc=@vger.kernel.org, AJvYcCWlrI/JSZ/JuzS25BJBuyhHkRldgpr04/5qaY/YnqEBG1YHrboHaYDpqGjpmTgrNJP3ChrkytKYAEs=@vger.kernel.org, AJvYcCX6Ssa8979EneFfYhtaAKodjajDjHOfsHL5SXVQjWL+Wpt/AirlpUm/5S9S3MkohbdN32hAInPZsS3k@vger.kernel.org, AJvYcCXGOZOkI9lE0ylnkW0ktt7aPVyh/RRvJqqZibl8nWD0+nU5bBc4/Jn50bSdtN32AQibAfnZmQxuLyTG/XU=@vger.kernel.org, AJvYcCXMMuu1sTDouy7+bUG/G9YWJANt
 U5x7ZyVtgwZpr347i2TCa6jfm7ldLE32U0FxTgjN+pO4rSUPcf7Iew0=@vger.kernel.org, AJvYcCXRKSALrXbi3YbfbNZTUz7Ps+pdGKDPFa5OCJciAmpTHN3Su5BptmzAObQG6GDmH08H2h7+Q9Vhm0vp@vger.kernel.org
X-Gm-Message-State: AOJu0Yxr3CPhGm8W4iDr6QTqTstL9azX+Uw+8RfXnyLamw8fGI/bUBtC
	YUmaEC7MECJEamEdzBjCIxA++D9v2aQD7VB7huqGNe63OUgohkpK
X-Gm-Gg: ASbGnct0KFiIGSMKavchuzIRbJohlzYkeVSZP914WZK+mCplAHw3Yoy/mlyvKfJsgye
	Cf2C4Bs4B2WNfX6Cnqvwo6zR1/QValY51yjC3Sg3KrsJ58GwlOJzW/5y8SJriFsdgnVnqMhZTL3
	PTfsq25FUzSCX9ZzIUin0Z/QwIKZ3lenAGyKYxGF/KBrKjNd3IE6uZ5ynP5BeCriY4Rg7VxjH83
	Hrf1ArhW4TpfLkSJ8AO9YujF7wAVjYscCfZCHxq0g+OX/Tb+mTI6RlVEfoyj7fLQyv+dVJwn5K5
	wI9ck+8z03mRtxCCet1nvTA97oh58E89BEywJeZaMHosMno2zLF53pJHEiS2coOqaWJ1h5ZeqXQ
	4LekjcPW+js7527c=
X-Google-Smtp-Source: AGHT+IGrKFiapGLIEGHnSEZIAujUvj6ZJLSj064m/nFeE0wcOjOeNVFt0u8EmZ8qnV5tFeQau4dR7A==
X-Received: by 2002:a17:903:3c6b:b0:224:24d3:6103 with SMTP id d9443c01a7336-22a955734f5mr25800795ad.35.1743815846125;
        Fri, 04 Apr 2025 18:17:26 -0700 (PDT)
Received: from [10.0.2.15] (KD106167137155.ppp-bb.dion.ne.jp. [106.167.137.155])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-229785b352esm39374225ad.18.2025.04.04.18.17.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 04 Apr 2025 18:17:25 -0700 (PDT)
Message-ID: <811c4103-08b1-4288-9a15-bd9795bc59f4@gmail.com>
Date: Sat, 5 Apr 2025 10:17:16 +0900
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
To: nfraprado@collabora.com
Cc: James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org,
 anton.ivanov@cambridgegreys.com, corbet@lwn.net, davem@davemloft.net,
 dmaengine@vger.kernel.org, ebiggers@kernel.org, edumazet@google.com,
 horms@kernel.org, jaegeuk@kernel.org, jarkko@kernel.org, jic23@kernel.org,
 johannes@sipsolutions.net, kernel@collabora.com, keyrings@vger.kernel.org,
 kuba@kernel.org, lars@metafoo.de, linux-doc@vger.kernel.org,
 linux-fscrypt@vger.kernel.org, linux-iio@vger.kernel.org,
 linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-media@vger.kernel.org, linux-mm@kvack.org,
 linux-sound@vger.kernel.org, linux-um@lists.infradead.org,
 maxime.chevallier@bootlin.com, mchehab@kernel.org, netdev@vger.kernel.org,
 pabeni@redhat.com, perex@perex.cz, richard@nod.at, tiwai@suse.com,
 tytso@mit.edu, vkoul@kernel.org, workflows@vger.kernel.org,
 zohar@linux.ibm.com, Akira Yokosawa <akiyks@gmail.com>
References: <20250404-doc-paths-unliteral-v1-1-74718785444e@collabora.com>
Subject: Re: [PATCH] docs: Remove literal markup from Documentation/ paths
Content-Language: en-US
From: Akira Yokosawa <akiyks@gmail.com>
In-Reply-To: <20250404-doc-paths-unliteral-v1-1-74718785444e@collabora.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Hi,

Nícolas F. R. A. Prado wrote:
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
> ---
[...]

>  Documentation/process/submit-checklist.rst                | 7 ++++---

I have updated ja_JP translation of this recently.

> diff --git a/Documentation/process/submit-checklist.rst b/Documentation/process/submit-checklist.rst
> index beb7f94279fdb6a1d9b4aa86b2bea031f140732b..3ae31c5af2cb5c374658c1fb7125e70bf36e911c 100644
> --- a/Documentation/process/submit-checklist.rst
> +++ b/Documentation/process/submit-checklist.rst
> @@ -30,7 +30,8 @@ Review Kconfig changes
>  
>  1) Any new or modified ``CONFIG`` options do not muck up the config menu and
>     default to off unless they meet the exception criteria documented in
> -   ``Documentation/kbuild/kconfig-language.rst`` Menu attributes: default value.
> +   Documentation/kbuild/kconfig-language.rst, under "Menu attributes", "default
> +   value".

I have made the same change in the translation, but failed to submit a patch...

>  
>  2) All new ``Kconfig`` options have help text.
>  
> @@ -47,7 +48,7 @@ Provide documentation
>  2) All new ``/proc`` entries are documented under ``Documentation/``
>  
>  3) All new kernel boot parameters are documented in
> -   ``Documentation/admin-guide/kernel-parameters.rst``.
> +   Documentation/admin-guide/kernel-parameters.rst.

Hmm, this item is asking "Have you documented the new params in that
particular file?", so I don't think this change should be made.

>  
>  4) All new module parameters are documented with ``MODULE_PARM_DESC()``
>  
> @@ -58,7 +59,7 @@ Provide documentation
>     linux-api@vger.kernel.org.
>  
>  6) If any ioctl's are added by the patch, then also update
> -   ``Documentation/userspace-api/ioctl/ioctl-number.rst``.
> +   Documentation/userspace-api/ioctl/ioctl-number.rst.

Ditto.

        Thanks, Akira

>  
>  Check your code with tools
>  ==========================


