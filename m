Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E8A2AFAB4
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 Nov 2020 22:49:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726096AbgKKVtN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 11 Nov 2020 16:49:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:53826 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725933AbgKKVtN (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 11 Nov 2020 16:49:13 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C55DC20825;
        Wed, 11 Nov 2020 21:49:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605131353;
        bh=JVmGaD5Z7NTFcsanYPb7xRpsUe07enkHt66SrD0XKeE=;
        h=From:To:Cc:Subject:Date:From;
        b=syYPIbNK/Q8/Eoz2Vh1BOt+qiT/WPSzJW6+qaqFkw3ZJMCmPywBNoNXGH5ht9Z+iA
         /y0HC3Y1CG2KnDY4EjFXWklHMmSNHZJsIoW3c0ZRXze9pH5mUBdrmpdu1ynA+dmkjo
         Y/GnyyyH2Ydhjw0WrHlCsZir1uS6QIJfu1q0qiQ4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>
Subject: [PATCH v2] block/keyslot-manager: prevent crash when num_slots=1
Date:   Wed, 11 Nov 2020 13:48:55 -0800
Message-Id: <20201111214855.428044-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.29.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

If there is only one keyslot, then blk_ksm_init() computes
slot_hashtable_size=1 and log_slot_ht_size=0.  This causes
blk_ksm_find_keyslot() to crash later because it uses
hash_ptr(key, log_slot_ht_size) to find the hash bucket containing the
key, and hash_ptr() doesn't support the bits == 0 case.

Fix this by making the hash table always have at least 2 buckets.

Tested by running:

    kvm-xfstests -c ext4 -g encrypt -m inlinecrypt \
                 -o blk-crypto-fallback.num_keyslots=1

Fixes: 1b2628397058 ("block: Keyslot Manager for Inline Encryption")
Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 block/keyslot-manager.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/block/keyslot-manager.c b/block/keyslot-manager.c
index 35abcb1ec051d..86f8195d8039e 100644
--- a/block/keyslot-manager.c
+++ b/block/keyslot-manager.c
@@ -103,6 +103,13 @@ int blk_ksm_init(struct blk_keyslot_manager *ksm, unsigned int num_slots)
 	spin_lock_init(&ksm->idle_slots_lock);
 
 	slot_hashtable_size = roundup_pow_of_two(num_slots);
+	/*
+	 * hash_ptr() assumes bits != 0, so ensure the hash table has at least 2
+	 * buckets.  This only makes a difference when there is only 1 keyslot.
+	 */
+	if (slot_hashtable_size < 2)
+		slot_hashtable_size = 2;
+
 	ksm->log_slot_ht_size = ilog2(slot_hashtable_size);
 	ksm->slot_hashtable = kvmalloc_array(slot_hashtable_size,
 					     sizeof(ksm->slot_hashtable[0]),

base-commit: f8394f232b1eab649ce2df5c5f15b0e528c92091
-- 
2.29.2

