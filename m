Return-Path: <linux-fscrypt+bounces-696-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id ACBB5AFF960
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Jul 2025 08:14:21 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 5E2671C861A3
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Jul 2025 06:13:40 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 37B4728DB48;
	Thu, 10 Jul 2025 06:10:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gooy9tEn"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFBCE28C5A1;
	Thu, 10 Jul 2025 06:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127805; cv=none; b=tJgrI3Nlu5lm4HkpO/SVy5iqTHmGvEcuFrSpRodyhY60cOupa/FH4FwuptcfHr2R6VLBTsAkXVZ4w6KXnZ3FxcTQsetChJNc+nHNdcTNnawKXBFQLK6fPC2fUUwsVvCxOR0prgDfUVazKUbKEQK3gcokD5f+nIee0kzxx6qEAHk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127805; c=relaxed/simple;
	bh=c0LblWZjHtA+pSM3OGRGzXlBbR2Gy8KHxtMN1dzIorg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W0Wfitqp6ks+4ZtoPZOAveC3YDR6rDczy6z1V9ne8E/nmu4HJNOQsWFruIK699ODY2+jxIq0R28ZtmT/mDcfbzJrmNcUTobIFCCq06Lp7Vv6IrBpUIZV1U4T2zV3fiThMykWiJxNa0MCqftNkjrW5Zb7kxzpSMj20CQyOUF4Cko=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gooy9tEn; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A372C4CEF7;
	Thu, 10 Jul 2025 06:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752127804;
	bh=c0LblWZjHtA+pSM3OGRGzXlBbR2Gy8KHxtMN1dzIorg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gooy9tEnWaUjAMYDxpZ1+MvVzB2Bl/WqS7VxX2kK5a4rhcDe9g2c9LPur896JqQGM
	 Q8pv+24fuPNDwojiVqYEnPDCe8W+zZ8gF4ASRIkhQjZQwYNCwLI6HJO80iU4dwrs2/
	 RrCsJN/+uCheB1eygag4QHchL1Nt+XDk7PBsAWzOsPTEi1xyX+fXlgU76g0Q0Q2Nyp
	 huB4eTNiObsmAuv/KSBxND1pVqKke1J6BEccZSbuMRUhdBOSVwfnXp1J3nAh3MgQ+D
	 XcWzwk1EPhFois5+o38tvnnb8kvkZPWKQ7e9n9EVqbKWweKlaNIafpN+AN3g4q9Y1L
	 a/tfsbLCWpMuw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Yuwen Chen <ywen.chen@foxmail.com>,
	linux-mtd@lists.infradead.org,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 2/6] fscrypt: Drop FORBID_WEAK_KEYS flag for AES-ECB
Date: Wed,  9 Jul 2025 23:07:49 -0700
Message-ID: <20250710060754.637098-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250710060754.637098-1-ebiggers@kernel.org>
References: <20250710060754.637098-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

This flag only has an effect for DES, 3DES, and XTS mode.  It does
nothing for AES-ECB, as there is no concept of weak keys for AES.

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
2.50.1


