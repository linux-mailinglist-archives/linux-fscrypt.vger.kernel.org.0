Return-Path: <linux-fscrypt+bounces-1669-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id oslmLBEMPGrCjAgAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1669-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 18:55:45 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 363426C0212
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 18:55:45 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=suse.com header.s=susede1 header.b=jhMmKh+1;
	dkim=pass header.d=suse.com header.s=susede1 header.b=jhMmKh+1;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1669-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1669-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=suse.com;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id 7B7583040F93
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 16:51:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BCB0A33EB01;
	Wed, 24 Jun 2026 16:51:53 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6745A3382F9
	for <linux-fscrypt@vger.kernel.org>; Wed, 24 Jun 2026 16:51:52 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782319913; cv=none; b=G/yUsYIUuKjzieMZ6b8oeLbwnEyB6mx2qMgtc6SSRejW9cvM0IjjoKfiSBqpqG8ae9GDwoGuHAThdS2IvPED84OoyG90Wh7x0SydN3/GTtZTFvIXSyXcy6mViUnY+u1lg8Qpc4IoBYUB1e5eCfHrPDbQS092OVdN9hUKeA9lTxg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782319913; c=relaxed/simple;
	bh=zTgx3ilLxt2zM0S75KL0awkTRUIONWc3w8EXdSQL7k4=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=KV5hVfcncjv36CFRNYpRMNBsqFgi+MzkVNLYiRF34hudCMFrrCiIpaq7LgSjgi4wkrmxWpNnrvOatEtgmLXAwzPXp8Y3SDBzxm6Ev96CJ0oR4nCr6pWH8XLaKN5fvPhWurx84a7snS1gUZtVm6IjwLY+x6To0hEDhLQAmlxjWSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=suse.com; spf=pass smtp.mailfrom=suse.com; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jhMmKh+1; dkim=pass (1024-bit key) header.d=suse.com header.i=@suse.com header.b=jhMmKh+1; arc=none smtp.client-ip=195.135.223.130
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id BC2C76D657;
	Wed, 24 Jun 2026 16:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782319910; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cW4XPqgvFkNAMKr0y0hEImXwCMZOOqLQtgYYlU3ouvI=;
	b=jhMmKh+1cgk0M9IlN/MOVkD2B5jKydedZLcQe7kKz2Kgz7BroQ1Nln4FVQO7PT5nkMrJ+S
	CpdU9pLpKTAGbeKd1KJIkNnQEBijrm8MaF2vMF+4bruiXj6cHeiQEVp07GW36bCb5bU/iu
	LgVYqnjw+CItHbQ6MY+Qt5GMw5wqJec=
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
	t=1782319910; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=cW4XPqgvFkNAMKr0y0hEImXwCMZOOqLQtgYYlU3ouvI=;
	b=jhMmKh+1cgk0M9IlN/MOVkD2B5jKydedZLcQe7kKz2Kgz7BroQ1Nln4FVQO7PT5nkMrJ+S
	CpdU9pLpKTAGbeKd1KJIkNnQEBijrm8MaF2vMF+4bruiXj6cHeiQEVp07GW36bCb5bU/iu
	LgVYqnjw+CItHbQ6MY+Qt5GMw5wqJec=
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id A8560779A8;
	Wed, 24 Jun 2026 16:51:50 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id 4euYKCYLPGrUTgAAD6G6ig
	(envelope-from <neelx@suse.com>); Wed, 24 Jun 2026 16:51:50 +0000
From: Daniel Vacek <neelx@suse.com>
To: David Sterba <dsterba@suse.com>
Cc: Daniel Vacek <neelx@suse.com>,
	linux-fscrypt@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/8] btrfs-progs: fscrypt updates
Date: Wed, 24 Jun 2026 18:51:36 +0200
Message-ID: <20260624165144.556908-1-neelx@suse.com>
X-Mailer: git-send-email 2.53.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Flag: NO
X-Spam-Score: -2.79
X-Spam-Level: 
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
	TAGGED_FROM(0.00)[bounces-1669-lists,linux-fscrypt=lfdr.de];
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
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:dkim,suse.com:mid,suse.com:from_mime,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 363426C0212

This series is a rebase of an older set of fscrypt related changes from
Sweet Tea Dorminy and Josef Bacik found here:
https://github.com/josefbacik/btrfs-progs/tree/fscrypt

Since then the on-disk format changed and parts of the series had to be
reworked. Now it works with the v7 of kernel changes.

Particularly the encryption context is now stored as dedicated item and
not glued onto extent data item.

Also it was missing to recognize the ENCRYPT inode item flag. So now
it's properly parsed.

It passed all my tests. Hopefully nothing blows. Enjoy testing.

Daniel Vacek (1):
  btrfs-progs: recognize ENCRYPT inode item flag

Josef Bacik (1):
  btrfs-progs: check: fix max inline extent size

Sweet Tea Dorminy (6):
  btrfs-progs: add new FEATURE_INCOMPAT_ENCRYPT flag
  btrfs-progs: start tracking extent encryption context info
  btrfs-progs: add inode encryption contexts
  btrfs-progs: print encryptin type field of file extents
  btrfs-progs: handle fscrypt context items
  btrfs-progs: check: update inline extent length checking

 check/main.c                    | 29 +++++++++++++++--------------
 kernel-shared/ctree.h           |  1 +
 kernel-shared/print-tree.c      | 23 +++++++++++++++++++++++
 kernel-shared/tree-checker.c    | 17 ++++++++++-------
 kernel-shared/uapi/btrfs.h      |  1 +
 kernel-shared/uapi/btrfs_tree.h | 11 +++++++++++
 libbtrfsutil/btrfs.h            |  1 +
 7 files changed, 62 insertions(+), 21 deletions(-)

-- 
2.53.0


