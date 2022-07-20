Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E19357AB26
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 Jul 2022 02:50:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237769AbiGTAuC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 Jul 2022 20:50:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiGTAuB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 Jul 2022 20:50:01 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62E3A61D6B;
        Tue, 19 Jul 2022 17:50:00 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 7CCFE3200681;
        Tue, 19 Jul 2022 20:49:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Tue, 19 Jul 2022 20:49:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1658278199; x=1658364599; bh=Uk
        rYvFlRpiuI9bgGcj6/LVlmIrB89hPXFscFDCWi2WA=; b=mXwQ/S/xFxFHPePKO9
        CzbqFUhHUcRFd54aDngtR/7r1tuc54A+HmLPbCazl95enfAbGHgyJVl7w6WpuxCo
        KIwZrlXFuPX1s8ltnDivB0GHZ8fPw48FLDFXGog1jm+C6hBcEs0Bh5snYO2v+v/z
        EyIto/ruXrAC0K8EB7TmGreuXKifBK4z4uDXq9I88AuGXYqW4Pa6TNQo2MpfCNAo
        ATA65IeNvorCyu7TUQ6p7Awo7d7hOuE3nDhTIQvuKr2BjKuhZIxe7U8r7JE2FsFh
        acKVEgfMbBOAkc9UPj/bC/pWeoA6MpD/PIqNrXKj8mUEEmZXxAIwIpavMuLDvbAH
        IWtg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658278199; x=1658364599; bh=UkrYvFlRpiuI9
        bgGcj6/LVlmIrB89hPXFscFDCWi2WA=; b=WmZmGNkahu7HYJUgOPClEa0dM1Ozp
        d1AA/I51CZPz9d/NuYlJpMBD03m/ezj+GZEMfz9V5s5bbp5Zf7cDlDiGhzKA03sn
        W2KAQC/cjbvHDtFwAAT9M9AXc2Mzpfnrs3RVzykUhiQg0Qupz5+oZNegnyD+lbLq
        6ZqAKvR9BoEv3+yk721uE3rnKAS5DvgYbNmtznieV7o0SrxHqfScdsUVtOSkNE2H
        LB/h9HlIww8LaJYC+7wfOVRiw0XuF6kSWETrvQyNxRYWLJg1t1oUqxyoWGyzF3z6
        Cs0ZZrpjqqVMkysAUqqmnU2r5CpEFGHuE8Q/XxOzoJX7EJuG87Useq2uQ==
X-ME-Sender: <xms:NlHXYnBDxmgFxB7AlyVbO-p4frwxcAnFqETqQIRSJ4QqxbJvsAfxOw>
    <xme:NlHXYthyN1B1dMjAu9lUy0YvsYdCIsQahR5ymx2eniOF0ItqrvCG1L9SSsAsuEOga
    XIq0bDqMgP2V5NpXcc>
X-ME-Received: <xmr:NlHXYilOSh8hpFuJIsPykLgDo5ihG_U3OWlFisB5BElarqQfpSuEPejtFZjMmKB6FFIuJ2Ztvino5mebBkmFnhRH6ELJiQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeluddgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdr
    ihhoqeenucggtffrrghtthgvrhhnpeeiueffuedvieeujefhheeigfekvedujeejjeffve
    dvhedtudefiefhkeegueehleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:NlHXYpyJi_Wh0KOxNLwKwoeIlpQmNTmEVNTRtdUZE7dlUbt9Ev4NeA>
    <xmx:NlHXYsSDH0pIM6_AolEqlFeu7zjf7wO7oqIRMMxuQ0veMk6zdQaJUA>
    <xmx:NlHXYsbOY9HdBj26gHqwYWt1otBgb9kPCim65af4IqNJEaOOosiqfA>
    <xmx:N1HXYnfFBaUajbUShcUeBaEiiKCNNg_TI_QZ1_y0xZnFKzoH3vOdmQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Jul 2022 20:49:58 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v13 2/5] common/verity: support btrfs in generic fsverity tests
Date:   Tue, 19 Jul 2022 17:49:47 -0700
Message-Id: <2bbb68b90691a82b8143ba4612ea2cc761e44ecb.1658277755.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658277755.git.boris@bur.io>
References: <cover.1658277755.git.boris@bur.io>
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
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 common/btrfs          |  5 +++++
 common/config         |  1 +
 common/verity         | 31 +++++++++++++++++++++++++++++++
 tests/generic/574     | 37 ++++++++++++++++++++++++++++++++++---
 tests/generic/574.out | 13 ++++---------
 5 files changed, 75 insertions(+), 12 deletions(-)

diff --git a/common/btrfs b/common/btrfs
index 14ad890e..bd2639bf 100644
--- a/common/btrfs
+++ b/common/btrfs
@@ -580,3 +580,8 @@ _btrfs_buffered_read_on_mirror()
 		:
 	done
 }
+
+_require_btrfs_corrupt_block()
+{
+	_require_command "$BTRFS_CORRUPT_BLOCK_PROG" btrfs-corrupt-block
+}
diff --git a/common/config b/common/config
index de3aba15..c30eec6d 100644
--- a/common/config
+++ b/common/config
@@ -297,6 +297,7 @@ export BTRFS_UTIL_PROG=$(type -P btrfs)
 export BTRFS_SHOW_SUPER_PROG=$(type -P btrfs-show-super)
 export BTRFS_CONVERT_PROG=$(type -P btrfs-convert)
 export BTRFS_TUNE_PROG=$(type -P btrfstune)
+export BTRFS_CORRUPT_BLOCK_PROG=$(type -P btrfs-corrupt-block)
 export XFS_FSR_PROG=$(type -P xfs_fsr)
 export MKFS_NFS_PROG="false"
 export MKFS_CIFS_PROG="false"
diff --git a/common/verity b/common/verity
index d58cad90..4c50d2b1 100644
--- a/common/verity
+++ b/common/verity
@@ -3,6 +3,16 @@
 #
 # Functions for setting up and testing fs-verity
 
+# btrfs will return IO errors on corrupted data with or without fs-verity.
+# to really test fs-verity, use nodatasum.
+if [ "$FSTYP" == "btrfs" ]; then
+        if [ -z "$MOUNT_OPTIONS" ]; then
+                export MOUNT_OPTIONS="-o nodatasum"
+        else
+                export MOUNT_OPTIONS+=" -o nodatasum"
+        fi
+fi
+
 _require_scratch_verity()
 {
 	_require_scratch
@@ -145,6 +155,9 @@ _require_fsverity_dump_metadata()
 _require_fsverity_corruption()
 {
 	_require_xfs_io_command "fiemap"
+	if [ $FSTYP == "btrfs" ]; then
+		_require_btrfs_corrupt_block
+	fi
 }
 
 _scratch_mkfs_verity()
@@ -153,6 +166,9 @@ _scratch_mkfs_verity()
 	ext4|f2fs)
 		_scratch_mkfs -O verity
 		;;
+	btrfs)
+		_scratch_mkfs
+		;;
 	*)
 		_notrun "No verity support for $FSTYP"
 		;;
@@ -314,6 +330,21 @@ _fsv_scratch_corrupt_merkle_tree()
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
index 17fdea52..fd4488c9 100755
--- a/tests/generic/574
+++ b/tests/generic/574
@@ -126,6 +126,39 @@ corruption_test()
 	fi
 }
 
+# Reading the last block of the file with mmap is tricky, so we need to be
+# a bit careful. Some filesystems read the last block in full, while others
+# return zeros in the last block past EOF, regardless of the contents on
+# disk. In the former, corruption should be detected and result in SIGBUS,
+# while in the latter we would expect zeros past EOF, but no error.
+corrupt_eof_block_test() {
+	local file_len=$1
+	local zap_len=$2
+	local page_aligned_eof=$(round_up_to_page_boundary $file_len)
+	_fsv_scratch_begin_subtest "Corruption test: EOF block"
+	setup_zeroed_file $file_len false
+	cmp $fsv_file $fsv_orig_file
+	echo "Corrupting bytes..."
+	head -c $zap_len /dev/zero | tr '\0' X \
+		| _fsv_scratch_corrupt_bytes $fsv_file $file_len
+
+	echo "Reading eof block via mmap into a temporary file..."
+	bash -c "trap '' SIGBUS; $XFS_IO_PROG -r $fsv_file \
+		-c 'mmap -r 0 $page_aligned_eof' \
+		-c 'mread -v $file_len $zap_len'" \
+		|& filter_sigbus >$tmp.eof_block_read 2>&1
+
+	head -c $file_len /dev/zero > $tmp.zero_cmp_file
+	$XFS_IO_PROG -r $tmp.zero_cmp_file \
+		-c "mmap -r 0 $page_aligned_eof" \
+		-c "mread -v $file_len $zap_len" >$tmp.eof_zero_read
+
+	echo "Checking for SIGBUS or zeros..."
+	grep -q -e '^Bus error$' $tmp.eof_block_read \
+		|| diff $tmp.eof_block_read $tmp.eof_zero_read \
+		&& echo "OK"
+}
+
 # Note: these tests just overwrite some bytes without checking their original
 # values.  Therefore, make sure to overwrite at least 5 or so bytes, to make it
 # nearly guaranteed that there will be a change -- even when the test file is
@@ -136,9 +169,7 @@ corruption_test 131072 4091 5
 corruption_test 131072 65536 65536
 corruption_test 131072 131067 5
 
-# Non-zeroed bytes in the final partial block beyond EOF should cause reads to
-# fail too.  Such bytes would be visible via mmap().
-corruption_test 130999 131000 72
+corrupt_eof_block_test 130999 72
 
 # Merkle tree corruption.
 corruption_test 200000 100 10 true
diff --git a/tests/generic/574.out b/tests/generic/574.out
index 3c08d3e8..d40d1263 100644
--- a/tests/generic/574.out
+++ b/tests/generic/574.out
@@ -56,17 +56,12 @@ Bus error
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
+Reading eof block via mmap into a temporary file...
+Checking for SIGBUS or zeros...
+OK
 
 # Corruption test: file_len=200000 zap_offset=100 (in Merkle tree) zap_len=10
 4a1e4325031b13f933ac4f1db9ecb63f  SCRATCH_MNT/file.fsv
-- 
2.37.1

