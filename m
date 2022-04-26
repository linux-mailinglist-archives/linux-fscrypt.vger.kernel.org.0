Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8CC78510C22
	for <lists+linux-fscrypt@lfdr.de>; Wed, 27 Apr 2022 00:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345860AbiDZWnd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Apr 2022 18:43:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355900AbiDZWnc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Apr 2022 18:43:32 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03AD514026;
        Tue, 26 Apr 2022 15:40:23 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id 668F45C0176;
        Tue, 26 Apr 2022 18:40:22 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 26 Apr 2022 18:40:22 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1651012822; x=1651099222; bh=YE
        aTmrniy5m8AfmjwUsMBxrwMa8bYqmGYLciN6SG0XY=; b=npPNJBDwePqBXGBfJq
        IaQnz1gKXTDUIh0CzEPnlLFlyyeYYYAyHM5jpxR92Cns92gqZmOuKQ+rOHx3Qe9b
        n5xng0oa67lXw/BZQvP+Ga8yv8SVckhQo1hwvmxH3gELCma4x/QHiPUnV54VfU4/
        GWwcQ9wBeU7VGYV79mhw4o7zBHBMVMZlFUuaogU9C1pvp9wL+zpGg4IAqFn9gV+H
        IhWtrLAkREyEtmhFLLhd2VdI5YzVeljSjztJbfUrKhAT4eGclvUlMxJnCGmxGju6
        C0LNTaCr2oMRWDJn6MzSXBVRM/61nVQdRJBpnYYqlSDPVyK5KgwjjXWSC94YjyFc
        PllQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1651012822; x=1651099222; bh=YEaTmrniy5m8AfmjwUsMBxrwMa8bYqmGYLc
        iN6SG0XY=; b=LD4rAQShqNhx5caDJR6OCo9RnZxpr4b1aZkZF08iZuSQDECvxH/
        8hvBUS62zJuyPhEnLJGQogQsIkZ2VQsuRsIkCX2GwQN6n1A3o/2Zfv/NICO8+fR5
        sPpHzeCfWT3dpoW2PhpXRxW/R8wanX9gLOfLasXZVmHTD3YCXYjrmNcqj6zUiE0n
        vi2Tdo7ZGBq9JNtWBuNLvfj3MiQAvk0Tn+XutP8U77+X+dX5ko5Z1NgFIDhZB9po
        5gU9BqjCcpCAgW7xOEgPhdZxX0CYZrK5TsOUTytlcY+Al0K7w1siCVJjq4tZmW7A
        LR/ddrFH7swfRNt8vd+VRNs7b/X4FyAZu2w==
X-ME-Sender: <xms:1nRoYlS4cpAHkmPmIxfw0AcZ5nQONlqknPjUmq0zH-16W57NZOVX3g>
    <xme:1nRoYuwP2p88QILkW3eV4M6i5MSlZUJ1lEr1EBVTTuuiUa48vWNQobLmr6TnBQ_4s
    pkUw5V5fAgx6AaqDCs>
X-ME-Received: <xmr:1nRoYq0nF0d4w3WlIslSKIX93jT2AtNAiBAd-oa017lWUdqLT0dEItymdUOR0a9Slj5MH6BTeU4Sik3AEmDSA8tXp6JlgA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeggddufecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvd
    ehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:1nRoYtC-4PC7apVgr0Fzi6mwruU0AakPxmODG8sMw-MAY57vxdan6w>
    <xmx:1nRoYujiI_-fFwlsVVC7XPzJPUxqvT-NqGunwADiMIfo7o_WwCXkag>
    <xmx:1nRoYhqp6r5uWFIrxDCEInahKCHTM0V6WDpyn8EYxEOugYvAoLEl4w>
    <xmx:1nRoYhtl4c1GqA5Vl_vDeqcxOI6U_wipTKfPvQgwCj0h-cF0VWrgAw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Apr 2022 18:40:22 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v9 2/5] common/verity: support btrfs in generic fsverity tests
Date:   Tue, 26 Apr 2022 15:40:13 -0700
Message-Id: <3ac2f088ab31052659aa37a7e2f0821ef7b95e60.1651012461.git.boris@bur.io>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651012461.git.boris@bur.io>
References: <cover.1651012461.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

generic/572-579 have tests for fsverity. Now that btrfs supports
fsverity, make these tests function as well. For a majority of the tests
that pass, simply adding the case to mkfs a btrfs filesystem with no
extra options is sufficient.

However, generic/574 has tests for corrupting the merkle tree itself.
Since btrfs uses a different scheme from ext4 and f2fs for storing this
data, the existing logic for corrupting it doesn't work out of the box.
Adapt it to properly corrupt btrfs merkle items.

576 does not run because btrfs does not support transparent encryption.

This test relies on the btrfs implementation of fsverity in the patch:
btrfs: initial fsverity support

and on btrfs-corrupt-block for corruption in the patches titled:
btrfs-progs: corrupt generic item data with btrfs-corrupt-block
btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block

Signed-off-by: Boris Burkov <boris@bur.io>
---
 common/btrfs          |  5 +++++
 common/config         |  1 +
 common/verity         | 28 ++++++++++++++++++++++++++++
 tests/generic/574     | 39 +++++++++++++++++++++++++++++++++++++--
 tests/generic/574.out | 12 +++---------
 5 files changed, 74 insertions(+), 11 deletions(-)

diff --git a/common/btrfs b/common/btrfs
index 670d9d1f..c3a7dc6e 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -511,3 +511,8 @@ _btrfs_metadump()
 	$BTRFS_IMAGE_PROG "$device" "$dumpfile"
 	[ -n "$DUMP_COMPRESSOR" ] && $DUMP_COMPRESSOR -f "$dumpfile" &> /dev/null
 }
+
+_require_btrfs_corrupt_block()
+{
+	_require_command "$BTRFS_CORRUPT_BLOCK_PROG" btrfs-corrupt-block
+}
diff --git a/common/config b/common/config
index 479e50d1..67bdf912 100644
--- a/common/config
+++ b/common/config
@@ -296,6 +296,7 @@ export BTRFS_UTIL_PROG=$(type -P btrfs)
 export BTRFS_SHOW_SUPER_PROG=$(type -P btrfs-show-super)
 export BTRFS_CONVERT_PROG=$(type -P btrfs-convert)
 export BTRFS_TUNE_PROG=$(type -P btrfstune)
+export BTRFS_CORRUPT_BLOCK_PROG=$(type -P btrfs-corrupt-block)
 export XFS_FSR_PROG=$(type -P xfs_fsr)
 export MKFS_NFS_PROG="false"
 export MKFS_CIFS_PROG="false"
diff --git a/common/verity b/common/verity
index d58cad90..8cde2737 100644
--- a/common/verity
+++ b/common/verity
@@ -3,6 +3,13 @@
 #
 # Functions for setting up and testing fs-verity
 
+. common/btrfs
+# btrfs will return IO errors on corrupted data with or without fs-verity.
+# to really test fs-verity, use nodatasum.
+if [ "$FSTYP" == "btrfs" ]; then
+	export MOUNT_OPTIONS="-o nodatasum"
+fi
+
 _require_scratch_verity()
 {
 	_require_scratch
@@ -145,6 +152,9 @@ _require_fsverity_dump_metadata()
 _require_fsverity_corruption()
 {
 	_require_xfs_io_command "fiemap"
+	if [ $FSTYP == "btrfs" ]; then
+		_require_btrfs_corrupt_block
+	fi
 }
 
 _scratch_mkfs_verity()
@@ -153,6 +163,9 @@ _scratch_mkfs_verity()
 	ext4|f2fs)
 		_scratch_mkfs -O verity
 		;;
+	btrfs)
+		_scratch_mkfs
+		;;
 	*)
 		_notrun "No verity support for $FSTYP"
 		;;
@@ -314,6 +327,21 @@ _fsv_scratch_corrupt_merkle_tree()
 		(( offset += ($(_get_filesize $file) + 65535) & ~65535 ))
 		_fsv_scratch_corrupt_bytes $file $offset
 		;;
+	btrfs)
+		local ino=$(stat -c '%i' $file)
+		_scratch_unmount
+		local byte=""
+		while read -n 1 byte; do
+			local ascii=$(printf "%d" "'$byte'")
+			# This command will find a Merkle tree item for the inode (-I $ino,37,0)
+			# in the default filesystem tree (-r 5) and corrupt one byte (-b 1) at
+			# $offset (-o $offset) with the ascii representation of the byte we read
+			# (-v $ascii)
+			$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,37,0 -v $ascii -o $offset -b 1 $SCRATCH_DEV
+			(( offset += 1 ))
+		done
+		_scratch_mount
+		;;
 	*)
 		_fail "_fsv_scratch_corrupt_merkle_tree() unimplemented on $FSTYP"
 		;;
diff --git a/tests/generic/574 b/tests/generic/574
index 17fdea52..680cece3 100755
--- a/tests/generic/574
+++ b/tests/generic/574
@@ -126,6 +126,41 @@ corruption_test()
 	fi
 }
 
+# xfs_io mread's output is parseable by xxd -r, except it has an extra space
+# after the colon. Output the number of non zero characters in the parsed contents.
+filter_mread() {
+	sed 's/:  /: /' | xxd -r | sed 's/\x0//g' | wc -c
+}
+
+# this expects to see stdout + stderr passed through filter_sigbus and filter_mread.
+# Outputs "OK" on a bus error or 0 non-zero characters counted by mread.
+filter_eof_block() {
+	sed 's/^Bus error$/OK/' | sed 's/^0$/OK/'
+}
+
+# some filesystems return zeros in the last block past EOF, regardless of
+# their contents. Handle those with a special test that accepts either zeros
+# or SIGBUS on an mmap+read of that block.
+corrupt_eof_block_test() {
+	local file_len=$1
+	local zap_len=$2
+	local page_aligned_eof=$(round_up_to_page_boundary $file_len)
+	local eof_page_start=$((page_aligned_eof - $(get_page_size)))
+	local corrupt_func=_fsv_scratch_corrupt_bytes
+	_fsv_scratch_begin_subtest "Corruption test: EOF block"
+	setup_zeroed_file $file_len false
+	cmp $fsv_file $fsv_orig_file
+	echo "Corrupting bytes..."
+	head -c $zap_len /dev/zero | tr '\0' X \
+		| $corrupt_func $fsv_file $((file_len + 1))
+
+	echo "Validating corruption or zeros (reading eof block via mmap)..."
+	bash -c "trap '' SIGBUS; $XFS_IO_PROG -r $fsv_file \
+		-c 'mmap -r $eof_page_start $(get_page_size)' \
+		-c 'mread -v $eof_page_start $(get_page_size)'" \
+		|& filter_mread | filter_sigbus | filter_eof_block
+}
+
 # Note: these tests just overwrite some bytes without checking their original
 # values.  Therefore, make sure to overwrite at least 5 or so bytes, to make it
 # nearly guaranteed that there will be a change -- even when the test file is
@@ -137,8 +172,8 @@ corruption_test 131072 65536 65536
 corruption_test 131072 131067 5
 
 # Non-zeroed bytes in the final partial block beyond EOF should cause reads to
-# fail too.  Such bytes would be visible via mmap().
-corruption_test 130999 131000 72
+# fail too.  Such bytes could be visible via mmap().
+corrupt_eof_block_test 130999 72
 
 # Merkle tree corruption.
 corruption_test 200000 100 10 true
diff --git a/tests/generic/574.out b/tests/generic/574.out
index 3c08d3e8..51bbd17b 100644
--- a/tests/generic/574.out
+++ b/tests/generic/574.out
@@ -56,17 +56,11 @@ Bus error
 Validating corruption (reading just corrupted part via mmap)...
 Bus error
 
-# Corruption test: file_len=130999 zap_offset=131000 zap_len=72
+# Corruption test: EOF block
 f5cca0d7fbb8b02bc6118a9954d5d306  SCRATCH_MNT/file.fsv
 Corrupting bytes...
-Validating corruption (reading full file)...
-md5sum: SCRATCH_MNT/file.fsv: Input/output error
-Validating corruption (direct I/O)...
-dd: error reading 'SCRATCH_MNT/file.fsv': Input/output error
-Validating corruption (reading full file via mmap)...
-Bus error
-Validating corruption (reading just corrupted part via mmap)...
-Bus error
+Validating corruption or zeros (reading eof block via mmap)...
+OK
 
 # Corruption test: file_len=200000 zap_offset=100 (in Merkle tree) zap_len=10
 4a1e4325031b13f933ac4f1db9ecb63f  SCRATCH_MNT/file.fsv
-- 
2.35.1

