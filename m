Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BB5A7C4123
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbjJJU0f (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:26:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234632AbjJJU0c (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:26:32 -0400
Received: from mail-yb1-xb31.google.com (mail-yb1-xb31.google.com [IPv6:2607:f8b0:4864:20::b31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDCABC9
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:26:27 -0700 (PDT)
Received: by mail-yb1-xb31.google.com with SMTP id 3f1490d57ef6-d9a516b015cso1473984276.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:26:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696969587; x=1697574387; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=nCU5pMZ0m3eAagSN+le1r3UM58vPGnqfNmWJ/pF9FlI=;
        b=N0wBgkc2d5Tkqg+iNcNW3Lqpbmjb4x2AeSjVurIRNV9RGQxg9X83htpUvm0Gdb3jxw
         NmF43S/5e341s31BENtdXmmsU1RnIEIPThaCy5Sw/tjFv6qN5V6qpsPiTVjeu4CJm5kH
         J8vbuO/C/UeX+QpkQ3lbnypnkRmsi4fa0g74pLjsybWjrS5wVZQWdxIDUlhBmCnVKH8l
         7wkfwzqapKWk1C/ufrlUu9pAnpnyu2Zme+vaPmvqK74psn9oN5hZphEs58Fl0DyeigPh
         n3dfJFvsW47hdeDyxY3tCrtB0JkjlStxo2KxOOoYh/CDGsThfxHCsUIRE0NiQLvtn8MN
         n+tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696969587; x=1697574387;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=nCU5pMZ0m3eAagSN+le1r3UM58vPGnqfNmWJ/pF9FlI=;
        b=k1GhdAHqO82CS3+1ju10kVQKRFs5hOtD5quSy1iml0pZzInY7Tl+aJsWbwxTLLTdmQ
         c35KWQRrdLGILt+1KmS4MuBaWyu/u2KHwZo6HMH8W6CHGG4kzpfEE1UnEvAwyn5VmixI
         kNRkjZm9SFJXQIt15aFpQ3xGtdhQuo3p4aAMStplRiiqYNHva+l3/wGtiY58tGCpqOFH
         F4FD6BhvGjumFeknq15PSO+8Esw7aPxd7zaTZbf8YOyqEbTcslEJ2U9YjzAFxjUwRAB+
         kMdZQLj/p+DSYBlbKWHOn47p/hw0Nt9GD9VmI8K81cSTQk+ckSUwmUqfrX57IHd6iJ12
         Hxxg==
X-Gm-Message-State: AOJu0YyHQHQ+DXDyN1P7fyesoKcLZh7NghTPjpS44MfkI+Rg5adwU41y
        GcFuaJOPRG5w/XQwJMDmsC2FjxqQI4STZf+msXLeWw==
X-Google-Smtp-Source: AGHT+IEnYO8liLS81q3dOYpjTVcFTD241g3yDLfTZ44VO54mhYjCFyeio+o8MlAwl2q8YA/MIf3scg==
X-Received: by 2002:a25:3308:0:b0:d9a:3801:aed8 with SMTP id z8-20020a253308000000b00d9a3801aed8mr4648166ybz.14.1696969586907;
        Tue, 10 Oct 2023 13:26:26 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id x142-20020a25ce94000000b00d89679f6d22sm786655ybe.64.2023.10.10.13.26.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:26:26 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 09/12] fstests: split generic/580 into two tests
Date:   Tue, 10 Oct 2023 16:26:02 -0400
Message-ID: <ecf95cca70aa11c64455893ea823ec8de0249cf5.1696969376.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696969376.git.josef@toxicpanda.com>
References: <cover.1696969376.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

generic/580 tests both v1 and v2 encryption policies, however btrfs only
supports v2 policies.  Split this into two tests so that we can get the
v2 coverage for btrfs.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 tests/generic/580     | 118 ++++++++++++++++++------------------------
 tests/generic/580.out |  40 --------------
 tests/generic/733     |  79 ++++++++++++++++++++++++++++
 tests/generic/733.out |  44 ++++++++++++++++
 4 files changed, 173 insertions(+), 108 deletions(-)
 create mode 100644 tests/generic/733
 create mode 100644 tests/generic/733.out

diff --git a/tests/generic/580 b/tests/generic/580
index 73f32ff9..63ab9712 100755
--- a/tests/generic/580
+++ b/tests/generic/580
@@ -5,7 +5,7 @@
 # FS QA Test generic/580
 #
 # Basic test of the fscrypt filesystem-level encryption keyring
-# and v2 encryption policies.
+# policy.
 #
 
 . ./common/preamble
@@ -18,80 +18,62 @@ echo
 
 # real QA test starts here
 _supported_fs generic
-_require_scratch_encryption -v 2
+_require_scratch_encryption 
 
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 
-test_with_policy_version()
-{
-	local vers=$1
-
-	if (( vers == 1 )); then
-		local keyspec=$TEST_KEY_DESCRIPTOR
-		local add_enckey_args="-d $keyspec"
-	else
-		local keyspec=$TEST_KEY_IDENTIFIER
-		local add_enckey_args=""
-	fi
-
-	mkdir $dir
-	echo "# Setting v$vers encryption policy"
-	_set_encpolicy $dir $keyspec
-	echo "# Getting v$vers encryption policy"
-	_get_encpolicy $dir | _filter_scratch
-	if (( vers == 1 )); then
-		echo "# Getting v1 encryption policy using old ioctl"
-		_get_encpolicy $dir -1 | _filter_scratch
-	fi
-	echo "# Trying to create file without key added yet"
-	$XFS_IO_PROG -f $dir/file |& _filter_scratch
-	echo "# Getting encryption key status"
-	_enckey_status $SCRATCH_MNT $keyspec
-	echo "# Adding encryption key"
-	_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY" $add_enckey_args
-	echo "# Creating encrypted file"
-	echo contents > $dir/file
-	echo "# Getting encryption key status"
-	_enckey_status $SCRATCH_MNT $keyspec
-	echo "# Removing encryption key"
-	_rm_enckey $SCRATCH_MNT $keyspec
-	echo "# Getting encryption key status"
-	_enckey_status $SCRATCH_MNT $keyspec
-	echo "# Verifying that the encrypted directory was \"locked\""
-	cat $dir/file |& _filter_scratch
-	cat "$(find $dir -type f)" |& _filter_scratch | cut -d ' ' -f3-
-
-	# Test removing key with a file open.
-	echo "# Re-adding encryption key"
-	_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY" $add_enckey_args
-	echo "# Creating another encrypted file"
-	echo foo > $dir/file2
-	echo "# Removing key while an encrypted file is open"
-	exec 3< $dir/file
-	_rm_enckey $SCRATCH_MNT $keyspec
-	echo "# Non-open file should have been evicted"
-	cat $dir/file2 |& _filter_scratch
-	echo "# Open file shouldn't have been evicted"
-	cat $dir/file
-	echo "# Key should be in \"incompletely removed\" state"
-	_enckey_status $SCRATCH_MNT $keyspec
-	echo "# Closing file and removing key for real now"
-	exec 3<&-
-	_rm_enckey $SCRATCH_MNT $keyspec
-	cat $dir/file |& _filter_scratch
-
-	echo "# Cleaning up"
-	rm -rf $dir
-	_scratch_cycle_mount	# Clear all keys
-	echo
-}
-
 dir=$SCRATCH_MNT/dir
+keyspec=$TEST_KEY_DESCRIPTOR
 
-test_with_policy_version 1
+mkdir $dir
+echo "# Setting v1 encryption policy"
+_set_encpolicy $dir $keyspec
+echo "# Getting v1 encryption policy"
+_get_encpolicy $dir | _filter_scratch
+echo "# Getting v1 encryption policy using old ioctl"
+_get_encpolicy $dir -1 | _filter_scratch
+echo "# Trying to create file without key added yet"
+$XFS_IO_PROG -f $dir/file |& _filter_scratch
+echo "# Getting encryption key status"
+_enckey_status $SCRATCH_MNT $keyspec
+echo "# Adding encryption key"
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY" -d $keyspec
+echo "# Creating encrypted file"
+echo contents > $dir/file
+echo "# Getting encryption key status"
+_enckey_status $SCRATCH_MNT $keyspec
+echo "# Removing encryption key"
+_rm_enckey $SCRATCH_MNT $keyspec
+echo "# Getting encryption key status"
+_enckey_status $SCRATCH_MNT $keyspec
+echo "# Verifying that the encrypted directory was \"locked\""
+cat $dir/file |& _filter_scratch
+cat "$(find $dir -type f)" |& _filter_scratch | cut -d ' ' -f3-
 
-test_with_policy_version 2
+# Test removing key with a file open.
+echo "# Re-adding encryption key"
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY" -d $keyspec
+echo "# Creating another encrypted file"
+echo foo > $dir/file2
+echo "# Removing key while an encrypted file is open"
+exec 3< $dir/file
+_rm_enckey $SCRATCH_MNT $keyspec
+echo "# Non-open file should have been evicted"
+cat $dir/file2 |& _filter_scratch
+echo "# Open file shouldn't have been evicted"
+cat $dir/file
+echo "# Key should be in \"incompletely removed\" state"
+_enckey_status $SCRATCH_MNT $keyspec
+echo "# Closing file and removing key for real now"
+exec 3<&-
+_rm_enckey $SCRATCH_MNT $keyspec
+cat $dir/file |& _filter_scratch
+
+echo "# Cleaning up"
+rm -rf $dir
+_scratch_cycle_mount	# Clear all keys
+echo
 
 echo "# Trying to remove absent key"
 _rm_enckey $SCRATCH_MNT abcdabcdabcdabcd
diff --git a/tests/generic/580.out b/tests/generic/580.out
index 989d4514..f2f4d490 100644
--- a/tests/generic/580.out
+++ b/tests/generic/580.out
@@ -47,45 +47,5 @@ Removed encryption key with descriptor 0000111122223333
 cat: SCRATCH_MNT/dir/file: No such file or directory
 # Cleaning up
 
-# Setting v2 encryption policy
-# Getting v2 encryption policy
-Encryption policy for SCRATCH_MNT/dir:
-	Policy version: 2
-	Master key identifier: 69b2f6edeee720cce0577937eb8a6751
-	Contents encryption mode: 1 (AES-256-XTS)
-	Filenames encryption mode: 4 (AES-256-CTS)
-	Flags: 0x02
-# Trying to create file without key added yet
-SCRATCH_MNT/dir/file: Required key not available
-# Getting encryption key status
-Absent
-# Adding encryption key
-Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
-# Creating encrypted file
-# Getting encryption key status
-Present (user_count=1, added_by_self)
-# Removing encryption key
-Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
-# Getting encryption key status
-Absent
-# Verifying that the encrypted directory was "locked"
-cat: SCRATCH_MNT/dir/file: No such file or directory
-Required key not available
-# Re-adding encryption key
-Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
-# Creating another encrypted file
-# Removing key while an encrypted file is open
-Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751, but files still busy
-# Non-open file should have been evicted
-cat: SCRATCH_MNT/dir/file2: Required key not available
-# Open file shouldn't have been evicted
-contents
-# Key should be in "incompletely removed" state
-Incompletely removed
-# Closing file and removing key for real now
-Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
-cat: SCRATCH_MNT/dir/file: No such file or directory
-# Cleaning up
-
 # Trying to remove absent key
 Error removing encryption key: Required key not available
diff --git a/tests/generic/733 b/tests/generic/733
new file mode 100644
index 00000000..ae0434fb
--- /dev/null
+++ b/tests/generic/733
@@ -0,0 +1,79 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+#
+# FS QA Test generic/733
+#
+# A v2 only version of generic/580
+
+. ./common/preamble
+_begin_fstest auto quick encrypt
+echo
+
+# Import common functions.
+. ./common/filter
+. ./common/encrypt
+
+# real QA test starts here
+_supported_fs generic
+_require_scratch_encryption -v 2
+
+_scratch_mkfs_encrypted &>> $seqres.full
+_scratch_mount
+
+keyspec=$TEST_KEY_IDENTIFIER
+dir=$SCRATCH_MNT/dir
+
+mkdir $dir
+echo "# Setting v2 encryption policy"
+_set_encpolicy $dir $keyspec
+echo "# Getting v2 encryption policy"
+_get_encpolicy $dir | _filter_scratch
+echo "# Trying to create file without key added yet"
+$XFS_IO_PROG -f $dir/file |& _filter_scratch
+echo "# Getting encryption key status"
+_enckey_status $SCRATCH_MNT $keyspec
+echo "# Adding encryption key"
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
+echo "# Creating encrypted file"
+echo contents > $dir/file
+echo "# Getting encryption key status"
+_enckey_status $SCRATCH_MNT $keyspec
+echo "# Removing encryption key"
+_rm_enckey $SCRATCH_MNT $keyspec
+echo "# Getting encryption key status"
+_enckey_status $SCRATCH_MNT $keyspec
+echo "# Verifying that the encrypted directory was \"locked\""
+cat $dir/file |& _filter_scratch
+cat "$(find $dir -type f)" |& _filter_scratch | cut -d ' ' -f3-
+
+# Test removing key with a file open.
+echo "# Re-adding encryption key"
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
+echo "# Creating another encrypted file"
+echo foo > $dir/file2
+echo "# Removing key while an encrypted file is open"
+exec 3< $dir/file
+_rm_enckey $SCRATCH_MNT $keyspec
+echo "# Non-open file should have been evicted"
+cat $dir/file2 |& _filter_scratch
+echo "# Open file shouldn't have been evicted"
+cat $dir/file
+echo "# Key should be in \"incompletely removed\" state"
+_enckey_status $SCRATCH_MNT $keyspec
+echo "# Closing file and removing key for real now"
+exec 3<&-
+_rm_enckey $SCRATCH_MNT $keyspec
+cat $dir/file |& _filter_scratch
+
+echo "# Cleaning up"
+rm -rf $dir
+_scratch_cycle_mount	# Clear all keys
+echo
+
+echo "# Trying to remove absent key"
+_rm_enckey $SCRATCH_MNT abcdabcdabcdabcd
+
+# success, all done
+status=0
+exit
+
diff --git a/tests/generic/733.out b/tests/generic/733.out
new file mode 100644
index 00000000..02dce51d
--- /dev/null
+++ b/tests/generic/733.out
@@ -0,0 +1,44 @@
+QA output created by 733
+
+# Setting v2 encryption policy
+# Getting v2 encryption policy
+Encryption policy for SCRATCH_MNT/dir:
+	Policy version: 2
+	Master key identifier: 69b2f6edeee720cce0577937eb8a6751
+	Contents encryption mode: 1 (AES-256-XTS)
+	Filenames encryption mode: 4 (AES-256-CTS)
+	Flags: 0x02
+# Trying to create file without key added yet
+SCRATCH_MNT/dir/file: Required key not available
+# Getting encryption key status
+Absent
+# Adding encryption key
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+# Creating encrypted file
+# Getting encryption key status
+Present (user_count=1, added_by_self)
+# Removing encryption key
+Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+# Getting encryption key status
+Absent
+# Verifying that the encrypted directory was "locked"
+cat: SCRATCH_MNT/dir/file: No such file or directory
+Required key not available
+# Re-adding encryption key
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+# Creating another encrypted file
+# Removing key while an encrypted file is open
+Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751, but files still busy
+# Non-open file should have been evicted
+cat: SCRATCH_MNT/dir/file2: Required key not available
+# Open file shouldn't have been evicted
+contents
+# Key should be in "incompletely removed" state
+Incompletely removed
+# Closing file and removing key for real now
+Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+cat: SCRATCH_MNT/dir/file: No such file or directory
+# Cleaning up
+
+# Trying to remove absent key
+Error removing encryption key: Required key not available
-- 
2.41.0

