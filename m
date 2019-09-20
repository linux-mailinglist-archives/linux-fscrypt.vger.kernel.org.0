Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32C2AB88A1
	for <lists+linux-fscrypt@lfdr.de>; Fri, 20 Sep 2019 02:38:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394032AbfITAiH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 Sep 2019 20:38:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:41822 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394234AbfITAiG (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 Sep 2019 20:38:06 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7DD512196E;
        Fri, 20 Sep 2019 00:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568939884;
        bh=rq+tUqHZoGcR0V+xR1NnK0mrUO8SXe3FdldvNKMVzx0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=vA2m5XlAdD4bcv9J853t1J5M1cQzNgwAEMl9QdOIe7B8wY6l9uD3fHWhwxkVbD94a
         xZ4ri4xpHI/ZUpRvRqf7mfnw8VePt0inVhCNL9YHB74Lr6+XsvNA7/NToglaBEf0ad
         DhcUyoIVgVeUDAb4Fo4ggJq0e1O7fHYExPeTAm0E=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 6/9] generic: add test for non-root use of fscrypt API additions
Date:   Thu, 19 Sep 2019 17:37:50 -0700
Message-Id: <20190920003753.40281-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.351.gc4317032e6-goog
In-Reply-To: <20190920003753.40281-1-ebiggers@kernel.org>
References: <20190920003753.40281-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Test non-root use of the fscrypt filesystem-level encryption keyring and
v2 encryption policies.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/801     | 144 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/801.out |  62 ++++++++++++++++++
 tests/generic/group   |   1 +
 3 files changed, 207 insertions(+)
 create mode 100755 tests/generic/801
 create mode 100644 tests/generic/801.out

diff --git a/tests/generic/801 b/tests/generic/801
new file mode 100755
index 00000000..c759ec94
--- /dev/null
+++ b/tests/generic/801
@@ -0,0 +1,144 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2019 Google LLC
+#
+# FS QA Test generic/801
+#
+# Test non-root use of the fscrypt filesystem-level encryption keyring
+# and v2 encryption policies.
+#
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+echo
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+orig_maxkeys=
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	if [ -n "$orig_maxkeys" ]; then
+		echo "$orig_maxkeys" > /proc/sys/kernel/keys/maxkeys
+	fi
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/encrypt
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_user
+_require_scratch_encryption -v 2
+
+_scratch_mkfs_encrypted &>> $seqres.full
+_scratch_mount
+
+# Set the fsgqa user's key quota to their current number of keys plus 5.
+orig_keys=$(_user_do "awk '/^[[:space:]]*$(id -u fsgqa):/{print \$4}' /proc/key-users | cut -d/ -f1")
+: ${orig_keys:=0}
+echo "orig_keys=$orig_keys" >> $seqres.full
+orig_maxkeys=$(</proc/sys/kernel/keys/maxkeys)
+keys_to_add=5
+echo $((orig_keys + keys_to_add)) > /proc/sys/kernel/keys/maxkeys
+
+dir=$SCRATCH_MNT/dir
+
+raw_key=""
+for i in `seq 64`; do
+	raw_key+="\\x$(printf "%02x" $i)"
+done
+keydesc="0000111122223333"
+keyid="69b2f6edeee720cce0577937eb8a6751"
+chmod 777 $SCRATCH_MNT
+
+_user_do "mkdir $dir"
+
+echo "# Setting v1 policy as regular user (should succeed)"
+_user_do_set_encpolicy $dir $keydesc
+
+echo "# Getting v1 policy as regular user (should succeed)"
+_user_do_get_encpolicy $dir | _filter_scratch
+
+echo "# Adding v1 policy key as regular user (should fail with EACCES)"
+_user_do_add_enckey $SCRATCH_MNT "$raw_key" -d $keydesc
+
+rm -rf $dir
+echo
+_user_do "mkdir $dir"
+
+echo "# Setting v2 policy as regular user without key already added (should fail with ENOKEY)"
+_user_do_set_encpolicy $dir $keyid |& _filter_scratch
+
+echo "# Adding v2 policy key as regular user (should succeed)"
+_user_do_add_enckey $SCRATCH_MNT "$raw_key"
+
+echo "# Setting v2 policy as regular user with key added (should succeed)"
+_user_do_set_encpolicy $dir $keyid
+
+echo "# Getting v2 policy as regular user (should succeed)"
+_user_do_get_encpolicy $dir | _filter_scratch
+
+echo "# Creating encrypted file as regular user (should succeed)"
+_user_do "echo contents > $dir/file"
+
+echo "# Removing v2 policy key as regular user (should succeed)"
+_user_do_rm_enckey $SCRATCH_MNT $keyid
+
+_scratch_cycle_mount	# Clear all keys
+
+echo
+echo "# Testing user key quota"
+for i in `seq $((keys_to_add + 1))`; do
+	rand_raw_key=$(_generate_raw_encryption_key)
+	_user_do_add_enckey $SCRATCH_MNT "$rand_raw_key" \
+	    | sed 's/ with identifier .*$//'
+done
+
+rm -rf $dir
+echo
+_user_do "mkdir $dir"
+_scratch_cycle_mount	# Clear all keys
+
+# Test multiple users adding the same key.
+echo "# Adding key as root"
+_add_enckey $SCRATCH_MNT "$raw_key"
+echo "# Getting key status as regular user"
+_user_do_enckey_status $SCRATCH_MNT $keyid
+echo "# Removing key only added by another user (should fail with ENOKEY)"
+_user_do_rm_enckey $SCRATCH_MNT $keyid
+echo "# Setting v2 encryption policy with key only added by another user (should fail with ENOKEY)"
+_user_do_set_encpolicy $dir $keyid |& _filter_scratch
+echo "# Adding second user of key"
+_user_do_add_enckey $SCRATCH_MNT "$raw_key"
+echo "# Getting key status as regular user"
+_user_do_enckey_status $SCRATCH_MNT $keyid
+echo "# Setting v2 encryption policy as regular user"
+_user_do_set_encpolicy $dir $keyid
+echo "# Removing this user's claim to the key"
+_user_do_rm_enckey $SCRATCH_MNT $keyid
+echo "# Getting key status as regular user"
+_user_do_enckey_status $SCRATCH_MNT $keyid
+echo "# Adding back second user of key"
+_user_do_add_enckey $SCRATCH_MNT "$raw_key"
+echo "# Remove key for \"all users\", as regular user (should fail with EACCES)"
+_user_do_rm_enckey $SCRATCH_MNT $keyid -a |& _filter_scratch
+_enckey_status $SCRATCH_MNT $keyid
+echo "# Remove key for \"all users\", as root"
+_rm_enckey $SCRATCH_MNT $keyid -a
+_enckey_status $SCRATCH_MNT $keyid
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/801.out b/tests/generic/801.out
new file mode 100644
index 00000000..b5b6cec8
--- /dev/null
+++ b/tests/generic/801.out
@@ -0,0 +1,62 @@
+QA output created by 801
+
+# Setting v1 policy as regular user (should succeed)
+# Getting v1 policy as regular user (should succeed)
+Encryption policy for SCRATCH_MNT/dir:
+	Policy version: 0
+	Master key descriptor: 0000111122223333
+	Contents encryption mode: 1 (AES-256-XTS)
+	Filenames encryption mode: 4 (AES-256-CTS)
+	Flags: 0x02
+# Adding v1 policy key as regular user (should fail with EACCES)
+Permission denied
+
+# Setting v2 policy as regular user without key already added (should fail with ENOKEY)
+SCRATCH_MNT/dir: failed to set encryption policy: Required key not available
+# Adding v2 policy key as regular user (should succeed)
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+# Setting v2 policy as regular user with key added (should succeed)
+# Getting v2 policy as regular user (should succeed)
+Encryption policy for SCRATCH_MNT/dir:
+	Policy version: 2
+	Master key identifier: 69b2f6edeee720cce0577937eb8a6751
+	Contents encryption mode: 1 (AES-256-XTS)
+	Filenames encryption mode: 4 (AES-256-CTS)
+	Flags: 0x02
+# Creating encrypted file as regular user (should succeed)
+# Removing v2 policy key as regular user (should succeed)
+Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+
+# Testing user key quota
+Added encryption key
+Added encryption key
+Added encryption key
+Added encryption key
+Added encryption key
+Error adding encryption key: Disk quota exceeded
+
+# Adding key as root
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+# Getting key status as regular user
+Present (user_count=1)
+# Removing key only added by another user (should fail with ENOKEY)
+Error removing encryption key: Required key not available
+# Setting v2 encryption policy with key only added by another user (should fail with ENOKEY)
+SCRATCH_MNT/dir: failed to set encryption policy: Required key not available
+# Adding second user of key
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+# Getting key status as regular user
+Present (user_count=2, added_by_self)
+# Setting v2 encryption policy as regular user
+# Removing this user's claim to the key
+Removed user's claim to encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+# Getting key status as regular user
+Present (user_count=1)
+# Adding back second user of key
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+# Remove key for "all users", as regular user (should fail with EACCES)
+Permission denied
+Present (user_count=2, added_by_self)
+# Remove key for "all users", as root
+Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+Absent
diff --git a/tests/generic/group b/tests/generic/group
index b3dc9ad1..83fccffa 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -571,3 +571,4 @@
 566 auto quick quota metadata
 567 auto quick rw punch
 800 auto quick encrypt
+801 auto quick encrypt
-- 
2.23.0.351.gc4317032e6-goog

