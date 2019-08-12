Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A13098A51D
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 19:58:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726756AbfHLR6r (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 13:58:47 -0400
Received: from mail.kernel.org ([198.145.29.99]:53806 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726556AbfHLR6r (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 13:58:47 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4E02520842;
        Mon, 12 Aug 2019 17:58:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565632726;
        bh=ZI1naHEThQRUCYrf5Ok9Y+sKB4p5G72t1tU75yZB+ss=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=KC8il8uzGjwGU+2UyUlatpDq186/MUh3HwTMQiXEYWoO/sMMGsxf9JsaqPZ41vZjn
         7hLRRfRM7nn8OKPvxyDy0DGDMLgW5lw12Dl4Jf+haJyL1UPrIIwZBcwRT7IQuDpVru
         DqUm0ghW8scgvRl3WUOThO5+BVBDVPwY/NzWl3XY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [RFC PATCH 3/9] common/encrypt: support checking for v2 encryption policy support
Date:   Mon, 12 Aug 2019 10:58:03 -0700
Message-Id: <20190812175809.34810-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.rc1.153.gdeed80330f-goog
In-Reply-To: <20190812175809.34810-1-ebiggers@kernel.org>
References: <20190812175809.34810-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Allow passing '-v 2' to _require_scratch_encryption() to check for v2
encryption policy support on the scratch device, and for xfs_io support
for setting and getting v2 encryption policies.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/encrypt | 41 +++++++++++++++++++++++++++++++----------
 1 file changed, 31 insertions(+), 10 deletions(-)

diff --git a/common/encrypt b/common/encrypt
index a086e80f..fa6e2672 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -6,12 +6,13 @@
 
 #
 # _require_scratch_encryption [-c CONTENTS_MODE] [-n FILENAMES_MODE]
+#			      [-v POLICY_VERSION]
 #
 # Require encryption support on the scratch device.
 #
-# This checks for support for the default type of encryption policy (AES-256-XTS
-# and AES-256-CTS).  Options can be specified to also require support for a
-# different type of encryption policy.
+# This checks for support for the default type of encryption policy (v1 with
+# AES-256-XTS and AES-256-CTS).  Options can be specified to also require
+# support for a different type of encryption policy.
 #
 _require_scratch_encryption()
 {
@@ -68,13 +69,15 @@ _require_encryption_policy_support()
 	local mnt=$1
 	local dir=$mnt/tmpdir
 	local set_encpolicy_args=""
+	local policy_version=1
 	local c
 
 	OPTIND=2
-	while getopts "c:n:" c; do
+	while getopts "c:n:v:" c; do
 		case $c in
-		c|n)
+		c|n|v)
 			set_encpolicy_args+=" -$c $OPTARG"
+			[ $c = v ] && policy_version=$OPTARG
 			;;
 		*)
 			_fail "Unrecognized option '$c'"
@@ -87,10 +90,26 @@ _require_encryption_policy_support()
 		>> $seqres.full
 
 	mkdir $dir
-	_require_command "$KEYCTL_PROG" keyctl
-	_new_session_keyring
-	local keydesc=$(_generate_session_encryption_key)
-	if _set_encpolicy $dir $keydesc $set_encpolicy_args \
+	if (( policy_version > 1 )); then
+		_require_xfs_io_command "get_encpolicy" "-t"
+		local output=$(_get_encpolicy $dir -t)
+		if [ "$output" != "supported" ]; then
+			if [ "$output" = "unsupported" ]; then
+				_notrun "kernel does not support $FSTYP encryption v2 API"
+			fi
+			_fail "Unexpected output from 'get_encpolicy -t'"
+		fi
+		# Both the kernel and xfs_io support v2 encryption policies, and
+		# therefore also filesystem-level keys -- since that's the only
+		# way to provide keys for v2 policies.
+		local raw_key=$(_generate_raw_encryption_key)
+		local keyspec=$(_add_enckey $mnt "$raw_key" | awk '{print $NF}')
+	else
+		_require_command "$KEYCTL_PROG" keyctl
+		_new_session_keyring
+		local keyspec=$(_generate_session_encryption_key)
+	fi
+	if _set_encpolicy $dir $keyspec $set_encpolicy_args \
 		2>&1 >>$seqres.full | egrep -q 'Invalid argument'; then
 		_notrun "kernel does not support encryption policy: '$set_encpolicy_args'"
 	fi
@@ -103,7 +122,9 @@ _require_encryption_policy_support()
 	if ! echo foo > $dir/file; then
 		_notrun "encryption policy '$set_encpolicy_args' is unusable; probably missing kernel crypto API support"
 	fi
-	$KEYCTL_PROG clear @s
+	if (( policy_version <= 1 )); then
+		$KEYCTL_PROG clear @s
+	fi
 	rm -r $dir
 }
 
-- 
2.23.0.rc1.153.gdeed80330f-goog

