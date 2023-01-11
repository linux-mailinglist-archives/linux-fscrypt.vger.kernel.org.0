Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7A104666500
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 Jan 2023 21:48:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230047AbjAKUsw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 11 Jan 2023 15:48:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229539AbjAKUsv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 11 Jan 2023 15:48:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D26D05FF8;
        Wed, 11 Jan 2023 12:48:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6B36C61E53;
        Wed, 11 Jan 2023 20:48:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF39EC433EF;
        Wed, 11 Jan 2023 20:48:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673470127;
        bh=HzsRQDLfFJisGLIvMqbnFWr06oooTi1mp0LWzSJqKEE=;
        h=From:To:Cc:Subject:Date:From;
        b=K2UO6+TFqKzTTio+chMxCyja8QqE3Mr2PTwbJfLvBYXiQltWFHfx3cdbrXlTii5na
         f68CvFomlhYRO4iu75kg7/YDtk/n7lE8NBmsJXlm4uKY4UcSVUbrxxQuOcMMymCw/J
         UrjSn3Z4Uth6aHXFJbDPhyRXK2guCqy5kDqyJwEuF2qje9khBEevkzVXVOKikwNOwL
         YdOGFcXvvscQKVvMLlSS/wvrHtcWN6yLLFQtfeiHqUkzAt62FJmf2T+Shj0dlfDmbf
         omMdD4KtntdzM0RIc28LAIfKgROdoYssadikI4i51EY63gPWrGasLPONN2IhXYO43a
         3OFKVXmnw92QQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: [PATCH v2] generic/692: generalize the test for non-4K Merkle tree block sizes
Date:   Wed, 11 Jan 2023 12:47:39 -0800
Message-Id: <20230111204739.77828-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.0
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

From: Ojaswin Mujoo <ojaswin@linux.ibm.com>

Due to the assumption of the Merkle tree block size being 4K, the file
size calculated for the second test case was taking way too long to hit
EFBIG in case of larger block sizes like 64K.  Fix this by generalizing
the calculation to any Merkle tree block size >= 1K.

Signed-off-by: Ojaswin Mujoo <ojaswin@linux.ibm.com>
Co-developed-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
v2: Cleaned up the original patch from Ojaswin:
    - Explained the calculations as they are done.
    - Considered 11 levels instead of 8, to account for 1K blocks
      potentially needing up to 11 levels.
    - Increased 'scale' for real number results, and don't use 'scale'
      at all for integer number results.
    - Improved a variable name.
    - Updated commit message.

 tests/generic/692 | 37 +++++++++++++++++++++++++------------
 1 file changed, 25 insertions(+), 12 deletions(-)

diff --git a/tests/generic/692 b/tests/generic/692
index d6da734b..90832b16 100755
--- a/tests/generic/692
+++ b/tests/generic/692
@@ -51,18 +51,31 @@ _fsv_enable $fsv_file |& _filter_scratch
 #
 # The Merkle tree is stored with the leaf node level (L0) last, but it is
 # written first.  To get an interesting overflow, we need the maximum file size
-# (MAX) to be in the middle of L0 -- ideally near the beginning of L0 so that we
-# don't have to write many blocks before getting an error.
-#
-# With SHA-256 and 4K blocks, there are 128 hashes per block.  Thus, ignoring
-# padding, L0 is 1/128 of the file size while the other levels in total are
-# 1/128**2 + 1/128**3 + 1/128**4 + ... = 1/16256 of the file size.  So still
-# ignoring padding, for L0 start exactly at MAX, the file size must be s such
-# that s + s/16256 = MAX, i.e. s = MAX * (16256/16257).  Then to get a file size
-# where MAX occurs *near* the start of L0 rather than *at* the start, we can
-# just subtract an overestimate of the padding: 64K after the file contents,
-# then 4K per level, where the consideration of 8 levels is sufficient.
-sz=$(echo "scale=20; $max_sz * (16256/16257) - 65536 - 4096*8" | $BC -q | cut -d. -f1)
+# ($max_sz) to be in the middle of L0 -- ideally near the beginning of L0 so
+# that we don't have to write many blocks before getting an error.
+
+bs=$FSV_BLOCK_SIZE
+hash_size=32   # SHA-256
+hash_per_block=$(echo "scale=30; $bs/($hash_size)" | $BC -q)
+
+# Compute the proportion of the original file size that the non-leaf levels of
+# the Merkle tree take up.  Ignoring padding, this is 1/${hashes_per_block}^2 +
+# 1/${hashes_per_block}^3 + 1/${hashes_per_block}^4 + ...  Compute it using the
+# formula for the sum of a geometric series: \sum_{k=0}^{\infty} ar^k = a/(1-r).
+a=$(echo "scale=30; 1/($hash_per_block^2)" | $BC -q)
+r=$(echo "scale=30; 1/$hash_per_block" | $BC -q)
+nonleaves_relative_size=$(echo "scale=30; $a/(1-$r)" | $BC -q)
+
+# Compute the original file size where the leaf level L0 starts at $max_sz.
+# Padding is still ignored, so the real value is slightly smaller than this.
+sz=$(echo "$max_sz/(1+$nonleaves_relative_size)" | $BC -q)
+
+# Finally, to get a file size where $max_sz occurs just after the start of L0
+# rather than *at* the start of L0, subtract an overestimate of the padding: 64K
+# after the file contents, then $bs per level for 11 levels.  11 levels is the
+# most levels that can ever be needed, assuming the block size is at least 1K.
+sz=$(echo "$sz - 65536 - $bs*11" | $BC -q)
+
 _fsv_scratch_begin_subtest "still too big: fail on first invalid merkle block"
 truncate -s $sz $fsv_file
 _fsv_enable $fsv_file |& _filter_scratch
-- 
2.39.0

