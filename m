Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 697EC654A6A
	for <lists+linux-fscrypt@lfdr.de>; Fri, 23 Dec 2022 02:11:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235914AbiLWBLS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 22 Dec 2022 20:11:18 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235834AbiLWBKg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 22 Dec 2022 20:10:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E217E2189D;
        Thu, 22 Dec 2022 17:07:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9FCEB81FBC;
        Fri, 23 Dec 2022 01:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D6CBC433EF;
        Fri, 23 Dec 2022 01:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671757623;
        bh=t4YxnTq55XKnzA6QkU3drS25kE9/QRlSDE3NErRiWn0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Wgf2wrmpPy3c5/eylxITrbdc5avdszMssHc7C5A1E96i44JaAESSGwYMjBvySembo
         1odYFGlJvtTjs9YVDBKazuKiSpoYFzmLodxcnEqGl2pLs9C20GgedOAtA/RXZxvwLG
         rk1ZE5OdfRXwUL0MkWQ/4vcBNqjFSuvRUIniErgv72SsqPtgNU+X7hGG4sUU/KFwxJ
         f/8iz0nHr+venYwIyL56+R0u/V4izSQTZmqjXbYXds1jhVK3uQz7tabhdbTgaGhz8c
         4OHmFxpkQMuZBs0bbIRLvD5/iN3axT/qe2uYS3tFzugejV/2vl0h8xMLVCbl3UJT3l
         QaZPDNAeSUfHA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 05/10] generic/572: support non-4K Merkle tree block size
Date:   Thu, 22 Dec 2022 17:05:49 -0800
Message-Id: <20221223010554.281679-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221223010554.281679-1-ebiggers@kernel.org>
References: <20221223010554.281679-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Update generic/572 to not implicitly assume that the Merkle tree block
size being used is 4096 bytes.  Also remove an unused function.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/572     | 21 ++++++---------------
 tests/generic/572.out | 10 +++-------
 2 files changed, 9 insertions(+), 22 deletions(-)

diff --git a/tests/generic/572 b/tests/generic/572
index cded9ac6..d8071a34 100755
--- a/tests/generic/572
+++ b/tests/generic/572
@@ -9,7 +9,7 @@
 # - conditions for enabling verity
 # - verity files have correct contents and size
 # - can't change contents of verity files, but can change metadata
-# - can retrieve a verity file's measurement via FS_IOC_MEASURE_VERITY
+# - can retrieve a verity file's digest via FS_IOC_MEASURE_VERITY
 #
 . ./common/preamble
 _begin_fstest auto quick verity
@@ -48,15 +48,6 @@ verify_data_readable()
 	md5sum $file > /dev/null
 }
 
-verify_data_unreadable()
-{
-	local file=$1
-
-	# try both reading just the first data block, and reading until EOF
-	head -c $FSV_BLOCK_SIZE $file 2>&1 >/dev/null | filter_output
-	md5sum $file |& filter_output
-}
-
 _fsv_scratch_begin_subtest "Enabling verity on file with verity already enabled fails with EEXIST"
 _fsv_create_enable_file $fsv_file
 echo "(trying again)"
@@ -94,7 +85,7 @@ verify_data_readable $fsv_file
 _fsv_scratch_begin_subtest "Enabling verity can be interrupted"
 dd if=/dev/zero of=$fsv_file bs=1 count=0 seek=$((1 << 34)) status=none
 start_time=$(date +%s)
-$FSVERITY_PROG enable $fsv_file &
+$FSVERITY_PROG enable --block-size=$FSV_BLOCK_SIZE $fsv_file &
 sleep 0.5
 kill %1
 wait
@@ -106,7 +97,7 @@ fi
 _fsv_scratch_begin_subtest "Enabling verity on file with verity already being enabled fails with EBUSY"
 dd if=/dev/zero of=$fsv_file bs=1 count=0 seek=$((1 << 34)) status=none
 start_time=$(date +%s)
-$FSVERITY_PROG enable $fsv_file &
+$FSVERITY_PROG enable --block-size=$FSV_BLOCK_SIZE $fsv_file &
 sleep 0.5
 _fsv_enable $fsv_file |& filter_output
 kill %1
@@ -129,7 +120,7 @@ verify_data_readable $fsv_file
 
 _fsv_scratch_begin_subtest "verity file can be measured"
 _fsv_create_enable_file $fsv_file >> $seqres.full
-_fsv_measure $fsv_file
+_fsv_measure $fsv_file | _filter_fsverity_digest
 
 _fsv_scratch_begin_subtest "verity file can be renamed"
 _fsv_create_enable_file $fsv_file
@@ -170,8 +161,8 @@ verify_data_readable $fsv_file
 
 # Test files <= 1 block in size.  These are a bit of a special case since there
 # are no hash blocks; the root hash is calculated directly over the data block.
+_fsv_scratch_begin_subtest "verity on small files"
 for size in 1 $((FSV_BLOCK_SIZE - 1)) $FSV_BLOCK_SIZE; do
-	_fsv_scratch_begin_subtest "verity on $size-byte file"
 	head -c $size /dev/urandom > $fsv_orig_file
 	cp $fsv_orig_file $fsv_file
 	_fsv_enable $fsv_file
@@ -179,7 +170,7 @@ for size in 1 $((FSV_BLOCK_SIZE - 1)) $FSV_BLOCK_SIZE; do
 	rm -f $fsv_file
 done
 
-_fsv_scratch_begin_subtest "verity on 100M file (multiple levels in hash tree)"
+_fsv_scratch_begin_subtest "verity on 100MB file (multiple levels in hash tree)"
 head -c 100000000 /dev/urandom > $fsv_orig_file
 cp $fsv_orig_file $fsv_file
 _fsv_enable $fsv_file
diff --git a/tests/generic/572.out b/tests/generic/572.out
index ad381629..d703835b 100644
--- a/tests/generic/572.out
+++ b/tests/generic/572.out
@@ -39,7 +39,7 @@ bash: SCRATCH_MNT/file.fsv: Operation not permitted
 # verity file can be read
 
 # verity file can be measured
-sha256:be54121da3877f8852c65136d731784f134c4dd9d95071502e80d7be9f99b263
+sha256:<digest>
 
 # verity file can be renamed
 
@@ -58,16 +58,12 @@ sha256:be54121da3877f8852c65136d731784f134c4dd9d95071502e80d7be9f99b263
 # Trying to measure non-verity file fails with ENODATA
 ERROR: FS_IOC_MEASURE_VERITY failed on 'SCRATCH_MNT/file.fsv': No data available
 
-# verity on 1-byte file
+# verity on small files
 Files matched
-
-# verity on 4095-byte file
 Files matched
-
-# verity on 4096-byte file
 Files matched
 
-# verity on 100M file (multiple levels in hash tree)
+# verity on 100MB file (multiple levels in hash tree)
 Files matched
 
 # verity on sparse file
-- 
2.39.0

