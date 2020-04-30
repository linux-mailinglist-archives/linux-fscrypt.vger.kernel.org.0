Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA88E1BF775
	for <lists+linux-fscrypt@lfdr.de>; Thu, 30 Apr 2020 14:00:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726900AbgD3MAJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 30 Apr 2020 08:00:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726053AbgD3MAJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 30 Apr 2020 08:00:09 -0400
Received: from mail-qv1-xf4a.google.com (mail-qv1-xf4a.google.com [IPv6:2607:f8b0:4864:20::f4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5D7EC08ED7D
        for <linux-fscrypt@vger.kernel.org>; Thu, 30 Apr 2020 05:00:08 -0700 (PDT)
Received: by mail-qv1-xf4a.google.com with SMTP id et5so6151823qvb.5
        for <linux-fscrypt@vger.kernel.org>; Thu, 30 Apr 2020 05:00:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xb7ctfgBkT8MKaWibTzyhvK9qysU0rW7SMEIFQJPgjA=;
        b=j3MV8ehiEKFgagO26nEjNhVxO4Z3rfz3PgodR90MbmrOihzmftOVMN3dBSVjw6DwcH
         NwnboOih2ghd10oscPSB9TbkVyxMFmxTmRY9cfbQYPSStmlGMGHr4pXkNtCKksXqcReZ
         VmjTcKlNEs5zmmT5nzpxh8Q4oACZ2GFvoGqw5BcrCu7lRNJhLvd8n0p8WvM7/2zMhXRC
         MChmDritFxEmgy7hFU9O/trQyxIrq47yNSgUDXcWBXHbTrr6Hx7+nBsFawKzrqskLaa2
         vz8ZbhrtwnNrqNVciVFxtHPWdZimvNauQchtfjH7114FebUU3UGoR8rZ65ov0YMMRTqZ
         cTTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xb7ctfgBkT8MKaWibTzyhvK9qysU0rW7SMEIFQJPgjA=;
        b=r/IYzIfX8dG6U/7y/HkepxN9iQYQXfbs7eWGBYjDzb1mXJfMqq0db2XqSPMfNvcWgy
         rd3ghrdDL8qttObE8qZGDIOP6O5NL2AZE9+Graq0fSfsZqOqqZ1u2rp7dRuMcqGMpJJv
         YPEcd7Td1sKMx8JLgi2iVQa8Y8tuH/Nsfer+GrhhllLTp8xoPHuRtS0fH91sr4l/nr9+
         wLrJ0f+iZzgIp4vIxZSO5YxOwU7pjVsM2Lg+9drU4IZbpne9jPMtevNQ28yXWsEbqZop
         kCA5sg6pF6A+svXmYxlRiNgvYIPlYOJ7i1/Qi7KJNbQqRAIuavJOTsrk6XtaderhuaSj
         mP8w==
X-Gm-Message-State: AGi0PuYXTZ4zrdoDleanaA+vic1Gres3xaZ1esa8wb6raLsWHLDl7tuL
        nj+q7XKEAOU4DpdJC1LZ4gREhiZo9sQ=
X-Google-Smtp-Source: APiQypJ0+JbtQIPsOVpdih60Wu/ehAdkUx4TBNQKmrynPl5SshZ274V1P85qpQJQSoRICJ+5d5v3BF8jgY8=
X-Received: by 2002:ad4:4f01:: with SMTP id fb1mr2711453qvb.162.1588248007896;
 Thu, 30 Apr 2020 05:00:07 -0700 (PDT)
Date:   Thu, 30 Apr 2020 11:59:51 +0000
In-Reply-To: <20200430115959.238073-1-satyat@google.com>
Message-Id: <20200430115959.238073-5-satyat@google.com>
Mime-Version: 1.0
References: <20200430115959.238073-1-satyat@google.com>
X-Mailer: git-send-email 2.26.2.303.gf8c07b1a785-goog
Subject: [PATCH v12 04/12] block: Make blk-integrity preclude hardware inline encryption
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

Whenever a device supports blk-integrity, make the kernel pretend that
the device doesn't support inline encryption (essentially by setting the
keyslot manager in the request queue to NULL).

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
index ff1070edbb400..c03705cbb9c9f 100644
--- a/block/blk-integrity.c
+++ b/block/blk-integrity.c
@@ -409,6 +409,13 @@ void blk_integrity_register(struct gendisk *disk, struct blk_integrity *template
 	bi->tag_size = template->tag_size;
 
 	disk->queue->backing_dev_info->capabilities |= BDI_CAP_STABLE_WRITES;
+
+#ifdef CONFIG_BLK_INLINE_ENCRYPTION
+	if (disk->queue->ksm) {
+		pr_warn("blk-integrity: Integrity and hardware inline encryption are not supported together. Disabling hardware inline encryption.\n");
+		blk_ksm_unregister(disk->queue);
+	}
+#endif
 }
 EXPORT_SYMBOL(blk_integrity_register);
 
diff --git a/block/keyslot-manager.c b/block/keyslot-manager.c
index 69f51909fc8ad..8d388cdbcd5d0 100644
--- a/block/keyslot-manager.c
+++ b/block/keyslot-manager.c
@@ -25,6 +25,9 @@
  * Upper layers will call blk_ksm_get_slot_for_key() to program a
  * key into some slot in the inline encryption hardware.
  */
+
+#define pr_fmt(fmt) "blk-crypto: " fmt
+
 #include <linux/keyslot-manager.h>
 #include <linux/atomic.h>
 #include <linux/mutex.h>
@@ -376,3 +379,19 @@ void blk_ksm_destroy(struct blk_keyslot_manager *ksm)
 	memzero_explicit(ksm, sizeof(*ksm));
 }
 EXPORT_SYMBOL_GPL(blk_ksm_destroy);
+
+bool blk_ksm_register(struct blk_keyslot_manager *ksm, struct request_queue *q)
+{
+	if (blk_integrity_queue_supports_integrity(q)) {
+		pr_warn("Integrity and hardware inline encryption are not supported together. Disabling hardware inline encryption.\n");
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
2.26.2.303.gf8c07b1a785-goog

