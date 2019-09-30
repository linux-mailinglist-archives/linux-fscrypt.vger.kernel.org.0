Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3E32C2896
	for <lists+linux-fscrypt@lfdr.de>; Mon, 30 Sep 2019 23:19:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731997AbfI3VT0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 30 Sep 2019 17:19:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47220 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1731206AbfI3VT0 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 30 Sep 2019 17:19:26 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 92FA921855;
        Mon, 30 Sep 2019 21:19:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1569878365;
        bh=vrx6r+SGfrTyFSiHE5OHRltvBYxK9kX4SHueCOiMXmE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kCBgjUOHkr02WThgME0Yy4+Mefza47yGqPOkgp0zAnQ81ZR2EO+TnpIV1GHfcLbYf
         Efmkgpwee/BTVol0SZaCHPrapw8opKPbne2URif9cU6ddGj2kMbenTS84x6BhVFRcz
         fOLPsFLVKsDXtF3gLEovbn5YoJ+VvakO+A0vXVng=
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        "Theodore Y . Ts'o" <tytso@mit.edu>
Subject: [PATCH v4 1/8] common/filter: add _filter_xfs_io_fiemap()
Date:   Mon, 30 Sep 2019 14:15:46 -0700
Message-Id: <20190930211553.64208-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0.444.g18eeb5a265-goog
In-Reply-To: <20190930211553.64208-1-ebiggers@kernel.org>
References: <20190930211553.64208-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add _filter_xfs_io_fiemap() to clean up the output of
'xfs_io -c fiemap'.  This will be used by a function in common/verity.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/filter | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/common/filter b/common/filter
index 26fc2132..2477f386 100644
--- a/common/filter
+++ b/common/filter
@@ -541,6 +541,30 @@ _filter_filefrag()
 	      $flags, "\n"'
 }
 
+# Clean up the extents list output of 'xfs_io -c fiemap', e.g.
+#
+#	file:
+#		0: [0..79]: 628365312..628365391
+#		1: [80..159]: hole
+#		2: [160..319]: 628365472..628365631
+# =>
+#	0  79   628365312  628365391
+#	160  319   628365472  628365631
+#
+# The fields are:
+#
+#	first_logical_block last_logical_block first_physical_block last_physical_block
+#
+# Blocks are 512 bytes, and holes are omitted.
+#
+_filter_xfs_io_fiemap()
+{
+	 grep -E '^[[:space:]]+[0-9]+:' \
+		 | grep -v '\<hole\>' \
+		 | sed -E 's/^[[:space:]]+[0-9]+://' \
+		 | tr '][.:' ' '
+}
+
 # We generate WARNINGs on purpose when applications mix buffered/mmap IO with
 # direct IO on the same file. This is a helper for _check_dmesg() to filter out
 # such warnings.
-- 
2.23.0.444.g18eeb5a265-goog

