Return-Path: <linux-fscrypt+bounces-642-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0F476A7C9EB
	for <lists+linux-fscrypt@lfdr.de>; Sat,  5 Apr 2025 17:32:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C7DE61767C0
	for <lists+linux-fscrypt@lfdr.de>; Sat,  5 Apr 2025 15:32:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16991148FE6;
	Sat,  5 Apr 2025 15:32:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jVK6JF8R"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACE337404E;
	Sat,  5 Apr 2025 15:32:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743867135; cv=none; b=d36Pwr56D6G4cyCQN2SY8MZKD75n/dxTNYNElzkSQvD1kwmg/HBOBaM+AiGjH7jLnYOKU7ddmNDXHQCymIKOrjfBi1Lz2L4TvfhOwojMBTB8pdrg1VW/1yAoGhmpjzjXy5kpphZhwVQjjRbkXfJqTZ5eBoe8VcvPXROjeEwDtNE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743867135; c=relaxed/simple;
	bh=RdPSb3R/N8g0+oYT6+2V0LNQyAZKsrTfROQEnTne+ak=;
	h=Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=i9ukhjP9rSkq2+bxD6dDUDlaAbQAyCLWIvM2aKxmqIU+OP8jSQ1BmrFr17uEspx9SDJW/YNux1ZKpbG6loYeFOVGwoT8JpgOz3uFiHCrWMp9hgT4GD5twxzQ8c0P0jgI/2bRwoUh3SMH0YOkQN7edndpQ25C+GSBAFxQARJvtDY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jVK6JF8R; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23B8AC4CEE4;
	Sat,  5 Apr 2025 15:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743867134;
	bh=RdPSb3R/N8g0+oYT6+2V0LNQyAZKsrTfROQEnTne+ak=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=jVK6JF8RzIa2fTbodJS2FISwWudNboXPBdoMoty0m2mNay6iJThuDSiveMToI7V8O
	 6g42eS8E8LtVI1QtvaMdw0SCKHNRCfLy0HhQZ9huqFtTKXXYLeE0vgxLVvbbhyeWV9
	 /2AcgLtXGwCv+ZtdoJsPxpFgNHty72ixEgcls3MiRRT57BMJNjgXWrqquPIHsgUjWo
	 Xrc3yG2qtgjXemyHrcmVgYcq10cFR7TTNYhQzl+nTvdm+Ef7qp75wk6UO/6XQFrscS
	 v1OjaKgVM6dR70zKrI+gtG7dOiGVaMpbieSrkNOSwc3LpO/u9ElY/UEveU82g3GLiz
	 NgnIiJ3gmDWxw==
Date: Sat, 5 Apr 2025 16:31:58 +0100
From: Jonathan Cameron <jic23@kernel.org>
To: Jonathan Corbet <corbet@lwn.net>
Cc: Jonathan Cameron <Jonathan.Cameron@huawei.com>, "=?UTF-8?B?TsOtY29s?=
 =?UTF-8?B?YXM=?= F. R. A. Prado" <nfraprado@collabora.com>, Andrew Morton
 <akpm@linux-foundation.org>, Vinod Koul <vkoul@kernel.org>, Eric Biggers
 <ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim
 <jaegeuk@kernel.org>, Lars-Peter Clausen <lars@metafoo.de>, "David S.
 Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Jakub
 Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>, Simon Horman
 <horms@kernel.org>, Maxime Chevallier <maxime.chevallier@bootlin.com>,
 James Bottomley <James.Bottomley@HansenPartnership.com>, Jarkko Sakkinen
 <jarkko@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>, Jaroslav Kysela
 <perex@perex.cz>, Takashi Iwai <tiwai@suse.com>, Mauro Carvalho Chehab
 <mchehab@kernel.org>, Richard Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, kernel@collabora.com, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 dmaengine@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-iio@vger.kernel.org, netdev@vger.kernel.org,
 workflows@vger.kernel.org, linux-integrity@vger.kernel.org,
 keyrings@vger.kernel.org, linux-sound@vger.kernel.org,
 linux-media@vger.kernel.org, linux-um@lists.infradead.org
Subject: Re: [PATCH] docs: Remove literal markup from Documentation/ paths
Message-ID: <20250405163158.55935fdf@jic23-huawei>
In-Reply-To: <874iz3g6w1.fsf@trenco.lwn.net>
References: <20250404-doc-paths-unliteral-v1-1-74718785444e@collabora.com>
	<20250404182006.000038cc@huawei.com>
	<874iz3g6w1.fsf@trenco.lwn.net>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.48; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

On Fri, 04 Apr 2025 11:42:54 -0600
Jonathan Corbet <corbet@lwn.net> wrote:

> Jonathan Cameron <Jonathan.Cameron@huawei.com> writes:
>=20
> > On Fri, 04 Apr 2025 11:37:28 -0400
> > N=C3=ADcolas F. R. A. Prado <nfraprado@collabora.com> wrote:
> > =20
> >> Given that the automarkup Sphinx plugin cross-references
> >> "Documentation/*.rst" strings in the text to the corresponding
> >> documents, surrounding those strings with the literal markup (``) not
> >> only adds unnecessary markup in the source files, but actually prevents
> >> the automatic cross-referencing to happen (as it doesn't happen in
> >> literal blocks).
> >>=20
> >> Remove all the occurrences of the literal markup in
> >> "Documentation/*.rst" paths, except when the actual source file is bei=
ng
> >> referred. Also change the surrounding text when needed so it reads well
> >> both in the source and the web page (eg. 'see file Doc...' -> 'see
> >> Doc...').
> >>=20
> >> Signed-off-by: N=C3=ADcolas F. R. A. Prado <nfraprado@collabora.com>
> >> ---
> >>  Documentation/admin-guide/mm/numa_memory_policy.rst       | 2 +-
> >>  Documentation/admin-guide/serial-console.rst              | 2 +-
> >>  Documentation/driver-api/dmaengine/client.rst             | 2 +-
> >>  Documentation/driver-api/nvdimm/security.rst              | 2 +-
> >>  Documentation/filesystems/fscrypt.rst                     | 4 ++--
> >>  Documentation/iio/adis16475.rst                           | 4 ++--
> >>  Documentation/iio/adis16480.rst                           | 4 ++--
> >>  Documentation/iio/adis16550.rst                           | 4 ++--
> >>  Documentation/iio/adxl380.rst                             | 4 ++-- =20
> >
> > Split patch up by subsystem would be a good thing here as we may
> > get other changes to these docs during the cycle and resulting
> > merge conflicts if this all goes in as one patch. =20
>=20
> That seems like a way to add a significant amount of pain to a basic
> (but indeed useful) cleanup patch like this.  If the relevant
> maintainers insist on it then that's how it has to be done, but I bet I
> could just take the whole thing through docs with almost no trouble.
>=20
hmm.  I'll go with maybe. Let's cross fingers then.

Acked-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>

> jon


