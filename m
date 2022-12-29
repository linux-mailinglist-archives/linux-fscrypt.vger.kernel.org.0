Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D35A165933B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Dec 2022 00:35:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234258AbiL2XfM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Dec 2022 18:35:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234257AbiL2XfI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Dec 2022 18:35:08 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0050F1743A;
        Thu, 29 Dec 2022 15:35:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6994B6199F;
        Thu, 29 Dec 2022 23:35:05 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7A0EC4339B;
        Thu, 29 Dec 2022 23:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672356904;
        bh=gKzCrHy+xzu6Nmwb6CFTwBoc7U+Riz8cqbTqN4FSbyI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dq0DABxPUyiT1xxLcC8eUjc08rMDSKi/ZOtDfm+C9yVJH8OS1CdXxOPE8Z7/jk1nx
         5FiRdK7IaufB2BwLzP86JzlRAC//jnBF9zFgpwBTie2GC0+yK5VWFeAFzThca4VgYg
         WKkbTki9if8nXghtAzi5RBy/FakcKM6kzYG7FP2XQSmUGkclbEx8kW94EN7wwVwagU
         YD+vc3Q7Yo24z4RWtZVYkEmSbeGJFm035xB91mYeMXZ2DEyCoKsqHwxKVVeTVHKPGT
         1vSXRshTEeeDUyMhGirpzxlcBXHh+5nCDs33r9BPnMXF2Z4lQucxzE5Dg6F1JlMwel
         lA+UDS5fRj9ew==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v3 08/10] generic/574: test multiple Merkle tree block sizes
Date:   Thu, 29 Dec 2022 15:32:20 -0800
Message-Id: <20221229233222.119630-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221229233222.119630-1-ebiggers@kernel.org>
References: <20221229233222.119630-1-ebiggers@kernel.org>
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
 tests/generic/574     | 219 +++++++++++++++++++++++++-----------------
 tests/generic/574.out |  83 +---------------
 2 files changed, 136 insertions(+), 166 deletions(-)

diff --git a/tests/generic/574 b/tests/generic/574
index fd4488c9..5d121510 100755
--- a/tests/generic/574
+++ b/tests/generic/574
@@ -37,23 +37,19 @@ fsv_file=$SCRATCH_MNT/file.fsv
 
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
-}
-
-filter_sigbus()
-{
-	sed -e 's/.*Bus error.*/Bus error/'
+	_fsv_enable $fsv_file --block-size=$block_size
+	cmp $fsv_orig_file $fsv_file
 }
 
 round_up_to_page_boundary()
@@ -64,65 +60,100 @@ round_up_to_page_boundary()
 	echo $(( (n + page_size - 1) & ~(page_size - 1) ))
 }
 
+mread()
+{
+	local file=$1
+	local offset=$2
+	local length=$3
+	local map_len=$(round_up_to_page_boundary $(_get_filesize $file))
+
+	# Some callers expect xfs_io to crash with SIGBUS due to the mread,
+	# causing the shell to print "Bus error" to stderr.  To allow this
+	# message to be redirected, execute xfs_io in a new shell instance.
+	# However, for this to work reliably, we also need to prevent the new
+	# shell instance from optimizing out the fork and directly exec'ing
+	# xfs_io.  The easiest way to do that is to append 'true' to the
+	# commands, so that xfs_io is no longer the last command the shell sees.
+	bash -c "trap '' SIGBUS; $XFS_IO_PROG -r $file \
+		-c 'mmap -r 0 $map_len' \
+		-c 'mread -v $offset $length'; true"
+}
+
 corruption_test()
 {
-	local file_len=$1
-	local zap_offset=$2
-	local zap_len=$3
-	local is_merkle_tree=${4:-false} # if true, zap tree instead of data
-	local use_sparse_file=${5:-false}
-	local page_aligned_eof=$(round_up_to_page_boundary $file_len)
-	local measurement
+	local block_size=$1
+	local file_len=$2
+	local zap_offset=$3
+	local zap_len=$4
+	local is_merkle_tree=${5:-false} # if true, zap tree instead of data
+	local use_sparse_file=${6:-false}
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
+	if cat $fsv_file >/dev/null 2>$tmp.err; then
+		echo "Unexpectedly was able to read full file ($paramstr)"
+	elif ! grep -q 'Input/output error' $tmp.err; then
+		echo "Wrong error reading full file ($paramstr):"
+		cat $tmp.err
+	fi
 
-	echo "Validating corruption (direct I/O)..."
+	# Reading the full file with direct I/O should fail.
 	_scratch_cycle_mount
-	dd if=$fsv_file bs=$FSV_BLOCK_SIZE iflag=direct status=none \
-		of=/dev/null |& _filter_scratch
+	if dd if=$fsv_file bs=$fs_block_size iflag=direct status=none \
+		of=/dev/null 2>$tmp.err
+	then
+		echo "Unexpectedly was able to read full file with DIO ($paramstr)"
+	elif ! grep -q 'Input/output error' $tmp.err; then
+		echo "Wrong error reading full file with DIO ($paramstr):"
+		cat $tmp.err
+	fi
 
-	if (( zap_offset < file_len )) && ! $is_merkle_tree; then
-		echo "Validating corruption (reading just corrupted part)..."
-		dd if=$fsv_file bs=1 skip=$zap_offset count=$zap_len \
-			of=/dev/null status=none |& _filter_scratch
+	# Reading just the corrupted part of the file should fail.
+	if ! $is_merkle_tree; then
+		if dd if=$fsv_file bs=1 skip=$zap_offset count=$zap_len \
+			of=/dev/null status=none 2>$tmp.err; then
+			echo "Unexpectedly was able to read corrupted part ($paramstr)"
+		elif ! grep -q 'Input/output error' $tmp.err; then
+			echo "Wrong error reading corrupted part ($paramstr):"
+			cat $tmp.err
+		fi
 	fi
 
-	echo "Validating corruption (reading full file via mmap)..."
-	bash -c "trap '' SIGBUS; $XFS_IO_PROG -r $fsv_file \
-		-c 'mmap -r 0 $page_aligned_eof' \
-		-c 'mread 0 $file_len'" |& filter_sigbus
+	# Reading the full file via mmap should fail.
+	mread $fsv_file 0 $file_len >/dev/null 2>$tmp.err
+	if ! grep -q 'Bus error' $tmp.err; then
+		echo "Didn't see SIGBUS when reading file via mmap"
+		cat $tmp.err
+	fi
 
+	# Reading just the corrupted part via mmap should fail.
 	if ! $is_merkle_tree; then
-		echo "Validating corruption (reading just corrupted part via mmap)..."
-		bash -c "trap '' SIGBUS; $XFS_IO_PROG -r $fsv_file \
-			-c 'mmap -r 0 $page_aligned_eof' \
-			-c 'mread $zap_offset $zap_len'" |& filter_sigbus
+		mread $fsv_file $zap_offset $zap_len >/dev/null 2>$tmp.err
+		if ! grep -q 'Bus error' $tmp.err; then
+			echo "Didn't see SIGBUS when reading corrupted part via mmap"
+			cat $tmp.err
+		fi
 	fi
 }
 
@@ -131,52 +162,64 @@ corruption_test()
 # return zeros in the last block past EOF, regardless of the contents on
 # disk. In the former, corruption should be detected and result in SIGBUS,
 # while in the latter we would expect zeros past EOF, but no error.
-corrupt_eof_block_test() {
-	local file_len=$1
-	local zap_len=$2
-	local page_aligned_eof=$(round_up_to_page_boundary $file_len)
-	_fsv_scratch_begin_subtest "Corruption test: EOF block"
-	setup_zeroed_file $file_len false
-	cmp $fsv_file $fsv_orig_file
-	echo "Corrupting bytes..."
+corrupt_eof_block_test()
+{
+	local block_size=$1
+	local file_len=$2
+	local zap_len=$3
+
+	rm -rf "${SCRATCH_MNT:?}"/*
+	setup_zeroed_file $block_size $file_len false
 	head -c $zap_len /dev/zero | tr '\0' X \
 		| _fsv_scratch_corrupt_bytes $fsv_file $file_len
 
-	echo "Reading eof block via mmap into a temporary file..."
-	bash -c "trap '' SIGBUS; $XFS_IO_PROG -r $fsv_file \
-		-c 'mmap -r 0 $page_aligned_eof' \
-		-c 'mread -v $file_len $zap_len'" \
-		|& filter_sigbus >$tmp.eof_block_read 2>&1
-
-	head -c $file_len /dev/zero > $tmp.zero_cmp_file
-	$XFS_IO_PROG -r $tmp.zero_cmp_file \
-		-c "mmap -r 0 $page_aligned_eof" \
-		-c "mread -v $file_len $zap_len" >$tmp.eof_zero_read
-
-	echo "Checking for SIGBUS or zeros..."
-	grep -q -e '^Bus error$' $tmp.eof_block_read \
-		|| diff $tmp.eof_block_read $tmp.eof_zero_read \
-		&& echo "OK"
-}
-
-# Note: these tests just overwrite some bytes without checking their original
-# values.  Therefore, make sure to overwrite at least 5 or so bytes, to make it
-# nearly guaranteed that there will be a change -- even when the test file is
-# encrypted due to the test_dummy_encryption mount option being specified.
+	mread $fsv_file $file_len $zap_len >$tmp.out 2>$tmp.err
 
-corruption_test 131072 0 5
-corruption_test 131072 4091 5
-corruption_test 131072 65536 65536
-corruption_test 131072 131067 5
+	head -c $file_len /dev/zero >$tmp.zeroes
+	mread $tmp.zeroes $file_len $zap_len >$tmp.zeroes_out
 
-corrupt_eof_block_test 130999 72
+	grep -q 'Bus error' $tmp.err || diff $tmp.out $tmp.zeroes_out
+}
 
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

