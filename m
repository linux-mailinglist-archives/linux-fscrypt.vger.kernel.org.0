Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2F7C522CDFC
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Jul 2020 20:45:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726676AbgGXSpM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Jul 2020 14:45:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgGXSpL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Jul 2020 14:45:11 -0400
Received: from mail-pf1-x449.google.com (mail-pf1-x449.google.com [IPv6:2607:f8b0:4864:20::449])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D06FFC0619E6
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Jul 2020 11:45:11 -0700 (PDT)
Received: by mail-pf1-x449.google.com with SMTP id a25so6939402pfl.2
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Jul 2020 11:45:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=cZRHJd9vm6wSJv/XnptuJQLr+rxaeXJfolkFtRJQLFQ=;
        b=cLH6fzkpbrIyelFo1byJfRWbdqDhF3ZuMGCQS4DuqoFfUVEI6AqUb/cLmCcnxe2DB/
         NuclTLQUseIGENpT7nSaTyqpx9/aizcWbC3NKqN5eALGkn02PLzSafBJR0zP+YtgRdjx
         iiqFAGrcWbXnR1oSAceanlMou1uN1NcKZaHO7V6Fq14CfHQBbuPffCJrhM+PHcdgXacy
         ZTIPrXi3DslzIjo4fnTej7bdyl7kq0p1qIzcLMEMzdaXiKnZj5yIvjZYQny4aGeAndIA
         PQZfy+PrHHJBs5Hj0M8Ccv3m4ELMXmcv4DxI8RLO/We8K9PWuYUCvp83BPAYwnWrSsLM
         6aYA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=cZRHJd9vm6wSJv/XnptuJQLr+rxaeXJfolkFtRJQLFQ=;
        b=f6Gz2bWlHRzNsf7ZTf7uhlxifRCv2caSP9OnVYVp6OMPglf0M4ZOS6JdA5l8rL9WsU
         H86TJd8Z2N4hj18S6u5zFYVgfkMJQJ26reTG3SQkAiEiF9J2T64gYKc0Hm2jFvzcJ96L
         o40Z7qJE+ktoUnHH4BAIPrkos1yshNjmhBWvePz38Swe4PBljMCIjS1DYSNbj7dZO0UN
         N8OwjkpTVawu9UCj1GpmbsUwKCTYw29cyHlZ39cNgaXF/IOte6FEH9MG3XZH9I0VTV6+
         hb2bWj+L/EygFmMCIPiNA0LI7EkMUfFcXudbqFWie/SqsevIiXl2jjNeKzSKma7bwCyx
         QbfQ==
X-Gm-Message-State: AOAM531rBVLCQwtZMo5cWugVpTrbnw09UV91/a3Dp8JzsnGejdwxemfN
        Drf+Y88lcxIz0TGokoXTBLe4k9jXvYTRytS6skcpne67q2GwOqnayvKkI0QJj8nYxdIBh3Azfpq
        q2FU7dWgb8LtBwRWaq5+EOuC+mN7mSnRS/WcBeR9rh8bFSmaxk2gr7TnH48Pyp1HvzwNP+0g=
X-Google-Smtp-Source: ABdhPJw8fcIvmjHR7H+eb8aZqwFTcCm45Bq/Yx+3nVsrxPL6bXnXqOMUT4Dox/jUn8rhKVdlkFqNAmoD0JI=
X-Received: by 2002:a62:1acc:: with SMTP id a195mr9957629pfa.32.1595616311087;
 Fri, 24 Jul 2020 11:45:11 -0700 (PDT)
Date:   Fri, 24 Jul 2020 18:44:57 +0000
In-Reply-To: <20200724184501.1651378-1-satyat@google.com>
Message-Id: <20200724184501.1651378-4-satyat@google.com>
Mime-Version: 1.0
References: <20200724184501.1651378-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v6 3/7] iomap: support direct I/O with fscrypt using blk-crypto
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

Set bio crypt contexts on bios by calling into fscrypt when required.
No DUN contiguity checks are done - callers are expected to set up the
iomap correctly to ensure that each bio submitted by iomap will not have
blocks with incontiguous DUNs by calling fscrypt_limit_io_blocks()
appropriately.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
---
 fs/iomap/direct-io.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ec7b78e6feca..a8785bffdc7c 100644
--- a/fs/iomap/direct-io.c
+++ b/fs/iomap/direct-io.c
@@ -6,6 +6,7 @@
 #include <linux/module.h>
 #include <linux/compiler.h>
 #include <linux/fs.h>
+#include <linux/fscrypt.h>
 #include <linux/iomap.h>
 #include <linux/backing-dev.h>
 #include <linux/uio.h>
@@ -183,11 +184,14 @@ static void
 iomap_dio_zero(struct iomap_dio *dio, struct iomap *iomap, loff_t pos,
 		unsigned len)
 {
+	struct inode *inode = file_inode(dio->iocb->ki_filp);
 	struct page *page = ZERO_PAGE(0);
 	int flags = REQ_SYNC | REQ_IDLE;
 	struct bio *bio;
 
 	bio = bio_alloc(GFP_KERNEL, 1);
+	fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
+				  GFP_KERNEL);
 	bio_set_dev(bio, iomap->bdev);
 	bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
 	bio->bi_private = dio;
@@ -270,6 +274,8 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		}
 
 		bio = bio_alloc(GFP_KERNEL, nr_pages);
+		fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
+					  GFP_KERNEL);
 		bio_set_dev(bio, iomap->bdev);
 		bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
 		bio->bi_write_hint = dio->iocb->ki_hint;
-- 
2.28.0.rc0.142.g3c755180ce-goog

