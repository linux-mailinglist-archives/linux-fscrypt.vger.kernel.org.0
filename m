Return-Path: <linux-fscrypt+bounces-645-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [IPv6:2604:1380:4601:e00::3])
	by mail.lfdr.de (Postfix) with ESMTPS id 05A31A7E0A1
	for <lists+linux-fscrypt@lfdr.de>; Mon,  7 Apr 2025 16:11:52 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id DEC2B189E4DB
	for <lists+linux-fscrypt@lfdr.de>; Mon,  7 Apr 2025 14:04:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 80B031C4A24;
	Mon,  7 Apr 2025 14:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b="XbK+zNlm"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from bali.collaboradmins.com (bali.collaboradmins.com [148.251.105.195])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E19B1B87CE;
	Mon,  7 Apr 2025 14:03:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=148.251.105.195
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744034619; cv=none; b=YhiusNlpa9lruvkylJeCH8j6rtlTHk6kNQ/tpTbkl+Lzu5b5BvqPIu/4kKBmZrp2n9EPVWF7nwC5glWzOuNHGE8iIc5x4CjjQ4AJ9IYUdp+LJ/urWhJFiQBNip0msw255o0YyP5cee/Zeufzr1rvMQhp4F177REfME8CAvqJ6H0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744034619; c=relaxed/simple;
	bh=LwpFHqtTF6aiM+1soPf8ma0ZkEP2mzQ1iN1O5ga09M4=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=SoKZAzSxpyXi6K/mK1ClctWGRkxEJcYn0Lqp7jtgzQMTwguD5SX9iY+eWbww8DK8bd4HZYDGeb2MemFW82XKTccC9Qwz5T0qdTBesy5+PUOROJtP2p2BaQnXuFL4cphnyPdsq9g8QvgUBHxgU5RiWlknRUe3Jdxg3tk2RDiMFGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com; spf=pass smtp.mailfrom=collabora.com; dkim=pass (2048-bit key) header.d=collabora.com header.i=@collabora.com header.b=XbK+zNlm; arc=none smtp.client-ip=148.251.105.195
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=collabora.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=collabora.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
	s=mail; t=1744034614;
	bh=LwpFHqtTF6aiM+1soPf8ma0ZkEP2mzQ1iN1O5ga09M4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=XbK+zNlmEYMyXgy9EE+nYDPMS6CNvfQvS4m8Ns622tsZ+iUYZZUmQVKBc+XlC+Ex0
	 LaVUBaVnuHyN4MmHQRM5lw75L9OtxOhDCkjuYODTe+qjTI/m5+AMTxT0Gka7jc0QE8
	 IifRhyjZZYK5QvnI+mMIhrnYhTnAo9KP5sABY5mQ6fcU6WPvsT9xj3IKWxPUaa7KsX
	 WNf9C7FVgUYYMwv/V1hMAOJBiisS+blTU874Zclxv4aFp9RB6gJyAyCkEp32WSgf2b
	 YGO6OexvWQ9aiFyaesw8sjta8FGk9hz0lRUCH2EruQhXMFQ6T/BIolXXN9TstLXeHQ
	 P+ItjRt/WHB3Q==
Received: from notapiano (unknown [70.107.117.78])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange ECDHE (prime256v1) server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: nfraprado)
	by bali.collaboradmins.com (Postfix) with ESMTPSA id D60C917E02BE;
	Mon,  7 Apr 2025 16:03:28 +0200 (CEST)
Date: Mon, 7 Apr 2025 10:03:26 -0400
From: =?utf-8?B?TsOtY29sYXMgRi4gUi4gQS4=?= Prado <nfraprado@collabora.com>
To: Akira Yokosawa <akiyks@gmail.com>
Cc: James.Bottomley@hansenpartnership.com, akpm@linux-foundation.org,
	anton.ivanov@cambridgegreys.com, corbet@lwn.net,
	davem@davemloft.net, dmaengine@vger.kernel.org, ebiggers@kernel.org,
	edumazet@google.com, horms@kernel.org, jaegeuk@kernel.org,
	jarkko@kernel.org, jic23@kernel.org, johannes@sipsolutions.net,
	kernel@collabora.com, keyrings@vger.kernel.org, kuba@kernel.org,
	lars@metafoo.de, linux-doc@vger.kernel.org,
	linux-fscrypt@vger.kernel.org, linux-iio@vger.kernel.org,
	linux-integrity@vger.kernel.org, linux-kernel@vger.kernel.org,
	linux-media@vger.kernel.org, linux-mm@kvack.org,
	linux-sound@vger.kernel.org, linux-um@lists.infradead.org,
	maxime.chevallier@bootlin.com, mchehab@kernel.org,
	netdev@vger.kernel.org, pabeni@redhat.com, perex@perex.cz,
	richard@nod.at, tiwai@suse.com, tytso@mit.edu, vkoul@kernel.org,
	workflows@vger.kernel.org, zohar@linux.ibm.com
Subject: Re: [PATCH] docs: Remove literal markup from Documentation/ paths
Message-ID: <9bc7b77b-73a7-4d6d-9187-ac452f8cad23@notapiano>
References: <20250404-doc-paths-unliteral-v1-1-74718785444e@collabora.com>
 <811c4103-08b1-4288-9a15-bd9795bc59f4@gmail.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <811c4103-08b1-4288-9a15-bd9795bc59f4@gmail.com>

On Sat, Apr 05, 2025 at 10:17:16AM +0900, Akira Yokosawa wrote:
> Hi,
> 
> Nícolas F. R. A. Prado wrote:
> > Given that the automarkup Sphinx plugin cross-references
> > "Documentation/*.rst" strings in the text to the corresponding
> > documents, surrounding those strings with the literal markup (``) not
> > only adds unnecessary markup in the source files, but actually prevents
> > the automatic cross-referencing to happen (as it doesn't happen in
> > literal blocks).
> > 
> > Remove all the occurrences of the literal markup in
> > "Documentation/*.rst" paths, except when the actual source file is being
> > referred. Also change the surrounding text when needed so it reads well
> > both in the source and the web page (eg. 'see file Doc...' -> 'see
> > Doc...').
> > 
> > Signed-off-by: Nícolas F. R. A. Prado <nfraprado@collabora.com>
> > ---
[..]
> >  
> >  2) All new ``Kconfig`` options have help text.
> >  
> > @@ -47,7 +48,7 @@ Provide documentation
> >  2) All new ``/proc`` entries are documented under ``Documentation/``
> >  
> >  3) All new kernel boot parameters are documented in
> > -   ``Documentation/admin-guide/kernel-parameters.rst``.
> > +   Documentation/admin-guide/kernel-parameters.rst.
> 
> Hmm, this item is asking "Have you documented the new params in that
> particular file?", so I don't think this change should be made.

Right, that makes sense. I'll drop this and the below change for v2.

Thanks,
Nícolas

> 
> >  
> >  4) All new module parameters are documented with ``MODULE_PARM_DESC()``
> >  
> > @@ -58,7 +59,7 @@ Provide documentation
> >     linux-api@vger.kernel.org.
> >  
> >  6) If any ioctl's are added by the patch, then also update
> > -   ``Documentation/userspace-api/ioctl/ioctl-number.rst``.
> > +   Documentation/userspace-api/ioctl/ioctl-number.rst.
> 
> Ditto.
> 
>         Thanks, Akira
> 
> >  
> >  Check your code with tools
> >  ==========================
> 

