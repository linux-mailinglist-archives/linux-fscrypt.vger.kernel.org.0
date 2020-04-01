Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 031B819B712
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Apr 2020 22:35:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733028AbgDAUe6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 1 Apr 2020 16:34:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:54408 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733021AbgDAUe5 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 1 Apr 2020 16:34:57 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 916E92082F;
        Wed,  1 Apr 2020 20:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585773296;
        bh=+1NW6Mkzb7xHuLjpEh9AxTsAlZnBD98KP1zGLJyrNp0=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AqHoq1ighwkpVcshZ5YOjoAvrC09TNdJZ7b2h12P3Ev2MJuQQHm4sZgvnESK/64v/
         WtuePhrsNA4fAHrtPvCFlLnRoQBOU0ejGI6psT4KFFpfUXBcqEiwbmEv/96fQRruWC
         awizldlvg7/cIKcu5GJuX5G1tVWQZvXXKiMFvic8=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 4/4] tune2fs.8: document the stable_inodes feature
Date:   Wed,  1 Apr 2020 13:32:39 -0700
Message-Id: <20200401203239.163679-5-ebiggers@kernel.org>
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
 misc/tune2fs.8.in | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/misc/tune2fs.8.in b/misc/tune2fs.8.in
index 3cf1f5ed..582d1da5 100644
--- a/misc/tune2fs.8.in
+++ b/misc/tune2fs.8.in
@@ -630,6 +630,13 @@ Limit the number of backup superblocks to save space on large filesystems.
 .B Tune2fs
 currently only supports setting this filesystem feature.
 .TP
+.B stable_inodes
+Prevent the filesystem from being shrunk or having its UUID changed, in order to
+allow the use of specialized encryption settings that make use of the inode
+numbers and UUID.
+.B Tune2fs
+currently only supports setting this filesystem feature.
+.TP
 .B uninit_bg
 Allow the kernel to initialize bitmaps and inode tables lazily, and to
 keep a high watermark for the unused inodes in a filesystem, to reduce
-- 
2.26.0.rc2.310.g2932bb562d-goog

