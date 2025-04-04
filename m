Return-Path: <linux-fscrypt+bounces-633-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 877A9A7C24A
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Apr 2025 19:20:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 5672B17B90D
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Apr 2025 17:20:19 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9D306211A23;
	Fri,  4 Apr 2025 17:20:13 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 440301F3D45;
	Fri,  4 Apr 2025 17:20:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.176.79.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743787213; cv=none; b=cz59c2jTgDAdsVfWLERAtZbBtDFUrBmAx1GEiHysuGb2tSGIrhLmLxow2FHx44xWtbZYGc3H5RHfS72MVQJZU88xZjNvRRnYQJNeAMlAGp6fUhBpwiweiBBzUg6FyKZuLilaienvgGGVEhrG6AyTNp2as4GJadTALEr9QvbO/Zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743787213; c=relaxed/simple;
	bh=HA1xCpYpiuBjQTt/pfzcIBhSFbPJbNH4yu1fa14YH+E=;
	h=Date:From:To:CC:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=LrgcZRzSoarwsFNtT8Z3NQaWlAOyQ+vE0yw4tv4rkAizVdBRSYoX0nxGjuwUF/blSUTkiGSQsp0ABqpVzkRth1gEvY4w75O7WKxssYQdwiFFD2BqA3JXNKOIXAfaomow6xUzF2QZtLzBcZBG9N0P1FS9NwUZP5rq4KJbBh+Zhpg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=185.176.79.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.18.186.231])
	by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4ZTld74xBKz6K9J8;
	Sat,  5 Apr 2025 01:16:27 +0800 (CST)
Received: from frapeml500008.china.huawei.com (unknown [7.182.85.71])
	by mail.maildlp.com (Postfix) with ESMTPS id BEE601402C7;
	Sat,  5 Apr 2025 01:20:08 +0800 (CST)
Received: from localhost (10.203.177.66) by frapeml500008.china.huawei.com
 (7.182.85.71) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.1.2507.39; Fri, 4 Apr
 2025 19:20:07 +0200
Date: Fri, 4 Apr 2025 18:20:06 +0100
From: Jonathan Cameron <Jonathan.Cameron@huawei.com>
To: "=?ISO-8859-1?Q?N=EDcolas?= F. R. A. Prado" <nfraprado@collabora.com>
CC: Andrew Morton <akpm@linux-foundation.org>, Jonathan Corbet
	<corbet@lwn.net>, Vinod Koul <vkoul@kernel.org>, Eric Biggers
	<ebiggers@kernel.org>, "Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim
	<jaegeuk@kernel.org>, Jonathan Cameron <jic23@kernel.org>, "Lars-Peter
 Clausen" <lars@metafoo.de>, "David S. Miller" <davem@davemloft.net>, "Eric
 Dumazet" <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, "Paolo
 Abeni" <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, "Maxime
 Chevallier" <maxime.chevallier@bootlin.com>, James Bottomley
	<James.Bottomley@HansenPartnership.com>, Jarkko Sakkinen <jarkko@kernel.org>,
	Mimi Zohar <zohar@linux.ibm.com>, Jaroslav Kysela <perex@perex.cz>, Takashi
 Iwai <tiwai@suse.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Richard
 Weinberger <richard@nod.at>, Anton Ivanov <anton.ivanov@cambridgegreys.com>,
	Johannes Berg <johannes@sipsolutions.net>, <kernel@collabora.com>,
	<linux-mm@kvack.org>, <linux-doc@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <dmaengine@vger.kernel.org>,
	<linux-fscrypt@vger.kernel.org>, <linux-iio@vger.kernel.org>,
	<netdev@vger.kernel.org>, <workflows@vger.kernel.org>,
	<linux-integrity@vger.kernel.org>, <keyrings@vger.kernel.org>,
	<linux-sound@vger.kernel.org>, <linux-media@vger.kernel.org>,
	<linux-um@lists.infradead.org>
Subject: Re: [PATCH] docs: Remove literal markup from Documentation/ paths
Message-ID: <20250404182006.000038cc@huawei.com>
In-Reply-To: <20250404-doc-paths-unliteral-v1-1-74718785444e@collabora.com>
References: <20250404-doc-paths-unliteral-v1-1-74718785444e@collabora.com>
X-Mailer: Claws Mail 4.3.0 (GTK 3.24.42; x86_64-w64-mingw32)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: quoted-printable
X-ClientProxiedBy: lhrpeml100006.china.huawei.com (7.191.160.224) To
 frapeml500008.china.huawei.com (7.182.85.71)

On Fri, 04 Apr 2025 11:37:28 -0400
N=EDcolas F. R. A. Prado <nfraprado@collabora.com> wrote:

> Given that the automarkup Sphinx plugin cross-references
> "Documentation/*.rst" strings in the text to the corresponding
> documents, surrounding those strings with the literal markup (``) not
> only adds unnecessary markup in the source files, but actually prevents
> the automatic cross-referencing to happen (as it doesn't happen in
> literal blocks).
>=20
> Remove all the occurrences of the literal markup in
> "Documentation/*.rst" paths, except when the actual source file is being
> referred. Also change the surrounding text when needed so it reads well
> both in the source and the web page (eg. 'see file Doc...' -> 'see
> Doc...').
>=20
> Signed-off-by: N=EDcolas F. R. A. Prado <nfraprado@collabora.com>
> ---
>  Documentation/admin-guide/mm/numa_memory_policy.rst       | 2 +-
>  Documentation/admin-guide/serial-console.rst              | 2 +-
>  Documentation/driver-api/dmaengine/client.rst             | 2 +-
>  Documentation/driver-api/nvdimm/security.rst              | 2 +-
>  Documentation/filesystems/fscrypt.rst                     | 4 ++--
>  Documentation/iio/adis16475.rst                           | 4 ++--
>  Documentation/iio/adis16480.rst                           | 4 ++--
>  Documentation/iio/adis16550.rst                           | 4 ++--
>  Documentation/iio/adxl380.rst                             | 4 ++--

Split patch up by subsystem would be a good thing here as we may
get other changes to these docs during the cycle and resulting
merge conflicts if this all goes in as one patch.


>  Documentation/kernel-hacking/hacking.rst                  | 6 +++---
>  Documentation/kernel-hacking/locking.rst                  | 2 +-
>  Documentation/networking/dsa/b53.rst                      | 2 +-
>  Documentation/networking/dsa/bcm_sf2.rst                  | 2 +-
>  Documentation/networking/dsa/dsa.rst                      | 2 +-
>  Documentation/networking/dsa/lan9303.rst                  | 2 +-
>  Documentation/networking/phy-link-topology.rst            | 2 +-
>  Documentation/process/adding-syscalls.rst                 | 2 +-
>  Documentation/process/submit-checklist.rst                | 7 ++++---
>  Documentation/security/keys/trusted-encrypted.rst         | 4 ++--
>  Documentation/sound/kernel-api/writing-an-alsa-driver.rst | 2 +-
>  Documentation/userspace-api/media/v4l/dev-sliced-vbi.rst  | 2 +-
>  Documentation/userspace-api/media/v4l/diff-v4l.rst        | 2 +-
>  Documentation/userspace-api/media/v4l/ext-ctrls-codec.rst | 4 ++--
>  Documentation/virt/uml/user_mode_linux_howto_v2.rst       | 2 +-
>  24 files changed, 36 insertions(+), 35 deletions(-)

