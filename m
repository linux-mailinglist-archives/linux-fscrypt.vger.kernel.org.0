Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 27A1765933D
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Dec 2022 00:35:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234286AbiL2XfO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Dec 2022 18:35:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234261AbiL2XfI (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Dec 2022 18:35:08 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3D7C817400;
        Thu, 29 Dec 2022 15:35:06 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0A4FB81A7C;
        Thu, 29 Dec 2022 23:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95E06C433F0;
        Thu, 29 Dec 2022 23:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672356903;
        bh=jmoj6R6gY8smk3dnMjMohxTWwjv+iMLa1saGMKzmISc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=UG61ZeayE/Ym8bci4ImtSwOpSWNdSXqsCdPdelAJgSDloitkwFbbMhQqEzX4PtkCH
         GLwzRAt1rcqvk8VZef7gyRkh5A+UFIWIOSzaOr4dKag8quLNPNNixGtBmvDUHWYzPv
         zIAGn+Pj/pMMTC7oGUoKQWJtAPmliBSxAE3L/t63YzRnCyaHYL5z9iIfvcZJfe07ga
         CUfbGGZoW5OHyuqVsOsJTMBFy4gSk/gCfNyKZ2w5VxNXdHVfdVEPPkvUkjq4PBJbA1
         VxZDL/1IdZkDbZW1BB80ZfyVyDn6o8dMbcX8L7IEnVu9tpTy8vioNsHhbCjAhrMsJP
         aLTgIpuADp8Iw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v3 03/10] common/verity: use FSV_BLOCK_SIZE by default
Date:   Thu, 29 Dec 2022 15:32:15 -0800
Message-Id: <20221229233222.119630-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221229233222.119630-1-ebiggers@kernel.org>
References: <20221229233222.119630-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Make _fsv_enable() and _fsv_sign() default to FSV_BLOCK_SIZE if no block
size is explicitly specified, so that the individual tests don't have to
do this themselves.  This overrides the fsverity-utils default of 4096
bytes, or the page size in older versions of fsverity-utils, both of
which may differ from FSV_BLOCK_SIZE.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/verity | 16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

diff --git a/common/verity b/common/verity
index a94ebf8e..1c706b80 100644
--- a/common/verity
+++ b/common/verity
@@ -249,7 +249,13 @@ _fsv_dump_signature()
 
 _fsv_enable()
 {
-	$FSVERITY_PROG enable "$@"
+	local args=("$@")
+	# If the caller didn't explicitly specify a Merkle tree block size, then
+	# use FSV_BLOCK_SIZE.
+	if ! [[ " $*" =~ " --block-size" ]]; then
+		args+=("--block-size=$FSV_BLOCK_SIZE")
+	fi
+	$FSVERITY_PROG enable "${args[@]}"
 }
 
 _fsv_measure()
@@ -259,7 +265,13 @@ _fsv_measure()
 
 _fsv_sign()
 {
-	$FSVERITY_PROG sign "$@"
+	local args=("$@")
+	# If the caller didn't explicitly specify a Merkle tree block size, then
+	# use FSV_BLOCK_SIZE.
+	if ! [[ " $*" =~ " --block-size" ]]; then
+		args+=("--block-size=$FSV_BLOCK_SIZE")
+	fi
+	$FSVERITY_PROG sign "${args[@]}"
 }
 
 # Generate a file, then enable verity on it.
-- 
2.39.0

