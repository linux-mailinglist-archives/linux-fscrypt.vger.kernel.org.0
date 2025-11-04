Return-Path: <linux-fscrypt+bounces-909-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id BEF90C2EBE8
	for <lists+linux-fscrypt@lfdr.de>; Tue, 04 Nov 2025 02:27:43 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 6B76534A782
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Nov 2025 01:27:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37BBF21ADA4;
	Tue,  4 Nov 2025 01:27:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="myPtxvnV"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE6122080C8;
	Tue,  4 Nov 2025 01:27:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762219661; cv=none; b=RiunB6dRzgFym3t7k5OYDMFT11P0kl0WhQG/slZRc44Pflu846qpDC3x3V3wRJEMOdi5Tn6IhkJeRVCh/+HkAxgGVJQ2X8R9IZTfzcDpP8cwI14qrJRjHEL7w9LHhiHz73nSPR5+xfvDcql2KJ1w6J0Cd9wue8fDuzWiYUqzS10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762219661; c=relaxed/simple;
	bh=OBTXv9sNR5YE3ZrQg2Ok9Boxfphznq9WB09Dl25csUc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=r8Er/Pr3bBbdwWsSI8UwubFmcPRZb591uqtofbplfbcqIbt1OEprBERvheK0O+sT1vRzLyu0ukHXI+uD93eYYa6yJYjZrFTzKPJUwTYnF6DQ/sLninj8GyRZmkstF7XHnzIU8hDVm1bCqhGZznzf4WKyLO6ehOUwDpJ92+q5PUY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=myPtxvnV; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2792C4CEE7;
	Tue,  4 Nov 2025 01:27:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1762219660;
	bh=OBTXv9sNR5YE3ZrQg2Ok9Boxfphznq9WB09Dl25csUc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=myPtxvnVpICK7vrRuydsQ0M733OeIQ4X9R3HHeA0alAcha1Tw8A9Mr06Z4GYQZKML
	 koZpo5jia5k4L6keArTMzzBtcPq2FpIED9hrAWLw+8lVIfCtrgF3i/MUiD3sT/wJcN
	 +jNJy1NVe/RrQpxhmPRRC0QObtkzYqzBxLlAnqqE=
Date: Mon, 3 Nov 2025 17:27:39 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Kuan-Wei Chiu <visitorckw@gmail.com>
Cc: Andy Shevchenko <andriy.shevchenko@intel.com>, David Laight
 <david.laight.linux@gmail.com>, Guan-Chun Wu <409411716@gms.tku.edu.tw>,
 ebiggers@kernel.org, tytso@mit.edu, jaegeuk@kernel.org, xiubli@redhat.com,
 idryomov@gmail.com, kbusch@kernel.org, axboe@kernel.dk, hch@lst.de,
 sagi@grimberg.me, home7438072@gmail.com, linux-nvme@lists.infradead.org,
 linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
 linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] lib/base64: add generic encoder/decoder, migrate
 users
Message-Id: <20251103172739.fd799d3df4edc014429babc5@linux-foundation.org>
In-Reply-To: <aQiM7OWWM0dXTT0J@google.com>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
	<20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
	<aQiC4zrtXobieAUm@black.igk.intel.com>
	<aQiM7OWWM0dXTT0J@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Mon, 3 Nov 2025 19:07:24 +0800 Kuan-Wei Chiu <visitorckw@gmail.com> wrote:

> Since I believe many people test and care about W=1 builds, I think we
> need to find another way to avoid this warning? Perhaps we could
> consider what you suggested:

I'll drop the v4 series from mm.git, thanks.

