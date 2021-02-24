Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F1FC3246F6
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Feb 2021 23:37:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235427AbhBXWhf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Feb 2021 17:37:35 -0500
Received: from mail.kernel.org ([198.145.29.99]:58050 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235406AbhBXWhc (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Feb 2021 17:37:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id CEE3464F07;
        Wed, 24 Feb 2021 22:36:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614206212;
        bh=L4z2C4DuIZfWTqYBVHamH20RgGZzTjtaVEyRT8RWgJY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=nwhemgLilp9QTp49yc7hlm6E3e9WaVzxl/RZxST+W1Mz1DDWXWD9XR9AECvbPNEjr
         aPnjQ+BsW4b/66VYgth3UQH6zrOL4XaqSJg6ujHUiovjq5MzP3ixbhGY6tsLqmH8bV
         Ix78UK/wNiZKGOMZCCqso09ddZaNTFjG0wcCXQumLqAFY6EO2ttS8jZpeZg6V7n1uU
         KxhrcFf9Wsn8Z1NVm5JObYqhdpDD9u6+2l2UcBmeIQAb//zoOu96gryHk98pCWHrOq
         l5OBGpxnTGnRLmw7KMSniVz7ZeTygCpmCXX3AbQBZCtNrdJyBAczIwyWyhjwYcqo0n
         g40+YnBt90uYw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [PATCH v2 1/4] generic: factor out helpers for fs-verity built-in signatures
Date:   Wed, 24 Feb 2021 14:35:34 -0800
Message-Id: <20210224223537.110491-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210224223537.110491-1-ebiggers@kernel.org>
References: <20210224223537.110491-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The test for retrieving a verity file's built-in signature using
FS_IOC_READ_VERITY_METADATA will need to set up a file with a built-in
signature, which requires the same commands that generic/577 does.
Factor this out into helper functions in common/verity.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/verity     | 37 ++++++++++++++++++++++++++++++++++++-
 tests/generic/577 | 15 +++------------
 2 files changed, 39 insertions(+), 13 deletions(-)

diff --git a/common/verity b/common/verity
index a8d3de06..9a182240 100644
--- a/common/verity
+++ b/common/verity
@@ -48,12 +48,47 @@ _require_scratch_verity()
 	FSV_BLOCK_SIZE=$(get_page_size)
 }
 
-# Check for CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y.
+# Check for CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y, as well as the userspace
+# commands needed to generate certificates and add them to the kernel.
 _require_fsverity_builtin_signatures()
 {
 	if [ ! -e /proc/sys/fs/verity/require_signatures ]; then
 		_notrun "kernel doesn't support fs-verity builtin signatures"
 	fi
+	_require_command "$OPENSSL_PROG" openssl
+	_require_command "$KEYCTL_PROG" keyctl
+}
+
+# Use the openssl program to generate a private key and a X.509 certificate for
+# use with fs-verity built-in signature verification, and convert the
+# certificate to DER format.
+_fsv_generate_cert()
+{
+	local keyfile=$1
+	local certfile=$2
+	local certfileder=$3
+
+	if ! $OPENSSL_PROG req -newkey rsa:4096 -nodes -batch -x509 \
+			-keyout $keyfile -out $certfile &>> $seqres.full; then
+		_fail "Failed to generate certificate and private key (see $seqres.full)"
+	fi
+	$OPENSSL_PROG x509 -in $certfile -out $certfileder -outform der
+}
+
+# Clear the .fs-verity keyring.
+_fsv_clear_keyring()
+{
+	$KEYCTL_PROG clear %keyring:.fs-verity
+}
+
+# Load the given X.509 certificate in DER format into the .fs-verity keyring so
+# that the kernel can use it to verify built-in signatures.
+_fsv_load_cert()
+{
+	local certfileder=$1
+
+	$KEYCTL_PROG padd asymmetric '' %keyring:.fs-verity \
+		< $certfileder >> $seqres.full
 }
 
 # Disable mandatory signatures for fs-verity files, if they are supported.
diff --git a/tests/generic/577 b/tests/generic/577
index 0e945942..114463be 100755
--- a/tests/generic/577
+++ b/tests/generic/577
@@ -34,8 +34,6 @@ rm -f $seqres.full
 _supported_fs generic
 _require_scratch_verity
 _require_fsverity_builtin_signatures
-_require_command "$OPENSSL_PROG" openssl
-_require_command "$KEYCTL_PROG" keyctl
 
 _scratch_mkfs_verity &>> $seqres.full
 _scratch_mount
@@ -53,21 +51,14 @@ othersigfile=$tmp.othersig
 
 echo -e "\n# Generating certificates and private keys"
 for suffix in '' '.2'; do
-	if ! $OPENSSL_PROG req -newkey rsa:4096 -nodes -batch -x509 \
-			-keyout $keyfile$suffix -out $certfile$suffix \
-			&>> $seqres.full; then
-		_fail "Failed to generate certificate and private key (see $seqres.full)"
-	fi
-	$OPENSSL_PROG x509 -in $certfile$suffix -out $certfileder$suffix \
-		-outform der
+	_fsv_generate_cert $keyfile$suffix $certfile$suffix $certfileder$suffix
 done
 
 echo -e "\n# Clearing fs-verity keyring"
-$KEYCTL_PROG clear %keyring:.fs-verity
+_fsv_clear_keyring
 
 echo -e "\n# Loading first certificate into fs-verity keyring"
-$KEYCTL_PROG padd asymmetric '' %keyring:.fs-verity \
-	< $certfileder >> $seqres.full
+_fsv_load_cert $certfileder
 
 echo -e "\n# Enabling fs.verity.require_signatures"
 _enable_fsverity_signatures
-- 
2.30.1

