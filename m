Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8F964183BB1
	for <lists+linux-fscrypt@lfdr.de>; Thu, 12 Mar 2020 22:48:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726528AbgCLVsj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Mar 2020 17:48:39 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:44493 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726481AbgCLVsj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Mar 2020 17:48:39 -0400
Received: by mail-qt1-f196.google.com with SMTP id h16so5749786qtr.11
        for <linux-fscrypt@vger.kernel.org>; Thu, 12 Mar 2020 14:48:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=gp+fuub9JdchdC/m/CyOPCVRL22yDc1KGEhZ0n1tIfo=;
        b=Zb+IXMq/i+F8mdddtBqUO3vlFidpKW3Vtqu7zD8FJq6W4w4VuyC9OXmcnb9XaoLx8Y
         BfNDewKdfCpEYJBYPEDBH/a1WWudKsli8RSFpTQCbs1lMUm7doAnRrC0yXhMUnzIJWkK
         SSt5RjkRzKyb5KwDESvFaKf4BZIGespz4x+55r0mVGqf0f9CRTorzL9JONfeW3NNh0NJ
         elt+F6cQCBLPIXqGXxvKEBgvCXZAOzTpCXVMHMipC26KjJhxYGkxpSZ7P6VGQ1VYa6Ov
         RKghXvMp3SQEDr6z/mTyi/qyqSqZCEVmT46Jc3VL0uyYQlSNMRvhyYW19k8N9FBoE8/N
         k3Qw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=gp+fuub9JdchdC/m/CyOPCVRL22yDc1KGEhZ0n1tIfo=;
        b=a0AyqxCmLymh1nGJTd6w53SyWemKsW26gcUbO3NPiywOpjDy6zyEmVUwM9Ddr2a5n2
         8CCfLnsbCjIZOl4L8y77rWP228/ICfJZDhXXo/V8PUpp1txjdrPuOqwLF4oLZ0L12P/d
         RxwC0HNhJP6Ize6Cz2shjyw6W/xyXMAq+PYXOBr6S/gxkxYNLlGd5cw8qve61k88C0v3
         /pr4u+v47JTN7DjJ36D9o164L7xFaRd+DJ/H2q3ViapwPJmHZXIbb+6spQZkApSAOzZX
         A4IAWRhbkIk/J++tetJCfO1JKdhN1Db5OX67QM/59EzWm9vbNoBZOs1VGGeAf6TSWLQ7
         79lQ==
X-Gm-Message-State: ANhLgQ0uDem2M8T19cBiHedSXKxOmjplMslB2omBGR1qcnzr6TnTOZQq
        gdIu7fXNp3ZKtMwZgXMjvCh8JTd4
X-Google-Smtp-Source: ADFU+vtfheySTMlcSUiHhLe5l8Y3iApkRbXavY7BzToTSlFfXFA/5L5QSiR5M1POZ/IzQccTcEzmxg==
X-Received: by 2002:ac8:36a1:: with SMTP id a30mr9246179qtc.103.1584049717515;
        Thu, 12 Mar 2020 14:48:37 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::fa82])
        by smtp.gmail.com with ESMTPSA id s49sm10638326qtc.29.2020.03.12.14.48.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 12 Mar 2020 14:48:36 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     kernel-team@fb.com, ebiggers@kernel.org,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH 9/9] Document API of libfsverity
Date:   Thu, 12 Mar 2020 17:47:58 -0400
Message-Id: <20200312214758.343212-10-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
References: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

Signed-off-by: Jes Sorensen <jsorensen@fb.com>
---
 libfsverity.h | 45 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 45 insertions(+)

diff --git a/libfsverity.h b/libfsverity.h
index a2abdb3..f6c4b13 100644
--- a/libfsverity.h
+++ b/libfsverity.h
@@ -64,18 +64,63 @@ struct fsverity_hash_alg {
 	struct hash_ctx *(*create_ctx)(const struct fsverity_hash_alg *alg);
 };
 
+/*
+ * libfsverity_compute_digest - Compute digest of a file
+ * @fd: open file descriptor of file to compute digest for
+ * @params: struct libfsverity_merkle_tree_params specifying hash algorithm,
+ *	    block size, version, and optional salt parameters.
+ *	    reserved parameters must be zero.
+ * @digest_ret: Pointer to pointer for computed digest
+ *
+ * Returns:
+ * * 0 for success, -EINVAL for invalid input arguments, -ENOMEM if failed
+ *   to allocate memory, -EBADF if fd is invalid, and -EAGAIN if root hash
+ *   fails to compute.
+ * * digest_ret returns a pointer to the digest on success.
+ */
 int
 libfsverity_compute_digest(int fd,
 			   const struct libfsverity_merkle_tree_params *params,
 			   struct libfsverity_digest **digest_ret);
 
+/*
+ * libfsverity_sign_digest - Sign previously computed digest of a file
+ * @digest: pointer to previously computed digest
+ * @sig_params: struct libfsverity_signature_params providing filenames of
+ *          the keyfile and certificate file. Reserved parameters must be zero.
+ * @sig_ret: Pointer to pointer for signed digest
+ * @sig_size_ret: Pointer to size of signed return digest
+ *
+ * Returns:
+ * * 0 for success, -EINVAL for invalid input arguments, -EAGAIN if key or
+ *   certificate files fail to read, or if signing the digest fails.
+ * * sig_ret returns a pointer to the signed digest on success.
+ * * sig_size_ret returns the size of the signed digest on success.
+ */
 int
 libfsverity_sign_digest(const struct libfsverity_digest *digest,
 			const struct libfsverity_signature_params *sig_params,
 			uint8_t **sig_ret, size_t *sig_size_ret);
 
+/*
+ * libfsverity_find_hash_alg_by_name - Find hash algorithm by name
+ * @name: Pointer to name of hash algorithm
+ *
+ * Returns:
+ * struct fsverity_hash_alg success
+ * NULL on error
+ */
 const struct fsverity_hash_alg *
 libfsverity_find_hash_alg_by_name(const char *name);
+
+/*
+ * libfsverity_find_hash_alg_by_num - Find hash algorithm by number
+ * @name: Number of hash algorithm
+ *
+ * Returns:
+ * struct fsverity_hash_alg success
+ * NULL on error
+ */
 const struct fsverity_hash_alg *
 libfsverity_find_hash_alg_by_num(unsigned int num);
 
-- 
2.24.1

