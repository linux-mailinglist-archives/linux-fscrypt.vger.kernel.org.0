Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A70825161F3
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 May 2022 07:13:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240284AbiEAFQU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 May 2022 01:16:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240557AbiEAFQQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 May 2022 01:16:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4040550E16;
        Sat, 30 Apr 2022 22:12:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DE9F6B80CDF;
        Sun,  1 May 2022 05:12:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65DC8C385B5;
        Sun,  1 May 2022 05:12:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651381967;
        bh=lZT1gByo3Y9Ub5T0TA1IR1XBzyPH8WZkJ9F8N3p3es0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=T1+iweG7jBy7ELy5r7MYHZHjHcu7ab9qUVX9z9mtOopxiYXR3GmtbIVHrvfIq0eIG
         7PUhfBXIP7yVu5kYBw+5KGjR8vunqyY5dBv9I5zbDqqXj5vR5fD73Fvzhe/DmCweL+
         hIDnU0LhqOzYEcD4HGGLbF04ArCT6/dF2S5HXYOnnKv4OHPE4T3UxKUUCudovpcqQX
         Pr6d8ah7kthYGLA3m18muKEZv3nOOZ8lo1tg78FTiZWkRAC6xvBzXpIUP0VHU9yTRF
         36AIHnGOB0/DP2Qxwk9hYgm0lsUXf87CYWnKEukWlweCR0i1deBNzR6/UHH+wX6ak/
         IJtWAQr466irQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Lukas Czerner <lczerner@redhat.com>, Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jeff Layton <jlayton@kernel.org>
Subject: [PATCH v2 3/7] fscrypt: factor out fscrypt_policy_to_key_spec()
Date:   Sat, 30 Apr 2022 22:08:53 -0700
Message-Id: <20220501050857.538984-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.36.0
In-Reply-To: <20220501050857.538984-1-ebiggers@kernel.org>
References: <20220501050857.538984-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Factor out a function that builds the fscrypt_key_specifier for an
fscrypt_policy.  Before this was only needed when finding the key for a
file, but now it will also be needed for test_dummy_encryption support.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h |  2 ++
 fs/crypto/keysetup.c        | 20 +++-----------------
 fs/crypto/policy.c          | 20 ++++++++++++++++++++
 3 files changed, 25 insertions(+), 17 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 5b0a9e6478b5d..f32d0ee91e70e 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -621,6 +621,8 @@ int fscrypt_setup_v1_file_key_via_subscribed_keyrings(struct fscrypt_info *ci);
 
 bool fscrypt_policies_equal(const union fscrypt_policy *policy1,
 			    const union fscrypt_policy *policy2);
+int fscrypt_policy_to_key_spec(const union fscrypt_policy *policy,
+			       struct fscrypt_key_specifier *key_spec);
 bool fscrypt_supported_policy(const union fscrypt_policy *policy_u,
 			      const struct inode *inode);
 int fscrypt_policy_from_context(union fscrypt_policy *policy_u,
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index eede186b04ce3..571d220d6e226 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -425,23 +425,9 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
 	if (err)
 		return err;
 
-	switch (ci->ci_policy.version) {
-	case FSCRYPT_POLICY_V1:
-		mk_spec.type = FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR;
-		memcpy(mk_spec.u.descriptor,
-		       ci->ci_policy.v1.master_key_descriptor,
-		       FSCRYPT_KEY_DESCRIPTOR_SIZE);
-		break;
-	case FSCRYPT_POLICY_V2:
-		mk_spec.type = FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER;
-		memcpy(mk_spec.u.identifier,
-		       ci->ci_policy.v2.master_key_identifier,
-		       FSCRYPT_KEY_IDENTIFIER_SIZE);
-		break;
-	default:
-		WARN_ON(1);
-		return -EINVAL;
-	}
+	err = fscrypt_policy_to_key_spec(&ci->ci_policy, &mk_spec);
+	if (err)
+		return err;
 
 	key = fscrypt_find_master_key(ci->ci_inode->i_sb, &mk_spec);
 	if (IS_ERR(key)) {
diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index ed3d623724cdd..2a11276913a98 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -32,6 +32,26 @@ bool fscrypt_policies_equal(const union fscrypt_policy *policy1,
 	return !memcmp(policy1, policy2, fscrypt_policy_size(policy1));
 }
 
+int fscrypt_policy_to_key_spec(const union fscrypt_policy *policy,
+			       struct fscrypt_key_specifier *key_spec)
+{
+	switch (policy->version) {
+	case FSCRYPT_POLICY_V1:
+		key_spec->type = FSCRYPT_KEY_SPEC_TYPE_DESCRIPTOR;
+		memcpy(key_spec->u.descriptor, policy->v1.master_key_descriptor,
+		       FSCRYPT_KEY_DESCRIPTOR_SIZE);
+		return 0;
+	case FSCRYPT_POLICY_V2:
+		key_spec->type = FSCRYPT_KEY_SPEC_TYPE_IDENTIFIER;
+		memcpy(key_spec->u.identifier, policy->v2.master_key_identifier,
+		       FSCRYPT_KEY_IDENTIFIER_SIZE);
+		return 0;
+	default:
+		WARN_ON(1);
+		return -EINVAL;
+	}
+}
+
 static const union fscrypt_policy *
 fscrypt_get_dummy_policy(struct super_block *sb)
 {
-- 
2.36.0

