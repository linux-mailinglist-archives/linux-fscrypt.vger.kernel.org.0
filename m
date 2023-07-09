Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ABA1974C7C7
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jul 2023 21:11:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229888AbjGITLY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jul 2023 15:11:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229769AbjGITLX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jul 2023 15:11:23 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4877103;
        Sun,  9 Jul 2023 12:11:22 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 32B39804C6;
        Sun,  9 Jul 2023 15:11:22 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688929882; bh=hRco+aZiR6zV/s62lKw1LnEYYKOCoUoqvQXPvj2ZlrQ=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Tz7ZYSmiEZ2lIEg4xfaSb5jOTyCytq4oyCRbGPYMJ9UWSivMCMEs0nOuTl6kjWrar
         QsNyX7H9B1CA9niHYWTjtbWFYJENlhtBhx8wunMudT23msPoVbRRgNd8XwY4iwkVMd
         cF4XR5U2PVlNeYCvY5MBqBwMROmgVNPAQjTey9vQBSW9SCbjm9Tg3n6ZbWP5F830p4
         uC2CmOjkMNV2u6q7PkoFTwubE7OYj4apo7mkNPOVH5q/2JyyYgDRA7CsR8ah/lJdgT
         vA0YDRFIVHsmJ6jwhdB2Zwc2UVUxZ1/HHx97Z3O5eyHFem6k0s6Q3JTAeK6ttNJq8K
         l4CXHtnzk48dw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@meta.com, ebiggers@google.com, anand.jain@oracle.com,
        fdmanana@suse.com, linux-fscrypt@vger.kernel.org,
        fsverity@lists.linux.dev, zlang@kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH v2 5/8] generic/613: write some actual data for btrfs
Date:   Sun,  9 Jul 2023 15:11:08 -0400
Message-Id: <548d104df621ba7532ff1b4ba2076cd3a24a98a0.1688929294.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1688929294.git.sweettea-kernel@dorminy.me>
References: <cover.1688929294.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Currently, the test touches a file and assumes that that is sufficient
to generate a new nonce to test for that file. However, btrfs doesn't
store an encryption context for a leaf inode, and doesn't store an
encryption context for data within a leaf inode until data is actually
written. Thus, merely touching the file on btrfs doesn't actually
generate a testable nonce.

Instead, write a trivial bit of data to each file, which provokes btrfs
to generate a encryption context for the data and thus a testable nonce.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 tests/generic/613 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tests/generic/613 b/tests/generic/613
index 279b1bfb..11f28c74 100755
--- a/tests/generic/613
+++ b/tests/generic/613
@@ -53,11 +53,11 @@ for i in {1..50}; do
 done
 for i in {1..50}; do
 	file=$SCRATCH_MNT/v1_policy_dir_1/$i
-	touch $file
+	echo "0" > $file
 	inodes+=("$(stat -c %i $file)")
 
 	file=$SCRATCH_MNT/v2_policy_dir_1/$i
-	touch $file
+	echo "0" > $file
 	inodes+=("$(stat -c %i $file)")
 done
 _scratch_unmount
-- 
2.40.1

