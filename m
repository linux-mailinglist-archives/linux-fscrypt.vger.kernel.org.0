Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66DBF526D7D
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 May 2022 01:23:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbiEMXXh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 May 2022 19:23:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229704AbiEMXX3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 May 2022 19:23:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 485A42FDA14;
        Fri, 13 May 2022 16:20:58 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72471617E2;
        Fri, 13 May 2022 23:20:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A04CFC34119;
        Fri, 13 May 2022 23:20:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652484056;
        bh=5M/AZsC8gJLP8HFVo/AGzWoR7VyDQEAa1r6XJg17fJE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nBkGJ+jTPn1NfvTN0PGMha6IDJgbcGKh0m9rtJZ3KB71/1QIMddlyvbm2nTpQEKou
         YC9QgCZu75rOyw9JieGTFp9HE22DK5RnzOiEZp94UcwE+YrJKrYdvn1uUC7GKiYgAP
         sA+MOjPNUTM/F+q4vVip2idiw/v3t0XQ5Ge3ypoc7/TmSSNxwYPtj6KfGv3waAUPD7
         s5rF6utZjnHPVlyGOv5kwa2s8K8lUW+rSTq7Iqgp447Y5RmEyZeusYSHA/qSOlbzOI
         /nK+VAXo4yfE4Ouh4iY1z1IiWI0DPptR/ivziccPYM8+q6TbQSUevLTRHPxrgfbxBF
         rJN/TAG1ue4ZA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jeff Layton <jlayton@kernel.org>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: [PATCH v3 5/5] fscrypt: remove fscrypt_set_test_dummy_encryption()
Date:   Fri, 13 May 2022 16:16:05 -0700
Message-Id: <20220513231605.175121-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.36.1
In-Reply-To: <20220513231605.175121-1-ebiggers@kernel.org>
References: <20220513231605.175121-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Now that all its callers have been converted to
fscrypt_parse_test_dummy_encryption() and fscrypt_add_test_dummy_key()
instead, fscrypt_set_test_dummy_encryption() can be removed.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/policy.c      | 13 -------------
 include/linux/fscrypt.h |  2 --
 2 files changed, 15 deletions(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 5f858cee1e3b0..d0a8921577def 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -802,19 +802,6 @@ bool fscrypt_dummy_policies_equal(const struct fscrypt_dummy_policy *p1,
 }
 EXPORT_SYMBOL_GPL(fscrypt_dummy_policies_equal);
 
-/* Deprecated, do not use */
-int fscrypt_set_test_dummy_encryption(struct super_block *sb, const char *arg,
-				      struct fscrypt_dummy_policy *dummy_policy)
-{
-	struct fs_parameter param = {
-		.type = fs_value_is_string,
-		.string = arg ? (char *)arg : "",
-	};
-	return fscrypt_parse_test_dummy_encryption(&param, dummy_policy) ?:
-		fscrypt_add_test_dummy_key(sb, dummy_policy);
-}
-EXPORT_SYMBOL_GPL(fscrypt_set_test_dummy_encryption);
-
 /**
  * fscrypt_show_test_dummy_encryption() - show '-o test_dummy_encryption'
  * @seq: the seq_file to print the option to
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 099b881e63e49..11db6d61d4244 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -284,8 +284,6 @@ int fscrypt_parse_test_dummy_encryption(const struct fs_parameter *param,
 				    struct fscrypt_dummy_policy *dummy_policy);
 bool fscrypt_dummy_policies_equal(const struct fscrypt_dummy_policy *p1,
 				  const struct fscrypt_dummy_policy *p2);
-int fscrypt_set_test_dummy_encryption(struct super_block *sb, const char *arg,
-				struct fscrypt_dummy_policy *dummy_policy);
 void fscrypt_show_test_dummy_encryption(struct seq_file *seq, char sep,
 					struct super_block *sb);
 static inline bool
-- 
2.36.1

