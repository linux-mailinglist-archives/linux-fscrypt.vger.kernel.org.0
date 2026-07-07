Return-Path: <linux-fscrypt+bounces-1741-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id YOvIHKYUTWr7ugEAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1741-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Tue, 07 Jul 2026 17:00:54 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id D132371CF07
	for <lists+linux-fscrypt@lfdr.de>; Tue, 07 Jul 2026 17:00:52 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=GUIOICoR;
	dkim=pass header.d=suse.com header.s=susede1 header.b=GUIOICoR;
	dmarc=pass (policy=quarantine) header.from=suse.com;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1741-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1741-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 103E4305CA23
	for <lists+linux-fscrypt@lfdr.de>; Tue,  7 Jul 2026 14:27:52 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 56403426410;
	Tue,  7 Jul 2026 14:27:51 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94EB23B1ECC
	for <linux-fscrypt@vger.kernel.org>; Tue,  7 Jul 2026 14:27:48 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783434470; cv=none; b=sCIhkTuRbtLrkEpfdCMKGN1b8o5g4JUnx7RzzEbxKGIHDSbVTISwWKEC4L8mcG6BXjo+NYvOXN+6ZEu0dF1SSArFVCEkxLQ2C7AWtnJZzfiBI0fUPUmeMXtKuacEag9ndLGKiQ8JUczdB2rCo4LIt7QCKoAqsHGfXtnxngb3IJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783434470; c=relaxed/simple;
	bh=QEG7qiIGxWO4H7vn+VU4+uoBpTaRmPYZsEpcrFYqnwU=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=c7ikb7vK2F2I1aPyC29afPlG0cYBmtEuV172pbJEfZzBC1lpm1vUUIsq5Q98VoYJuIKPwIC+f0SsszVcQIcTQ3jTOZv1eigoPnBvjJoYu3vVCLA4EzQU3ejwdii6D+PgX/nfDj+l6P6jM4s5dMGJbmKhuqMQo0gNzI3Xu8+YGuI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GUIOICoR; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=GUIOICoR; arc=none smtp.client-ip=195.135.223.130
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id C453875B87;
	Tue,  7 Jul 2026 14:27:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783434466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=TKnGXkRv0X5ryAjOi2KSsMdVK8zJIkTG9rNvgYEpYO8=;
	b=GUIOICoRurPAdDFFhK3/bguULv+cAXHq3qlUYesfmQYikOximvH2ufxUYrx4KkZlnolwkB
	jtRg7VtX7Gnjq8j0i7ToOfzdQ5iqS3EML1aXrRX9ZXv3sE3ctpQRTOUasJ1CipawA1QHXh
	m+0nqVPFMc5URM4EsBA+rYavEAcYwpk=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1783434466; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=TKnGXkRv0X5ryAjOi2KSsMdVK8zJIkTG9rNvgYEpYO8=;
	b=GUIOICoRurPAdDFFhK3/bguULv+cAXHq3qlUYesfmQYikOximvH2ufxUYrx4KkZlnolwkB
	jtRg7VtX7Gnjq8j0i7ToOfzdQ5iqS3EML1aXrRX9ZXv3sE3ctpQRTOUasJ1CipawA1QHXh
	m+0nqVPFMc5URM4EsBA+rYavEAcYwpk=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AE8E2779AE;
	Tue,  7 Jul 2026 14:27:46 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id EJMOKuIMTWoLaQAAD6G6ig
	(envelope-from <neelx@suse.com>); Tue, 07 Jul 2026 14:27:46 +0000
From: Daniel Vacek <neelx@suse.com>
To: David Sterba <dsterba@suse.com>
Cc: Daniel Vacek <neelx@suse.com>,
	linux-fscrypt@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v3 0/7] btrfs-progs: fscrypt updates
Date: Tue,  7 Jul 2026 16:27:29 +0200
Message-ID: <20260707142736.2330146-1-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Level: 
X-Spam-Score: -2.80
X-Rspamd-Action: no action
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
	TAGGED_FROM(0.00)[bounces-1741-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:dsterba@suse.com,m:neelx@suse.com,m:linux-fscrypt@vger.kernel.org,m:linux-btrfs@vger.kernel.org,m:linux-kernel@vger.kernel.org,s:lists@lfdr.de];
	FORGED_SENDER_MAILLIST(0.00)[];
	TO_DN_SOME(0.00)[];
	FORGED_SENDER(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	FORWARDED(0.00)[lists@lfdr.de];
	DKIM_TRACE(0.00)[suse.com:+];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCPT_COUNT_FIVE(0.00)[5];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[neelx@suse.com,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	RCVD_COUNT_FIVE(0.00)[6];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ALIAS_RESOLVED(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:from_mime,suse.com:dkim,suse.com:mid,sea.lore.kernel.org:helo,sea.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D132371CF07

This series is a rebase of an older set of fscrypt related changes from
Sweet Tea Dorminy and Josef Bacik found here:
https://github.com/josefbacik/btrfs-progs/tree/fscrypt

It passed all my tests. Hopefully nothing blows. Enjoy testing.

v3:
 * dropped first patch and improved inline extent length checking
 * correctly squashed the context key definitions into "btrfs-progs: add
   inode encryption contexts"
 * inline extents also show the encryption field now in tree dump

v2: https://lore.kernel.org/linux-btrfs/20260624165144.556908-1-neelx@suse.com/
 * works with v7 of the kernel fscrypt series
 * the on-disk format changed and parts of the series had to be reworked
   - particularly the encryption context is now stored as dedicated item
     and not glued onto extent data item
 * also parses the ENCRYPT inode item flag

Daniel Vacek (1):
  btrfs-progs: recognize ENCRYPT inode item flag

Sweet Tea Dorminy (6):
  btrfs-progs: add new FEATURE_INCOMPAT_ENCRYPT flag
  btrfs-progs: start tracking extent encryption context info
  btrfs-progs: add inode encryption contexts
  btrfs-progs: print encryptin type field of file extents
  btrfs-progs: handle fscrypt context items
  btrfs-progs: check: update inline extent length checking

 check/main.c                    | 34 ++++++++++++++++++---------------
 kernel-shared/ctree.h           |  1 +
 kernel-shared/print-tree.c      | 28 +++++++++++++++++++++++++--
 kernel-shared/tree-checker.c    | 17 ++++++++++-------
 kernel-shared/uapi/btrfs.h      |  1 +
 kernel-shared/uapi/btrfs_tree.h | 11 +++++++++++
 libbtrfsutil/btrfs.h            |  1 +
 7 files changed, 69 insertions(+), 24 deletions(-)

-- 
2.53.0


