Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1558D4C640D
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Feb 2022 08:49:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233721AbiB1Htg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Feb 2022 02:49:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbiB1Hte (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Feb 2022 02:49:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39DE23D1D2;
        Sun, 27 Feb 2022 23:48:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72162610A4;
        Mon, 28 Feb 2022 07:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2854CC36AE3;
        Mon, 28 Feb 2022 07:48:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646034535;
        bh=dNhFGMROSIDvPCnQSBawc2ub7nxSShPfueI2bzsEfMg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=CFLzk888PsDt/RXZezLtV6WOwbd+ubyx26G96Nu2AmrslHMmvif2czdBzcFVZgoBC
         +rudEBCrT0p7dORa3edlu7/mxBhGQIPI35oBF7cDf+GTsVxGztWoWdmBpziCY32aiw
         K3PcgYg1pO4oxZ0/4QcgN4EatGCrkqGwb8o+0BFPkOw5dtn+0DNVAIT+AvIO3ErALm
         BncYn7mzzb39C/e7fInqH38Oihi1WsRTo7H3fShyqr0c91Ua2P76nFdwVR1UGx5FHS
         lSMTQk19ivZj8rQajRMB/keknSdXH3QaVQP/hmgZkl9hhJ8QoUIE5yly+YqC+EqHDR
         w4P//ZBGHGKLw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [RFC PATCH 8/8] generic: verify ciphertext with hardware-wrapped keys
Date:   Sun, 27 Feb 2022 23:47:22 -0800
Message-Id: <20220228074722.77008-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228074722.77008-1-ebiggers@kernel.org>
References: <20220228074722.77008-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add two tests which verify that encrypted files are encrypted correctly
when a hardware-wrapped inline encryption key is used.  The two tests
are identical except that one uses FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64
and the other uses FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32.  These cover both
of the settings where hardware-wrapped keys currently may be used.

I've verified that these tests run and pass when all prerequisites are
met, namely:

- Hardware supporting the feature must be present.  I tested this on the
  SM8350 HDK (note: this currently requires a custom TrustZone image);
  this hardware is compatible with both of IV_INO_LBLK_{64,32}.
- The kernel patches for hardware-wrapped key support must be applied.
- The filesystem must be ext4 or f2fs.
- The kernel must have CONFIG_FS_ENCRYPTION_INLINE_CRYPT=y.
- The fscryptctl program must be available, and must have patches for
  hardware-wrapped key support applied.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/900     | 30 ++++++++++++++++++++++++++++++
 tests/generic/900.out |  6 ++++++
 tests/generic/901     | 30 ++++++++++++++++++++++++++++++
 tests/generic/901.out |  6 ++++++
 4 files changed, 72 insertions(+)
 create mode 100755 tests/generic/900
 create mode 100644 tests/generic/900.out
 create mode 100755 tests/generic/901
 create mode 100644 tests/generic/901.out

diff --git a/tests/generic/900 b/tests/generic/900
new file mode 100755
index 00000000..a021732e
--- /dev/null
+++ b/tests/generic/900
@@ -0,0 +1,30 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2022 Google LLC
+#
+# FS QA Test No. 900
+#
+# Verify the ciphertext for encryption policies that use the HW_WRAPPED_KEY and
+# IV_INO_LBLK_64 flags and that use AES-256-XTS to encrypt file contents and
+# AES-256-CTS-CBC to encrypt file names.
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
+# Hardware-wrapped keys require the inlinecrypt mount option.
+_require_scratch_inlinecrypt
+export MOUNT_OPTIONS="$MOUNT_OPTIONS -o inlinecrypt"
+
+_verify_ciphertext_for_encryption_policy AES-256-XTS AES-256-CTS-CBC \
+	v2 iv_ino_lblk_64 hw_wrapped_key
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/900.out b/tests/generic/900.out
new file mode 100644
index 00000000..9edc012c
--- /dev/null
+++ b/tests/generic/900.out
@@ -0,0 +1,6 @@
+QA output created by 900
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: AES-256-XTS
+	filenames_encryption_mode: AES-256-CTS-CBC
+	options: v2 iv_ino_lblk_64 hw_wrapped_key
diff --git a/tests/generic/901 b/tests/generic/901
new file mode 100755
index 00000000..dd5c6e5f
--- /dev/null
+++ b/tests/generic/901
@@ -0,0 +1,30 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2022 Google LLC
+#
+# FS QA Test No. 901
+#
+# Verify the ciphertext for encryption policies that use the HW_WRAPPED_KEY and
+# IV_INO_LBLK_32 flags and that use AES-256-XTS to encrypt file contents and
+# AES-256-CTS-CBC to encrypt file names.
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
+# Hardware-wrapped keys require the inlinecrypt mount option.
+_require_scratch_inlinecrypt
+export MOUNT_OPTIONS="$MOUNT_OPTIONS -o inlinecrypt"
+
+_verify_ciphertext_for_encryption_policy AES-256-XTS AES-256-CTS-CBC \
+	v2 iv_ino_lblk_32 hw_wrapped_key
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/901.out b/tests/generic/901.out
new file mode 100644
index 00000000..2f928465
--- /dev/null
+++ b/tests/generic/901.out
@@ -0,0 +1,6 @@
+QA output created by 901
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: AES-256-XTS
+	filenames_encryption_mode: AES-256-CTS-CBC
+	options: v2 iv_ino_lblk_32 hw_wrapped_key
-- 
2.35.1

