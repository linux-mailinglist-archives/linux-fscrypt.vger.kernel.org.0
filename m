Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A8425096A7
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Apr 2022 07:23:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1378720AbiDUF01 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Apr 2022 01:26:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbiDUF0Z (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Apr 2022 01:26:25 -0400
Received: from mail-pg1-x52d.google.com (mail-pg1-x52d.google.com [IPv6:2607:f8b0:4864:20::52d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7053EDFAB;
        Wed, 20 Apr 2022 22:23:37 -0700 (PDT)
Received: by mail-pg1-x52d.google.com with SMTP id r83so3741221pgr.2;
        Wed, 20 Apr 2022 22:23:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=6TLmqQdfX4YkZzTLAR0rl7KghqQxWM9b+06k+s5s34E=;
        b=KgB0v4CyaZksf924eGUftWqDhu3QSb+51gwgaAmkENKuVy4kX4gevOjinZmqPsAt2b
         7fee0go6Eih8NF7lBpDgm2lG5zWcEDvjZoJ1M9x3mWVeypJM0EV0ESMU7MmeI8po1fsR
         vk0683XdRkQ+mY1SzWIpa8K+/UBrTsQzO/4smYGYJ0Zr1bEw8MNqF+CfwtfEykCkYS95
         Iyr21DNJm8IwZtknLm0M4TLceXs0Smb3xnuYot1T7kzT0DBvmTwhFpl5qD9ySnb6Si62
         NmuBgHZ0KGOqQuwXwcFC1s6EJGjqXJ4SxDZ2mRMcFFWxUZJ/WAxY0PhTZmTKv/HFbxfR
         UYww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=6TLmqQdfX4YkZzTLAR0rl7KghqQxWM9b+06k+s5s34E=;
        b=ioxZt7UqIIjmfwZPKZWwzGQ4gG3rll9jjnb3OZFil/MqIFTT/1A28YUzXwkzku+ROg
         yufH0SqOJKuDw4TW3C3AdC5MveVHRFomGWYhtuZXwpgNn7b7njwzgIYmejmH22gEO4Tm
         fmAMJRBKH58NxzcD5Lm2gGwNp1m/PeHoUPxYRYMi9siY5JVWgCoEM7ULp3F39E8kfR05
         VIlqa0Q0g1PBY8/k6CAUyWqfEKV+1/HzAc4CcsztgRyYUH4FBES86ooLVLeoWvCTOfQW
         JNaoZgY3Nw3Ba+6K0NnUF9L8g8pByvvXy1m2RACZHqNw1zaG6eUs5+ZO1tbiWeNEh0nq
         UeEA==
X-Gm-Message-State: AOAM533wOkl4kWlpepS/Zh4Sk9hlZJ567stTkHXrVVjrhG+Kr+JA18T5
        gIgLorFMSmI2VpGrzRLZFZa7vkdcKY8=
X-Google-Smtp-Source: ABdhPJyloJo/16EbPc21doM3ov6i/2iOsRHAIMkz8uE4CciBV6O0+f4dfRV29osVWMX+UUb0OW/x8g==
X-Received: by 2002:a63:f047:0:b0:399:24bb:7fa1 with SMTP id s7-20020a63f047000000b0039924bb7fa1mr21948501pgj.397.1650518616846;
        Wed, 20 Apr 2022 22:23:36 -0700 (PDT)
Received: from localhost ([2406:7400:63:fca5:5639:1911:2ab6:cfe6])
        by smtp.gmail.com with ESMTPSA id u10-20020a17090a890a00b001cb14240c4csm1119494pjn.1.2022.04.20.22.23.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 22:23:36 -0700 (PDT)
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, Ritesh Harjani <ritesh.list@gmail.com>
Subject: [RFC 1/6] fscrypt: Provide definition of fscrypt_set_test_dummy_encryption
Date:   Thu, 21 Apr 2022 10:53:17 +0530
Message-Id: <c71206cd78eecee74f896c4a428c9f8e65b71bc3.1650517532.git.ritesh.list@gmail.com>
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

Provide definition of fscrypt_set_test_dummy_encryption() when
CONFIG_FS_ENCRYPTION is disabled. This then returns -EOPNOTSUPP.

Signed-off-by: Ritesh Harjani <ritesh.list@gmail.com>
---
 include/linux/fscrypt.h | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 91ea9477e9bd..18dd6048bab3 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -467,6 +467,13 @@ static inline int fscrypt_set_context(struct inode *inode, void *fs_data)
 struct fscrypt_dummy_policy {
 };
 
+static inline int fscrypt_set_test_dummy_encryption(struct super_block *sb,
+				const char *arg,
+				struct fscrypt_dummy_policy *dummy_policy)
+{
+	return -EOPNOTSUPP;
+}
+
 static inline void fscrypt_show_test_dummy_encryption(struct seq_file *seq,
 						      char sep,
 						      struct super_block *sb)
-- 
2.31.1

