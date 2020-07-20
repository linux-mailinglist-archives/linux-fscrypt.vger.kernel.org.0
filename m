Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4BF59227325
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Jul 2020 01:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728108AbgGTXiA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Jul 2020 19:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728076AbgGTXhu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Jul 2020 19:37:50 -0400
Received: from mail-qt1-x849.google.com (mail-qt1-x849.google.com [IPv6:2607:f8b0:4864:20::849])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14C1AC061794
        for <linux-fscrypt@vger.kernel.org>; Mon, 20 Jul 2020 16:37:50 -0700 (PDT)
Received: by mail-qt1-x849.google.com with SMTP id j18so1358981qtr.9
        for <linux-fscrypt@vger.kernel.org>; Mon, 20 Jul 2020 16:37:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=E/vVSGidxRNqfgFvT7W0V9puYBqKI9SZ+5JR8j0m+58=;
        b=g/MoPPQO9uYrVCFue0RQVPoXmBbud7mYzW1uO00zgttEFNcBugQhJLJ0C4bLk7QMvj
         kDC/xn5b/hdZ+iLXzsYk/gNFTa6oP4Iy0Kq0MDZZYT/+Rv7z0ImMqKnxNgcrPPK5ux/Q
         /2QYuvTrbSQaOoUT4k0leV1KIHgv/PMsBeUZonX73xVlOHRzBVBFi9AAc6DEsH+2oLpX
         RtCsnGrKjhiKmt+u0hNfDmT1HQkIhvm5y2ydBSWgsnZ5BWastbRHvVHFo3TUw3hYdRMw
         nOe1InbB5hOZ5z42QMPclDxIirMKAefHotGk5eRtZM4qjRJHULvd9dCL9vPpNut3JATv
         teLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=E/vVSGidxRNqfgFvT7W0V9puYBqKI9SZ+5JR8j0m+58=;
        b=IFFIgmopoJMqQT52zFpTbpmDajbBMRomcj9R4Op0MjrdVmWbGvX041k0A+UNNzSZG1
         yXSGaSEvzpVbxSdzy0jKlo2w19w/TKdO8yC2WjrJSMfZpAoD8qvhSVy4vTKu5uuUog8x
         XP3gM7uBiEK8AtXHdcBSOVFzDqpModaRnZ5lRPn3cx2+ahBx5aDdg5OBPXLpFm/dV90w
         nTSuxrUlCIKjST5OXx5Uzswu/9PAN28OVIhjsNhcG6Sw679jxL27m5COS78n2uzfUjYp
         yzCh99KgUB0GIgoRdCQGL0K7tQ0MFUV92OC95qrNupWYfNemQbhf9HTlktuHWNCy61EM
         SiNA==
X-Gm-Message-State: AOAM531V8SwzvFPJSuIAkXCS/GBo/jeBuCMUdEW+8oXsD+k2qdzgHdi8
        YqbdwAt8vvT6e7v5xIZB6BirJUAkSqh6bLHjMZy1cK2c4dgBZK2OEMyxwlCqYhYwatc4nfR2jxX
        nvJ7EZaseCkDHjS0GesVUK1OLnsl45O6tgJSjo8CJEFCaSVLHwpF1WRn7vEbXJMwVu2nKasg=
X-Google-Smtp-Source: ABdhPJxp7mXopL0NljWOXr1p+y9+bz+KQoO/+c618p+nfllpGmix63TA/BESv20fd6MJMRipfMl8AeBqQ/w=
X-Received: by 2002:ad4:5a46:: with SMTP id ej6mr24289285qvb.52.1595288269050;
 Mon, 20 Jul 2020 16:37:49 -0700 (PDT)
Date:   Mon, 20 Jul 2020 23:37:36 +0000
In-Reply-To: <20200720233739.824943-1-satyat@google.com>
Message-Id: <20200720233739.824943-5-satyat@google.com>
Mime-Version: 1.0
References: <20200720233739.824943-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v4 4/7] ext4: support direct I/O with fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Wire up ext4 with fscrypt direct I/O support. direct I/O with fscrypt is
only supported through blk-crypto (i.e. CONFIG_BLK_INLINE_ENCRYPTION must
have been enabled, the 'inlinecrypt' mount option must have been specified,
and either hardware inline encryption support must be present or
CONFIG_BLK_INLINE_ENCYRPTION_FALLBACK must have been enabled). Further,
direct I/O on encrypted files is only supported when I/O is aligned
to the filesystem block size (which is *not* necessarily the same as the
block device's block size).

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
---
 fs/ext4/file.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/fs/ext4/file.c b/fs/ext4/file.c
index 2a01e31a032c..d534f72675d9 100644
--- a/fs/ext4/file.c
+++ b/fs/ext4/file.c
@@ -36,9 +36,11 @@
 #include "acl.h"
 #include "truncate.h"
 
-static bool ext4_dio_supported(struct inode *inode)
+static bool ext4_dio_supported(struct kiocb *iocb, struct iov_iter *iter)
 {
-	if (IS_ENABLED(CONFIG_FS_ENCRYPTION) && IS_ENCRYPTED(inode))
+	struct inode *inode = file_inode(iocb->ki_filp);
+
+	if (!fscrypt_dio_supported(iocb, iter))
 		return false;
 	if (fsverity_active(inode))
 		return false;
@@ -61,7 +63,7 @@ static ssize_t ext4_dio_read_iter(struct kiocb *iocb, struct iov_iter *to)
 		inode_lock_shared(inode);
 	}
 
-	if (!ext4_dio_supported(inode)) {
+	if (!ext4_dio_supported(iocb, to)) {
 		inode_unlock_shared(inode);
 		/*
 		 * Fallback to buffered I/O if the operation being performed on
@@ -490,7 +492,7 @@ static ssize_t ext4_dio_write_iter(struct kiocb *iocb, struct iov_iter *from)
 	}
 
 	/* Fallback to buffered I/O if the inode does not support direct I/O. */
-	if (!ext4_dio_supported(inode)) {
+	if (!ext4_dio_supported(iocb, from)) {
 		if (ilock_shared)
 			inode_unlock_shared(inode);
 		else
-- 
2.28.0.rc0.105.gf9edc3c819-goog

