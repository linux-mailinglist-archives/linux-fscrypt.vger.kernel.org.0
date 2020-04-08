Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 025531A1A80
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Apr 2020 05:57:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726648AbgDHD5U (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 7 Apr 2020 23:57:20 -0400
Received: from mail-pl1-f201.google.com ([209.85.214.201]:55410 "EHLO
        mail-pl1-f201.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726475AbgDHD5S (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 7 Apr 2020 23:57:18 -0400
Received: by mail-pl1-f201.google.com with SMTP id w11so4012805plp.22
        for <linux-fscrypt@vger.kernel.org>; Tue, 07 Apr 2020 20:57:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=R63k+AfysXRo+KgVRO7Z6nFDHUcUfFcV6SnK1eQRL6M=;
        b=EbA4+PTDy2+dipLkMxCGkSOn3xK3neIY4SLpHSjfVMC8UMOcn6o/Nw/1JbY8nYjtqB
         tABJBFWJEJmgNu8RcJT4kbUo0F980e48dMipw3hYe985GvZ+IXqD6muziFCcEFghtg2S
         8w42m9TeIMdmKp8Cj8uAcxnT188v3/6ig7aq51qrIQ09GES4aMaQzydyzMj8EqoPg3kx
         f2H2/+Om8n00RcqYl7vfTwwsLRM+C+mrOZHe0qfjVph+Z4Oy64Ry+yrq2q8tCHkiff2N
         zF1wI+Fcqee7eU6oOsnJ8MNKrIuO6sRwQHjzlUwWytrU+v6REm3F2uLDMN2FAVTwz8oz
         vsSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=R63k+AfysXRo+KgVRO7Z6nFDHUcUfFcV6SnK1eQRL6M=;
        b=nI1GqM+cJB/id984ed8ocIHUuThSEboQciMV2VpAbL5NXSIdfuI+yCbdXm6skOAJhC
         a4cX5G70N73iCGn4GU7E8UCDHNssSOFSzeGl0kgGv+9BBuDH6O5GtrYAaeIEMPLauFhd
         CXr75bHG8rDb/GlXNdFXSlV7KKXywvrMi+X3l4OzMN55ZrDVClrO6LAlb5b37dQQOwEI
         aHd7wltAvtnfsiiSP86YR+T3nGhM9RCb/Yfcn/7ms8bsnYBTy7yjKIsmSRKDSftkGias
         ezFy5c8ERLTHFfYE1p0gcrtsq45YP+rymRqNTLV6znMoWoo55OwajEnTBEwx6flBsG/s
         D9iw==
X-Gm-Message-State: AGi0Pua4HMUYps/RYz0+iqAQyHj62O181or42gH1oPtESfe8dkw7KY8H
        8f96KwtlKehzZ7S/mcyzSsDqqnKrI/s=
X-Google-Smtp-Source: APiQypJ9qpq8KunwOUGMv+PZhAX21JVqOelW4cxBH/GQHSsxncC5enjkQSMfCbJNkSXIDmd7pSvCVX1fIm4=
X-Received: by 2002:a17:90a:c583:: with SMTP id l3mr3082112pjt.84.1586318236101;
 Tue, 07 Apr 2020 20:57:16 -0700 (PDT)
Date:   Tue,  7 Apr 2020 20:56:46 -0700
In-Reply-To: <20200408035654.247908-1-satyat@google.com>
Message-Id: <20200408035654.247908-5-satyat@google.com>
Mime-Version: 1.0
References: <20200408035654.247908-1-satyat@google.com>
X-Mailer: git-send-email 2.26.0.110.g2183baf09c-goog
Subject: [PATCH v10 04/12] block: Make blk-integrity preclude hardware inline encryption
From:   Satya Tangirala <satyat@google.com>
To:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     Barani Muthukumaran <bmuthuku@qti.qualcomm.com>,
        Kuohong Wang <kuohong.wang@mediatek.com>,
        Kim Boojin <boojin.kim@samsung.com>,
        Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Whenever a device supports blk-integrity, the kernel will now always
pretend that the device doesn't support inline encryption (essentially
by setting the keyslot manager in the request queue to NULL).

There's no hardware currently that supports both integrity and inline
encryption. However, it seems possible that there will be such hardware
in the near future (like the NVMe key per I/O support that might support
both inline encryption and PI).

But properly integrating both features is not trivial, and without
real hardware that implements both, it is difficult to tell if it will
be done correctly by the majority of hardware that support both.
So it seems best not to support both features together right now, and
to decide what to do at probe time.

Signed-off-by: Satya Tangirala <satyat@google.com>
---
 block/bio-integrity.c   |  3 +++
 block/blk-integrity.c   |  7 +++++++
 block/keyslot-manager.c | 19 +++++++++++++++++++
 include/linux/blkdev.h  | 30 ++++++++++++++++++++++++++++++
 4 files changed, 59 insertions(+)

diff --git a/block/bio-integrity.c b/block/bio-integrity.c
index bf62c25cde8f4..3579ac0f6ec1f 100644
--- a/block/bio-integrity.c
+++ b/block/bio-integrity.c
@@ -42,6 +42,9 @@ struct bio_integrity_payload *bio_integrity_alloc(struct bio *bio,
 	struct bio_set *bs = bio->bi_pool;
 	unsigned inline_vecs;
 
+	if (WARN_ON_ONCE(bio_has_crypt_ctx(bio)))
+		return ERR_PTR(-EOPNOTSUPP);
+
 	if (!bs || !mempool_initialized(&bs->bio_integrity_pool)) {
 		bip = kmalloc(struct_size(bip, bip_inline_vecs, nr_vecs), gfp_mask);
 		inline_vecs = nr_vecs;
diff --git a/block/blk-integrity.c b/block/blk-integrity.c
index ff1070edbb400..b45711fc37df4 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -409,6 +409,13 @@ void blk_integrity_register(struct gendisk *disk, struct blk_integrity *template
 	bi->tag_size = template->tag_size;
 
 	disk->queue->backing_dev_info->capabilities |= BDI_CAP_STABLE_WRITES;
+
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	if (disk->queue->ksm) {
+		pr_warn("blk-integrity: Integrity and hardware inline encryption are not supported together. Unregistering keyslot manager from request queue, to disable hardware inline encryption.\n");
+		blk_ksm_unregister(disk->queue);
+	}
+#endif
 }
 EXPORT_SYMBOL(blk_integrity_register);
 
diff --git a/block/keyslot-manager.c b/block/keyslot-manager.c
index bae8d67a1f3fd..7cdd428f343e8 100644
--- a/block/keyslot-manager.c
+++ b/block/keyslot-manager.c
@@ -25,6 +25,9 @@
  * Upper layers will call blk_ksm_get_slot_for_key() to program a
  * key into some slot in the inline encryption hardware.
  */
+
+#define pr_fmt(fmt) "blk_crypto: " fmt
+
 #include <crypto/algapi.h>
 #include <linux/keyslot-manager.h>
 #include <linux/atomic.h>
@@ -376,3 +379,19 @@ void blk_ksm_destroy(struct blk_keyslot_manager *ksm)
 	memzero_explicit(ksm, sizeof(*ksm));
 }
 EXPORT_SYMBOL_GPL(blk_ksm_destroy);
+
+bool blk_ksm_register(struct blk_keyslot_manager *ksm, struct request_queue *q)
+{
+	if (blk_integrity_queue_supports_integrity(q)) {
+		pr_warn("Integrity and hardware inline encryption are not supported together. Hardware inline encryption is being disabled.\n");
+		return false;
+	}
+	q->ksm = ksm;
+	return true;
+}
+EXPORT_SYMBOL_GPL(blk_ksm_register);
+
+void blk_ksm_unregister(struct request_queue *q)
+{
+	q->ksm = NULL;
+}
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 98aae4638fda9..17738dab8ae04 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -1562,6 +1562,12 @@ struct blk_integrity *bdev_get_integrity(struct block_device *bdev)
 	return blk_get_integrity(bdev->bd_disk);
 }
 
+static inline bool
+blk_integrity_queue_supports_integrity(struct request_queue *q)
+{
+	return q->integrity.profile;
+}
+
 static inline bool blk_integrity_rq(struct request *rq)
 {
 	return rq->cmd_flags & REQ_INTEGRITY;
@@ -1642,6 +1648,11 @@ static inline struct blk_integrity *blk_get_integrity(struct gendisk *disk)
 {
 	return NULL;
 }
+static inline bool
+blk_integrity_queue_supports_integrity(struct request_queue *q)
+{
+	return false;
+}
 static inline int blk_integrity_compare(struct gendisk *a, struct gendisk *b)
 {
 	return 0;
@@ -1693,6 +1704,25 @@ static inline struct bio_vec *rq_integrity_vec(struct request *rq)
 
 #endif /* CONFIG_BLK_DEV_INTEGRITY */
 
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+
+bool blk_ksm_register(struct blk_keyslot_manager *ksm, struct request_queue *q);
+
+void blk_ksm_unregister(struct request_queue *q);
+
+#else /* CONFIG_BLK_INLINE_ENCRYPTION */
+
+static inline bool blk_ksm_register(struct blk_keyslot_manager *ksm,
+				    struct request_queue *q)
+{
+	return true;
+}
+
+static inline void blk_ksm_unregister(struct request_queue *q) { }
+
+#endif /* CONFIG_BLK_INLINE_ENCRYPTION */
+
+
 struct block_device_operations {
 	int (*open) (struct block_device *, fmode_t);
 	void (*release) (struct gendisk *, fmode_t);
-- 
2.26.0.110.g2183baf09c-goog

