Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 42B5D649302
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Dec 2022 08:08:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230025AbiLKHH6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Dec 2022 02:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230036AbiLKHHx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Dec 2022 02:07:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99EC55F5C;
        Sat, 10 Dec 2022 23:07:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1BD5160DBC;
        Sun, 11 Dec 2022 07:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D09AEC433F1;
        Sun, 11 Dec 2022 07:07:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670742466;
        bh=b3bIyJ4TnmtvkkKCix58sU220caoIb+53Q6lkzuhMeI=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=tjJMCnhmkHUKiZwg7MoQcnXBZPK1T2sUc1tdHXOewNRqHK9o5Q9m0DQB+jbDHuqQz
         OtZfCj1Yd4o2Y7GmHfLYRIx7q/qIllgi5tp9P7DoK/n+JMNLiaU4ayb/TrtnlaXszI
         5ETm9l/ygG1orYwgm06WIthlM5EsM2a8IW5Hgs98u8t32uiTjj9UYwLmyfD+zg3OVC
         jHpa0BYgbu7Y3svnBejxPaAdo9+VoDB0hYMG0baJgtu9iD5+MERXSSUiVnRbv29Dk7
         jWozXnYwf5ap0AGuaNwoKIYhLO4Cc2udze1b1oYa0XJGJ7lzYfDfGXZIgXm197qXKJ
         zHGmO+3sxt4hQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 10/10] generic/575: test 1K Merkle tree block size
Date:   Sat, 10 Dec 2022 23:07:03 -0800
Message-Id: <20221211070704.341481-11-ebiggers@kernel.org>
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

In addition to 4K, test 1K Merkle tree blocks.  Also always run this
test, regardless of FSV_BLOCK_SIZE, but allow skipping tests of
parameters that are unsupported, unless they are the default.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/575     | 58 ++++++++++++++++++++++++++++++-------------
 tests/generic/575.out |  8 ++++--
 2 files changed, 47 insertions(+), 19 deletions(-)

diff --git a/tests/generic/575 b/tests/generic/575
index 0ece8826..ddc10104 100755
--- a/tests/generic/575
+++ b/tests/generic/575
@@ -4,7 +4,7 @@
 #
 # FS QA Test generic/575
 #
-# Test that fs-verity is using the correct measurement values.  This test
+# Test that fs-verity is using the correct file digest values.  This test
 # verifies that fs-verity is doing its Merkle tree-based hashing correctly,
 # i.e. that it hasn't been broken by a change.
 #
@@ -26,9 +26,6 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _require_scratch_verity
-if [ $FSV_BLOCK_SIZE != 4096 ]; then
-	_notrun "4096-byte verity block size not supported on this platform"
-fi
 _disable_fsverity_signatures
 
 _scratch_mkfs_verity &>> $seqres.full
@@ -36,24 +33,42 @@ _scratch_mount
 fsv_orig_file=$SCRATCH_MNT/file
 fsv_file=$SCRATCH_MNT/file.fsv
 
+# Try multiple hash algorithms.
 algs=(sha256 sha512)
 
+# Try multiple Merkle tree block sizes.
+block_sizes=(1024 4096)
+
 # Try files with 0, 1, and multiple Merkle tree levels.
 file_sizes=(0 4096 65536 65536 100000000)
 
 # Try both unsalted and salted, and check that empty salt is the same as no salt
 salts=('' '' '' '--salt=' '--salt=f3c93fa6fb828c0e1587e5714ecf6f56')
 
-# The expected file measurements are here rather than in the expected output
-# file because not all hash algorithms may be available.
-sha256_vals=(
+# The expected file digests are here rather than in the expected output file
+# because the kernel might not support all hash algorithms and block sizes.
+sha256_vals_bsize1024=(
+sha256:f2cca36b9b1b7f07814e4284b10121809133e7cb9c4528c8f6846e85fc624ffa
+sha256:ea08590a4fe9c3d6c9dafe0eedacd9dffff8f24e24f1865ee3af132a495ab087
+sha256:527496288d703686e31092f5cca7e1306b2467f00b247ad01056ee5ec35a4bb9
+sha256:527496288d703686e31092f5cca7e1306b2467f00b247ad01056ee5ec35a4bb9
+sha256:087818b23312acb15dff9ff6e2b4f601406d08bb36013542444cc15248f47016
+)
+sha256_vals_bsize4096=(
 sha256:3d248ca542a24fc62d1c43b916eae5016878e2533c88238480b26128a1f1af95
 sha256:babc284ee4ffe7f449377fbf6692715b43aec7bc39c094a95878904d34bac97e
 sha256:011e3f2b1dc89b75d78cddcc2a1b85cd8a64b2883e5f20f277ae4c0617e0404f
 sha256:011e3f2b1dc89b75d78cddcc2a1b85cd8a64b2883e5f20f277ae4c0617e0404f
 sha256:9d33cab743468fcbe4edab91a275b30dd543c12dd5e6ce6f2f737f66a1558f06
 )
-sha512_vals=(
+sha512_vals_bsize1024=(
+sha512:8451664f25b2ad3f24391280e0c5681cb843389c180baa719f8fdfb063f5ddfa2d1c4433e55e2b6fbb3ba6aa2df8a4f41bf56cb7e0a3b617b6919a42c80f034c
+sha512:ab3c6444ab377bbe54c604c26cad241b146d85dc29727703a0d8134f70a8172fb3fa67d171355106b69cc0a9e7e9debb335f9461b3aba44093914867f7c73233
+sha512:e6a11353c24dd7b4603cb8ffa50a7041dbea7382d4698474ccbc2d8b34f3a83d8bf16df25c64ed31ee27213a8a3cbd001fb1ccde46384c23b81305c2393c1046
+sha512:e6a11353c24dd7b4603cb8ffa50a7041dbea7382d4698474ccbc2d8b34f3a83d8bf16df25c64ed31ee27213a8a3cbd001fb1ccde46384c23b81305c2393c1046
+sha512:517d573bd50d5f3787f5766c2ac60c7af854b0901b69757b4ef8dd70aa6b30fcc10d81629ce923bdd062a01c20fad0f063a081a2f3b0814ac06547b26bedc0d9
+)
+sha512_vals_bsize4096=(
 sha512:ccf9e5aea1c2a64efa2f2354a6024b90dffde6bbc017825045dce374474e13d10adb9dadcc6ca8e17a3c075fbd31336e8f266ae6fa93a6c3bed66f9e784e5abf
 sha512:928922686c4caf32175f5236a7f964e9925d10a74dc6d8344a8bd08b23c228ff5792573987d7895f628f39c4f4ebe39a7367d7aeb16aaa0cd324ac1d53664e61
 sha512:eab7224ce374a0a4babcb2db25e24836247f38b87806ad9be9e5ba4daac2f5b814fc0cbdfd9f1f8499b3c9a6c1b38fe08974cce49883ab4ccd04462fd2f9507f
@@ -61,23 +76,29 @@ sha512:eab7224ce374a0a4babcb2db25e24836247f38b87806ad9be9e5ba4daac2f5b814fc0cbdf
 sha512:f7083a38644880d25539488313e9e5b41a4d431a0e383945129ad2c36e3c1d0f28928a424641bb1363c12b6e770578102566acea73baf1ce8ee15336f5ba2446
 )
 
-test_alg()
+test_alg_with_block_size()
 {
 	local alg=$1
-	local -n vals=${alg}_vals
+	local block_size=$2
+	local -n vals=${alg}_vals_bsize${block_size}
 	local i
 	local file_size
 	local expected actual salt_arg
 
-	_fsv_scratch_begin_subtest "Check for expected measurement values ($alg)"
+	_fsv_scratch_begin_subtest "Testing alg=$alg, block_size=$block_size"
 
-	if ! _fsv_can_enable $fsv_file --hash-alg=$alg; then
-		if [ "$alg" = sha256 ]; then
-			_fail "Something is wrong - sha256 hash should always be available"
+	if ! _fsv_can_enable $fsv_file --hash-alg=$alg --block-size=$block_size
+	then
+		# Since this is after _require_scratch_verity, sha256 with
+		# FSV_BLOCK_SIZE must be supported.
+		if [ "$alg" = "sha256" -a "$block_size" = "$FSV_BLOCK_SIZE" ]
+		then
+			_fail "Failed to enable verity with default params"
 		fi
+		# This combination of parameters is unsupported; skip it.
+		echo "alg=$alg, block_size=$block_size is unsupported" >> $seqres.full
 		return 0
 	fi
-
 	for i in ${!file_sizes[@]}; do
 		file_size=${file_sizes[$i]}
 		expected=${vals[$i]}
@@ -85,7 +106,8 @@ test_alg()
 
 		head -c $file_size /dev/zero > $fsv_orig_file
 		cp $fsv_orig_file $fsv_file
-		_fsv_enable --hash-alg=$alg $salt_arg $fsv_file
+		_fsv_enable $fsv_file --hash-alg=$alg --block-size=$block_size \
+			$salt_arg
 		actual=$(_fsv_measure $fsv_file)
 		if [ "$actual" != "$expected" ]; then
 			echo "Mismatch: expected $expected, kernel calculated $actual (file_size=$file_size)"
@@ -96,7 +118,9 @@ test_alg()
 }
 
 for alg in ${algs[@]}; do
-	test_alg $alg
+	for block_size in ${block_sizes[@]}; do
+		test_alg_with_block_size $alg $block_size
+	done
 done
 
 # success, all done
diff --git a/tests/generic/575.out b/tests/generic/575.out
index 77bec43e..cb4115c9 100644
--- a/tests/generic/575.out
+++ b/tests/generic/575.out
@@ -1,5 +1,9 @@
 QA output created by 575
 
-# Check for expected measurement values (sha256)
+# Testing alg=sha256, block_size=1024
 
-# Check for expected measurement values (sha512)
+# Testing alg=sha256, block_size=4096
+
+# Testing alg=sha512, block_size=1024
+
+# Testing alg=sha512, block_size=4096
-- 
2.38.1

