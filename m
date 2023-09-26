Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 395E67AF259
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:04:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235535AbjIZSEB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:04:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57954 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235526AbjIZSEA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:04:00 -0400
Received: from mail-qt1-x82d.google.com (mail-qt1-x82d.google.com [IPv6:2607:f8b0:4864:20::82d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A694E124
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:52 -0700 (PDT)
Received: by mail-qt1-x82d.google.com with SMTP id d75a77b69052e-41814760ae1so34332251cf.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751432; x=1696356232; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=X6Ati+EqeLVccyZuz2RaSUk3+ioP3QFcOhWT02y0KiE=;
        b=3WAbG2vDA8H7dKaf19YaKMFPBc6e4tXuTFZj7/UA+5f3NlcdQe8dC2NLfZvc3mEh+o
         JLKOfh3DD4i2ZU3DrZABCwrGz9OPhhbvGl49SD1tw2/vkO84jQQB4O+FES6+7U2isZqa
         m0mWP0Ex/iT8APCe6sjk4mSOUid9VRxWQ82R+kWc42L7GvN92HPhRi47xiUcNm04W2qx
         mVeKQhhGzYrxYLiuS7sDwzYKNjBEzWDEtekLzWnaExW/8FXFeFnyZFZfPF9QsVkPhy6S
         7m1kJ9VRJhQvvstkpDOVCvHeI/mMp9W/pxsTIAhUoMCyFsJ5fVA8oEQ/Nu4+oev8ZTE1
         1RUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751432; x=1696356232;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=X6Ati+EqeLVccyZuz2RaSUk3+ioP3QFcOhWT02y0KiE=;
        b=jiOsllj91PYvD9Y29GqMZmdcQPNvNHLzW17Xb/PbgKXNQnMTtM5ezypRy9ZN+TzLcu
         Ft1uY+HeODZFmogJI2eHKAyuZGKfvQzlrg1HVL5I27Sf2wdX44IK86vPutQK5BPbuzUF
         xhpr0fj7AMyX5sh1GBUOGMN1lep2ZERLDppDRzdBfBwtE5Y+5fKLWUHMCMeoqS3vJZdW
         be5bC5DcPtoD4D9u7x2fGGx2Ac1pkU0sv0l9MNwcpbPuxdW4mwZIo/qZLYlyRDfjZsqU
         rtdGiJ+P5xf/TLm10EKLfgVHz/g6Xol44S5wul3/zhwLmXBqRrnotYSNa6sI4QEjWB95
         i0TA==
X-Gm-Message-State: AOJu0YwJgA3WSU20JdcBFxjgia3BBnvbRy2YbmWLvMhgWe12JkRUkdHB
        bdIkzKWnGZ2y5eGpzVrbXh0vBQ==
X-Google-Smtp-Source: AGHT+IHxHPofgTlk9TRSv29aYPre8S3krhnfYT4B//B01U8HprHN27b3ssd+/qdfng7V63uUJuuUyw==
X-Received: by 2002:a05:622a:5215:b0:418:11de:ce1 with SMTP id dq21-20020a05622a521500b0041811de0ce1mr7415059qtb.24.1695751431704;
        Tue, 26 Sep 2023 11:03:51 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id c1-20020ac84e01000000b00403ad6ec2e8sm2417849qtw.26.2023.09.26.11.03.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:51 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Subject: [PATCH 34/35] btrfs: add orig_logical to btrfs_bio
Date:   Tue, 26 Sep 2023 14:02:00 -0400
Message-ID: <949cdb4e3ecfaf623716a7ceb76e46a203051311.1695750478.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1695750478.git.josef@toxicpanda.com>
References: <cover.1695750478.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

When checksumming the encrypted bio on writes we need to know which
logical address this checksum is for.  At the point where we get the
encrypted bio the bi_sector is the physical location on the target disk,
so we need to save the original logical offset in the btrfs_bio.  Then
we can use this when csum'ing the bio instead of the
bio->iter.bi_sector.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/bio.c       | 9 +++++++++
 fs/btrfs/bio.h       | 3 +++
 fs/btrfs/file-item.c | 2 +-
 3 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/fs/btrfs/bio.c b/fs/btrfs/bio.c
index 90e4d4709fa3..7d6931e53beb 100644
--- a/fs/btrfs/bio.c
+++ b/fs/btrfs/bio.c
@@ -96,6 +96,7 @@ static struct btrfs_bio *btrfs_split_bio(struct btrfs_fs_info *fs_info,
 	if (bbio_has_ordered_extent(bbio)) {
 		refcount_inc(&orig_bbio->ordered->refs);
 		bbio->ordered = orig_bbio->ordered;
+		orig_bbio->orig_logical += map_length;
 	}
 	atomic_inc(&orig_bbio->pending_ios);
 	return bbio;
@@ -674,6 +675,14 @@ static bool btrfs_submit_chunk(struct btrfs_bio *bbio, int mirror_num)
 		goto fail;
 	}
 
+	/*
+	 * For fscrypt writes we will get the encrypted bio after we've remapped
+	 * our bio to the physical disk location, so we need to save the
+	 * original bytenr so we know what we're checksumming.
+	 */
+	if (bio_op(bio) == REQ_OP_WRITE && is_data_bbio(bbio))
+		bbio->orig_logical = logical;
+
 	map_length = min(map_length, length);
 	if (use_append)
 		map_length = min(map_length, fs_info->max_zone_append_size);
diff --git a/fs/btrfs/bio.h b/fs/btrfs/bio.h
index ca79decee060..5d3f53dcd6d5 100644
--- a/fs/btrfs/bio.h
+++ b/fs/btrfs/bio.h
@@ -54,11 +54,14 @@ struct btrfs_bio {
 		 * - pointer to the checksums for this bio
 		 * - original physical address from the allocator
 		 *   (for zone append only)
+		 * - original logical address, used for checksumming fscrypt
+		 *   bios.
 		 */
 		struct {
 			struct btrfs_ordered_extent *ordered;
 			struct btrfs_ordered_sum *sums;
 			u64 orig_physical;
+			u64 orig_logical;
 		};
 
 		/* For metadata reads: parentness verification. */
diff --git a/fs/btrfs/file-item.c b/fs/btrfs/file-item.c
index d925d6d98bf4..26e3bc602655 100644
--- a/fs/btrfs/file-item.c
+++ b/fs/btrfs/file-item.c
@@ -756,7 +756,7 @@ blk_status_t btrfs_csum_one_bio(struct btrfs_bio *bbio, struct bio *bio)
 	sums->len = bio->bi_iter.bi_size;
 	INIT_LIST_HEAD(&sums->list);
 
-	sums->logical = bio->bi_iter.bi_sector << SECTOR_SHIFT;
+	sums->logical = bbio->orig_logical;
 	index = 0;
 
 	shash->tfm = fs_info->csum_shash;
-- 
2.41.0

