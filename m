Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49F9A649307
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Dec 2022 08:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230175AbiLKHIB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Dec 2022 02:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiLKHHy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Dec 2022 02:07:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65FE5BF5B;
        Sat, 10 Dec 2022 23:07:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1E87EB80956;
        Sun, 11 Dec 2022 07:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ADF20C43396;
        Sun, 11 Dec 2022 07:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670742465;
        bh=V8Ey0SwLCOJ9knxWE1VbNJnYffVGUO6Y70yYYPMrpqw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=qObPhNNgn6VgTy4B9lHVKE4NsKO5Hd4eHJgFXF2r9E2LYNMrG97VoSPJ473+w5sHl
         qQVGanARksA88mhGI9+QS0X88LMq18pZNnQwMJWT8ekJU2fZ/Jj9ni9DvIGXiMmkBi
         f05wCrgsGecFd0ySfk2Zkw+4LFwLSPoDjJWwB9kVnYag5n+hgTkAW497qgD4PymVqW
         5SaFYNvx4HWR/7/m2AC4bVdYSS4PRvmCXSbxGq6rEu5rXeznJbtqak8Zg1B23GOFfa
         HnMNmSBgT12Y++mt9MMRRTB35xQb9/VbLQr51wJmzQsn38sGU1qzopW0e5BawpgIQ7
         g73tiRR6jD8Bg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 05/10] generic/572: support non-4K Merkle tree block size
Date:   Sat, 10 Dec 2022 23:06:58 -0800
Message-Id: <20221211070704.341481-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221211070704.341481-1-ebiggers@kernel.org>
References: <20221211070704.341481-1-ebiggers@kernel.org>
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
2.38.1

