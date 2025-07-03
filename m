Return-Path: <linux-fscrypt+bounces-683-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 7B662AF6A45
	for <lists+linux-fscrypt@lfdr.de>; Thu,  3 Jul 2025 08:28:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 23AF63BB3B5
	for <lists+linux-fscrypt@lfdr.de>; Thu,  3 Jul 2025 06:28:08 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 89D80291C1A;
	Thu,  3 Jul 2025 06:28:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="yPQ8Hje4"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from out162-62-58-216.mail.qq.com (out162-62-58-216.mail.qq.com [162.62.58.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0504934CF5;
	Thu,  3 Jul 2025 06:28:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=162.62.58.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751524107; cv=none; b=eOiDnEc9+NsM3R2V+H/6bcS51/B64k7M4LBEf4evgafS2VzodvhvVIzqV4FGYicy7waneDgLhsKP987oheAuY2VqWM1JrTS4YyTI7HTDgTKVx9puWAeMUNgW4llegXHQJdzTUSXCWdgjiCY2xsL/Czc+Nw+5zJwvj7VTUiU0kgE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751524107; c=relaxed/simple;
	bh=k2fQ15blhXnokoZCixT/LqKBpaoOPiZz7TLHKu3xLxE=;
	h=Message-ID:From:To:Cc:Subject:Date:MIME-Version; b=XiSIWW1AAav4UrZUcrrz7Me8iIJ+RU3eKxDqcywDsU+M0vg9FVCpm/SUW+ahTI8ZN8Lc9v7bFKV1jUSsMStlwKm9dtG0cH63jzIF6pNef4wIFJMgV7pIY6bUDgGcRlKQ/xnuH8rLN2kQYG155cagzDm815KuomSV8QnbRltxKiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=yPQ8Hje4; arc=none smtp.client-ip=162.62.58.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1751523797;
	bh=nE5o0ZqeNH5gAh0+GhcCOmyyvJ/oaeaGfaV8MIneIgk=;
	h=From:To:Cc:Subject:Date;
	b=yPQ8Hje4K5Rz2pz7rPuUdFaKpeGnsnW6ZKqh6DJvGKFxwFZm86d3AJ4b2l0DhxhDQ
	 xTh8ehxF1h5X/0e9HdKrM+NHRuq2eFX/CUllhDEMbl2TXWH7VEXLfgykgRFqG1R9no
	 NNs9jdKyKoo7nExLuWVG2jxYhKKEu2fu5SUDbl/s=
Received: from meizu-Precision-3660.meizu.com ([14.21.33.154])
	by newxmesmtplogicsvrsza28-0.qq.com (NewEsmtp) with SMTP
	id 5CF33025; Thu, 03 Jul 2025 14:23:15 +0800
X-QQ-mid: xmsmtpt1751523795tikroen7m
Message-ID: <tencent_D06DEE8D71295798F385BCC52FACAE96A207@qq.com>
X-QQ-XMAILINFO: MMwjR1C73eIs3QfeLzO2lVtLnj7bWfRMm+8Iu0tVq8lBrc+Mi/7zpRftqsC4Ri
	 1fRium/jka+geMb5PIdCC69ZnQ0NMT4kzyQJS3hg7IplUlc81FMbJS+cojkr6C2Bk2EtsnGI/vxY
	 krvAPKvVhdo8+UIq5J/kc4penx/O/3ZFBGt8Xk+r2R780k/b2a6akT2+3wOyfR8xkVUTeEwyGfv6
	 DnuMPJxxLbYQkg56ZPmptat9fdKz7rmhFGP+PylC71fwSfNVdIKTyNTA/84RLkCu68EwjBve5imp
	 CwN37vk6C9KwXmy4xH64r48lPIbDAQRRwQRmvIkX3RyXP3NrGiM6hcawzxfqQllVnMttX+cU8r+Z
	 erOjQ50Ae/17BLE269goMX5zA9GN7v8NWPV3mnVHsg76xnBj6Vrm7RveJLAuivF4unib933y2x40
	 rB28NWy2cWWJRPCFgEwY7yzIM8F9cZ5+8Gmm+xYWhnH375TutQ/wG9L2idy1EEW1p1XmYGFAMjXR
	 DoHEU9Nnfb0vBnFAO5rg3twDSvki62rA16hEc4QjVDZ8H6rDCnzEbQL4ZzxXAj0ClXLX8tFPVXRn
	 QRVLxxHNSvYOGbbNvy+CMbLOTHV7jYAxc+DlsmdfkFKbvcC+bPdJ77VblOuKc8jPaOR2tic/bwGZ
	 JhqiodUEP4DvymwKvF+QXzv8J6XgbbXZ/ISO3AbgG3RDVgmK3GlRT9uJf+TC2qtOqPIOI/p9bA7w
	 UE78ZWNVzIq72TT4+LkEqfZLoZ3DTZbuyL+pUwTQ8eO0PnYXUOq7rUBUp4lv4Y3p49viJEacU8LY
	 oqiudUAlYvszwWMeYusMXnb7oU1vEbfnUWJ8Lri0uLKF7+nbHd0B5CIK40aLV5RPndm2h8Gf5TOH
	 2SrEYqwJE2qriBBq83IEk+4gbK0ZEiIl14kPPydDYxb6V5a7zVQaxJeIQflilCzPtWj2DQesS4OA
	 kSyilN/9oF6//2nJ6ydnbepamIQa4+zhKi9apeIb+QAdrMW0nKsUQ3Af85K62FzgAz00pBTZeI/c
	 e3Zg+eSAF117X1/pPuzkRsGqxGdfAi8NQhV9fRRg==
X-QQ-XMRINFO: OD9hHCdaPRBwq3WW+NvGbIU=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: ebiggers@kernel.org,
	tytso@mit.edu,
	herbert@gondor.apana.org.au,
	davem@davemloft.net,
	jaegeuk@kernel.org
Cc: linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	linux-crypto@vger.kernel.org,
	Yuwen Chen <ywen.chen@foxmail.com>
Subject: [PATCH] fscrypt: improve filename encryption and decryption performance
Date: Thu,  3 Jul 2025 14:19:01 +0800
X-OQ-MSGID: <20250703061901.3662034-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

With the CONFIG_UNICODE configuration enabled, the fname_decrypt
and fscrypt_fname_encrypt functions may be called very frequently.
Since filenames are generally short, the frequent invocation of
memory allocation and release operations by these two functions
will lead to very poor performance.

Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
---
 fs/crypto/fname.c         | 11 +++--------
 include/crypto/skcipher.h |  9 +++++++++
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 010f9c0a4c2f1..a3cc30ff3586b 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -77,6 +77,7 @@ static inline bool fscrypt_is_dot_dotdot(const struct qstr *str)
 	return is_dot_dotdot(str->name, str->len);
 }
 
+#define MAX_SKCIPHER_REQSIZE (384)
 /**
  * fscrypt_fname_encrypt() - encrypt a filename
  * @inode: inode of the parent directory (for regular filenames)
@@ -92,10 +93,10 @@ static inline bool fscrypt_is_dot_dotdot(const struct qstr *str)
 int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
 			  u8 *out, unsigned int olen)
 {
-	struct skcipher_request *req = NULL;
 	DECLARE_CRYPTO_WAIT(wait);
 	const struct fscrypt_inode_info *ci = inode->i_crypt_info;
 	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
+	SKCIPHER_REQUEST_ON_STACK(req, tfm, MAX_SKCIPHER_REQSIZE);
 	union fscrypt_iv iv;
 	struct scatterlist sg;
 	int res;
@@ -124,7 +125,6 @@ int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
 
 	/* Do the encryption */
 	res = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
-	skcipher_request_free(req);
 	if (res < 0) {
 		fscrypt_err(inode, "Filename encryption failed: %d", res);
 		return res;
@@ -148,18 +148,14 @@ static int fname_decrypt(const struct inode *inode,
 			 const struct fscrypt_str *iname,
 			 struct fscrypt_str *oname)
 {
-	struct skcipher_request *req = NULL;
 	DECLARE_CRYPTO_WAIT(wait);
 	struct scatterlist src_sg, dst_sg;
 	const struct fscrypt_inode_info *ci = inode->i_crypt_info;
 	struct crypto_skcipher *tfm = ci->ci_enc_key.tfm;
+	SKCIPHER_REQUEST_ON_STACK(req, tfm, MAX_SKCIPHER_REQSIZE);
 	union fscrypt_iv iv;
 	int res;
 
-	/* Allocate request */
-	req = skcipher_request_alloc(tfm, GFP_NOFS);
-	if (!req)
-		return -ENOMEM;
 	skcipher_request_set_callback(req,
 		CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
 		crypto_req_done, &wait);
@@ -172,7 +168,6 @@ static int fname_decrypt(const struct inode *inode,
 	sg_init_one(&dst_sg, oname->name, oname->len);
 	skcipher_request_set_crypt(req, &src_sg, &dst_sg, iname->len, &iv);
 	res = crypto_wait_req(crypto_skcipher_decrypt(req), &wait);
-	skcipher_request_free(req);
 	if (res < 0) {
 		fscrypt_err(inode, "Filename decryption failed: %d", res);
 		return res;
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 9e5853464345b..ff2c5ac9252ff 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -226,6 +226,15 @@ struct lskcipher_alg {
 			crypto_sync_skcipher_tfm((_tfm)), \
 		 (void *)__##name##_desc)
 
+
+#define SKCIPHER_REQUEST_ON_STACK(name, _tfm, reqsize) \
+	char __##name##_desc[sizeof(struct skcipher_request) + reqsize \
+		] CRYPTO_MINALIGN_ATTR; \
+	struct skcipher_request *name = \
+		(((struct skcipher_request *)__##name##_desc)->base.tfm = \
+			crypto_skcipher_tfm((_tfm)), \
+		 (void *)__##name##_desc)
+
 /**
  * DOC: Symmetric Key Cipher API
  *
-- 
2.34.1


