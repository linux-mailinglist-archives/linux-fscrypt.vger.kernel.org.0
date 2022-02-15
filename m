Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08F554B5ED9
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Feb 2022 01:10:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232430AbiBOAKQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 14 Feb 2022 19:10:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49646 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230054AbiBOAKO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 14 Feb 2022 19:10:14 -0500
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44F74AB476;
        Mon, 14 Feb 2022 16:10:05 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id C00635C02E2;
        Mon, 14 Feb 2022 19:10:04 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Mon, 14 Feb 2022 19:10:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; bh=8SgSt8Jr/5tgDmL7nQQgPMk/ZjwgaM
        rsp6Un67UcncM=; b=F7Rel9HUfVIJmoCkf7anUDfM5VAv6/O5yxI8R9IfDKv47H
        Fc5Nbrfjym3Iv28RmxrjZ077vcdtOYinSPnFx9E/FemDurR55JTtwl4zkVchYliO
        aaGqA9mmwA7rDkWf+zv7RY47YnWGq0KDn2/d61TAoL+4Qq2054Lj0G3mBJG8UshS
        Tx7dlT+E7VsCpcD19x8ZJ2d1RzImWUd95z64nhHHcXb5ref0aoVHDsTal+4rxAnK
        SmsXX0O2QutEZXZDGXiAZaISQpIIqv6ICBgfGVAqYXvC8TmiSD5rxaP+C+s47z0Q
        iEnuQ8BgzpbCEVb+9Hiu+FsJNhoydQnRAEt2J1xQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=8SgSt8
        Jr/5tgDmL7nQQgPMk/ZjwgaMrsp6Un67UcncM=; b=dqG+2ye8bL30+BjoA1onZS
        qrstwGtW5+0qlBh1oRojUGHKM/YQhegC2iMYhCvn753XLSlibLmvNc0ycYR3fJCE
        M8Lr1vlzMkub02YOD3NHAHIH+zJFGSzfpXzQISbwk+ZSanZnuKCOxXBoJZ+JbdYs
        S5UulPpqVt5UdQU1bTWiCXXaqKjCjoG+fRxsfn0pKJvz4wjskej3NnG8C+AId5Am
        FISUxwAC5sA4V8+i4w4SQlhnt1q9jggccuelVRsq7vB2+DMNfAv5cPWclssN9H7a
        FPPRIqOq+JhuGlRSBl6DrYkka0PRxQYmQlzPs8EwozNnjkcs74OHPZ8ORo/RLyJA
        ==
X-ME-Sender: <xms:XO8KYivle7q7o2Z_M85XwJ6_qs-fXjczIviQtVs0fYUeP08QB7lQ9w>
    <xme:XO8KYndRP4zS4NiMp_cBbeFIPRkFL6Z7u_QSzTPUr5sgustrdHA7CgYM2yo0UsXFU
    HG4Nq40e4bc-mkkBuE>
X-ME-Received: <xmr:XO8KYtzxOt3XCL_ERn1cxjeOpqd8limNe3Ada39qE0FXy7ZjgWHO_fMZCQjFcOp8BwYq1vt2RGkSZX7nOE131BiREXguIA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrjeefgddulecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvd
    ehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:XO8KYtMOGCvoSUSDRjBFsKGllTcM4uQk0_tMKqWaOUy_28ITgwa_EA>
    <xmx:XO8KYi-mV9dP-Zr8lQ1Js-AX7kU-jrku2FC5Olz9WuiFnXLzWNQVRQ>
    <xmx:XO8KYlWY2uX-55bjltwi9PbI87Ore5edpGidQclgp2N-EsXjpW12BA>
    <xmx:XO8KYkKqGSVirXPrWWJ6_UNodPWyGPGro4PGKaKUNs3aQMI_De_QIg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 14 Feb 2022 19:10:04 -0500 (EST)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v6 2/4] generic/574: corrupt btrfs merkle tree data
Date:   Mon, 14 Feb 2022 16:09:56 -0800
Message-Id: <93f40b68c7beafb546e3cda328a78b2ab088d85c.1644883592.git.boris@bur.io>
X-Mailer: git-send-email 2.34.0
In-Reply-To: <cover.1644883592.git.boris@bur.io>
References: <cover.1644883592.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
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
 common/verity     | 18 ++++++++++++++++++
 tests/generic/574 |  1 +
 2 files changed, 19 insertions(+)

diff --git a/common/verity b/common/verity
index eec8ae72..07d9d3fe 100644
--- a/common/verity
+++ b/common/verity
@@ -322,6 +322,24 @@ _fsv_scratch_corrupt_merkle_tree()
 		(( offset += ($(_get_filesize $file) + 65535) & ~65535 ))
 		_fsv_scratch_corrupt_bytes $file $offset
 		;;
+	btrfs)
+		local ino=$(stat -c '%i' $file)
+		_scratch_unmount
+		local byte=""
+		while read -n 1 byte; do
+			if [ -z $byte ]; then
+				break
+			fi
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
index 882baa21..6cb7eff6 100755
--- a/tests/generic/574
+++ b/tests/generic/574
@@ -27,6 +27,7 @@ _cleanup()
 # real QA test starts here
 _supported_fs generic
 _require_scratch_verity
+_require_fsverity_corruption
 _disable_fsverity_signatures
 
 _scratch_mkfs_verity &>> $seqres.full
-- 
2.34.0

