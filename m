Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2D4A01B8143
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 22:55:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgDXUzl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 16:55:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726151AbgDXUzl (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 16:55:41 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE440C09B048
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:40 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id v10so5408993qvr.2
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=KXt26GhzkGwGQaRV/av92J4+sn8Df7Wx5FQBj66cr+Y=;
        b=gTRg/EubWKN9aeln0aPEcvTA8+0vXJtqk+s5M1zavB7cUxalhmGUBwQLXf60Eigdm/
         a+qrfGM1ZH9CNHH0QY620+TehU2bvCNnEP9ZiJCQBUfcYqhtkVRqYogb+ktWbZaYgsQL
         JmeLOYpFBBdeImFs0UIZyLbLX1pILIjDkZDwuRAGEcbDn9HslQ0BQ/gU2fvSWXOR88nc
         46UtHk/f2CwiPS0nJP3Od08BlwQ/N4VDX9L1hoCnlet1NzbjSHM+VJmrKrG5YccqiFUx
         ZZ1TS4PHn2ADH5md+nqPTPSX4BL99F6Sc0vxUAeKRMq67JZYw/tmDqXzj1T5JJ2hB087
         4kqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=KXt26GhzkGwGQaRV/av92J4+sn8Df7Wx5FQBj66cr+Y=;
        b=e9GjM5Ge2iyt2RLY/ZEihMZyH78TTHvMcHR+hlu/wLyjJh2QAcYCGjkwz8Llwl6Qb2
         ZQFiWlH+rHsCPunn90o7NrlA1DhySGtdE+4mtgSdxM7X46zFYrni7L5i6lLhx+Kp2jq6
         akZZusYaHnqdV0DW59NigOnR5fTEJEEjLXkic1fn29ordKBrNJw2EbEc8DvVM5pXXN1Q
         VMYF7feGNHjk6khwqw/JDweVnIKxeHkIGxQq1kSupBXYUzwjw+M7pUGDCRtPVOtrxDRz
         a0mK7jkA/6sFXVHFS49xFqSQCK38ikdwtLSQ8sYKWWGFr5Bo5FEn2wFNFmiuWPRB+y18
         DhMA==
X-Gm-Message-State: AGi0PuZLWT7JLc4D0WhkXb8+e6WK8mv2oNy13lnLp96XSZ49xjYm7kTB
        O9Mk/Q7ZUi1Jm1GzZrCTrp2GYUIWbqM=
X-Google-Smtp-Source: APiQypK8KgAcP9qI0xFkoiaRTuBJDG8xNM5lidlvuqudH7fVSO0bxFbDKTEQ48BwPm6Es506n7eV1Q==
X-Received: by 2002:a0c:e992:: with SMTP id z18mr11549015qvn.25.1587761739732;
        Fri, 24 Apr 2020 13:55:39 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id f130sm4460722qke.22.2020.04.24.13.55.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:55:39 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, kernel-team@fb.com, jsorensen@fb.com
Subject: [PATCH 19/20] Improve documentation of libfsverity.h API
Date:   Fri, 24 Apr 2020 16:55:03 -0400
Message-Id: <20200424205504.2586682-20-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.25.3
In-Reply-To: <20200424205504.2586682-1-Jes.Sorensen@gmail.com>
References: <20200424205504.2586682-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 libfsverity.h | 27 +++++++++++++++++++--------
 1 file changed, 19 insertions(+), 8 deletions(-)

diff --git a/libfsverity.h b/libfsverity.h
index 4f0f885..c4f6b8d 100644
--- a/libfsverity.h
+++ b/libfsverity.h
@@ -58,17 +58,21 @@ struct libfsverity_signature_params {
 
 /*
  * libfsverity_compute_digest - Compute digest of a file
+ *          An fsverity digest is the root of the Merkle tree of the file.
+ *          Not to be confused with a traditional file digests computed over
+ *          the entire file.
  * @fd: open file descriptor of file to compute digest for
  * @params: struct libfsverity_merkle_tree_params specifying hash algorithm,
  *	    block size, version, and optional salt parameters.
  *	    reserved parameters must be zero.
- * @digest_ret: Pointer to pointer for computed digest
+ * @digest_ret: Pointer to pointer for computed digest.
  *
  * Returns:
  * * 0 for success, -EINVAL for invalid input arguments, -ENOMEM if failed
  *   to allocate memory, -EBADF if fd is invalid, and -EAGAIN if root hash
  *   fails to compute.
- * * digest_ret returns a pointer to the digest on success.
+ * * digest_ret returns a pointer to the digest on success. The digest object
+ *   is allocated by libfsverity and must be freed by the caller.
  */
 int
 libfsverity_compute_digest(void *fd, size_t file_size,
@@ -78,6 +82,12 @@ libfsverity_compute_digest(void *fd, size_t file_size,
 
 /*
  * libfsverity_sign_digest - Sign previously computed digest of a file
+ *          This is signature is used by the file system to validate the
+ *          signed file measurement against a public key loaded into the
+ *          .fs-verity kernel keyring, when CONFIG_FS_VERITY_BUILTIN_SIGNATURES
+ *          is enabled. The signature is formatted as PKCS#7 stored in DER
+ *          format. See Documentation/filesystems/fsverity.rst for further
+ *          details.
  * @digest: pointer to previously computed digest
  * @sig_params: struct libfsverity_signature_params providing filenames of
  *          the keyfile and certificate file. Reserved parameters must be zero.
@@ -87,7 +97,8 @@ libfsverity_compute_digest(void *fd, size_t file_size,
  * Returns:
  * * 0 for success, -EINVAL for invalid input arguments, -EAGAIN if key or
  *   certificate files fail to read, or if signing the digest fails.
- * * sig_ret returns a pointer to the signed digest on success.
+ * * sig_ret returns a pointer to the signed digest on success. This object
+ *   is allocated by libfsverity_sign_digest and must be freed by the caller.
  * * sig_size_ret returns the size of the signed digest on success.
  */
 int
@@ -100,7 +111,7 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
  * @name: Pointer to name of hash algorithm
  *
  * Returns:
- * uint16_t containing hash algorithm number, zero on error.
+ * uint16_t containing hash algorithm number, zero if not found.
  */
 uint16_t libfsverity_find_hash_alg_by_name(const char *name);
 
@@ -109,7 +120,7 @@ uint16_t libfsverity_find_hash_alg_by_name(const char *name);
  * @alg_nr: Valid hash algorithm number
  *
  * Returns:
- * int containing size of digest, -1 on error.
+ * int containing size of digest, -1 if algorithm is not known.
  */
 int libfsverity_digest_size(uint16_t alg_nr);
 
@@ -118,9 +129,9 @@ int libfsverity_digest_size(uint16_t alg_nr);
  * @name: Number of hash algorithm
  *
  * Returns:
- *  New allocated string containing name of algorithm.
- *  String must be freed by caller.
- * NULL on error
+ * New allocated string containing name of algorithm.
+ *  The string must be freed by caller.
+ * NULL if algorithm is not known.
  */
 char *libfsverity_hash_name(uint16_t num);
 
-- 
2.25.3

