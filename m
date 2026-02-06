Return-Path: <linux-fscrypt+bounces-1118-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by lfdr with LMTP
	id oDhaHVY2hmmHLAQAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1118-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:43:34 +0100
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id F14461022D0
	for <lists+linux-fscrypt@lfdr.de>; Fri, 06 Feb 2026 19:43:33 +0100 (CET)
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 27FDF31C989E
	for <lists+linux-fscrypt@lfdr.de>; Fri,  6 Feb 2026 18:29:43 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id D1AF543DA25;
	Fri,  6 Feb 2026 18:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZKtaFJlK";
	dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b="ZKtaFJlK"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.223.131])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E9F544BC87
	for <linux-fscrypt@vger.kernel.org>; Fri,  6 Feb 2026 18:25:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.131
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770402325; cv=none; b=GexJdS9D8LUff12UiTxmYZxafGJmUiYqg2tl+6wyzBUZ8FIZeLYWEvm0fZw/8afUGGHhjPxMNMmDw7MStuC/ndYv+a+NuC8Ij7T+TCn9O6gXcWURE6ASrwkQpYK+sYu9VN/W21/y6ATKMot15a3FIXmmXhvB6Zo5iBO31W31TGc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770402325; c=relaxed/simple;
	bh=GfnO68KXoBeEnqOHN5arOyt9p0B9ZFFw2XWnNOvoB4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DzBpV/voBeNLlG3+x4bbqhGcLnN3iw4j/IElXnb9fwfo3vzAom60iYWygRb/Ja4P68SbxN7zfh5ZzUNcRMDosOC16uhLvrgBCoi31r4Axow8BH+T0LOr5FmB0qjZIi/HTxvTKZnhzufP4mJ3DncOtJCtZpJbtnpAZKFdvFoJhaA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZKtaFJlK; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=ZKtaFJlK; arc=none smtp.client-ip=195.135.223.131
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.com
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out2.suse.de (Postfix) with ESMTPS id BCF995BD35;
	Fri,  6 Feb 2026 18:24:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sbKbFDBvAoHVV+zcvNVZ9N7jQeEHQ8nUuWj4G99Gpu0=;
	b=ZKtaFJlKLO4EkBCD9rOxrt3wRA/eB6Va5Y04z9GKP2c1HIs0s7R2RltIyO5sKyCH2X+rcq
	i+OmSfDOUess3SWpjYnq2Gs4zxWhqjAwgTz3NWfX6qx6VoCVpYTL6/9CtVdoqZCM4nHim/
	sDauKpUpaqCiUu0grk0La6pHWEyEhWw=
Authentication-Results: smtp-out2.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1770402260; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sbKbFDBvAoHVV+zcvNVZ9N7jQeEHQ8nUuWj4G99Gpu0=;
	b=ZKtaFJlKLO4EkBCD9rOxrt3wRA/eB6Va5Y04z9GKP2c1HIs0s7R2RltIyO5sKyCH2X+rcq
	i+OmSfDOUess3SWpjYnq2Gs4zxWhqjAwgTz3NWfX6qx6VoCVpYTL6/9CtVdoqZCM4nHim/
	sDauKpUpaqCiUu0grk0La6pHWEyEhWw=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 8FD033EA63;
	Fri,  6 Feb 2026 18:24:20 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id eMOcItQxhmkTCQAAD6G6ig
	(envelope-from <neelx@suse.com>); Fri, 06 Feb 2026 18:24:20 +0000
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
Subject: [PATCH v6 43/43] btrfs: disable send if we have encryption enabled
Date: Fri,  6 Feb 2026 19:23:15 +0100
Message-ID: <20260206182336.1397715-44-neelx@suse.com>
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
	TAGGED_FROM(0.00)[bounces-1118-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[toxicpanda.com:email,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,bur.io:email,suse.com:email,suse.com:dkim,suse.com:mid]
X-Rspamd-Queue-Id: F14461022D0
X-Rspamd-Action: no action

From: Josef Bacik <josef@toxicpanda.com>

send needs to track the dir item values to see if files were renamed
when doing an incremental send.  There is code to decrypt the names, but
this breaks the code that checks to see if something was overwritten.
Until this gap is closed we need to disable send on encrypted file
systems.  Fixing this is straightforward, but a medium sized project.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Reviewed-by: Boris Burkov <boris@bur.io>
Signed-off-by: Daniel Vacek <neelx@suse.com>
---

v5: https://lore.kernel.org/linux-btrfs/62ce86b38e2575c542eed7fbe8d986e68496b1d7.1706116485.git.josef@toxicpanda.com/
 * No changes since.
---
 fs/btrfs/send.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
index bf9a99a9d24d..a3aa95ce4f87 100644
--- a/fs/btrfs/send.c
+++ b/fs/btrfs/send.c
@@ -8095,6 +8095,12 @@ long btrfs_ioctl_send(struct btrfs_root *send_root, const struct btrfs_ioctl_sen
 	if (!capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
+	if (btrfs_fs_incompat(fs_info, ENCRYPT)) {
+		btrfs_err(fs_info,
+		  "send with encryption enabled isn't currently suported");
+		return -EINVAL;
+	}
+
 	/*
 	 * The subvolume must remain read-only during send, protect against
 	 * making it RW. This also protects against deletion.
-- 
2.51.0


