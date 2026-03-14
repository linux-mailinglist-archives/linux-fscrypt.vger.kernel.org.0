Return-Path: <linux-fscrypt+bounces-1530-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id GPwuDSKTtWnL2AAAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1530-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 Mar 2026 17:56:02 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 6F8DF28DFC9
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 Mar 2026 17:56:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id F23CB301725C
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 Mar 2026 16:55:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2CA1315785;
	Sat, 14 Mar 2026 16:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ANCrx5T8"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CA87F507;
	Sat, 14 Mar 2026 16:55:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773507358; cv=none; b=LERT/5f1k4wrjD0Ep3PnuKdioYfqj13hhCFiydn8w6KLjkAf+ncj/B9q07cmRuQw0bg/z/W7oqxs/e6geDSFHX1+PtwMbZadiID4W0P8IHyxlQY+FWMHIjoMaWpbM3QrTQLZJzsAQApqLHbkToF33CCK6rqQ8CN8uZN/HEn0tKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773507358; c=relaxed/simple;
	bh=OU2kqLqL46R/whoj7/DBKG1N2KxHrjeHH683kSBKUxc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=I3DusJEh5h9Mbll00Kz7CgBl+L71wrSujgytCHgU7eB/bL6fe1FfnwUkevMZIeF5lu969N0aSv0Mc1qUSvV4xXKkdPjCMhgQJ3CxvwPHfMjRWKJKJ6FF3l5Kwtw/azvABAIMoTTOtmHWoRjL4xgiC1kbjUK8ny/LWqyAlDDJWeI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ANCrx5T8; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B3DEC116C6;
	Sat, 14 Mar 2026 16:55:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773507358;
	bh=OU2kqLqL46R/whoj7/DBKG1N2KxHrjeHH683kSBKUxc=;
	h=From:To:Cc:Subject:Date:From;
	b=ANCrx5T8MufQXBY2woTDqlBfXgvZxyD4i8MsnPhrQbASPKjywtvZZf1V5ypMLAUea
	 QqGV/V6TLoGZOg/ggr12tsQHYqT3cdG/qtNVoMAMO50rs6sGQmhFdiNyGv6an86Nyt
	 rvkFyrExlBnH3DEuZ3vXdIjuAV5sDKeiLoj7gqJi/Txj41xD7vfsu98iL0JphdxzGD
	 ncLLym8LTgk4r3SGHofa7hi+JIsn8/MXvda4liTXY4bAG2/FdLQQQxrBHmNjz4rfDq
	 cMamCoInZHj1hlRnHB7JFJjDhIzaERoweMZJC2ENy4aHn6jYGAwjHekHI8x1lUWue8
	 h973Gw5UNoImA==
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
Subject: [PATCH] crypto: tegra - Add missing CRYPTO_ALG_ASYNC
Date: Sat, 14 Mar 2026 09:55:15 -0700
Message-ID: <20260314165515.9678-1-ebiggers@kernel.org>
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
	TAGGED_FROM(0.00)[bounces-1530-lists,linux-fscrypt=lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	NEURAL_HAM(-0.00)[-1.000];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	RCPT_COUNT_SEVEN(0.00)[10];
	TO_DN_SOME(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,nvidia.com:email]
X-Rspamd-Queue-Id: 6F8DF28DFC9
X-Rspamd-Action: no action
X-Rspamd-Server: lfdr

The tegra crypto driver failed to set the CRYPTO_ALG_ASYNC on its
asynchronous algorithms, causing the crypto API to select them for users
that request only synchronous algorithms.  This causes crashes (at
least).  Fix this by adding the flag like what the other drivers do.

Reported-by: Zorro Lang <zlang@redhat.com>
Closes: https://lore.kernel.org/r/20260314080937.pghb4aa7d4je3mhh@dell-per750-06-vm-08.rhts.eng.pek2.redhat.com
Fixes: 0880bb3b00c8 ("crypto: tegra - Add Tegra Security Engine driver")
Cc: stable@vger.kernel.org
Cc: Akhil R <akhilrajeev@nvidia.com>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---

This patch is targeting crypto/master

 drivers/crypto/tegra/tegra-se-aes.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/crypto/tegra/tegra-se-aes.c b/drivers/crypto/tegra/tegra-se-aes.c
index 0e07d0523291a..cb97a59084519 100644
--- a/drivers/crypto/tegra/tegra-se-aes.c
+++ b/drivers/crypto/tegra/tegra-se-aes.c
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
+				.cra_flags = CRYPTO_ALG_TYPE_AHASH | CRYPTO_ALG_ASYNC,
 				.cra_blocksize = AES_BLOCK_SIZE,
 				.cra_ctxsize = sizeof(struct tegra_cmac_ctx),
 				.cra_alignmask = 0,
 				.cra_module = THIS_MODULE,
 				.cra_init = tegra_cmac_cra_init,

base-commit: 1c9982b4961334c1edb0745a04cabd34bc2de675
-- 
2.53.0


