Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 762332B66DB
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Nov 2020 15:11:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387914AbgKQOH2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Nov 2020 09:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729706AbgKQOHX (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Nov 2020 09:07:23 -0500
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EDF6FC061A4A
        for <linux-fscrypt@vger.kernel.org>; Tue, 17 Nov 2020 06:07:20 -0800 (PST)
Received: by mail-pg1-x54a.google.com with SMTP id l7so4179188pgq.16
        for <linux-fscrypt@vger.kernel.org>; Tue, 17 Nov 2020 06:07:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=4NJdRU1Ce0aa6Hnfqmub71YUmFd4Qx8kk5Y17DesY40=;
        b=nFNLxAfPd8e/zZTqlZUXpXuN77+dJdfeaniNFRSeDnLdmkHZ4pPlCypUrVhliOogm2
         4Dwh4eHqmw2aUK8kmS7CCa6ww0SDvMftt2FkxmnXssuFtIw0EusEu5Tkclj14gnChFDP
         nxiC5qrIaleDvreRVgMA2Wlvc7e6OAIU8ncMChxF9U+5y5/JiD5FTbKCl+/WuKfwvoEH
         mCKaCC4qnI+2FSmVaNkQ7Him8OftmfrHMw8NaMSBnAohoHm15k5RFsSppzf8zmthwEic
         mYwEOwBuIURqwBhUSgbh3+kM8mQOu63f4FrhK7OWUC5IlMyZLtGBLvhREdbtOF4tBIKo
         hkEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=4NJdRU1Ce0aa6Hnfqmub71YUmFd4Qx8kk5Y17DesY40=;
        b=K65HYbir4FglLUzIFIaQ8dkMKTRT66hC31/YtEk4E0Ox7e2Lz6+Rdha37/zxGGVvN5
         vQAVVJODPk7djuUL6Jqy9ps8SSkUnuffpoyDO+HpZZD2p9B4nrpChcYlIr6HTse+5cos
         MY8f4vtXlSbiTzJOGhk/XmBJzDEminMhCOZ2eJT9NJF1NAEEknZbhY3+gAfF9e+80ltz
         jIQnUuQB1YldOcsmzlcrfU+wL1xZdcnoZpiC/DH7jmHJHnss8n471oLv+8rjBGgYlPIO
         r/mEniKC25uS0JKzZqsqz2OuIIsPtv0oaUXkG+2s0CkXj5YCISkHGfQRxZ4gHjanAOB3
         pLbg==
X-Gm-Message-State: AOAM5329L9hamEcXq0NVqMA5tqk5bqKAwTuu/gHjOhaKQiSZHMp8Xtl4
        1lmbM/LDG0B06XMPq852lRmFKnjVNeA=
X-Google-Smtp-Source: ABdhPJxfrRrknOI/BvOJaGPc6TEIdJJ1naDUKZko8kN45MeyLyMTe361mEhiYF+cx+Qes0o2OJZjXCGY5eY=
Sender: "satyat via sendgmr" <satyat@satyaprateek.c.googlers.com>
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:a17:90a:8043:: with SMTP id
 e3mr4901058pjw.52.1605622040427; Tue, 17 Nov 2020 06:07:20 -0800 (PST)
Date:   Tue, 17 Nov 2020 14:07:04 +0000
In-Reply-To: <20201117140708.1068688-1-satyat@google.com>
Message-Id: <20201117140708.1068688-5-satyat@google.com>
Mime-Version: 1.0
References: <20201117140708.1068688-1-satyat@google.com>
X-Mailer: git-send-email 2.29.2.299.gdc1121823c-goog
Subject: [PATCH v7 4/8] direct-io: add support for fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        Eric Biggers <ebiggers@google.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Set bio crypt contexts on bios by calling into fscrypt when required,
and explicitly check for DUN continuity when adding pages to the bio.
(While DUN continuity is usually implied by logical block contiguity,
this is not the case when using certain fscrypt IV generation methods
like IV_INO_LBLK_32).

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
Reviewed-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/direct-io.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index d53fa92a1ab6..f6672c4030e3 100644
--- a/fs/direct-io.c
+++ b/fs/direct-io.c
@@ -24,6 +24,7 @@
 #include <linux/module.h>
 #include <linux/types.h>
 #include <linux/fs.h>
+#include <linux/fscrypt.h>
 #include <linux/mm.h>
 #include <linux/slab.h>
 #include <linux/highmem.h>
@@ -392,6 +393,7 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 	      sector_t first_sector, int nr_vecs)
 {
 	struct bio *bio;
+	struct inode *inode = dio->inode;
 
 	/*
 	 * bio_alloc() is guaranteed to return a bio when allowed to sleep and
@@ -399,6 +401,9 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 	 */
 	bio = bio_alloc(GFP_KERNEL, nr_vecs);
 
+	fscrypt_set_bio_crypt_ctx(bio, inode,
+				  sdio->cur_page_fs_offset >> inode->i_blkbits,
+				  GFP_KERNEL);
 	bio_set_dev(bio, bdev);
 	bio->bi_iter.bi_sector = first_sector;
 	bio_set_op_attrs(bio, dio->op, dio->op_flags);
@@ -763,9 +768,17 @@ static inline int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
 		 * current logical offset in the file does not equal what would
 		 * be the next logical offset in the bio, submit the bio we
 		 * have.
+		 *
+		 * When fscrypt inline encryption is used, data unit number
+		 * (DUN) contiguity is also required.  Normally that's implied
+		 * by logical contiguity.  However, certain IV generation
+		 * methods (e.g. IV_INO_LBLK_32) don't guarantee it.  So, we
+		 * must explicitly check fscrypt_mergeable_bio() too.
 		 */
 		if (sdio->final_block_in_bio != sdio->cur_page_block ||
-		    cur_offset != bio_next_offset)
+		    cur_offset != bio_next_offset ||
+		    !fscrypt_mergeable_bio(sdio->bio, dio->inode,
+					   cur_offset >> dio->inode->i_blkbits))
 			dio_bio_submit(dio, sdio);
 	}
 
-- 
2.29.2.299.gdc1121823c-goog

