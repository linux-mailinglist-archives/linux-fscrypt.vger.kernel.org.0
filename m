Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1E63C7C412B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:26:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343759AbjJJU0l (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:26:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234481AbjJJU0f (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:26:35 -0400
Received: from mail-yw1-x1131.google.com (mail-yw1-x1131.google.com [IPv6:2607:f8b0:4864:20::1131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 49D13116
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:26:30 -0700 (PDT)
Received: by mail-yw1-x1131.google.com with SMTP id 00721157ae682-5a7cc03dee5so10040487b3.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:26:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696969589; x=1697574389; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CpXoLSC4B3+y4tFzKbAFP96R061BBPW8n0TzUGeBy20=;
        b=1I2t8mzbvuNF3pruO1Xc89EgwsALHJBW3WE/RSrXcL3zphYYNS6hnIfCyIcvypmpeR
         YViEHmWtdVNo43z+6eFe1g1qh5oy9O9q6PTetX/u4IQvSS6y644nQZxJd8RrYRi9QS8q
         LrrIgTVzptfeKVbBcGIWYGW5ydrJS0/kSnSui1M3o70CUfxq/j+jD5O+2p7C2/DnEw5i
         DFeSADdy3s4xs4JxckBzmL7EoiNZ6oIUGaqoz9PYrUJjzYOok67aP+Xfc1Cc1IgRjeYF
         VObc6OsJm2FFl3D3F8r+m6GSQ84KzpUhGpKiuJZQsuC4NEZtE5jM+lDbV0rb6NABscZ8
         92sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696969589; x=1697574389;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CpXoLSC4B3+y4tFzKbAFP96R061BBPW8n0TzUGeBy20=;
        b=KR5nfWCvZNywsSjQL6sJzzKaZE09fhPKDnCx/tR9+XW0NuL0H+HNJUPiDgcW28Hxpi
         /TiEu9iEZyq/cauVeQmbZOYuzz1rLR3liCodoYGwXSPucVkxMnkHmTnGsGPZB5szQ9JP
         5cwyeOeZ5Tmlh/wvXMg6T/LXtJ8V6bUQIGd4bFZz2i2wIWHLwWnaVLVqxPKt/QDcD8nw
         qjFAuSjvMBlEDvu3RnOkkxLFiDjXnN1Z7Fmw9qlabkaidYcxPBaIFPYAiKfBaImxOEq8
         QqJi/8ZvEiQCPHQlOIFrlSq9VI3mtMeUXYzXV8aQ1hXot/VKbPO+7HocUH48YbliONeC
         GlHw==
X-Gm-Message-State: AOJu0Yxm8oOX1rsOPx1CQEJsnp9PK0sBGFJgzQcMU8ugJgewfssUBDxs
        eTKMJUAAu7NnhDBgFF/dcrqowA==
X-Google-Smtp-Source: AGHT+IF7Y/FZ6maDxIIOaCWirMfXhRsvOOUqzWjpYsCWBIt+XCan7S/I9Xp6egN+Uj1LaMkChVCBjg==
X-Received: by 2002:a81:6203:0:b0:59b:bd55:8452 with SMTP id w3-20020a816203000000b0059bbd558452mr22083068ywb.36.1696969589322;
        Tue, 10 Oct 2023 13:26:29 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id g68-20020a0df647000000b0059f766f9750sm4665680ywf.124.2023.10.10.13.26.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:26:28 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH 11/12] fstests: split generic/613 into two tests
Date:   Tue, 10 Oct 2023 16:26:04 -0400
Message-ID: <227ac42377705dcd416558f8415965ecba3a17df.1696969376.git.josef@toxicpanda.com>
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

generic/613 tests v1 and v2 policies, but btrfs can only support v2
policies.  Split this into two different tests, 613 which will only test
v1 policies, and then 735 which will test v2 policies.

The 735 test will also add checks for the per-extent nonces to validate
they're all sufficiently random.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 tests/generic/613     |  20 ++------
 tests/generic/613.out |   5 +-
 tests/generic/735     | 117 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/735.out |  14 +++++
 4 files changed, 138 insertions(+), 18 deletions(-)
 create mode 100644 tests/generic/735
 create mode 100644 tests/generic/735.out

diff --git a/tests/generic/613 b/tests/generic/613
index 47c60e9c..96b81a96 100755
--- a/tests/generic/613
+++ b/tests/generic/613
@@ -22,22 +22,21 @@ _begin_fstest auto quick encrypt
 
 # real QA test starts here
 _supported_fs generic
-_require_scratch_encryption -v 2
+_require_scratch_encryption
 _require_get_encryption_nonce_support
 _require_command "$XZ_PROG" xz
 
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 
-echo -e "\n# Adding encryption keys"
-_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
+echo -e "\n# Adding encryption key"
 _add_enckey $SCRATCH_MNT "$TEST_RAW_KEY" -d $TEST_KEY_DESCRIPTOR
 
 # Create a bunch of encrypted files and directories -- enough for the uniqueness
 # and randomness tests to be meaningful, but not so many that this test takes a
-# long time.  Test using both v1 and v2 encryption policies, and for each of
-# those test the case of an encryption policy that is assigned to an empty
-# directory as well as the case of a file created in an encrypted directory.
+# long time.  Test using the v1 encryption policy, test the case of an
+# encryption policy that is assigned to an empty directory as well as the case
+# of a file created in an encrypted directory.
 echo -e "\n# Creating encrypted files and directories"
 inodes=()
 for i in {1..50}; do
@@ -45,20 +44,11 @@ for i in {1..50}; do
 	mkdir $dir
 	inodes+=("$(stat -c %i $dir)")
 	_set_encpolicy $dir $TEST_KEY_DESCRIPTOR
-
-	dir=$SCRATCH_MNT/v2_policy_dir_$i
-	mkdir $dir
-	inodes+=("$(stat -c %i $dir)")
-	_set_encpolicy $dir $TEST_KEY_IDENTIFIER
 done
 for i in {1..50}; do
 	file=$SCRATCH_MNT/v1_policy_dir_1/$i
 	touch $file
 	inodes+=("$(stat -c %i $file)")
-
-	file=$SCRATCH_MNT/v2_policy_dir_1/$i
-	touch $file
-	inodes+=("$(stat -c %i $file)")
 done
 _scratch_unmount
 
diff --git a/tests/generic/613.out b/tests/generic/613.out
index 203a64f2..4a218d03 100644
--- a/tests/generic/613.out
+++ b/tests/generic/613.out
@@ -1,7 +1,6 @@
 QA output created by 613
 
-# Adding encryption keys
-Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+# Adding encryption key
 Added encryption key with descriptor 0000111122223333
 
 # Creating encrypted files and directories
@@ -12,5 +11,5 @@ Added encryption key with descriptor 0000111122223333
 Listing non-unique nonces:
 
 # Verifying randomness of nonces
-Uncompressed size is 3200 bytes
+Uncompressed size is 1600 bytes
 Nonces are incompressible, as expected
diff --git a/tests/generic/735 b/tests/generic/735
new file mode 100644
index 00000000..c901be1f
--- /dev/null
+++ b/tests/generic/735
@@ -0,0 +1,117 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2023 Meta
+#
+# FS QA Test No. 735
+#
+# A variation of generic/613 that only tests v2, and checks data nonces for any
+# file system that supporst per-extent encryption.
+#
+# Test that encryption nonces are unique and random, where randomness is
+# approximated as "incompressible by the xz program".
+#
+# An encryption nonce is the 16-byte value that the filesystem generates for
+# each encrypted file.  These nonces must be unique in order to cause different
+# files to be encrypted differently, which is an important security property.
+# In practice, they need to be random to achieve that; and it's easy enough to
+# test for both uniqueness and randomness, so we test for both.
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
+_require_scratch_encryption -v 2
+_require_get_encryption_nonce_support
+_require_command "$XZ_PROG" xz
+
+_check_nonce()
+{
+	local nonce=$1
+
+	if (( ${#nonce} != 32 )) || [ -n "$(echo "$nonce" | tr -d 0-9a-fA-F)" ]
+	then
+		_fail "Expected nonce for inode $inode to be 16 bytes (32 hex characters), but got \"$nonce\""
+	fi
+}
+
+_scratch_mkfs_encrypted &>> $seqres.full
+_scratch_mount
+
+echo -e "\n# Adding encryption key"
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
+
+# Create a bunch of encrypted files and directories -- enough for the uniqueness
+# and randomness tests to be meaningful, but not so many that this test takes a
+# long time.  Test using the v2 encryption policy, test the case of an
+# encryption policy that is assigned to an empty directory as well as the case
+# of a file created in an encrypted directory.
+echo -e "\n# Creating encrypted files and directories"
+inodes=()
+for i in {1..50}; do
+	dir=$SCRATCH_MNT/v2_policy_dir_$i
+	mkdir $dir
+	inodes+=("$(stat -c %i $dir)")
+	_set_encpolicy $dir $TEST_KEY_IDENTIFIER
+done
+for i in {1..50}; do
+	file=$SCRATCH_MNT/v2_policy_dir_1/$i
+	$XFS_IO_PROG -f -c "pwrite 0 1m" $file > /dev/null
+	inodes+=("$(stat -c %i $file)")
+done
+_scratch_unmount
+
+# Build files that contain all the nonces.  nonces_hex contains them in hex, one
+# per line.  nonces_bin contains them in binary, all concatenated.
+echo -e "\n# Getting encryption nonces from inodes"
+echo -n > $tmp.nonces_hex
+echo -n > $tmp.nonces_bin
+for inode in "${inodes[@]}"; do
+	inode_nonce=$(_get_encryption_file_nonce $SCRATCH_DEV $inode)
+	_check_nonce $inode_nonce
+	
+	echo $inode_nonce >> $tmp.nonces_hex
+	echo -ne "$(echo $inode_nonce | sed 's/[0-9a-fA-F]\{2\}/\\x\0/g')" \
+		>> $tmp.nonces_bin
+
+	data_nonce=$(_get_encryption_data_nonce $SCRATCH_DEV $inode)
+
+	# If the inode is empty we won't have a data nonce
+	[ "$data_nonce" = "" ] && continue
+
+	# If the inode nonce and data nonce are the same continue
+	[ "$inode_nonce" = "$data_nonce" ] && continue
+
+	_check_nonce $data_nonce
+	
+	echo $data_nonce >> $tmp.nonces_hex
+	echo -ne "$(echo $data_nonce | sed 's/[0-9a-fA-F]\{2\}/\\x\0/g')" \
+		>> $tmp.nonces_bin
+done
+
+# Verify the uniqueness and randomness of the nonces.  In theory randomness
+# implies uniqueness here, but it's easy enough to explicitly test for both.
+
+echo -e "\n# Verifying uniqueness of nonces"
+echo "Listing non-unique nonces:"
+sort < $tmp.nonces_hex | uniq -d
+
+echo -e "\n# Verifying randomness of nonces"
+uncompressed_size=$(stat -c %s $tmp.nonces_bin)
+echo "Uncompressed size is $uncompressed_size bytes" >> $seqres.full
+compressed_size=$($XZ_PROG -c < $tmp.nonces_bin | wc -c)
+echo "Compressed size is $compressed_size bytes" >> $seqres.full
+# The xz format has 60 bytes of overhead.  Go a bit lower to avoid flakiness.
+if (( compressed_size >= uncompressed_size + 55 )); then
+	echo "Nonces are incompressible, as expected"
+else
+	_fail "Nonces are compressible (non-random); compressed $uncompressed_size => $compressed_size bytes!"
+fi
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/735.out b/tests/generic/735.out
new file mode 100644
index 00000000..bf73118b
--- /dev/null
+++ b/tests/generic/735.out
@@ -0,0 +1,14 @@
+QA output created by 735
+
+# Adding encryption key
+Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
+
+# Creating encrypted files and directories
+
+# Getting encryption nonces from inodes
+
+# Verifying uniqueness of nonces
+Listing non-unique nonces:
+
+# Verifying randomness of nonces
+Nonces are incompressible, as expected
-- 
2.41.0

