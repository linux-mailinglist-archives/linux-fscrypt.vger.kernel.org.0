Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F0FD5096A9
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Apr 2022 07:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384297AbiDUF0f (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Apr 2022 01:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbiDUF0f (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Apr 2022 01:26:35 -0400
Received: from mail-pj1-x1030.google.com (mail-pj1-x1030.google.com [IPv6:2607:f8b0:4864:20::1030])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00FB3DFAB;
        Wed, 20 Apr 2022 22:23:46 -0700 (PDT)
Received: by mail-pj1-x1030.google.com with SMTP id ga4-20020a17090b038400b001d4b33c74ccso2904121pjb.1;
        Wed, 20 Apr 2022 22:23:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=mkTk6jJ30N/x3F4AyIBMkhdrEysHqLwx5nd2q3CElLU=;
        b=Hc0+5IgrOya2iYRzrDxmtBBvxHXeMw89ZPAP7iTNdSp6LlrD6DHKIteDsapSIPn+Zz
         vv2qF1dTw4fLdGTkQtwGH70TmBB5kOdtIPbKrQ8khICLgKd7Rnpi8zqekpr0lcnnNp5H
         C9Hkw/X9CMDaO+BK163KMxwDk5A6PKZsTYnFG9T2Sgzmkzch7bBH9R3EEwCm6zEbcF8C
         S2VYWsPHfGriq+4302WB9Tgqo9Hp6gcjLUuzeggRYdcLotGNqCIT72DYwuVihl2rEMib
         KsVZ5vvp8CJvWOcpG1nG1MyUiaLWkQX0fYECcttcCA5VDj6ZktlWvbvjdP0hBuX1luqq
         uJww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=mkTk6jJ30N/x3F4AyIBMkhdrEysHqLwx5nd2q3CElLU=;
        b=g8EM6YmhvpYRYPbb1l3Jb4uDExQvKseEQSaGB7E2Cra4EtrlA96cexJv8hWHaKgRVY
         UkD6FliIdsB3Qn333RzArgr/Z02hRSSGLwNzsvr0QkkQifvOMqo+s1yXmPLFIuQMhCqw
         3LrR8//SnzW4g7noGQKDXxDpFiUYN/PZLiPWUVsyW5DRfpl0PzcanePlL7VoVSDXDKJy
         T0GQIBH70xeIeg9AvVnfLSYjMSQdNVYsuJ127syrbTlKMgSfZuxtlHxU4Ye7UkPupgrk
         rW9G+cgmqFOauoJWBqS43IsaVhCP4mwsOn2RUynuNDD+uLFyviQ9ZlEQXAbZn0xFr/YQ
         Xk/A==
X-Gm-Message-State: AOAM533GbI4J47QysIl4vh97bC9VH5dpaGcETH9xuKXH7hejXI76pT8o
        DxyvB0nLGTJmTTqPPYp36xuBtOtTO9Q=
X-Google-Smtp-Source: ABdhPJyw7NGf2k92oHzVhHWDLm02aKic69xkIBEFIN2vA+HRraI79QeKnIN4lTcF6ljYFGbczB77BA==
X-Received: by 2002:a17:90a:2809:b0:1cb:99a8:ffcd with SMTP id e9-20020a17090a280900b001cb99a8ffcdmr8452065pjd.7.1650518626541;
        Wed, 20 Apr 2022 22:23:46 -0700 (PDT)
Received: from localhost ([2406:7400:63:fca5:5639:1911:2ab6:cfe6])
        by smtp.gmail.com with ESMTPSA id cu19-20020a17090afa9300b001cd4989ff59sm988919pjb.32.2022.04.20.22.23.45
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 22:23:46 -0700 (PDT)
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, Ritesh Harjani <ritesh.list@gmail.com>
Subject: [RFC 3/6] ext4: Directly opencode ext4_set_test_dummy_encryption
Date:   Thu, 21 Apr 2022 10:53:19 +0530
Message-Id: <fd5bd9c46ebe41de0f4923d94aa7a412aa113dc5.1650517532.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <cover.1650517532.git.ritesh.list@gmail.com>
References: <cover.1650517532.git.ritesh.list@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Simplify the code by opencoding ext4_set_test_dummy_encryption(), since
there is only one caller of it and ext4_** variant in itself does nothing
special other than calling fscrypt_set_test_dummy_encryption(). This can
be done directly by opencoding it in the caller.

Signed-off-by: Ritesh Harjani <ritesh.list@gmail.com>
---
 fs/ext4/super.c | 34 ++++++++++++++--------------------
 1 file changed, 14 insertions(+), 20 deletions(-)

diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 8bb5fa15a013..e7e5c9c057d7 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -1863,24 +1863,6 @@ ext4_sb_read_encoding(const struct ext4_super_block *es)
 }
 #endif
 
-static int ext4_set_test_dummy_encryption(struct super_block *sb, char *arg)
-{
-#ifdef CONFIG_FS_ENCRYPTION
-	struct ext4_sb_info *sbi = EXT4_SB(sb);
-	int err;
-
-	err = fscrypt_set_test_dummy_encryption(sb, arg,
-						&sbi->s_dummy_enc_policy);
-	if (err) {
-		ext4_msg(sb, KERN_WARNING,
-			 "Error while setting test dummy encryption [%d]", err);
-		return err;
-	}
-	ext4_msg(sb, KERN_WARNING, "Test dummy encryption mode enabled");
-#endif
-	return 0;
-}
-
 #define EXT4_SPEC_JQUOTA			(1 <<  0)
 #define EXT4_SPEC_JQFMT				(1 <<  1)
 #define EXT4_SPEC_DATAJ				(1 <<  2)
@@ -2795,8 +2777,20 @@ static int ext4_apply_options(struct fs_context *fc, struct super_block *sb)
 
 	ext4_apply_quota_options(fc, sb);
 
-	if (ctx->spec & EXT4_SPEC_DUMMY_ENCRYPTION)
-		ret = ext4_set_test_dummy_encryption(sb, ctx->test_dummy_enc_arg);
+	if (IS_ENABLED(CONFIG_FS_ENCRYPTION) &&
+			(ctx->spec & EXT4_SPEC_DUMMY_ENCRYPTION)) {
+
+		ret = fscrypt_set_test_dummy_encryption(sb,
+						ctx->test_dummy_enc_arg,
+						&sbi->s_dummy_enc_policy);
+		if (ret) {
+			ext4_msg(sb, KERN_WARNING, "Error while setting test dummy encryption [%d]",
+				 ret);
+			return ret;
+		}
+
+		ext4_msg(sb, KERN_WARNING, "Test dummy encryption mode enabled");
+	}
 
 	return ret;
 }
-- 
2.31.1

