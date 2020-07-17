Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 09B2D2230A0
	for <lists+linux-fscrypt@lfdr.de>; Fri, 17 Jul 2020 03:45:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726803AbgGQBpx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 16 Jul 2020 21:45:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726593AbgGQBps (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 16 Jul 2020 21:45:48 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A669C08C5DB
        for <linux-fscrypt@vger.kernel.org>; Thu, 16 Jul 2020 18:45:48 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id m81so9523385ybf.6
        for <linux-fscrypt@vger.kernel.org>; Thu, 16 Jul 2020 18:45:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zp9IyNE/WOqMjmmUo5OQb7An9Jck4EABFW2ZtXIp0J8=;
        b=p36HscUchAg0CPB1IVlLAHSXs2vt/CAtvnGZGYh+pgGb8ff5pnVy92OpuvFkRtll4M
         SI5aSrhV3PxrLbwz17jamuLN6negVlYOyUO0lVR594tXatTmLzOco1s3uJGTt9G0c02T
         oGCMZyhVeE5Rx/Y4UrAqp28VHMbYuQav1xwBQCWuZUTwsEly/5H7VsNZS6EQ79Dy4jsm
         ylGUbOu6BuqAvds98BLPpY+r2Ujizq6ziG99s99QZJPq2K6KpQk33kIgRGXyAgj8CE8A
         e/8DA/xD/kOPAsUIfxdTPXOBYEdxznO4bFVFYb8uJoYP8nKKJ9E5RyrGSz68UIXgrnZx
         mu5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zp9IyNE/WOqMjmmUo5OQb7An9Jck4EABFW2ZtXIp0J8=;
        b=rGAm9Zc2JddSn7c5J2be2NDxdEIYnt1Q3swrhLk3DOJoNWQxHcD4XCHCnq7P6bSoW6
         qYXNFH8OgxASv+hnMGke7bJrn/tqcHcvMjlCDVxPBg9V1gI9T9HESUji14G4gxpuWHHA
         L2PPwlTgB7Ip+dwb52hZLPISc+ciMKdoiGAtIN5xkMYBiNrTsHZ6NifhN84CQALUONjx
         JlXYVYro2ovPCoRWQxP13L9h8Lcg5J7TIsOm3mX4ibkbsFkQLN6cq0+34MY+QB120e7M
         8zn++B7eJL3ZZQYrwjOCi25+0C87ZvcbfW6DtBN/cWzcKzoERK9jsIS8dcNUq+5Qk1Iv
         vuuQ==
X-Gm-Message-State: AOAM530jgaTdIqkWVxyD7CKIRiqbtMlDBawVDlEWWrZvFSL8wtaBAth7
        u+webJn3+b5VmTD1zIdS6CO+Lo7S1f36/9M2n5fsWHf2Fi6HycB76ukAsPAWSAf0pY9xV3wv0g/
        MT0nmMqmj82wdmLnS2psRVWoHGPgcWT5Jg7B8vOpD1ElBypIMn79E7aZhEtXz26QpV5TonvI=
X-Google-Smtp-Source: ABdhPJzr5GCoe/5L+0bMuPjqymASle/2ldfXTMtsEz86fUAPPo0bs236xCphulrBw+iau6eQYoDrV+vdm10=
X-Received: by 2002:a25:4c81:: with SMTP id z123mr10656827yba.309.1594950347400;
 Thu, 16 Jul 2020 18:45:47 -0700 (PDT)
Date:   Fri, 17 Jul 2020 01:45:35 +0000
In-Reply-To: <20200717014540.71515-1-satyat@google.com>
Message-Id: <20200717014540.71515-3-satyat@google.com>
Mime-Version: 1.0
References: <20200717014540.71515-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v3 2/7] direct-io: add support for fscrypt using blk-crypto
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

Set bio crypt contexts on bios by calling into fscrypt when required,
and explicitly check for DUN continuity when adding pages to the bio.
(While DUN continuity is usually implied by logical block contiguity,
this is not the case when using certain fscrypt IV generation methods
like IV_INO_LBLK_32).

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
---
 fs/direct-io.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/fs/direct-io.c b/fs/direct-io.c
index 6d5370eac2a8..f27f7e3780ee 100644
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
@@ -411,6 +412,7 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 	      sector_t first_sector, int nr_vecs)
 {
 	struct bio *bio;
+	struct inode *inode = dio->inode;
 
 	/*
 	 * bio_alloc() is guaranteed to return a bio when allowed to sleep and
@@ -418,6 +420,9 @@ dio_bio_alloc(struct dio *dio, struct dio_submit *sdio,
 	 */
 	bio = bio_alloc(GFP_KERNEL, nr_vecs);
 
+	fscrypt_set_bio_crypt_ctx(bio, inode,
+				  sdio->cur_page_fs_offset >> inode->i_blkbits,
+				  GFP_KERNEL);
 	bio_set_dev(bio, bdev);
 	bio->bi_iter.bi_sector = first_sector;
 	bio_set_op_attrs(bio, dio->op, dio->op_flags);
@@ -782,9 +787,17 @@ static inline int dio_send_cur_page(struct dio *dio, struct dio_submit *sdio,
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
2.28.0.rc0.105.gf9edc3c819-goog

