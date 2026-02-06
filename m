Return-Path: <linux-fscrypt+bounces-1097-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id MHFvOkgzhmneKQQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1097-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:30:32 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sin.lore.kernel.org (sin.lore.kernel.org [IPv6:2600:3c15:e001:75::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 0A1B9101E15
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:30:31 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sin.lore.kernel.org (Postfix) with ESMTP id 5BB10303C60C
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:25:55 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B164343E9FA;
	Fri,  6 Feb 2026 18:24:40 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 68A5F43E9F7
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:24:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402280; cv=none; b=Ypp8TCsBNp3lkUpHxWUxBHpcbPNjJcBJw4UdXF/vijr1KELAg0G2wOTx0dMuqTyxwAv1o2KPjvc49nWqHq+LT8iiYVyz7pmpPdS7yvAdGyJiSNew0ULRXvoqG1UXzdD3Lxutf+lI/yH6ZSTEu3bhQjHyU4u7QUzIz6wFbh4uO24=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402280; c=relaxed/simple;
	bh=ILW5MjqFNyY2StUj24TeI6krWd5DbLhdgiXmKM46mD0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FvCMgQMPDkg+5e202yxlSZR/QQ8BuhtUR5cjr1pTk6+FcufXPJNTor2lr5rGDVjqArX/x9eRIigXpPKLOrshbW24PGG7Tpos8N7LvRLiARNpfGt5ulCcciKE2giSt2wwdj7MUsT0EeHDq33O+T/flHc7GI2E47ZXM16/qeRxAdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 1DD1C3E750;
	Fri,  6 Feb 2026 18:24:07 +0000 (UTC)
Authentication-Results: smtp-out1.suse.de;
	none
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id E69543EA63;
	Fri,  6 Feb 2026 18:24:06 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id aMq9N8YxhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:24:06 +0000
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
	linux-kernel@vger.kernel.org
Subject: [PATCH v6 20/43] btrfs: add fscrypt_info and encryption_type to ordered_extent
Date: Fri,  6 Feb 2026 19:22:52 +0100
Message-ID: <20260206182336.1397715-21-neelx@suse.com>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Level: 
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [1.54 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[suse.com : SPF not aligned (relaxed), No valid DKIM,quarantine];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c15:e001:75::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	MIME_TRACE(0.00)[0:+];
	RCPT_COUNT_TWELVE(0.00)[12];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1097-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c15::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	NEURAL_HAM(-0.00)[-0.994];
	RCVD_COUNT_FIVE(0.00)[6];
	R_DKIM_NA(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sin.lore.kernel.org:helo,sin.lore.kernel.org:rdns,toxicpanda.com:email,suse.com:mid,suse.com:email]
X-Rspamd-Queue-Id: 0A1B9101E15
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

We're going to need these to update the file extent items once the
writes are complete.  Add them and add the pieces necessary to assign
them and free everything.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v5: https://lore.kernel.org/linux-btrfs/de9ff13d1dc042b764c224d039fbb2a08946e004.1706116485.git.josef@toxicpanda.com/
 * Changed encryption_type member to u8.
---
 fs/btrfs/ordered-data.c | 2 ++
 fs/btrfs/ordered-data.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index 5df02c707aee..7a5701937184 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -192,6 +192,7 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 	}
 	entry->inode = inode;
 	entry->compress_type = compress_type;
+	entry->encryption_type = BTRFS_ENCRYPTION_NONE;
 	entry->truncated_len = (u64)-1;
 	entry->qgroup_rsv = qgroup_rsv;
 	entry->flags = flags;
@@ -630,6 +631,7 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 		btrfs_add_delayed_iput(entry->inode);
 		list_for_each_entry_safe(sum, tmp, &entry->list, list)
 			kvfree(sum);
+		fscrypt_put_extent_info(entry->fscrypt_info);
 		kmem_cache_free(btrfs_ordered_extent_cache, entry);
 	}
 }
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 1e6b0b182b29..ce19198e7f84 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -124,6 +124,9 @@ struct btrfs_ordered_extent {
 	/* compression algorithm */
 	int compress_type;
 
+	/* encryption mode */
+	u8 encryption_type;
+
 	/* Qgroup reserved space */
 	int qgroup_rsv;
 
@@ -133,6 +136,9 @@ struct btrfs_ordered_extent {
 	/* the inode we belong to */
 	struct btrfs_inode *inode;
 
+	/* the fscrypt_info for this extent, if necessary */
+	struct fscrypt_extent_info *fscrypt_info;
+
 	/* list of checksums for insertion when the extent io is done */
 	struct list_head list;
 
-- 
2.51.0


