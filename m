Return-Path: <linux-fscrypt+bounces-1578-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id mKfeE9A+BGoqFgIAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1578-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:05:20 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id EA29353031C
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 11:05:19 +0200 (CEST)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id DBA7F303E2FB
	for <lists+linux-fscrypt@lfdr.de>; Wed, 13 May 2026 08:57:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 104023FF8A2;
	Wed, 13 May 2026 08:55:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="mSGV9IhT";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="Y4Fj1VSG"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DB743FF883
	for <linux-fscrypt@vger.kernel.org>; Wed, 13 May 2026 08:55:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778662537; cv=none; b=MuPNGH78cX3Qhjwagj5Cdgnrm4IjhVvIDj0V2l7z6x+cdSCM2zv2z5r2echbzVXZrVQeFnZbAwcfYWHsM9PH641j6aP+FdLI3j0n/IuMMLw6vgju8gxO/G1CzIPlBKMiZuDnAmZ2Ew+mC/bbWw4x4vh3rQ1grvakOZs3LCUvQu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778662537; c=relaxed/simple;
	bh=1FtFIlBqoaNm3ZAKcTS+4f2w++MAxzjyZ45rZdfqcPs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLQ7AajaJgn9BvyIi0v5EKhp4eijdr9ZyinGrngZ1wOZqYF+2C73XFeS4juJMlywxkOjHNd1hojx7zguINCJvpa+iMyybCrBqJyRGh8cy3fSB2GNNXHxWL9VPeqCXT41cgWwmP6jCW/LvBH1iIlNYVe3k6P8M38ctPOrxxiMwnw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=mSGV9IhT; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=Y4Fj1VSG; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id E512976672;
	Wed, 13 May 2026 08:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662472; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iQGWM7+w0kbQEF0MyiAgEUfgjut+7zEyKpvCh2x/3gg=;
	b=mSGV9IhTZmdlHIuD3KbVDFm4MnFZkeeCODeZ/jxJBLWySsSNnlRi513btXvWHb/XNe/ATi
	QgNl9v3vXz0ZlVDa7Z/ksJn4B0gwtiDu6mVDZVoN0a2iBc7kW8ku+zaO4XXFRnDk8e5kfz
	ZBf5l1LcmSlwfYVKL102AStC8NL28og=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1778662471; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=iQGWM7+w0kbQEF0MyiAgEUfgjut+7zEyKpvCh2x/3gg=;
	b=Y4Fj1VSGtMQWFT3+Bha8CZ0PN6BY6O6JPGcAJ6erCHt8zmn5HrqbY/9UIZY/a0uys4u1UQ
	zMKbyyw5m26IP2jPtgWSAG2pIK5pB+JIjtAEg5O6jqVA8H5qKa1a+y+FWsaB1m/IQe4/4n
	UqXqX1QG/ZtYnAgMOWIeJGkg/V+YIaA=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id C3698593A9;
	Wed, 13 May 2026 08:54:31 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EPk6L0c8BGpERwAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 13 May 2026 08:54:31 +0000
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
Subject: [PATCH v7 20/43] btrfs: add fscrypt_info and encryption_type to ordered_extent
Date: Wed, 13 May 2026 10:52:54 +0200
Message-ID: <20260513085340.3673127-21-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260513085340.3673127-1-neelx@suse.com>
References: <20260513085340.3673127-1-neelx@suse.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Level: 
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Rspamd-Queue-Id: EA29353031C
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1578-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	MIME_TRACE(0.00)[0:+];
	FROM_HAS_DN(0.00)[];
	RCPT_COUNT_TWELVE(0.00)[12];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	NEURAL_HAM(-0.00)[-1.000];
	DKIM_TRACE(0.00)[suse.com:+];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,suse.com:email,suse.com:mid,suse.com:dkim]
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

We're going to need these to update the file extent items once the
writes are complete.  Add them and add the pieces necessary to assign
them and free everything.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

No changes in v7.
v6 changes:
 * Changed encryption_type member to u8 as suggested by Dave.
v5: https://lore.kernel.org/linux-btrfs/de9ff13d1dc042b764c224d039fbb2a08946e004.1706116485.git.josef@toxicpanda.com/
---
 fs/btrfs/ordered-data.c | 2 ++
 fs/btrfs/ordered-data.h | 6 ++++++
 2 files changed, 8 insertions(+)

diff --git a/fs/btrfs/ordered-data.c b/fs/btrfs/ordered-data.c
index e5a24b3ff95e..ac302fb7484b 100644
--- a/fs/btrfs/ordered-data.c
+++ b/fs/btrfs/ordered-data.c
@@ -205,6 +205,7 @@ static struct btrfs_ordered_extent *alloc_ordered_extent(
 	}
 	entry->inode = inode;
 	entry->compress_type = compress_type;
+	entry->encryption_type = BTRFS_ENCRYPTION_NONE;
 	entry->truncated_len = (u64)-1;
 	entry->qgroup_rsv = qgroup_rsv;
 	entry->flags = flags;
@@ -629,6 +630,7 @@ void btrfs_put_ordered_extent(struct btrfs_ordered_extent *entry)
 		btrfs_add_delayed_iput(entry->inode);
 		list_for_each_entry_safe(sum, tmp, &entry->csum_list, list)
 			kvfree(sum);
+		fscrypt_put_extent_info(entry->fscrypt_info);
 		kmem_cache_free(btrfs_ordered_extent_cache, entry);
 	}
 }
diff --git a/fs/btrfs/ordered-data.h b/fs/btrfs/ordered-data.h
index 03e12380a2fd..9b288c3908f9 100644
--- a/fs/btrfs/ordered-data.h
+++ b/fs/btrfs/ordered-data.h
@@ -131,6 +131,9 @@ struct btrfs_ordered_extent {
 	/* compression algorithm */
 	int compress_type;
 
+	/* encryption mode */
+	u8 encryption_type;
+
 	/* Qgroup reserved space */
 	int qgroup_rsv;
 
@@ -140,6 +143,9 @@ struct btrfs_ordered_extent {
 	/* the inode we belong to */
 	struct btrfs_inode *inode;
 
+	/* the fscrypt_info for this extent, if necessary */
+	struct fscrypt_extent_info *fscrypt_info;
+
 	/* list of checksums for insertion when the extent io is done */
 	struct list_head csum_list;
 
-- 
2.53.0


