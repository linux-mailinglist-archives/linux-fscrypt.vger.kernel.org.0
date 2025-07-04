Return-Path: <linux-fscrypt+bounces-684-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 62721AF86C4
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Jul 2025 06:30:07 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id D2DE816E6CE
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Jul 2025 04:29:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 994CB1EF375;
	Fri,  4 Jul 2025 04:24:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b="in8sYwCZ"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from xmbghk7.mail.qq.com (xmbghk7.mail.qq.com [43.163.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 210D51F03D5;
	Fri,  4 Jul 2025 04:24:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=43.163.128.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751603093; cv=none; b=TgyASH/kVHj9JSNQ28ue43mQE6C0t0KlLc4r7oX7kuMm7ynnFy2+K7UjPBVJW2dl+a6A8ypZpjwVNZCSJU9EMtuMPnWJvQM5Zcb8aVwk054Ps2JvJA3R19thck8+luAhmE412dLMeIRcXuVqn68sBVQ44yB00Buanvtp7/8NDj8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751603093; c=relaxed/simple;
	bh=i9caz6yz/k0aha4xAwtlSBZ8FnbLb9IR1W5kvZkLDnk=;
	h=Message-ID:From:To:Cc:Subject:Date:In-Reply-To:References:
	 MIME-Version; b=OUGNs7ugL1ua/GmBn2Nw+pdnVQRB+OAZcA/SbapweTPOYiwIafGcQwepvRVwa8VJUgsxgfP1dbRB+UrafJl2YRPBv3Z7WNPhtpY67WrmwPic51s0MQeJgNr+/RqNml2zLtC9pdhD3bTFR7qfDebdhlhBil1bYH1mThWTkETUEqw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com; spf=pass smtp.mailfrom=foxmail.com; dkim=pass (1024-bit key) header.d=foxmail.com header.i=@foxmail.com header.b=in8sYwCZ; arc=none smtp.client-ip=43.163.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=foxmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=foxmail.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
	s=s201512; t=1751602780;
	bh=d8G3ursgmpgGAC/Br6jukg9RoUoOyYy7C+7W30RrUm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=in8sYwCZQFU6bE5QtvFi4Kv2MPiwrdSq8EXM1wS+mofFSdapCMZwb0FQKL97RGak2
	 IZ9YIJ1ghqphWXD71mWDEIOjzMFOGUBWq0ItTnVYjCCmVQxHWSmCxf/WS31gr08FpG
	 Ou6V7UIUQrGiyhTZepBQAs+bo0fgdsrm8awteNCM=
Received: from meizu-Precision-3660.meizu.com ([14.21.33.153])
	by newxmesmtplogicsvrsza36-0.qq.com (NewEsmtp) with SMTP
	id 35B3D4E2; Fri, 04 Jul 2025 12:13:27 +0800
X-QQ-mid: xmsmtpt1751602407twnhm2552
Message-ID: <tencent_583C288FFF6BA70BAF0880FB7A5CCAB5EA05@qq.com>
X-QQ-XMAILINFO: OQhZ3T0tjf0aLXs2QmI1IVU7O0NPyLtLJqRRO7hxSTqGWk14G6UCzNOm3dcD+S
	 e//JSJMcGsMlb2UZN74vBykxLMchwL8oq9Xng1a0avozdF166wybEdjQ87lYOPFMOn1a0ySVwGbZ
	 aQhY6UjeGlLPpJpZINaTQiHAOyRcK7ORKvO0h+NHbcq0wRHVQB+BRvO1UUSVTk3fi1vXOzhhbbpk
	 UhMDYvnLPc0Kyotk85k7N/PJERtJzFi+UQjyrLIUx1LZGkddeLJdnLLUzuO1yAQ8elfbjHXN4kii
	 gV58Qd1e5s0xG5yXjLlbOV6Z1fjQ+XQBiP/zMxpEqnbyHspTUnKIc8o+w8YyvptskVzrM+9wlu9r
	 4Jat8Mev+ZZcuYvroK+5ZKJZLG7N677kJ5vnk7w5IDb2f8ZOzVC0Xih+VYph8/VXIoBXWqfEpEpm
	 3wSrKQ+XauHS5VNriBjPUY8sSHaUP7P9ftPtYkhXQhcGmcirF+ivKQnG/BST7JaMAi5ZnqKwGIId
	 NyqToambFjfLWaUNUfoyHRraEnPhHCpPbqkofnlOqJLEK2togm0PU9oxsFDs4EZ7PzJyZ8/IsN1t
	 UmwXPTpj2Yx+tBSEH3XREDolMoHUDZBWVmEh7+pXhMwYM+LkyY4OZV6jIxiYEpcNPkxarVzeku6f
	 NMYya+dpijxZRhBfYQKQq1JfSqGqdAzAI4ejuAZdqfyaDKSwpzhUfkZ70L+oCsfL+itDmsdQHvJw
	 YzUZdZcG0Uqfo19pr83bmULuDUxIu80NUIQ4pZNfqkTg70zbO7XvBF4GSyS8+eEA/pgXc0LeNpfK
	 +3nJX6I859noUYcukuGENvxeM3oNSaQ/G/IeHf49XVDNtaKgS5knp1f6VHxKLRjMxTyjOqGqnLTg
	 H6WHrmF9fwmsgM9HyFwvr4n8E5XI63igGFGDfEaGqe1gy1DoG+Wv2k9PxcVxMayZuXkh/a+MY087
	 vxluIXJbQxie5LEioJW2/bU52fQEMY9lfxunQo0j9uy79aXT0QWd40EfG9qYAZRDtyfRZwMWoLow
	 tXPuVs/4ynH8khU9L+GKKBmRmbdpo=
X-QQ-XMRINFO: Nq+8W0+stu50PRdwbJxPCL0=
From: Yuwen Chen <ywen.chen@foxmail.com>
To: ywen.chen@foxmail.com
Cc: davem@davemloft.net,
	ebiggers@kernel.org,
	herbert@gondor.apana.org.au,
	jaegeuk@kernel.org,
	linux-crypto@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	tytso@mit.edu
Subject: [PATCH v2] fscrypt: improve filename encryption and decryption performance
Date: Fri,  4 Jul 2025 12:13:22 +0800
X-OQ-MSGID: <20250704041322.339758-1-ywen.chen@foxmail.com>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <tencent_D06DEE8D71295798F385BCC52FACAE96A207@qq.com>
References: <tencent_D06DEE8D71295798F385BCC52FACAE96A207@qq.com>
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

Use the following program to conduct a file-creation test in
the private program directory(/data/media/0/Android/data/*)
of Android.

int main(int argc, char **argv)
{
    size_t fcnt = 0;
    char path[PATH_MAX];
    char buf[4096] = {0};
    int i, fd;

    if (argc < 2)
        return - EINVAL;

    fcnt = atoi(argv[1]);
    for (i = 0; i < fcnt; i++) {
        snprintf(path, sizeof(path), "./%d", i);
        fd = open(path, O_RDWR | O_CREAT, 0600);
        if (fd < 0)
            return - 1;
        write(fd, buf, sizeof(buf));
        close(fd);
    }
    return 0;
}

The test platform is Snapdragon 8s Gen4, with a kernel version
of v6.6 and a userdebug version.

Before this submission was merged, when creating 2000 files,
the performance test results are as follows:
$ time /data/file_creater 2000
0m14.83s real     0m00.00s user     0m14.30s system
0m15.61s real     0m00.00s user     0m15.04s system
0m14.72s real     0m00.01s user     0m14.18s system

After this submission was merged, the performance is as follows:
$ time /data/file_creater 2000
0m07.64s real     0m00.00s user     0m07.37s system
0m07.66s real     0m00.00s user     0m07.40s system
0m08.67s real     0m00.01s user     0m08.35s system

Signed-off-by: Yuwen Chen <ywen.chen@foxmail.com>
---
 fs/crypto/fname.c         | 22 ++++++++++++++--------
 include/crypto/skcipher.h |  9 +++++++++
 2 files changed, 23 insertions(+), 8 deletions(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 010f9c0a4c2f1..168b2a88fa23b 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -92,14 +92,20 @@ static inline bool fscrypt_is_dot_dotdot(const struct qstr *str)
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
 
+	/*
+	 * When the size of the statically - allocated skcipher_request
+	 * structure is insufficient, remind us to make modifications.
+	 */
+	BUG_ON(MAX_SKCIPHER_REQSIZE < crypto_skcipher_reqsize(tfm));
+
 	/*
 	 * Copy the filename to the output buffer for encrypting in-place and
 	 * pad it with the needed number of NUL bytes.
@@ -124,7 +130,6 @@ int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
 
 	/* Do the encryption */
 	res = crypto_wait_req(crypto_skcipher_encrypt(req), &wait);
-	skcipher_request_free(req);
 	if (res < 0) {
 		fscrypt_err(inode, "Filename encryption failed: %d", res);
 		return res;
@@ -148,18 +153,20 @@ static int fname_decrypt(const struct inode *inode,
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
+	/*
+	 * When the size of the statically - allocated skcipher_request
+	 * structure is insufficient, remind us to make modifications.
+	 */
+	BUG_ON(MAX_SKCIPHER_REQSIZE < crypto_skcipher_reqsize(tfm));
+
 	skcipher_request_set_callback(req,
 		CRYPTO_TFM_REQ_MAY_BACKLOG | CRYPTO_TFM_REQ_MAY_SLEEP,
 		crypto_req_done, &wait);
@@ -172,7 +179,6 @@ static int fname_decrypt(const struct inode *inode,
 	sg_init_one(&dst_sg, oname->name, oname->len);
 	skcipher_request_set_crypt(req, &src_sg, &dst_sg, iname->len, &iv);
 	res = crypto_wait_req(crypto_skcipher_decrypt(req), &wait);
-	skcipher_request_free(req);
 	if (res < 0) {
 		fscrypt_err(inode, "Filename decryption failed: %d", res);
 		return res;
diff --git a/include/crypto/skcipher.h b/include/crypto/skcipher.h
index 9e5853464345b..77e74a038c36e 100644
--- a/include/crypto/skcipher.h
+++ b/include/crypto/skcipher.h
@@ -213,6 +213,7 @@ struct lskcipher_alg {
 };
 
 #define MAX_SYNC_SKCIPHER_REQSIZE      384
+#define MAX_SKCIPHER_REQSIZE	       384
 /*
  * This performs a type-check against the "_tfm" argument to make sure
  * all users have the correct skcipher tfm for doing on-stack requests.
@@ -226,6 +227,14 @@ struct lskcipher_alg {
 			crypto_sync_skcipher_tfm((_tfm)), \
 		 (void *)__##name##_desc)
 
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


