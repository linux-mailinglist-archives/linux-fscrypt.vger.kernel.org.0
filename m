Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1D2459A688
	for <lists+linux-fscrypt@lfdr.de>; Fri, 19 Aug 2022 21:40:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349523AbiHSTeN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 19 Aug 2022 15:34:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34116 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349969AbiHSTeM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 19 Aug 2022 15:34:12 -0400
Received: from wout1-smtp.messagingengine.com (wout1-smtp.messagingengine.com [64.147.123.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5AC6DBD137;
        Fri, 19 Aug 2022 12:34:10 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.west.internal (Postfix) with ESMTP id 90895320090B;
        Fri, 19 Aug 2022 15:34:08 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Fri, 19 Aug 2022 15:34:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1660937648; x=1661024048; bh=KOogtIxNy7p+8f7xZ1U+CpQiV
        L2RpO9fzrnDJ36KbZk=; b=2J2+ozCrvwp0hdtnh+TA16F9c6uNal00ziJL6pyAC
        6TsQDqOH67f8Je6nARDNmMANBcWzS8LwobXfnPnZKGwYQ0t43sZZehlEobPwKa+V
        TszVJHN6C70+VelGRMOdFZ0Jr+1xYZkJZ17ODK47JURKcEBFnH4EglAIEhj44NSu
        qXFIlgWuibO+A+jsbOYGd/OTxx5Sw/wYSIfWBDB/g11VXAkKhjymQltwXZbkIcor
        Ez5GEdmxSvyW3hVYtVQ3Pve+jpqteQQs/tA0sMJO8voQAGqYZVUK0sM66iVKN31W
        5nXLecoCFXGak2G1k+4ymYN3EBXOl7USbXN7buTVT9TWg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1660937648; x=1661024048; bh=KOogtIxNy7p+8f7xZ1U+CpQiVL2RpO9fzrn
        DJ36KbZk=; b=O4rEiF7gEAsrACDZJfSJQmFke4K1bae5Ymymj6OQY1CuCrq3Gf/
        XuPdVnk7DwOHicDzNq1ufYM3bnTg+XKo92xah5Ncgh8XnJGVMqC/RH2jYXnNGfKd
        OdTF4yFBFgzkmMDK+VAS6FdCARIm/dXUT43Rk3sPl+nh36aJAckjEWKpmCSrGcH2
        V4TXmfcsvXduHMghUrH7QXBiNaUZEm/hstQHEYwXsSbQgilpSvVEmruR8wArcE9R
        wPMUrKetDKZ16GTWhZrkU/xPfyo+lvWLar4jwscNwyx8lTB6FTe+3lbBnWbR+37w
        udXGc9Y/2/wFG6uLahPjkO3YDYxr+B9icIg==
X-ME-Sender: <xms:r-X_YvYGRgQ_PHcQ6r2FVS3yQoz99xWzp6Geo8n-iIdI6JvJF2YmOw>
    <xme:r-X_YuYW0MKe3CQ9fjU4T6svs2xsWvpq9POyjO9UWAck9T4S77iCUzFID7_YTv1wF
    HM-i3FFu5JdaQL1fGc>
X-ME-Received: <xmr:r-X_Yh-8lG5doXjUEENZf_Pvj8l348k1Eja7FpwD7EFLWskGS7O1LJQczSxzMymU21UEeaLNj3uXY9ALoUbSc--ZocZL8w>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeiuddgudegudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffoggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepteevveetjeffveffueeuvdegffehlefgiedukeegge
    etheetteegleejheevveeunecuffhomhgrihhnpehfshhvrdhsshenucevlhhushhtvghr
    ufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:r-X_Ylpfz0kKGba7cpl8sqVSq-BvsegI98xq-i8zemIB1dxqWuQMYw>
    <xmx:r-X_Yqo5Mux3wMTIsRXVfyXYzWR9Y12pTkp4ba14rTYXzAUps1q-6A>
    <xmx:r-X_YrTlz8aVJzAdx_nRQCtiN25OXknDWs0zs3cca6ot0puUsfdkTA>
    <xmx:sOX_YvA7TRkglb0Mjg1LOXg4rlGED9pZ18hir5WTb0xICj__FlvHnw>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 19 Aug 2022 15:34:07 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH v4] fstests: add btrfs fs-verity send/recv test
Date:   Fri, 19 Aug 2022 12:34:05 -0700
Message-Id: <c46544a9bd65f22debac5dfff0a624e3b4996ca6.1660937484.git.boris@bur.io>
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
Changes for v4:
- btrfs subv -> btrfs subvolume
Changes for v3:
- commit a few things from v2 that I left unstaged (277 in output,
  true/false)
Changes for v2:
- btrfs/271 -> btrfs/277
- YOUR NAME HERE -> Meta
- change 0/1 to false/true
- change drop caches to cycle mount
- get rid of unneeded _require_test
- compare file contents


 tests/btrfs/277     | 115 ++++++++++++++++++++++++++++++++++++++++++++
 tests/btrfs/277.out |  59 +++++++++++++++++++++++
 2 files changed, 174 insertions(+)
 create mode 100755 tests/btrfs/277
 create mode 100644 tests/btrfs/277.out

diff --git a/tests/btrfs/277 b/tests/btrfs/277
new file mode 100755
index 00000000..f5684fde
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
+	$BTRFS_UTIL_PROG subvolume create $subv >> $seqres.full
+	echo "create file"
+	$XFS_IO_PROG -fc "pwrite -q -S 0x58 0 12288" $fsv_file
+	if $salt; then
+		extra_args+=" --salt=deadbeef"
+	fi
+	if $sig; then
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
+_test_send_verity false false # no sig; no salt
+_test_send_verity false true # no sig; salt
+_test_send_verity true false # sig; no salt
+_test_send_verity true true # sig; salt
+
+# success, all done
+status=0
+exit
diff --git a/tests/btrfs/277.out b/tests/btrfs/277.out
new file mode 100644
index 00000000..5f778cf4
--- /dev/null
+++ b/tests/btrfs/277.out
@@ -0,0 +1,59 @@
+QA output created by 277
+
+verity send/recv test: sig: false salt: false
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
+verity send/recv test: sig: false salt: true
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
+verity send/recv test: sig: true salt: false
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
+verity send/recv test: sig: true salt: true
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

