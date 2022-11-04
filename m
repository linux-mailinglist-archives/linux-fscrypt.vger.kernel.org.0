Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1CC2C61A2D4
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Nov 2022 21:59:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229496AbiKDU7U (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Nov 2022 16:59:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbiKDU7S (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Nov 2022 16:59:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EECC243871;
        Fri,  4 Nov 2022 13:59:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8780FB82FBC;
        Fri,  4 Nov 2022 20:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14F9FC43470;
        Fri,  4 Nov 2022 20:59:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667595554;
        bh=kbJgc+So+lixQa5sA0cnuaYsYA5o80LPhq/HVcNCT4k=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=VYwmq07Ea5nd1lxhH/vkxYo74ZXDJ73UhAAnVA0DyjLvdLSRyglKF4VjagjfopvzC
         RhByKI5TBTpuNCIYfu/ma+UNSjbB//fRCpdAP4FeNfZ/c61NCaLQUk6mg9slYej423
         03rd3Yxiqmx/bAXUKLwVctzCdZ3YJ7ujarHtZfOeUN8OQsaIaJstR5AelLkxgN05c5
         70NJy0HjrKGvgiOCRk9cU23ZygPbW/jGMggq6MB1EhOtfuPQIsX7GeO4ZClLP9SVZX
         WjCkX47UpG0kdAHzx0mZMYmLyr5UQyYfWpergiBnUaPIy78QeMHCTkrN8hf5zhHYmc
         xpj6AAY2+wx4g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Andrey Albershteyn <aalbersh@redhat.com>
Subject: [xfstests PATCH v2 3/3] tests: fix some tests for systems with fs.verity.require_signatures=1
Date:   Fri,  4 Nov 2022 13:58:30 -0700
Message-Id: <20221104205830.130132-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221104205830.130132-1-ebiggers@kernel.org>
References: <20221104205830.130132-1-ebiggers@kernel.org>
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

Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
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

