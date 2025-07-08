Return-Path: <linux-fscrypt+bounces-691-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 5338AAFD638
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Jul 2025 20:14:23 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id A889217ECDE
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Jul 2025 18:14:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 967F62E6D0A;
	Tue,  8 Jul 2025 18:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="UnZ6jutl"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6967F2E5B07;
	Tue,  8 Jul 2025 18:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751998451; cv=none; b=kDjJweInO5sISMR35euINWw0uXuVHbCLU2R8dzMWXWoFabzBejCe52lnplWM9nc8XcP9UOUgweczb2udgEzBwu+loizrjepGdO7RiufyQzv1EFe79Omd5wkfiRfbb0jbGYaUrazPX7EcUMEinrBiV26Oo3bF3WKz4LhLzqRaVY4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751998451; c=relaxed/simple;
	bh=X/6hc9CPgA+08/k2HjcML/2zRds8BD5CSrnwLokgqks=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=an+nkDE3hoaXh9k8Q3ao5qP2PaFN/XcNfdUjLyqbwt3QMQvJviVdICWL4WJ7xqv0ber8rrtppQStOMO9mAm5JuM3uO/4301rLAPoskVYAm3E1Fvs/LbcsNLQPIpjgRkbdUKI6S4pk+b7ErgRUtQHV4sOzqxonUjETC7cKUEbFO0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=UnZ6jutl; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8042C4CEF0;
	Tue,  8 Jul 2025 18:14:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751998451;
	bh=X/6hc9CPgA+08/k2HjcML/2zRds8BD5CSrnwLokgqks=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UnZ6jutldxmfSodjhbmYNtQJrWaM+vvmwFy6rBcHDyLECDm5y3E5humaGeSD5EUV4
	 tfOeLW5lNSvjtA3b075DxvbnCAGTkZQlhEcxo2FQrvEJioT4ZpvwEIgk33wejAWH98
	 9g8eSrPtpbw5tSAk5F1lbRja/12j91+sYxQuQUS9Z2/AfFQRPWiJUDtyxGWsjjkidy
	 ug/bsR+X0Q4cWiEr275Lrd30sYqpsqwLINQmmVuZetcvKUt2yXkPWZGq7wpZoBSe1p
	 hdENo7smaXB+ebXbZ4G652LA6l8b+J8NnHY2s37dvihMYQ/HEZwAWNT4qtPB+Fj8VB
	 evQGuqSQwfGPQ==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: Yuwen Chen <ywen.chen@foxmail.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/3] fscrypt: Drop FORBID_WEAK_KEYS flag for AES-ECB
Date: Tue,  8 Jul 2025 11:13:12 -0700
Message-ID: <20250708181313.66961-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708181313.66961-1-ebiggers@kernel.org>
References: <20250708181313.66961-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This flag does nothing for AES-ECB.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/crypto/keysetup_v1.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
index 3fdf174384f3d..75b0f1211a1e6 100644
--- a/fs/crypto/keysetup_v1.c
+++ b/fs/crypto/keysetup_v1.c
@@ -57,11 +57,10 @@ static int derive_key_aes(const u8 *master_key,
 	if (IS_ERR(tfm)) {
 		res = PTR_ERR(tfm);
 		tfm = NULL;
 		goto out;
 	}
-	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
 	req = skcipher_request_alloc(tfm, GFP_KERNEL);
 	if (!req) {
 		res = -ENOMEM;
 		goto out;
 	}
-- 
2.50.0


