Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEBC74DA526
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Mar 2022 23:16:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351357AbiCOWRS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 15 Mar 2022 18:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350324AbiCOWRS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 15 Mar 2022 18:17:18 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81CCC55BD1;
        Tue, 15 Mar 2022 15:16:05 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id DF4E65C0207;
        Tue, 15 Mar 2022 18:16:04 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute3.internal (MEProxy); Tue, 15 Mar 2022 18:16:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; bh=SEC0H9OItPspyLXYSaNaZvwbL/b0zp
        vHbge9eZDq0b8=; b=wQWtjBHQi4w4F6P5/3m5foT7kaX9iZkEaEkX7OaeEf3Om9
        3M/XTQJuG/DPNwAabJSjp5gqBYHyTYV8YT4Z+j38lIZMvCiORZIB3u3iyZxbINrd
        Z2fqIUORW+QtkDe7P6MSu8lttOnVvwUhQBS9S/lFTe5UghxJLNz0kZ7ZiMV5vIEv
        nZVi6YTnx40O7tHl/iETINXHEs/eBPPWt1BjqAjaqqGqdEJwELjAI9B5/4dV4IGL
        BN2ZGVKtEwSd2hu51mFnRPd6NEyyaMQy6bVIM3+JmVyneQhWfZ9R1iLMylLpwD/X
        6jtrTsrexdDRPZIRY1NDksUvs9X3HO2q19sucrQg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=SEC0H9
        OItPspyLXYSaNaZvwbL/b0zpvHbge9eZDq0b8=; b=Bx5VfbtrC0idq+ptEz459M
        897Avbbh4XlmKugfSiz48oTDwqwSfNP903lS98tHAgICFoQVcjyFIGCQTRJHYgMg
        dtSZxzKNJi41y+njDmMIJ9YRlDjeNYygkhMlM8x1/PC0PVoSCghA5k2xQqhViEC9
        b8N7FkB58MXG0hyekfSOfufGtNA+RDZEVd+Arg3Xl/pouraM3ofbLQZp6Cf/svKa
        6oG2gt2qarhQ/pK81tOFC43kQuIxg3FDJE/XCfxeNvt6W2Tq1+JinTmxW1tKafjC
        FStwMpxLzaetKj/W/qamTwouO+80YHNM9NH2CPvmOUqorCm3Z4QJPcfvWdv2+dag
        ==
X-ME-Sender: <xms:JBAxYqwdRCYjyvNbTSg0e4F0Qpu7F5etKv1A6z9wBfyG5SLa0wtZAw>
    <xme:JBAxYmRGL0j1pqMubH0XvpM2IzEKTSgZjwbIkw_mEwWTQUXyCaLDYJymNKEVZI2hj
    2Q0ce07KIkfk73CWRM>
X-ME-Received: <xmr:JBAxYsUo78g2eIKTzaVKD9igx4MSt0keFaIAefyD92weK0VDatn99SCwSliY32Nq_6JzpwOvMytcXHdgPSZoZ63CYi9rLA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeftddgudehjecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtke
    ertdertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejff
    evvdehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghm
    pehmrghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:JBAxYgjG9Bxl5oIgOgM5bl3A6_bvs6bfNiOd-SeykFg0vy5zE-b7VA>
    <xmx:JBAxYsBFx_mZuHDzpnbG3QJwE6L5qV5GSk0j5HLxZkEP06kLFYLVMA>
    <xmx:JBAxYhLPabDrfHXxNjo3LoEhwrul6weHiBE6whByCGJIlLvlPucUBA>
    <xmx:JBAxYvNKjQjP5ddKSO2ZuypHG-vHMFCoX8Bje5JU06_CZF-7Wib5xA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Mar 2022 18:16:04 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v7 1/5] verity: require corruption functionality
Date:   Tue, 15 Mar 2022 15:15:57 -0700
Message-Id: <73ea99df928e64baf172fa38a0648fb21494e864.1647382272.git.boris@bur.io>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1647382272.git.boris@bur.io>
References: <cover.1647382272.git.boris@bur.io>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
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
index 38eea157..1afe4a82 100644
--- a/common/verity
+++ b/common/verity
@@ -141,6 +141,12 @@ _require_fsverity_dump_metadata()
 	_fail "Unexpected output from 'fsverity dump_metadata': $(<"$tmpfile")"
 }
 
+# Check for userspace tools needed to corrupt verity data or metadata.
+_require_fsverity_corruption()
+{
+       _require_xfs_io_command "fiemap"
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

