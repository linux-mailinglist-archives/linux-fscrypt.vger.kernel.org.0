Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEA7A57681B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Jul 2022 22:32:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230210AbiGOUcD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Jul 2022 16:32:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49528 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229532AbiGOUcC (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Jul 2022 16:32:02 -0400
Received: from out4-smtp.messagingengine.com (out4-smtp.messagingengine.com [66.111.4.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0A5A15B044;
        Fri, 15 Jul 2022 13:31:57 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 479175C00F3;
        Fri, 15 Jul 2022 16:31:56 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Fri, 15 Jul 2022 16:31:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm3; t=1657917116; x=1658003516; bh=Td
        ZnSCJGNrBEC/2Qzr7d09NUMvR1tmi1sQGMRBURoQM=; b=coF83jTAYKIKroUI9j
        fACJSpnpySdKlXU8v7Z/f/ait0aVmNr2Gut7uSaSvYmenspjOrAeu5YwfbvSuEB0
        HViMEOEcVbszUjx/WF/EDMs4WyFVQT+1I8JwQjGfpDBFi0EfL/yjHp+fUSGZ98yx
        CRKx90DgVX0Xj0Rk6iH+Ql4JDtvoCRnVcRTUKZ1XQz8Gc4zTRtBamw7s9MvoNiHP
        hcnxMPCtX85hcNgdiDW924GqIoR2uOHQRMDUh9HcgamBfaJhjYAPsoUcc1hlehCg
        C2DIZMCTyRnBlS6oSbnyE9zcHm3wM1GcLCbuznye4rYbm+CLANtjOf4qym+V8R2r
        uO/A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-transfer-encoding:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; t=1657917116; x=1658003516; bh=TdZnSCJGNrBEC
        /2Qzr7d09NUMvR1tmi1sQGMRBURoQM=; b=PhxR2vtVxbqkWzGEY4yS93Um1Gfe8
        904Izf/YmUUGLqlFwfszQBMGUg3yRwWTAEYwWYIBCrPN7zLiKuHK8yha0AcPARp2
        HdtjLSKkbIZnuEGFAVy/yxt5kRNzxbZdDbJWn6k3Wvrrh1pdqRP02LypsgBv+C3Q
        ztA8FOTAXE0cmKnHvq6tvH7kuKLjJ02sqSUXRpSVjQy+kUd8L9NLdbhGHZV4h0qf
        wR5vmGPge/yAILqDm9+CQh7J6LG/CqYqOg/IkKuOm1iOY6eYXM/PthE+T1y8D4cX
        rTp9ev8spQZyj868VI4aZhfYTF1Xre3jC1k45OK0oea1srOUZLY5uFDbA==
X-ME-Sender: <xms:vM7RYoJZW5shpePqjufWcTYXDxaGgCJ4HveQIGwq8xtzmw0aZmr1eg>
    <xme:vM7RYoIEHsBz2qa9cminQzDrJORjBP2hgsGRxwEWmEyk-dibV-KkxJOo0jPzMIlrN
    eLmGZhJ4C_pt0HfdUU>
X-ME-Received: <xmr:vM7RYosPDaATeVThoi7yamYohtnM8GU7cofz48AvmrkNVqUxBZRN3sS9289Tysj01xHrDWusIFB-E_PUMqMFAZaRglxb5Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekuddgudehfecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpefhvfevufffkffojghfggfgsedtkeertdertddtnecuhfhrohhmpeeuohhr
    ihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnh
    epgeduteffveeileetueejheevveeugfdttddvgfeijefhjeetjeduffehkeelkeehnecu
    vehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepsghorhhish
    essghurhdrihho
X-ME-Proxy: <xmx:vM7RYlbsjQTGrf5s0kaaoXyN2laGjwishv_ZNWG0vIUOlpj4jNhNow>
    <xmx:vM7RYvaoTiLm6FiWKG1q2LnsyTgFAIppCDz0E0PlzAH8dLKxSb0dug>
    <xmx:vM7RYhCR-d7EuaXORw53x5GqzVh9yMYAtYcIYPx316VuXu00V0t5IQ>
    <xmx:vM7RYuVYi-XuEl6shJUDCsFwlyuZbhV90NB9zYbIZHJDJu6WnjlgHQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Fri,
 15 Jul 2022 16:31:55 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Eric Biggers <ebiggers@google.com>,
        Josef Bacik <josefbacik@toxicpanda.com>
Subject: [PATCH v10 1/5] common/verity: require corruption functionality
Date:   Fri, 15 Jul 2022 13:31:48 -0700
Message-Id: <8a0a68f0729b66fceb43e2638305fc85ace58702.1657916662.git.boris@bur.io>
X-Mailer: git-send-email 2.37.0
In-Reply-To: <cover.1657916662.git.boris@bur.io>
References: <cover.1657916662.git.boris@bur.io>
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
2.35.1

