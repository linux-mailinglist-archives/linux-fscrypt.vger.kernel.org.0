Return-Path: <linux-fscrypt+bounces-92-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [147.75.48.161])
	by mail.lfdr.de (Postfix) with ESMTPS id 1606081676C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 18 Dec 2023 08:33:41 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id AD24EB210E9
	for <lists+linux-fscrypt@lfdr.de>; Mon, 18 Dec 2023 07:33:38 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4177B8473;
	Mon, 18 Dec 2023 07:33:30 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail.nsr.re.kr (unknown [210.104.33.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4540179EE;
	Mon, 18 Dec 2023 07:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nsr.re.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nsr.re.kr
Received: from 210.104.33.70 (nsr.re.kr)
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128 bits))
	by mail.nsr.re.kr with SMTP; Mon, 18 Dec 2023 16:33:09 +0900
X-Sender: letrhee@nsr.re.kr
Received: from 192.168.155.188 ([192.168.155.188])
          by mail.nsr.re.kr (Crinity Message Backbone-7.0.1) with SMTP ID 291;
          Mon, 18 Dec 2023 16:33:05 +0900 (KST)
From: Dongsoo Lee <letrhee@nsr.re.kr>
To: 'Herbert Xu' <herbert@gondor.apana.org.au>, 
	"'David S. Miller'" <davem@davemloft.net>, 
	'Jens Axboe' <axboe@kernel.dk>, 'Eric Biggers' <ebiggers@kernel.org>, 
	"'Theodore Y. Ts'o'" <tytso@mit.edu>, 
	'Jaegeuk Kim' <jaegeuk@kernel.org>, 
	'Thomas Gleixner' <tglx@linutronix.de>, 
	'Ingo Molnar' <mingo@redhat.com>, 'Borislav Petkov' <bp@alien8.de>, 
	'Dave Hansen' <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"'H. Peter Anvin'" <hpa@zytor.com>, 
	'Dongsoo Lee' <letrhee@nsr.re.kr>
Cc: linux-crypto@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20231205010329.21996-1-letrehee@nsr.re.kr>
In-Reply-To: <20231205010329.21996-1-letrehee@nsr.re.kr>
Subject: RE: [PATCH v6 0/5] crypto: LEA block cipher implementation
Date: Mon, 18 Dec 2023 16:33:01 +0900
Message-ID: <004701da3184$6e090560$4a1b1020$@nsr.re.kr>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Mailer: Microsoft Outlook 16.0
Thread-Index: AQKQdsWb5UD+xQlqqHr8cbxlcEv/nK9CGvZQ
Content-Language: ko

(Resend mail because of an error)
Hello,

I'm checking in on the status of the patch submitted to the Linux kernel =
group. I understand the review process takes time, and we appreciate =
your team's efforts.

While awaiting review, is there anything specific we can do to enhance =
the patch's acceptance chances? Your guidance would be greatly =
appreciated.

Thank you,
Dongsoo Lee

