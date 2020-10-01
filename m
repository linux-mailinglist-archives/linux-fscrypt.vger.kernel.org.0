Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EE67027F6A5
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Oct 2020 02:25:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730258AbgJAAZd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Sep 2020 20:25:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:54454 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731951AbgJAAZc (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Sep 2020 20:25:32 -0400
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 44CCB21D46;
        Thu,  1 Oct 2020 00:25:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601511932;
        bh=PX2avfBQAT2272AnOXuwkHoRGp/VANtbvRz7e8rbYt0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=W45EFdy8MtRuN2/15xLai41d4mbzBngN0q3UQykAGibk4CpyIRQRot+go0Jx4IbWD
         cABRN3gdSk7+jboKmnpHYcJkTd7T+cj2cFIsPEc5yvFNhQ3q+42tiWtyf7xZIppqWE
         vLNQ0E+VbUOyeSJ+hJZuz0Fjg6xsLf2p7+CoTJ8g=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <yuchao0@huawei.com>,
        Daeho Jeong <daeho43@gmail.com>
Subject: [PATCH 5/5] f2fs: verify ciphertext of compressed+encrypted file
Date:   Wed, 30 Sep 2020 17:25:07 -0700
Message-Id: <20201001002508.328866-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.28.0
In-Reply-To: <20201001002508.328866-1-ebiggers@kernel.org>
References: <20201001002508.328866-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In Linux v5.6, f2fs added support for per-file compression.  f2fs
compression can be used in combination with the existing f2fs encryption
support (a.k.a. fscrypt), in which case the compressed data is encrypted
rather than the uncompressed data.

We need to verify that the encryption is actually being done as expected
in this case.  So add a test which verifies it.

For now this is a f2fs-specific test.  It's possible that ext4 will
implement compression in the same way as f2fs (in which case this could
be made a generic test), but for now there are no plans for that.

This complements the existing ciphertext verification tests, e.g.
generic/548, which don't handle compression.  Encryption+compression has
some unique considerations, so it requires its own test.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/config      |   1 +
 tests/f2fs/002     | 217 +++++++++++++++++++++++++++++++++++++++++++++
 tests/f2fs/002.out |  21 +++++
 tests/f2fs/group   |   1 +
 4 files changed, 240 insertions(+)
 create mode 100755 tests/f2fs/002
 create mode 100644 tests/f2fs/002.out

diff --git a/common/config b/common/config
index 3de87ea7..285b7d1f 100644
--- a/common/config
+++ b/common/config
@@ -202,6 +202,7 @@ export GETRICHACL_PROG="$(type -P getrichacl)"
 export SETRICHACL_PROG="$(type -P setrichacl)"
 export KEYCTL_PROG="$(type -P keyctl)"
 export XZ_PROG="$(type -P xz)"
+export LZ4_PROG="$(type -P lz4)"
 export FLOCK_PROG="$(type -P flock)"
 export LDD_PROG="$(type -P ldd)"
 export TIMEOUT_PROG="$(type -P timeout)"
diff --git a/tests/f2fs/002 b/tests/f2fs/002
new file mode 100755
index 00000000..9e6cb102
--- /dev/null
+++ b/tests/f2fs/002
@@ -0,0 +1,217 @@
+#!/bin/bash
+# SPDX-License-Identifier: GPL-2.0-only
+# Copyright 2020 Google LLC
+#
+# FS QA Test No. f2fs/002
+#
+# Test that when a file is both compressed and encrypted, the encryption is done
+# correctly.  I.e., the correct ciphertext is written to disk.
+#
+# f2fs compression behaves as follows: the original data of a compressed file is
+# divided into equal-sized clusters.  The cluster size is configurable, but it
+# must be a power-of-2 multiple of the filesystem block size.  If the file size
+# isn't a multiple of the cluster size, then the final cluster is "partial" and
+# holds the remainder modulo the cluster size.  Each cluster is compressed
+# independently.  Each cluster is stored compressed if it isn't partial and
+# compression would save at least 1 block, otherwise it is stored uncompressed.
+#
+# If the file is also encrypted, then the data is encrypted after compression
+# (or decrypted before decompression).  In a compressed cluster, the block
+# numbers used in the IVs for encryption start at logical_block_number + 1 and
+# increment from there.  E.g. if the first three clusters each compressed 8
+# blocks to 6 blocks, then the IVs used will be 1..6, 9..14, 17..22.
+# In comparison, uncompressed clusters would use 0..7, 8..15, 16..23.
+#
+# This test verifies that the encryption is actually being done in the expected
+# way.  This is critical, since the f2fs filesystem implementation uses
+# significantly different code for I/O to/from compressed files, and bugs (say,
+# a bug that caused the encryption to be skipped) may not otherwise be detected.
+#
+# To do this test, we create a file that is both compressed and encrypted,
+# retrieve its raw data from disk, decrypt it, decompress it, and compare the
+# result to the original file.  We can't do it the other way around (compress
+# and encrypt the original data, and compare it to the on-disk data) because
+# compression can produce many different outputs from the same input.  E.g. the
+# lz4 command-line tool may not give the same output as the kernel's lz4
+# implementation, even though both outputs will decompress to the original data.
+#
+# f2fs supports multiple compression algorithms, but the choice of compression
+# algorithm shouldn't make a difference for the purpose of this test.  So we
+# just test LZ4.
+
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	cd /
+	rm -f $tmp.*
+}
+
+. ./common/rc
+. ./common/filter
+. ./common/f2fs
+. ./common/encrypt
+
+rm -f $seqres.full
+
+_supported_fs f2fs
+
+# Prerequisites to create a file that is both encrypted and LZ4-compressed
+_require_scratch_encryption -v 2
+_require_scratch_f2fs_compression lz4
+_require_command "$CHATTR_PROG" chattr
+
+# Prerequisites to verify the ciphertext of the file
+_require_get_encryption_nonce_support
+_require_xfs_io_command "fiemap" # for _get_ciphertext_block_list()
+_require_test_program "fscrypt-crypt-util"
+_require_command "$LZ4_PROG" lz4
+
+# Test parameters
+compress_log_size=4
+num_compressible_clusters=5
+num_incompressible_clusters=2
+
+echo -e "\n# Creating filesystem that supports encryption and compression"
+_scratch_mkfs -O encrypt,compression,extra_attr >> $seqres.full
+_scratch_mount "-o compress_algorithm=lz4,compress_log_size=$compress_log_size"
+
+dir=$SCRATCH_MNT/dir
+file=$dir/file
+block_size=$(_get_block_size $SCRATCH_MNT)
+cluster_blocks=$((1 << compress_log_size))
+cluster_bytes=$((cluster_blocks * block_size))
+num_compressible_blocks=$((num_compressible_clusters * cluster_blocks))
+num_compressible_bytes=$((num_compressible_clusters * cluster_bytes))
+
+echo -e "\n# Creating directory"
+mkdir $dir
+
+echo -e "\n# Enabling encryption on the directory"
+_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY" >> $seqres.full
+_set_encpolicy $dir $TEST_KEY_IDENTIFIER
+
+echo -e "\n# Enabling compression on the directory"
+$CHATTR_PROG +c $dir
+
+echo -e "\n# Creating compressed+encrypted file"
+for (( i = 0; i < num_compressible_clusters; i++ )); do
+	# Fill each compressible cluster with 2 blocks of zeroes, then the rest
+	# random data.  This should make the compression save 1 block.  (Not 2,
+	# due to overhead.)  We don't want the data to be *too* compressible,
+	# since we want to see the encryption IVs increment within each cluster.
+	head -c $(( 2 * block_size )) /dev/zero
+	head -c $(( (cluster_blocks - 2) * block_size )) /dev/urandom
+done > $tmp.orig_data
+# Also append some incompressible clusters, just in case there is some problem
+# that affects only uncompressed data in a compressed file.
+head -c $(( num_incompressible_clusters * cluster_bytes )) /dev/urandom \
+	>> $tmp.orig_data
+# Also append a compressible partial cluster at the end, just in case there is
+# some problem specific to partial clusters at EOF.  However, the current
+# behavior of f2fs compression is that partial clusters are never compressed.
+head -c $(( cluster_bytes - block_size )) /dev/zero >> $tmp.orig_data
+
+cp $tmp.orig_data $file
+inode=$(stat -c %i $file)
+
+# Get the list of blocks that contain the file's raw data.
+#
+# This is a hack, because the only API to get this information is fiemap, which
+# doesn't directly support compression as it assumes a 1:1 mapping between
+# logical blocks and physical blocks.
+#
+# But as we have no other option, we use fiemap anyway.  We rely on some f2fs
+# implementation details which make it work well enough in practice for the
+# purpose of this test:
+#
+#   - f2fs writes the blocks of each compressed cluster contiguously.
+#   - fiemap on a f2fs file gives an extent for each compressed cluster,
+#     with length equal to its uncompressed size.
+#
+# Note that for each compressed cluster, there will be some extra blocks
+# appended which aren't actually part of the file.  But it's simplest to just
+# read these anyway and ignore them when actually doing the decompression.
+blocklist=$(_get_ciphertext_block_list $file)
+
+_scratch_unmount
+
+echo -e "\n# Getting file's encryption nonce"
+nonce=$(_get_encryption_nonce $SCRATCH_DEV $inode)
+
+echo -e "\n# Dumping the file's raw data"
+_dump_ciphertext_blocks $SCRATCH_DEV $blocklist > $tmp.raw
+
+echo -e "\n# Decrypting the file's data"
+TEST_RAW_KEY_HEX=$(echo "$TEST_RAW_KEY" | tr -d '\\x')
+decrypt_blocks()
+{
+	$here/src/fscrypt-crypt-util "$@"			\
+		--decrypt					\
+		--block-size=$block_size			\
+		--file-nonce=$nonce				\
+		--kdf=HKDF-SHA512				\
+		AES-256-XTS					\
+		$TEST_RAW_KEY_HEX
+}
+head -c $num_compressible_bytes $tmp.raw \
+	| decrypt_blocks --block-number=1 > $tmp.decrypted
+dd if=$tmp.raw bs=$cluster_bytes skip=$num_compressible_clusters status=none \
+	| decrypt_blocks --block-number=$num_compressible_blocks \
+	>> $tmp.decrypted
+
+# Decompress the compressed clusters using the lz4 command-line tool.
+#
+# Each f2fs compressed cluster begins with a 24-byte header, starting with the
+# compressed size in bytes (excluding the header) as a __le32.  The header is
+# followed by the actual compressed data; for LZ4, that means an LZ4 block.
+#
+# Unfortunately, the lz4 command-line tool only deals with LZ4 *frames*
+# (https://github.com/lz4/lz4/blob/master/doc/lz4_Frame_format.md) and can't
+# decompress LZ4 blocks directly.  So we have to extract the LZ4 block, then
+# wrap it with a minimal LZ4 frame.
+
+decompress_cluster()
+{
+	if (( $(stat -c %s "$1") < 24 )); then
+		_fail "Invalid compressed cluster (truncated)"
+	fi
+	compressed_size=$(od -td4 -N4 -An --endian=little $1 | awk '{print $1}')
+	if (( compressed_size <= 0 )); then
+		_fail "Invalid compressed cluster (bad compressed size)"
+	fi
+	(
+		echo -e -n '\x04\x22\x4d\x18' # LZ4 frame magic number
+		echo -e -n '\x40\x70\xdf'     # LZ4 frame descriptor
+		head -c 4 "$1"                # Compressed block size
+		dd if="$1" skip=24 iflag=skip_bytes bs=$compressed_size \
+			count=1 status=none
+		echo -e -n '\x00\x00\x00\x00' # Next block size (none)
+	) | $LZ4_PROG -d
+}
+
+echo -e "\n# Decompressing the file's data"
+for (( i = 0; i < num_compressible_clusters; i++ )); do
+	dd if=$tmp.decrypted bs=$cluster_bytes skip=$i count=1 status=none \
+		of=$tmp.cluster
+	decompress_cluster $tmp.cluster >> $tmp.uncompressed_data
+done
+# Append the incompressible clusters and the final partial cluster,
+# neither of which should have been compressed.
+dd if=$tmp.decrypted bs=$cluster_bytes skip=$num_compressible_clusters \
+	status=none >> $tmp.uncompressed_data
+
+# Finally do the actual test.  The data we got after decryption+decompression
+# should match the original file contents.
+echo -e "\n# Comparing to original data"
+cmp $tmp.uncompressed_data $tmp.orig_data
+
+status=0
+exit
diff --git a/tests/f2fs/002.out b/tests/f2fs/002.out
new file mode 100644
index 00000000..bc7bf9b3
--- /dev/null
+++ b/tests/f2fs/002.out
@@ -0,0 +1,21 @@
+QA output created by 002
+
+# Creating filesystem that supports encryption and compression
+
+# Creating directory
+
+# Enabling encryption on the directory
+
+# Enabling compression on the directory
+
+# Creating compressed+encrypted file
+
+# Getting file's encryption nonce
+
+# Dumping the file's raw data
+
+# Decrypting the file's data
+
+# Decompressing the file's data
+
+# Comparing to original data
diff --git a/tests/f2fs/group b/tests/f2fs/group
index daba9a30..7cd42fe4 100644
--- a/tests/f2fs/group
+++ b/tests/f2fs/group
@@ -4,3 +4,4 @@
 # - comment line before each group is "new" description
 #
 001 auto quick rw
+002 auto quick rw encrypt compress
-- 
2.28.0

