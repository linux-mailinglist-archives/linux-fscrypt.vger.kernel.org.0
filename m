Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE194578E9E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 Jul 2022 01:59:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235733AbiGRX7Z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 Jul 2022 19:59:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236271AbiGRX6t (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 Jul 2022 19:58:49 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C305633E32;
        Mon, 18 Jul 2022 16:58:37 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id B9CE35C0136;
        Mon, 18 Jul 2022 19:58:36 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 18 Jul 2022 19:58:36 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1658188716; x=1658275116; bh=2s
        f0/qhtYUFQefEjNOYr1zz/jjRB8K8ODeUOsWiRJsQ=; b=GpfElRbvztBBzx3exA
        n7K2M3iq7VJiRTVP112/Ndr0Ba59kvzXjSV08f3awQLstY++baFAyOvMrMIWk0M3
        72XkHi6Q6iOvIkZY8Vv00GIQc7c0vqTfsdsurVpNfAxeBhjGNfkgFFBmTJoAc6dJ
        BM1qjKWZ4hvW5UsOFsquqNURLP2Zx99Dg7u6NTh3JCeBYSmG23NcdVaQJPxo9cwB
        nR5JFphLoLofAr94yUQe74ww3Iad4nLqoizlI+UkQ1yx/TeKTSmcCet8heR8Ztv7
        E2vocvUEq2Elp3vCclTUg0nUe8LO0u2Eeb+yvhvA2OUOjzDznqZhfIPvNy9C886H
        rUhA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1658188716; x=1658275116; bh=2sf0/qhtYUFQe
        fEjNOYr1zz/jjRB8K8ODeUOsWiRJsQ=; b=WtJSojBfrGv0FnT3SkhvGOx7VwoqO
        54ALmEY3obJgcdBcbFsBvYkEJlRUxmfXkpXHXalJLLTGy7UMPDYwxbrNDCBxi91B
        lDCLRDIGeoAoT4kTVIpPlqCFTQ7WVu+vl2HmBniS6mHLtKdaYwyKg7bAu384uu5Z
        Y0QhvzSad8FSR+2ml2/VwryK9dNO4ye9troiN7V+H8PgxHwob46CLRoQ7xH+n1Y5
        GTen45jLB41yVAlbUSs1wVN4itxYam8l8D1zyVWnqW2rawqjadxdo4ZvQsdbTqxi
        NVCsYQkZkGnAm1LfeVHgKlX81Pb8IlG9l1k8UwcapMKS5G9K3ayPP//Vg==
X-ME-Sender: <xms:rPPVYg9o_UYNY-jMj4R134EU62JppFVnitUasqldE-D_WTa9Yrt5gg>
    <xme:rPPVYovkLB3Et-ZkZRxwHIfdN6b43G0QlWtewaWTHJwkrosBtcyQUhs-qWZ79PvKP
    Gd688evM1r0h6jIz_Y>
X-ME-Received: <xmr:rPPVYmCJ9vIfYb4s65qh2Jqq-IJj0XozNpQu_c9xbri11oMmRe02evxCkFuLKJ_DCbXBWsMx09_JZ0QJ_UlXLODni4R1VQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekledgvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucenucfjughrpefhvffufffkofgjfhgggfestdekre
    dtredttdenucfhrhhomhepuehorhhishcuuehurhhkohhvuceosghorhhishessghurhdr
    ihhoqeenucggtffrrghtthgvrhhnpeeiueffuedvieeujefhheeigfekvedujeejjeffve
    dvhedtudefiefhkeegueehleenucevlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhep
    mhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:rPPVYgcqyBst8Qky_nesUusMuCStxCfR_1tncwBenjyrR5ofyGZKlg>
    <xmx:rPPVYlPzs7ZeD3X60mmDwMZPge88I-p3dmi9wkKiFPs2Gn9kLO9m1A>
    <xmx:rPPVYqnIpUKrDWv4013VhVGufs7559ZkhqBwykmPsjZt_oubOU_K8g>
    <xmx:rPPVYub3HMYR6bILz4EowwQmFR0udlZMunfEVKgQ3NMIG9XZVEj1IQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Jul 2022 19:58:36 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v12 1/5] common/verity: require corruption functionality
Date:   Mon, 18 Jul 2022 16:58:29 -0700
Message-Id: <8a0a68f0729b66fceb43e2638305fc85ace58702.1658188603.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1658188603.git.boris@bur.io>
References: <cover.1658188603.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
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

