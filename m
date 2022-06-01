Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B4F539E01
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Jun 2022 09:18:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350237AbiFAHSt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 1 Jun 2022 03:18:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35960 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350251AbiFAHSr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 1 Jun 2022 03:18:47 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79AE04993C
        for <linux-fscrypt@vger.kernel.org>; Wed,  1 Jun 2022 00:18:45 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id 85-20020a250358000000b0065b9b24987aso756997ybd.4
        for <linux-fscrypt@vger.kernel.org>; Wed, 01 Jun 2022 00:18:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=tqVQPGkdfthzc1F/K+tWIJalB7pkWil9X53565hwH3Y=;
        b=F1S7jTIkzDSQklI+WWyiC36tHK7vgpLE7T3ITKGGS4ytU8icoFAdhLwkuRCbw5KJ7D
         p9bIqc88lU0VPUyTr/XTed8g5nk0Sxw4EauCwuoOKAkAMaGaffgkmu+9cDAbLKO7grMe
         lVFvFO+IaFqfgf0VC5D2TNtRs4kvlE+mENFcvgoG0b+p3lx5bH6/SsMK4bMnRvtbNlcy
         eiOYfB7SsMW2enuoh3c9bsM5CfmKgKPwXjMGqhqXhHbZy+QPcVytG59RZi8FX9SoAwjV
         JgGi63qqZf1+WC68Ip20NnLwzIv/Tmmr457/2GX3HWq1rl36KZ26pMCtdHCvOvzOMHPq
         cYSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=tqVQPGkdfthzc1F/K+tWIJalB7pkWil9X53565hwH3Y=;
        b=HKGAME2ZuDIzglwvWARPYnrvFYw/lhu/Waa7zTxlUUtPaFvmy2pEFh8r5I0401CSsg
         edrSQKmigvSAwcEVTY1Y84SjuCI9he3qVRKJc7EGGhBGdwybA/k2BicIlNGQIeOo67bF
         oLHz/ZpFZsAHc8fADugNeYs1JqwLQAI4fxn1z0dt3K26pl7kokcEAtTv7ufn/C0HlIVr
         aB3mdnpHD7zgkjKfKe+LizIsDalzt9Ry5/Wy2zz+MUzGFb58ABdlYxWhjVEJzQjdpzoh
         VcdEpI8r4FD0kN1GbDyBdBLSK3df1iecTNhM6sGoWPtlhKnQinMdQg4MV4Qm6WgdjtPL
         +bew==
X-Gm-Message-State: AOAM5330lULz6eJwdcXOJEjuOYq62fPEEWlIWCRKkjrwz/uzS+Bdht+p
        1n/7OT0gM9mM0WkPVqkK2Z9G5TAbaA==
X-Google-Smtp-Source: ABdhPJyui7IpFCc5mQX6aSovBaYWFvlQoXytuIehDtyRjxlTw8tXpZmmJP8g2lDYp5iLqt1O3Vg8XMMrTA==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a25:3a86:0:b0:64f:d513:104 with SMTP id
 h128-20020a253a86000000b0064fd5130104mr44013226yba.314.1654067924577; Wed, 01
 Jun 2022 00:18:44 -0700 (PDT)
Date:   Wed,  1 Jun 2022 00:18:11 -0700
In-Reply-To: <20220601071811.1353635-1-nhuck@google.com>
Message-Id: <20220601071811.1353635-3-nhuck@google.com>
Mime-Version: 1.0
References: <20220601071811.1353635-1-nhuck@google.com>
X-Mailer: git-send-email 2.36.1.255.ge46751e96f-goog
Subject: [RFC PATCH v4 2/2] generic: add tests for fscrypt policies with HCTR2
From:   Nathan Huckleberry <nhuck@google.com>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
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
 tests/generic/900     | 28 ++++++++++++++++++++++++++++
 tests/generic/900.out | 16 ++++++++++++++++
 2 files changed, 44 insertions(+)
 create mode 100755 tests/generic/900
 create mode 100644 tests/generic/900.out

diff --git a/tests/generic/900 b/tests/generic/900
new file mode 100755
index 00000000..d1496007
--- /dev/null
+++ b/tests/generic/900
@@ -0,0 +1,28 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2022 Google LLC
+#
+# FS QA Test No. generic/900
+#
+# Verify ciphertext for v2 encryption policies that use AES-256-XTS to encrypt
+# file contents and AES-256-HCTR2 to encrypt file names.
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
2.36.1.255.ge46751e96f-goog

