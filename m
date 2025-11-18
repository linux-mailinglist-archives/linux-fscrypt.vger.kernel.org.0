Return-Path: <linux-fscrypt+bounces-985-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ams.mirrors.kernel.org (ams.mirrors.kernel.org [213.196.21.55])
	by mail.lfdr.de (Postfix) with ESMTPS id 6C163C6AFB1
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Nov 2025 18:32:21 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.mirrors.kernel.org (Postfix) with ESMTPS id 7C47D3A2918
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Nov 2025 17:26:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 5CC393612E0;
	Tue, 18 Nov 2025 17:24:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b="XPVP0681"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 222673612C8;
	Tue, 18 Nov 2025 17:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763486650; cv=none; b=b22EBEyD0GfVQ3GOdm0nNz+Uzl+TaMUOOIPb6MvhMR+P+uoQuCyo5tCEp7oBRDWbDm0Sw+coyvzLXOvKz0yLIkSPumGwchA1JP6KbbIjJ3cyWAcijEa6VRMoDpSPbsg3o4yWUY9QJLR5KoGJEkLSTq3ms0KFU2T4Ki6fkfTemMs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763486650; c=relaxed/simple;
	bh=M8Z67lOaONf/tmr+4o9HrN9eRSIJ2trYjVqjqfGfxlc=;
	h=Date:From:To:Cc:Subject:Message-Id:In-Reply-To:References:
	 Mime-Version:Content-Type; b=UMe/7Ro2CQemdebY5d/AmTqtTUgaEfHgOBt2d8BcXLhGWMmEaL55ap4HiMR1KeSdPM3yK7OFVCLOxr+4Mvx04lZy+ks4dtRIIlHU/gBKdrpTj4dlmLMUkix9AJHXNxbvz/vqQ03uk4V6ORxkuRv67N1S569EWcDJ58d3LigyyM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.b=XPVP0681; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C298CC4AF0E;
	Tue, 18 Nov 2025 17:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1763486649;
	bh=M8Z67lOaONf/tmr+4o9HrN9eRSIJ2trYjVqjqfGfxlc=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=XPVP0681fm+BDVWzM0jz/sIjLLt1GdLomjG5YXAx+Zwhr1YqRHlqYk7G1Rwvp0xtt
	 j9Vl+YXUPYOuniWU8p19EsOTMVRxDU+Fs4EJWw32rsuuU6QjR5rKEpJzHsw24NDSDX
	 PNg4Tw29sMCMrztnEiDPNb3xpNN+zYplwhvCyPXk=
Date: Tue, 18 Nov 2025 09:24:05 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Andy Shevchenko <andriy.shevchenko@intel.com>
Cc: Guan-Chun Wu <409411716@gms.tku.edu.tw>, David Laight
 <david.laight.linux@gmail.com>, axboe@kernel.dk,
 ceph-devel@vger.kernel.org, ebiggers@kernel.org, hch@lst.de,
 home7438072@gmail.com, idryomov@gmail.com, jaegeuk@kernel.org,
 kbusch@kernel.org, linux-fscrypt@vger.kernel.org,
 linux-kernel@vger.kernel.org, linux-nvme@lists.infradead.org,
 sagi@grimberg.me, tytso@mit.edu, visitorckw@gmail.com, xiubli@redhat.com
Subject: Re: [PATCH v5 3/6] lib/base64: rework encode/decode for speed and
 stricter validation
Message-Id: <20251118092405.230a6acb4eea49ecc62c65bf@linux-foundation.org>
In-Reply-To: <aRxMtmatG7wbqJKL@black.igk.intel.com>
References: <20251114055829.87814-1-409411716@gms.tku.edu.tw>
	<20251114060132.89279-1-409411716@gms.tku.edu.tw>
	<20251114091830.5325eed3@pumpkin>
	<aRmnYTHmfPi1lyix@wu-Pro-E500-G6-WS720T>
	<20251117094652.b04c6cf841d6426f70f23d22@linux-foundation.org>
	<aRxMtmatG7wbqJKL@black.igk.intel.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Tue, 18 Nov 2025 11:38:46 +0100 Andy Shevchenko <andriy.shevchenko@intel.com> wrote:

> The file also needs to fix the kernel-doc
> 
> $ scripts/kernel-doc -none -v -Wall lib/base64.c
> Warning: lib/base64.c:24 This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  * Initialize the base64 reverse mapping for a single character
> Warning: lib/base64.c:36 This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  * Recursive macros to generate multiple Base64 reverse mapping table entries.
> Info: lib/base64.c:67 Scanning doc for function base64_encode
> Info: lib/base64.c:119 Scanning doc for function base64_decode

Thanks.

--- a/lib/base64.c~lib-base64-optimize-base64_decode-with-reverse-lookup-tables-fix
+++ a/lib/base64.c
@@ -21,7 +21,7 @@ static const char base64_tables[][65] =
 	[BASE64_IMAP] = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+,",
 };
 
-/**
+/*
  * Initialize the base64 reverse mapping for a single character
  * This macro maps a character to its corresponding base64 value,
  * returning -1 if the character is invalid.
@@ -33,7 +33,8 @@ static const char base64_tables[][65] =
 		: (v) >= 'a' && (v) <= 'z' ? (v) - 'a' + 26 \
 		: (v) >= '0' && (v) <= '9' ? (v) - '0' + 52 \
 		: (v) == (ch_62) ? 62 : (v) == (ch_63) ? 63 : -1
-/**
+
+/*
  * Recursive macros to generate multiple Base64 reverse mapping table entries.
  * Each macro generates a sequence of entries in the lookup table:
  * INIT_2 generates 2 entries, INIT_4 generates 4, INIT_8 generates 8, and so on up to INIT_32.
_


