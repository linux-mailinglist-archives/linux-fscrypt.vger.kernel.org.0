Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6378B70E371
	for <lists+linux-fscrypt@lfdr.de>; Tue, 23 May 2023 19:46:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237846AbjEWQzK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 23 May 2023 12:55:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237240AbjEWQzH (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 23 May 2023 12:55:07 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DFC41E5
        for <linux-fscrypt@vger.kernel.org>; Tue, 23 May 2023 09:55:04 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id d2e1a72fcca58-64d247a023aso4288628b3a.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 23 May 2023 09:55:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684860904; x=1687452904;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=mZtmkk+jONnQa4W4uK+zgLIk9BnAdsu1LRB9JUp0pRA=;
        b=YcXM7AizsHZKC+nEe8qqkjpFx8oVQxBrbpi8ehC37rTsPI6zK/kZYcQNxFv4kz6ci1
         KIL2mpcoSJ+P5BKhnK+0xAapwCG6ywioPURxl56ZN9ov/DMRJY1jidUZaTuIL65LQ6OQ
         2PdkMIrENbpeyLhUlp0+fLJUcbrnWlh0QqVAM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684860904; x=1687452904;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mZtmkk+jONnQa4W4uK+zgLIk9BnAdsu1LRB9JUp0pRA=;
        b=cB3CgnOeVGsMQb3zTYXRz/mOoky+tM/jk9kj/96rwgrXIxpcCiMj6+oRRJkNhd2U4S
         S6X7R5LaBSNviruQSWF0117N9bmn+/XZqwbad1iF5L1VOXwieJ0EJhAL0LERcnjaJ8bW
         CL0PYVTMKdK0QAjK7/fGoYOQ7+3aoqnd1P5lmTHgopkqWYDKXchCi/bFYrZnPuqf1cS3
         q8VVtkVDzppvHZHFbVVqzehkj025jdvwcttV84orgkBfrbSP/GHKz/+lmyhA8eB/Olmx
         7+ERZIduY4LuJ8C+7XZMP2o1t+hxiL77bjs5nLmQWAigAvnGe2zxPF2FPt/bpporSbhc
         sX+g==
X-Gm-Message-State: AC+VfDyvzShe9EKGyjCuPTkDoHZh2PgBOFhlVAq705y+GZFaqZ0l0Cxb
        gWdDVKdv0re02c+naedUwZdzQg==
X-Google-Smtp-Source: ACHHUZ4QKSw+1ing3KbGt7B+kOHy7kMOgtRyZ0ZvULR23hds7Q2OC0kA2NWfDALZ3ne9/6QoPXVZpA==
X-Received: by 2002:a05:6a00:2310:b0:63b:859f:f094 with SMTP id h16-20020a056a00231000b0063b859ff094mr21374070pfh.20.1684860904384;
        Tue, 23 May 2023 09:55:04 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id d2-20020aa78e42000000b0062dcf5c01f9sm6069865pfr.36.2023.05.23.09.55.03
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 23 May 2023 09:55:03 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH v2] fscrypt: Replace 1-element array with flexible array
Date:   Tue, 23 May 2023 09:55:02 -0700
Message-Id: <20230523165458.gonna.580-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2915; h=from:subject:message-id; bh=5hU5H6VcCCVzxQwneKvoaEslQuGBTUVxQyklCojjRSc=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBkbO/lCibWPVGnc+0KmunFnL6sqLePTIZbyoJB7dT3 hI0SbWOJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZGzv5QAKCRCJcvTf3G3AJpvoEA CGQToI49kw84yifCeLDVhY5whkYA1MGP3c9qNIE5XRpaGAJiu9RTjCSfWp0vd3FhpOYk0qWytWdgA4 j46fK3lknxxumy9HSym1ampOtAhs4gvJbdeZhZxACZ8KXS6+WWRANB8rKhyjvN5SZGELGIQg4KfdWR xUoNyV/2E5vI5hwGtpKrW3hj7vXEFmc7FXzQPtkQ+fxHAwDHnTr7es+duoYenQ/DAQhaP5zXNJT/FU UUvpWSOeAaLVEHrq/Qob31nw/FYX5/B9a42R+0Hg75Ig6Z8u/bdJcOCAoIUNjK8oN2TdSK+3KpQq9d A4/61yxkuaEW2QgfT2FfZd5oHJcQcd9ywaeFRi2YLHFWUqwuGuzUeSIJZeGzgLQGZ4Wyoq8NCFG22Y PhGMOuN16eh0VPPdKcsgY/Z8aH8YDVmQfS+oSle0nmpo+CJKNhSZefziEXDYXPlzZQXxJb/QvjHRSS U6hzjaS+fAK7gQ1iRQWf5fAs7V5lPy/xhWQdUU8utvKDkaQMZ9JlFfJjP5L5pmig4bbvwGoZeiA4if 3qtLmPxig81K6YLJbMb+eNPa2n5cX5ZhxW7YM33U584KllbWHdCUQ9vZc0ffzaYujWTW72JFaBI+ab DMGwTR2/wsfXY7u43BWMyR6Abtq5Ihw2KhrjlnxLIdRKR0hGOm+HzJgp+OtQ==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

1-element arrays are deprecated and are being replaced with C99
flexible arrays[1].

As sizes were being calculated with the extra byte intentionally,
propagate the difference so there is no change in binary output.

[1] https://github.com/KSPP/linux/issues/79

Cc: Eric Biggers <ebiggers@kernel.org>
Cc: "Theodore Y. Ts'o" <tytso@mit.edu>
Cc: Jaegeuk Kim <jaegeuk@kernel.org>
Cc: Gustavo A. R. Silva <gustavoars@kernel.org>
Cc: linux-fscrypt@vger.kernel.org
Signed-off-by: Kees Cook <keescook@chromium.org>
---
v2: update commit log to avoid mentioning "len" member.
v1: https://lore.kernel.org/lkml/20230522213924.never.119-kees@kernel.org/
---
 fs/crypto/fscrypt_private.h |  2 +-
 fs/crypto/hooks.c           | 10 +++++-----
 2 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 7ab5a7b7eef8..2d63da48635a 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -171,7 +171,7 @@ fscrypt_policy_flags(const union fscrypt_policy *policy)
  */
 struct fscrypt_symlink_data {
 	__le16 len;
-	char encrypted_path[1];
+	char encrypted_path[];
 } __packed;
 
 /**
diff --git a/fs/crypto/hooks.c b/fs/crypto/hooks.c
index 9e786ae66a13..6238dbcadcad 100644
--- a/fs/crypto/hooks.c
+++ b/fs/crypto/hooks.c
@@ -255,10 +255,10 @@ int fscrypt_prepare_symlink(struct inode *dir, const char *target,
 	 * for now since filesystems will assume it is there and subtract it.
 	 */
 	if (!__fscrypt_fname_encrypted_size(policy, len,
-					    max_len - sizeof(struct fscrypt_symlink_data),
+					    max_len - sizeof(struct fscrypt_symlink_data) - 1,
 					    &disk_link->len))
 		return -ENAMETOOLONG;
-	disk_link->len += sizeof(struct fscrypt_symlink_data);
+	disk_link->len += sizeof(struct fscrypt_symlink_data) + 1;
 
 	disk_link->name = NULL;
 	return 0;
@@ -289,7 +289,7 @@ int __fscrypt_encrypt_symlink(struct inode *inode, const char *target,
 		if (!sd)
 			return -ENOMEM;
 	}
-	ciphertext_len = disk_link->len - sizeof(*sd);
+	ciphertext_len = disk_link->len - sizeof(*sd) - 1;
 	sd->len = cpu_to_le16(ciphertext_len);
 
 	err = fscrypt_fname_encrypt(inode, &iname, sd->encrypted_path,
@@ -367,7 +367,7 @@ const char *fscrypt_get_symlink(struct inode *inode, const void *caddr,
 	 * the ciphertext length, even though this is redundant with i_size.
 	 */
 
-	if (max_size < sizeof(*sd))
+	if (max_size < sizeof(*sd) + 1)
 		return ERR_PTR(-EUCLEAN);
 	sd = caddr;
 	cstr.name = (unsigned char *)sd->encrypted_path;
@@ -376,7 +376,7 @@ const char *fscrypt_get_symlink(struct inode *inode, const void *caddr,
 	if (cstr.len == 0)
 		return ERR_PTR(-EUCLEAN);
 
-	if (cstr.len + sizeof(*sd) - 1 > max_size)
+	if (cstr.len + sizeof(*sd) > max_size)
 		return ERR_PTR(-EUCLEAN);
 
 	err = fscrypt_fname_alloc_buffer(cstr.len, &pstr);
-- 
2.34.1

