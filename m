Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DAF9510C1E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 27 Apr 2022 00:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355895AbiDZWnb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Apr 2022 18:43:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240418AbiDZWna (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Apr 2022 18:43:30 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7FF2A13F0A;
        Tue, 26 Apr 2022 15:40:20 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 399195C0164;
        Tue, 26 Apr 2022 18:40:20 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Tue, 26 Apr 2022 18:40:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc
        :content-transfer-encoding:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm1; t=1651012820; x=1651099220; bh=ss
        XnEw9itOkmvU5n03mfVnTTvDIDQzuYWNCfiA8EImc=; b=rdXJO4n+zvSMyf0bfx
        APovOQXpWQ+u708ePQHg17Ds1IB0TngWZjqZvgzpZOT6R7Mpw+aOXoTvff0dbOn+
        YOcxxA+sFmR0RvskXAH6vkt9TbEG46PDbLLEAbIEqqmPqNsT276VPiysigBYZSFQ
        l42G49F2YYJWf4fFAAnPR+aa7kD4oUrk9432pAm5s3I3ShbOukJYe0Ek4xq1lZ2L
        0scbHK7wLT0lUJ1uYeyIygn08M/q3myk3h6zTnxQF7onwkTNrdoreuIQPo88Ysxa
        7/+WjMM8ejPGxmdFBB3bI2foGhrFfND201iNxMv8PCazyoxRaR8wJjbIf11O/+wA
        KblQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:date:date
        :from:from:in-reply-to:in-reply-to:message-id:mime-version
        :references:reply-to:sender:subject:subject:to:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=
        1651012820; x=1651099220; bh=ssXnEw9itOkmvU5n03mfVnTTvDIDQzuYWNC
        fiA8EImc=; b=zhStwTUOtdyr2aNfIiAfMk78ksLMpxJzhvGZ2c7HVjOBDWqTAbT
        TOnAAXonChn9l6yDQFWgYfmo/ZYztqf8n7md0pOuYIV/M3sHTN+j7ee70D8B+dz/
        Lt5CTM3ItLPck8QGuS6skEARWD7YlR9jMj1xJCCoZdRFPtCnH3G2xs83GYEOq7Xb
        dlwui8y8iw8uQ0IqdNSLLku12J652b4BZavm3o1+MXU5Y+RszCQp8LZjf8AjV2x2
        w2if+QOL/i7ZikQa0M1tS15brT37zG3gY0/Q/DUyNASnHn1AxFdga3XM61hjKSl1
        Z/puZ2Jmoli5kMmvqKKc9QNiLU9lLHvnlnA==
X-ME-Sender: <xms:1HRoYh5tn3zkVcOrk9D5vIUg3-JEhARc9F9GzFe4oCg2HwwAkcaJUA>
    <xme:1HRoYu6FiC9XWXpvHAaDznfn30WJeJsL_wA_oJQ9kc6fyJsC5zD4uZ5N3Un26xzpr
    YuLWEOOu375j4wCzIk>
X-ME-Received: <xmr:1HRoYocyPbhWKaXH28jq0S_A7KIdVAaEOJLRN61zrkWYkTm_T-C6IuKDsPN9qWa1dtuCZ9fmfC-tSTTot1S4WXJLyOZlqw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudeggddugecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecunecujfgurhephffvufffkffojghfggfgsedtkeertd
    ertddtnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhi
    oheqnecuggftrfgrthhtvghrnhepieeuffeuvdeiueejhfehiefgkeevudejjeejffevvd
    ehtddufeeihfekgeeuheelnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehm
    rghilhhfrhhomhepsghorhhishessghurhdrihho
X-ME-Proxy: <xmx:1HRoYqI5y1jbuEsxi4cAuaTxoFx9FRC4kwQ-WUM0EiLZDIjitA6lbg>
    <xmx:1HRoYlLa6j28915KHEgyURR5ASkTFXlCTVBBB3QXrtHEDlGjKykyKg>
    <xmx:1HRoYjw9oz169eVHOKn6_WS-WLq-CmBOzIC8dunOWUffUjo84Kq-Og>
    <xmx:1HRoYsUfhBHdCqIj4KEeRc1tqaMzC3oSxRi6qLNeq-zOGdpQBPBBVg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 26 Apr 2022 18:40:19 -0400 (EDT)
From:   Boris Burkov <boris@bur.io>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: [PATCH v9 1/5] common/verity: require corruption functionality
Date:   Tue, 26 Apr 2022 15:40:12 -0700
Message-Id: <657cd5facdbd0b41ee99ab18ad0bba9f0d690729.1651012461.git.boris@bur.io>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <cover.1651012461.git.boris@bur.io>
References: <cover.1651012461.git.boris@bur.io>
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
2.35.1

