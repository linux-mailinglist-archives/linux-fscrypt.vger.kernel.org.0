Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 278BD57AB23
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 Jul 2022 02:50:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232455AbiGTAt7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 Jul 2022 20:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiGTAt6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 Jul 2022 20:49:58 -0400
Received: from wout5-smtp.messagingengine.com (wout5-smtp.messagingengine.com [64.147.123.21])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9E28E61B3D;
        Tue, 19 Jul 2022 17:49:57 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id ABCEA3200681;
        Tue, 19 Jul 2022 20:49:56 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Tue, 19 Jul 2022 20:49:57 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1658278196; x=1658364596; bh=ic
        szR0M7gLuJJF10HMx7zt0pqzTzn9tc7/VnThZs7uA=; b=a4Q5OD4O4BGwky5JDZ
        AeUJCYRhnfAyCzDHFgZxlFiUN0mYWPpbCLmbva2jyf4wyQdmUvanVWdW485hZ6wj
        P6yGMzT+qIS1DAbWbn1+aXno6sl2btUgmOZAh4i26z+miyo0r0gl1peaTKppZhaB
        51EJhltfdr9+ViwjO3+ITQ2sk6AoY7+kY4KVGPiq5LNmpbXmZgqPnBmTQDj7LhCx
        yDttvV3rcXyPtWrlsv/NDZxUtIWuao17QkmEWNYLNI2Z8Nlp6prPwKfTAIQsEVWU
        JbOZqFObEv14BiD+974OYZro7DIggw5OupyFvK05Nlfsliw2+euy2J3WQXB4xNtj
        heyg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658278196; x=1658364596; bh=icszR0M7gLuJJ
        F10HMx7zt0pqzTzn9tc7/VnThZs7uA=; b=WS6qr9KLsWReMzahF9uE8hc/uGcIf
        IpghUM0iKlXzouip5hC7R6WlEs1Un2ujcruCHwqHvsmfkkOOAxaGzwSsMHCtuGgF
        qob10Cxa+qj+6eUJF2DDxNbqgtxFHdXRBtEA2ZgT2b6D3/b+XyF9ZYRI3fJq6IGA
        icw22eknp417Desk8JUhGIH+bzywx4sgNfh71eZ9aRUEFSG4ItVVe5MXVlPEjVGN
        4KG1paKPHOvD0GOx6DON5/XDfPGflPoMDkTHvrtetpBL/56VvE3NdhsHA0YDoBA4
        yBPLt/4Q+a+qWXwLKJ0w3dUdg2HPUoqOiDAJhHiYsf47MUIzfHaVi4kbA==
X-ME-Sender: <xms:NFHXYj8HnzRSspVcCcWzVWMHp73DnEKRYwSLoc7osioIm52QPpMI-w>
    <xme:NFHXYvvLQuDz6TpfNQsRaS5CC6w-mXP7JZmgi9Z6ZswCdiXTKb_YmqDd3O-3Ud9hw
    sgNDYYzF0srxQ3NfPg>
X-ME-Received: <xmr:NFHXYhC0eCyQBe_2ct479fnUEZ9B0E7Y0kQvs1UgmlWm4M0_N11xpVVMMAOxcrOzuv6gJT74m_vXhxie2Fo9PDGF-nxLqw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeluddgfeelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdr
    ihhoqeenucggtffrrghtthgvrhhnpeeiueffuedvieeujefhheeigfekvedujeejjeffve
    dvhedtudefiefhkeegueehleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:NFHXYvd2zoRmXj9Fks9CnYAknBp9MqQcL2IrZ02-VZBOy7gNHcSRYg>
    <xmx:NFHXYoNVwiTnQxQ-Y9iIT9mYztG_95a-qQYDURTbHMLm_bNQdYoVfQ>
    <xmx:NFHXYhm3PC-hhFcfXriL5uHL8AToVlFDJM5TQvZlmNWs0FFA2JKHGg>
    <xmx:NFHXYhZw4-XICd9D-YAqKHbH-KCVRCK9LbqYeoI-k0-cuSq4RTlyRA>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 19 Jul 2022 20:49:55 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v13 1/5] common/verity: require corruption functionality
Date:   Tue, 19 Jul 2022 17:49:46 -0700
Message-Id: <f3b3ac5435afd912e47f867e6561c5cc3732f56e.1658277755.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658277755.git.boris@bur.io>
References: <cover.1658277755.git.boris@bur.io>
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

Corrupting ext4 and f2fs relies on xfs_io fiemap. Btrfs corruption
testing will rely on a btrfs specific corruption utility. Add the
ability to require corruption functionality to make this properly
modular. To start, just check for fiemap, as that is needed
universally for _fsv_scratch_corrupt_bytes.

Signed-off-by: Boris Burkov <boris@bur.io>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
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
index 3ef04953..c8862de2 100755
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
2.37.1

