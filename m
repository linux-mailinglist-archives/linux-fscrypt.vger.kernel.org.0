Return-Path: <linux-fscrypt+bounces-1534-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id kDIbMX5muGlOdQEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1534-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Mar 2026 21:22:22 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 3E1582A025F
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Mar 2026 21:22:22 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 2555C30254E1
	for <lists+linux-fscrypt@lfdr.de>; Mon, 16 Mar 2026 20:22:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A20333EE1C8;
	Mon, 16 Mar 2026 20:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="pkDskulU"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D9AB296BDC;
	Mon, 16 Mar 2026 20:22:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773692540; cv=none; b=uY6ozJXyGaTuvKUdbjjogJoM+e2ZzTt9TTZPFsZSFigUgZBxPxrLngQX/nPovGsmIVn6vcZX5HsXsZM27I4mtk/1bxDGr8wDS1IBPSELljOzKZVD2Klq16HfmtjEmyaHrPSrn3+w2UissX/a9tSAYuLnpLCiFD4OC5mboZkmOTU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773692540; c=relaxed/simple;
	bh=lunMFDLmUDZwME6Stf/cLCjqXqvBAvKS+2/nf2ou+lU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=IieE79mlNtIlYyfNW+JyuY/vaoDKIz8idukbIka0HEzICDlkib5/yVA9UlgPluLYXOMfw8Mc/5QZEaHHwEIDoZ8NEMGjsnVg4UMdggKxv9BhY4Ncky2kEXEYXozW1bA5j3pvccfLR49MUwkzIvevZLutPyNn0xcgyWd9A84oJVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=pkDskulU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CDB5BC19421;
	Mon, 16 Mar 2026 20:22:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773692540;
	bh=lunMFDLmUDZwME6Stf/cLCjqXqvBAvKS+2/nf2ou+lU=;
	h=From:To:Cc:Subject:Date:From;
	b=pkDskulUimYSgSHEr5XRuQ6Y2UyWEaEb4MET41cMDSNhkVIW2u91d+9a5w66hAthj
	 b99sEtvhucrCtqDbUF1ETKIaxX1ybhNIfjwPP2i2jOrBBGGIE0670W4IkVDqz9XIHg
	 veSX2KtUsNvSfj1MQmuO+/mqgil09m1VFDq8me6KFrPxBacoDUY72TSOc7tH7JmwoE
	 M+WqEWHwQHUyWfeVofPyA9DJJLDL7V+68Zu8X/Vg41kYXgFX/xZ5I9eh4PSLFAExpt
	 zEqjm0BNbezNK+3wdxJ2G1JDfDsI134PBmIGgeljnFvYAoz/uX4oPnmrgf7nmS31AF
	 U816hA1TfBIxQ==
From: Eric Biggers <ebiggers@kernel.org>
To: Herbert Xu <herbert@gondor.apana.org.au>,
	linux-crypto@vger.kernel.org
Cc: linux-ext4@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	Thierry Reding <thierry.reding@gmail.com>,
	Jonathan Hunter <jonathanh@nvidia.com>,
	Eric Biggers <ebiggers@kernel.org>,
	Zorro Lang <zlang@redhat.com>,
	stable@vger.kernel.org,
	Akhil R <akhilrajeev@nvidia.com>
Subject: [PATCH v2] crypto: tegra - Add missing CRYPTO_ALG_ASYNC
Date: Mon, 16 Mar 2026 13:21:19 -0700
Message-ID: <20260316202119.13934-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spamd-Result: default: False [0.84 / 15.00];
	SUSPICIOUS_RECIPS(1.50)[];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20201202];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,gmail.com,nvidia.com,kernel.org,redhat.com];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1534-lists,linux-fscrypt=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-0.999];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: 3E1582A025F
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The tegra crypto driver failed to set the CRYPTO_ALG_ASYNC on its
asynchronous algorithms, causing the crypto API to select them for users
that request only synchronous algorithms.  This causes crashes (at
least).  Fix this by adding the flag like what the other drivers do.
Also remove the unnecessary CRYPTO_ALG_TYPE_* flags, since those just
get ignored and overridden by the registration function anyway.

Reported-by: Zorro Lang <zlang@redhat.com>
Closes: https://lore.kernel.org/r/20260314080937.pghb4aa7d4je3mhh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com
Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Cc: stable@vger.kernel.org
Cc: Akhil R <akhilrajeev@nvidia.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting crypto/master.

v2: fix tegra-se-hash.c as well, and remove unnecessary type flags

 drivers/crypto/tegra/tegra-se-aes.c  | 11 ++++++----
 drivers/crypto/tegra/tegra-se-hash.c | 30 ++++++++++++++++------------
 2 files changed, 24 insertions(+), 17 deletions(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 0e07d0523291..9210cceb4b7b 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
@@ -527,11 +527,11 @@ static struct tegra_se_alg tegra_aes_algs[] = {
 			.ivsize	= AES_BLOCK_SIZE,
 			.base = {
 				.cra_name = "cbc(aes)",
 				.cra_driver_name = "cbc-aes-tegra",
 				.cra_priority = 500,
-				.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER | CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_aes_ctx),
 				.cra_alignmask = 0xf,
 				.cra_module = THIS_MODULE,
 			},
@@ -548,11 +548,11 @@ static struct tegra_se_alg tegra_aes_algs[] = {
 			.max_keysize = AES_MAX_KEY_SIZE,
 			.base = {
 				.cra_name = "ecb(aes)",
 				.cra_driver_name = "ecb-aes-tegra",
 				.cra_priority = 500,
-				.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER | CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_aes_ctx),
 				.cra_alignmask = 0xf,
 				.cra_module = THIS_MODULE,
 			},
@@ -570,11 +570,11 @@ static struct tegra_se_alg tegra_aes_algs[] = {
 			.ivsize	= AES_BLOCK_SIZE,
 			.base = {
 				.cra_name = "ctr(aes)",
 				.cra_driver_name = "ctr-aes-tegra",
 				.cra_priority = 500,
-				.cra_flags = CRYPTO_ALG_TYPE_SKCIPHER | CRYPTO_ALG_ASYNC,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = 1,
 				.cra_ctxsize = sizeof(struct tegra_aes_ctx),
 				.cra_alignmask = 0xf,
 				.cra_module = THIS_MODULE,
 			},
@@ -592,10 +592,11 @@ static struct tegra_se_alg tegra_aes_algs[] = {
 			.ivsize	= AES_BLOCK_SIZE,
 			.base = {
 				.cra_name = "xts(aes)",
 				.cra_driver_name = "xts-aes-tegra",
 				.cra_priority = 500,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_ctxsize	   = sizeof(struct tegra_aes_ctx),
 				.cra_alignmask	   = (__alignof__(u64) - 1),
 				.cra_module	   = THIS_MODULE,
 			},
@@ -1920,10 +1921,11 @@ static struct tegra_se_alg tegra_aead_algs[] = {
 			.ivsize	= GCM_AES_IV_SIZE,
 			.base = {
 				.cra_name = "gcm(aes)",
 				.cra_driver_name = "gcm-aes-tegra",
 				.cra_priority = 500,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = 1,
 				.cra_ctxsize = sizeof(struct tegra_aead_ctx),
 				.cra_alignmask = 0xf,
 				.cra_module = THIS_MODULE,
 			},
@@ -1942,10 +1944,11 @@ static struct tegra_se_alg tegra_aead_algs[] = {
 			.chunksize = AES_BLOCK_SIZE,
 			.base = {
 				.cra_name = "ccm(aes)",
 				.cra_driver_name = "ccm-aes-tegra",
 				.cra_priority = 500,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = 1,
 				.cra_ctxsize = sizeof(struct tegra_aead_ctx),
 				.cra_alignmask = 0xf,
 				.cra_module = THIS_MODULE,
 			},
@@ -1969,11 +1972,11 @@ static struct tegra_se_alg tegra_cmac_algs[] = {
 			.halg.statesize = sizeof(struct tegra_cmac_reqctx),
 			.halg.base = {
 				.cra_name = "cmac(aes)",
 				.cra_driver_name = "tegra-se-cmac",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_cmac_ctx),
 				.cra_alignmask = 0,
 				.cra_module = THIS_MODULE,
 				.cra_init = tegra_cmac_cra_init,
diff --git a/drivers/crypto/tegra/tegra-se-hash.c b/drivers/crypto/tegra/tegra-se-hash.c
index 4a298ace6e9f..06bb5bf0fa33 100644
--- a/drivers/crypto/tegra/tegra-se-hash.c
+++ b/drivers/crypto/tegra/tegra-se-hash.c
@@ -759,11 +759,11 @@ static struct tegra_se_alg tegra_hash_algs[] = {
 			.halg.statesize = sizeof(struct tegra_sha_reqctx),
 			.halg.base = {
 				.cra_name = "sha1",
 				.cra_driver_name = "tegra-se-sha1",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = SHA1_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
 				.cra_module = THIS_MODULE,
 				.cra_init = tegra_sha_cra_init,
@@ -784,11 +784,11 @@ static struct tegra_se_alg tegra_hash_algs[] = {
 			.halg.statesize = sizeof(struct tegra_sha_reqctx),
 			.halg.base = {
 				.cra_name = "sha224",
 				.cra_driver_name = "tegra-se-sha224",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
 				.cra_module = THIS_MODULE,
 				.cra_init = tegra_sha_cra_init,
@@ -809,11 +809,11 @@ static struct tegra_se_alg tegra_hash_algs[] = {
 			.halg.statesize = sizeof(struct tegra_sha_reqctx),
 			.halg.base = {
 				.cra_name = "sha256",
 				.cra_driver_name = "tegra-se-sha256",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
 				.cra_module = THIS_MODULE,
 				.cra_init = tegra_sha_cra_init,
@@ -834,11 +834,11 @@ static struct tegra_se_alg tegra_hash_algs[] = {
 			.halg.statesize = sizeof(struct tegra_sha_reqctx),
 			.halg.base = {
 				.cra_name = "sha384",
 				.cra_driver_name = "tegra-se-sha384",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
 				.cra_module = THIS_MODULE,
 				.cra_init = tegra_sha_cra_init,
@@ -859,11 +859,11 @@ static struct tegra_se_alg tegra_hash_algs[] = {
 			.halg.statesize = sizeof(struct tegra_sha_reqctx),
 			.halg.base = {
 				.cra_name = "sha512",
 				.cra_driver_name = "tegra-se-sha512",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
 				.cra_module = THIS_MODULE,
 				.cra_init = tegra_sha_cra_init,
@@ -884,11 +884,11 @@ static struct tegra_se_alg tegra_hash_algs[] = {
 			.halg.statesize = sizeof(struct tegra_sha_reqctx),
 			.halg.base = {
 				.cra_name = "sha3-224",
 				.cra_driver_name = "tegra-se-sha3-224",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = SHA3_224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
 				.cra_module = THIS_MODULE,
 				.cra_init = tegra_sha_cra_init,
@@ -909,11 +909,11 @@ static struct tegra_se_alg tegra_hash_algs[] = {
 			.halg.statesize = sizeof(struct tegra_sha_reqctx),
 			.halg.base = {
 				.cra_name = "sha3-256",
 				.cra_driver_name = "tegra-se-sha3-256",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = SHA3_256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
 				.cra_module = THIS_MODULE,
 				.cra_init = tegra_sha_cra_init,
@@ -934,11 +934,11 @@ static struct tegra_se_alg tegra_hash_algs[] = {
 			.halg.statesize = sizeof(struct tegra_sha_reqctx),
 			.halg.base = {
 				.cra_name = "sha3-384",
 				.cra_driver_name = "tegra-se-sha3-384",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = SHA3_384_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
 				.cra_module = THIS_MODULE,
 				.cra_init = tegra_sha_cra_init,
@@ -959,11 +959,11 @@ static struct tegra_se_alg tegra_hash_algs[] = {
 			.halg.statesize = sizeof(struct tegra_sha_reqctx),
 			.halg.base = {
 				.cra_name = "sha3-512",
 				.cra_driver_name = "tegra-se-sha3-512",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH,
+				.cra_flags = CRYPTO_ALG_ASYNC,
 				.cra_blocksize = SHA3_512_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
 				.cra_module = THIS_MODULE,
 				.cra_init = tegra_sha_cra_init,
@@ -986,11 +986,12 @@ static struct tegra_se_alg tegra_hash_algs[] = {
 			.halg.statesize = sizeof(struct tegra_sha_reqctx),
 			.halg.base = {
 				.cra_name = "hmac(sha224)",
 				.cra_driver_name = "tegra-se-hmac-sha224",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_NEED_FALLBACK,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA224_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
 				.cra_module = THIS_MODULE,
 				.cra_init = tegra_sha_cra_init,
@@ -1013,11 +1014,12 @@ static struct tegra_se_alg tegra_hash_algs[] = {
 			.halg.statesize = sizeof(struct tegra_sha_reqctx),
 			.halg.base = {
 				.cra_name = "hmac(sha256)",
 				.cra_driver_name = "tegra-se-hmac-sha256",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_NEED_FALLBACK,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA256_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
 				.cra_module = THIS_MODULE,
 				.cra_init = tegra_sha_cra_init,
@@ -1040,11 +1042,12 @@ static struct tegra_se_alg tegra_hash_algs[] = {
 			.halg.statesize = sizeof(struct tegra_sha_reqctx),
 			.halg.base = {
 				.cra_name = "hmac(sha384)",
 				.cra_driver_name = "tegra-se-hmac-sha384",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_NEED_FALLBACK,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA384_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
 				.cra_module = THIS_MODULE,
 				.cra_init = tegra_sha_cra_init,
@@ -1067,11 +1070,12 @@ static struct tegra_se_alg tegra_hash_algs[] = {
 			.halg.statesize = sizeof(struct tegra_sha_reqctx),
 			.halg.base = {
 				.cra_name = "hmac(sha512)",
 				.cra_driver_name = "tegra-se-hmac-sha512",
 				.cra_priority = 300,
-				.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_NEED_FALLBACK,
+				.cra_flags = CRYPTO_ALG_ASYNC |
+					     CRYPTO_ALG_NEED_FALLBACK,
 				.cra_blocksize = SHA512_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_sha_ctx),
 				.cra_alignmask = 0,
 				.cra_module = THIS_MODULE,
 				.cra_init = tegra_sha_cra_init,

base-commit: 5c52607c43c397b79a9852ce33fc61de58c3645c
-- 
2.53.0


