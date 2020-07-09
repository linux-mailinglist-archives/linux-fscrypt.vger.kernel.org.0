Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C7AA21A81B
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jul 2020 21:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726324AbgGITsp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jul 2020 15:48:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726664AbgGITsD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jul 2020 15:48:03 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43014C08E8A0
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jul 2020 12:48:03 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id y3so4179756ybf.4
        for <linux-fscrypt@vger.kernel.org>; Thu, 09 Jul 2020 12:48:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=rwbjEFtn1GWMpUE4S/kWQzWtXcP4lb72aoJySrvCSqw=;
        b=Ni3dskATOxYJ3Tcou/e65RLNqvkujfDEqEt8oCq4+JTTsuIx3HbTN0WrZ9IycRBL/O
         TJL2j7H0gJ5dCFtN9P528A9cSXAEEFM9S/d3qQ39Blq6q6GXsqpcsUuQxmLEnMSc01Ct
         IzXeUSJ4rafu5s+r01Of1jOoVwyRm/EY4m32sYcxbDTWtfWKK3J5R+N3r/qbdUdvnwoo
         k/9hbVc5Xo59Cbat+Kl6P2i5mS9X0PdbksquM3NIC/nnSiK39eepPvZwPiAmftVMoD9H
         1pescv+NQm6GgJGb1DJMeV28SVU4y756tuYAb5GrroFxPRMzWFeqjuqEB5PaD41tHPWV
         rpxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=rwbjEFtn1GWMpUE4S/kWQzWtXcP4lb72aoJySrvCSqw=;
        b=XkZ/8B1doh+/T47hAxgQdKfuxjog9OCfBsHAHi6IaQE/FsjyUZ4ZL24AwsKZ+joFhi
         TmUF7YCzKCfkXendFb86JA9ypfoTRbtnABL88u2QNgE0WVoOreTyY1zRuOOMR+Zr3QLr
         DTGv9GFODtmAM6+JCZoHKMn+sCXtAjHrnAs7SUGcvT1AQhtsF7ztmNUP3DyBA3IJaH9l
         n6eOJIiQO7IFiWzASBcjqDKH+i2C8lFG1Lnl7zD4JzE93PQ3PEH5eIhVW6pEFiHJTuiW
         Gf+lVaUH8pz5OBcd3rPMTJ58m1nQ6OF2Vj+eT9X1j2Hv600b1QYJ2mxAJ5yDxlveQMb4
         etkQ==
X-Gm-Message-State: AOAM531bQV4oT+YfT1HZxcXEoBfNdOdBp97BYeY2pKz7F3Bh5Ia9k0QR
        tv8t05r/56Ywx4zKPk7NeiySNYXdIM/lMHq0rUHp0dvEbaML21TVdohcLPD6lekktkR0fm3N4Jc
        uvR1/4hP4uALlBwnywrbjck3YlCKASrUIp+8yiDGkPU3I8bn0u4+GvI3ylTkntRce6oqpK5A=
X-Google-Smtp-Source: ABdhPJx3NvWhZ+XQotweCss427Fvg18zXF043v/X5vRII5O4su0czV7qo/Ra6b6aKypDdPmHsc2gJLC2uUs=
X-Received: by 2002:a25:5d5:: with SMTP id 204mr99009732ybf.24.1594324082481;
 Thu, 09 Jul 2020 12:48:02 -0700 (PDT)
Date:   Thu,  9 Jul 2020 19:47:50 +0000
In-Reply-To: <20200709194751.2579207-1-satyat@google.com>
Message-Id: <20200709194751.2579207-5-satyat@google.com>
Mime-Version: 1.0
References: <20200709194751.2579207-1-satyat@google.com>
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH 4/5] ext4: support direct I/O with fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     Eric Biggers <ebiggers@google.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Wire up ext4 with fscrypt direct I/O support.

Signed-off-by: Eric Biggers <ebiggers@google.com>
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
2.27.0.383.g050319c2ae-goog

