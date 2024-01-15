Return-Path: <linux-fscrypt+bounces-130-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id C870A82D3D5
	for <lists+linux-fscrypt@lfdr.de>; Mon, 15 Jan 2024 06:18:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B497028170F
	for <lists+linux-fscrypt@lfdr.de>; Mon, 15 Jan 2024 05:18:20 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A5857523E;
	Mon, 15 Jan 2024 05:18:16 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail.nsr.re.kr (unknown [210.104.33.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2695A522B;
	Mon, 15 Jan 2024 05:18:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nsr.re.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nsr.re.kr
Received: from 210.104.33.70 (nsr.re.kr)
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128 bits))
	by mail.nsr.re.kr with SMTP; Mon, 15 Jan 2024 14:17:49 +0900
X-Sender: letrhee@nsr.re.kr
Received: from 192.168.155.188 ([192.168.155.188])
          by mail.nsr.re.kr (Crinity Message Backbone-7.0.1) with SMTP ID 499;
          Mon, 15 Jan 2024 14:17:43 +0900 (KST)
From: Dongsoo Lee <letrhee@nsr.re.kr>
To: 'David Laight' <David.Laight@ACULAB.COM>, 
	'Herbert Xu' <herbert@gondor.apana.org.au>, 
	"'David S. Miller'" <davem@davemloft.net>, 
	'Jens Axboe' <axboe@kernel.dk>, 'Eric Biggers' <ebiggers@kernel.org>, 
	"'Theodore Y. Ts'o'" <tytso@mit.edu>, 
	'Jaegeuk Kim' <jaegeuk@kernel.org>, 
	'Thomas Gleixner' <tglx@linutronix.de>, 
	'Ingo Molnar' <mingo@redhat.com>, 'Borislav Petkov' <bp@alien8.de>, 
	'Dave Hansen' <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"'H. Peter Anvin'" <hpa@zytor.com>
Cc: linux-crypto@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20240112022859.2384-1-letrhee@nsr.re.kr> <20240112022859.2384-6-letrhee@nsr.re.kr> <cbd8de6ff70849a98faf2fd25b065a94@AcuMS.aculab.com>
In-Reply-To: <cbd8de6ff70849a98faf2fd25b065a94@AcuMS.aculab.com>
Subject: RE: [PATCH v6 RESEND 5/5] crypto: LEA block cipher x86_64 optimization
Date: Mon, 15 Jan 2024 14:17:43 +0900
Message-ID: <000e01da4772$2b2c5360$8184fa20$@nsr.re.kr>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="utf-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Content-Language: ko
Thread-Index: AQMGEr+nvC0x82l43QjPVTp1bc6i9wFH8CyOAqmBDhmuYzLfEA==

On  Fri, 12 Jan 2024 12:59:56 +0000, David Laight =
<David.Laight@ACULAB.COM> wrote:
> From: Dongsoo Lee
>> Sent: 12 January 2024 02:29
>>
>> For the x86_64 environment, we use AVX-512F/AVX2/SSE2 instructions.
>> Since LEA uses 128-bit blocks of four 32-bit integers, for =
optimization,
>> SSE2 encrypts 4 blocks, AVX2 encrypts 4/8 blocks, and AVX-512F =
encrypts
>> 4/8/16 blocks at a time.
>>
>> Our submission provides a optimized implementation of ECB, CBC
>> decryption, CTR, and XTS cipher operation modes on x86_64 CPUs
>> supporting.
>=20
> Given you say in 0/0:
>=20
> The LEA algorithm is a lightweight block cipher that processes data =
blocks of 128-bits and has three different key lengths, each with a =
different number of rounds:
>=20
> Just how big is it ?
> Doesn't look 'lightweight' to me.
>=20
> 	David
>=20
> -
> Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, =
MK1 1PT, UK
> Registration No: 1397386 (Wales)
>=20

Firstly, it's worth mentioning that LEA is an encryption algorithm =
designed to ensure 128-bit security.

The LEA cipher provides a balance between code size and required memory, =
allowing for trade-offs with performance. The implementation of LEA that =
we have submitted is oriented towards achieving optimal performance.

While it's difficult to compare to the most recent implementations of =
cryptographic algorithms because the test is out of date, you can see =
the results of a previous FELICS test [1] that implemented LEA for a =
smaller code size.

For example, a detailed example of skipping the key schedule to reduce =
memory usage and minimize code size can be found in [2].

Thank you for your interest.

    Dongsoo Lee

[1] https://www.cryptolux.org/index.php/FELICS#Results
[2] =
https://github.com/cryptolu/FELICS/blob/master/block_ciphers/source/ciphe=
rs/LEA_128_128_v03/source/encrypt.c

