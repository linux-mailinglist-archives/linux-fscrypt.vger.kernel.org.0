Return-Path: <linux-fscrypt+bounces-1090-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mDqrIio1hmlrLAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1090-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:38:34 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id CA4741020DA
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:38:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C550C3046522
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:24:48 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 657EB42EEB5;
	Fri,  6 Feb 2026 18:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="q827tzaI";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="q827tzaI"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 105A742EEBD
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:24:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402263; cv=none; b=Ufck/YfwjEoJRWf1kZgIE+ZU7g/pfErhwhIaUzdub1Z3v9kDREMhUY/jtLQNPnZ3YUeMomAZ4expST1FRsSSWzmfGoGUYJtYNHvYzGeGneWknQ4rckg1VZDLE+VmbIDATfs1iIGV4jSUkET+RqhBpdY9cyF/jk0dOjKFJjVHFKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402263; c=relaxed/simple;
	bh=XVhsTk+LYpWAXNJDQrvJq2UU4XDe6OSIWEwozraAeOc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lsanjRkuvS8XyD6yOSurWZPSDhKPh+J9SY7oJhCiXjkSPlKGzJGjdBaQVMqpyNbDset1fMAiNOCupiN9WtHEkgGRdnQ9mgxJSucPXSFJdTPwyOT5mH5KvshDUoMULnNpNun1FyW/s5dJ6BB0WuaggN7UCDy9zWwKHxGHz7vxJJU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=q827tzaI; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=q827tzaI; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id F2F7F5BD27;
	Fri,  6 Feb 2026 18:23:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402239; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ahxdoq0wAm++q/QMvFMTlIGeudeamFjihSebXBaXzxc=;
	b=q827tzaI998W3R1OaxrJEuODt4hhyA2sxStRK+nO8UgwIsr+6x8LhRCfV4zt9JXvi34KKh
	jRp7GVBngNSUGZUhEXk3igIekc0cNKAYuPIcJ/XoGM+e19/r+liIGM5k/SQcLS00ayiQZg
	up9jdfv+QGV73QtTgJFXBhi7BPy38qo=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402239; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=Ahxdoq0wAm++q/QMvFMTlIGeudeamFjihSebXBaXzxc=;
	b=q827tzaI998W3R1OaxrJEuODt4hhyA2sxStRK+nO8UgwIsr+6x8LhRCfV4zt9JXvi34KKh
	jRp7GVBngNSUGZUhEXk3igIekc0cNKAYuPIcJ/XoGM+e19/r+liIGM5k/SQcLS00ayiQZg
	up9jdfv+QGV73QtTgJFXBhi7BPy38qo=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C40DF3EA63;
	Fri,  6 Feb 2026 18:23:58 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id OMFeL74xhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:23:58 +0000
From: Daniel Vacek <neelx@suse.com>
To: Chris Mason <clm@fb.com>,
	Josef Bacik <josef@toxicpanda.com>,
	Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Jens Axboe <axboe@kernel.dk>,
	David Sterba <dsterba@suse.com>
Cc: linux-block@vger.kernel.org,
	Daniel Vacek <neelx@suse.com>,
	linux-fscrypt@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Boris Burkov <boris@bur.io>
Subject: [PATCH v6 09/43] btrfs: add infrastructure for safe em freeing
Date: Fri,  6 Feb 2026 19:22:41 +0100
Message-ID: <20260206182336.1397715-10-neelx@suse.com>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260206182336.1397715-1-neelx@suse.com>
References: <20260206182336.1397715-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Score: -6.80
X-Spam-Level: 
X-Spam-Flag: NO
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1090-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[13];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,suse.com:email,suse.com:dkim,suse.com:mid,bur.io:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns]
X-Rspamd-Queue-Id: CA4741020DA
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

When we add fscrypt support we're going to have fscrypt objects hanging
off of extent_maps.  This includes a block key, which if we're the last
one freeing the key we may have to unregister it from the block layer.
This requires taking a semaphore in the block layer, which means we
can't free em's under the extent map tree lock.

Thankfully we only do this in two places, one where we're dropping a
range of extent maps, and when we're freeing logged extents.  Add a
free_extent_map_safe() which will add the em to a list in the em_tree if
we free'd the object.  Currently this is unconditional but will be
changed to conditional on the fscrypt object we will add in a later
patch.

To process these delayed objects add a free_pending_extent_maps() that
is called after the lock has been dropped on the em_tree.  This will
process the extent maps on the freed list and do the appropriate freeing
work in a safe manner.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v5: https://lore.kernel.org/linux-btrfs/6cf44f7860e94de68df242e69f4c5250bd061cff.1706116485.git.josef@toxicpanda.com/
 * No changes since (other than simple function renames).
---
 fs/btrfs/extent_map.c | 76 +++++++++++++++++++++++++++++++++++++++++--
 fs/btrfs/extent_map.h | 10 ++++++
 fs/btrfs/tree-log.c   |  6 ++--
 3 files changed, 87 insertions(+), 5 deletions(-)

diff --git a/fs/btrfs/extent_map.c b/fs/btrfs/extent_map.c
index 095a561d733f..58589fc11802 100644
--- a/fs/btrfs/extent_map.c
+++ b/fs/btrfs/extent_map.c
@@ -34,7 +34,9 @@ void __cold btrfs_extent_map_exit(void)
 void btrfs_extent_map_tree_init(struct extent_map_tree *tree)
 {
 	tree->root = RB_ROOT;
+	tree->flags = 0;
 	INIT_LIST_HEAD(&tree->modified_extents);
+	INIT_LIST_HEAD(&tree->freed_extents);
 	rwlock_init(&tree->lock);
 }
 
@@ -51,9 +53,15 @@ struct extent_map *btrfs_alloc_extent_map(void)
 	RB_CLEAR_NODE(&em->rb_node);
 	refcount_set(&em->refs, 1);
 	INIT_LIST_HEAD(&em->list);
+	INIT_LIST_HEAD(&em->free_list);
 	return em;
 }
 
+static void free_extent_map(struct extent_map *em)
+{
+	kmem_cache_free(extent_map_cache, em);
+}
+
 /*
  * Drop the reference out on @em by one and free the structure if the reference
  * count hits zero.
@@ -65,10 +73,69 @@ void btrfs_free_extent_map(struct extent_map *em)
 	if (refcount_dec_and_test(&em->refs)) {
 		WARN_ON(btrfs_extent_map_in_tree(em));
 		WARN_ON(!list_empty(&em->list));
-		kmem_cache_free(extent_map_cache, em);
+		free_extent_map(em);
+	}
+}
+
+/*
+ * Drop a ref for the extent map in the given tree.
+ *
+ * @tree:	tree that the em is a part of.
+ * @em:		the em to drop the reference to.
+ *
+ * Drop the reference count on @em by one, if the reference count hits 0 and
+ * there is an object on the em that can't be safely freed in the current
+ * context (if we are holding the extent_map_tree->lock for example), then add
+ * it to the freed_extents list on the extent_map_tree for later processing.
+ *
+ * This must be followed by a btrfs_free_pending_extent_maps() to clear
+ * the pending frees.
+ */
+void btrfs_free_extent_map_safe(struct extent_map_tree *tree,
+				struct extent_map *em)
+{
+	lockdep_assert_held_write(&tree->lock);
+
+	if (!em)
+		return;
+
+	if (refcount_dec_and_test(&em->refs)) {
+		WARN_ON(btrfs_extent_map_in_tree(em));
+		WARN_ON(!list_empty(&em->list));
+		list_add_tail(&em->free_list, &tree->freed_extents);
+		set_bit(EXTENT_MAP_TREE_PENDING_FREES, &tree->flags);
 	}
 }
 
+/*
+ * Free the em objects that exist on the em tree
+ *
+ * @tree:	the tree to free the objects from.
+ *
+ * If there are any objects on the em->freed_extents list go ahead and
+ * free them here in a safe way.  This is to be coupled with any uses of
+ * btrfs_free_extent_map_safe().
+ */
+void btrfs_free_pending_extent_maps(struct extent_map_tree *tree)
+{
+	struct extent_map *em;
+
+	/* Avoid taking the write lock if we don't have any pending frees. */
+	if (!test_and_clear_bit(EXTENT_MAP_TREE_PENDING_FREES, &tree->flags))
+		return;
+
+	write_lock(&tree->lock);
+	while ((em = list_first_entry_or_null(&tree->freed_extents,
+					      struct extent_map, free_list))) {
+		list_del_init(&em->free_list);
+		write_unlock(&tree->lock);
+		free_extent_map(em);
+		cond_resched();
+		write_lock(&tree->lock);
+	}
+	write_unlock(&tree->lock);
+}
+
 /* Do the math around the end of an extent, handling wrapping. */
 static u64 range_end(u64 start, u64 len)
 {
@@ -784,7 +851,7 @@ static void drop_all_extent_maps_fast(struct btrfs_inode *inode)
 		em = rb_entry(node, struct extent_map, rb_node);
 		em->flags &= ~(EXTENT_FLAG_PINNED | EXTENT_FLAG_LOGGING);
 		btrfs_remove_extent_mapping(inode, em);
-		btrfs_free_extent_map(em);
+		btrfs_free_extent_map_safe(tree, em);
 
 		if (cond_resched_rwlock_write(&tree->lock))
 			node = rb_first(&tree->root);
@@ -792,6 +859,8 @@ static void drop_all_extent_maps_fast(struct btrfs_inode *inode)
 			node = next;
 	}
 	write_unlock(&tree->lock);
+
+	btrfs_free_pending_extent_maps(tree);
 }
 
 /*
@@ -986,13 +1055,14 @@ void btrfs_drop_extent_map_range(struct btrfs_inode *inode, u64 start, u64 end,
 		btrfs_free_extent_map(em);
 next:
 		/* Once for us (for our lookup reference). */
-		btrfs_free_extent_map(em);
+		btrfs_free_extent_map_safe(em_tree, em);
 
 		em = next_em;
 	}
 
 	write_unlock(&em_tree->lock);
 
+	btrfs_free_pending_extent_maps(em_tree);
 	btrfs_free_extent_map(split);
 	btrfs_free_extent_map(split2);
 }
diff --git a/fs/btrfs/extent_map.h b/fs/btrfs/extent_map.h
index 6f685f3c9327..a962012be1c3 100644
--- a/fs/btrfs/extent_map.h
+++ b/fs/btrfs/extent_map.h
@@ -97,11 +97,18 @@ struct extent_map {
 	u32 flags;
 	refcount_t refs;
 	struct list_head list;
+	struct list_head free_list;
+};
+
+enum extent_map_flags {
+	EXTENT_MAP_TREE_PENDING_FREES,
 };
 
 struct extent_map_tree {
 	struct rb_root root;
+	unsigned long flags;
 	struct list_head modified_extents;
+	struct list_head freed_extents;
 	rwlock_t lock;
 };
 
@@ -175,6 +182,9 @@ int btrfs_split_extent_map(struct btrfs_inode *inode, u64 start, u64 len, u64 pr
 
 struct extent_map *btrfs_alloc_extent_map(void);
 void btrfs_free_extent_map(struct extent_map *em);
+void btrfs_free_extent_map_safe(struct extent_map_tree *tree,
+				struct extent_map *em);
+void btrfs_free_pending_extent_maps(struct extent_map_tree *tree);
 int __init btrfs_extent_map_init(void);
 void __cold btrfs_extent_map_exit(void);
 int btrfs_unpin_extent_cache(struct btrfs_inode *inode, u64 start, u64 len, u64 gen);
diff --git a/fs/btrfs/tree-log.c b/fs/btrfs/tree-log.c
index e1bd03ebfd98..4034c04d4d63 100644
--- a/fs/btrfs/tree-log.c
+++ b/fs/btrfs/tree-log.c
@@ -5383,7 +5383,7 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 		 */
 		if (ret) {
 			btrfs_clear_em_logging(inode, em);
-			btrfs_free_extent_map(em);
+			btrfs_free_extent_map_safe(tree, em);
 			continue;
 		}
 
@@ -5392,11 +5392,13 @@ static int btrfs_log_changed_extents(struct btrfs_trans_handle *trans,
 		ret = log_one_extent(trans, inode, em, path, ctx);
 		write_lock(&tree->lock);
 		btrfs_clear_em_logging(inode, em);
-		btrfs_free_extent_map(em);
+		btrfs_free_extent_map_safe(tree, em);
 	}
 	WARN_ON(!list_empty(&extents));
 	write_unlock(&tree->lock);
 
+	btrfs_free_pending_extent_maps(tree);
+
 	if (!ret)
 		ret = btrfs_log_prealloc_extents(trans, inode, path, ctx);
 	if (ret)
-- 
2.51.0


