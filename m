Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 402D34DB94F
	for <lists+linux-fscrypt@lfdr.de>; Wed, 16 Mar 2022 21:25:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1357839AbiCPU0g (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Mar 2022 16:26:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355277AbiCPU0f (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Mar 2022 16:26:35 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E25049F03;
        Wed, 16 Mar 2022 13:25:21 -0700 (PDT)
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.west.internal (Postfix) with ESMTP id 680E63200F72;
        Wed, 16 Mar 2022 16:25:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 16 Mar 2022 16:25:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; bh=H3G5YtAB6Bqou+RsqKNPGk9Mkuq70b
        N4JJ3uf9liuXQ=; b=uv+e2mfAe+uyJQZHDigx9K/oLxRYZw8oKOC8sA4U2E9pYl
        AF/qlc245i/vB0umPauxTdpRU5qpYXNdTQClh+ZAS3E5hbI2wzmwkJBGERIOWocK
        eYTyAq5vhtnBTupP8lwPrMjaA/+wZiBCEfvNXFrqxtrJ8JasCtUzYUHjsx4LYPKy
        SfNO11moevT0SsNersu3x85uUt2UCe/97699GjLSkHP78GdIE+Ywv1U2qcejd6C+
        YgR7kiydP9Xu7J4/4vb52dvr+va98lhskm/HKonnX3minN7U+pOgnmDQg9jyIua2
        Ym4DMcs/zwof7vAmof2QkWE+U9IB/oGHTEW0IE5g==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=H3G5Yt
        AB6Bqou+RsqKNPGk9Mkuq70bN4JJ3uf9liuXQ=; b=gkkFtJcTWw/1hoTPNsKVJk
        WjxEEmEyhhhkJjGFaPlif9tXve7PvTKnfLc5lUKRP35gdpbG9pJS32/HrLTV+7Jj
        o7P7s/htgCclyR3/zDthq+uTQuNunIRoPbAnvzywOpSIdpXnBzgtFrppyKAFxJy5
        BkvxmgQQXBccqdRMYtmkGuonwXsQ3kQeLWCKJJwq81YynbdSKv7LOqnhSnhL448Y
        buYVrn32izIdh1edaLzY8Fjlx29OlWlEVxHXSsO1Rrz1Yh+eo0oPkykyBEqzukZ1
        c2u9qDJX17xVoWrxDSYwqWeh1qVXxjsL/82we/l9IKsyw+/nL0hctpTLjqBTHfOw
        ==
X-ME-Sender: <xms:r0cyYgBHXjY38DLT7nOdHLxrGUMejZamtZMATJTCPTOpzWetMN4bmw>
    <xme:r0cyYihX5JV88yhGbYc_i-RvxNBnrMhhyAVO6_OpUksScp7-YH9ojqx-PeKnqlK7h
    MKHFpr7H-CUYX9Qv4g>
X-ME-Received: <xmr:r0cyYjlkx_gW5rVlLn4UZJ8w2Sal47CSxSiby2m7sdGypYL0xDXRqPzGujThahagwO0VMGihktm0C_faXokFx7_4ma9sWQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudefvddgudeffecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:r0cyYmxOYCglqiCSIddnwIMn1gLMAnZaqvzuIGGmtUNLobpxoHMmfQ>
    <xmx:r0cyYlQwSufdAewNV9WOoM5M_qbudAERkmVX5Po3YYMFBenuW2MJvA>
    <xmx:r0cyYhaoWAikD7kQA4FKdxnUCRfp_awjaEGWBDSThyT8NT7SLo7Dtg>
    <xmx:r0cyYgd0g8lCE9F4AG4tX4MeiBKtReIguw_JbgQhPTeAttnJjDpkHQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 16 Mar 2022 16:25:19 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v8 1/5] common/verity: require corruption functionality
Date:   Wed, 16 Mar 2022 13:25:11 -0700
Message-Id: <c142dce513191c0097989e5752a57515246e0de9.1647461985.git.boris@bur.io>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647461985.git.boris@bur.io>
References: <cover.1647461985.git.boris@bur.io>
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

Corrupting ext4 and f2fs relies on xfs_io fiemap. Btrfs corruption
testing will rely on a btrfs specific corruption utility. Add the
ability to require corruption functionality to make this properly
modular. To start, just check for fiemap, as that is needed
universally for _fsv_scratch_corrupt_bytes.

Signed-off-by: Boris Burkov <boris@bur.io>
---
 common/verity     | 6 ++++++
 tests/generic/574 | 1 +
 tests/generic/576 | 1 +
 3 files changed, 8 insertions(+)

diff --git a/common/verity b/common/verity
index 38eea157..d58cad90 100644
--- a/common/verity
+++ b/common/verity
@@ -141,6 +141,12 @@ _require_fsverity_dump_metadata()
 	_fail "Unexpected output from 'fsverity dump_metadata': $(<"$tmpfile")"
 }
 
+# Check for userspace tools needed to corrupt verity data or metadata.
+_require_fsverity_corruption()
+{
+	_require_xfs_io_command "fiemap"
+}
+
 _scratch_mkfs_verity()
 {
 	case $FSTYP in
diff --git a/tests/generic/574 b/tests/generic/574
index 882baa21..17fdea52 100755
--- a/tests/generic/574
+++ b/tests/generic/574
@@ -28,6 +28,7 @@ _cleanup()
 _supported_fs generic
 _require_scratch_verity
 _disable_fsverity_signatures
+_require_fsverity_corruption
 
 _scratch_mkfs_verity &>> $seqres.full
 _scratch_mount
diff --git a/tests/generic/576 b/tests/generic/576
index 82fbdd71..d3e0a2d6 100755
--- a/tests/generic/576
+++ b/tests/generic/576
@@ -28,6 +28,7 @@ _supported_fs generic
 _require_scratch_verity
 _require_scratch_encryption
 _require_command "$KEYCTL_PROG" keyctl
+_require_fsverity_corruption
 _disable_fsverity_signatures
 
 _scratch_mkfs_encrypted_verity &>> $seqres.full
-- 
2.31.0

