Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88DB558947B
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Aug 2022 00:41:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236179AbiHCWlq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 3 Aug 2022 18:41:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237699AbiHCWlq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 3 Aug 2022 18:41:46 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6D5317053
        for <linux-fscrypt@vger.kernel.org>; Wed,  3 Aug 2022 15:41:44 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id 137-20020a250b8f000000b0067a5a14d730so3924832ybl.12
        for <linux-fscrypt@vger.kernel.org>; Wed, 03 Aug 2022 15:41:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:from:to:cc;
        bh=N1kHtACpfgmsbMFbEUNB8TGQc2yWFjE8j4fZSVbhCbA=;
        b=MYrQDEJkJpZU+64tomnIuv6c0l5NBVa4NisQFtD0FqrneE7DihqpSyhx3e69gR2spk
         yu16ySBifm6pZ9bvYhHzXSCTHVjQsU1npqW5lKfTAvzk6EvnEMUe6SEkNnFBTHFUKaaW
         M2z8tV0SFYGf8uh5Ct4PtuuY6Ag+RkI0gmOFzdz9UzPsraYLR3UiY1qdK/SDGlXLBsKO
         f6ss/UyFcMGNDIow2xA2+F5B0f6CsWysuk/usIHIfrAhWnVmo77rflZwxF1vJR51Yc+e
         2OPAAIIuJN1sQZN9rQ8oVOpmVfsObaa6RsMPoFEYMoTdPtwiO6+2UFE6xhJllMfIeq2r
         RI0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:references:mime-version:message-id:in-reply-to
         :date:x-gm-message-state:from:to:cc;
        bh=N1kHtACpfgmsbMFbEUNB8TGQc2yWFjE8j4fZSVbhCbA=;
        b=GFcfrykGh4Ewua5FvQVr/e9FBsoA9bWx6EUMyOVl/vLflYv5zd/1IHhc6G+OtEB9hb
         eyXaX9BrGYEJ5CA4mBsc1aXYaIpR/DlCx5flTVxPtXMbW8QpMoPpO1xlGyGR+M5NiMGY
         TgmD4S5kLHI9I/tsoAUwOGoqlkhWUxPlj2GeCLs15hiR+ar9bG26kCif6ox4Oi2vNZe3
         zHMu6LmyP7G+HjpNeD4ZO4VCJIkDlsmKxP+mo4YOOpCaSxqrOWRgZ/fH0+L9TsJQT3AZ
         N+Jt/NGB/DCUzgLjG+920YetbVtzmOr6woURQbYu8CPGcXar4ypgMlCmukF68tItqfps
         ENcg==
X-Gm-Message-State: ACgBeo3rnYYKRvx08ErutwHX04JLb1m+GTHtnQo6HKji7++QGCuJiqvX
        HN5pGhSODe+GvgjzZf+6eK0NwSivFQ==
X-Google-Smtp-Source: AA6agR7E6hUXf8P/U7i8yZUhvHwZv/Giuv/zoxarwEYqz75rqExVfFJKDJXfw4ISTo4hI2YfKgc78Q7zbQ==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a0d:fcc7:0:b0:324:5b7b:5de6 with SMTP id
 m190-20020a0dfcc7000000b003245b7b5de6mr23086899ywf.506.1659566504273; Wed, 03
 Aug 2022 15:41:44 -0700 (PDT)
Date:   Wed,  3 Aug 2022 15:41:21 -0700
In-Reply-To: <20220803224121.420705-1-nhuck@google.com>
Message-Id: <20220803224121.420705-3-nhuck@google.com>
Mime-Version: 1.0
References: <20220803224121.420705-1-nhuck@google.com>
X-Mailer: git-send-email 2.37.1.455.g008518b4e5-goog
Subject: [PATCH v5 2/2] generic: add tests for fscrypt policies with HCTR2
From:   Nathan Huckleberry <nhuck@google.com>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,USER_IN_DEF_DKIM_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This patch adds fscrypt policy tests for filename encryption using
HCTR2.

More information on HCTR2 can be found here: "Length-preserving
encryption with HCTR2" https://ia.cr/2021/1441

Signed-off-by: Nathan Huckleberry <nhuck@google.com>
---
 tests/generic/900     | 31 +++++++++++++++++++++++++++++++
 tests/generic/900.out | 16 ++++++++++++++++
 2 files changed, 47 insertions(+)
 create mode 100755 tests/generic/900
 create mode 100644 tests/generic/900.out

diff --git a/tests/generic/900 b/tests/generic/900
new file mode 100755
index 00000000..1ff7c512
--- /dev/null
+++ b/tests/generic/900
@@ -0,0 +1,31 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2022 Google LLC
+#
+# FS QA Test No. generic/900
+#
+# Verify ciphertext for v2 encryption policies that use AES-256-XTS to encrypt
+# file contents and AES-256-HCTR2 to encrypt file names.
+#
+# HCTR2 was introduced in kernel commit 6b2a51ff03bf ("fscrypt: Add HCTR2
+# support for filename encryption")
+#
+. ./common/preamble
+_begin_fstest auto quick encrypt
+
+# Import common functions.
+. ./common/filter
+. ./common/encrypt
+
+# real QA test starts here
+_supported_fs generic
+
+_verify_ciphertext_for_encryption_policy AES-256-XTS AES-256-HCTR2 v2
+_verify_ciphertext_for_encryption_policy AES-256-XTS AES-256-HCTR2 \
+	v2 iv_ino_lblk_32
+_verify_ciphertext_for_encryption_policy AES-256-XTS AES-256-HCTR2 \
+	v2 iv_ino_lblk_64
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/900.out b/tests/generic/900.out
new file mode 100644
index 00000000..a87c80b3
--- /dev/null
+++ b/tests/generic/900.out
@@ -0,0 +1,16 @@
+QA output created by 900
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: AES-256-XTS
+	filenames_encryption_mode: AES-256-HCTR2
+	options: v2
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: AES-256-XTS
+	filenames_encryption_mode: AES-256-HCTR2
+	options: v2 iv_ino_lblk_32
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: AES-256-XTS
+	filenames_encryption_mode: AES-256-HCTR2
+	options: v2 iv_ino_lblk_64
-- 
2.37.1.455.g008518b4e5-goog

