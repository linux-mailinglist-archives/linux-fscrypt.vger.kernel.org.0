Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13F64DA520
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Mar 2022 23:16:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350324AbiCOWRX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 15 Mar 2022 18:17:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46860 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352117AbiCOWRV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 15 Mar 2022 18:17:21 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6CA355BD4;
        Tue, 15 Mar 2022 15:16:08 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 32FC75C01FC;
        Tue, 15 Mar 2022 18:16:08 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 15 Mar 2022 18:16:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; bh=yBU7ee8GgstnrKpZtmIYUDQFJY8SAT
        8Fh47TW6BpOoI=; b=vMVLsIYegBDYQP2rj7qwq79ZOiw+xpb/jR3TGSJWJVTOl8
        Ha/53kUqzz/p0zXbTKuVUqwHqxuUzL/K/yBT5qDfCthUp3N3hRbp0Q0NDRoNDfvf
        Y9GBh0PUfWSbgmZQVTsKpPbA2qSAGhJDWT3u2dfR0e0Nvcah5LHSj3ZX+7yn9HJS
        t450GhxkmbE1qnmwKhyW3n1PCmdIJIuin3kLljIUSO9GRmo/4F17NDi4BcSIRVyX
        3JtTnVAU+X77PZzPYN3z582D5GaDITNS3xRKHUACUczfu7B8uCqexKYqSxTGkC2S
        iUCywFOygXWOZKfq7opkIHHV2shfCr6ja4XSFVPQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=yBU7ee
        8GgstnrKpZtmIYUDQFJY8SAT8Fh47TW6BpOoI=; b=KXgC9QnbCwu/o2KNxmPc5E
        F6P/VucpZN+m1OpZpHwEG7w/A17UBZcto1X25DuRNGFsu4roQit6fcQ8KNTKM6Mu
        8izKGzsuM83hzVePKtRH1OisKFBLyKYTSqe6CEOCPjQ3yQawQJHxJlVFhMHhOMuN
        MbEs2K8/mFBvikSPnpkjfYf1pqmMblWVlHZEFw66Q4LrC1jgft5ypfhVwWzggQ8a
        3ucDhoXol8Dc21m1tkloqGauhANU+LGMZXAZix4v4yIjYAmj6NLYqPdSn+XzCxmN
        6C1Jx+xFfQzcdXqUAK5rOGwYk/g/jcKK7I4w5dcOPurqRLOOlB3htienbnnyMPYA
        ==
X-ME-Sender: <xms:KBAxYqoZ6h7Chjkgtq9OlQLFRFQnK_XB6DwW_hPIBAqcRrdFBqt6cQ>
    <xme:KBAxYorFadmIusYc8y5507ZIhkph3P9U1FRnFwEQjDAi0E4I5dfz82Bfv8_2WuHch
    nfRRJKq6WOjOVL_4Io>
X-ME-Received: <xmr:KBAxYvNvG1j9GVUtjrZPBzP0BAEvZOrXF--oDukhL1xoQAwV7Y0kdp0eKMy7hoAJ5_WF4qhw1DJm4u9DGAYy3AQCllHnBQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeftddgudehkecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgepudenucfrrghrrghm
    pehmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:KBAxYp5oKl1xnoHrB3YeY-k216-AcOmFkPya1qYJcnrq5QOH5qzR2Q>
    <xmx:KBAxYp5D-HZIjkuX73ASULBjoX4UfY0aLZZr3T5k9rVjHeATHtODIQ>
    <xmx:KBAxYphaA4_lG-oI85Egbao5jjRCb7DZjqeK7YGtJlCr-d4qjeyLqw>
    <xmx:KBAxYpHmoCz9FsX7RWpyqio2ZGqKzZcVZ0MZrdQepqii4pqNxrgdDw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Mar 2022 18:16:07 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v7 3/5] generic/574: corrupt btrfs merkle tree data
Date:   Tue, 15 Mar 2022 15:15:59 -0700
Message-Id: <6d08195d452509ebf0f8724fd3c25a7cd2079232.1647382272.git.boris@bur.io>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647382272.git.boris@bur.io>
References: <cover.1647382272.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

generic/574 has tests for corrupting the merkle tree data stored by the
filesystem. Since btrfs uses a different scheme for storing this data,
the existing logic for corrupting it doesn't work out of the box. Adapt
it to properly corrupt btrfs merkle items.

This test relies on the btrfs implementation of fsverity in the patch:
btrfs: initial fsverity support

and on btrfs-corrupt-block for corruption in the patches titled:
btrfs-progs: corrupt generic item data with btrfs-corrupt-block
btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block

Signed-off-by: Boris Burkov <boris@bur.io>
---
 common/verity     | 15 +++++++++++++++
 tests/generic/574 |  1 +
 2 files changed, 16 insertions(+)

diff --git a/common/verity b/common/verity
index 77766fca..db03510e 100644
--- a/common/verity
+++ b/common/verity
@@ -328,6 +328,21 @@ _fsv_scratch_corrupt_merkle_tree()
 		(( offset += ($(_get_filesize $file) + 65535) & ~65535 ))
 		_fsv_scratch_corrupt_bytes $file $offset
 		;;
+	btrfs)
+		local ino=$(stat -c '%i' $file)
+		_scratch_unmount
+		local byte=""
+		while read -n 1 byte; do
+			local ascii=$(printf "%d" "'$byte'")
+			# This command will find a Merkle tree item for the inode (-I $ino,37,0)
+			# in the default filesystem tree (-r 5) and corrupt one byte (-b 1) at
+			# $offset (-o $offset) with the ascii representation of the byte we read
+			# (-v $ascii)
+			$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,37,0 -v $ascii -o $offset -b 1 $SCRATCH_DEV
+			(( offset += 1 ))
+		done
+		_scratch_mount
+		;;
 	*)
 		_fail "_fsv_scratch_corrupt_merkle_tree() unimplemented on $FSTYP"
 		;;
diff --git a/tests/generic/574 b/tests/generic/574
index 17fdea52..18810ab2 100755
--- a/tests/generic/574
+++ b/tests/generic/574
@@ -27,6 +27,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _require_scratch_verity
+_require_fsverity_corruption
 _disable_fsverity_signatures
 _require_fsverity_corruption
 
-- 
2.31.0

