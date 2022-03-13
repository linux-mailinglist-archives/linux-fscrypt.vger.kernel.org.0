Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AADF34D7209
	for <lists+linux-fscrypt@lfdr.de>; Sun, 13 Mar 2022 02:06:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232296AbiCMBHq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 12 Mar 2022 20:07:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232055AbiCMBHo (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 12 Mar 2022 20:07:44 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 50B231470DF;
        Sat, 12 Mar 2022 17:06:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCD8D60DD8;
        Sun, 13 Mar 2022 01:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35773C340F5;
        Sun, 13 Mar 2022 01:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647133596;
        bh=k4S5di8zkPHlytVqNzUKf65R4jUD1HKT508FSPuOsA8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DDbbwEPJT1hHytorHuv4AbNo+VIoPSYjfv0phRFw6m4LoSFQeMf9jhRnhvegRj8rH
         NbuRKHLfxZcwORev1Qych11LAYbPTUtoEMvAWaHpE/RiyidcP5BoPhGiix46x0VqKV
         iSy4ePqLgjfXmoRiSnCx8BqHMNF1aiyvVrbl+C43vqbjXIiA5Ls4luO/MCGbVkid3U
         waKyuesodWSUlBDpM3I8fKN3HYsXX9DgpZN8ZnNmjdK2x4tBQ/WFjuT8l4b0aaLcpc
         b6ok3wZqWkVxucCA6dzsqavyRPpkhJyOHz4hjGYrKPE8ISD3EJZZDjx/7lkt4fqOZ9
         JRekqU5vskt0Q==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 4/5] common/encrypt: log full ciphertext verification params
Date:   Sat, 12 Mar 2022 17:05:58 -0800
Message-Id: <20220313010559.545995-5-ebiggers@kernel.org>
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

