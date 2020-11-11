Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1CE982AE63E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 Nov 2020 03:16:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731772AbgKKCQJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Nov 2020 21:16:09 -0500
Received: from mail.kernel.org ([198.145.29.99]:41322 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726307AbgKKCQI (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Nov 2020 21:16:08 -0500
Received: from sol.attlocal.net (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4AAA721D91;
        Wed, 11 Nov 2020 02:16:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605060968;
        bh=PZRt3E6xxphWLNzNZIOoOuzGlDMjxwJgE196pZ7V150=;
        h=From:To:Cc:Subject:Date:From;
        b=jFYo4SObuhumM2OS4flaYv43pxymqBCEH26pzPgG3NsTvcCAj0KALgg9je/z3sQ54
         l6WbWCayAo1Ma1mY4sBIZtczuWaj3AvOgaVDFwgjqi4lqy7NVRzRAIpUtT8Y3d8AuN
         mo8DovjK/px47OISPMXoR7L1sEpmIbg02PWJnPQU=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fscrypt@vger.kernel.org, Satya Tangirala <satyat@google.com>
Subject: [PATCH] block/keyslot-manager: prevent crash when num_slots=1
Date:   Tue, 10 Nov 2020 18:14:27 -0800
Message-Id: <20201111021427.466349-1-ebiggers@kernel.org>
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
index 35abcb1ec051d..0a5b2772324ad 100644
--- a/block/keyslot-manager.c
+++ b/block/keyslot-manager.c
@@ -103,6 +103,13 @@ int blk_ksm_init(struct blk_keyslot_manager *ksm, unsigned int num_slots)
 	spin_lock_init(&ksm->idle_slots_lock);
 
 	slot_hashtable_size = roundup_pow_of_two(num_slots);
+
+	/*
+	 * hash_ptr() assumes bits != 0, so ensure the hash table has at least 2
+	 * buckets.  This only makes a difference when there is only 1 keyslot.
+	 */
+	slot_hashtable_size = max(slot_hashtable_size, 2U);
+
 	ksm->log_slot_ht_size = ilog2(slot_hashtable_size);
 	ksm->slot_hashtable = kvmalloc_array(slot_hashtable_size,
 					     sizeof(ksm->slot_hashtable[0]),

base-commit: f8394f232b1eab649ce2df5c5f15b0e528c92091
-- 
2.29.2

