Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2DD9741D18
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 02:35:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231450AbjF2Afl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 20:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58564 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231290AbjF2AfW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 20:35:22 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6CEC210E;
        Wed, 28 Jun 2023 17:35:19 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 9383E8079D;
        Wed, 28 Jun 2023 20:29:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1687998550; bh=g0b35MrtF2uGyl8iDzN5bX4Wn/xb7o1sAgwZ2In2a1o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KzBiXw++myjXzO26U4YjM+kDm2tABjv2ds31/P3BmSkbXKCQOYUe95Pg8hX1bxZyo
         mcRR9YrKef7n/GlzxmLrj/2yrXf77SJLtPkFVI7mBGnRPZkez5qdSdmRvusLwhrNbe
         2aNmqnn7AxD3F3YsJgGu0HT3vJfvW+arb/kdnUCljJdCOzGm//AtE1vrL8/f2tF+gx
         ggsSAPz3PsISfV4VHFB1CTyTp2Q4QHGF+jSgMxYz39JkjuQCZclJz9lqtDobKBNaDD
         XNTCREok7mt1olhg5owvCbOaUFnxR6vEcX5SHz7W48mTxLQh1vjJP0JQ3sHyi/XcIQ
         QFT1UL/lIPEHg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v4 1/8] fscrypt: move inline crypt decision to info setup
Date:   Wed, 28 Jun 2023 20:28:51 -0400
Message-Id: <ad6abe16bf9e70aad9f3e4348106b56a7ac8b83f.1687988119.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1687988119.git.sweettea-kernel@dorminy.me>
References: <cover.1687988119.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

setup_file_encryption_key() is doing a lot of things at the moment --
setting the crypt_info's inline encryption bit, finding and locking a
master key, and calling the functions to get the appropriate prepared
key for this info. Since setting the inline encryption bit has nothing
to do with finding the master key, it's easy and hopefully clearer to
select the encryption implementation in fscrypt_setup_encryption_info(),
the main fscrypt_info setup function, instead of in
setup_file_encryption_key() which will long-term only deal in setting
up the prepared key for the info.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/keysetup.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 361f41ef46c7..b89c32ad19fb 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -443,10 +443,6 @@ static int setup_file_encryption_key(struct fscrypt_info *ci,
 	struct fscrypt_master_key *mk;
 	int err;
 
-	err = fscrypt_select_encryption_impl(ci);
-	if (err)
-		return err;
-
 	err = fscrypt_policy_to_key_spec(&ci->ci_policy, &mk_spec);
 	if (err)
 		return err;
@@ -580,6 +576,10 @@ fscrypt_setup_encryption_info(struct inode *inode,
 	WARN_ON_ONCE(mode->ivsize > FSCRYPT_MAX_IV_SIZE);
 	crypt_info->ci_mode = mode;
 
+	res = fscrypt_select_encryption_impl(crypt_info);
+	if (res)
+		goto out;
+
 	res = setup_file_encryption_key(crypt_info, need_dirhash_key, &mk);
 	if (res)
 		goto out;
-- 
2.40.1

