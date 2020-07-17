Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18D51223067
	for <lists+linux-fscrypt@lfdr.de>; Fri, 17 Jul 2020 03:35:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726907AbgGQBfc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 16 Jul 2020 21:35:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726401AbgGQBfa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 16 Jul 2020 21:35:30 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9730C08C5DB
        for <linux-fscrypt@vger.kernel.org>; Thu, 16 Jul 2020 18:35:29 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id i203so9509983yba.9
        for <linux-fscrypt@vger.kernel.org>; Thu, 16 Jul 2020 18:35:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=zp9IyNE/WOqMjmmUo5OQb7An9Jck4EABFW2ZtXIp0J8=;
        b=EcPT5iw6xeAfEjdlPbda6DoINJs/j9jKP2TGre8RBeZXNcyIRuqos8GS/JPjNxyyMj
         aARz+rkyGL52RWpzFM5BJ3zkR/4wfsdnrw+1luAFREm/VEQT+l2s5cpIKsr+5uKeFMH4
         WY51ds7oCW7o+7bxVZeVdvBRNakPa9eZZmcbTSZ4YdYGuLV6Q/SugNCpoAJkT93/jfJb
         IGJddYgCOXxJUJ+GqNK5dO62cUYyve5r5yM+KtVqyAb2Zs2BUOSmw7Fs3p41vxvgdu5b
         24MANUxf9LZQryIjThNYfZtFGr6rsTY31QgdC5WUa3iwxTm6vikksUZPQJEA49/6nHBM
         jWDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=zp9IyNE/WOqMjmmUo5OQb7An9Jck4EABFW2ZtXIp0J8=;
        b=M6x/TAtc5bBrOCFSZ7HN28ZQOUQwULHHicIJQqgwLzPHN/Eh68YrkaYLaEBWjt5h/5
         EsIkyaFeCfHYN7+qJEKkKDBZid5FpAfJorWc26LyAe1S/eF3UUTIi/o54q3kAO02vSdd
         gn9ZfAnkX5T24Jbvt/cyIIPAH0MA9kdz995ob0BBfa9m8r+Gqam3zPgriFHBXpCgbbJ2
         NoZA2n6kViOklcHDXZfUPAtA9SOv3DlGVUgCL7kjNJCBAHRjAKLjEkQl2Q+vkFR8kHoe
         M0KNs2+a+GDUuJL9KDEdNuu5GDPs2CKF1TQM2ucR4U7exP5xfkQIVYPXpdlpIefpG+Bi
         8ung==
X-Gm-Message-State: AOAM530HbDUBWyWn1sj1IPpPAAxqZ7dEl+kRzsFV+WEtQeyRmTlwOJyQ
        iksXnOHNJ5K16/HlACZkzrAO2WMKhRTdC5WcVnH8BiKGMTYMgmiaAhPkLvrNkT5k43W4/KU1TBp
        9S/XnPxTYbSBxcVbrA2/FQjq866TdflMdfQSrnmOGWpOs3nWnDKsxUHXoTuzJ4Q2UyBc5BcM=
X-Google-Smtp-Source: ABdhPJxs8eFAsth37g1R47hI62Mpm1RAZyjhJ4mmlKAvDAiqG/78AzVwzEyzIKJIVFj3OeeEfj/R+GGoZ6o=
X-Received: by 2002:a25:e481:: with SMTP id b123mr9697382ybh.126.1594949728932;
 Thu, 16 Jul 2020 18:35:28 -0700 (PDT)
Date:   Fri, 17 Jul 2020 01:35:13 +0000
In-Reply-To: <20200717013518.59219-1-satyat@google.com>
Message-Id: <20200717013518.59219-3-satyat@google.com>
Mime-Version: 1.0
References: <20200717013518.59219-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v2 2/7] direct-io: add support for fscrypt using blk-crypto
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

