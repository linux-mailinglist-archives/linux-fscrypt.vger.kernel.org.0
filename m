Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6FC64D720C
	for <lists+linux-fscrypt@lfdr.de>; Sun, 13 Mar 2022 02:06:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233325AbiCMBHr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 12 Mar 2022 20:07:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233320AbiCMBHp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 12 Mar 2022 20:07:45 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 31343149979;
        Sat, 12 Mar 2022 17:06:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D6D69B80AF4;
        Sun, 13 Mar 2022 01:06:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6C1CCC340F7;
        Sun, 13 Mar 2022 01:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647133596;
        bh=0hiKtnvItwbeAVZHNDETPFE8syYxYRcQaVRMGhIxECM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=jEZ6kHkBZGcXpASLKqYGG4lBh1Kyq2fL2gC7O/yot1W+WFYiVLkA2UKplN99Iv1qR
         SXN43vx6u1cfXtjwcSy9JyZOwzYHcSfUDmPsxLacKoykzKR6bTW+1jpz0voeXcW8rK
         gQIzZP0aiFMeLdexW/asc1bD3sWH3ZyLa8aSvMTHPNlpKuds7AUmi2Ppb/9nHUAyWN
         VZ1URr8IN91KlgrPOja3q0E7NaqLXo4BEsa79uNDcMIGpZd5oIMkRuOBcEEfHeeQgV
         gS7DMucvW06tvMT3q3CoIAQr6/AY4o+89Me6V8fU7NM1+owWlwvJcDkSTvmgTOqVF+
         978C+M9TsT2bw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 5/5] common/encrypt: verify the key identifiers
Date:   Sat, 12 Mar 2022 17:05:59 -0800
Message-Id: <20220313010559.545995-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220313010559.545995-1-ebiggers@kernel.org>
References: <20220313010559.545995-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

As part of all the ciphertext verification tests, verify that the
filesystem correctly computed the key identifier from the key the test
generated.  This uses fscrypt-crypt-util to compute the key identifier.

Previously this was only being tested indirectly, via the tests that
happen to use the hardcoded $TEST_RAW_KEY and $TEST_KEY_IDENTIFIER.
The new check provides better coverage.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/encrypt | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/common/encrypt b/common/encrypt
index cf402570..78a574bd 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -812,6 +812,7 @@ _verify_ciphertext_for_encryption_policy()
 	local crypt_util_args=""
 	local crypt_util_contents_args=""
 	local crypt_util_filename_args=""
+	local expected_identifier
 
 	shift 2
 	for opt; do
@@ -902,6 +903,18 @@ _verify_ciphertext_for_encryption_policy()
 	fi
 	local raw_key_hex=$(echo "$raw_key" | tr -d '\\x')
 
+	if (( policy_version > 1 )); then
+		echo "Verifying key identifier" >> $seqres.full
+		expected_identifier=$($here/src/fscrypt-crypt-util  \
+				      --dump-key-identifier "$raw_key_hex" \
+				      $crypt_util_args)
+		if [ "$expected_identifier" != "$keyspec" ]; then
+			echo "KEY IDENTIFIER MISMATCH!"
+			echo "    Expected: $expected_identifier"
+			echo "    Actual: $keyspec"
+		fi
+	fi
+
 	echo
 	echo -e "Verifying ciphertext with parameters:"
 	echo -e "\tcontents_encryption_mode: $contents_encryption_mode"
-- 
2.35.1

