Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E29157C7D98
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Oct 2023 08:17:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbjJMGRf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 13 Oct 2023 02:17:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjJMGRe (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 13 Oct 2023 02:17:34 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76CA8C0;
        Thu, 12 Oct 2023 23:17:32 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1246DC433CB;
        Fri, 13 Oct 2023 06:17:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697177852;
        bh=2JJTJo8b65JYNmloSNwbmqkTtFlcw6toD5B2mqpjEX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Qj5tGSyGdFljlOF9tdscHfqdJLj3G4Yfo/XywtV7ODcJZ3ER60Kb4Dy4IuAXVBUxv
         +9/GDxb76yctBEYtqORNE3RQpHykEznbbzJfCfFVhWXamN1hFaKmp2Mnj+A+jfOcn2
         lMwINzc8lNt5kOxHiNt5BWaUsupzW+JKKffcQ17rHzbTufO0hW/+xrgqVZaRQfJk7x
         QoHSbtdr7JLaHgyffC6kBSh68lV9Dj/GGi6/pKx/rPnbkbdrB4PXq9E7vFFEAUI8ui
         sB4fjcnp/MlYV+qy5ZqLwxXLP/Y0O6wMCdEnohZHA7T7SeOORg+ARI4bmow1s42WTq
         wf+/u7RcZR8jQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 4/4] generic: add test for custom crypto data unit size
Date:   Thu, 12 Oct 2023 23:14:03 -0700
Message-ID: <20231013061403.138425-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231013061403.138425-1-ebiggers@kernel.org>
References: <20231013061403.138425-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a test that verifies the on-disk format of encrypted files that use
a crypto data unit size that differs from the filesystem block size.
This tests the functionality that was introduced by the kernel patch
"fscrypt: support crypto data unit size less than filesystem block size"
(https://lore.kernel.org/linux-fscrypt/20230925055451.59499-6-ebiggers@kernel.org).

This depends on an xfsprogs patch that adds the '-s' option to the
set_encpolicy command of xfs_io, allowing the new log2_data_unit_size
field to be set via a shell script.

As usual, the test skips itself when any prerequisite isn't met.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/900     | 27 +++++++++++++++++++++++++++
 tests/generic/900.out | 11 +++++++++++
 2 files changed, 38 insertions(+)
 create mode 100755 tests/generic/900
 create mode 100644 tests/generic/900.out

diff --git a/tests/generic/900 b/tests/generic/900
new file mode 100755
index 00000000..b18d9f6a
--- /dev/null
+++ b/tests/generic/900
@@ -0,0 +1,27 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2023 Google LLC
+#
+# FS QA Test No. generic/900
+#
+# Verify the on-disk format of encrypted files that use a crypto data unit size
+# that differs from the filesystem block size.
+#
+. ./common/preamble
+_begin_fstest auto quick encrypt
+
+. ./common/filter
+. ./common/encrypt
+
+_supported_fs generic
+
+# For now, just test 512-byte and 1024-byte data units.  Filesystems accept
+# power-of-2 sizes between 512 and the filesystem block size, inclusively.
+# Testing 512 and 1024 ensures this test will run for any FS block size >= 1024
+# (provided that the filesystem supports sub-block data units at all).
+_verify_ciphertext_for_encryption_policy AES-256-XTS AES-256-CTS-CBC v2 log2_dusize=9
+_verify_ciphertext_for_encryption_policy AES-256-XTS AES-256-CTS-CBC v2 log2_dusize=10
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/900.out b/tests/generic/900.out
new file mode 100644
index 00000000..3259f08c
--- /dev/null
+++ b/tests/generic/900.out
@@ -0,0 +1,11 @@
+QA output created by 900
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: AES-256-XTS
+	filenames_encryption_mode: AES-256-CTS-CBC
+	options: v2 log2_dusize=9
+
+Verifying ciphertext with parameters:
+	contents_encryption_mode: AES-256-XTS
+	filenames_encryption_mode: AES-256-CTS-CBC
+	options: v2 log2_dusize=10
-- 
2.42.0

