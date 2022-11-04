Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D9D261A2D2
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Nov 2022 21:59:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229567AbiKDU7T (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Nov 2022 16:59:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229495AbiKDU7S (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Nov 2022 16:59:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5741CCE16;
        Fri,  4 Nov 2022 13:59:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 05EF9B82FBA;
        Fri,  4 Nov 2022 20:59:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F0C2C433D6;
        Fri,  4 Nov 2022 20:59:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667595553;
        bh=ST3IYM4B6dddb9c3HsGD3Pz8XYBRhWCrkIuJ9yRrTEE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GCn9s649zHyODFpekuaqYPn/FkHOAT/2Sm1eas8E3gy2WE/5jvPCk3X8O2gh8flSJ
         R43zhvaXij74WFt6hEvzKo3uWB7V4oBGotqMtr3qL2QbxWz/hORqWGLPszPah7sEKG
         IDdcxTXSOIXt+nB7iW32MDq6vSD9KeciNbqknra7Yz0eN5XtJzx4qMx5UiNdC9Qnmk
         0b6gSl9pPfa7UtBWOL5U1RJDRHkD8RrVQ7e744wdvDVOCxeXPjVXOq6tU5AznTnpvy
         wC1Os3ZTQIw6cis/QLDZRUax9X0uSbxpBaNASyAvi9csgrp5S862l/e39y3dvmoUrD
         dDH0AcPIfE2Fw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Andrey Albershteyn <aalbersh@redhat.com>
Subject: [xfstests PATCH v2 1/3] common/verity: fix _fsv_have_hash_algorithm() with required signatures
Date:   Fri,  4 Nov 2022 13:58:28 -0700
Message-Id: <20221104205830.130132-2-ebiggers@kernel.org>
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

_fsv_have_hash_algorithm() uses _fsv_enable() without a signature, so it
always fails when called while fs.verity.require_signatures=1.  This
happens in generic/577, which tests file signing.  This wasn't noticed
because it just made part of generic/577 always be skipped.

Fix this by making _fsv_have_hash_algorithm() temporarily set
fs.verity.require_signatures to 0.

Since the previous value needs to be restored afterwards, whether it is
0 or 1, also make some changes to the fs.verity.require_signatures
helper functions to allow the restoration of the previous value, rather
than the value that existed at the beginning of the test.

Finally, make a couple related cleanups: make _fsv_have_hash_algorithm()
always delete the file it works with, and also update the similar code
in _require_scratch_verity().

Reported-by: Andrey Albershteyn <aalbersh@redhat.com>
Reviewed-by: Andrey Albershteyn <aalbersh@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/verity | 58 ++++++++++++++++++++++++++++++++-------------------
 1 file changed, 37 insertions(+), 21 deletions(-)

diff --git a/common/verity b/common/verity
index 65a39d3e..f98dcb07 100644
--- a/common/verity
+++ b/common/verity
@@ -44,12 +44,13 @@ _require_scratch_verity()
 	# doesn't work on ext3-style filesystems.  So, try actually using it.
 	echo foo > $SCRATCH_MNT/tmpfile
 	_disable_fsverity_signatures
-	if ! _fsv_enable $SCRATCH_MNT/tmpfile; then
-		_restore_fsverity_signatures
+	_fsv_enable $SCRATCH_MNT/tmpfile
+	local status=$?
+	_restore_prev_fsverity_signatures
+	rm -f $SCRATCH_MNT/tmpfile
+	if (( $status != 0 )); then
 		_notrun "$FSTYP verity isn't usable by default with these mkfs options"
 	fi
-	_restore_fsverity_signatures
-	rm -f $SCRATCH_MNT/tmpfile
 
 	_scratch_unmount
 
@@ -105,10 +106,7 @@ _fsv_load_cert()
 _disable_fsverity_signatures()
 {
 	if [ -e /proc/sys/fs/verity/require_signatures ]; then
-		if [ -z "$FSVERITY_SIG_CTL_ORIG" ]; then
-			FSVERITY_SIG_CTL_ORIG=$(</proc/sys/fs/verity/require_signatures)
-		fi
-		echo 0 > /proc/sys/fs/verity/require_signatures
+		_set_fsverity_require_signatures 0
 	fi
 }
 
@@ -116,18 +114,36 @@ _disable_fsverity_signatures()
 # This assumes that _require_fsverity_builtin_signatures() was called.
 _enable_fsverity_signatures()
 {
-	if [ -z "$FSVERITY_SIG_CTL_ORIG" ]; then
-		FSVERITY_SIG_CTL_ORIG=$(</proc/sys/fs/verity/require_signatures)
-	fi
-	echo 1 > /proc/sys/fs/verity/require_signatures
+	_set_fsverity_require_signatures 1
 }
 
-# Restore the original signature verification setting.
+# Restore the original value of fs.verity.require_signatures, i.e. the value it
+# had at the beginning of the test.
 _restore_fsverity_signatures()
 {
-        if [ -n "$FSVERITY_SIG_CTL_ORIG" ]; then
-                echo "$FSVERITY_SIG_CTL_ORIG" > /proc/sys/fs/verity/require_signatures
-        fi
+	if [ -n "$FSVERITY_SIG_CTL_ORIG" ]; then
+		_set_fsverity_require_signatures "$FSVERITY_SIG_CTL_ORIG"
+	fi
+}
+
+# Restore the previous value of fs.verity.require_signatures, i.e. the value it
+# had just before it was last written to.
+_restore_prev_fsverity_signatures()
+{
+	if [ -n "$FSVERITY_SIG_CTL_PREV" ]; then
+		_set_fsverity_require_signatures "$FSVERITY_SIG_CTL_PREV"
+	fi
+}
+
+_set_fsverity_require_signatures()
+{
+	local newval=$1
+	local oldval=$(</proc/sys/fs/verity/require_signatures)
+	FSVERITY_SIG_CTL_PREV=$oldval
+	if [ -z "$FSVERITY_SIG_CTL_ORIG" ]; then
+		FSVERITY_SIG_CTL_ORIG=$oldval
+	fi
+	echo "$newval" > /proc/sys/fs/verity/require_signatures
 }
 
 # Require userspace and kernel support for 'fsverity dump_metadata'.
@@ -245,14 +261,14 @@ _fsv_have_hash_algorithm()
 	local hash_alg=$1
 	local test_file=$2
 
+	_disable_fsverity_signatures
 	rm -f $test_file
 	head -c 4096 /dev/zero > $test_file
-	if ! _fsv_enable --hash-alg=$hash_alg $test_file &>> $seqres.full; then
-		# no kernel support
-		return 1
-	fi
+	_fsv_enable --hash-alg=$hash_alg $test_file &>> $seqres.full
+	local status=$?
+	_restore_prev_fsverity_signatures
 	rm -f $test_file
-	return 0
+	return $status
 }
 
 #
-- 
2.38.1

