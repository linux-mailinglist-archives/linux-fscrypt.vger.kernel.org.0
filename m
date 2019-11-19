Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D77D102F5F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 Nov 2019 23:32:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727431AbfKSWch (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 Nov 2019 17:32:37 -0500
Received: from mail.kernel.org ([198.145.29.99]:42684 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726874AbfKSWch (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 Nov 2019 17:32:37 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BED322245B;
        Tue, 19 Nov 2019 22:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1574202755;
        bh=NcvtOdidX5kcQWTaIje71KC/ZZ636GyfcNysOyqAjI4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=BJtcEs1qgDTO51WS5ZUMO4UlsF9pZqd7G7/QIgciIxDQG/hygzPjhuq3rJVQ36IeQ
         zT4Pk1ITCZv5j2LvyGNbwLWSy+N88USbP8xzfJFAPE/7lMEOX4n1I8WQ7f82xDjWNr
         eWIhQI7en4RAoeoL+Upuf+vRiI369GfEpsFClVBY=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, keyrings@vger.kernel.org,
        Jarkko Sakkinen <jarkko.sakkinen@linux.intel.com>
Subject: [RFC PATCH 2/3] common/encrypt: move constant test key to common code
Date:   Tue, 19 Nov 2019 14:31:29 -0800
Message-Id: <20191119223130.228341-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.432.g9d3f5f5b63-goog
In-Reply-To: <20191119223130.228341-1-ebiggers@kernel.org>
References: <20191119223130.228341-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

For some encryption tests it's helpful to always use the same key so
that the test's output is always the same.

generic/580 already defines such a key, so move it into common/encrypt
so that other tests can use it too.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/encrypt    | 11 +++++++++++
 tests/generic/580 | 17 ++++-------------
 2 files changed, 15 insertions(+), 13 deletions(-)

diff --git a/common/encrypt b/common/encrypt
index 2e9908ad..98a407ce 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -187,6 +187,17 @@ _scratch_mkfs_stable_inodes_encrypted()
 	esac
 }
 
+# For some tests it's helpful to always use the same key so that the test's
+# output is always the same.  For this purpose the following key can be used:
+TEST_RAW_KEY=
+for i in {1..64}; do
+	TEST_RAW_KEY+="\\x$(printf "%02x" $i)"
+done
+# Key descriptor: arbitrary value
+TEST_KEY_DESCRIPTOR="0000111122223333"
+# Key identifier: HKDF-SHA512(key=$TEST_RAW_KEY, salt="", info="fscrypt\0\x01")
+TEST_KEY_IDENTIFIER="69b2f6edeee720cce0577937eb8a6751"
+
 # Give the invoking shell a new session keyring.  This makes any keys we add to
 # the session keyring scoped to the lifetime of the test script.
 _new_session_keyring()
diff --git a/tests/generic/580 b/tests/generic/580
index d0b0e9b3..283d6efa 100755
--- a/tests/generic/580
+++ b/tests/generic/580
@@ -43,21 +43,12 @@ _scratch_mount
 test_with_policy_version()
 {
 	local vers=$1
-	local raw_key=""
-	local i
-
-	for i in {1..64}; do
-		raw_key+="\\x$(printf "%02x" $i)"
-	done
 
 	if (( vers == 1 )); then
-		# Key descriptor: arbitrary value
-		local keyspec="0000111122223333"
+		local keyspec=$TEST_KEY_DESCRIPTOR
 		local add_enckey_args="-d $keyspec"
 	else
-		# Key identifier:
-		# HKDF-SHA512(key=raw_key, salt="", info="fscrypt\0\x01")
-		local keyspec="69b2f6edeee720cce0577937eb8a6751"
+		local keyspec=$TEST_KEY_IDENTIFIER
 		local add_enckey_args=""
 	fi
 
@@ -75,7 +66,7 @@ test_with_policy_version()
 	echo "# Getting encryption key status"
 	_enckey_status $SCRATCH_MNT $keyspec
 	echo "# Adding encryption key"
-	_add_enckey $SCRATCH_MNT "$raw_key" $add_enckey_args
+	_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY" $add_enckey_args
 	echo "# Creating encrypted file"
 	echo contents > $dir/file
 	echo "# Getting encryption key status"
@@ -90,7 +81,7 @@ test_with_policy_version()
 
 	# Test removing key with a file open.
 	echo "# Re-adding encryption key"
-	_add_enckey $SCRATCH_MNT "$raw_key" $add_enckey_args
+	_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY" $add_enckey_args
 	echo "# Creating another encrypted file"
 	echo foo > $dir/file2
 	echo "# Removing key while an encrypted file is open"
-- 
2.24.0.432.g9d3f5f5b63-goog

