Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B17EA3246F5
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Feb 2021 23:37:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbhBXWhe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Feb 2021 17:37:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:58060 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235409AbhBXWhc (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Feb 2021 17:37:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2B76A64F03;
        Wed, 24 Feb 2021 22:36:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614206212;
        bh=oTVCwPzecV6I2cZ5E15iVdMSPRBuTMWbFl4v1zgMrYA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=beAfwZxoJAY8sQ5Uo6e0LQcKi38ZFjh0eagee0mOjJKX9u6A5QHdJMztMPs7rLPvl
         dcApBKca4imWpawr2+P/HpzcFn0MzqugvW+dSitd7rZGBK4nZd0Ksgxt9JnxN8I9b2
         sPTbQ5TH0dU2kUFees9x3INtQHOntJT2cf/pQ/qWVjE/fEeZrvujYze0VanitG4hRC
         xq0E46VdiSNW0eMmfehtakKejEXWCBWFajLMdsPMgh4/EkG2/l54GswR1XV+adTRQ8
         Kg6gudNNuXF9VwTyPxnjZw7ilcEVwMj0Tzs5YunD+s3K6WJ3WD3f5+Ni8DlhJj19pu
         gzJxV33iwj67w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Theodore Ts'o <tytso@mit.edu>,
        Victor Hsieh <victorhsieh@google.com>
Subject: [PATCH v2 2/4] generic: add helpers for dumping fs-verity metadata
Date:   Wed, 24 Feb 2021 14:35:35 -0800
Message-Id: <20210224223537.110491-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.30.1
In-Reply-To: <20210224223537.110491-1-ebiggers@kernel.org>
References: <20210224223537.110491-1-ebiggers@kernel.org>
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
2.30.1

