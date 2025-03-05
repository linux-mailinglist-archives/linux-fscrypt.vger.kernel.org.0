Return-Path: <linux-fscrypt+bounces-627-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 69CCBA4FA2D
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 Mar 2025 10:34:07 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id AF1843A970B
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 Mar 2025 09:33:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3C4E41C84D7;
	Wed,  5 Mar 2025 09:34:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="KKTub0uv"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94858204859
	for <linux-fscrypt@vger.kernel.org>; Wed,  5 Mar 2025 09:34:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741167244; cv=none; b=eyBOmZrJY6Fs4BxauKZrps+lMoHsjwBmLEsrGK6xA4On+2Gv2zbmZOhJr58i8SVL+2MG5cSSSg6CogshV2cqQu+0uIoMjNUjNnprsjUhnGOYX6M+4pJSBFHYMSCes+x1NWS+UVj3enl3R9ZHNHDvCYU81/JtzR9msGiNm62Eyio=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741167244; c=relaxed/simple;
	bh=L0AVZyspqDFndAdjg41HMPg3gZ/8rwatGh9EIkQ94p4=;
	h=From:In-Reply-To:References:To:Cc:Subject:MIME-Version:
	 Content-Type:Date:Message-ID; b=ETIokQCNTfIbHGTgIY1wmRHHwbxhnI6dcXNKOkY5pdi0/I6/fLb+8iW3FsqA+A7viTPlC1GjLshjM+bkT9VIrZeJF41PupqeM/TGWMmZ4r76sTTGofeMNHQg3f5moGhSLguHGOrWfjoYeDSiQs4ifYE25RFU0JPtDbLIu+i/RSA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=KKTub0uv; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1741167241;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Is3lm+EMgLSmZ5dlkslbusgfnXkzG7ZEELUtVKrYZwk=;
	b=KKTub0uvBlnnh89LAbQr/4pHkRXcu8luq8AnyNVRmaSPhNimcAb1Kbf8WP9wOuzUTYu8HN
	2CqakB7hwKro/z5M5W9FSlgYl/7DSXyfdqb8aubQf2dxcQvCr9h+oYgjhChIob8U2sSz0A
	F5GzVNEACilPhhiqGBSzDgqX1RnlPBE=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-647-LDYQevm7NHKHQCpZQRvj7w-1; Wed,
 05 Mar 2025 04:33:43 -0500
X-MC-Unique: LDYQevm7NHKHQCpZQRvj7w-1
X-Mimecast-MFC-AGG-ID: LDYQevm7NHKHQCpZQRvj7w_1741167221
Received: from mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.4])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 9C48D18001D8;
	Wed,  5 Mar 2025 09:33:40 +0000 (UTC)
Received: from warthog.procyon.org.uk (unknown [10.44.32.200])
	by mx-prod-int-01.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id DF1F03000708;
	Wed,  5 Mar 2025 09:33:37 +0000 (UTC)
Organization: Red Hat UK Ltd. Registered Address: Red Hat UK Ltd, Amberley
	Place, 107-111 Peascod Street, Windsor, Berkshire, SI4 1TE, United
	Kingdom.
	Registered in England and Wales under Company Registration No. 3798903
From: David Howells <dhowells@redhat.com>
In-Reply-To: <20250305022353.GB20133@sol.localdomain>
References: <20250305022353.GB20133@sol.localdomain> <3324492.1740742954@warthog.procyon.org.uk>
To: Eric Biggers <ebiggers@kernel.org>
Cc: dhowells@redhat.com, afs3-standardization@openafs.org,
    jaltman@auristor.com, openafs-devel@openafs.org,
    linux-afs@lists.infradead.org, linux-fscrypt@vger.kernel.org
Subject: Re: RFE: Support for client-side content encryption in AFS
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-ID: <4114837.1741167216.1@warthog.procyon.org.uk>
Content-Transfer-Encoding: quoted-printable
Date: Wed, 05 Mar 2025 09:33:36 +0000
Message-ID: <4114838.1741167216@warthog.procyon.org.uk>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.4

Eric Biggers <ebiggers@kernel.org> wrote:

> First, CephFS already supports fscrypt.  Have you looked at how it works=
 and
> solves some of these issues?

Yes.  I've been looking into it very deeply:

https://web.git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs.git/=
log/?h=3Dceph-iter

I'm not sure which issues you're referring to specifically that you think =
ceph
might have a usable solution, but note that Ceph has the ability to store
extra data, such as the "sparse map" that AFS doesn't have, unfortunately.
It's not easy to extend AFS because the volume transfer protocol/backup
protocol would need to change.

And with regard to filename encryption, the traditional AFS directory form=
at
has a limit on the maximum directory size, so increasing the size of filen=
ames
by a third would be a problem.

> Second, per-block keys would be really inefficient and are unnecessary. =
 The
> way that fscrypt works is that the keys are (usually) per-file, and with=
in
> each file each block has a different IV (initialization vector).  That i=
s
> sufficient to make each block be encrypted differently.

Okay.  Sounds good.

David


