Return-Path: <linux-fscrypt+bounces-116-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9073582B990
	for <lists+linux-fscrypt@lfdr.de>; Fri, 12 Jan 2024 03:30:53 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E962E281DB2
	for <lists+linux-fscrypt@lfdr.de>; Fri, 12 Jan 2024 02:30:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6DC61F4F2;
	Fri, 12 Jan 2024 02:30:27 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail.nsr.re.kr (unknown [210.104.33.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 45AA1D285;
	Fri, 12 Jan 2024 02:30:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=nsr.re.kr
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=nsr.re.kr
Received: from 210.104.33.70 (nsr.re.kr)
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128 bits))
	by mail.nsr.re.kr with SMTP; Fri, 12 Jan 2024 11:30:08 +0900
X-Sender: letrhee@nsr.re.kr
Received: from 192.168.155.188 ([192.168.155.188])
          by mail.nsr.re.kr (Crinity Message Backbone-7.0.1) with SMTP ID 155;
          Fri, 12 Jan 2024 11:30:03 +0900 (KST)
From: Dongsoo Lee <letrhee@nsr.re.kr>
To: Herbert Xu <herbert@gondor.apana.org.au>, 
	"David S. Miller" <davem@davemloft.net>, 
	Jens Axboe <axboe@kernel.dk>, Eric Biggers <ebiggers@kernel.org>, 
	"Theodore Y. Ts'o" <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>, 
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>, 
	Borislav Petkov <bp@alien8.de>, 
	Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org, 
	"H. Peter Anvin" <hpa@zytor.com>
Cc: linux-crypto@vger.kernel.org, linux-block@vger.kernel.org, 
	linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org, 
	Dongsoo Lee <letrhee@nsr.re.kr>
Subject: [PATCH v6 RESEND 3/5] blk-crypto: Add LEA-256-XTS blk-crypto support
Date: Fri, 12 Jan 2024 02:28:57 +0000
Message-Id: <20240112022859.2384-4-letrhee@nsr.re.kr>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20240112022859.2384-1-letrhee@nsr.re.kr>
References: <20240112022859.2384-1-letrhee@nsr.re.kr>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Add LEA-256-XTS blk-crypto support

LEA is a 128-bit block cipher developed by South Korea.

LEA is a Korean national standard (KS X 3246) and included in the
ISO/IEC 29192-2:2019 standard (Information security - Lightweight
cryptography - Part 2: Block ciphers).

Enable the LEA to be used in block inline encryption. This can be
used via blk-crypto-fallback, when using the "inlinecrypt" mount
option in fscrypt.

Signed-off-by: Dongsoo Lee <letrhee@nsr.re.kr>
---
 block/blk-crypto.c         | 6 ++++++
 include/linux/blk-crypto.h | 1 +
 2 files changed, 7 insertions(+)

diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 4d760b092deb..b847706bbc59 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -43,6 +43,12 @@ const struct blk_crypto_mode blk_crypto_modes[] = {
 		.keysize = 32,
 		.ivsize = 16,
 	},
+	[BLK_ENCRYPTION_MODE_LEA_256_XTS] = {
+		.name = "LEA-256-XTS",
+		.cipher_str = "xts(lea)",
+		.keysize = 64,
+		.ivsize = 16,
+	},
 };
 
 /*
diff --git a/include/linux/blk-crypto.h b/include/linux/blk-crypto.h
index 5e5822c18ee4..b6bf2a5c58ed 100644
--- a/include/linux/blk-crypto.h
+++ b/include/linux/blk-crypto.h
@@ -14,6 +14,7 @@ enum blk_crypto_mode_num {
 	BLK_ENCRYPTION_MODE_AES_128_CBC_ESSIV,
 	BLK_ENCRYPTION_MODE_ADIANTUM,
 	BLK_ENCRYPTION_MODE_SM4_XTS,
+	BLK_ENCRYPTION_MODE_LEA_256_XTS,
 	BLK_ENCRYPTION_MODE_MAX,
 };
 
-- 
2.40.1

