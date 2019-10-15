Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F0C02D7EE1
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Oct 2019 20:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389037AbfJOSZ5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 15 Oct 2019 14:25:57 -0400
Received: from mail.kernel.org ([198.145.29.99]:44082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730002AbfJOSZ4 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 15 Oct 2019 14:25:56 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2C37A222C6;
        Tue, 15 Oct 2019 18:17:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1571163443;
        bh=ZPCr5yAug8CbLSs+7CjUY/YdR3nLwh5sWzDXxrkNqno=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=hRgAzMkE7IQVu4Sk7ibY+n82MvRm2L+odbY0k5O38x/T889JyQbJLL1ZBvVwCNDpR
         uXnUST/ReDmZma2hNA/JFVBSU0oQBogYU1/IrTP5GeSNrANghh1HpDhVmhzLKzFJSb
         j24IfIYr2M/Wdc0M7FQjjQagP9f4jZKXgvGzsKpg=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v3 3/9] common/encrypt: support checking for v2 encryption policy support
Date:   Tue, 15 Oct 2019 11:16:37 -0700
Message-Id: <20191015181643.6519-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.700.g56cf767bdb-goog
In-Reply-To: <20191015181643.6519-1-ebiggers@kernel.org>
References: <20191015181643.6519-1-ebiggers@kernel.org>
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
 common/encrypt | 42 +++++++++++++++++++++++++++++++++---------
 1 file changed, 33 insertions(+), 9 deletions(-)

diff --git a/common/encrypt b/common/encrypt
index a086e80f..eec585a0 100644
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
@@ -68,14 +69,19 @@ _require_encryption_policy_support()
 	local mnt=$1
 	local dir=$mnt/tmpdir
 	local set_encpolicy_args=""
+	local policy_version=1
 	local c
 
 	OPTIND=2
-	while getopts "c:n:" c; do
+	while getopts "c:n:v:" c; do
 		case $c in
 		c|n)
 			set_encpolicy_args+=" -$c $OPTARG"
 			;;
+		v)
+			set_encpolicy_args+=" -$c $OPTARG"
+			policy_version=$OPTARG
+			;;
 		*)
 			_fail "Unrecognized option '$c'"
 			;;
@@ -87,10 +93,26 @@ _require_encryption_policy_support()
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
+			_fail "Unexpected output from 'get_encpolicy -t': $output"
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
@@ -103,7 +125,9 @@ _require_encryption_policy_support()
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
2.23.0.700.g56cf767bdb-goog

