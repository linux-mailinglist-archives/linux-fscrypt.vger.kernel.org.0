Return-Path: <linux-fscrypt+bounces-324-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id EEFF391F01A
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jul 2024 09:28:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 9BDFC1F20F22
	for <lists+linux-fscrypt@lfdr.de>; Tue,  2 Jul 2024 07:28:49 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id ECB6E13D8BA;
	Tue,  2 Jul 2024 07:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iYN4rARC"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C153E133987;
	Tue,  2 Jul 2024 07:28:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719905308; cv=none; b=ZUVym+pvfBA/BGasIsR0Bjsxm6+4+6e9HMHXg9fWS0HUuPRmyqELkMRS9MePXCQq4BwPxmSTDBvW4as2EStnPviUlFvHNTUW1r4XhG3YlhsF87J/uFFEfTFB7vtjyGBzYJlV8cJkKOYDXXHprfUXwvVwW9rtp9BF/X8T51laTG8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719905308; c=relaxed/simple;
	bh=+G9ORUrBUv9a/KnYMu5t8kezquGhj4+2CEx9gv7oeJw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=okEFj/MTX+4z8blOg5JtMXQe25jatm7hPcrU3kH8gTmfiCF1oncO9Ucip6ehnMZOmG3I4h7SZtjbK85LP6i75c3p9YsKxeRgirPq3CJB9TdlF+oTKmbA/hadePzwKqb8dObwr0Krzau70fYxoPcfeuFdEra6YgM459FhwOVvGOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iYN4rARC; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 514DBC116B1;
	Tue,  2 Jul 2024 07:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1719905308;
	bh=+G9ORUrBUv9a/KnYMu5t8kezquGhj4+2CEx9gv7oeJw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=iYN4rARCVPZ5D5bMzDOcOqyUMHkmWXuxml6g4BGWZ3IISsZBN3EVV1ahsWlbYBnT6
	 hOQV9u9dPswb0CFjVqHpEVkGfaegXgVIcYQepefWI2HB6+OFZnY6D+HOq0eU0mMD6U
	 1nnO2LAtYZXRGRqJnr3EFE36STNS2il2EkBYPQjv4JoJpLG+VXljlLlTAy390Bph7Z
	 i3dZr4T13T/2kE6cZlBwL56ET3wR9h9WhvUhmMq3h4xFaARKHo1rf7Z/M6iZdIMG1o
	 iIJiYAbGGwoZVqjFM8sCvtXHQMIp4YUSUcPkxXugegIPuL20ILhIzvoGY2K5wj/+uV
	 EZZzx/Ey4yRuA==
Date: Tue, 2 Jul 2024 00:28:26 -0700
From: Eric Biggers <ebiggers@kernel.org>
To: Bart Van Assche <bvanassche@acm.org>
Cc: linux-scsi@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Avri Altman <avri.altman@wdc.com>,
	"Martin K . Petersen" <martin.petersen@oracle.com>,
	Peter Griffin <peter.griffin@linaro.org>,
	=?iso-8859-1?Q?Andr=E9?= Draszik <andre.draszik@linaro.org>,
	William McVicker <willmcvicker@google.com>
Subject: Re: [PATCH 6/6] scsi: ufs: exynos: Add support for Flash Memory
 Protector (FMP)
Message-ID: <20240702072826.GA121190@sol.localdomain>
References: <20240611223419.239466-1-ebiggers@kernel.org>
 <20240611223419.239466-7-ebiggers@kernel.org>
 <4dfd06ba-7d95-435b-95e1-e864a33447b9@acm.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4dfd06ba-7d95-435b-95e1-e864a33447b9@acm.org>

On Fri, Jun 14, 2024 at 10:08:49AM -0700, Bart Van Assche wrote:
> On 6/11/24 3:34 PM, Eric Biggers wrote:
> > +#define FMP_DATA_UNIT_SIZE	SZ_4K
> 
> A Samsung employee told me that the Exynos encryption data unit size is configurable
> and also that it is set by the following code:
> 
> 	hci_writel(ufs, PRDT_SET_SIZE(12), HCI_TXPRDT_ENTRY_SIZE);
> 	hci_writel(ufs, PRDT_SET_SIZE(12), HCI_RXPRDT_ENTRY_SIZE);
> 
> How about introducing a new macro that represents the TX PRDT entry size, the RX PRDT
> entry size and the encryption data unit size?
> 

Done in v2.

- Eric

