Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68892409C79
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Sep 2021 20:44:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240040AbhIMSqA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Sep 2021 14:46:00 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:47325 "EHLO
        out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237448AbhIMSqA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Sep 2021 14:46:00 -0400
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 648085C01D9;
        Mon, 13 Sep 2021 14:44:43 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 13 Sep 2021 14:44:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=from
        :to:subject:date:message-id:in-reply-to:references:mime-version
        :content-transfer-encoding; s=fm1; bh=ziXD2xTXrt/gW24set+fyaa8xS
        0rDn/8oGNMQ3t2B6o=; b=W278lSRk1A89zHOsx+zZy7fk4BslTYwp0/vK9AtXrE
        QxOmwRvPODAsfGDXsX7X9Y/4HJh12s+zUKmV/sHkZfU6BlDnGfaAjJp2rFx1p5wr
        eniEFs29niy7OpPZk01U+vQc33aKF5hniwdfIuNs4zZPDP5Bqe0N9fhVfaFpvpLa
        Zrd2yyi7wEaSxOzbGTEZd9xdA2j0HyyvqUBtU5JLUgKOy+3qtxN6t4I6fIYMFe2Y
        pHxhNqf5WFzETq/yTOCOo7q71tQE4v2TjMOaYLw/8fEOqLy2rQA8VoutiLFnoO/m
        sAtDmAgQWWgAypLm/H5EcZdy17iuxNAP/47YY6gpd+2Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-transfer-encoding:date:from
        :in-reply-to:message-id:mime-version:references:subject:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; bh=ziXD2xTXrt/gW24set+fyaa8xS0rDn/8oGNMQ3t2B6o=; b=Ro12T0nJ
        xmQSyou9fyZB8kz4w06yyoxwblxj18SsuVMYh/TStHtCzgqTRQhhXxy/I4lv1NlU
        Yu0P/REJab4Gt/PNGovvuBt19gYChdUtOfZD3MaOlpKjl7Ye2SCY2XJ1zHwqpYp0
        XbA5BgS+/wKsEZz1RJMYMwv/eudfysfB0XuA87RhFoWLVJh7gEVtyslv+Ea0OsXi
        URT0MJ3PbX/Km9LJS7R5i/UZh5tpTLVbDXH9OOlRzU5HZ9T6yCFnqu0aio8dmORz
        UM88kPzbuMsXlFTs1ipsB71ODxhryk8WvzDcGNuh3zd0+72h/J98LZDboGYY2OeT
        bQLYBRdzemZ+Ng==
X-ME-Sender: <xms:G5w_YRslOGoNns9SniTVNWY7UYkgVOgVNhiSPorMF6cfZm02vnlFgg>
    <xme:G5w_YacqGJJoLtquODkoB89d7bv_51Y9Qt4aL6C5JtF7zqRlnunJMyrr7OrJ5KnAn
    wlAVpgPnV-NAvcuWiE>
X-ME-Received: <xmr:G5w_YUyL8AX7Dhvi-ZEKQ5-0_TEredxLGcvqann7mJhGIfLHhJ9UXOz8VDkroiDaPWlQ5ELZChusIx_RXkwjJEwUUu_UNw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudegjedguddviecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:G5w_YYMDhTudHihnsJYAm0JEs1hzs3XY9dpaFxJGBzLWvnMVwSQN6A>
    <xmx:G5w_YR_10eu58A6s1dBBlXrMDqYHOOtMvEQ3x9SkhQIc_NLDAaGo0Q>
    <xmx:G5w_YYXUGWYXGo49YqF7YHfbVl0esRVGPBxsytXLp1LE9hPE2A5ndg>
    <xmx:G5w_YTLnlDjOGcFzbkUuQIxxFskd5S2rQfrC1FDj7s0T_ecuGD5HsQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 13 Sep 2021 14:44:42 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v5 2/4] generic/574: corrupt btrfs merkle tree data
Date:   Mon, 13 Sep 2021 11:44:35 -0700
Message-Id: <ce1febfd4247357e89bf18c15115ad08bf1870d7.1631558495.git.boris@bur.io>
X-Mailer: git-send-email 2.33.0
In-Reply-To: <cover.1631558495.git.boris@bur.io>
References: <cover.1631558495.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
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
 common/verity | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/common/verity b/common/verity
index 7eb8d9b9..74163987 100644
--- a/common/verity
+++ b/common/verity
@@ -317,6 +317,24 @@ _fsv_scratch_corrupt_merkle_tree()
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
-- 
2.33.0

