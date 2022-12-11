Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F006649308
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Dec 2022 08:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230186AbiLKHIC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Dec 2022 02:08:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230141AbiLKHHz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Dec 2022 02:07:55 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19BB9A463;
        Sat, 10 Dec 2022 23:07:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 2F61DCE0B01;
        Sun, 11 Dec 2022 07:07:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E587C433F0;
        Sun, 11 Dec 2022 07:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670742465;
        bh=R6jZ7zdfQigG689HseHD2EJYafMft1gQlkIU9/mxEmw=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GhYG6RScuprveOH/r+Pnc5TVXeNHc3fXHnxsWAPB+jKf27+jz17ijj3su572aAkx8
         mLpJt624KnJeOee7i/OqFRK5w3nVlB7V+NgXhw4HseRpacWCBnaZJwPQGBxfHqWJlm
         4hUyt5HpVA+BM6W0C0emUxkuhCGLJUwBjQz3w6IG077lqCSNsFfUeANPKn2sblQ8Kv
         WeSQafpcmY2tFc7L5ffajGgz9OjObo4DecJPjCDOrJDgZZ1Z35WYEqq6JRzaLn2jai
         QVvBJnMFML7k78v5Z2kwPEyHY34ofBy136LTB/flwMABvzoPHv2myLBFWcjgaGddwG
         E5W1wca3Dc7qA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 03/10] common/verity: use FSV_BLOCK_SIZE by default
Date:   Sat, 10 Dec 2022 23:06:56 -0800
Message-Id: <20221211070704.341481-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221211070704.341481-1-ebiggers@kernel.org>
References: <20221211070704.341481-1-ebiggers@kernel.org>
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
2.38.1

