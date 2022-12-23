Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0F285654A67
	for <lists+linux-fscrypt@lfdr.de>; Fri, 23 Dec 2022 02:11:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236058AbiLWBLQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 22 Dec 2022 20:11:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235824AbiLWBKe (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 22 Dec 2022 20:10:34 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 789BC21894;
        Thu, 22 Dec 2022 17:07:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2BAD6B81DA4;
        Fri, 23 Dec 2022 01:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEB84C433F2;
        Fri, 23 Dec 2022 01:07:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671757622;
        bh=jmoj6R6gY8smk3dnMjMohxTWwjv+iMLa1saGMKzmISc=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=oFj72Map8tGgVqFJRPnggdZ2JW27jl6lXD74MGW1171aC5QNxwYBPxNsy32lfQY+Q
         ocEOG+9dpTQrtOqZyz8nxO1f0irDtDhYHO0GJeQQ0sOZMFYgsmW4ZopND78Twt9jkI
         OBcX7V7AQOg08KqiD2xjjf2dwbCr5Z7Wo4rMB+FPUR7raxB+8yanCxqjrFpJYkQ76+
         oamdJAnUWrde/eLSXsiXt/k0bvyvTtcSa6qr+x1D0pKEKOAvUiScYsAg9FS3gkpM4y
         D+v/17kq4ndK7gkTvPL31qW7tnFAv3f+AvbCazFmhp46F5wXnZoWTO5ojtoKy9io5A
         Ci+F973m813sw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 03/10] common/verity: use FSV_BLOCK_SIZE by default
Date:   Thu, 22 Dec 2022 17:05:47 -0800
Message-Id: <20221223010554.281679-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221223010554.281679-1-ebiggers@kernel.org>
References: <20221223010554.281679-1-ebiggers@kernel.org>
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

