Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB9E2EA614
	for <lists+linux-fscrypt@lfdr.de>; Wed, 30 Oct 2019 23:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726596AbfJ3WUO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 30 Oct 2019 18:20:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:47242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726538AbfJ3WUO (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 30 Oct 2019 18:20:14 -0400
Received: from sol.localdomain (c-24-5-143-220.hsd1.ca.comcast.net [24.5.143.220])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CDC0420873;
        Wed, 30 Oct 2019 22:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1572474013;
        bh=39tlinMi/mwa6K8bh+AvUrEqnvDUmchorz6iz1Vb2MI=;
        h=From:To:Cc:Subject:Date:From;
        b=dsqYm+NoUlZpxlsre8/ninHtAsLPpuA5GeG76ceKYSruhHR62LS0vHKwBN0Fvt84W
         qrMaQU64T9FsPIpaBXxnIAX/h1IFURq5gGBcOcZ6HOKl5zTKAebB/mlyH2hRJQ2vYP
         2zR6VBycETR8KzV2WlJR6qHxF7CCiOXHDBdNFllo=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Subject: [PATCH] docs: fs-verity: document first supported kernel version
Date:   Wed, 30 Oct 2019 15:19:15 -0700
Message-Id: <20191030221915.229858-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.23.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

I had meant to replace these TODOs with the actual version when applying
the patches, but forgot to do so.  Do it now.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fsverity.rst | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/fsverity.rst b/Documentation/filesystems/fsverity.rst
index 3355377a2439..a95536b6443c 100644
--- a/Documentation/filesystems/fsverity.rst
+++ b/Documentation/filesystems/fsverity.rst
@@ -406,7 +406,7 @@ pages have been read into the pagecache.  (See `Verifying data`_.)
 ext4
 ----
 
-ext4 supports fs-verity since Linux TODO and e2fsprogs v1.45.2.
+ext4 supports fs-verity since Linux v5.4 and e2fsprogs v1.45.2.
 
 To create verity files on an ext4 filesystem, the filesystem must have
 been formatted with ``-O verity`` or had ``tune2fs -O verity`` run on
@@ -442,7 +442,7 @@ also only supports extent-based files.
 f2fs
 ----
 
-f2fs supports fs-verity since Linux TODO and f2fs-tools v1.11.0.
+f2fs supports fs-verity since Linux v5.4 and f2fs-tools v1.11.0.
 
 To create verity files on an f2fs filesystem, the filesystem must have
 been formatted with ``-O verity``.
-- 
2.23.0

