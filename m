Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 92ACD61915F
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Nov 2022 07:48:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231714AbiKDGsm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Nov 2022 02:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231620AbiKDGr6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Nov 2022 02:47:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72E552AC7A;
        Thu,  3 Nov 2022 23:47:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0DC8E620D0;
        Fri,  4 Nov 2022 06:47:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 529DCC43144;
        Fri,  4 Nov 2022 06:47:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667544476;
        bh=BW8pVW5BVjfri4dyrTipKKy3ENTLbXJCjfFUziVKoPQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KOKxjCHfUBTHC9fh8Qa1nx13Ias+7z1bv9fl4lPbqoRwASpiBrvMd18Y1c0eZf0Mo
         6JO43WWBXVY9oh18y56ctkMOZzuffv8N8iBlZAeNNSqErTY2HKQgbEgz3s8I2ZnuAj
         NGQvD2PCi5voCn8FAWYAxmW5elQXq/LD4KS/MdpMRTcbEm8q9Rl+ts+5KVBetPEM2r
         /FmwV3HnGN5LfZ8Ty2CAPzvl18ChgOa/TzhL0UP54wHY/3+uoYBYgOAmuLB5IHrWTL
         OHU5KQPrV8DbzvoYwZIJfLKawTSh+pI57n4VtXZ0CmskUg/kPNw29YVM4OtUYN//k1
         IvDdRo0TvLmCw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     Andrey Albershteyn <aalbersh@redhat.com>,
        linux-fscrypt@vger.kernel.org
Subject: [xfstests PATCH 3/3] tests: fix some tests for systems with fs.verity.require_signatures=1
Date:   Thu,  3 Nov 2022 23:47:42 -0700
Message-Id: <20221104064742.167326-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221104064742.167326-1-ebiggers@kernel.org>
References: <20221104064742.167326-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Some of the newer verity tests don't work properly on systems where
fs.verity.require_signatures is enabled, either because they forget to
disable it at the beginning of the test, or they forget to re-enable it
afterwards, or both.  Fix this.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/btrfs/290   | 9 +++++++++
 tests/btrfs/291   | 2 ++
 tests/generic/624 | 8 ++++++++
 tests/generic/692 | 8 ++++++++
 4 files changed, 27 insertions(+)

diff --git a/tests/btrfs/290 b/tests/btrfs/290
index b7254c5e..06a58f47 100755
--- a/tests/btrfs/290
+++ b/tests/btrfs/290
@@ -15,6 +15,14 @@ _begin_fstest auto quick verity
 . ./common/filter
 . ./common/verity
 
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	_restore_fsverity_signatures
+	rm -f $tmp.*
+}
+
 # real QA test starts here
 _supported_fs btrfs
 _require_scratch_verity
@@ -24,6 +32,7 @@ _require_xfs_io_command "falloc"
 _require_xfs_io_command "pread"
 _require_xfs_io_command "pwrite"
 _require_btrfs_corrupt_block
+_disable_fsverity_signatures
 
 get_ino() {
 	local file=$1
diff --git a/tests/btrfs/291 b/tests/btrfs/291
index bbdd183d..c5947133 100755
--- a/tests/btrfs/291
+++ b/tests/btrfs/291
@@ -23,6 +23,7 @@ _cleanup()
 	rm -f $img
 	$LVM_PROG vgremove -f -y $vgname >>$seqres.full 2>&1
 	losetup -d $loop_dev >>$seqres.full 2>&1
+	_restore_fsverity_signatures
 }
 
 # Import common functions.
@@ -43,6 +44,7 @@ _require_command $LVM_PROG lvm
 _require_scratch_verity
 _require_btrfs_command inspect-internal dump-tree
 _require_test_program "log-writes/replay-log"
+_disable_fsverity_signatures
 
 sync_loop() {
 	i=$1
diff --git a/tests/generic/624 b/tests/generic/624
index 89fbf256..7c447289 100755
--- a/tests/generic/624
+++ b/tests/generic/624
@@ -10,6 +10,14 @@
 . ./common/preamble
 _begin_fstest auto quick verity
 
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	_restore_fsverity_signatures
+	rm -f $tmp.*
+}
+
 . ./common/filter
 . ./common/verity
 
diff --git a/tests/generic/692 b/tests/generic/692
index 0bb1fd33..d6da734b 100644
--- a/tests/generic/692
+++ b/tests/generic/692
@@ -15,6 +15,13 @@
 . ./common/preamble
 _begin_fstest auto quick verity
 
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	_restore_fsverity_signatures
+	rm -f $tmp.*
+}
 
 # Import common functions.
 . ./common/filter
@@ -26,6 +33,7 @@ _require_test
 _require_math
 _require_scratch_verity
 _require_fsverity_max_file_size_limit
+_disable_fsverity_signatures
 
 _scratch_mkfs_verity &>> $seqres.full
 _scratch_mount
-- 
2.38.1

