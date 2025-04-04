Return-Path: <linux-fscrypt+bounces-634-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1BDB7A7C2A2
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Apr 2025 19:43:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 48E5C7A508D
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Apr 2025 17:42:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CBB47215F46;
	Fri,  4 Apr 2025 17:43:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b="gjzgvuRx"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from ms.lwn.net (ms.lwn.net [45.79.88.28])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E4A19CCF5;
	Fri,  4 Apr 2025 17:42:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.79.88.28
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743788586; cv=none; b=VLfw1EPQUan8zLpnwXi5ZGs1tR4wGuyCNjq7TVKzjX05UX6awJZN0CyyklbvwGv/rU6M85IPdLKHhXQ13xlzaoYFm6srFBF5MsxvXUtzPvxsbszNgOmZoxah9aYuRQqAh9TCoY8eZVv9Ci0aQ0GH4XnjpEmy+kJbJ+IpKi2tA3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743788586; c=relaxed/simple;
	bh=64IZKEhRyE4FDTtfV/JRObo1kIgvMNxD89S+aQlJRcY=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=kq6sNZW7KzJskg1H4mwEdSyYep3M22CYe0uI2zOBj0I14nesyzl12R40r4gB8AjImSkaZzw4/DHeuBRvfvnBAe+m9//2HO5E6YEoyc4GFYGtYcrizekhALhGP1SK0FPIX7mwJTk7bWXV79jxI8HHbMD8El9kkER0Z6moFe0H3KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net; spf=pass smtp.mailfrom=lwn.net; dkim=pass (2048-bit key) header.d=lwn.net header.i=@lwn.net header.b=gjzgvuRx; arc=none smtp.client-ip=45.79.88.28
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lwn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lwn.net
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 712B140407
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
	t=1743788575; bh=JzbhxxufdLBWNEgR9vh1QpsUJVM3j8df+P7niCurQOQ=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=gjzgvuRxZCBmi8B6mkrqXXRmMKQkpGQhbiqLXejxp/qRwu5yW7JSeYWStGwDZMaO+
	 B3f79u/9zrKGbFs5vQRDl/ICF/laMc5MDfcYEBYHwtMMTcfRWPwvW7+/gel1Nc42gY
	 DkfUyQLmULGr9Q08Npj3bYSv74wwxIaM7vXi0npgl0MqVahgRfkb/AhVrG1s/46cIj
	 zvUfYkYmt1a52pM4Gs14ivgHcAR+r8skBoqp8C1wzyt9JXJZYNfn7prWSbPfW3Rqa/
	 GieNnfvB9yehHrM8xXgX5u5KMqO7ag8pturer7DhZ+rq9ooE0/m8bgOq5AUQQv3iTH
	 gCYovv7u8iTTQ==
Received: from localhost (unknown [IPv6:2601:280:4600:2da9::1fe])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by ms.lwn.net (Postfix) with ESMTPSA id 712B140407;
	Fri,  4 Apr 2025 17:42:55 +0000 (UTC)
From: Jonathan Corbet <corbet@lwn.net>
To: Jonathan Cameron <Jonathan.Cameron@huawei.com>, =?utf-8?Q?N=C3=ADcolas?=
 =?utf-8?Q?_F=2E_R=2E_A=2E_Prado?=
 <nfraprado@collabora.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Vinod Koul
 <vkoul@kernel.org>, Eric Biggers <ebiggers@kernel.org>, "Theodore Y. Ts'o"
 <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Jonathan Cameron
 <jic23@kernel.org>, Lars-Peter
 Clausen <lars@metafoo.de>, "David S. Miller" <davem@davemloft.net>, Eric
 Dumazet <edumazet@google.com>, Jakub Kicinski <kuba@kernel.org>, Paolo
 Abeni <pabeni@redhat.com>, Simon Horman <horms@kernel.org>, Maxime
 Chevallier <maxime.chevallier@bootlin.com>, James Bottomley
 <James.Bottomley@HansenPartnership.com>, Jarkko Sakkinen
 <jarkko@kernel.org>, Mimi Zohar <zohar@linux.ibm.com>, Jaroslav Kysela
 <perex@perex.cz>, Takashi
 Iwai <tiwai@suse.com>, Mauro Carvalho Chehab <mchehab@kernel.org>, Richard
 Weinberger <richard@nod.at>, Anton Ivanov
 <anton.ivanov@cambridgegreys.com>, Johannes Berg
 <johannes@sipsolutions.net>, kernel@collabora.com, linux-mm@kvack.org,
 linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
 dmaengine@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-iio@vger.kernel.org, netdev@vger.kernel.org,
 workflows@vger.kernel.org, linux-integrity@vger.kernel.org,
 keyrings@vger.kernel.org, linux-sound@vger.kernel.org,
 linux-media@vger.kernel.org, linux-um@lists.infradead.org
Subject: Re: [PATCH] docs: Remove literal markup from Documentation/ paths
In-Reply-To: <20250404182006.000038cc@huawei.com>
References: <20250404-doc-paths-unliteral-v1-1-74718785444e@collabora.com>
 <20250404182006.000038cc@huawei.com>
Date: Fri, 04 Apr 2025 11:42:54 -0600
Message-ID: <874iz3g6w1.fsf@trenco.lwn.net>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Jonathan Cameron <Jonathan.Cameron@huawei.com> writes:

> On Fri, 04 Apr 2025 11:37:28 -0400
> N=C3=ADcolas F. R. A. Prado <nfraprado@collabora.com> wrote:
>
>> Given that the automarkup Sphinx plugin cross-references
>> "Documentation/*.rst" strings in the text to the corresponding
>> documents, surrounding those strings with the literal markup (``) not
>> only adds unnecessary markup in the source files, but actually prevents
>> the automatic cross-referencing to happen (as it doesn't happen in
>> literal blocks).
>>=20
>> Remove all the occurrences of the literal markup in
>> "Documentation/*.rst" paths, except when the actual source file is being
>> referred. Also change the surrounding text when needed so it reads well
>> both in the source and the web page (eg. 'see file Doc...' -> 'see
>> Doc...').
>>=20
>> Signed-off-by: N=C3=ADcolas F. R. A. Prado <nfraprado@collabora.com>
>> ---
>>  Documentation/admin-guide/mm/numa_memory_policy.rst       | 2 +-
>>  Documentation/admin-guide/serial-console.rst              | 2 +-
>>  Documentation/driver-api/dmaengine/client.rst             | 2 +-
>>  Documentation/driver-api/nvdimm/security.rst              | 2 +-
>>  Documentation/filesystems/fscrypt.rst                     | 4 ++--
>>  Documentation/iio/adis16475.rst                           | 4 ++--
>>  Documentation/iio/adis16480.rst                           | 4 ++--
>>  Documentation/iio/adis16550.rst                           | 4 ++--
>>  Documentation/iio/adxl380.rst                             | 4 ++--
>
> Split patch up by subsystem would be a good thing here as we may
> get other changes to these docs during the cycle and resulting
> merge conflicts if this all goes in as one patch.

That seems like a way to add a significant amount of pain to a basic
(but indeed useful) cleanup patch like this.  If the relevant
maintainers insist on it then that's how it has to be done, but I bet I
could just take the whole thing through docs with almost no trouble.

jon

