Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 680B17C4124
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234658AbjJJU0g (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232064AbjJJU0c (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:26:32 -0400
Received: from mail-yw1-x1129.google.com (mail-yw1-x1129.google.com [IPv6:2607:f8b0:4864:20::1129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7E4A110
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:26:28 -0700 (PDT)
Received: by mail-yw1-x1129.google.com with SMTP id 00721157ae682-5a7be61fe74so14876407b3.2
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:26:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696969588; x=1697574388; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=mF1vbhiX1cdiPR9Z0KxSfmvhj/avUWiDcOqPSNPdsMM=;
        b=i5zKHZRm8nga1f7lLWUDuIoJCcEAKWGCSl5qkHOIgjzc4eXQgLlwiZpqXSarjIhqde
         TqWVZBGEyS0W2xSX8hOFzcsnG3aDeKvT9lmLL13fJUcjqWGQ4kRrJxxVxolgMS1+CUUT
         FOuYo1m2efwWkBSENKLSEuM6uKhFucxXeMZxN0bU2gcD9HfCmZUAFkMLRsGQ0YBJUqeD
         RP9OZA/YYX9QVgTT9MgGdMCA545gYpDyaXHvh0IndCVY4R0dLyPJMT6/665FQzqNaFZY
         NkK+Zu1pEdkeioYS2ESVNzmHcqRlgnVrKBWYYsyGGa9woDyzKpc+Y9Aelfu7uAqdS+Tw
         GmHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696969588; x=1697574388;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=mF1vbhiX1cdiPR9Z0KxSfmvhj/avUWiDcOqPSNPdsMM=;
        b=rZpv+rBliB1q1eu4kpIhn6X5gw+AuFiu5R+Y8V3wKRmdobLcVTqsmLgbC17UbstXZe
         eLLOSfETGmiUB1j4CSsiT/NKZcRVjrkdRHb0Bx2JXKn8IMFCuTavJ3h4e1vMbzUo+j/f
         LfMvVHagwCA0f/V4OpP38/uAHgnQMVz3y/cttXt/IpdcfIyZeQdwxUCSEF5tP7JK9gmY
         rTgyT8cr03KtBkfBt/JIARUtV5/jIaOgNaIzCDu2XlG5AazYP/09oDIsZkTqhpMImssz
         VPnU9MNf2+uyL6GeYEyedMD6QBE7xxyB1f8XDd49uAF3ZUFQxfE64rLAcpS2sTeWpzi3
         sIVA==
X-Gm-Message-State: AOJu0YybwNeNN7u+jl3V+4IWTgrHxNmnQKngtCqnTYMy8sNidC9AlZ2+
        YfmYj98G1LzdlWV04GHuvs3FxKeA9G0IwatlP/j/Gw==
X-Google-Smtp-Source: AGHT+IHbQlbrp+UsbhNo4Yoi3+VZM3megDUDcwS3/dwnScoEwA0IR1HI8nRIPEMka0keny9ES8h4ug==
X-Received: by 2002:a0d:ea90:0:b0:5a0:83d3:b61d with SMTP id t138-20020a0dea90000000b005a083d3b61dmr20657862ywe.8.1696969587987;
        Tue, 10 Oct 2023 13:26:27 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id x184-20020a814ac1000000b005869ca8da8esm4613337ywa.146.2023.10.10.13.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:26:27 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 10/12] fstests: split generic/581 into two tests
Date:   Tue, 10 Oct 2023 16:26:03 -0400
Message-ID: <4f808fb5081fc4e9afe77e8498535fd41cc122b2.1696969376.git.josef@toxicpanda.com>
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

generic/581 is mostly a v2 policy test, but it does do some quick checks
of v1 policies as a normal user.  Split the v1 and v2 related parts
into two different tests so that the v2 part can get properly tested for
btrfs file systems, which only support v2 policies.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 tests/generic/581     |  89 +---------------------------
 tests/generic/581.out |  50 ----------------
 tests/generic/734     | 135 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/734.out |  51 ++++++++++++++++
 4 files changed, 188 insertions(+), 137 deletions(-)
 create mode 100644 tests/generic/734
 create mode 100644 tests/generic/734.out

diff --git a/tests/generic/581 b/tests/generic/581
index cabc7e1c..ab930ac6 100755
--- a/tests/generic/581
+++ b/tests/generic/581
@@ -4,8 +4,7 @@
 #
 # FS QA Test No. generic/581
 #
-# Test non-root use of the fscrypt filesystem-level encryption keyring
-# and v2 encryption policies.
+# Test non-root use of the fscrypt filesystem-level encryption keyring policy.
 #
 
 . ./common/preamble
@@ -31,7 +30,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _require_user
-_require_scratch_encryption -v 2
+_require_scratch_encryption
 
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
@@ -58,90 +57,6 @@ echo "# Adding v1 policy key as regular user (should fail with EACCES)"
 _user_do_add_enckey $SCRATCH_MNT "$raw_key" -d $keydesc
 
 rm -rf $dir
-echo
-_user_do "mkdir $dir"
-
-echo "# Setting v2 policy as regular user without key already added (should fail with ENOKEY)"
-_user_do_set_encpolicy $dir $keyid |& _filter_scratch
-
-echo "# Adding v2 policy key as regular user (should succeed)"
-_user_do_add_enckey $SCRATCH_MNT "$raw_key"
-
-echo "# Setting v2 policy as regular user with key added (should succeed)"
-_user_do_set_encpolicy $dir $keyid
-
-echo "# Getting v2 policy as regular user (should succeed)"
-_user_do_get_encpolicy $dir | _filter_scratch
-
-echo "# Creating encrypted file as regular user (should succeed)"
-_user_do "echo contents > $dir/file"
-
-echo "# Removing v2 policy key as regular user (should succeed)"
-_user_do_rm_enckey $SCRATCH_MNT $keyid
-
-_scratch_cycle_mount	# Clear all keys
-
-# Wait for any invalidated keys to be garbage-collected.
-i=0
-while grep -E -q '^[0-9a-f]+ [^ ]*i[^ ]*' /proc/keys; do
-	if ((++i >= 20)); then
-		echo "Timed out waiting for invalidated keys to be GC'ed" >> $seqres.full
-		break
-	fi
-	sleep 0.5
-done
-
-# Set the user key quota to the fsgqa user's current number of keys plus 5.
-orig_keys=$(_user_do "awk '/^[[:space:]]*$(id -u fsgqa):/{print \$4}' /proc/key-users | cut -d/ -f1")
-: ${orig_keys:=0}
-echo "orig_keys=$orig_keys" >> $seqres.full
-orig_maxkeys=$(</proc/sys/kernel/keys/maxkeys)
-keys_to_add=5
-echo $((orig_keys + keys_to_add)) > /proc/sys/kernel/keys/maxkeys
-
-echo
-echo "# Testing user key quota"
-for i in `seq $((keys_to_add + 1))`; do
-	rand_raw_key=$(_generate_raw_encryption_key)
-	_user_do_add_enckey $SCRATCH_MNT "$rand_raw_key" \
-	    | sed 's/ with identifier .*$//'
-done
-
-# Restore the original key quota.
-echo "$orig_maxkeys" > /proc/sys/kernel/keys/maxkeys
-
-rm -rf $dir
-echo
-_user_do "mkdir $dir"
-_scratch_cycle_mount	# Clear all keys
-
-# Test multiple users adding the same key.
-echo "# Adding key as root"
-_add_enckey $SCRATCH_MNT "$raw_key"
-echo "# Getting key status as regular user"
-_user_do_enckey_status $SCRATCH_MNT $keyid
-echo "# Removing key only added by another user (should fail with ENOKEY)"
-_user_do_rm_enckey $SCRATCH_MNT $keyid
-echo "# Setting v2 encryption policy with key only added by another user (should fail with ENOKEY)"
-_user_do_set_encpolicy $dir $keyid |& _filter_scratch
-echo "# Adding second user of key"
-_user_do_add_enckey $SCRATCH_MNT "$raw_key"
-echo "# Getting key status as regular user"
-_user_do_enckey_status $SCRATCH_MNT $keyid
-echo "# Setting v2 encryption policy as regular user"
-_user_do_set_encpolicy $dir $keyid
-echo "# Removing this user's claim to the key"
-_user_do_rm_enckey $SCRATCH_MNT $keyid
-echo "# Getting key status as regular user"
-_user_do_enckey_status $SCRATCH_MNT $keyid
-echo "# Adding back second user of key"
-_user_do_add_enckey $SCRATCH_MNT "$raw_key"
-echo "# Remove key for \"all users\", as regular user (should fail with EACCES)"
-_user_do_rm_enckey $SCRATCH_MNT $keyid -a |& _filter_scratch
-_enckey_status $SCRATCH_MNT $keyid
-echo "# Remove key for \"all users\", as root"
-_rm_enckey $SCRATCH_MNT $keyid -a
-_enckey_status $SCRATCH_MNT $keyid
 
 # success, all done
 status=0
diff --git a/tests/generic/581.out b/tests/generic/581.out
index b3f7d889..a8cb96a8 100644
--- a/tests/generic/581.out
+++ b/tests/generic/581.out
@@ -10,53 +10,3 @@ Encryption policy for SCRATCH_MNT/dir:
 	Flags: 0x02
 # Adding v1 policy key as regular user (should fail with EACCES)
 Permission denied
-
-# Setting v2 policy as regular user without key already added (should fail with ENOKEY)
-SCRATCH_MNT/dir: failed to set encryption policy: Required key not available
-# Adding v2 policy key as regular user (should succeed)
-Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
-# Setting v2 policy as regular user with key added (should succeed)
-# Getting v2 policy as regular user (should succeed)
-Encryption policy for SCRATCH_MNT/dir:
-	Policy version: 2
-	Master key identifier: 69b2f6edeee720cce0577937eb8a6751
-	Contents encryption mode: 1 (AES-256-XTS)
-	Filenames encryption mode: 4 (AES-256-CTS)
-	Flags: 0x02
-# Creating encrypted file as regular user (should succeed)
-# Removing v2 policy key as regular user (should succeed)
-Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
-
-# Testing user key quota
-Added encryption key
-Added encryption key
-Added encryption key
-Added encryption key
-Added encryption key
-Error adding encryption key: Disk quota exceeded
-
-# Adding key as root
-Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
-# Getting key status as regular user
-Present (user_count=1)
-# Removing key only added by another user (should fail with ENOKEY)
-Error removing encryption key: Required key not available
-# Setting v2 encryption policy with key only added by another user (should fail with ENOKEY)
-SCRATCH_MNT/dir: failed to set encryption policy: Required key not available
-# Adding second user of key
-Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
-# Getting key status as regular user
-Present (user_count=2, added_by_self)
-# Setting v2 encryption policy as regular user
-# Removing this user's claim to the key
-Removed user's claim to encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
-# Getting key status as regular user
-Present (user_count=1)
-# Adding back second user of key
-Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
-# Remove key for "all users", as regular user (should fail with EACCES)
-Permission denied
-Present (user_count=2, added_by_self)
-# Remove key for "all users", as root
-Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
-Absent
diff --git a/tests/generic/734 b/tests/generic/734
new file mode 100644
index 00000000..a6f46e7e
--- /dev/null
+++ b/tests/generic/734
@@ -0,0 +1,135 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2019 Google LLC
+#
+# FS QA Test No. generic/581
+#
+# Test non-root use of the fscrypt filesystem-level encryption v2 policy.
+#
+
+. ./common/preamble
+_begin_fstest auto quick encrypt
+echo
+
+orig_maxkeys=
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+	if [ -n "$orig_maxkeys" ]; then
+		echo "$orig_maxkeys" > /proc/sys/kernel/keys/maxkeys
+	fi
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/encrypt
+
+# real QA test starts here
+_supported_fs generic
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
+# Wait for any invalidated keys to be garbage-collected.
+i=0
+while grep -E -q '^[0-9a-f]+ [^ ]*i[^ ]*' /proc/keys; do
+	if ((++i >= 20)); then
+		echo "Timed out waiting for invalidated keys to be GC'ed" >> $seqres.full
+		break
+	fi
+	sleep 0.5
+done
+
+# Set the user key quota to the fsgqa user's current number of keys plus 5.
+orig_keys=$(_user_do "awk '/^[[:space:]]*$(id -u fsgqa):/{print \$4}' /proc/key-users | cut -d/ -f1")
+: ${orig_keys:=0}
+echo "orig_keys=$orig_keys" >> $seqres.full
+orig_maxkeys=$(</proc/sys/kernel/keys/maxkeys)
+keys_to_add=5
+echo $((orig_keys + keys_to_add)) > /proc/sys/kernel/keys/maxkeys
+
+echo
+echo "# Testing user key quota"
+for i in `seq $((keys_to_add + 1))`; do
+	rand_raw_key=$(_generate_raw_encryption_key)
+	_user_do_add_enckey $SCRATCH_MNT "$rand_raw_key" \
+	    | sed 's/ with identifier .*$//'
+done
+
+# Restore the original key quota.
+echo "$orig_maxkeys" > /proc/sys/kernel/keys/maxkeys
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
+
diff --git a/tests/generic/734.out b/tests/generic/734.out
new file mode 100644
index 00000000..85a8c973
--- /dev/null
+++ b/tests/generic/734.out
@@ -0,0 +1,51 @@
+QA output created by 734
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
-- 
2.41.0

