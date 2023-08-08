Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D8353774439
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232808AbjHHSQR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:16:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232978AbjHHSPy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:15:54 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DCFA35AA;
        Tue,  8 Aug 2023 10:22:15 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 1542F83548;
        Tue,  8 Aug 2023 13:22:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691515335; bh=k80BosUuOf3+UJm9EFkXHB69AfR7v14eADYsDzCRrm8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=ehjjsu3wu1rmbMIsG8YnYBgeZrV5ixD8xbUyncG5Ux1jx2ZVVq5OpekqEcHmbqtPE
         RsROO5EZclETdFRvSgxUyKu9/YEM5mwY6E1pfA5yfsfr//lIKcofAI5hGn2RXOIrUE
         DgEGAmstfmbkgy7t2ae8akFhm+0P3yE1C/HRVvOitL3YfrAhWhzBRI7mdlcpoSJH4M
         MyZ/1I3AQ1TpghdvWyzIvBanGvwcbnyfJ0Ixmj5cfYJ2Dc2/C/pK4uadaOSAFSsxJB
         AljBYxqlJrMzoarmJM9bXIecmQ34GfJmoqqeX19XHAi7MxwSUSyP1ahqZYrsNyOwgn
         G71014MWyEG0w==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@meta.com, ebiggers@google.com, anand.jain@oracle.com,
        fdmanana@suse.com, linux-fscrypt@vger.kernel.org,
        fsverity@lists.linux.dev, zlang@kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH v3 5/9] generic/613: write some actual data for btrfs
Date:   Tue,  8 Aug 2023 13:21:24 -0400
Message-ID: <200c306794a620f1ff7db0dddf304ec5997e4456.1691530000.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691530000.git.sweettea-kernel@dorminy.me>
References: <cover.1691530000.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
2.41.0

