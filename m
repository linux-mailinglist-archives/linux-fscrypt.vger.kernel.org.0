Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB4DF358D17
	for <lists+linux-fscrypt@lfdr.de>; Thu,  8 Apr 2021 20:57:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232970AbhDHS6I (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 14:58:08 -0400
Received: from wout5-smtp.messagingengine.com ([64.147.123.21]:57761 "EHLO
        wout5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232856AbhDHS6H (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 14:58:07 -0400
Received: from compute2.internal (compute2.nyi.internal [10.202.2.42])
        by mailout.west.internal (Postfix) with ESMTP id B67831262;
        Thu,  8 Apr 2021 14:57:55 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 08 Apr 2021 14:57:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm3; bh=ajYa6BTOpFUxtQd67b/LHvTz/V
        VZqbhJoiZySGL+5Xo=; b=FPUWb5XhOA4tro8d6C82/9v3vvyn2ShA1+F1hpDla+
        qTbXMJyPx5SOzQ9hUIWY0b4zecKWVh3vJ9ynYBPDJT4eZScwtKVdWj/38uz2auQn
        0SOjpOe1Y0xVIENh92xmu6qRQ9FI1M07ODqoRBHm0mEhQoh9A16ccs5HGWBIs8EY
        +dGa7ayPxS1w70+uFkEDsSAczbN1O7Rti/gOeCqlkqmncU4FXk6k51dn8lMXZX0x
        rgA9gILNn8UnYVwLVrSiyGg4Kc+nExO1UD7KVau7UgL8ctj6GHtWEKAaVDXcAZhR
        yr6uijJJ92taJ+DDOplzZKb0Vxq6axBQmQLVm3lJ/vuA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm2; bh=ajYa6BTOpFUxtQd67b/LHvTz/VVZqbhJoiZySGL+5Xo=; b=KEawTGML
        pWx7abkUNMrBbQvw/yvGf/SZjJ0CZhR+PeM8p6G43f2IRptxhtk4/anJdBJrDmMf
        u+Lvq2Hxsw1JveOOK7usjCIeCdggJKw+8eGoMc2VbW0LywBmM6HuFPbSg9jCUYau
        IcQQ0alg5HhnICHXTMK4P2hp89kZUxAwOvU2axVJ4fwdn0RwgbfxIRde2Ummb+Y7
        tsGx4WvCHa+MgHPyBgZ6DKei0fQsLATwUlCm1XFxoh60Dmg6zxFkgjGc2shxV8pq
        bNJoGvexqkzfAGPSauAW6BS1pMgln1zp/Xb7OR1obletg5mVsmIG1YS2PAPk8j5K
        LoRmQsTSl+e4Hw==
X-ME-Sender: <xms:M1JvYHlDRPpYoTLEEK8_7UeHXkM8CIYXudI9rm9rpXM6SJg7DHrydA>
    <xme:M1JvYK2MMU1GO1BeF7DOJvtHew1DkokmqgEl5T5WSGqBQYm5XXbJxdFDUAAVNaswX
    JPZx8mXz1kUtPm0qBk>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrudejledgudeffecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhioh
X-ME-Proxy: <xmx:M1JvYNqrWA8x5De9KHf-gqhjZbEsA6LTfK8_VeJhRBuhY2Ortvq3TQ>
    <xmx:M1JvYPlzAvELDEqsIXnGkmFcRipAmyHkrfGd5EP538DDOqvtfHwjNw>
    <xmx:M1JvYF3bDOZmxnXIDWfMhOJncOW0-lJ6Cb7-PJ2bKiRLf_h4olWk4g>
    <xmx:M1JvYG-lrBzrcAsStA3x8KHeFVdvTi0CCqwQ2j3tmDpRBsfzupgeqA>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA id 18FA524005E;
        Thu,  8 Apr 2021 14:57:55 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v3 2/3] generic/574: corrupt btrfs merkle tree data
Date:   Thu,  8 Apr 2021 11:57:50 -0700
Message-Id: <4429f6365c3250efe9bf7bc0a1a22e642b149f61.1617908086.git.boris@bur.io>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <cover.1617908086.git.boris@bur.io>
References: <cover.1617908086.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

generic/574 has tests for corrupting the merkle tree data stored by the
filesystem. Since btrfs uses a different scheme for storing this data,
the existing logic for corrupting it doesn't work out of the box. Adapt
it to properly corrupt btrfs merkle items.

Note that there is a bit of a kludge here: since btrfs_corrupt_block
doesn't handle streaming corruption bytes from stdin (I could change
that, but it feels like overkill for this purpose), I just read the
first corruption byte and duplicate it for the desired length. That is
how the test is using the interface in practice, anyway.

This relies on the following kernel patch for btrfs verity support:
<btrfs-verity-patch>
And the following btrfs-progs patch for btrfs_corrupt_block support:
<btrfs-corrupt-block-patch>

Signed-off-by: Boris Burkov <boris@bur.io>
---
 common/verity | 15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

diff --git a/common/verity b/common/verity
index d2c1ea24..fdd05783 100644
--- a/common/verity
+++ b/common/verity
@@ -3,8 +3,7 @@
 #
 # Functions for setting up and testing fs-verity
 
-_require_scratch_verity()
-{
+_require_scratch_verity() {
 	_require_scratch
 	_require_command "$FSVERITY_PROG" fsverity
 
@@ -315,6 +314,18 @@ _fsv_scratch_corrupt_merkle_tree()
 		(( offset += ($(_get_filesize $file) + 65535) & ~65535 ))
 		_fsv_scratch_corrupt_bytes $file $offset
 		;;
+	btrfs)
+		ino=$(ls -i $file | awk '{print $1}')
+		sync
+		cat > $tmp.bytes
+		sz=$(_get_filesize $tmp.bytes)
+		read -n 1 byte < $tmp.bytes
+		ascii=$(printf "%d" "'$byte'")
+		_scratch_unmount
+		$BTRFS_CORRUPT_BLOCK_PROG -r 5 -I $ino,37,0 -v $ascii -o $offset -b $sz $SCRATCH_DEV
+		sync
+		_scratch_mount
+		;;
 	*)
 		_fail "_fsv_scratch_corrupt_merkle_tree() unimplemented on $FSTYP"
 		;;
-- 
2.30.2

