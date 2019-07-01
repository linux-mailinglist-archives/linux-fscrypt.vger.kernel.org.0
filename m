Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7B9555C2F5
	for <lists+linux-fscrypt@lfdr.de>; Mon,  1 Jul 2019 20:27:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbfGAS1a (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 1 Jul 2019 14:27:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:42070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726442AbfGAS13 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 1 Jul 2019 14:27:29 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2DF0321841;
        Mon,  1 Jul 2019 18:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1562005648;
        bh=h8X5PV0gURpdX3fp8i8QmUWNau3EZlWkadg+5EMJTw8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=1wTKmYV16nhawJp+A/nsuDx+zHyhaR3fOXdx7SSvs80cI8J61FDYtNk4KstfEMRem
         u7g5SYngIfgKdnyl7A1V4s4eracmGn96Zjjd2lfkri8YOX0IEfKh+tXIrwnfv64WHg
         ssEh2++KpxUCS0YUkv0YEpYcUNCu1LKtSh3KbkWA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [RFC PATCH v3 2/8] common/verity: add common functions for testing fs-verity
Date:   Mon,  1 Jul 2019 11:25:41 -0700
Message-Id: <20190701182547.165856-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190701182547.165856-1-ebiggers@kernel.org>
References: <20190701182547.165856-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add common functions for setting up and testing fs-verity, a new feature
for read-only file-based authenticity protection.  fs-verity will be
supported by ext4 and f2fs, and perhaps by other filesystems later.
Running the fs-verity tests requires:

- A kernel with the fs-verity patches from
  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/linux.git
  branch "fsverity" and configured with CONFIG_FS_VERITY.
- The fsverity utility program from
  https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git
- e2fsprogs v1.45.2 or later for ext4 tests, or f2fs-tools v1.11.0 or
  later for f2fs tests.

See the file Documentation/filesystems/fsverity.rst in the kernel tree
for more information about fs-verity.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/config |   1 +
 common/verity | 199 ++++++++++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 200 insertions(+)
 create mode 100644 common/verity

diff --git a/common/config b/common/config
index bd64be62..001ddc45 100644
--- a/common/config
+++ b/common/config
@@ -212,6 +212,7 @@ export CHECKBASHISMS_PROG="$(type -P checkbashisms)"
 export XFS_INFO_PROG="$(type -P xfs_info)"
 export DUPEREMOVE_PROG="$(type -P duperemove)"
 export CC_PROG="$(type -P cc)"
+export FSVERITY_PROG="$(type -P fsverity)"
 
 # use 'udevadm settle' or 'udevsettle' to wait for lv to be settled.
 # newer systems have udevadm command but older systems like RHEL5 don't.
diff --git a/common/verity b/common/verity
new file mode 100644
index 00000000..a8aae51e
--- /dev/null
+++ b/common/verity
@@ -0,0 +1,199 @@
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2018 Google LLC
+#
+# Functions for setting up and testing fs-verity
+
+_require_scratch_verity()
+{
+	_require_scratch
+	_require_command "$FSVERITY_PROG" fsverity
+
+	if ! _scratch_mkfs_verity &>>$seqres.full; then
+		# ext4: need e2fsprogs v1.44.5 or later (but actually v1.45.2+
+		#       is needed for some tests to pass, due to an e2fsck bug)
+		# f2fs: need f2fs-tools v1.11.0 or later
+		_notrun "$FSTYP userspace tools don't support fs-verity"
+	fi
+
+	# Try to mount the filesystem.  If this fails then either the kernel
+	# isn't aware of fs-verity, or the mkfs options were not compatible with
+	# verity (e.g. ext4 with block size != PAGE_SIZE).
+	if ! _try_scratch_mount &>>$seqres.full; then
+		_notrun "kernel is unaware of $FSTYP verity feature," \
+			"or mkfs options are not compatible with verity"
+	fi
+
+	# The filesystem may be aware of fs-verity but have it disabled by
+	# CONFIG_FS_VERITY=n.  Detect support via sysfs.
+	if [ ! -e /sys/fs/$FSTYP/features/verity ]; then
+		_notrun "kernel $FSTYP isn't configured with verity support"
+	fi
+
+	# The filesystem may have fs-verity enabled but not actually usable by
+	# default.  E.g., ext4 only supports verity on extent-based files, so it
+	# doesn't work on ext3-style filesystems.  So, try actually using it.
+	echo foo > $SCRATCH_MNT/tmpfile
+	if ! _fsv_enable $SCRATCH_MNT/tmpfile; then
+		_notrun "$FSTYP verity isn't usable by default with these mkfs options"
+	fi
+	rm -f $SCRATCH_MNT/tmpfile
+
+	_scratch_unmount
+
+	# Merkle tree block size.  Currently all filesystems only support
+	# PAGE_SIZE for this.  This is also the default for 'fsverity enable'.
+	FSV_BLOCK_SIZE=$(get_page_size)
+}
+
+_scratch_mkfs_verity()
+{
+	case $FSTYP in
+	ext4|f2fs)
+		_scratch_mkfs -O verity
+		;;
+	*)
+		_notrun "No verity support for $FSTYP"
+		;;
+	esac
+}
+
+_scratch_mkfs_encrypted_verity()
+{
+	case $FSTYP in
+	ext4)
+		_scratch_mkfs -O encrypt,verity
+		;;
+	f2fs)
+		# f2fs-tools as of v1.11.0 doesn't allow comma-separated
+		# features with -O.  Instead -O must be supplied multiple times.
+		_scratch_mkfs -O encrypt -O verity
+		;;
+	*)
+		_notrun "$FSTYP not supported in _scratch_mkfs_encrypted_verity"
+		;;
+	esac
+}
+
+_fsv_scratch_begin_subtest()
+{
+	local msg=$1
+
+	rm -rf "${SCRATCH_MNT:?}"/*
+	echo -e "\n# $msg"
+}
+
+_fsv_enable()
+{
+	$FSVERITY_PROG enable "$@"
+}
+
+_fsv_measure()
+{
+        $FSVERITY_PROG measure "$@" | awk '{print $1}'
+}
+
+# Generate a file, then enable verity on it.
+_fsv_create_enable_file()
+{
+	local file=$1
+	shift
+
+	head -c $((FSV_BLOCK_SIZE * 2)) /dev/zero > "$file"
+	_fsv_enable "$file" "$@"
+}
+
+_fsv_have_hash_algorithm()
+{
+	local hash_alg=$1
+	local test_file=$2
+
+	rm -f $test_file
+	head -c 4096 /dev/zero > $test_file
+	if ! _fsv_enable --hash-alg=$hash_alg $test_file &>> $seqres.full; then
+		# no kernel support
+		return 1
+	fi
+	rm -f $test_file
+	return 0
+}
+
+#
+# _fsv_scratch_corrupt_bytes - Write some bytes to a file, bypassing the filesystem
+#
+# Write the bytes sent on stdin to the given offset in the given file, but do so
+# by writing directly to the extents on the block device, with the filesystem
+# unmounted.  This can be used to corrupt a verity file for testing purposes,
+# bypassing the restrictions imposed by the filesystem.
+#
+# The file is assumed to be located on $SCRATCH_DEV.
+#
+_fsv_scratch_corrupt_bytes()
+{
+	local file=$1
+	local offset=$2
+	local lstart lend pstart pend
+	local dd_cmds=()
+	local cmd
+
+	sync	# Sync to avoid unwritten extents
+
+	cat > $tmp.bytes
+	local end=$(( offset + $(stat -c %s $tmp.bytes ) ))
+
+	# For each extent that intersects the requested range in order, add a
+	# command that writes the next part of the data to that extent.
+	while read -r lstart lend pstart pend; do
+		lstart=$((lstart * 512))
+		lend=$(((lend + 1) * 512))
+		pstart=$((pstart * 512))
+		pend=$(((pend + 1) * 512))
+
+		if (( lend - lstart != pend - pstart )); then
+			_fail "Logical and physical extent lengths differ for file '$file'"
+		elif (( offset < lstart )); then
+			_fail "Hole in file '$file' at byte $offset.  Next extent begins at byte $lstart"
+		elif (( offset < lend )); then
+			local len=$((lend - offset))
+			local seek=$((pstart + (offset - lstart)))
+			dd_cmds+=("head -c $len | dd of=$SCRATCH_DEV oflag=seek_bytes seek=$seek status=none")
+			(( offset += len ))
+		fi
+	done < <($XFS_IO_PROG -r -c "fiemap $offset $((end - offset))" "$file" \
+		 | _filter_xfs_io_fiemap)
+
+	if (( offset < end )); then
+		_fail "Extents of file '$file' ended at byte $offset, but needed until $end"
+	fi
+
+	# Execute the commands to write the data
+	_scratch_unmount
+	for cmd in "${dd_cmds[@]}"; do
+		eval "$cmd"
+	done < $tmp.bytes
+	sync	# Sync to flush the block device's pagecache
+	_scratch_mount
+}
+
+#
+# _fsv_scratch_corrupt_merkle_tree - Corrupt a file's Merkle tree
+#
+# Like _fsv_scratch_corrupt_bytes(), but this corrupts the file's fs-verity
+# Merkle tree.  The offset is given as a byte offset into the Merkle tree.
+#
+_fsv_scratch_corrupt_merkle_tree()
+{
+	local file=$1
+	local offset=$2
+
+	case $FSTYP in
+	ext4|f2fs)
+		# ext4 and f2fs store the Merkle tree after the file contents
+		# itself, starting at the next 65536-byte aligned boundary.
+		(( offset += ($(stat -c %s $file) + 65535) & ~65535 ))
+		_fsv_scratch_corrupt_bytes $file $offset
+		;;
+	*)
+		_fail "_fsv_scratch_corrupt_merkle_tree() unimplemented on $FSTYP"
+		;;
+	esac
+}
-- 
2.22.0.410.gd8fdbe21b5-goog

