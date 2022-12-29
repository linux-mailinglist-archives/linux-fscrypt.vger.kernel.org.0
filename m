Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54431659331
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Dec 2022 00:35:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234256AbiL2XfH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Dec 2022 18:35:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234211AbiL2XfG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Dec 2022 18:35:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5853017408;
        Thu, 29 Dec 2022 15:35:05 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E7A39619A0;
        Thu, 29 Dec 2022 23:35:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4847BC433EF;
        Thu, 29 Dec 2022 23:35:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672356904;
        bh=xKsP/0Vh5sWLaXmpf4gkpUu9ysvAPC2FvhutYJM8cqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Dg5K8oALAEZJ0TFxHOXCT6QjdILMmdfaLanS6nThOaPCJyme1FWXZrKZ5mpdJVfxd
         vfN9sX2rG79ihmRqTpEJfdnQ5dzKV+TGXrXGbgThTOPnyq0GF3WKY43YzCre5hBXIF
         KjrT7/gy8oDLWaf6+rV/IfGLjAYo6wP4V4EngjiJg4BsEgGsktm/oe5EELx8phE6dw
         yJp1G2yOrfIphMTScZaZyUUsQeOEN+ejMwP+9Dht9W9C0Kd4hPW/v/JxNuRN785YeD
         CkDEPzUi4Z8hiQKSG5vHS0rSxEE7/5QdfdfMNyCkSt7CVxlrWUyV7zHsB7GBJSrCqv
         ZVYZi9XJP+Z9g==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v3 06/10] generic/573: support non-4K Merkle tree block size
Date:   Thu, 29 Dec 2022 15:32:18 -0800
Message-Id: <20221229233222.119630-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221229233222.119630-1-ebiggers@kernel.org>
References: <20221229233222.119630-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Update generic/573 to not implicitly assume that the Merkle tree block
size being used is 4096 bytes.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/573 | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tests/generic/573 b/tests/generic/573
index 63c0aef5..ca0f27f9 100755
--- a/tests/generic/573
+++ b/tests/generic/573
@@ -36,23 +36,23 @@ fsv_file=$SCRATCH_MNT/file.fsv
 _fsv_scratch_begin_subtest "FS_IOC_ENABLE_VERITY doesn't require root"
 echo foo > $fsv_file
 chmod 666 $fsv_file
-_user_do "$FSVERITY_PROG enable $fsv_file"
+_user_do "$FSVERITY_PROG enable --block-size=$FSV_BLOCK_SIZE $fsv_file"
 
 _fsv_scratch_begin_subtest "FS_IOC_ENABLE_VERITY requires write access"
 echo foo > $fsv_file >> $seqres.full
 chmod 444 $fsv_file
-_user_do "$FSVERITY_PROG enable $fsv_file" |& _filter_scratch
+_user_do "$FSVERITY_PROG enable --block-size=$FSV_BLOCK_SIZE $fsv_file" |& _filter_scratch
 
 _fsv_scratch_begin_subtest "FS_IOC_ENABLE_VERITY requires !append-only"
 echo foo > $fsv_file >> $seqres.full
 $CHATTR_PROG +a $fsv_file
-$FSVERITY_PROG enable $fsv_file |& _filter_scratch
+_fsv_enable $fsv_file |& _filter_scratch
 $CHATTR_PROG -a $fsv_file
 
 _fsv_scratch_begin_subtest "FS_IOC_ENABLE_VERITY requires !immutable"
 echo foo > $fsv_file >> $seqres.full
 $CHATTR_PROG +i $fsv_file
-$FSVERITY_PROG enable $fsv_file |& _filter_scratch
+_fsv_enable $fsv_file |& _filter_scratch
 $CHATTR_PROG -i $fsv_file
 
 _fsv_scratch_begin_subtest "FS_IOC_MEASURE_VERITY doesn't require root"
-- 
2.39.0

