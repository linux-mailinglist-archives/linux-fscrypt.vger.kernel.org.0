Return-Path: <linux-fscrypt+bounces-1745-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id w8N2Cj4NTWoFuQEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1745-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 07 Jul 2026 16:29:18 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sto.lore.kernel.org (sto.lore.kernel.org [IPv6:2600:3c09:e001:a7::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id B4C4B71C9F9
	for <lists+linux-fscrypt@lfdr.de>; Tue, 07 Jul 2026 16:29:17 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=suse.com (policy=quarantine);
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1745-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c09:e001:a7::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1745-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sto.lore.kernel.org (Postfix) with ESMTP id DEF6D300BBB1
	for <lists+linux-fscrypt@lfdr.de>; Tue,  7 Jul 2026 14:28:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A1B0B42A14A;
	Tue,  7 Jul 2026 14:28:08 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 031A442CB08
	for <linux-fscrypt@vger.kernel.org>; Tue,  7 Jul 2026 14:28:04 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783434487; cv=none; b=RtmTE+6KOL76fJyBANQM8Rn67Eh5b7a7MSYXJEP42RynyLicyBXGtCKJPWCVzXnbyAfnsKTkxklr3a7Z+NHG7umd/2yYhvQwD/+9UL2cOCdpn/j1XlhQlIfE1Xc7LJ8devYCQO4FCCDnz8Gp4GZ8gue72GytMQ2wgrsA2uDSN6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783434487; c=relaxed/simple;
	bh=jojUr7pjvrjX3qSTYC3q7xnLYpKQfg3LDe2yPs+FbpE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DNzmu0K4ee6Ov/WA9Ur1cLMX081M4osSXH357oNnAjtNuItbnqquJbEqSjG0+AC1bxo1uux6yYGq2gFiB1lAKzpgETE9MC0BXQGvw4KFRPff36pINMcb3m0t9ASKHLpr/mYCpIJRzko6l5oTxzodQDvQRtbgCeW9Vf/y6NDqOfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 4D66175D28;
	Tue,  7 Jul 2026 14:27:47 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 38AF3779AE;
	Tue,  7 Jul 2026 14:27:47 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id QHdKDeMMTWoLaQAAD6G6ig
	(envelope-from <neelx@suse.com>); Tue, 07 Jul 2026 14:27:47 +0000
From: Daniel Vacek <neelx@suse.com>
To: David Sterba <dsterba@suse.com>
Cc: Daniel Vacek <neelx@suse.com>,
	linux-fscrypt@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 5/7] btrfs-progs: handle fscrypt context items
Date: Tue,  7 Jul 2026 16:27:34 +0200
Message-ID: <20260707142736.2330146-6-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260707142736.2330146-1-neelx@suse.com>
References: <20260707142736.2330146-1-neelx@suse.com>
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
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Spam-Flag: NO
X-Spam-Score: -4.00
X-Spam-Level: 
X-Rspamd-Action: no action
X-Spamd-Result: default: False [1.54 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[suse.com : SPF not aligned (relaxed), No valid DKIM,quarantine];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c09:e001:a7::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:dsterba@suse.com,m:neelx@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:sweettea-kernel@dorminy.me,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1745-lists,linux-fscrypt=lfdr.de];
	FORGED_SENDER(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FORGED_SENDER_FORWARDING(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	FROM_HAS_DN(0.00)[];
	TO_DN_SOME(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	R_DKIM_NA(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	RCPT_COUNT_FIVE(0.00)[6];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c09::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:from_mime,suse.com:email,suse.com:mid,vger.kernel.org:from_smtp,sto.lore.kernel.org:helo,sto.lore.kernel.org:rdns,dorminy.me:email]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: B4C4B71C9F9

From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Encrypted inodes have a new associated item, the fscrypt context, which
can be printed as a pure hex string in dump-tree.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---
 check/main.c               |  2 ++
 kernel-shared/print-tree.c | 20 ++++++++++++++++++++
 2 files changed, 22 insertions(+)

diff --git a/check/main.c b/check/main.c
index 7f438302..9447b01e 100644
--- a/check/main.c
+++ b/check/main.c
@@ -1896,6 +1896,8 @@ static int process_one_leaf(struct btrfs_root *root, struct extent_buffer *eb,
 			break;
 		case BTRFS_VERITY_DESC_ITEM_KEY:
 		case BTRFS_VERITY_MERKLE_ITEM_KEY:
+		case BTRFS_FSCRYPT_INODE_CTX_KEY:
+		case BTRFS_FSCRYPT_CTX_KEY:
 			break;
 		default:
 			error("unknown key (%llu %u %llu) found in leaf %llu",
diff --git a/kernel-shared/print-tree.c b/kernel-shared/print-tree.c
index 2c0168b0..6a4eee48 100644
--- a/kernel-shared/print-tree.c
+++ b/kernel-shared/print-tree.c
@@ -117,6 +117,20 @@ static void print_dir_item(struct extent_buffer *eb, u32 size,
 	}
 }
 
+static void print_fscrypt_context(struct extent_buffer *eb, int slot)
+{
+	int i;
+	unsigned long ptr = btrfs_item_ptr_offset(eb, slot);
+	u32 item_size = btrfs_item_size(eb, slot);
+	u8 ctx_buf[item_size];
+
+	read_extent_buffer(eb, ctx_buf, ptr, item_size);
+	printf("\t\tvalue: ");
+	for(i = 0; i < item_size; i++)
+		printf("%02x", ctx_buf[i]);
+	printf("\n");
+}
+
 static void print_inode_extref_item(struct extent_buffer *eb, u32 size,
 		struct btrfs_inode_extref *extref)
 {
@@ -741,6 +755,8 @@ void print_key_type(FILE *stream, u64 objectid, u8 type)
 		[BTRFS_DIR_LOG_ITEM_KEY]	= "DIR_LOG_ITEM",
 		[BTRFS_DIR_LOG_INDEX_KEY]	= "DIR_LOG_INDEX",
 		[BTRFS_XATTR_ITEM_KEY]		= "XATTR_ITEM",
+		[BTRFS_FSCRYPT_INODE_CTX_KEY]   = "FSCRYPT_INODE_CTX",
+		[BTRFS_FSCRYPT_CTX_KEY]         = "FSCRYPT_CTX",
 		[BTRFS_VERITY_DESC_ITEM_KEY]	= "VERITY_DESC_ITEM",
 		[BTRFS_VERITY_MERKLE_ITEM_KEY]	= "VERITY_MERKLE_ITEM",
 		[BTRFS_ORPHAN_ITEM_KEY]		= "ORPHAN_ITEM",
@@ -1557,6 +1573,10 @@ void __btrfs_print_leaf(struct extent_buffer *eb, unsigned int mode)
 		case BTRFS_XATTR_ITEM_KEY:
 			print_dir_item(eb, item_size, ptr);
 			break;
+		case BTRFS_FSCRYPT_INODE_CTX_KEY:
+		case BTRFS_FSCRYPT_CTX_KEY:
+			print_fscrypt_context(eb, i);
+			break;
 		case BTRFS_DIR_LOG_INDEX_KEY:
 		case BTRFS_DIR_LOG_ITEM_KEY: {
 			struct btrfs_dir_log_item *dlog;
-- 
2.53.0


