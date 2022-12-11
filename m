Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBDE2649301
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Dec 2022 08:07:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiLKHH6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Dec 2022 02:07:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230025AbiLKHHx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Dec 2022 02:07:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94244320;
        Sat, 10 Dec 2022 23:07:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9239B60C95;
        Sun, 11 Dec 2022 07:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5AC3C433F1;
        Sun, 11 Dec 2022 07:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670742466;
        bh=5XdxmPbQ5uD8EQjNq6Wlsk6Jo13qeKOFtp/IbedmcHU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=cOdqFCDvbeOW6R31uQpU9YRltjGSunNsiKpchFE6NrxA/O3AH7viudKFUlCcjbL1k
         tuSaIxvNWsJXdLQdz4Cc320c4YBnIhyhSed2XesPgAjkLOqQQWz934OtvUyeFwh5op
         RxOxiUDoTCTFZazmrwXpQ0Nw11IhfUco/UXtpvo2siVA3Ok05VctSvXScsJqK0h/ma
         EyDkeLsSL5myQDZmAXJQONaQvpU5oTW5YzrsomocW266f3F6K9gQ32vGoTKbSFrJAE
         0fXy+z01TXnNIEDy8rfsttJO7hmZfA+RO4VqLGM1GIaWXUnZW0s2RSxpjEPiZ8Jsyv
         a30d/ShnRQcDQ==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 06/10] generic/573: support non-4K Merkle tree block size
Date:   Sat, 10 Dec 2022 23:06:59 -0800
Message-Id: <20221211070704.341481-7-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221211070704.341481-1-ebiggers@kernel.org>
References: <20221211070704.341481-1-ebiggers@kernel.org>
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
2.38.1

