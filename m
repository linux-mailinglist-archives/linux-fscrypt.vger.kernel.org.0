Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B05D6654A69
	for <lists+linux-fscrypt@lfdr.de>; Fri, 23 Dec 2022 02:11:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235833AbiLWBLR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 22 Dec 2022 20:11:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235891AbiLWBKf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 22 Dec 2022 20:10:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2EC4521813;
        Thu, 22 Dec 2022 17:07:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B140261DE7;
        Fri, 23 Dec 2022 01:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 083F6C43392;
        Fri, 23 Dec 2022 01:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671757624;
        bh=x0iH/+8N/34jzQlGKFW92IkmsY0QaeFUJJY7TBodcpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=FtDZYM5mNyeEhCNFCZgFod3EVgmN9pRiWUCg4mQX2xMBDCsXrgS/5xSFEnBBJF3Wn
         7etMI7DaFuU96M+3lEkVcqXq14+CX5J+7GJkl2w5NOAZvcg0Pxye1ZAnpZc/XzaheZ
         8sHbzh444LJA5uV384aUphaXAk61Ae670LmuTfahyBXEh3kqgzRh384gRp0NEOA24y
         b9AOP9+bHKRQCYAQpa0MevzbFi87e4CpUDugq4YGWJzdElVS7smDkhi2zzTjxC8NmQ
         gRwqjep0cB2sGnwt4uGiANTeOk83YDL0vyyS5ii++6mR2Yw52LBCiG76YtnwrEHpb6
         7TxgSps+uq5wA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 08/10] generic/574: test multiple Merkle tree block sizes
Date:   Thu, 22 Dec 2022 17:05:52 -0800
Message-Id: <20221223010554.281679-9-ebiggers@kernel.org>
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

Instead of only testing 4K Merkle tree blocks, test FSV_BLOCK_SIZE, and
also other sizes if they happen to be supported.  This allows this test
to run in cases where it couldn't before and improves test coverage in
cases where it did run before.

Given that the list of Merkle tree block sizes that will actually work
is not fixed, this required reworking the test to not rely on the .out
file so heavily.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/574     | 177 ++++++++++++++++++++++++++----------------
 tests/generic/574.out |  83 ++------------------
 2 files changed, 114 insertions(+), 146 deletions(-)

diff --git a/tests/generic/574 b/tests/generic/574
index fd4488c9..8f7923ba 100755
--- a/tests/generic/574
+++ b/tests/generic/574
@@ -37,18 +37,19 @@ fsv_file=$SCRATCH_MNT/file.fsv
 
 setup_zeroed_file()
 {
-	local len=$1
-	local sparse=$2
+	local block_size=$1
+	local file_len=$2
+	local sparse=$3
 
 	if $sparse; then
-		dd if=/dev/zero of=$fsv_orig_file bs=1 count=0 seek=$len \
+		dd if=/dev/zero of=$fsv_orig_file bs=1 count=0 seek=$file_len \
 			status=none
 	else
-		head -c $len /dev/zero > $fsv_orig_file
+		head -c $file_len /dev/zero > $fsv_orig_file
 	fi
 	cp $fsv_orig_file $fsv_file
-	_fsv_enable $fsv_file
-	md5sum $fsv_file |& _filter_scratch
+	_fsv_enable $fsv_file --block-size=$block_size
+	cmp $fsv_orig_file $fsv_file
 }
 
 filter_sigbus()
@@ -66,63 +67,84 @@ round_up_to_page_boundary()
 
 corruption_test()
 {
-	local file_len=$1
-	local zap_offset=$2
-	local zap_len=$3
-	local is_merkle_tree=${4:-false} # if true, zap tree instead of data
-	local use_sparse_file=${5:-false}
+	local block_size=$1
+	local file_len=$2
+	local zap_offset=$3
+	local zap_len=$4
+	local is_merkle_tree=${5:-false} # if true, zap tree instead of data
+	local use_sparse_file=${6:-false}
 	local page_aligned_eof=$(round_up_to_page_boundary $file_len)
-	local measurement
+
+	local paramstr="block_size=$block_size"
+	paramstr+=", file_len=$file_len"
+	paramstr+=", zap_offset=$zap_offset"
+	paramstr+=", zap_len=$zap_len"
+	paramstr+=", is_merkle_tree=$is_merkle_tree"
+	paramstr+=", use_sparse_file=$use_sparse_file"
 
 	if $is_merkle_tree; then
 		local corrupt_func=_fsv_scratch_corrupt_merkle_tree
 	else
 		local corrupt_func=_fsv_scratch_corrupt_bytes
 	fi
+	local fs_block_size=$(_get_block_size $SCRATCH_MNT)
 
-	local msg="Corruption test:"
-	msg+=" file_len=$file_len"
-	if $use_sparse_file; then
-		msg+=" (sparse)"
-	fi
-	msg+=" zap_offset=$zap_offset"
-	if $is_merkle_tree; then
-		msg+=" (in Merkle tree)"
-	fi
-	msg+=" zap_len=$zap_len"
+	rm -rf "${SCRATCH_MNT:?}"/*
+	setup_zeroed_file $block_size $file_len $use_sparse_file
 
-	_fsv_scratch_begin_subtest "$msg"
-	setup_zeroed_file $file_len $use_sparse_file
-	cmp $fsv_file $fsv_orig_file
-	echo "Corrupting bytes..."
+	# Corrupt part of the file (data or Merkle tree).
 	head -c $zap_len /dev/zero | tr '\0' X \
 		| $corrupt_func $fsv_file $zap_offset
 
-	echo "Validating corruption (reading full file)..."
+	# Reading the full file with buffered I/O should fail.
 	_scratch_cycle_mount
-	md5sum $fsv_file |& _filter_scratch
+	if cat $fsv_file >/dev/null 2>$tmp.out; then
+		echo "Unexpectedly was able to read full file ($paramstr)"
+	elif ! grep -q 'Input/output error' $tmp.out; then
+		echo "Wrong error reading full file ($paramstr):"
+		cat $tmp.out
+	fi
 
-	echo "Validating corruption (direct I/O)..."
+	# Reading the full file with direct I/O should fail.
 	_scratch_cycle_mount
-	dd if=$fsv_file bs=$FSV_BLOCK_SIZE iflag=direct status=none \
-		of=/dev/null |& _filter_scratch
+	if dd if=$fsv_file bs=$fs_block_size iflag=direct status=none \
+		of=/dev/null 2>$tmp.out
+	then
+		echo "Unexpectedly was able to read full file with DIO ($paramstr)"
+	elif ! grep -q 'Input/output error' $tmp.out; then
+		echo "Wrong error reading full file with DIO ($paramstr):"
+		cat $tmp.out
+	fi
 
-	if (( zap_offset < file_len )) && ! $is_merkle_tree; then
-		echo "Validating corruption (reading just corrupted part)..."
-		dd if=$fsv_file bs=1 skip=$zap_offset count=$zap_len \
-			of=/dev/null status=none |& _filter_scratch
+	# Reading just the corrupted part of the file should fail.
+	if ! $is_merkle_tree; then
+		if dd if=$fsv_file bs=1 skip=$zap_offset count=$zap_len \
+			of=/dev/null status=none 2>$tmp.out; then
+			echo "Unexpectedly was able to read corrupted part ($paramstr)"
+		elif ! grep -q 'Input/output error' $tmp.out; then
+			echo "Wrong error reading corrupted part ($paramstr):"
+			cat $tmp.out
+		fi
 	fi
 
-	echo "Validating corruption (reading full file via mmap)..."
+	# Reading the full file via mmap should fail.
 	bash -c "trap '' SIGBUS; $XFS_IO_PROG -r $fsv_file \
 		-c 'mmap -r 0 $page_aligned_eof' \
-		-c 'mread 0 $file_len'" |& filter_sigbus
+		-c 'mread 0 $file_len'" >/dev/null 2>$tmp.out
+	if ! grep -q 'Bus error' $tmp.out; then
+		echo "Didn't see SIGBUS when reading file via mmap"
+		cat $tmp.out
+	fi
 
+	# Reading just the corrupted part via mmap should fail.
 	if ! $is_merkle_tree; then
-		echo "Validating corruption (reading just corrupted part via mmap)..."
 		bash -c "trap '' SIGBUS; $XFS_IO_PROG -r $fsv_file \
 			-c 'mmap -r 0 $page_aligned_eof' \
-			-c 'mread $zap_offset $zap_len'" |& filter_sigbus
+			-c 'mread $zap_offset $zap_len'" >/dev/null 2>$tmp.out
+		if ! grep -q 'Bus error' $tmp.out; then
+			echo "Didn't see SIGBUS when reading corrupted part via mmap"
+			cat $tmp.out
+		fi
 	fi
 }
 
@@ -131,18 +153,18 @@ corruption_test()
 # return zeros in the last block past EOF, regardless of the contents on
 # disk. In the former, corruption should be detected and result in SIGBUS,
 # while in the latter we would expect zeros past EOF, but no error.
-corrupt_eof_block_test() {
-	local file_len=$1
-	local zap_len=$2
+corrupt_eof_block_test()
+{
+	local block_size=$1
+	local file_len=$2
+	local zap_len=$3
 	local page_aligned_eof=$(round_up_to_page_boundary $file_len)
-	_fsv_scratch_begin_subtest "Corruption test: EOF block"
-	setup_zeroed_file $file_len false
-	cmp $fsv_file $fsv_orig_file
-	echo "Corrupting bytes..."
+
+	rm -rf "${SCRATCH_MNT:?}"/*
+	setup_zeroed_file $block_size $file_len false
 	head -c $zap_len /dev/zero | tr '\0' X \
 		| _fsv_scratch_corrupt_bytes $fsv_file $file_len
 
-	echo "Reading eof block via mmap into a temporary file..."
 	bash -c "trap '' SIGBUS; $XFS_IO_PROG -r $fsv_file \
 		-c 'mmap -r 0 $page_aligned_eof' \
 		-c 'mread -v $file_len $zap_len'" \
@@ -153,30 +175,49 @@ corrupt_eof_block_test() {
 		-c "mmap -r 0 $page_aligned_eof" \
 		-c "mread -v $file_len $zap_len" >$tmp.eof_zero_read
 
-	echo "Checking for SIGBUS or zeros..."
-	grep -q -e '^Bus error$' $tmp.eof_block_read \
-		|| diff $tmp.eof_block_read $tmp.eof_zero_read \
-		&& echo "OK"
+	grep -q -e '^Bus error$' $tmp.eof_block_read || \
+		diff $tmp.eof_block_read $tmp.eof_zero_read
 }
 
-# Note: these tests just overwrite some bytes without checking their original
-# values.  Therefore, make sure to overwrite at least 5 or so bytes, to make it
-# nearly guaranteed that there will be a change -- even when the test file is
-# encrypted due to the test_dummy_encryption mount option being specified.
-
-corruption_test 131072 0 5
-corruption_test 131072 4091 5
-corruption_test 131072 65536 65536
-corruption_test 131072 131067 5
-
-corrupt_eof_block_test 130999 72
-
-# Merkle tree corruption.
-corruption_test 200000 100 10 true
+test_block_size()
+{
+	local block_size=$1
+
+	# Note: these tests just overwrite some bytes without checking their
+	# original values.  Therefore, make sure to overwrite at least 5 or so
+	# bytes, to make it nearly guaranteed that there will be a change --
+	# even when the test file is encrypted due to the test_dummy_encryption
+	# mount option being specified.
+	corruption_test $block_size 131072 0 5
+	corruption_test $block_size 131072 4091 5
+	corruption_test $block_size 131072 65536 65536
+	corruption_test $block_size 131072 131067 5
+
+	corrupt_eof_block_test $block_size 130999 72
+
+	# Merkle tree corruption.
+	corruption_test $block_size 200000 100 10 true
+
+	# Sparse file.  Corrupting the Merkle tree should still cause reads to
+	# fail, i.e. the filesystem must verify holes.
+	corruption_test $block_size 200000 100 10 true true
+}
 
-# Sparse file.  Corrupting the Merkle tree should still cause reads to fail,
-# i.e. the filesystem must verify holes.
-corruption_test 200000 100 10 true true
+# Always test FSV_BLOCK_SIZE.  Also test some other block sizes if they happen
+# to be supported.
+_fsv_scratch_begin_subtest "Testing block_size=FSV_BLOCK_SIZE"
+test_block_size $FSV_BLOCK_SIZE
+for block_size in 1024 4096 16384 65536; do
+	_fsv_scratch_begin_subtest "Testing block_size=$block_size if supported"
+	if (( block_size == FSV_BLOCK_SIZE )); then
+		continue # Skip redundant test case.
+	fi
+	if ! _fsv_can_enable $fsv_file --block-size=$block_size; then
+		echo "block_size=$block_size is unsupported" >> $seqres.full
+		continue
+	fi
+	test_block_size $block_size
+done
 
 # success, all done
 status=0
diff --git a/tests/generic/574.out b/tests/generic/574.out
index d40d1263..3ed57f1c 100644
--- a/tests/generic/574.out
+++ b/tests/generic/574.out
@@ -1,84 +1,11 @@
 QA output created by 574
 
-# Corruption test: file_len=131072 zap_offset=0 zap_len=5
-0dfbe8aa4c20b52e1b8bf3cb6cbdf193  SCRATCH_MNT/file.fsv
-Corrupting bytes...
-Validating corruption (reading full file)...
-md5sum: SCRATCH_MNT/file.fsv: Input/output error
-Validating corruption (direct I/O)...
-dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
-Validating corruption (reading just corrupted part)...
-dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
-Validating corruption (reading full file via mmap)...
-Bus error
-Validating corruption (reading just corrupted part via mmap)...
-Bus error
+# Testing block_size=FSV_BLOCK_SIZE
 
-# Corruption test: file_len=131072 zap_offset=4091 zap_len=5
-0dfbe8aa4c20b52e1b8bf3cb6cbdf193  SCRATCH_MNT/file.fsv
-Corrupting bytes...
-Validating corruption (reading full file)...
-md5sum: SCRATCH_MNT/file.fsv: Input/output error
-Validating corruption (direct I/O)...
-dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
-Validating corruption (reading just corrupted part)...
-dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
-Validating corruption (reading full file via mmap)...
-Bus error
-Validating corruption (reading just corrupted part via mmap)...
-Bus error
+# Testing block_size=1024 if supported
 
-# Corruption test: file_len=131072 zap_offset=65536 zap_len=65536
-0dfbe8aa4c20b52e1b8bf3cb6cbdf193  SCRATCH_MNT/file.fsv
-Corrupting bytes...
-Validating corruption (reading full file)...
-md5sum: SCRATCH_MNT/file.fsv: Input/output error
-Validating corruption (direct I/O)...
-dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
-Validating corruption (reading just corrupted part)...
-dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
-Validating corruption (reading full file via mmap)...
-Bus error
-Validating corruption (reading just corrupted part via mmap)...
-Bus error
+# Testing block_size=4096 if supported
 
-# Corruption test: file_len=131072 zap_offset=131067 zap_len=5
-0dfbe8aa4c20b52e1b8bf3cb6cbdf193  SCRATCH_MNT/file.fsv
-Corrupting bytes...
-Validating corruption (reading full file)...
-md5sum: SCRATCH_MNT/file.fsv: Input/output error
-Validating corruption (direct I/O)...
-dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
-Validating corruption (reading just corrupted part)...
-dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
-Validating corruption (reading full file via mmap)...
-Bus error
-Validating corruption (reading just corrupted part via mmap)...
-Bus error
+# Testing block_size=16384 if supported
 
-# Corruption test: EOF block
-f5cca0d7fbb8b02bc6118a9954d5d306  SCRATCH_MNT/file.fsv
-Corrupting bytes...
-Reading eof block via mmap into a temporary file...
-Checking for SIGBUS or zeros...
-OK
-
-# Corruption test: file_len=200000 zap_offset=100 (in Merkle tree) zap_len=10
-4a1e4325031b13f933ac4f1db9ecb63f  SCRATCH_MNT/file.fsv
-Corrupting bytes...
-Validating corruption (reading full file)...
-md5sum: SCRATCH_MNT/file.fsv: Input/output error
-Validating corruption (direct I/O)...
-dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
-Validating corruption (reading full file via mmap)...
-Bus error
-
-# Corruption test: file_len=200000 (sparse) zap_offset=100 (in Merkle tree) zap_len=10
-4a1e4325031b13f933ac4f1db9ecb63f  SCRATCH_MNT/file.fsv
-Corrupting bytes...
-Validating corruption (reading full file)...
-md5sum: SCRATCH_MNT/file.fsv: Input/output error
-Validating corruption (direct I/O)...
-dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
-Validating corruption (reading full file via mmap)...
-Bus error
+# Testing block_size=65536 if supported
-- 
2.39.0

