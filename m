Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E7E321A81D
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jul 2020 21:48:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726624AbgGITsr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jul 2020 15:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39844 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726615AbgGITsD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jul 2020 15:48:03 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5EB61C08E876
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jul 2020 12:48:01 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id o34so2465003pgm.18
        for <linux-fscrypt@vger.kernel.org>; Thu, 09 Jul 2020 12:48:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=F8Vh+2Oj0e1Bz4p4CaEpLpu89IEB8oilLTMr2JnBHtA=;
        b=n/XchN266fqGBoCIT70QRrbSKL8BhsIGh3atkfrL+0wfDq/ITuCBBAwQFiwD29zrHo
         RjO2JizNIiO3Rvwi0LtaaItm6GvUOons1saevQ9aIy9GCDsecu+O5x3aZvIqzhIwt6Ap
         jwBA+lkwIT8AlS4+zuBI2BDea413RQdLMek8QcT8+eMzDoxlqYty2NGOEtoAgG3ViD5k
         uLRAbg36Cjuz6m/+QQmmfQPX3S/WRrOaid2M3uJ0/+vad0TZ6VHnsBsCgxr4A4AoOHK0
         omL+w4IbITj0XhF1IO0CaTO2QXaxuLEqIMNw+IgjiorB+/s2cF9r9dCip0/PmtPIZn/l
         w6ng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=F8Vh+2Oj0e1Bz4p4CaEpLpu89IEB8oilLTMr2JnBHtA=;
        b=cPWlbYLrGyfxe3ojsKitM7Ts++KAv5MCBJgdvIxqRzAGbs+2u/V42mSZLrHmqy9rYg
         PBvCanOPxw3I9EWJaLIY0em+h5lc04qyIIwGLB1PEt8D6vE7JYX265RArCQ7ZCfS/Y7Z
         PFko0KkUwtv6YDrw2n932eGtCbNFZYJHhOHaazZtPLXsp5s83ycbusNAtQDmptHTJkBb
         iIlINYot7TK6wVdTXu1xp5WY/P52r+CAxKW536b58iKovCvoRyAXPUqDA7bAClVMVmLS
         5L6d+Ba8H84B10TeNCGorOVGPID26URqgqZAJAXkiwH4mZpTm7UgjPmrodar8Zjpebnz
         QQQQ==
X-Gm-Message-State: AOAM532WS/CranKMvz7hgwDJJkRkW4RJrYhqH3sNyZayZ2igTcu2z2SZ
        FC5td9ZLb1j1KOdM7aTQatdL5yir1oLiPVPtW8oNomKvMYL7gJMy86MuNyyqOaaQWPUahtO35q8
        9/sDYCU/rnzYFqTkVj02Mwt4wNO7flzzGiOJDOLHaNZvaB4j7GY6D1UPtPBRLhjgzsOg24OE=
X-Google-Smtp-Source: ABdhPJwgF0eduoVEqL+5EnB4NT5k175DYmVz+vnVdiaT3ayIkgmltIZBeFIoEPNUTNM+7geNefWVH9TuAAQ=
X-Received: by 2002:a17:902:a50c:: with SMTP id s12mr41269918plq.119.1594324080790;
 Thu, 09 Jul 2020 12:48:00 -0700 (PDT)
Date:   Thu,  9 Jul 2020 19:47:49 +0000
In-Reply-To: <20200709194751.2579207-1-satyat@google.com>
Message-Id: <20200709194751.2579207-4-satyat@google.com>
Mime-Version: 1.0
References: <20200709194751.2579207-1-satyat@google.com>
X-Mailer: git-send-email 2.27.0.383.g050319c2ae-goog
Subject: [PATCH 3/5] iomap: support direct I/O with fscrypt using blk-crypto
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

Wire up iomap direct I/O with the fscrypt additions for direct I/O,
and set bio crypt contexts on bios when appropriate.

Signed-off-by: Eric Biggers <ebiggers@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
---
 fs/iomap/direct-io.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/fs/iomap/direct-io.c b/fs/iomap/direct-io.c
index ec7b78e6feca..1e123d785199 100644
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
@@ -253,6 +257,7 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		ret = nr_pages;
 		goto out;
 	}
+	nr_pages = fscrypt_limit_dio_pages(inode, pos, nr_pages);
 
 	if (need_zeroout) {
 		/* zero out from the start of the block to the write offset */
@@ -270,6 +275,8 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		}
 
 		bio = bio_alloc(GFP_KERNEL, nr_pages);
+		fscrypt_set_bio_crypt_ctx(bio, inode, pos >> inode->i_blkbits,
+					  GFP_KERNEL);
 		bio_set_dev(bio, iomap->bdev);
 		bio->bi_iter.bi_sector = iomap_sector(iomap, pos);
 		bio->bi_write_hint = dio->iocb->ki_hint;
@@ -307,6 +314,7 @@ iomap_dio_bio_actor(struct inode *inode, loff_t pos, loff_t length,
 		copied += n;
 
 		nr_pages = iov_iter_npages(dio->submit.iter, BIO_MAX_PAGES);
+		nr_pages = fscrypt_limit_dio_pages(inode, pos, nr_pages);
 		iomap_dio_submit_bio(dio, iomap, bio, pos);
 		pos += n;
 	} while (nr_pages);
-- 
2.27.0.383.g050319c2ae-goog

