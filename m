Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7399F595191
	for <lists+linux-fscrypt@lfdr.de>; Tue, 16 Aug 2022 07:01:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232268AbiHPFBt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 16 Aug 2022 01:01:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234638AbiHPFBQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 16 Aug 2022 01:01:16 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E739F2D1C4;
        Mon, 15 Aug 2022 13:56:33 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id 0BC94320092F;
        Mon, 15 Aug 2022 16:56:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 15 Aug 2022 16:56:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1660596992; x=1660683392; bh=+AeD9/fPYivTmizjOXPOejqGH
        WW8ff0iMGTf0qo3xbg=; b=LnLoBjXTv73gO/AgbpxLhsB/tws9nUaBqNXsYRMKa
        Nd9Wf8i8cg6H1w3kQtI3FabKiCUek5u5g1legD8LFdwyMh3i5vTx2vVtLfM/SSOI
        nYns23MtHl122i45AogXhyoSp0xTIHamNEdNCaR1lA1QoMHVMiopWFWSO5657Fbi
        G60mrG/mfsaz3cV0s+LjBUZivnwv/vpYagglGhy0N78uGGENZlRdmO98uoSHX6GK
        /Us9itCJ1qP/gCnkLetkqdTQmFXDScsgZ43vnjsczUW8krpeYzs5RY7RO66Y9ylR
        W1hMlekC7afNuyX7I6UsX1vD4ULMXUIiz+PgF3cJHUXRQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1660596992; x=1660683392; bh=+AeD9/fPYivTmizjOXPOejqGHWW8ff0iMGT
        f0qo3xbg=; b=t47c2ynB+zqehYQH1ivXn2hg4NdS/Pq/E2wxbW3Vy199FxbD2LW
        lD9utXB6d1pBZRUleZfYhdawRPAXNXm3+OvDWlNhILsLNvkgg4PBX71/dowSpEqh
        cYAdy7oZXCYCN2TvAmxc2571wGyn5Q/kiuNhOVJ/8S+9ATs+HiNUprPKveua44tX
        2EhjNjILzyNere8ynCg0LEkhy///JaasgyMJX6VDVDtknsvMl5shEKdV8Wi3DXyp
        jZhPTjcsHZvz0+lRfQnAtonlucIdzCys6W+B43TAPtV9cukRnB+n2ws1SDawo1k2
        PirQKSTHqf1Mz1ZCMJf2u57VabS7VS4mcdQ==
X-ME-Sender: <xms:ALP6YmFMbHOJyvP0qjuehHJyCoA3kLjh9_VaNGTd_bQRnQKbEi3KSA>
    <xme:ALP6YnXHHUGIa_QiTFFO4MmiK_H2doWVy3aFFoFW8dCUYb355nAiNavunVtILP4KS
    aGroPhWWVYfzrpObek>
X-ME-Received: <xmr:ALP6YgJjHci73xEaC4TLfDWMQy_vOInejwYEeuPlm6geMVMAnmP77LI8WPvD9i-lt5en-CdAMllZDSp6RDvz5XGSjZ5Rdg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehvddgudehjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvvefufffkofgggfestdekre
    dtredttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdr
    ihhoqeenucggtffrrghtthgvrhhnpeejkeffleevudfgudffleffgeeludevvdekleefue
    fgjeehudduhffhlefhuefhtdenucffohhmrghinhepfhhsvhdrshhsnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessghurhdrih
    ho
X-ME-Proxy: <xmx:ALP6YgFgMuJiECEFzIwv70XXc9aJpabk897e_MhN_jkaUr_agrgRdg>
    <xmx:ALP6YsWK4yxudbOB0YTQmhPaQnuhPFmwhMCKccLqZOZnHz9E9w4dYw>
    <xmx:ALP6YjOwEdBfNIApexejGfgvY6eJmTF_eMDPP-yEFBGEOgMEJvvtEw>
    <xmx:ALP6YphLyUIjYCY--D0uFKgcu5atMCbM0LPv6LjdbldiVTz_Ma6wug>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 15 Aug 2022 16:56:32 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org
Cc:     kernel-team@fb.com, linux-fscrypt@vger.kernel.org
Subject: [PATCH] fstests: add btrfs fs-verity send/recv test
Date:   Mon, 15 Aug 2022 13:57:56 -0700
Message-Id: <9e0ee6345a406765cf06594b805cb3568de16acc.1660596985.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Test btrfs send/recv support for fs-verity. Includes tests for
signatures, salts, and interaction with chmod/caps. The last of those is
to ensure the various features that go in during inode_finalize interact
properly.

This depends on the kernel patch adding support for send:
btrfs: send: add support for fs-verity

And the btrfs-progs patch adding support for recv:
btrfs-progs: receive: add support for fs-verity

Signed-off-by: Boris Burkov <boris@bur.io>
---
 tests/btrfs/271     | 114 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/271.out |  59 +++++++++++++++++++++++
 2 files changed, 173 insertions(+)
 create mode 100755 tests/btrfs/271
 create mode 100644 tests/btrfs/271.out

diff --git a/tests/btrfs/271 b/tests/btrfs/271
new file mode 100755
index 00000000..93b34540
--- /dev/null
+++ b/tests/btrfs/271
@@ -0,0 +1,114 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 YOUR NAME HERE.  All Rights Reserved.
+#
+# FS QA Test 271
+#
+# Test sendstreams involving fs-verity enabled files
+#
+. ./common/preamble
+_begin_fstest auto quick verity send
+
+# Override the default cleanup function.
+_cleanup()
+{
+	cd /
+	_restore_fsverity_signatures
+	rm -r -f $tmp.*
+}
+
+# Import common functions.
+. ./common/filter
+. ./common/verity
+
+# real QA test starts here
+
+# Modify as appropriate.
+_supported_fs btrfs
+_require_scratch_verity
+_require_fsverity_builtin_signatures
+_require_command "$SETCAP_PROG" setcap
+_require_command "$GETCAP_PROG" getcap
+_require_test
+
+subv=$SCRATCH_MNT/subv
+fsv_file=$subv/file.fsv
+keyfile=$tmp.key.pem
+certfile=$tmp.cert.pem
+certfileder=$tmp.cert.der
+sigfile=$tmp.sig
+stream=$tmp.fsv.ss
+
+_test_send_verity() {
+	local sig=$1
+	local salt=$2
+	local extra_args=""
+
+	_scratch_mkfs >> $seqres.full
+	_scratch_mount
+	echo -e "\nverity send/recv test: sig: $sig salt: $salt"
+	_disable_fsverity_signatures
+
+	echo "create subvolume"
+	$BTRFS_UTIL_PROG subv create $subv >> $seqres.full
+	echo "create file"
+	$XFS_IO_PROG -fc "pwrite -q -S 0x58 0 12288" $fsv_file
+	if [ $salt -eq 1 ]; then
+		extra_args+=" --salt=deadbeef"
+	fi
+	if [ $sig -eq 1 ]; then
+		echo "generate keys and cert"
+		_fsv_generate_cert $keyfile $certfile $certfileder
+		echo "clear keyring"
+		_fsv_clear_keyring
+		echo "load cert into keyring"
+		_fsv_load_cert $certfileder
+		echo "require signatures"
+		_enable_fsverity_signatures
+		echo "sign file digest"
+		_fsv_sign $fsv_file $sigfile --key=$keyfile --cert=$certfile \
+			$extra_args | _filter_scratch >> $seqres.full
+		extra_args+=" --signature=$sigfile"
+	fi
+	echo "enable verity"
+	_fsv_enable $fsv_file $extra_args
+	_fsv_measure $fsv_file > $tmp.digest-before
+
+	# ensure send plays nice with other properties that are set when
+	# finishing the file during send, like chmod and capabilities.
+	echo "modify other properties"
+	chmod a+x $fsv_file
+	$SETCAP_PROG "cap_sys_ptrace+ep cap_sys_nice+ep" $fsv_file
+	$GETCAP_PROG $fsv_file > $tmp.cap-before
+
+	echo "set subvolume read only"
+	$BTRFS_UTIL_PROG property set $subv ro true
+	echo "send subvolume"
+	$BTRFS_UTIL_PROG send $subv -f $stream -q >> $seqres.full
+
+	echo "blow away fs"
+	_scratch_unmount
+	_scratch_mkfs >> $seqres.full
+	_scratch_mount
+
+	echo "receive sendstream"
+	$BTRFS_UTIL_PROG receive $SCRATCH_MNT -f $stream -q >> $seqres.full
+
+	echo "check received subvolume..."
+	echo 3 > /proc/sys/vm/drop_caches
+	_fsv_measure $fsv_file > $tmp.digest-after
+	$GETCAP_PROG $fsv_file > $tmp.cap-after
+	diff $tmp.digest-before $tmp.digest-after
+	diff $tmp.cap-before $tmp.cap-after
+	_scratch_unmount
+	echo OK
+}
+
+_test_send_verity 0 0
+_test_send_verity 0 1
+_test_send_verity 1 0
+_test_send_verity 1 1
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/271.out b/tests/btrfs/271.out
new file mode 100644
index 00000000..9a484404
--- /dev/null
+++ b/tests/btrfs/271.out
@@ -0,0 +1,59 @@
+QA output created by 271
+
+verity send/recv test: sig: 0 salt: 0
+create subvolume
+create file
+enable verity
+modify other properties
+set subvolume read only
+send subvolume
+blow away fs
+receive sendstream
+check received subvolume...
+OK
+
+verity send/recv test: sig: 0 salt: 1
+create subvolume
+create file
+enable verity
+modify other properties
+set subvolume read only
+send subvolume
+blow away fs
+receive sendstream
+check received subvolume...
+OK
+
+verity send/recv test: sig: 1 salt: 0
+create subvolume
+create file
+generate keys and cert
+clear keyring
+load cert into keyring
+require signatures
+sign file digest
+enable verity
+modify other properties
+set subvolume read only
+send subvolume
+blow away fs
+receive sendstream
+check received subvolume...
+OK
+
+verity send/recv test: sig: 1 salt: 1
+create subvolume
+create file
+generate keys and cert
+clear keyring
+load cert into keyring
+require signatures
+sign file digest
+enable verity
+modify other properties
+set subvolume read only
+send subvolume
+blow away fs
+receive sendstream
+check received subvolume...
+OK
-- 
2.37.1

