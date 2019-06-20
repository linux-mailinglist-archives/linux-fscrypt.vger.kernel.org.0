Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1C4C34DCBA
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Jun 2019 23:38:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726059AbfFTVim (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Jun 2019 17:38:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:47234 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726554AbfFTVil (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Jun 2019 17:38:41 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E485521530;
        Thu, 20 Jun 2019 21:38:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1561066720;
        bh=tD13SQPiq6U//Di45+l/aLXBU1zkuW4qczDAR3KDkUg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=OHRKAUozrSLQsYLc+Vn9OWH/pKZWtrUwNpbkGoIc6ngnZUxSmkx0Cv0OzmA4eYuPL
         zc6dpyYI7P1ohPcYsAgLTsfxsQ42hQdtrcuAJbw7txyT+3r4HlfINrFI3CioLYXPtC
         bhnYKW4PJKS/lur1AfMSSKKpCkvvwLtfFcL6u8Fs=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [RFC PATCH v2 8/8] generic: test the fs-verity built-in signature verification support
Date:   Thu, 20 Jun 2019 14:36:14 -0700
Message-Id: <20190620213614.113685-9-ebiggers@kernel.org>
X-Mailer: git-send-email 2.22.0.410.gd8fdbe21b5-goog
In-Reply-To: <20190620213614.113685-1-ebiggers@kernel.org>
References: <20190620213614.113685-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a basic test for the fs-verity built-in signature verification
support, which is an optional feature where the kernel can be configured
to enforce that all verity files are accompanied with a valid signature
by a key that has been loaded into the fs-verity keyring.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/config         |   1 +
 common/verity         |  11 ++++
 tests/generic/905     | 141 ++++++++++++++++++++++++++++++++++++++++++
 tests/generic/905.out |  34 ++++++++++
 tests/generic/group   |   1 +
 5 files changed, 188 insertions(+)
 create mode 100755 tests/generic/905
 create mode 100644 tests/generic/905.out

diff --git a/common/config b/common/config
index 001ddc45..1aaf0a75 100644
--- a/common/config
+++ b/common/config
@@ -213,6 +213,7 @@ export XFS_INFO_PROG="$(type -P xfs_info)"
 export DUPEREMOVE_PROG="$(type -P duperemove)"
 export CC_PROG="$(type -P cc)"
 export FSVERITY_PROG="$(type -P fsverity)"
+export OPENSSL_PROG="$(type -P openssl)"
 
 # use 'udevadm settle' or 'udevsettle' to wait for lv to be settled.
 # newer systems have udevadm command but older systems like RHEL5 don't.
diff --git a/common/verity b/common/verity
index 86fb6585..edd7e523 100644
--- a/common/verity
+++ b/common/verity
@@ -35,6 +35,17 @@ _require_scratch_verity()
 	FSV_BLOCK_SIZE=$(get_page_size)
 }
 
+# Check for CONFIG_FS_VERITY_BUILTIN_SIGNATURES=y.
+_require_fsverity_builtin_signatures()
+{
+	if [ ! -e /proc/keys ]; then
+		_notrun "kernel doesn't support keyrings"
+	fi
+	if ! awk '{print $9}' /proc/keys | grep -q '^\.fs-verity:$'; then
+		_notrun "kernel doesn't support fs-verity builtin signatures"
+	fi
+}
+
 _scratch_mkfs_verity()
 {
 	case $FSTYP in
diff --git a/tests/generic/905 b/tests/generic/905
new file mode 100755
index 00000000..db83d221
--- /dev/null
+++ b/tests/generic/905
@@ -0,0 +1,141 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright 2019 Google LLC
+#
+# FS QA Test generic/905
+#
+# Test the fs-verity built-in signature verification support.
+#
+seq=`basename $0`
+seqres=$RESULT_DIR/$seq
+echo "QA output created by $seq"
+
+here=`pwd`
+tmp=/tmp/$$
+status=1	# failure is the default!
+trap "_cleanup; exit \$status" 0 1 2 3 15
+
+_cleanup()
+{
+	sysctl -w fs.verity.require_signatures=0 &>/dev/null
+	cd /
+	rm -f $tmp.*
+}
+
+# get standard environment, filters and checks
+. ./common/rc
+. ./common/filter
+. ./common/verity
+
+# remove previous $seqres.full before test
+rm -f $seqres.full
+
+# real QA test starts here
+_supported_fs generic
+_supported_os Linux
+_require_scratch_verity
+_require_fsverity_builtin_signatures
+_require_command "$OPENSSL_PROG" openssl
+_require_command "$KEYCTL_PROG" keyctl
+
+_scratch_mkfs_verity &>> $seqres.full
+_scratch_mount
+
+fsv_file=$SCRATCH_MNT/file.fsv
+fsv_orig_file=$SCRATCH_MNT/file
+keyfile=$tmp.key.pem
+certfile=$tmp.cert.pem
+certfileder=$tmp.cert.der
+sigfile=$tmp.sig
+othersigfile=$tmp.othersig
+tmpfile=$tmp.tmp
+
+# Setup
+
+echo -e "\n# Generating certificates and private keys"
+for suffix in '' '.2'; do
+	if ! $OPENSSL_PROG req -newkey rsa:4096 -nodes -batch -x509 \
+			-keyout $keyfile$suffix -out $certfile$suffix \
+			&>> $seqres.full; then
+		_fail "Failed to generate certificate and private key (see $seqres.full)"
+	fi
+	$OPENSSL_PROG x509 -in $certfile$suffix -out $certfileder$suffix \
+		-outform der
+done
+
+echo -e "\n# Clearing fs-verity keyring"
+$KEYCTL_PROG clear %keyring:.fs-verity
+
+echo -e "\n# Loading first certificate into fs-verity keyring"
+$KEYCTL_PROG padd asymmetric '' %keyring:.fs-verity \
+	< $certfileder >> $seqres.full
+
+echo -e "\n# Enabling fs.verity.require_signatures"
+sysctl -w fs.verity.require_signatures=1
+
+echo -e "\n# Generating file and signing it for fs-verity"
+head -c 100000 /dev/urandom > $fsv_orig_file
+for suffix in '' '.2'; do
+	$FSVERITY_PROG sign $fsv_orig_file $sigfile$suffix \
+		--key=$keyfile$suffix --cert=$certfile$suffix
+done
+
+echo -e "\n# Signing a different file for fs-verity"
+head -c 100000 /dev/zero > $tmpfile
+$FSVERITY_PROG sign $tmpfile $othersigfile --key=$keyfile --cert=$certfile
+
+# Actual tests
+
+reset_fsv_file()
+{
+	rm -f $fsv_file
+	cp $fsv_orig_file $fsv_file
+}
+
+echo -e "\n# Enabling verity with valid signature (should succeed)"
+reset_fsv_file
+_fsv_enable $fsv_file --signature=$sigfile
+cmp $fsv_file $fsv_orig_file
+
+echo -e "\n# Enabling verity without signature (should fail)"
+reset_fsv_file
+_fsv_enable $fsv_file |& _filter_scratch
+
+echo -e "\n# Opening verity file without signature (should fail)"
+reset_fsv_file
+sysctl -w fs.verity.require_signatures=0 &>> $seqres.full
+_fsv_enable $fsv_file
+sysctl -w fs.verity.require_signatures=1 &>> $seqres.full
+_scratch_cycle_mount
+md5sum $fsv_file |& _filter_scratch
+
+echo -e "\n# Enabling verity with wrong file's signature (should fail)"
+reset_fsv_file
+_fsv_enable $fsv_file --signature=$othersigfile |& _filter_scratch
+
+echo -e "\n# Enabling verity with untrusted signature (should fail)"
+reset_fsv_file
+_fsv_enable $fsv_file --signature=$sigfile.2 |& _filter_scratch
+
+echo -e "\n# Testing salt"
+reset_fsv_file
+$FSVERITY_PROG sign $fsv_orig_file $sigfile.salted \
+	--key=$keyfile --cert=$certfile --salt=abcd
+_fsv_enable $fsv_file --signature=$sigfile.salted --salt=abcd
+
+echo -e "\n# Testing non-default hash algorithm"
+if _fsv_have_hash_algorithm sha512 $fsv_file; then
+	reset_fsv_file
+	$FSVERITY_PROG sign $fsv_orig_file $sigfile.sha512 \
+		--key=$keyfile --cert=$certfile --hash-alg=sha512
+	_fsv_enable $fsv_file --signature=$sigfile.sha512 --hash-alg=sha512
+fi
+
+echo -e "\n# Testing empty file"
+echo -n > $fsv_file
+$FSVERITY_PROG sign $fsv_file $sigfile.emptyfile --key=$keyfile --cert=$certfile
+_fsv_enable $fsv_file --signature=$sigfile.emptyfile
+
+# success, all done
+status=0
+exit
diff --git a/tests/generic/905.out b/tests/generic/905.out
new file mode 100644
index 00000000..76707b5c
--- /dev/null
+++ b/tests/generic/905.out
@@ -0,0 +1,34 @@
+QA output created by 905
+
+# Generating certificates and private keys
+
+# Clearing fs-verity keyring
+
+# Loading first certificate into fs-verity keyring
+
+# Enabling fs.verity.require_signatures
+fs.verity.require_signatures = 1
+
+# Generating file and signing it for fs-verity
+
+# Signing a different file for fs-verity
+
+# Enabling verity with valid signature (should succeed)
+
+# Enabling verity without signature (should fail)
+ERROR: FS_IOC_ENABLE_VERITY failed on 'SCRATCH_MNT/file.fsv': Bad message
+
+# Opening verity file without signature (should fail)
+md5sum: SCRATCH_MNT/file.fsv: Bad message
+
+# Enabling verity with wrong file's signature (should fail)
+ERROR: FS_IOC_ENABLE_VERITY failed on 'SCRATCH_MNT/file.fsv': Bad message
+
+# Enabling verity with untrusted signature (should fail)
+ERROR: FS_IOC_ENABLE_VERITY failed on 'SCRATCH_MNT/file.fsv': Required key not available
+
+# Testing salt
+
+# Testing non-default hash algorithm
+
+# Testing empty file
diff --git a/tests/generic/group b/tests/generic/group
index 5b4c32ff..bfbb4957 100644
--- a/tests/generic/group
+++ b/tests/generic/group
@@ -564,3 +564,4 @@
 902 auto quick verity
 903 auto quick verity
 904 auto quick verity encrypt
+905 auto quick verity
-- 
2.22.0.410.gd8fdbe21b5-goog

