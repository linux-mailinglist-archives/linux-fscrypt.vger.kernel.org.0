Return-Path: <linux-fscrypt+bounces-332-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5244D929FFB
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 12:14:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 46CDF2877CC
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 10:14:47 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6F646762D2;
	Mon,  8 Jul 2024 10:14:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="tSeDj6eI"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEB6A7581A
	for <linux-fscrypt@vger.kernel.org>; Mon,  8 Jul 2024 10:14:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720433684; cv=none; b=OA5h/IqQkkuJXnGTjBu1W6kZk30gjOTHaVxfiMTrbg/CBNEC82zgWTDIUhGwOMRcOP/FAnBi5qQDyl6ZuKDvmrsPf266b37emT13WFMAIZiUFdqbOnrUMeZxWLX3P9cxgw4INE8a0x03YYUF+ZUbkgJ/O30E/yN429HbBk/unsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720433684; c=relaxed/simple;
	bh=mdVR5DRCAlUSw+xlybDf+S/9XIvFQblFmhn0Muinhjs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HEacvFtIHDjffQU+8LCHtaywaFQAow+tMqZ86Bw70IJjFtQfciK3N0Ye46yIQFWBI9Xa0CAreYoBOHgsJgLdgfAexuiEydIa0qAA71x0BaaoDnwNWQSU0zBHIXLGkUfXCZPVbd6buAxldn5cjyfQ72/Xwtz0bMUTs7YAfY9mkSI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=tSeDj6eI; arc=none smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-5c6639969cbso690733eaf.3
        for <linux-fscrypt@vger.kernel.org>; Mon, 08 Jul 2024 03:14:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720433682; x=1721038482; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=18mFUjlhCEFSztkcHmlQ6M7fE1sy3dAJtP6H2AmzxHQ=;
        b=tSeDj6eIjkW+IJkgWUeAl0cZurxmv0Pw1t0bB5Bkf8+4CI2U61LynOPqZAo8J5PoMl
         ZBstK80tW+zwtb6mDrfHagNiMQUgaGzntUsOaK9ah7WEK9p7Q726lq9QTP692MoSBleX
         t+Og1wOCBwK+K25UQ99uDB3XKjwxGPAffccBTN8bXEzJw88+IYy0/M5apbRgd4pvuo4t
         KX7wTMV8iY9y1Sv/9F17uP5c0OWoaDEd9tcHSioxH5TMEO4HYmRcswylEwTgmgeezugA
         hV/55ve5pTa5A266bwE+7errpEnGisTXcWuGhuNAXKj7/HLojPGV1V5g8AMNBf5R+2hL
         dmnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720433682; x=1721038482;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=18mFUjlhCEFSztkcHmlQ6M7fE1sy3dAJtP6H2AmzxHQ=;
        b=cRFGU8YoOqBXv3ZdV/znCcTKQkJqZtPwwxH5QHDB9mavoE0hkwVEk7WUjAqh61G1U6
         WYiKHfN6NTo5LvTXUrb6T/0SoZ5ltcCyuLtxPdm8gKLOBCqz8SmyY4r/jBTvbrNORPdh
         s/5vi37IRnGiE7HXW1SaFX3iIRL+ZLv0LMCTyiBvI9vt8qAPG7ocrKom7o21cj7OhutE
         K0NIA6BH1r6hzcVZSc4wsNbBY8zknMSE2vsR6qP3Niw3DwbPVDpYLT2ESQfKLx8wZIQV
         tmXr4jyUEdshLempCqA8D+7IlEtkiI2NBJwU+K0U1Xp8vT9Y3eJ4BoWDL/5C+3Gqi6kY
         fjXg==
X-Forwarded-Encrypted: i=1; AJvYcCV9zSxrIgIzTkBhkApHnO5bHePr2CYMXckcsUM/kH08Ql7XkrdIeoG2bZ0ry8lRmzt+wE3hBTObgTaYrw784rA1i94KKr8gNgeeqlAWJw==
X-Gm-Message-State: AOJu0Yw86iTOZWelE27Q+ApU+JqSQjSLZRd7m14CV5NE/CmNqvMPxPBz
	bwxscOhteFhM+yR9/Q6Ry95wQ98PnB0DkCGsHk869Q1p2yXNz9+HmzWfpd6HnEek+3UgUrF9vA+
	Q6mllQpZYLiK7EluMu850ShOLPwHVIRGkwWKdeECEZKUgESD9pa0=
X-Google-Smtp-Source: AGHT+IEidV5BA3GbP/YUGyFWXUPUfjUVbg/HkGroMH2IukzlChvyhkwiqBj3UjHON66KEYrUdeF5hH0WDWHlcPueGqc=
X-Received: by 2002:a4a:2:0:b0:5bb:1310:5f37 with SMTP id 006d021491bc7-5c646e9798cmr9054879eaf.3.1720433682004;
 Mon, 08 Jul 2024 03:14:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240702072510.248272-1-ebiggers@kernel.org> <20240702072510.248272-3-ebiggers@kernel.org>
In-Reply-To: <20240702072510.248272-3-ebiggers@kernel.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Mon, 8 Jul 2024 11:14:31 +0100
Message-ID: <CADrjBPop5VwR+QW8XQi7ALEwWpt=OkB1X7bPjfk9gaWHn95r9g@mail.gmail.com>
Subject: Re: [PATCH v2 2/6] scsi: ufs: core: fold ufshcd_clear_keyslot() into
 its caller
To: Eric Biggers <ebiggers@kernel.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, Alim Akhtar <alim.akhtar@samsung.com>, 
	Avri Altman <avri.altman@wdc.com>, Bart Van Assche <bvanassche@acm.org>, 
	"Martin K . Petersen" <martin.petersen@oracle.com>, =?UTF-8?Q?Andr=C3=A9_Draszik?= <andre.draszik@linaro.org>, 
	William McVicker <willmcvicker@google.com>
Content-Type: text/plain; charset="UTF-8"

Hi Eric,

On Tue, 2 Jul 2024 at 08:28, Eric Biggers <ebiggers@kernel.org> wrote:
>
> From: Eric Biggers <ebiggers@google.com>
>
> Fold ufshcd_clear_keyslot() into its only remaining caller.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Reviewed-by:  Peter Griffin <peter.griffin@linaro.org>

[..]

regards,

Peter

