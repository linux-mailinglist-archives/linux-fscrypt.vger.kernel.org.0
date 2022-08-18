Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17D23598CD6
	for <lists+linux-fscrypt@lfdr.de>; Thu, 18 Aug 2022 21:48:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343788AbiHRTsD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 18 Aug 2022 15:48:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241954AbiHRTsD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 18 Aug 2022 15:48:03 -0400
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9BFC56110E;
        Thu, 18 Aug 2022 12:48:01 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 0AF215C0306;
        Thu, 18 Aug 2022 15:48:01 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Thu, 18 Aug 2022 15:48:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1660852081; x=1660938481; bh=Oq2a05cIug/Xr9SlMAsKp39QM
        fY2FI66HWHMaeR532g=; b=bDH2TsNS1rwcMd6RDL9Bmox4/vUuIJbEwsPAtpGfH
        e4YqEv6rsHlUPYGF6H1LgVwpal+Z9WmxhhPQkBtqbTzn6ZQBbUegoAqu119Wn8lt
        5N2MS4UzIDmMAqLiI7NeJb+hlkEQ1JB9WxMhzRoGgU37OS5cHKS26A/K6cgDj84Y
        e5hrKDwlCSBmsQwJ6aR+/DcdgcguQ+Gu5RkYmozksKg3JgBgVIuGZ1Aidpvg/BEK
        F+X+uz+hA+9V53eSnjvYxOXGqnmJQ+kXmOqisWBUbPA/rZSQH2fxYRc5/Oh2ZfQl
        z8COAV8kpzJqtncgdzk1floEDI1ICx0zoEsuEDVhhy0nw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1660852081; x=1660938481; bh=Oq2a05cIug/Xr9SlMAsKp39QMfY2FI66HWH
        MaeR532g=; b=q3JKoQRE3/X0j2y6Bp7aH9Gd+XeZUImTUUPYJ4kYRqowh821ZMG
        ghapwgoe51nmLCzj6sXcCOarC36pef5mAN3QzvSfq2f0xdBAGDVRBEvf2hTRIauK
        nxmIIRK4GnMayTJvzm/ETfS1DjQVbfCB+WX7tzMQqLHyzUfUD0WOQTvwu9HiuZpD
        PS+XYIl0MLCUNDqaxwQPZyrVqHx1kovNTwsqtX14AdLSdoBIuNOoTXmoJJMFtJHM
        8eYaXeAhcH2rn614auoTBI4H/vvflAputbNUzDEPZYMa1VwymDnQQDHnuii91HeL
        KjUXdGZ6zEH21YF6eSjkur5qXs7XCCh4f/A==
X-ME-Sender: <xms:cJf-Ymp7xncxzXLZfRpRjLbBhHkjzdK8qwhHQh1ZDth0p2K70xxyvw>
    <xme:cJf-YkrkEUwes7g9RrLoHkuvy3FCHDc7l4s1p0aHo1hIBxZxWO0IL4dYWrDKWHI_0
    eyrhfv_HxH1_Fc1PfA>
X-ME-Received: <xmr:cJf-YrMHUQ6dfMowtmxf5IZRr9MJL-fIpM4-PArUyWTgOb_2-toKuvYJ33T3nWj_1FM32XsOn3-_wFRRUAw1x2aHeOCRxg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdehledgudduhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepteevveetjeffveffueeuvdegffehlefgiedukeegge
    etheetteegleejheevveeunecuffhomhgrihhnpehfshhvrdhsshenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:cJf-Yl6FUn3k309_itcSNS6BrmLyv8c9uLbzEXZBHZ7FnrAppesyxQ>
    <xmx:cJf-Yl4B4TLnfWOZTn29iaHtpk3A_FRbAjAMIkoIifukEbcFtK8S0w>
    <xmx:cJf-YlillhjjcTGqz60_85bBdKVRIQTt3YbnHrXd3jF9KFXpwvi9Eg>
    <xmx:cZf-YnSeZSxAq_MccpHRZLoH0LqXpoEvqxP2iy9UEuNHZzp1FflaKA>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Aug 2022 15:48:00 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH v2] fstests: add btrfs fs-verity send/recv test
Date:   Thu, 18 Aug 2022 12:47:59 -0700
Message-Id: <e2a327a5ac21cfd532b0ae5c936171dc178308ec.1660851850.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
--
Changes for v2:
- btrfs/271 -> btrfs/277
- YOUR NAME HERE -> Meta
- change 0/1 to false/true
- change drop caches to cycle mount
- get rid of unneeded _require_test
- compare file contents
---
 tests/btrfs/277     | 115 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/277.out |  59 +++++++++++++++++++++++
 2 files changed, 174 insertions(+)
 create mode 100755 tests/btrfs/277
 create mode 100644 tests/btrfs/277.out

diff --git a/tests/btrfs/277 b/tests/btrfs/277
new file mode 100755
index 00000000..5325ad94
--- /dev/null
+++ b/tests/btrfs/277
@@ -0,0 +1,115 @@
+#! /bin/bash
+# SPDX-License-Identifier: GPL-2.0
+# Copyright (c) 2022 Meta, Inc.  All Rights Reserved.
+#
+# FS QA Test 277
+#
+# Test sendstreams involving fs-verity enabled files.
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
+	cat $fsv_file > $tmp.file-before
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
+	_scratch_cycle_mount
+	_fsv_measure $fsv_file > $tmp.digest-after
+	$GETCAP_PROG $fsv_file > $tmp.cap-after
+	diff $tmp.file-before $fsv_file
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
diff --git a/tests/btrfs/277.out b/tests/btrfs/277.out
new file mode 100644
index 00000000..9a484404
--- /dev/null
+++ b/tests/btrfs/277.out
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

