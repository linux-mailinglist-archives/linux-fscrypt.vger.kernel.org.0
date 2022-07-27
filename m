Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0EC5835CC
	for <lists+linux-fscrypt@lfdr.de>; Thu, 28 Jul 2022 01:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233061AbiG0Xt1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 27 Jul 2022 19:49:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiG0Xt1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 27 Jul 2022 19:49:27 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C5AFF5A3E2;
        Wed, 27 Jul 2022 16:49:25 -0700 (PDT)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 326765C00FB;
        Wed, 27 Jul 2022 19:49:25 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Wed, 27 Jul 2022 19:49:25 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm3; t=1658965765; x=1659052165; bh=+AeD9/fPYivTmizjOXPOejqGH
        WW8ff0iMGTf0qo3xbg=; b=K87JebS6DRCfnwGoPNP9lKgsOzT8gUpkAPFPYAVGY
        5AQyqj1Jb8urHy2oNN5gJ+C/1XrQbpdANSGLINzzw+7Ztirla4kjEAh8LjM49Q9Y
        etYWlEzOPcX/8YyuMEjDA8UT0ORNXmlCLc89fdakE5nKGRpE/QfwozGPB0rt9Q7h
        YcMYxzVV/p+VJPAo2RLwKrKvZOrdiU+5j2VMEDKnt3INnPIoGX/vnScGFPeZkvh0
        lfmnaMHALch7bhgXh6d8IOm3RNor3oYBPNoeBQY7ac4wQsjgcc55BTGOvMuobmj7
        RQhep/fH3aKvROmNNhrN1e3Unl/b4fRc7FlxQQcKDMkNQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; t=
        1658965765; x=1659052165; bh=+AeD9/fPYivTmizjOXPOejqGHWW8ff0iMGT
        f0qo3xbg=; b=QwFz6yKuxbwh+jjFdvmjbiLwSpY5p7Jip+dVoNErdfbvaiSHePc
        u9sZn3M9b2HbCehQsfJUFVzpcazBw1rejag4RhLVG0/eSGgcG0jS0yaGpRLSlEBS
        ry+1dbqW2FRJFiyU6gWWBcjaQaC25q++1XG3OolakuyJyBomWP5yEyvQuJUa0D4k
        Q/kH9kFAlj17JeQVqTUXMGtWwIgCtU+KsLpRBmZSWsr3GS0L7yhOBkD4/Kz9R2Na
        zpi62WzKAR/NMcvc/gEcjwPtuJpcAoCuMMqrnhyNdMaMV0nXWmerxL1rs4ucSYPy
        24WJn/MW5q9PsxZgSSlDNBGOb2xFLI87zlg==
X-ME-Sender: <xms:Bc_hYtAV9ILNCW5JHPLPlZUm_hiZ2MYHfTZqB0Q8edmPFp5W1DXwUg>
    <xme:Bc_hYrhFPNGqR3NxgVwcZXi7GUSRXz-jE3zRVhPWXiYrEhpXZM0kxRktfkFbvXBag
    tqBBk9d4XmLioEO6Ss>
X-ME-Received: <xmr:Bc_hYolXTQqYVinX45q95g4k2Yx4RRLQrea_RYePOa7umVBg_lAAq2vNkaNkCFS-wZEmTtTxBqKYviO8sVPXc8hmq8Tb_Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvddufedgvdehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeetveevteejffevffeuuedvgeffheelgfeiudekgeegte
    ehteetgeeljeehveevueenucffohhmrghinhepfhhsvhdrshhsnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:Bc_hYnzHwqThksOJ5jmhEsphISJF_f8McyP9P95xKciwD6XTjekiTg>
    <xmx:Bc_hYiQcvNCbbT_6xBdLpJpyLuaLhdFDcwrPpBATL1drauF48mxVBA>
    <xmx:Bc_hYqbvdou9lN_ndogivyO8An00slhLpK4QaYA4EOk9ZS9VDk-Btg>
    <xmx:Bc_hYlLGRCvGw7T7Qi8KZCKJxW9xuYuJnCEcNuM4TSxxwV4qzDaa6w>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 27 Jul 2022 19:49:24 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: [PATCH] fstests: add btrfs fs-verity send/recv test
Date:   Wed, 27 Jul 2022 16:49:35 -0700
Message-Id: <9e0ee6345a406765cf06594b805cb3568de16acc.1658965730.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
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

