Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2FC3D743046
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Jun 2023 00:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231653AbjF2WRr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Jun 2023 18:17:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231633AbjF2WRn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Jun 2023 18:17:43 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7802330F1;
        Thu, 29 Jun 2023 15:17:41 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 57FC180853;
        Thu, 29 Jun 2023 18:17:41 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688077061; bh=25iYtADJPd2nrRlUwLh/2stsRklypj/QDkXQHfukXX4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=PTwpYiDQL3qwq+UkbDqMfqnKI7TMQYsoLsB86zYkCciyq/Sx9Gij/rTvSEYBQ1sJh
         vaT04+aVMK/Z860oaSNyJGbSJiJ7zwKsZqQIeH3jHGQkzYYs8wJ1SCkVoEkLH0OaXa
         Iy+WZ7HuwxpRsW9TAuuGMBLOAqVfEn3tqRSNiEwpSMS51fFYWFnAxTQesMQKB4Oyf2
         V/exQx93awiIYA0pwLs8HIrjtlS2I7qXEInU9vPXazY6CyYuviIFXC2HkGVFFuLGv8
         XfU+otAtzun72t1sa9XDbIH+73emmT/wEGiR6rXGpnnQcE7Q+3PwLzgGZBOItll1rP
         y3hclLXeLSb2A==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@meta.com, ebiggers@google.com, anand.jain@oracle.com,
        fdmanana@suse.com, linux-fscrypt@vger.kernel.org,
        fsverity@lists.linux.dev, zlang@kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 6/8] tests: adjust encryption tests for extent encryption
Date:   Thu, 29 Jun 2023 18:17:21 -0400
Message-Id: <f10e5d1b3d5027361c646c9c0e011a366b923b6a.1688076612.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1688076612.git.sweettea-kernel@dorminy.me>
References: <cover.1688076612.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Extent encryption is different from the existing inode-based encryption
insofar as it only generates encryption keys for data encryption at the
moment at which the data is written. This means that when a key is
removed, even if there's an open file using it, that file immediately
becomes unreadable and unwritable.

This contradicts the assumptions in three tests. In generic/429, we can
issue a sync to push the dirty data to the filesystem before dropping
the key. However, generic/580 explicitly wants to write data after
dropping the key, and generic/595 wants to intermingle key removals and
data writes, which is unpredictable in effect. So just disable those
two.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 tests/generic/429 | 6 ++++++
 tests/generic/580 | 4 ++++
 tests/generic/595 | 4 ++++
 3 files changed, 14 insertions(+)

diff --git a/tests/generic/429 b/tests/generic/429
index 2cf12316..1d26deda 100755
--- a/tests/generic/429
+++ b/tests/generic/429
@@ -68,6 +68,12 @@ show_directory_with_key()
 	show_file_contents
 }
 
+# btrfs needs to have dirty data pushed into it before session keyring
+# is unlinked, as it doesn't set up the data encryption key until then.	
+if [ "$FSTYP" = "btrfs" ]; then
+	sync
+fi
+
 # View the directory without the encryption key.  The plaintext names shouldn't
 # exist, but 'cat' each to verify this, which also should create negative
 # dentries.  The no-key names are unpredictable by design, but verify that the
diff --git a/tests/generic/580 b/tests/generic/580
index 73f32ff9..abaf8c3e 100755
--- a/tests/generic/580
+++ b/tests/generic/580
@@ -23,6 +23,10 @@ _require_scratch_encryption -v 2
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 
+if [ $FSTYP = "btrfs" ]; then
+	_notrun "extent encryption locks open files immediately on key removal"
+fi
+
 test_with_policy_version()
 {
 	local vers=$1
diff --git a/tests/generic/595 b/tests/generic/595
index d559e3bb..9040f0c4 100755
--- a/tests/generic/595
+++ b/tests/generic/595
@@ -35,6 +35,10 @@ _require_command "$KEYCTL_PROG" keyctl
 _scratch_mkfs_encrypted &>> $seqres.full
 _scratch_mount
 
+if [ $FSTYP = "btrfs" ]; then
+	_notrun "extent encryption locks open files immediately on key removal"
+fi
+
 dir=$SCRATCH_MNT/dir
 runtime=$((4 * TIME_FACTOR))
 
-- 
2.40.1

