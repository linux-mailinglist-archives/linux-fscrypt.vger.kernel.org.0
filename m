Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2CE4578E1E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 Jul 2022 01:13:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236443AbiGRXNp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 Jul 2022 19:13:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229888AbiGRXNp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 Jul 2022 19:13:45 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0259933368;
        Mon, 18 Jul 2022 16:13:41 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 73DA15C0143;
        Mon, 18 Jul 2022 19:13:40 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 18 Jul 2022 19:13:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1658186020; x=1658272420; bh=2s
        f0/qhtYUFQefEjNOYr1zz/jjRB8K8ODeUOsWiRJsQ=; b=LdLRLkbplqcKoZymtl
        uwUnapyGnPX2enovoDgaCtNmJQ0YswPM9mNfMI/S8BqQ0G2bGRiFXENZR2m9MFvQ
        9G+F5mAp9cIBnoJO9P8QxzjtTosZQjBff3CiMoeXFpBt/GMxmQkju9uKBGtdTgRT
        V7rUBTuIuyjV5c17Z2gnaRKRo/wq8zBG7rghlRP5J5UGZaXmPDIWo/CAI4NxBEh0
        aj4lwkLoKo765hhOZVzomNUW6nyaMgOBPZvhscxpNE+WKwMW5YeekXaCYJ7PZVaZ
        IORZYRh9PuN0qF34q7Wg1/4l79s5emfh29DGT9vpidIOgqh7ndV02qoB0fH+Ldy4
        kFLQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658186020; x=1658272420; bh=2sf0/qhtYUFQe
        fEjNOYr1zz/jjRB8K8ODeUOsWiRJsQ=; b=ncf9n7pHowese4SrFbumPBpQntK4o
        5FLxGRQopyPNdwBnOfh1vLy8x0iZP05gt8D7qQs62S3UomcTjaM719ZklsXOAsLG
        Sv93IkMG4eDSWZscFpsV1pQyR1SNR/M627+n+iKLBLdai51ejcTdIvP/EsirkXDL
        F6yYxBSw+/RIA7R8BPTd9ZMS+nKCPgMf7RkDj+o66TFneEhqHPHcqF90Ihrd65MU
        ZPIGUALfdm4ojf3IUdMYY5q2yUWzf5iq4aQN8Zh+qw2Xjb+eSdri7Fc7ffF96mzM
        6hD2dxd+tbV1bxvOw1z4JMYU9wfY98BGSM09lyLga2kDeiLIoLcJLktEg==
X-ME-Sender: <xms:JOnVYilfB2RDiRilmcXK97vQDkvKAWgqS2tHkhDY11EIVnjK9-_hVw>
    <xme:JOnVYp12ZMbLcu9Dvo2CoOqOhs_u1GkEoG4HIoOEAFUwUqSl4R3ZBQtNuPwdH3Xrl
    yuGLy2SlF5gd969U6A>
X-ME-Received: <xmr:JOnVYgrnczGKxud8NIKRaFTjy6aNYhtnGOF7Ox4lMwXhrJtrmrAz_6w3IjNZOMdN7PTwLLFbA9TUFZjxH7XD0SiYMloySg>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekledgvddtucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdr
    ihhoqeenucggtffrrghtthgvrhhnpeeiueffuedvieeujefhheeigfekvedujeejjeffve
    dvhedtudefiefhkeegueehleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:JOnVYmnHBx4o6D5f91GLCwlE-vC6nZTyPFPELaykZ8EpTWQJ_wILzg>
    <xmx:JOnVYg0CiOWxOcfsJbtbhIK3QA7TvnNwqFfOznlbD9wkvyTuftOfcw>
    <xmx:JOnVYtspo5f-MBYiTEkhZZ7HdSVqVfqFn8hbxdP9tBzvEvSq6tJ4PA>
    <xmx:JOnVYuBjeivR4rwLm9jQp4CKYyftt5crGFVhrXVabDr9RwZh8Nuz7Q>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Jul 2022 19:13:39 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v11 1/5] common/verity: require corruption functionality
Date:   Mon, 18 Jul 2022 16:13:33 -0700
Message-Id: <8a0a68f0729b66fceb43e2638305fc85ace58702.1658185784.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658185784.git.boris@bur.io>
References: <cover.1658185784.git.boris@bur.io>
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

