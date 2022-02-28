Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 033794C63FE
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Feb 2022 08:49:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231740AbiB1Htf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Feb 2022 02:49:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231854AbiB1Htd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Feb 2022 02:49:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85B043D1DA;
        Sun, 27 Feb 2022 23:48:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0CA1B6106E;
        Mon, 28 Feb 2022 07:48:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52693C36AE3;
        Mon, 28 Feb 2022 07:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646034534;
        bh=ihLUvkE02m6lI4esqM8Hd125A3xtzXTuiFtrNib3XVc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Levyra1PYc86mC1p8NL+ce4caM5S6JoIRbOe2EhVXj4/vifBKMEYC9Sn3h5ivHlIW
         dVDOywO16lu3WEcT5sVtTJm38bqdCOA3ZS6ibDIARv6ST0aZh9O4CVixb+IP/aBuEJ
         F8FFQ+TsV0UHhxe1w9hVv78YteBHG8j68Xfwh6IWI8Hv52YOLlRjD+QQ26smI2YZ/D
         qI6l6Ib3MibUKdd1W67YyYfRy2h6nbYFu1Q+HhenBjjVQ0uK9/JMhFRDDJdJ/7KUpt
         x/OA1RyykYYynwpTW8NOtDWn1lZnlb0cSNRmAqj5P8eiDpWW6BlukavebM9hdlbmef
         QLl9GLskZVRYA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [RFC PATCH 5/8] common/encrypt: verify the key identifiers
Date:   Sun, 27 Feb 2022 23:47:19 -0800
Message-Id: <20220228074722.77008-6-ebiggers@kernel.org>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220228074722.77008-1-ebiggers@kernel.org>
References: <20220228074722.77008-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
 common/encrypt | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/common/encrypt b/common/encrypt
index cf402570..d8e2dba9 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -902,6 +902,18 @@ _verify_ciphertext_for_encryption_policy()
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

