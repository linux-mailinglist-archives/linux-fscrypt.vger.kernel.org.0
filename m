Return-Path: <linux-fscrypt+bounces-508-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 3CDB09A72D4
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Oct 2024 21:03:22 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 67DC61C214AD
	for <lists+linux-fscrypt@lfdr.de>; Mon, 21 Oct 2024 19:03:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 93BD91FBC8C;
	Mon, 21 Oct 2024 19:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cp31ZgBx"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B3B61CF7CC;
	Mon, 21 Oct 2024 19:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1729537372; cv=none; b=I7fQODzJsBUXxJ1+g8S275ImoW1MB+qopRGq0JYJDHiZ4Xzy/h/Hx7ngockjwWREmTPb6VoEfKmQ4wzJQtmFR6SbtH6rw980Ltfe7ihu/3eExbgfoc0sv2ACk5nKC9jlv6t8LFAF+PCQlZHI5hDiRTM2i8RKayUD2swb0k9Ub3I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1729537372; c=relaxed/simple;
	bh=vsbnNtYOihL02PJdWlvwTbTMZpcopwhOkYgiKqHnc7g=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=VfUeCYr5Mf6IofeURq5HaoNsiulU1KZKH1ShibFm8zKE2806yLEIefNHnFtg/t3bXFAIQDN135tQb3e/1I+wRmEbWj1TfO/8JeNlGqpiXdfJGkeTG6i5/JaQUWTfyCAufMwwK1KRygfxRV8sBQerJmW+iq/uMS7sV4dhdSP1/vQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cp31ZgBx; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4B23C4CEC3;
	Mon, 21 Oct 2024 19:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1729537372;
	bh=vsbnNtYOihL02PJdWlvwTbTMZpcopwhOkYgiKqHnc7g=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cp31ZgBxuboh+ucSekXdmlnI3mHdudXaS7XYFnpwXwWiqGdcRZEOzo8U5ia9IlgdU
	 Q00gJVrAOakH0PUA/rFTlLRrwwoeKd2LfApKX8cA378JE5RRkvM3Uj95pHY15VikaY
	 r5paDpIv0Fim2yM8OB1fhAKrxJEAQc9AZlrqczh6wssbWPGyPB0YDkQdjJ5KBJPmtm
	 pGxANDmkvm2gPCXgM+hvzGe+I4ibtpNEyMcOgSkWiqVX/uupV1cgbdn5K38++K9Arn
	 /JOZ+ibZYxQBNUHJlaib87bqllhOEmT5zeMwrM4TQtGLd2jnN6pPKmAsz1wlSgltmJ
	 f1aPAjnqalVMQ==
Date: Mon, 21 Oct 2024 19:02:49 +0000
From: Eric Biggers <ebiggers@kernel.org>
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: dm-devel@lists.linux.dev, linux-block@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
	Md Sadre Alam <quic_mdalam@quicinc.com>,
	Israel Rukshin <israelr@nvidia.com>,
	Milan Broz <gmazyland@gmail.com>,
	Adrian Vovk <adrianvovk@gmail.com>
Subject: Re: [RFC PATCH 2/4] block: add the bi_skip_dm_default_key flag
Message-ID: <20241021190249.GA1395714@google.com>
References: <20241018184339.66601-1-ebiggers@kernel.org>
 <20241018184339.66601-3-ebiggers@kernel.org>
 <2caf648d-73cf-9436-2af4-ad530a966592@redhat.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2caf648d-73cf-9436-2af4-ad530a966592@redhat.com>

On Mon, Oct 21, 2024 at 01:11:36PM +0200, Mikulas Patocka wrote:
> Hi
> 
> What about using the REQ_META flag (it is set on metadata bios and cleared 
> on data bios), instead of adding a new flag with the same meaning?
> 
> Mikulas

REQ_META is a hint and is not used for all metadata.

And while metadata is the main point, more precisely the goal is to encrypt
every block that isn't already encrypted.  That means that the contents of files
that are unencrypted at the filesystem layer are encrypted by dm-default-key
too.  So technically it's more than just metadata.

To avoid recurring "oops, we forgot to encrypt this" bugs, the right model is
really an opt-out flag, not opt-in.  And especially not opt-in via something
that is currently just a hint and is used as such.

- Eric

