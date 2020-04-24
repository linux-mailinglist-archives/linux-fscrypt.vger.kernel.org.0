Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2AC601B8138
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 22:55:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726169AbgDXUzX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 16:55:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726027AbgDXUzX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 16:55:23 -0400
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C93CC09B048
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:23 -0700 (PDT)
Received: by mail-qt1-x843.google.com with SMTP id h26so8844482qtu.8
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Apr 2020 13:55:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=n6smN2gl6f/Wp2dCgqnwDat4UskK5//wrwJg+Nr4HmI=;
        b=n/qUTdQbodBAlPH3f0FRiqnoHBUIL3XTXhsvjCSiIfMjaPvIHa/pK10YD+UIxgq0Ru
         AsN9mm5p5iadGD/9JcYfzpxUoWx2Bu1kdWVl8c7Mo6jP6g/dxj/YQiD37KClRrQ3ao0x
         DCdhpJABwXh+1fLD51vbNR9bI0z1NxKhHIJ99sB3jzP3eR8Qs85iAkG8mg+WsifovTFB
         bR5NV6cwqb/WwIueWQpAikjmImS4PIv3MuwvQUVKAx/fL5IqHkl0wbE5GLOn/4uevLei
         x1PnYwpwlMV5+yvzBa+iXmQf0MB0v9wSSK7XCjSPx7nwtb0HXSKzFC9GaWeR6HERi+SD
         k3/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=n6smN2gl6f/Wp2dCgqnwDat4UskK5//wrwJg+Nr4HmI=;
        b=Z1zS54LS4re+Jy4nL1LqV9zt66phy4CI3lMvUGMsyYw2+z5UGV/bXpJRpwRufbKuaw
         +JI2nIqGhiHscRV4Yb7gGzQRoG0sxVJYDGn7/9YQ26LRbQ0Kw13XvvG9GMHoL+u/qmkQ
         dzOyqkfJhtA/ul6PKHGgg5rNFFswct2vFjAql4sZkROx5zIApYSiqasVNAdl+PvA953N
         mHzYwhiJ4HpUxFTbsROxszZGNGLzBIxjGx7pj5yIQJdsqpdutcbEaAIlyWuyIr72SYfi
         POHOhh5oWKUsbCC3KeLGNDmubtCnqR9hmhHHAncWymAFxO4rJgaRONBoXkrq+iCwMdq7
         pz6w==
X-Gm-Message-State: AGi0PuYtOfLwerKwcCZm8Xm5neGgzktLqpugrIE9LJkqdviXKGC9GbXW
        aUBLW8dLTL9Ge/soPG8Me7UELZsmuWw=
X-Google-Smtp-Source: APiQypI/GwOh1+oyJqG4Ea1ZDItignVe3zN22NGyAPQcnxWDxBTd6EHtJLT6pbz1OjUS19FIojwRMg==
X-Received: by 2002:ac8:2dae:: with SMTP id p43mr11611742qta.341.1587761722266;
        Fri, 24 Apr 2020 13:55:22 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::62b])
        by smtp.gmail.com with ESMTPSA id j9sm4435862qkk.99.2020.04.24.13.55.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Apr 2020 13:55:21 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     linux-fscrypt@vger.kernel.org
Cc:     ebiggers@google.com, kernel-team@fb.com, jsorensen@fb.com
Subject: [PATCH 09/20] Document API of libfsverity
Date:   Fri, 24 Apr 2020 16:54:53 -0400
Message-Id: <20200424205504.2586682-10-Jes.Sorensen@gmail.com>
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
2.25.3

