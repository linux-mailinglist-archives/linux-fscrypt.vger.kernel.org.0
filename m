Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7DB85588B7
	for <lists+linux-fscrypt@lfdr.de>; Thu, 23 Jun 2022 21:26:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230512AbiFWT0o (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 23 Jun 2022 15:26:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230518AbiFWT0R (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 23 Jun 2022 15:26:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0576809A;
        Thu, 23 Jun 2022 11:43:45 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DCBBE6202D;
        Thu, 23 Jun 2022 18:43:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01E16C341C6;
        Thu, 23 Jun 2022 18:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656009824;
        bh=8JGe9eNXEurDtGUIOyQMri1/phHvJdA0fNLSfBzS7mg=;
        h=From:To:Cc:Subject:Date:From;
        b=VTJnq498YgKS82Dy0bbSmatOgnVDF5fX0zO6WkqQSxO7/cUtrNLUpUD3RYVr1HG+J
         hNgnkknImrSSx0uXv5u4q8wD0M3lMFo9z1qU63P0jME7UnfngZV7BFs7RkdADI9rQm
         yaYTneIIVB7GcYHU1ggRao+3v9HUJ74AKsGePil7zeQzeNZxTgwO8W0pEYsFBDMDxD
         ILgq52EVJbuSmwlwxkdLKtd13f+lPc2JTE3x3QWoyWeqPPwZPhcLd77OMyzACzSAdW
         mE3XkW3l8wn/cPzsnBfuik7KdC6d4v/vc3SqWveuKJaW+TxWJC/IKboN+Iwl90CZef
         DcjBfA35q7OQw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Lukas Czerner <lczerner@redhat.com>
Subject: [xfstests PATCH v2] ext4/053: test changing test_dummy_encryption on remount
Date:   Thu, 23 Jun 2022 11:41:13 -0700
Message-Id: <20220623184113.330183-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.36.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The test_dummy_encryption mount option isn't supposed to be settable or
changeable via a remount, so add test cases for this.  This is a
regression test for a bug that was introduced in Linux v5.17 and fixed
in v5.19-rc3 by commit 85456054e10b ("ext4: fix up test_dummy_encryption
handling for new mount API").

Reviewed-by: Lukas Czerner <lczerner@redhat.com>
Signed-off-by: Eric Biggers <ebiggers@google.com>
---

v2: added info about fixing commit, and added a Reviewed-by tag

 tests/ext4/053 | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/tests/ext4/053 b/tests/ext4/053
index 23e553c5..555e474e 100755
--- a/tests/ext4/053
+++ b/tests/ext4/053
@@ -685,6 +685,9 @@ for fstype in ext2 ext3 ext4; do
 		mnt test_dummy_encryption=v2
 		not_mnt test_dummy_encryption=bad
 		not_mnt test_dummy_encryption=
+		# Can't be set or changed on remount.
+		mnt_then_not_remount defaults test_dummy_encryption
+		mnt_then_not_remount test_dummy_encryption=v1 test_dummy_encryption=v2
 		do_mkfs -O ^encrypt $SCRATCH_DEV ${SIZE}k
 	fi
 	not_mnt test_dummy_encryption

base-commit: 0882b0913eae6fd6d2010323da1dde0ff96bf7d4
-- 
2.36.1

