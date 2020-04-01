Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 451F819B713
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Apr 2020 22:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733044AbgDAUe6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 1 Apr 2020 16:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54406 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733018AbgDAUe5 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 1 Apr 2020 16:34:57 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 5B10A20BED;
        Wed,  1 Apr 2020 20:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585773296;
        bh=asV0FOHdhlZH5ZrfsvPkfpWgqdAVrxpW3yMEjV5dxJ0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=IbnBYal/8lTLmc4T5JqZG811IKIJIvFd+mt1bHZJ6avPcHMh1s2+feqKAkpBLah99
         N1ci+2tv4x3FpvtcrC9MCHI8pUZjgvWxIJceQzpBV+wkvkRIvU4+NnfgVEdmB593eP
         sHzbtmvCyto5Z1oqswH1R4AQQmzf7SSIK0kdFAx8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 3/4] ext4.5: document the stable_inodes feature
Date:   Wed,  1 Apr 2020 13:32:38 -0700
Message-Id: <20200401203239.163679-4-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.0.rc2.310.g2932bb562d-goog
In-Reply-To: <20200401203239.163679-1-ebiggers@kernel.org>
References: <20200401203239.163679-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 misc/ext4.5.in | 16 ++++++++++++++++
 1 file changed, 16 insertions(+)

diff --git a/misc/ext4.5.in b/misc/ext4.5.in
index 1db61a5f..90bc4f88 100644
--- a/misc/ext4.5.in
+++ b/misc/ext4.5.in
@@ -299,6 +299,20 @@ feature is essentially a more extreme version of sparse_super and is
 designed to allow a much larger percentage of the disk to have
 contiguous blocks available for data files.
 .TP
+.B stable_inodes
+.br
+Marks the filesystem's inode numbers and UUID as stable.
+.BR resize2fs (8)
+will not allow shrinking a filesystem with this feature, nor
+will
+.BR tune2fs (8)
+allow changing its UUID.  This feature allows the use of specialized encryption
+settings that make use of the inode numbers and UUID.  Note that the
+.B encrypt
+feature still needs to be enabled separately.
+.B stable_inodes
+is a "compat" feature, so old kernels will allow it.
+.TP
 .B uninit_bg
 .br
 This ext4 file system feature indicates that the block group descriptors
@@ -788,6 +802,8 @@ ext4, 4.13
 ext4, 5.2
 .IP "\fBverity\fR" 2i
 ext4, 5.4
+.IP "\fBstable_inodes\fR" 2i
+ext4, 5.5
 .SH SEE ALSO
 .BR mke2fs (8),
 .BR mke2fs.conf (5),
-- 
2.26.0.rc2.310.g2932bb562d-goog

