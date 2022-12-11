Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC763649305
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Dec 2022 08:08:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230133AbiLKHIA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Dec 2022 02:08:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230138AbiLKHHy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Dec 2022 02:07:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F04BFB48C;
        Sat, 10 Dec 2022 23:07:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 38CBEB80945;
        Sun, 11 Dec 2022 07:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3445C433D2;
        Sun, 11 Dec 2022 07:07:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670742464;
        bh=RSlfrXXjhLYM9CdWMJaXYvN1wwoVOb0jnL6OewsqvWw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=P7v65V5VDfP6v1k3W80Yhb89hRy933STa450H0kl5kYytdoX82J+jACnDLBdHXXQn
         bF+SuI41phhoGcn0o/1wbolbYERSlX1Rz61b3z0ewOaQLxVkyxuRuoVLLY2wopLbSm
         FMDRNjKP4DvDDMjHlY1DoeLC992cxiZKup5rQ4of7CnXSNJmIDUSN2AfD8bw2nm1VV
         PSa80tk9NzuL7LPYy8D+S+ioftgTIhspCXHwiOENn80PpRN5tpYxK1jzSaHwtR17M8
         CwK/pt07d/yaDs7rqLYvBUqXwxzWVqINxusy8F4wDSxw+IqM5yAwq0pZgVzL+eCzT9
         SzVohrz3SvxfA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 01/10] common/verity: add and use _fsv_can_enable()
Date:   Sat, 10 Dec 2022 23:06:54 -0800
Message-Id: <20221211070704.341481-2-ebiggers@kernel.org>
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

Replace _fsv_have_hash_algorithm() with a more general function
_fsv_can_enable() which checks whether 'fsverity enable' with the given
parameters works.  For now it is just used with --hash-alg or with no
parameters, but soon it will be used with --block-size too.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/verity     | 17 ++++++-----------
 tests/generic/575 |  2 +-
 tests/generic/577 |  2 +-
 3 files changed, 8 insertions(+), 13 deletions(-)

diff --git a/common/verity b/common/verity
index f98dcb07..1a53a7ea 100644
--- a/common/verity
+++ b/common/verity
@@ -42,13 +42,7 @@ _require_scratch_verity()
 	# The filesystem may have fs-verity enabled but not actually usable by
 	# default.  E.g., ext4 only supports verity on extent-based files, so it
 	# doesn't work on ext3-style filesystems.  So, try actually using it.
-	echo foo > $SCRATCH_MNT/tmpfile
-	_disable_fsverity_signatures
-	_fsv_enable $SCRATCH_MNT/tmpfile
-	local status=$?
-	_restore_prev_fsverity_signatures
-	rm -f $SCRATCH_MNT/tmpfile
-	if (( $status != 0 )); then
+	if ! _fsv_can_enable $SCRATCH_MNT/tmpfile; then
 		_notrun "$FSTYP verity isn't usable by default with these mkfs options"
 	fi
 
@@ -256,15 +250,16 @@ _fsv_create_enable_file()
 	_fsv_enable "$file" "$@"
 }
 
-_fsv_have_hash_algorithm()
+_fsv_can_enable()
 {
-	local hash_alg=$1
-	local test_file=$2
+	local test_file=$1
+	shift
+	local params=("$@")
 
 	_disable_fsverity_signatures
 	rm -f $test_file
 	head -c 4096 /dev/zero > $test_file
-	_fsv_enable --hash-alg=$hash_alg $test_file &>> $seqres.full
+	_fsv_enable $test_file "${params[@]}" &>> $seqres.full
 	local status=$?
 	_restore_prev_fsverity_signatures
 	rm -f $test_file
diff --git a/tests/generic/575 b/tests/generic/575
index ffa6b61d..0ece8826 100755
--- a/tests/generic/575
+++ b/tests/generic/575
@@ -71,7 +71,7 @@ test_alg()
 
 	_fsv_scratch_begin_subtest "Check for expected measurement values ($alg)"
 
-	if ! _fsv_have_hash_algorithm $alg $fsv_file; then
+	if ! _fsv_can_enable $fsv_file --hash-alg=$alg; then
 		if [ "$alg" = sha256 ]; then
 			_fail "Something is wrong - sha256 hash should always be available"
 		fi
diff --git a/tests/generic/577 b/tests/generic/577
index 5f7e0573..85d680df 100755
--- a/tests/generic/577
+++ b/tests/generic/577
@@ -112,7 +112,7 @@ _fsv_enable $fsv_file --signature=$sigfile.salted --salt=abcd
 cmp $fsv_file $fsv_orig_file
 
 echo -e "\n# Testing non-default hash algorithm"
-if _fsv_have_hash_algorithm sha512 $fsv_file; then
+if _fsv_can_enable $fsv_file --hash-alg=sha512; then
 	reset_fsv_file
 	_fsv_sign $fsv_orig_file $sigfile.sha512 --key=$keyfile \
 		--cert=$certfile --hash-alg=sha512 > /dev/null
-- 
2.38.1

