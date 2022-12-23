Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A503F654A65
	for <lists+linux-fscrypt@lfdr.de>; Fri, 23 Dec 2022 02:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235895AbiLWBLO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 22 Dec 2022 20:11:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41958 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235821AbiLWBKe (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 22 Dec 2022 20:10:34 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 001322180C;
        Thu, 22 Dec 2022 17:07:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8406361DE9;
        Fri, 23 Dec 2022 01:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43AC2C43398;
        Fri, 23 Dec 2022 01:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671757624;
        bh=Xsl4WRll+T0cwHktEtlV+O8N99M2H9MXi9xfwKWCoVg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=txWHB/fIbQuRfBc4oTcS5trIDNMAx7hrXVKvbxAMkHDL03vHs+3+Wz6QtiULiIwto
         XHIpMI4OPrrvoAiD3t5SDIqjUHvAilyszbpT8LZkTBi3/E/8md7Q0XIgRKUDXGvA0K
         3Ba4scxUhqBQugT7kdR1FmmU3XWyYddZAUiB+TF92nglviD5OLSJssdX+BwBgo3fjd
         l1t/6mCzIzUwFe21Zt9paqwUu0C4WZx5LAL6oPsKPftXNQR6yBcVcYrEDQpMo/da/E
         7SiC5Zx6xxelTF08Y1skw3SNNVqf9V20fobORPcshPf9cSID/xOVffxG8FvIL5/dQZ
         JjYdn6CM6sFKg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 09/10] generic/624: test multiple Merkle tree block sizes
Date:   Thu, 22 Dec 2022 17:05:53 -0800
Message-Id: <20221223010554.281679-10-ebiggers@kernel.org>
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

This required reworking the test to compute the expected digests using
the 'fsverity digest' command, instead of relying on .out file
comparisons.  (There isn't much downside to this, since comparison to
known-good file digests already happens in generic/575.  So if both the
kernel and fsverity-utils were to be broken in the same way, generic/575
would detect it.  generic/624 serves a different purpose.)

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/verity         |  11 ++++
 tests/generic/624     | 119 ++++++++++++++++++++++++++++++------------
 tests/generic/624.out |  15 ++----
 3 files changed, 101 insertions(+), 44 deletions(-)

diff --git a/common/verity b/common/verity
index b88e839b..77c257d3 100644
--- a/common/verity
+++ b/common/verity
@@ -263,6 +263,17 @@ _fsv_measure()
         $FSVERITY_PROG measure "$@" | awk '{print $1}'
 }
 
+_fsv_digest()
+{
+	local args=("$@")
+	# If the caller didn't explicitly specify a Merkle tree block size, then
+	# use FSV_BLOCK_SIZE.
+	if ! [[ " $*" =~ " --block-size" ]]; then
+		args+=("--block-size=$FSV_BLOCK_SIZE")
+	fi
+	$FSVERITY_PROG digest "${args[@]}" | awk '{print $1}'
+}
+
 _fsv_sign()
 {
 	local args=("$@")
diff --git a/tests/generic/624 b/tests/generic/624
index 7c447289..db4b6731 100755
--- a/tests/generic/624
+++ b/tests/generic/624
@@ -24,48 +24,99 @@ _cleanup()
 _supported_fs generic
 _require_scratch_verity
 _disable_fsverity_signatures
-# For the output of this test to always be the same, it has to use a specific
-# Merkle tree block size.
-if [ $FSV_BLOCK_SIZE != 4096 ]; then
-	_notrun "4096-byte verity block size not supported on this platform"
-fi
+fsv_orig_file=$SCRATCH_MNT/file
+fsv_file=$SCRATCH_MNT/file.fsv
 
 _scratch_mkfs_verity &>> $seqres.full
 _scratch_mount
-
-echo -e "\n# Creating a verity file"
-fsv_file=$SCRATCH_MNT/file
-# Always use the same file contents, so that the output of the test is always
-# the same.  Also use a file that is large enough to have multiple Merkle tree
-# levels, so that the test verifies that the blocks are returned in the expected
-# order.  A 1 MB file with SHA-256 and a Merkle tree block size of 4096 will
-# have 3 Merkle tree blocks (3*4096 bytes): two at level 0 and one at level 1.
-head -c 1000000 /dev/zero > $fsv_file
-merkle_tree_size=$((3 * FSV_BLOCK_SIZE))
-fsverity_descriptor_size=256
-_fsv_enable $fsv_file --salt=abcd
+_fsv_create_enable_file $fsv_file
 _require_fsverity_dump_metadata $fsv_file
-_fsv_measure $fsv_file
 
-echo -e "\n# Dumping Merkle tree"
-_fsv_dump_merkle_tree $fsv_file | sha256sum
+# Test FS_IOC_READ_VERITY_METADATA on a file that uses the given Merkle tree
+# block size.
+test_block_size()
+{
+	local block_size=$1
+	local digest_size=32 # assuming SHA-256
+	local i
+
+	# Create the file.  Make the file size big enough to result in multiple
+	# Merkle tree levels being needed.  The following expression computes a
+	# file size that needs 2 blocks at level 0, and thus 1 block at level 1.
+	local file_size=$((block_size * (2 * (block_size / digest_size))))
+	head -c $file_size /dev/zero > $fsv_orig_file
+	local tree_params=("--salt=abcd" "--block-size=$block_size")
+	cp $fsv_orig_file $fsv_file
+	_fsv_enable $fsv_file "${tree_params[@]}"
+
+	# Use the 'fsverity digest' command to compute the expected Merkle tree,
+	# descriptor, and file digest.
+	#
+	# Ideally we'd just hard-code expected values into the .out file and
+	# echo the actual values.  That doesn't quite work here, since all these
+	# values depend on the Merkle tree block size, and the Merkle tree block
+	# sizes that are supported (and thus get tested here) vary.  Therefore,
+	# we calculate the expected values in userspace with the help of
+	# 'fsverity digest', then do explicit comparisons with them.  This works
+	# fine as long as fsverity-utils and the kernel don't get broken in the
+	# same way, in which case generic/575 should detect the problem anyway.
+	local expected_file_digest=$(_fsv_digest $fsv_orig_file \
+		"${tree_params[@]}" \
+		--out-merkle-tree=$tmp.merkle_tree.expected \
+		--out-descriptor=$tmp.descriptor.expected)
+	local merkle_tree_size=$(_get_filesize $tmp.merkle_tree.expected)
+	local descriptor_size=$(_get_filesize $tmp.descriptor.expected)
 
-echo -e "\n# Dumping Merkle tree (in chunks)"
-# The above test may get the whole tree in one read, so also try reading it in
-# chunks.
-for (( i = 0; i < merkle_tree_size; i += 997 )); do
-	_fsv_dump_merkle_tree $fsv_file --offset=$i --length=997
-done | sha256sum
+	# 'fsverity measure' should return the expected file digest.
+	local actual_file_digest=$(_fsv_measure $fsv_file)
+	if [ "$actual_file_digest" != "$expected_file_digest" ]; then
+		echo "Measure returned $actual_file_digest but expected $expected_file_digest"
+	fi
 
-echo -e "\n# Dumping descriptor"
-# Note that the hash that is printed here should be the same hash that was
-# printed by _fsv_measure above.
-_fsv_dump_descriptor $fsv_file | sha256sum
+	# Test dumping the Merkle tree.
+	_fsv_dump_merkle_tree $fsv_file > $tmp.merkle_tree.actual
+	if ! cmp $tmp.merkle_tree.expected $tmp.merkle_tree.actual; then
+		echo "Dumped Merkle tree didn't match"
+	fi
+
+	# Test dumping the Merkle tree in chunks.
+	for (( i = 0; i < merkle_tree_size; i += 997 )); do
+		_fsv_dump_merkle_tree $fsv_file --offset=$i --length=997
+	done > $tmp.merkle_tree.actual
+	if ! cmp $tmp.merkle_tree.expected $tmp.merkle_tree.actual; then
+		echo "Dumped Merkle tree (in chunks) didn't match"
+	fi
+
+	# Test dumping the descriptor.
+	_fsv_dump_descriptor $fsv_file > $tmp.descriptor.actual
+	if ! cmp $tmp.descriptor.expected $tmp.descriptor.actual; then
+		echo "Dumped descriptor didn't match"
+	fi
+
+	# Test dumping the descriptor in chunks.
+	for (( i = 0; i < descriptor_size; i += 13 )); do
+		_fsv_dump_descriptor $fsv_file --offset=$i --length=13
+	done > $tmp.descriptor.actual
+	if ! cmp $tmp.descriptor.expected $tmp.descriptor.actual; then
+		echo "Dumped descriptor (in chunks) didn't match"
+	fi
+}
 
-echo -e "\n# Dumping descriptor (in chunks)"
-for (( i = 0; i < fsverity_descriptor_size; i += 13 )); do
-	_fsv_dump_descriptor $fsv_file --offset=$i --length=13
-done | sha256sum
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
diff --git a/tests/generic/624.out b/tests/generic/624.out
index 912826d3..0ea19ee5 100644
--- a/tests/generic/624.out
+++ b/tests/generic/624.out
@@ -1,16 +1,11 @@
 QA output created by 624
 
-# Creating a verity file
-sha256:11e4f886bf2d70a6ef3a8b6ce8e8c62c9e5d3263208b9f120ae46791f124be73
+# Testing block_size=FSV_BLOCK_SIZE
 
-# Dumping Merkle tree
-db88cdad554734cd648a1bfbb5be7f86646c54397847aab0b3f42a28829fed17  -
+# Testing block_size=1024 if supported
 
-# Dumping Merkle tree (in chunks)
-db88cdad554734cd648a1bfbb5be7f86646c54397847aab0b3f42a28829fed17  -
+# Testing block_size=4096 if supported
 
-# Dumping descriptor
-11e4f886bf2d70a6ef3a8b6ce8e8c62c9e5d3263208b9f120ae46791f124be73  -
+# Testing block_size=16384 if supported
 
-# Dumping descriptor (in chunks)
-11e4f886bf2d70a6ef3a8b6ce8e8c62c9e5d3263208b9f120ae46791f124be73  -
+# Testing block_size=65536 if supported
-- 
2.39.0

