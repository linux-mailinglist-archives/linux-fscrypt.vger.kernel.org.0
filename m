Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8157527366
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 May 2022 20:05:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231899AbiENSFl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 14 May 2022 14:05:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229538AbiENSFk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 14 May 2022 14:05:40 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F510E01F;
        Sat, 14 May 2022 11:05:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 32826B801BD;
        Sat, 14 May 2022 18:05:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A3B24C340EE;
        Sat, 14 May 2022 18:05:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652551535;
        bh=I0s9oWoQTIjzMiZqERKj9agOoscpX/k8iVkfOBRfigQ=;
        h=From:To:Cc:Subject:Date:From;
        b=qGJcxnVysDc0Bo3dCNBVoCTL+5YsGsp3ZiNuIocy7/QSXelMRmc0UfUsa/ILjNvvE
         X01aSBlut6TkReXgraqIL/ZnLm2rwpUOkOoGQ+ISsm/uJR5Uf7ymYQLYPRTBS39dxN
         GeWcJG3cRfx0fdsFoE1/icJK6Ufi4u9ra/FxmLUIZhCwXO0tTKkEgoH8VCUQPrKL9v
         LNZ9wAdbhpcmo34m8cWLtJP6uL8niOcaUH745Tx8jfYzqVFu1mtW6okPa7Bcgnfg3W
         Az4iANyjVCUp7sDYB6xryICwrgP1GdFVY3XK5MFJLmFjt+eNLemF1tC6AlGkx0zSdT
         uFkm/tTdW5ZOg==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Daniel Rosenberg <drosen@google.com>
Subject: [xfstests PATCH] generic/556: add test case for top-level dir rename
Date:   Sat, 14 May 2022 11:01:46 -0700
Message-Id: <20220514180146.44775-1-ebiggers@kernel.org>
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

Test renaming a casefolded directory located in the top-level directory,
while the cache is cold.  When $MOUNT_OPTIONS contains
test_dummy_encryption, this detects an f2fs bug.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 tests/generic/556 | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/tests/generic/556 b/tests/generic/556
index 7ef2f6f4..8abb65e8 100755
--- a/tests/generic/556
+++ b/tests/generic/556
@@ -348,6 +348,21 @@ test_file_rename()
 		echo "Name shouldn't change."
 }
 
+test_toplevel_dir_rename()
+{
+	local dir=${SCRATCH_MNT}/dir_rename
+
+	# With the cache cold, rename a casefolded directory located in the
+	# top-level directory.  If $MOUNT_OPTIONS contains
+	# test_dummy_encryption, this detects the bug that was fixed by
+	# 'f2fs: don't use casefolded comparison for "." and ".."'.
+	mkdir ${dir}
+	_casefold_set_attr ${dir}
+	sync
+	echo 2 > /proc/sys/vm/drop_caches
+	mv ${dir} ${dir}.new
+}
+
 # Test openfd with casefold.
 # 1. Delete a file after gettings its fd.
 # 2. Then create new dir with same name
@@ -486,6 +501,7 @@ test_dir_name_preserve
 test_name_reuse
 test_create_with_same_name
 test_file_rename
+test_toplevel_dir_rename
 test_casefold_openfd
 test_casefold_openfd2
 test_hard_link_lookups

base-commit: bb04d577435d04ce3aa160f0563d1d35d4860d54
-- 
2.36.1

