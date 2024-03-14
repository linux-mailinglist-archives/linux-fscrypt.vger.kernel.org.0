Return-Path: <linux-fscrypt+bounces-255-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id E066987B6FF
	for <lists+linux-fscrypt@lfdr.de>; Thu, 14 Mar 2024 05:00:42 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 17B7A1C2135B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 14 Mar 2024 04:00:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6C8F4C13B;
	Thu, 14 Mar 2024 04:00:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b="WTRFixv5"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from buxtehude.debian.org (buxtehude.debian.org [209.87.16.39])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95442C129
	for <linux-fscrypt@vger.kernel.org>; Thu, 14 Mar 2024 04:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.87.16.39
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710388838; cv=none; b=aPdHRCHaPqvfXP3gGIbcYuGqyP7JFISWBKJieTsdUenF1+tvOjv1jJV8mCB7J5IbL/oOiVfpQExgpgBZVeUKq8C1AiNUEy7ZDGCoPsuLpZTk5iliozk6hchHBxnD0MDlIY5rpQiOs40xaBw7AkZnkPSnNUjtKCkkdYtZwuvnWrs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710388838; c=relaxed/simple;
	bh=Hxnb+7r6FOD5UJhB6BXPqkFvFxpWLQUU4xbBSd37m4E=;
	h=Content-Disposition:MIME-Version:Content-Type:From:To:Subject:
	 Message-ID:References:Date; b=ZnJeT3rVLmjKXGWVC5PbH5tmu/51kEVso0L6RboU1Q9qk8QzKEH5uSuLZF263tKz8szZZAHqRR2uTrZkje2JeXU8pZu0ulIpZ9Ot9GxcXmBm107UQQJOKPAreCiu+wK4/I+UnFPPR8F6GXm7F2pxt7zwmieoO7D2JhzBbjt0x7w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org; spf=none smtp.mailfrom=buxtehude.debian.org; dkim=pass (2048-bit key) header.d=bugs.debian.org header.i=@bugs.debian.org header.b=WTRFixv5; arc=none smtp.client-ip=209.87.16.39
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=bugs.debian.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=buxtehude.debian.org
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=bugs.debian.org; s=smtpauto.buxtehude; h=Date:Reply-To:References:
	Message-ID:Subject:To:From:Content-Type:MIME-Version:
	Content-Transfer-Encoding:Cc:Content-ID:Content-Description:In-Reply-To;
	bh=Hxnb+7r6FOD5UJhB6BXPqkFvFxpWLQUU4xbBSd37m4E=; b=WTRFixv520XhfC236HQXZwyvWd
	EJV2FJypxck+5qoU+nOk5UqghscvCnu3ZwC/DndkpcbVFiP1J3dVG0nREpFffb2gW0SxGi/GW4mpr
	KNCKN/upa0L5Uq/CXH0yR6ya8Dt+o6tn0T2+2l2PhPft80v1pRA+uNiKt/HwLd7WzTAcxDJHM3Xwf
	QhabmEBXzdhKTx7WciVAarT/9Bam/ndqhALehwFw+HQwOIBapJ6ZRM6nn2LHjwGjHRSYlWZ7dy7jQ
	m0Z0pqwdFiTVc04Su6MNeotLobSIFwuYqu2xetT1Av3odWyrmpICOumqhqXWzaV1NUzXwrKG9VX4C
	C+5bTB3g==;
Received: from debbugs by buxtehude.debian.org with local (Exim 4.94.2)
	(envelope-from <debbugs@buxtehude.debian.org>)
	id 1rkbq4-009NcN-5n; Thu, 14 Mar 2024 03:33:04 +0000
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mailer: MIME-tools 5.509 (Entity 5.509)
Content-Type: text/plain; charset=utf-8
X-Loop: owner@bugs.debian.org
From: "Debian Bug Tracking System" <owner@bugs.debian.org>
To: 1066832@bugs.debian.org, 1066832-submitter@bugs.debian.org,
 linux-fscrypt@vger.kernel.org
Subject: Bug#1066832: Info received (Debian #1066832: [fsverity-utils]
 hard Build-Depends on unportable package pandoc)
Message-ID: <handler.1066832.B1066832.17103869452234129.ackinfo@bugs.debian.org>
References: <Pine.BSM.4.64L.2403140311320.10945@herc.mirbsd.org>
X-Debian-PR-Message: ack-info 1066832
X-Debian-PR-Package: src:fsverity-utils
X-Debian-PR-Source: fsverity-utils
Reply-To: 1066832@bugs.debian.org
Date: Thu, 14 Mar 2024 03:33:04 +0000

Thank you for the additional information you have supplied regarding
this Bug report.

This is an automatically generated reply to let you know your message
has been received.

Your message is being forwarded to the package maintainers and other
interested parties for their attention; they will reply in due course.

Your message has been sent to the package maintainer(s):
 Romain Perier <romain.perier@gmail.com>

If you wish to submit further information on this problem, please
send it to 1066832@bugs.debian.org.

Please do not send mail to owner@bugs.debian.org unless you wish
to report a problem with the Bug-tracking system.

--=20
1066832: https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=3D1066832
Debian Bug Tracking System
Contact owner@bugs.debian.org with problems

