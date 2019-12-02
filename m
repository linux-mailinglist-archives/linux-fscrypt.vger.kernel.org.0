Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 34DF010F316
	for <lists+linux-fscrypt@lfdr.de>; Tue,  3 Dec 2019 00:02:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726086AbfLBXCd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 Dec 2019 18:02:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:59508 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725939AbfLBXCd (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 Dec 2019 18:02:33 -0500
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B48C2071F;
        Mon,  2 Dec 2019 23:02:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1575327752;
        bh=5TycULaQZpS/DKJs/QLw8slbVfis5ujHgJKQe/yYs0o=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Anpcgyal8OxkbKcmQBByvwKnrFA5UqXyHlE7hQuIeZvXOk7ytJUeA9cT7kpa08UgY
         0FWoPop31+XxLGR/G35pQ0cZSTvruh1YLPJhYi8wN4EJG7NaX8/DcVAwvLfD2P4Stv
         XFJpTC9o0VTDU6adsY53TcSMWmRNIUgd3dR08Lm0=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>
Subject: [PATCH v2 3/5] common/encrypt: create named variables for UAPI constants
Date:   Mon,  2 Dec 2019 15:01:53 -0800
Message-Id: <20191202230155.99071-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.24.0.393.g34dc348eaf-goog
In-Reply-To: <20191202230155.99071-1-ebiggers@kernel.org>
References: <20191202230155.99071-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Use named variables rather than hard-coded numbers + comments.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/encrypt | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/common/encrypt b/common/encrypt
index 90f931fc..b967c65a 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -664,16 +664,26 @@ _do_verify_ciphertext_for_encryption_policy()
 	done
 }
 
+# fscrypt UAPI constants (see <linux/fscrypt.h>)
+
+FSCRYPT_MODE_AES_256_XTS=1
+FSCRYPT_MODE_AES_256_CTS=4
+FSCRYPT_MODE_AES_128_CBC=5
+FSCRYPT_MODE_AES_128_CTS=6
+FSCRYPT_MODE_ADIANTUM=9
+
+FSCRYPT_POLICY_FLAG_DIRECT_KEY=0x04
+
 _fscrypt_mode_name_to_num()
 {
 	local name=$1
 
 	case "$name" in
-	AES-256-XTS)		echo 1 ;; # FS_ENCRYPTION_MODE_AES_256_XTS
-	AES-256-CTS-CBC)	echo 4 ;; # FS_ENCRYPTION_MODE_AES_256_CTS
-	AES-128-CBC-ESSIV)	echo 5 ;; # FS_ENCRYPTION_MODE_AES_128_CBC
-	AES-128-CTS-CBC)	echo 6 ;; # FS_ENCRYPTION_MODE_AES_128_CTS
-	Adiantum)		echo 9 ;; # FS_ENCRYPTION_MODE_ADIANTUM
+	AES-256-XTS)		echo $FSCRYPT_MODE_AES_256_XTS ;;
+	AES-256-CTS-CBC)	echo $FSCRYPT_MODE_AES_256_CTS ;;
+	AES-128-CBC-ESSIV)	echo $FSCRYPT_MODE_AES_128_CBC ;;
+	AES-128-CTS-CBC)	echo $FSCRYPT_MODE_AES_128_CTS ;;
+	Adiantum)		echo $FSCRYPT_MODE_ADIANTUM ;;
 	*)			_fail "Unknown fscrypt mode: $name" ;;
 	esac
 }
@@ -705,7 +715,7 @@ _verify_ciphertext_for_encryption_policy()
 			     $filenames_encryption_mode ]; then
 				_fail "For direct key mode, contents and filenames modes must match"
 			fi
-			(( policy_flags |= 0x04 )) # FS_POLICY_FLAG_DIRECT_KEY
+			(( policy_flags |= FSCRYPT_POLICY_FLAG_DIRECT_KEY ))
 			;;
 		*)
 			_fail "Unknown option '$opt' passed to ${FUNCNAME[0]}"
@@ -721,11 +731,11 @@ _verify_ciphertext_for_encryption_policy()
 	if (( policy_version > 1 )); then
 		set_encpolicy_args+=" -v 2"
 		crypt_util_args+=" --kdf=HKDF-SHA512"
-		if (( policy_flags & 0x04 )); then
+		if (( policy_flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY )); then
 			crypt_util_args+=" --mode-num=$contents_mode_num"
 		fi
 	else
-		if (( policy_flags & 0x04 )); then
+		if (( policy_flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY )); then
 			crypt_util_args+=" --kdf=none"
 		else
 			crypt_util_args+=" --kdf=AES-128-ECB"
-- 
2.24.0.393.g34dc348eaf-goog

