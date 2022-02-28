Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 223FC4C6408
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Feb 2022 08:49:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231293AbiB1Hte (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Feb 2022 02:49:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32914 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231740AbiB1Htd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Feb 2022 02:49:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 65F083D1D5;
        Sun, 27 Feb 2022 23:48:55 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BB54861055;
        Mon, 28 Feb 2022 07:48:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0D75DC36AE2;
        Mon, 28 Feb 2022 07:48:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646034534;
        bh=k4S5di8zkPHlytVqNzUKf65R4jUD1HKT508FSPuOsA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sE14u/qwCnfBlxCteiw3dZcSa9M8Vn3tOo8P7cdM8vAixPOyz519NTtPjYlzRVORZ
         HDZskbayZNOnbmUYLaTQXIuqyzbCPIMlW0rzsuE+9n9krbzx8zun02OnXEdr05EDgY
         rQqNyqlA5J2tF2TWde7zGmBq6yN020ZILXYEsxqtJjBDKT2Pyq5/n4cSgsbon8dAfp
         0iM2fSFyPGdcs00zbWN9BQN5Fopnl5L2FAQTO+oWwDJFacnJSDq9yBij0HLtebpcSe
         7M2nt5BqoakhMncuY4LiS63y0xLXKc8Mab7JwyGIcehMUA3SMqO0QFlPwaRFdMDWTC
         chW2hWOHqIsxw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [RFC PATCH 4/8] common/encrypt: log full ciphertext verification params
Date:   Sun, 27 Feb 2022 23:47:18 -0800
Message-Id: <20220228074722.77008-5-ebiggers@kernel.org>
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

To help with debugging, log some additional information to $seqres.full.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/encrypt | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/common/encrypt b/common/encrypt
index 2cf02ca0..cf402570 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -908,6 +908,17 @@ _verify_ciphertext_for_encryption_policy()
 	echo -e "\tfilenames_encryption_mode: $filenames_encryption_mode"
 	[ $# -ne 0 ] && echo -e "\toptions: $*"
 
+	cat >> $seqres.full <<EOF
+Full ciphertext verification parameters:
+  contents_encryption_mode = $contents_encryption_mode
+  filenames_encryption_mode = $filenames_encryption_mode
+  policy_flags = $policy_flags
+  set_encpolicy_args = $set_encpolicy_args
+  keyspec = $keyspec
+  raw_key_hex = $raw_key_hex
+  crypt_util_contents_args = $crypt_util_contents_args
+  crypt_util_filename_args = $crypt_util_filename_args
+EOF
 	_do_verify_ciphertext_for_encryption_policy \
 		"$contents_encryption_mode" \
 		"$filenames_encryption_mode" \
-- 
2.35.1

