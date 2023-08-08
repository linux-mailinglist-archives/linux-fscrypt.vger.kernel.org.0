Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D585774432
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:16:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235529AbjHHSQL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:16:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234346AbjHHSPv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:15:51 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E26672B5;
        Tue,  8 Aug 2023 10:22:11 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id D0F97803AF;
        Tue,  8 Aug 2023 13:22:10 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691515331; bh=HJHfEC2utk1cT+5gy9FZrT+lWxfLUWWvrcTsspJsx8o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IAOTX6hDO3oSDCTKQhbvj44A4DCZReh40FzcvOoLgZqLZuLyUoFfAQk+/sx++ILYF
         yZ46K7lXTxpC9I0p87zVtte5WQbhguhD93b+1m/ekmS2nAizJH5JxgeYKJDzUKlV/L
         wJATGXDG+SZC0tWdDmfw2CY+TXVk7zsbhxFn780MDea1P173atgczECY8imkeGyV5z
         dywPb4l6mPD1a1qN7ulAc1xqV8xmNSQekWebmmnOdEblUSmh3VdD/ZZLDOkqIiLU4N
         K39JaR5+e7U7+A8+FjTN1QfS3A6jfFEDCVsBxYMEisvMeKSajDtO2eEFkqJdyLdGcV
         JoqUJ6nIP/t4Q==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@meta.com, ebiggers@google.com, anand.jain@oracle.com,
        fdmanana@suse.com, linux-fscrypt@vger.kernel.org,
        fsverity@lists.linux.dev, zlang@kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH v3 2/9] common/encrypt: add btrfs to get_encryption_*nonce
Date:   Tue,  8 Aug 2023 13:21:21 -0400
Message-ID: <dd7c1bbeb443fbb6d0836fe2b5be394c991dc4d0.1691530000.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691530000.git.sweettea-kernel@dorminy.me>
References: <cover.1691530000.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Add the modes of getting the encryption nonces, either inode or extent,
to the various get_encryption_nonce functions. For now, no encrypt test
makes a file with more than one extent, so we can just grab the first
extent's nonce for the data nonce; when we write a bigger file test,
we'll need to change that.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 common/encrypt    | 31 +++++++++++++++++++++++++++++++
 tests/generic/613 |  4 ++++
 2 files changed, 35 insertions(+)

diff --git a/common/encrypt b/common/encrypt
index 04b6e5ac..fc1c8cc7 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -531,6 +531,17 @@ _get_encryption_file_nonce()
 				found = 0;
 			}'
 		;;
+	btrfs)
+		# Retrieve the fscrypt context for an inode as a hex string.
+		# btrfs prints these like:
+		#        item 14 key ($inode FSCRYPT_CTXT_ITEM 0) itemoff 15491 itemsize 40
+		#                value: 02010400000000008fabf3dd745d41856e812458cd765bf0140f41d62853f4c0351837daff4dcc8f
+
+		$BTRFS_UTIL_PROG inspect-internal dump-tree $device | \
+			grep -A 1 "key ($inode FSCRYPT_CTXT_ITEM 0)" | \
+			grep --only-matching 'value: [[:xdigit:]]\+' | \
+			tr -d ' \n' | tail -c 32
+		;;
 	*)
 		_fail "_get_encryption_file_nonce() isn't implemented on $FSTYP"
 		;;
@@ -550,6 +561,23 @@ _get_encryption_data_nonce()
 	ext4|f2fs)
 		_get_encryption_file_nonce $device $inode
 		;;
+	btrfs)
+		# Retrieve the encryption IV of the first file extent in an inode as a hex
+		# string. btrfs prints the file extents (for simple unshared
+		# inodes) like:
+		#         item 21 key ($inode EXTENT_DATA 0) itemoff 2534 itemsize 69
+		#                generation 7 type 1 (regular)
+                #		 extent data disk byte 5304320 nr 1048576
+                #		 extent data offset 0 nr 1048576 ram 1048576
+                #		 extent compression 0 (none)
+                #		 extent encryption 161 ((1, 40: context 0201040200000000116a77667261d7422a4b1ed8c427e685edb7a0d370d0c9d40030333033333330))
+
+
+		$BTRFS_UTIL_PROG inspect-internal dump-tree $device | \
+			grep -A 5 "key ($inode EXTENT_DATA 0)" | \
+			grep --only-matching 'context [[:xdigit:]]\+' | \
+			tr -d ' \n' | tail -c 32
+		;;
 	*)
 		_fail "_get_encryption_data_nonce() isn't implemented on $FSTYP"
 		;;
@@ -572,6 +600,9 @@ _require_get_encryption_nonce_support()
 		# Otherwise the xattr is incorrectly parsed as v1.  But just let
 		# the test fail in that case, as it was an f2fs-tools bug...
 		;;
+	btrfs)
+		_require_command "$BTRFS_UTIL_PROG" btrfs
+		;;
 	*)
 		_notrun "_get_encryption_*nonce() isn't implemented on $FSTYP"
 		;;
diff --git a/tests/generic/613 b/tests/generic/613
index 47c60e9c..279b1bfb 100755
--- a/tests/generic/613
+++ b/tests/generic/613
@@ -69,6 +69,10 @@ echo -n > $tmp.nonces_hex
 echo -n > $tmp.nonces_bin
 for inode in "${inodes[@]}"; do
 	nonce=$(_get_encryption_data_nonce $SCRATCH_DEV $inode)
+	if [ "$FSTYP" == "btrfs" ] && [ "$nonce" == "" ]
+	then
+		nonce=$(_get_encryption_file_nonce $SCRATCH_DEV $inode)
+	fi
 	if (( ${#nonce} != 32 )) || [ -n "$(echo "$nonce" | tr -d 0-9a-fA-F)" ]
 	then
 		_fail "Expected nonce for inode $inode to be 16 bytes (32 hex characters), but got \"$nonce\""
-- 
2.41.0

