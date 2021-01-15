Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68D7E2F846C
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Jan 2021 19:31:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732702AbhAOSbB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Jan 2021 13:31:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:49340 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728784AbhAOSbB (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Jan 2021 13:31:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 45C5923A58;
        Fri, 15 Jan 2021 18:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610735420;
        bh=OlnfKFkoxSsw83/Nn4nLPOmT1fppOZvKCzhP/LtAIl0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=t/O8dyvApsG/tAs049qpWPh34uTtY8zTJEtQe176sA4nna21Mz1l6QhUo2LUFQuwN
         m4BeX8w+ZP+QvKvz39MUWoOk8FtWQ/gdztA+SXheMn1KIN7J7KQImiNRu6PFReI3E5
         OSD82W/izCrxFEUXEkfYpnK0lD0YklHed3ff43G13izvGG1iA7YtxFwULaWIWNvTwg
         7mqfiHlRf3Q4qiIxZ35GBHZ6ykdpwnyCPZz43i6IoCGsIQygMe4a6h9IN6XcuqB0/Y
         9HQPn79xSztl+3Vdgj/hw7DFDCX2s8daIBfu0xDkLMN1hHWJEXM3Y974ap7nbjfRhb
         ZuG/QL1S4cp4A==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Theodore Ts'o <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [xfstests RFC PATCH 2/4] generic: add helpers for dumping fs-verity metadata
Date:   Fri, 15 Jan 2021 10:28:35 -0800
Message-Id: <20210115182837.36333-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.0
In-Reply-To: <20210115182837.36333-1-ebiggers@kernel.org>
References: <20210115182837.36333-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

In common/verity, add helper functions for dumping a file's fs-verity
metadata using the new FS_IOC_READ_VERITY_METADATA ioctl.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/verity | 36 ++++++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/common/verity b/common/verity
index 9a182240..38eea157 100644
--- a/common/verity
+++ b/common/verity
@@ -120,6 +120,27 @@ _restore_fsverity_signatures()
         fi
 }
 
+# Require userspace and kernel support for 'fsverity dump_metadata'.
+# $1 must be a file with fs-verity enabled.
+_require_fsverity_dump_metadata()
+{
+	local verity_file=$1
+	local tmpfile=$tmp.require_fsverity_dump_metadata
+
+	if _fsv_dump_merkle_tree "$verity_file" 2>"$tmpfile" >/dev/null; then
+		return
+	fi
+	if grep -q "^ERROR: unrecognized command: 'dump_metadata'$" "$tmpfile"
+	then
+		_notrun "Missing 'fsverity dump_metadata' command"
+	fi
+	if grep -q "^ERROR: FS_IOC_READ_VERITY_METADATA failed on '.*': Inappropriate ioctl for device$" "$tmpfile"
+	then
+		_notrun "Kernel doesn't support FS_IOC_READ_VERITY_METADATA"
+	fi
+	_fail "Unexpected output from 'fsverity dump_metadata': $(<"$tmpfile")"
+}
+
 _scratch_mkfs_verity()
 {
 	case $FSTYP in
@@ -157,6 +178,21 @@ _fsv_scratch_begin_subtest()
 	echo -e "\n# $msg"
 }
 
+_fsv_dump_merkle_tree()
+{
+	$FSVERITY_PROG dump_metadata merkle_tree "$@"
+}
+
+_fsv_dump_descriptor()
+{
+	$FSVERITY_PROG dump_metadata descriptor "$@"
+}
+
+_fsv_dump_signature()
+{
+	$FSVERITY_PROG dump_metadata signature "$@"
+}
+
 _fsv_enable()
 {
 	$FSVERITY_PROG enable "$@"
-- 
2.30.0

