Return-Path: <linux-fscrypt+bounces-1676-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id tgIKC5AMPGrgjAgAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1676-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 18:57:52 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 73BE96C0258
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 18:57:51 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=none;
	dmarc=fail reason="SPF not aligned (relaxed), No valid DKIM" header.from=suse.com (policy=quarantine);
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1676-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1676-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id AA1653127709
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 16:53:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2A8A3403ED;
	Wed, 24 Jun 2026 16:52:21 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92C7833FE0F
	for <linux-fscrypt@vger.kernel.org>; Wed, 24 Jun 2026 16:52:20 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782319941; cv=none; b=jjPU5/PVEnYBO8dLfWfYbgvJ0JDNGL6vkIE0JvZDe+zR7F9lm2zOjOQC6t/dM71rYHXrlbhUxGEV+pQ5n0XT/ZGFwqUeSL5lcbO3Lpp5G7FwcBzTz0R1ThduKPp3i4y+Q5kSH4+1orX0QnxPcpirEf8c3rvAsfhJFUlPEv3goHY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782319941; c=relaxed/simple;
	bh=qjNRDS6XHXAaqS0PwZfBzgrQukeeUDnP8fJAr05fr4A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UEpGyADhCDlLb6iL+JOq9S3t61t6h3k7Al5TwE0iFFGnZm3C8/hV6L0tDlaHW7vXf7afNi4+grZPdojCt1tQixs1mq2K2gYs9qr9Yhkowe+0eymEFBhfYnqfcWL7B5pLhtMs45mjzbfBhQKj+V6tonI+6YDMc24tVOZcOszvLZA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; arc=none smtp.client-ip=195.135.223.131
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id 6A15176061;
	Wed, 24 Jun 2026 16:51:51 +0000 (UTC)
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 555B6779AC;
	Wed, 24 Jun 2026 16:51:51 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id GOxaFCcLPGrUTgAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 24 Jun 2026 16:51:51 +0000
From: Daniel Vacek <neelx@suse.com>
To: David Sterba <dsterba@suse.com>
Cc: Daniel Vacek <neelx@suse.com>,
	linux-fscrypt@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 7/8] btrfs-progs: check: update inline extent length checking
Date: Wed, 24 Jun 2026 18:51:43 +0200
Message-ID: <20260624165144.556908-8-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260624165144.556908-1-neelx@suse.com>
References: <20260624165144.556908-1-neelx@suse.com>
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
X-Spam-Level: 
X-Rspamd-Pre-Result: action=no action;
	module=replies;
	Message is reply to one we originated
X-Rspamd-Action: no action
X-Spamd-Result: default: False [1.54 / 15.00];
	DMARC_POLICY_QUARANTINE(1.50)[suse.com : SPF not aligned (relaxed), No valid DKIM,quarantine];
	MID_CONTAINS_FROM(1.00)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:dsterba@suse.com,m:neelx@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:sweettea-kernel@dorminy.me,s:lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1676-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	DBL_BLOCKED_OPENRESOLVER(0.00)[dorminy.me:email,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp,suse.com:email,suse.com:mid,suse.com:from_mime]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 73BE96C0258

From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

As part of the encryption changes, encrypted inline file extents record
their actual data length in ram_bytes, like compressed inline file
extents, while the item's length records the actual size. As such,
encrypted inline extents must be treated like compressed ones for
inode length consistency checking.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---
 check/main.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/check/main.c b/check/main.c
index 2df55edc..4902cbd9 100644
--- a/check/main.c
+++ b/check/main.c
@@ -1722,7 +1722,7 @@ static int process_file_extent(struct btrfs_root *root,
 	u64 mask = gfs_info->sectorsize - 1;
 	u32 max_inline_size = min_t(u32, gfs_info->sectorsize,
 				BTRFS_MAX_INLINE_DATA_SIZE(gfs_info));
-	u8 compression;
+	u8 compression, encryption;
 	int extent_type;
 	int ret;
 
@@ -1747,25 +1747,25 @@ static int process_file_extent(struct btrfs_root *root,
 	fi = btrfs_item_ptr(eb, slot, struct btrfs_file_extent_item);
 	extent_type = btrfs_file_extent_type(eb, fi);
 	compression = btrfs_file_extent_compression(eb, fi);
+	encryption = btrfs_file_extent_encryption(eb, fi);
 
 	if (extent_type == BTRFS_FILE_EXTENT_INLINE) {
-		num_bytes = btrfs_file_extent_ram_bytes(eb, fi);
-		if (num_bytes == 0)
+		u64 num_decoded_bytes = btrfs_file_extent_ram_bytes(eb, fi);
+		u64 num_disk_bytes =  btrfs_file_extent_inline_item_len(eb, slot);
+		if (num_decoded_bytes == 0)
 			rec->errors |= I_ERR_BAD_FILE_EXTENT;
-		if (compression) {
-			if (btrfs_file_extent_inline_item_len(eb, slot) >
-			    max_inline_size ||
-			    num_bytes > gfs_info->sectorsize)
+		if (compression || encryption) {
+			if (num_disk_bytes > max_inline_size ||
+			    num_decoded_bytes > gfs_info->sectorsize)
 				rec->errors |= I_ERR_FILE_EXTENT_TOO_LARGE;
 		} else {
-			if (num_bytes > max_inline_size)
+			if (num_decoded_bytes > max_inline_size)
 				rec->errors |= I_ERR_FILE_EXTENT_TOO_LARGE;
-			if (btrfs_file_extent_inline_item_len(eb, slot) !=
-			    num_bytes)
+			if (num_disk_bytes != num_decoded_bytes)
 				rec->errors |= I_ERR_INLINE_RAM_BYTES_WRONG;
 		}
-		rec->found_size += num_bytes;
-		num_bytes = (num_bytes + mask) & ~mask;
+		rec->found_size += num_decoded_bytes;
+		num_bytes = (num_decoded_bytes + mask) & ~mask;
 	} else if (extent_type == BTRFS_FILE_EXTENT_REG ||
 		   extent_type == BTRFS_FILE_EXTENT_PREALLOC) {
 		num_bytes = btrfs_file_extent_num_bytes(eb, fi);
-- 
2.53.0


