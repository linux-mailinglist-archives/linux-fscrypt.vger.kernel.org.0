Return-Path: <linux-fscrypt+bounces-333-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D2ECB92A002
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 12:18:48 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0BCDB1C20CF3
	for <lists+linux-fscrypt@lfdr.de>; Mon,  8 Jul 2024 10:18:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9CFC5482DE;
	Mon,  8 Jul 2024 10:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="k3VcjDjA"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C34D34CD8
	for <linux-fscrypt@vger.kernel.org>; Mon,  8 Jul 2024 10:18:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1720433925; cv=none; b=KuhbRLH1bmg5py6748QTc6pqTHrRt0QwRjNjf0ng8PbZOUynuM+E1Bj8FzyitMcfZ0yT4nDOVzohhCiB87e76/ukCgUYpeiKlc74ZsmzyDHjeEN9GBxrPPxcHv7FehYHsWl8xClJR9EJoQIB38l7UwkU6twsZuZFB6Rq27njnEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1720433925; c=relaxed/simple;
	bh=vEGAapFRjI501MYswUKdFdLhmHF/1NB+R8R2PfH1hLE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=NB/WPX8t9xyYv06dChjJiPqeqP7cNJqmLl++SzG1gMnlnm5/nbpc5wWLJz3wufrMLgAWuK+91CJl7bO4XFPviI+tmNWDr/WqkloHJkfs6J993hnAOxSXF8TYrN+K35veg8DqSb8XZm/4rkXayocggcl6rO1dIkJwNV69ug1/ags=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=k3VcjDjA; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-3d925e50f33so1118551b6e.2
        for <linux-fscrypt@vger.kernel.org>; Mon, 08 Jul 2024 03:18:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1720433923; x=1721038723; darn=vger.kernel.org;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=C05iwDI122P+LyKKeS9yPk8Jmk0qt5vE9oNXx72X8Dk=;
        b=k3VcjDjAU3UcQoIV0HO0OVTPggUkwDzN1kTO7lc8dfKXlwaTYbaHBBLit+32WOfrOp
         ANGa6irislsm4sZWnSs0i3/WBHv1BhUFcCoIH2qH5kFyhnhd1klBYqViUxr0jLKn3wdo
         mvc3jXSBY1hSWJCN7Bytd1q5L1gRXjs2f8mCgAD2iS0tqE6kKIIywGu9BHNzhMscKJxI
         WQGKaKiica6YFMbmNFHHPXwuJyN/CkFM4u5eK9MsfmL0ZF63Ynpwl6VXrv786aN/Qe7P
         zbEZc1KODUyCkQSpdqRjFBXcaVIm3ju6Y991tmbA2HchtIN7qv3e5U1wdhSqIc2Xrejt
         Jrrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1720433923; x=1721038723;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=C05iwDI122P+LyKKeS9yPk8Jmk0qt5vE9oNXx72X8Dk=;
        b=rfhDZx2/JZyF0zBk2MplNVrsrnZpc9qNrpftiRH5SG6t5IqsHKt4VoIAYnVi8NwJio
         +WhhOD41mWQ8QdoPgU6yd9IUmCAw4sksC/+7MT/R05A2LbdG7eerZk83Z3o12bDJWC3V
         cBWJPM+WP09IwxVNIH4OYXXpKZm/sOZAlRoH6vKhJUIy5WGPrnIEYfq3lUcSM6XgDdFN
         C7NqOHfk+AfgxmMSOGDMT11kWqZQ77xNegYPgSSvOC/p1Cao58yJlkzYXNagvVFroeou
         Xr6cMZfW7K9g2QKv3YcOYpH/DgYKrB9lgIEHKh/khbRw9NRGXD4sViPVYgI23WiK/lg1
         kovg==
X-Forwarded-Encrypted: i=1; AJvYcCWBI1YZOrROKN+VbZOohytPqHwDjf956FL4o9JIXgYhIpI6orcN4PXyOLhwAoJU9Uoq8yG/3mKMgRykRDiHkPEMTeUc0+siwWhjVLYNKw==
X-Gm-Message-State: AOJu0YyrH6cQinxcV7vuEcxvxQPwToSs8XYZdKiWp2pIO8r1DB8QKjMe
	IJqEqMqbSqh7Ht5boGm9J52fj44yofcJFjFHwT4iBR/0+3GrMTT/jt6aYCbgrNq8CyioZLx4noM
	oYPTsDuTzZN28ENQfVBsavzkxRBPuuoh9S186Ag==
X-Google-Smtp-Source: AGHT+IHnExyWB3RdFty63aa+Ml5nM5CwhGI0pyjKmeyRRliSl5t4o2vh3/Hq8s1DvYqWwZ68mL5LA5GE7W8C78uPIjs=
X-Received: by 2002:a05:6808:10d1:b0:3d9:2ac4:5d63 with SMTP id
 5614622812f47-3d92ac46007mr6215261b6e.25.1720433923157; Mon, 08 Jul 2024
 03:18:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20240702072510.248272-1-ebiggers@kernel.org> <20240702072510.248272-2-ebiggers@kernel.org>
In-Reply-To: <20240702072510.248272-2-ebiggers@kernel.org>
From: Peter Griffin <peter.griffin@linaro.org>
Date: Mon, 8 Jul 2024 11:18:32 +0100
Message-ID: <CADrjBPoSQTni8a8Ok_kYZWb_Q2FKX2suZkH5xYS2rVLALGAR=g@mail.gmail.com>
Subject: Re: [PATCH v2 1/6] scsi: ufs: core: Add UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE
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
> Add UFSHCD_QUIRK_CUSTOM_CRYPTO_PROFILE which lets UFS host drivers
> initialize the blk_crypto_profile themselves rather than have it be
> initialized by ufshcd-core according to the UFSHCI standard.  This is
> needed to support inline encryption on the "Exynos" UFS controller which
> has a nonstandard interface.
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---

Reviewed-by:  Peter Griffin <peter.griffin@linaro.org>

[..]

regards,

Peter

