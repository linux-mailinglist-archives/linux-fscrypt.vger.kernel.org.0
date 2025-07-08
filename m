Return-Path: <linux-fscrypt+bounces-688-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 29E97AFC4A8
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Jul 2025 09:52:15 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 9A2C63BB5D2
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Jul 2025 07:51:36 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A9B7729B8F5;
	Tue,  8 Jul 2025 07:51:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="U0cDHJnp"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from out162-62-58-211.mail.qq.com (out162-62-58-211.mail.qq.com [162.62.58.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E798229ACD4;
	Tue,  8 Jul 2025 07:51:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751961097; cv=none; b=lAfgNH+5fL77ztYGWoPFIRAyCN4p9StJgAor3dAStak84IdpgnIE4fM9Pvo91uvgxhEgbT1tMlVVUdwXj5iNXpdRSfNo6G8LH/E7ouS0AEeOjpy4UbvvPvAMmVXGe+lcglF392Iw/CyKzXuwTt/UPgU9rw4XseK23SnB1x9VNbU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751961097; c=relaxed/simple;
	bh=5dvVW3pdLho+n4XOxAaO3k26gyabZjzykXYDBqe1/kE=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=ogNh+bX01DFX/mXml/A6DyyfoIO6I+jrpJFeYVkxknobRW3FEKXHgscZzT77uyK7EySu3ewjy64gNAteW3ykIOhRxQCgC2nQYLrEI5j8FosvP6bvJObAwgd5fz2MBJaHd2yYH+gc7NIJWGDcXXLBnutGsO8GMKFVXDX/tqNR+bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=U0cDHJnp; arc=none smtp.client-ip=162.62.58.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1751961088;
	bh=ja69UZHY3ug8x60Ljsr6P2AspfvfaVgkyzqS4C9OqYs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=U0cDHJnp1ukw7nlI7hOPtIQy4B/NbeDkkUWDuiXd4m6JRgFRIl91pAFYkBHFXFk+B
	 h6LP16p/OMWiX/5rQJvSl9brpSvW/h8dq93umDt9Xd+VWyjTa4Pql29YmrnX+hhFwM
	 ZPbDCALni4O79zz+3tc8Tz0ghUQ/RFJqfANTNaSQ=
Received: from meizu-Precision-3660.meizu.com ([14.21.33.153])
	by newxmesmtplogicsvrszb16-1.qq.com (NewEsmtp) with SMTP
	id 8629B05B; Tue, 08 Jul 2025 15:33:34 +0800
X-QQ-mid: xmsmtpt1751960014tmcng8hqz
Message-ID: <tencent_8F6BAFE88DDB6EFCC8D5E81C3BCFEAEBB105@qq.com>
X-QQ-XMAILINFO: NafziRg7Bx69zREP8ImlZ7bFOVvu5pSrDUDJdJso3mb7i24tC75td0mv6SL0Yz
	 TpLlAORjRwcKpg8QZEVS9vAa3jcr4D0MKJl82pnqWVJb2ffbdCYttb8NAoNAx1+RY+lOJoVEhRyt
	 vIuO67689OnTpJ0mAphag4C7auoVrAgK39sf+UYGcOGsdTBG6GYF306Z160r3dBw4JJFn/APZTct
	 oOFE2Ui4oSz20p03LY3vIgkVnOUf6lZyfBfe2cZ9wgmz+6rSh7UX3qowFBu2ILMUf6dl6Aks69Vx
	 zN9Jhis2rSzO9jr9MQgwZ+b3/Mrl6CFYQFCSkZ4cF5vl0lEihfWkSsSW12VOjTJS/KjTCRHW4pCE
	 qHKcgLvr5kxzwBWKLRbrT+uzQg/hgLvAv5b4/nG4MJUZ4HxCvBox27aCp28pRb1GV4XfsLY9y4fW
	 U/XpFUeH9aQTd712ON94A2rracdo9wQ0uPKvbYP6MjUD+Y+x6+RkHzv619tVT/Z+qD4AEv6iT2cO
	 grzq48hq4nRShByuyYzJ4mSzwZDahzVq1iIc89foNuv4AVaK6lzrQz5bzG1cs3mZaLJp2ke2OnBY
	 nCbRv5pZbnt/C+lxQi4eFZt01SsqPhvQfv/a5AR/yVLNb7SahSJ0kQ/hN8YgGnHIFjl59JrqZn0p
	 aa+IVEUW+89q6qqWwifL9wvQ2yxqSUonpUwZcHh/3a+S34iPD94tCUTlMXlxPurikaA8h+mb65Kn
	 7ghDUZE1E9HYQpzZ3esq4q9323AdUEjj4Gc8Df+e8xtShdLlSVmxDPrxU4GS1Fkz3cN/NKhOfueW
	 0Rzr0rdCjR/IiO/6O4sN25U7VANZJDoqrMij4ZMXCLejGkLCsj3OZVywMnh3jI1HHMwA9sf/CfJ/
	 Ug3JsCZE9OeVqAEtLNcvVwCtVo6TPJK8ERtX4FrDT5vlLwTa2erLpu21ZvYdLQn/e8ax4gNN4gaM
	 lTuwdV5Jdklse9hBU8JGMPx9MaOsmFBPaAlYxxnmX10beWllS+epjENRaRV9DwsDAVO5L3SWArBX
	 rVrUiofg==
X-QQ-XMRINFO: NI4Ajvh11aEj8Xl/2s1/T8w=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: ebiggers@kernel.org
Cc: davem@davemloft.net,
	herbert@gondor.apana.org.au,
	jaegeuk@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu,
	ywen.chen@foxmail.com
Subject: [PATCH v2] fscrypt: improve filename encryption and decryption performance
Date: Tue,  8 Jul 2025 15:33:34 +0800
X-OQ-MSGID: <20250708073334.848261-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20250704051441.GA4199@sol>
References: <20250704051441.GA4199@sol>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

On Thu, 3 Jul 2025 22:14:41 -0700, Eric Biggers wrote:
> I'm guessing you have some debugging options enabled in your kconfig.  Usually
> the allocations aren't quite *that* expensive.  That being said, it's always
> been really annoying that they have to be there.

Turn off most of the debugging options and merge these two patches
for memory allocation. The performance test results are as follows:
Before this submission was merged, when creating 10000 files,
the performance test results are as follows:
$ time /data/file_creater 10000
0m10.90s real     0m00.00s user     0m10.69s system

After merge these two patches, the performance is as follows:
$ time /data/file_creater 10000
0m05.32s real     0m00.00s user     0m05.28s system

> Unfortunately, as far as I know, you actually can't just allocate the
> skcipher_request on the stack like that, since the legacy crypto API assumes
> that the request memory is DMA-able.  On-stack requests also might not be
> properly aligned (see
> https://lore.kernel.org/all/CA+55aFxJOzMim_d-O2E2yip8JWo0NdYs_72sNwFKSkTjy8q0Sw@mail.gmail.com/
> -- may be outdated, but I haven't heard otherwise).

Thank you for the reminder. This should be a problem here.
Just, why can SYNC_SKCIPHER_REQUEST_ON_STACK be allocated on
the stack? Is it possible to use ALIGN to achieve alignment?

> The problem is really that the legacy crypto API (crypto_skcipher in this case)
> was never really designed for efficient CPU-based crypto in the first place.
> The correct solution is to add simple library APIs for the algorithms to
> lib/crypto/, then update fscrypt to use that instead of crypto_skcipher.
> I plan to do that, but I'm first focusing on other related things, such as doing
> the same for fsverity.

This sounds very good. For file name decryption, due to the
relatively small amount of data, the cost of interface calls
indeed cannot be ignored. Thank you very much for your guidance.


