Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D1B870CC9E
	for <lists+linux-fscrypt@lfdr.de>; Mon, 22 May 2023 23:39:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjEVVje (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 22 May 2023 17:39:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229707AbjEVVjd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 22 May 2023 17:39:33 -0400
Received: from mail-pf1-x436.google.com (mail-pf1-x436.google.com [IPv6:2607:f8b0:4864:20::436])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BFA6C6
        for <linux-fscrypt@vger.kernel.org>; Mon, 22 May 2023 14:39:30 -0700 (PDT)
Received: by mail-pf1-x436.google.com with SMTP id d2e1a72fcca58-64d1a0d640cso3821595b3a.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 22 May 2023 14:39:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google; t=1684791570; x=1687383570;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:from:to:cc:subject:date:message-id:reply-to;
        bh=yYwGioKHAJzzXpZNwhrgt0fRkyN2XRD/FBakCK3HKOU=;
        b=Q/22MWbGb4LJqU4oSYD5bGLZUhkksBa8VfQiVKUE2LGw0hyXubaLn9Y/Pdl4qcu1Aq
         flztw3sWhfSnCqIMTr7eJNRRxwjAiXYBXb8l0ib+XijXpYkN7UQ2e7ONMhEfFjUsQvF9
         zYB+8w4BCBY2hNioWCZf1Gfu45jCcBbXUNlUY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1684791570; x=1687383570;
        h=content-transfer-encoding:mime-version:message-id:date:subject:cc
         :to:from:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yYwGioKHAJzzXpZNwhrgt0fRkyN2XRD/FBakCK3HKOU=;
        b=Wi3wmVTCANYIsVLxI1cOTXzYweYWZ32lOfBpN6b3LBnOgNjyf6GXGsi2Aigl9D5drd
         kc5yxixn/WVVWtYHSvTRzDpVYsYrCo+p51Xkoohu3x/akQhuJxIfRIVLCdPrQbRHPyq0
         +Bmd/deLi0iSM7vyfd44zhrWiHdincJ8sCEYKqO2NJPpFmyvBn/9R+WVT/hhTIY9eKzR
         lUYHzSHcnKqfysxivIrBU4hnUlmcDDnKwQvm3c19QvuUKfdcHr4Cxa/DfjRE7fM318bT
         a4nJ5IqtMxQrwWT2cF/68e77CzYcKta+CLF1MktAOk5m3rVOcYuiZGOHjBwZeeHQC9LE
         NiCg==
X-Gm-Message-State: AC+VfDxuk9t/mZsO7az7ly9RWSzc4dbBBXP2YRzCUZfWl+0jWSHNfwT5
        IxeM/Gi/1ibjeRyXSJWAAEYsPA==
X-Google-Smtp-Source: ACHHUZ4tELJVgwSsxaTjmW47Bpn3ZRSsp7oLQq+wh9pdRRCLxA4adydSsg0EjneIuLPo0/xXkmXAhQ==
X-Received: by 2002:a05:6a20:394c:b0:100:15c4:23af with SMTP id r12-20020a056a20394c00b0010015c423afmr11925142pzg.60.1684791570055;
        Mon, 22 May 2023 14:39:30 -0700 (PDT)
Received: from www.outflux.net (198-0-35-241-static.hfc.comcastbusiness.net. [198.0.35.241])
        by smtp.gmail.com with ESMTPSA id l19-20020a635713000000b00530621e5ee4sm4839164pgb.9.2023.05.22.14.39.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 May 2023 14:39:29 -0700 (PDT)
From:   Kees Cook <keescook@chromium.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Kees Cook <keescook@chromium.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Gustavo A . R . Silva" <gustavoars@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: [PATCH] fscrypt: Replace 1-element array with flexible array
Date:   Mon, 22 May 2023 14:39:28 -0700
Message-Id: <20230522213924.never.119-kees@kernel.org>
X-Mailer: git-send-email 2.34.1
MIME-Version: 1.0
X-Developer-Signature: v=1; a=openpgp-sha256; l=2912; h=from:subject:message-id; bh=Azb8w1rjB2zyvDvJ+lSvv6YeF+QInB+mT0KQipjdFM0=; b=owEBbQKS/ZANAwAKAYly9N/cbcAmAcsmYgBka+EPHAALilDffN1PW5lkx5fDdiqwuf/mqnCY5D5f 78uDTNKJAjMEAAEKAB0WIQSlw/aPIp3WD3I+bhOJcvTf3G3AJgUCZGvhDwAKCRCJcvTf3G3AJpBTEA CH/KLnWo3rWXcLH4l1ngTeGWFakuc0FBlaAc2kTkmzyNqbxgOsNxCWX/KtSatEIflpNsffvr3z+tlh rQsCg95Ka1NbY3UGKHk74Aith96RuR5HvQ8WpcDc/ICyNRuI6KHw3z7QO4ap7lnla1/ntHE58BwEJM iopopn2Jn8MroUBQhE3+eKeToDdJVJ2nYCfq0Mp/qUcuLdemVi3q58UjcFQMy58M+X0pWkLsLPVO5i ++4o+Vtyx5UfvMo8E+Q3G4ecoTYvKtgZFN4bcf8KPETs+4bR4y2xALvbWoQq+b+wU2T1JnbCNgIt5T xLLDGOrAg54DlJJG5ewCspp6u6OL0b/NLsxwN7GqJxAMuGt0gnj22YpZgt66teZohQTDheU2nNQ/Io rkF+KIE3E1GurJkkANbkBvO1hzbRiOyO/M5whlcp1aoxlNGQLmYS7QnX/xHdnAa4cYmMUUZkfZCpEb +DTQS7IINv8Jd/R2eXY+OQxD8Su8YkumjE8ntZ7eyvM7j2Ercs0ocqnk57JlhgJHD/Bj1rDUkXd0nd HHtoncl8G6j2ocDo2B7aovg522H+j78QpKXmDIU7tOnkxErXT5bWq2+JmkEMd0OKUI5Ep0aLP0/lTo iXdbaA0iKs2qVCPTGCIQuMhzlJbAnTvtEpGQRIk3XInGQnizAGUThZLZa3mg==
X-Developer-Key: i=keescook@chromium.org; a=openpgp; fpr=A5C3F68F229DD60F723E6E138972F4DFDC6DC026
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

1-element arrays are deprecated, and are being replaced with C99
flexible arrays[1]. In the future, we can add annotations for the
flexible array member "encrypted_path" to have a size determined
by the "len" member.

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

