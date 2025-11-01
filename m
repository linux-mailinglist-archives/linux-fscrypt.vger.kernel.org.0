Return-Path: <linux-fscrypt+bounces-899-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from dfw.mirrors.kernel.org (dfw.mirrors.kernel.org [142.0.200.124])
	by mail.lfdr.de (Postfix) with ESMTPS id 5F146C2776B
	for <lists+linux-fscrypt@lfdr.de>; Sat, 01 Nov 2025 05:09:54 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by dfw.mirrors.kernel.org (Postfix) with ESMTPS id 0B93B4E15DB
	for <lists+linux-fscrypt@lfdr.de>; Sat,  1 Nov 2025 04:09:53 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D621272E6E;
	Sat,  1 Nov 2025 04:09:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="BUybZAkr"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C422B2727FE;
	Sat,  1 Nov 2025 04:09:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761970190; cv=none; b=PLwKbyCrt6o5wXSjnZ587PTVIdqt7r7/K2soS/qN0G9AJlZ8HcChedClO2+Z4NY7qQ8KMsOb/ErHlvwjVwTiua/VT4FbsHoPZ9ZTc7yicTP0JYWux3EHlfIBpgrjrl+7UoSYmidwlkefTOZYgThYSzm2BGKsGfK/W4kVfpfWr8k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761970190; c=relaxed/simple;
	bh=vIzIpGr+Y0KCqjEMshY9/Fa+K5rSJIBw2Btho9NZx94=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=JVwCu9i8eC/+iYPYmn0x3vEiE2bO09I1JUvusROXGhuRy4JKuZ81+ISc2/iXouy7EsNcsz4uV1ASVqjBRsF01Yfue1RTrLYqNweOkEBkMvQOjSEN5BHCwftwClq5awcV2AWD78wSq+/mphy0FPDdw88TXUmVHV8Z3TZIHJ+GDcc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=BUybZAkr; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB93EC4CEF1;
	Sat,  1 Nov 2025 04:09:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1761970189;
	bh=vIzIpGr+Y0KCqjEMshY9/Fa+K5rSJIBw2Btho9NZx94=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=BUybZAkrmZfEv7OYCM/DQB6sLpaells0D9RK8FedH5j5ONj6Zc5Wf7hVGuEMiJ2sp
	 /4HBi8fOxSJ0Oc20nFFr/ao8OIzmN2b/2KTE4JE3Yfp+OaWrfx/t5tmQrw/tYlJU+H
	 8+6CzSZTVaoSPbpAL8gNFj2ZcLurm3NnLnIIzKBI=
Date: Fri, 31 Oct 2025 21:09:47 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Guan-Chun Wu <409411716@gms.tku.edu.tw>
Cc: ebiggers@kernel.org, tytso@mit.edu, jaegeuk@kernel.org,
 xiubli@redhat.com, idryomov@gmail.com, kbusch@kernel.org, axboe@kernel.dk,
 hch@lst.de, sagi@grimberg.me, visitorckw@gmail.com, home7438072@gmail.com,
 linux-nvme@lists.infradead.org, linux-fscrypt@vger.kernel.org,
 ceph-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/6] lib/base64: add generic encoder/decoder, migrate
 users
Message-Id: <20251031210947.1d2b028da88ef526aebd890d@linux-foundation.org>
In-Reply-To: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
References: <20251029101725.541758-1-409411716@gms.tku.edu.tw>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Wed, 29 Oct 2025 18:17:25 +0800 Guan-Chun Wu <409411716@gms.tku.edu.tw> wrote:

> This series introduces a generic Base64 encoder/decoder to the kernel
> library, eliminating duplicated implementations and delivering significant
> performance improvements.
> 
> The Base64 API has been extended to support multiple variants (Standard,
> URL-safe, and IMAP) as defined in RFC 4648 and RFC 3501. The API now takes
> a variant parameter and an option to control padding. As part of this
> series, users are migrated to the new interface while preserving their
> specific formats: fscrypt now uses BASE64_URLSAFE, Ceph uses BASE64_IMAP,
> and NVMe is updated to BASE64_STD.
> 
> On the encoder side, the implementation processes input in 3-byte blocks,
> mapping 24 bits directly to 4 output symbols. This avoids bit-by-bit
> streaming and reduces loop overhead, achieving about a 2.7x speedup compared
> to previous implementations.
> 
> On the decoder side, replace strchr() lookups with per-variant reverse tables
> and process input in 4-character groups. Each group is mapped to numeric values
> and combined into 3 bytes. Padded and unpadded forms are validated explicitly,
> rejecting invalid '=' usage and enforcing tail rules.

Looks like wonderful work, thanks.  And it's good to gain a selftest
for this code.

> This improves throughput by ~43-52x.

Well that isn't a thing we see every day.

: Decode:
:   64B   ~1530ns  ->  ~80ns    (~19.1x)
:   1KB  ~27726ns  -> ~1239ns   (~22.4x)


: Encode:
:   64B   ~90ns   -> ~32ns   (~2.8x)
:   1KB  ~1332ns  -> ~510ns  (~2.6x)
: 
: Decode:
:   64B  ~1530ns  -> ~35ns   (~43.7x)
:   1KB ~27726ns  -> ~530ns  (~52.3x)


: This change also improves performance: encoding is about 2.7x faster and
: decoding achieves 43-52x speedups compared to the previous implementation.

: This change also improves performance: encoding is about 2.7x faster and
: decoding achieves 43-52x speedups compared to the previous local
: implementation.


Do any of these callers spend a sufficient amount of time in this
encoder/decoder for the above improvements to be observable/useful?


I'll add the series to mm.git's mm-nonmm-unstable branch to give it
linux-next exposure.  I ask the NVMe, ceph and fscrypt teams to check
the code and give it a test in the next few weeks, thanks.  


