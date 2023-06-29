Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5569174304A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Jun 2023 00:17:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231849AbjF2WRu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Jun 2023 18:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231718AbjF2WRq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Jun 2023 18:17:46 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF2882707;
        Thu, 29 Jun 2023 15:17:45 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 067A5809D5;
        Thu, 29 Jun 2023 18:17:44 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688077065; bh=s9IkOPswFcoMbSUPlHIx6NlUBPocYX+B+nK2H9PE4AU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=MAlqqSWscwBcr8WOLjtTPx1/YFsQfdyqL/1NtKBq/Dj74Zn0WWltXR0T0RaHQbntM
         zu4mqa3UaFN7Sz2TpJhX5dU4aBOpwuqDdTfKHIHuWXGArhHUvrfhI9tW+Wi3fWXcku
         wpVIxQyCDbSb6T8AqfzXejfunhVqtS5PjHlZTR234WbI9+sGaCdY16HrEuaH+b5pxJ
         Vi0SJsdPTIpu9q2OpXtGPYVd5jUK5LulEeAuNQRlLcUo7y57Vsh8Uu+BR5YAhGsD8s
         gpwD+R/RJK0FmXJfgvgLnGjeBelT2sedNILdkiZf/mv4ik8s8pzyNk3wJ+RaGg13Ww
         WCLctJLwlM+kg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@meta.com, ebiggers@google.com, anand.jain@oracle.com,
        fdmanana@suse.com, linux-fscrypt@vger.kernel.org,
        fsverity@lists.linux.dev, zlang@kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 8/8] btrfs: add simple test of reflink of encrypted data
Date:   Thu, 29 Jun 2023 18:17:23 -0400
Message-Id: <dbf938dfa6828b9307759c89a48237b16dbcb5a3.1688076612.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1688076612.git.sweettea-kernel@dorminy.me>
References: <cover.1688076612.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Make sure that we succeed at reflinking encrypted data.

Test deliberately numbered with a high number so it won't conflict with
tests between now and merge.
---
 tests/btrfs/613     | 62 +++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/613.out | 13 ++++++++++
 2 files changed, 75 insertions(+)
 create mode 100755 tests/btrfs/613
 create mode 100644 tests/btrfs/613.out

diff --git a/tests/btrfs/613 b/tests/btrfs/613
new file mode 100755
index 00000000..93c209c4
--- /dev/null
+++ b/tests/btrfs/613
@@ -0,0 +1,62 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2023 YOUR NAME HERE.  All Rights Reserved.
+#
+# FS QA Test 613
+#
+# Check if reflinking one encrypted file on btrfs succeeds.
+#
+. ./common/preamble
+_begin_fstest auto encrypt
+
+# Import common functions.
+. ./common/encrypt
+. ./common/filter
+. ./common/reflink
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs btrfs
+
+_require_test
+_require_scratch
+_require_cp_reflink
+_require_scratch_encryption -v 2
+_require_command "$KEYCTL_PROG" keyctl
+
+_scratch_mkfs_encrypted &>> $seqres.full
+_scratch_mount
+
+dir=$SCRATCH_MNT/dir
+mkdir $dir
+_set_encpolicy $dir $TEST_KEY_IDENTIFIER
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
+echo "Creating and reflinking a file"
+$XFS_IO_PROG -t -f -c "pwrite 0 33k" $dir/test > /dev/null
+sync
+cp --reflink=always $dir/test $dir/test2
+sync
+
+echo "Can't reflink encrypted and unencrypted"
+cp --reflink=always $dir/test $SCRATCH_MNT/fail |& _filter_scratch
+
+echo "Diffing the file and its copy"
+diff $dir/test $dir/test2
+
+echo "Verifying the files are reflinked"
+_verify_reflink $dir/test $dir/test2
+
+echo "Diffing the files after remount"
+_scratch_cycle_mount
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
+diff $dir/test $dir/test2
+
+echo "Diffing the files after key remove"
+echo 2 > /proc/sys/vm/drop_caches
+_rm_enckey $SCRATCH_MNT $TEST_KEY_IDENTIFIER
+diff $dir/test $dir/test2 |& _filter_scratch
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/613.out b/tests/btrfs/613.out
new file mode 100644
index 00000000..4895d6dd
--- /dev/null
+++ b/tests/btrfs/613.out
@@ -0,0 +1,13 @@
+QA output created by 613
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+Creating and reflinking a file
+Can't reflink encrypted and unencrypted
+cp: failed to clone 'SCRATCH_MNT/fail' from 'SCRATCH_MNT/dir/test': Invalid argument
+Diffing the file and its copy
+Verifying the files are reflinked
+Diffing the files after remount
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+Diffing the files after key remove
+Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+diff: SCRATCH_MNT/dir/test: No such file or directory
+diff: SCRATCH_MNT/dir/test2: No such file or directory
-- 
2.40.1

