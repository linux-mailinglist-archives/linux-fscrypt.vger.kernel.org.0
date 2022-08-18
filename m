Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FB17599056
	for <lists+linux-fscrypt@lfdr.de>; Fri, 19 Aug 2022 00:17:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239230AbiHRWQg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 18 Aug 2022 18:16:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240340AbiHRWQf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 18 Aug 2022 18:16:35 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9879CD7CEF;
        Thu, 18 Aug 2022 15:16:33 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id BEA4A5C0299;
        Thu, 18 Aug 2022 18:16:32 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Thu, 18 Aug 2022 18:16:32 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :message-id:mime-version:reply-to:sender:subject:subject:to:to;
         s=fm1; t=1660860992; x=1660947392; bh=9GARbCTRN0P3/0gYljgsUKifz
        Jc7JGfutu8+kijaJdI=; b=L5dSaKYkdBh0nOAwkULneNKhwlKZcd2e5okfIVIi9
        QiR5Gz2SMfVTPEEGWedzJ99hsAORYFLMzIqhgllyRngOZ2fB3kzlz0T5khU9y4UW
        K30TpuUJHOMOhoUv4lRYDB0JJ0htpqSWXAFYwWDHDW09AyXAovDWEXSUOc8W7Z+9
        6+fDDB0vGpsSf4g0usH4zXAanjaTcWih+RB+zEKIBLrMc6mV/vHSwovB5tkgcXoj
        X19JpLKCsKu98gX2951bfsj+p+dnjG6dqLx1n8NPXG+roAAKAK8O5UfUu/Tunmi8
        UWsJp6L3KMXC+FkgOvrtkKIxveDoebz8/lvYMrr8e90Ow==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:message-id
        :mime-version:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1660860992; x=1660947392; bh=9GARbCTRN0P3/0gYljgsUKifzJc7JGfutu8
        +kijaJdI=; b=v3XocNiH6QjRqwgqvXj7WI6LDfgKrRKQ9FikYZe3YuX3CnPRXRW
        Y10n8cNcDSzsjhJyNafdZSkp7PPX/D8tF6vCFczkCKdiygmMbQr8h3nYjzNbevmM
        G2qWDA6COGzAnlSzHZNu18Re49YNyDpB0dLvDeXLsbL8gmjzlpJRfBxZrXdBBKMe
        +JbfQ+rIIplSWXBEvrZNcQeKI/sAXmP+e1gvoxwJhEiWphPCt9uC061+Z/ept4tQ
        oi8oK41b7sZ8pLjiisluLZGnyEaSVS6RLKvdytIBF++G9p322mQpZSxA3bhkJNRK
        G16TrfSVJbFBJ8jzH7fhLrfoASBHsfKN7NQ==
X-ME-Sender: <xms:QLr-YgR1HEB9Wn8HIxnh4JqlgBOYJ4JwJdRgyFzWlHu9qdlSvMOiww>
    <xme:QLr-YtyG5XzxK8a165pdFehy-ogHnN-HK35v1rpvkwInf53IJLdk4AiYNwZrCcA_p
    jSZiFchCEaYj9dAPVQ>
X-ME-Received: <xmr:QLr-Yt1rFHfZDDPFQuep6hPvxu8h96uHQA94mdR2Ok7Fbzrbko9ASMB86X5GrY0WLsUYE1XG0vNBFa35MwKi2nbGQ77sAg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrvdeitddgtdejucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgggfestdekredtre
    dttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdrihho
    qeenucggtffrrghtthgvrhhnpeetveevteejffevffeuuedvgeffheelgfeiudekgeegte
    ehteetgeeljeehveevueenucffohhmrghinhepfhhsvhdrshhsnecuvehluhhsthgvrhfu
    ihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:QLr-YkDnOWeMbO2KCD6d87pfV_rYtoVkN2yDcuhloRlM-FCaSTca-A>
    <xmx:QLr-Ypi6ruRHFI2_-48rrTf3WGlYI4Psl2vVAl7Z-62E2iRAT41byQ>
    <xmx:QLr-YgqfEK_i94LrTzx1Htvi71H5cP4IV5dduRAA9-kkZ101lQvV9w>
    <xmx:QLr-YpaarozAvBVXOvA3EqZOhHLwfzdaI9E-6W0OmUvFF_Qn3-rMHA>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Thu,
 18 Aug 2022 18:16:32 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        fstests@vger.kernel.org
Subject: [PATCH v3] fstests: add btrfs fs-verity send/recv test
Date:   Thu, 18 Aug 2022 15:16:30 -0700
Message-Id: <e1e77ce5d7277b235e48adc8daf00a0dc0ae36e9.1660860807.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
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
index 00000000..251e2818
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

