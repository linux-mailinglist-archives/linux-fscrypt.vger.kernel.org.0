Return-Path: <linux-fscrypt+bounces-178-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A813B84B249
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 Feb 2024 11:16:40 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6427E28A7B0
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 Feb 2024 10:16:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2074912E1F0;
	Tue,  6 Feb 2024 10:16:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NjtyuZCZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Q3zU5kg6";
	dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b="NjtyuZCZ";
	dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b="Q3zU5kg6"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F6C12E1D8;
	Tue,  6 Feb 2024 10:16:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707214586; cv=none; b=c4aS6sXOoo8h0WezV4ueFwF+vZlM7/9FpsQRG8MDZpWjBdGIeLV6Uf17WvsY/ursU7Klwy/8XmUkfbGe1DiOJzlELEzNxnsqBBArJvkjSUn59iyNuyb13OJyeA/KE/5Sv5pvAAJWoCfYMsiDVOWenGQwUckOdWHaky00exwhsiE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707214586; c=relaxed/simple;
	bh=JLStoQUTBclwGMIg4iQAeZltWYDX8/fp91Ubem0/TXk=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VzoAfXvAzMZsqKc2Rqe4QuJlyjlDozga9tKudR3hhnF9RcMZT+VbIwAsYzFFUU9Vzl0AzR3maGw1KnDgwsFwKPbbgIV4RFj5fGoAyGc9+cif+hiebqrRYSTBeHvap38+K/jqYAxdU+GYbSz83TrsdQWcFG+iEpTqELIm3wkQH0Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de; spf=pass smtp.mailfrom=suse.de; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NjtyuZCZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Q3zU5kg6; dkim=pass (1024-bit key) header.d=suse.de header.i=@suse.de header.b=NjtyuZCZ; dkim=permerror (0-bit key) header.d=suse.de header.i=@suse.de header.b=Q3zU5kg6; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=suse.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.de
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 142CD220F1;
	Tue,  6 Feb 2024 10:16:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707214582; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Qjjytxk+YrJqkh2UdaOiVqqhU2xaLDtEuunmNkVgd3w=;
	b=NjtyuZCZvpGOxb1zkmajaqwpdzbn+CM8/0dcTsqDHkcvnRAjzN5L2PBBgyrR8ai0fmuuh4
	LCOVS7mBETFu6G39tUgwUOCxYxefpw7NRRS3nY4nPJaxWSk3PR+10cSth+iaVQxLFTzLIp
	Vf4sI2gJi+ekoqUCXIa3X6luvwCq+0E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707214582;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Qjjytxk+YrJqkh2UdaOiVqqhU2xaLDtEuunmNkVgd3w=;
	b=Q3zU5kg6tfmOWkjaMA7gF4JDyIBYWAglfBv36DQ3rx3uL0ZaLsWBI8ACL/DaFRriH/1obI
	sM0Tb0jcAcHpiyBQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
	t=1707214582; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Qjjytxk+YrJqkh2UdaOiVqqhU2xaLDtEuunmNkVgd3w=;
	b=NjtyuZCZvpGOxb1zkmajaqwpdzbn+CM8/0dcTsqDHkcvnRAjzN5L2PBBgyrR8ai0fmuuh4
	LCOVS7mBETFu6G39tUgwUOCxYxefpw7NRRS3nY4nPJaxWSk3PR+10cSth+iaVQxLFTzLIp
	Vf4sI2gJi+ekoqUCXIa3X6luvwCq+0E=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
	s=susede2_ed25519; t=1707214582;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:  content-transfer-encoding:content-transfer-encoding;
	bh=Qjjytxk+YrJqkh2UdaOiVqqhU2xaLDtEuunmNkVgd3w=;
	b=Q3zU5kg6tfmOWkjaMA7gF4JDyIBYWAglfBv36DQ3rx3uL0ZaLsWBI8ACL/DaFRriH/1obI
	sM0Tb0jcAcHpiyBQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 7771913A3A;
	Tue,  6 Feb 2024 10:16:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id xuDNGfUGwmXLfAAAD6G6ig
	(envelope-from <lhenriques@suse.de>); Tue, 06 Feb 2024 10:16:21 +0000
Received: from localhost (brahms.olymp [local])
	by brahms.olymp (OpenSMTPD) with ESMTPA id f760fa64;
	Tue, 6 Feb 2024 10:16:20 +0000 (UTC)
From: Luis Henriques <lhenriques@suse.de>
To: Eric Biggers <ebiggers@kernel.org>,
	"Theodore Y. Ts'o" <tytso@mit.edu>,
	Jaegeuk Kim <jaegeuk@kernel.org>
Cc: David Howells <dhowells@redhat.com>,
	Jarkko Sakkinen <jarkko@kernel.org>,
	linux-fscrypt@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Luis Henriques <lhenriques@suse.de>
Subject: [PATCH] fscrypt: clear keyring before calling key_put()
Date: Tue,  6 Feb 2024 10:16:19 +0000
Message-ID: <20240206101619.8083-1-lhenriques@suse.de>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Authentication-Results: smtp-out1.suse.de;
	none
X-Spam-Level: ***
X-Spam-Score: 3.70
X-Spamd-Result: default: False [3.70 / 50.00];
	 ARC_NA(0.00)[];
	 RCVD_VIA_SMTP_AUTH(0.00)[];
	 FROM_HAS_DN(0.00)[];
	 TO_DN_SOME(0.00)[];
	 R_MISSING_CHARSET(2.50)[];
	 TO_MATCH_ENVRCPT_ALL(0.00)[];
	 MIME_GOOD(-0.10)[text/plain];
	 BROKEN_CONTENT_TYPE(1.50)[];
	 NEURAL_HAM_LONG(-1.00)[-1.000];
	 RCVD_COUNT_THREE(0.00)[4];
	 DKIM_SIGNED(0.00)[suse.de:s=susede2_rsa,suse.de:s=susede2_ed25519];
	 NEURAL_HAM_SHORT(-0.20)[-1.000];
	 RCPT_COUNT_SEVEN(0.00)[8];
	 MID_CONTAINS_FROM(1.00)[];
	 DBL_BLOCKED_OPENRESOLVER(0.00)[suse.de:email];
	 FUZZY_BLOCKED(0.00)[rspamd.com];
	 FROM_EQ_ENVFROM(0.00)[];
	 MIME_TRACE(0.00)[0:+];
	 RCVD_TLS_LAST(0.00)[];
	 BAYES_HAM(-0.00)[32.10%]
X-Spam-Flag: NO

Now that the key quotas are handled immediately on key_put() instead of
being postponed to the key management garbage collection worker, a call to
keyring_clear() is all that is required in fscrypt_put_master_key() so that
the keyring clean-up is also done synchronously.  This patch should fix the
fstest generic/581 flakiness.

Signed-off-by: Luis Henriques <lhenriques@suse.de>
---
Hi!

I know that patch "keys: update key quotas in key_put()" isn't yet merged
but since David and Jarkko seem to be OK with it, it doesn't hurt to send
this follow-up patch immediately.

Cheers,
-- 
Luis

 fs/crypto/keyring.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index 0edf0b58daa7..dfdaae16b83a 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -74,8 +74,11 @@ void fscrypt_put_master_key(struct fscrypt_master_key *mk)
 	 * that concurrent keyring lookups can no longer find it.
 	 */
 	WARN_ON_ONCE(refcount_read(&mk->mk_active_refs) != 0);
-	key_put(mk->mk_users);
-	mk->mk_users = NULL;
+	if (mk->mk_users) {
+		keyring_clear(mk->mk_users);
+		key_put(mk->mk_users);
+		mk->mk_users = NULL;
+	}
 	call_rcu(&mk->mk_rcu_head, fscrypt_free_master_key);
 }
 

