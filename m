Return-Path: <linux-fscrypt+bounces-119-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id CD7D382C048
	for <lists+linux-fscrypt@lfdr.de>; Fri, 12 Jan 2024 14:00:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 830ED1F228D5
	for <lists+linux-fscrypt@lfdr.de>; Fri, 12 Jan 2024 13:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2BA356BB26;
	Fri, 12 Jan 2024 13:00:19 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from eu-smtp-delivery-151.mimecast.com (eu-smtp-delivery-151.mimecast.com [185.58.86.151])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 965536BB35
	for <linux-fscrypt@vger.kernel.org>; Fri, 12 Jan 2024 13:00:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=ACULAB.COM
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=aculab.com
Received: from AcuMS.aculab.com (156.67.243.121 [156.67.243.121]) by
 relay.mimecast.com with ESMTP with both STARTTLS and AUTH (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 uk-mta-107-MotGPF6GOuKC6jFoeEgFUA-1; Fri, 12 Jan 2024 13:00:14 +0000
X-MC-Unique: MotGPF6GOuKC6jFoeEgFUA-1
Received: from AcuMS.Aculab.com (10.202.163.4) by AcuMS.aculab.com
 (10.202.163.4) with Microsoft SMTP Server (TLS) id 15.0.1497.48; Fri, 12 Jan
 2024 12:59:56 +0000
Received: from AcuMS.Aculab.com ([::1]) by AcuMS.aculab.com ([::1]) with mapi
 id 15.00.1497.048; Fri, 12 Jan 2024 12:59:56 +0000
From: David Laight <David.Laight@ACULAB.COM>
To: 'Dongsoo Lee' <letrhee@nsr.re.kr>, Herbert Xu
	<herbert@gondor.apana.org.au>, "David S. Miller" <davem@davemloft.net>, "Jens
 Axboe" <axboe@kernel.dk>, Eric Biggers <ebiggers@kernel.org>, "Theodore Y.
 Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, Thomas Gleixner
	<tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, Borislav Petkov
	<bp@alien8.de>, Dave Hansen <dave.hansen@linux.intel.com>, "x86@kernel.org"
	<x86@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>
CC: "linux-crypto@vger.kernel.org" <linux-crypto@vger.kernel.org>,
	"linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
	"linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
	"linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH v6 RESEND 5/5] crypto: LEA block cipher x86_64
 optimization
Thread-Topic: [PATCH v6 RESEND 5/5] crypto: LEA block cipher x86_64
 optimization
Thread-Index: AQHaRP97Qv3M1SIfYkW1atonfzlDU7DWJB2Q
Date: Fri, 12 Jan 2024 12:59:56 +0000
Message-ID: <cbd8de6ff70849a98faf2fd25b065a94@AcuMS.aculab.com>
References: <20240112022859.2384-1-letrhee@nsr.re.kr>
 <20240112022859.2384-6-letrhee@nsr.re.kr>
In-Reply-To: <20240112022859.2384-6-letrhee@nsr.re.kr>
Accept-Language: en-GB, en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Mimecast-Spam-Score: 0
X-Mimecast-Originator: aculab.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable

From: Dongsoo Lee
> Sent: 12 January 2024 02:29
>=20
> For the x86_64 environment, we use AVX-512F/AVX2/SSE2 instructions.
> Since LEA uses 128-bit blocks of four 32-bit integers, for optimization,
> SSE2 encrypts 4 blocks, AVX2 encrypts 4/8 blocks, and AVX-512F encrypts
> 4/8/16 blocks at a time.
>=20
> Our submission provides a optimized implementation of ECB, CBC
> decryption, CTR, and XTS cipher operation modes on x86_64 CPUs
> supporting.

Given you say in 0/0:

The LEA algorithm is a lightweight block cipher that processes data blocks =
of 128-bits and has three different key lengths, each with a different numb=
er of rounds:

Just how big is it ?
Doesn't look 'lightweight' to me.

=09David

-
Registered Address Lakeside, Bramley Road, Mount Farm, Milton Keynes, MK1 1=
PT, UK
Registration No: 1397386 (Wales)


