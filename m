Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B59787C4118
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:26:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229598AbjJJU0X (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:26:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36390 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230510AbjJJU0W (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:26:22 -0400
Received: from mail-yb1-xb2f.google.com (mail-yb1-xb2f.google.com [IPv6:2607:f8b0:4864:20::b2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6159CCA
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:26:20 -0700 (PDT)
Received: by mail-yb1-xb2f.google.com with SMTP id 3f1490d57ef6-d8a000f6a51so6641288276.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:26:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696969579; x=1697574379; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Hwy8Zi2uzZrYdFBsR35VWjRso0l8oMrGMg/hmDe3qJM=;
        b=Yl0pGiFBg6X/6EpYGRdhV9NPnuFkdKffP4AQG+REbjvJdJ97qLeTFoHibxIo6b/G3K
         AcnnUxQwf+OweE/xI1l7XiAFkI7hngfozZyARh0Ei/IiCJxHzIoK7dfUSLM50k7gnpap
         KLGefxb+/XkUNrNbuqENo2Y8K0JP9DLAe/mFksIHRSPv2g8YFBNgphzVTeeNiiCaqaTm
         x/+xX8IzzO5D6oEZGR6WtdAT99gV7RhxueHU2EcX2kmUweeegVRRBq+zrTs8qZhGZhYF
         yegap7TCqgZRK3EfkwdSgePurl67ZVE+3Bqx3WHin/ccFy0yy8tmt1pfNt2eeRTC2PL+
         UaTw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696969579; x=1697574379;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Hwy8Zi2uzZrYdFBsR35VWjRso0l8oMrGMg/hmDe3qJM=;
        b=Gn8dw09RnorulLendgM4dxKIEP/HpsRadf8YC6bPWSb4GlqslE1V2xH00ciPEpxgrK
         zS6r0VzFhNceLPxdoe2aNn9UQ6sfvgAkj6UULj8hvk0Q33l7nEqaPvi+7Hh9k8HQ5BZA
         lYrEgR4otWNk1evfkYF6p/431o+5+U94FF1F7sooU5fYaQ77Vx8NeBoTsH4NwJxDTuB1
         GjFR2NFlA6+WPalCinyhB1F1QWsZf9VX5g5TKWxRVJnoDKAgq1yhM5CZet+wc6QWclDY
         AjxVaaoonCIFee2E0t1iczX6PU8aCDOtMAzRiyUE/XVqWmBtUuafuATFP9jgawBOMkMS
         LoqA==
X-Gm-Message-State: AOJu0YzMNWDZjOs56BDcvVth+PLE+0fc5b52eNc4Gl5yWJd/tDm1Wkef
        rdRM42PbcvEtfm7yhpWQdS3V1Xain4I12Ut74xmZ/g==
X-Google-Smtp-Source: AGHT+IGazxV6INO6CLta8CjXhAk2I8g2uwMKRNIInMbviKy22fPV7nEsEgC0OCc6sZ0Sr9E6Z7ZHBQ==
X-Received: by 2002:a25:6810:0:b0:d78:878d:e1e1 with SMTP id d16-20020a256810000000b00d78878de1e1mr17959900ybc.50.1696969579546;
        Tue, 10 Oct 2023 13:26:19 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id 6-20020a251806000000b00d800eb5ac2asm3972167yby.65.2023.10.10.13.26.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:26:19 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 01/12] common/encrypt: separate data and inode nonces
Date:   Tue, 10 Oct 2023 16:25:54 -0400
Message-ID: <d5a7bbf5027095a1177c0da42c26aa72aba84064.1696969376.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696969376.git.josef@toxicpanda.com>
References: <cover.1696969376.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

btrfs will have different inode and data nonces, so we need to be
specific about which nonce each use needs. For now, there is no
difference in the two functions.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 common/encrypt    | 33 ++++++++++++++++++++++++++-------
 tests/f2fs/002    |  2 +-
 tests/generic/613 |  4 ++--
 3 files changed, 29 insertions(+), 10 deletions(-)

diff --git a/common/encrypt b/common/encrypt
index 1a77e23b..04b6e5ac 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -488,7 +488,7 @@ _add_fscrypt_provisioning_key()
 # Retrieve the encryption nonce of the given inode as a hex string.  The nonce
 # was randomly generated by the filesystem and isn't exposed directly to
 # userspace.  But it can be read using the filesystem's debugging tools.
-_get_encryption_nonce()
+_get_encryption_file_nonce()
 {
 	local device=$1
 	local inode=$2
@@ -532,15 +532,34 @@ _get_encryption_nonce()
 			}'
 		;;
 	*)
-		_fail "_get_encryption_nonce() isn't implemented on $FSTYP"
+		_fail "_get_encryption_file_nonce() isn't implemented on $FSTYP"
 		;;
 	esac
 }
 
-# Require support for _get_encryption_nonce()
+# Retrieve the encryption nonce used to encrypt the data of the given inode as
+# a hex string.  The nonce was randomly generated by the filesystem and isn't
+# exposed directly to userspace.  But it can be read using the filesystem's
+# debugging tools.
+_get_encryption_data_nonce()
+{
+	local device=$1
+	local inode=$2
+
+	case $FSTYP in
+	ext4|f2fs)
+		_get_encryption_file_nonce $device $inode
+		;;
+	*)
+		_fail "_get_encryption_data_nonce() isn't implemented on $FSTYP"
+		;;
+	esac
+}
+
+# Require support for _get_encryption_*nonce()
 _require_get_encryption_nonce_support()
 {
-	echo "Checking for _get_encryption_nonce() support for $FSTYP" >> $seqres.full
+	echo "Checking for _get_encryption_*nonce() support for $FSTYP" >> $seqres.full
 	case $FSTYP in
 	ext4)
 		_require_command "$DEBUGFS_PROG" debugfs
@@ -554,7 +573,7 @@ _require_get_encryption_nonce_support()
 		# the test fail in that case, as it was an f2fs-tools bug...
 		;;
 	*)
-		_notrun "_get_encryption_nonce() isn't implemented on $FSTYP"
+		_notrun "_get_encryption_*nonce() isn't implemented on $FSTYP"
 		;;
 	esac
 }
@@ -760,7 +779,7 @@ _do_verify_ciphertext_for_encryption_policy()
 	echo "Verifying encrypted file contents" >> $seqres.full
 	for f in "${test_contents_files[@]}"; do
 		read -r src inode blocklist <<< "$f"
-		nonce=$(_get_encryption_nonce $SCRATCH_DEV $inode)
+		nonce=$(_get_encryption_data_nonce $SCRATCH_DEV $inode)
 		_dump_ciphertext_blocks $SCRATCH_DEV $blocklist > $tmp.actual_contents
 		$crypt_contents_cmd $contents_encryption_mode $raw_key_hex \
 			--file-nonce=$nonce --block-size=$blocksize \
@@ -780,7 +799,7 @@ _do_verify_ciphertext_for_encryption_policy()
 	echo "Verifying encrypted file names" >> $seqres.full
 	for f in "${test_filenames_files[@]}"; do
 		read -r name inode dir_inode padding <<< "$f"
-		nonce=$(_get_encryption_nonce $SCRATCH_DEV $dir_inode)
+		nonce=$(_get_encryption_file_nonce $SCRATCH_DEV $dir_inode)
 		_get_ciphertext_filename $SCRATCH_DEV $inode $dir_inode \
 			> $tmp.actual_name
 		echo -n "$name" | \
diff --git a/tests/f2fs/002 b/tests/f2fs/002
index 8235d88a..a51ddf22 100755
--- a/tests/f2fs/002
+++ b/tests/f2fs/002
@@ -129,7 +129,7 @@ blocklist=$(_get_ciphertext_block_list $file)
 _scratch_unmount
 
 echo -e "\n# Getting file's encryption nonce"
-nonce=$(_get_encryption_nonce $SCRATCH_DEV $inode)
+nonce=$(_get_encryption_data_nonce $SCRATCH_DEV $inode)
 
 echo -e "\n# Dumping the file's raw data"
 _dump_ciphertext_blocks $SCRATCH_DEV $blocklist > $tmp.raw
diff --git a/tests/generic/613 b/tests/generic/613
index 4cf5ccc6..47c60e9c 100755
--- a/tests/generic/613
+++ b/tests/generic/613
@@ -68,10 +68,10 @@ echo -e "\n# Getting encryption nonces from inodes"
 echo -n > $tmp.nonces_hex
 echo -n > $tmp.nonces_bin
 for inode in "${inodes[@]}"; do
-	nonce=$(_get_encryption_nonce $SCRATCH_DEV $inode)
+	nonce=$(_get_encryption_data_nonce $SCRATCH_DEV $inode)
 	if (( ${#nonce} != 32 )) || [ -n "$(echo "$nonce" | tr -d 0-9a-fA-F)" ]
 	then
-		_fail "Expected nonce to be 16 bytes (32 hex characters), but got \"$nonce\""
+		_fail "Expected nonce for inode $inode to be 16 bytes (32 hex characters), but got \"$nonce\""
 	fi
 	echo $nonce >> $tmp.nonces_hex
 	echo -ne "$(echo $nonce | sed 's/[0-9a-fA-F]\{2\}/\\x\0/g')" \
-- 
2.41.0

