Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BEC768A522
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 19:58:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726800AbfHLR6t (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 13:58:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:53816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbfHLR6s (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 13:58:48 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 06DFD20820;
        Mon, 12 Aug 2019 17:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565632727;
        bh=wSBgZ+VS/jzugej8msKGGFw2U3nE6eExO6gRC8sweVI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=gO1ZUXOVlazKyuBGD4Y97mko4tsA4zykHMlj2F6eapQoUhHhOuLwsytafZtpz10++
         dKb7XO8IK+pbJo38yK574OCnjjFSpUmgqE1MHkjJ6m0Wl3uzwvcYbmunwa3+YxaqVL
         BNE+bvU57jdQvNErq6OELnTQ4tHjhfBkE0NbF3Qo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 6/9] generic: add test for non-root use of fscrypt API additions
Date:   Mon, 12 Aug 2019 10:58:06 -0700
Message-Id: <20190812175809.34810-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
In-Reply-To: <20190812175809.34810-1-ebiggers@kernel.org>
References: <20190812175809.34810-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Test non-root use of thte fscrypt filesystem-level encryption keyring
and v2 encryption policies.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/801     | 136 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/801.out |  62 +++++++++++++++++++
 tests/generic/group   |   1 +
 3 files changed, 199 insertions(+)
 create mode 100755 tests/generic/801
 create mode 100644 tests/generic/801.out

diff --git a/tests/generic/801 b/tests/generic/801
new file mode 100755
index 00000000..dc306315
--- /dev/null
+++ b/tests/generic/801
@@ -0,0 +1,136 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2019 Google LLC
+#
+# FS QA Test generic/801
+#
+# Test non-root use of fscrypt filesystem-level encryption keyring
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
+orig_maxkeys=$(</proc/sys/kernel/keys/maxkeys)
+maxkeys=5
+echo $maxkeys > /proc/sys/kernel/keys/maxkeys
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	echo $orig_maxkeys > /proc/sys/kernel/keys/maxkeys
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
+for i in `seq $((maxkeys + 1))`; do
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
index 5be46357..4bc4772a 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -569,3 +569,4 @@
 564 auto quick copy_range
 565 auto quick copy_range
 800 auto quick encrypt
+801 auto quick encrypt
-- 
2.23.0.rc1.153.gdeed80330f-goog

