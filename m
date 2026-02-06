Return-Path: <linux-fscrypt+bounces-1096-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id iLFcD08zhmneKQQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1096-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:30:39 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id A7863101E2B
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:30:38 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id 20B63309ECEA
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:25:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C99CF43E4AE;
	Fri,  6 Feb 2026 18:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ihQb7wKY";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ihQb7wKY"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7792743E4A1
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402276; cv=none; b=mYt6c/FWJq+Sw7MS/5iaaj1JUqOwj8SqsbE5lG0wdAPmXW4YgqHjtuJmJKa7EbB+x1wCd/eKaP4dHMk1ieobLDXz/UH8h/Fsau79Cwf4w1tWjOTp4Zd4zPY/MFLMHpijGVXMGdqAyK842lGOKbLsI+Ukxp855hgt1C5pP9F5kpM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402276; c=relaxed/simple;
	bh=8loaANaPFESANLrYnj8Wqx4yYtxkh/Uh+aihMl15zrc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VEHD5Vqjb6K2qxp3MfZINkRniklnhICiL+M9pjsMkuKz/cyE0OnNuvEFYw7YzgLvdodkkchbJf7IuM+MxHBg7GoX8JNBEQMfs1ReX8drM1pUjUAjQHlSS1l7OU7IlTAvtRHAiIxjTfvVp/mWnElXwHWqDUfZ8Jdl3v1KUxJztts=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ihQb7wKY; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ihQb7wKY; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id B23F35BCE4;
	Fri,  6 Feb 2026 18:24:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402244; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NmyK3AesDBGZv034yJBs56keke+EnBt3klqGpQx8SQY=;
	b=ihQb7wKYYxZvJjVJZ7cCm+iivepKmOmCPf2LdHgt6qW3xLQMO0+wDXU5jq2NnrHQW3uyI6
	9HelUOcdE45AbSngkEZxv8vaeZ6nBXnmB9tgbXH81nle7XPU0kb3+/5PB7q6JdPm0ut51R
	71v8D5Nj+tjQsjHSg7UATnruCVR5jZQ=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402244; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=NmyK3AesDBGZv034yJBs56keke+EnBt3klqGpQx8SQY=;
	b=ihQb7wKYYxZvJjVJZ7cCm+iivepKmOmCPf2LdHgt6qW3xLQMO0+wDXU5jq2NnrHQW3uyI6
	9HelUOcdE45AbSngkEZxv8vaeZ6nBXnmB9tgbXH81nle7XPU0kb3+/5PB7q6JdPm0ut51R
	71v8D5Nj+tjQsjHSg7UATnruCVR5jZQ=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 85C1F3EA63;
	Fri,  6 Feb 2026 18:24:04 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id +PssIMQxhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:24:04 +0000
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
Subject: [PATCH v6 16/43] btrfs: select encryption dependencies if FS_ENCRYPTION
Date: Fri,  6 Feb 2026 19:22:48 +0100
Message-ID: <20260206182336.1397715-17-neelx@suse.com>
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
X-Spam-Flag: NO
X-Spam-Score: -6.80
X-Spam-Level: 
X-Rspamd-Server: lfdr
X-Spamd-Result: default: False [-0.66 / 15.00];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[suse.com,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	R_DKIM_ALLOW(-0.20)[suse.com:s=susede1];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	TAGGED_FROM(0.00)[bounces-1096-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	TO_DN_SOME(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,toxicpanda.com:email,suse.com:email,suse.com:dkim,suse.com:mid]
X-Rspamd-Queue-Id: A7863101E2B
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

We need this to make sure the appropriate encryption algorithms are
turned on in our config if we have FS_ENCRYPTION enabled, and
additionally we only support inline encryption with the fallback block
crypto, so we need to make sure we pull in those dependencies.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v5: https://lore.kernel.org/linux-btrfs/396f5067b2551a9f2de4b439509e1a285985d358.1706116485.git.josef@toxicpanda.com/
 * No changes since.
---
 fs/btrfs/Kconfig | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
index ede184b6eda1..216a5707b099 100644
--- a/fs/btrfs/Kconfig
+++ b/fs/btrfs/Kconfig
@@ -16,6 +16,9 @@ config BTRFS_FS
 	select RAID6_PQ
 	select XOR_BLOCKS
 	select XXHASH
+	select FS_ENCRYPTION_ALGS if FS_ENCRYPTION
+	select FS_ENCRYPTION_INLINE_CRYPT if FS_ENCRYPTION
+	select BLK_INLINE_ENCRYPTION_FALLBACK if FS_ENCRYPTION
 	depends on PAGE_SIZE_LESS_THAN_256KB
 
 	help
-- 
2.51.0


