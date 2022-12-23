Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52D5C654A61
	for <lists+linux-fscrypt@lfdr.de>; Fri, 23 Dec 2022 02:11:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236022AbiLWBLK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 22 Dec 2022 20:11:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235892AbiLWBKd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 22 Dec 2022 20:10:33 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ED2821269;
        Thu, 22 Dec 2022 17:07:04 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3A9C061DE4;
        Fri, 23 Dec 2022 01:07:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 871F1C433D2;
        Fri, 23 Dec 2022 01:07:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671757623;
        bh=xKsP/0Vh5sWLaXmpf4gkpUu9ysvAPC2FvhutYJM8cqk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IotiWMod8dIST5lVDee8XymEB9q/xbW/ZGiCQFatb3TAMN0XsIr0TUbp5h+fr2BPD
         lFvsnC6TQgCX/kP86AMaxjNhm9VIFIcusRK6gtd2DnBJv9M16KPGMaZ3symytSQi5Y
         l2fx1d0DpeywTdJjbh0i2109iDHB6Z2ORTe8jKkpgZFk2LjgqfvUOYBWweA6V4TCxb
         /4ilkHJDW4wLKUS3Nrw5L66aYAjsGt/LqX489wKaYkQOAOU7BAHFrLa/zfHVoqUufI
         wq4vQvKLP712BBSw765cRtZ7PBigV6Ptks1IvOKc5JeG7iC9Vv9X8KGl4b93hgBee2
         B7sHsQxSgCIZA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH v2 06/10] generic/573: support non-4K Merkle tree block size
Date:   Thu, 22 Dec 2022 17:05:50 -0800
Message-Id: <20221223010554.281679-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221223010554.281679-1-ebiggers@kernel.org>
References: <20221223010554.281679-1-ebiggers@kernel.org>
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

