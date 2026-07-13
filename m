Return-Path: <linux-fscrypt+bounces-1758-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id Cyw4F+pPVGrbkQMAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1758-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jul 2026 04:39:38 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from tor.lore.kernel.org (tor.lore.kernel.org [IPv6:2600:3c04:e001:36c::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id DCDF3746A97
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jul 2026 04:39:37 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b="jrW/JYM3";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1758-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c04:e001:36c::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1758-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by tor.lore.kernel.org (Postfix) with ESMTP id D26853011A44
	for <lists+linux-fscrypt@lfdr.de>; Mon, 13 Jul 2026 02:39:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3004D357CED;
	Mon, 13 Jul 2026 02:39:34 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E18F935839E;
	Mon, 13 Jul 2026 02:39:32 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783910374; cv=none; b=OlOFgVUpzn3aaIhI0ckONu7eNsliVmsmfGY4OGQ4bSJuYq343kllcOYsHUYQpZwSXahUxUwDPEIfmMTfI5OArqZrHcabGexZhK9UZTWR2naUj4M2WyR37IK/RyhF3XlWVhE+jZVec9zsv5khyGT3tBc+kEx+JlRYe1mOZUEUGYM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783910374; c=relaxed/simple;
	bh=84xiyY9aCfVQAoCwsVVef4h6mO+W3sOkq6IoWGvAuPw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FCyFKwykNNAaLeQCfXRoP0iLiWbIxqbD2t7h9PyQyd9p072PmrDIpHIQSSvYTMM49gzgQWgqsR/Lkrgjd8ntBb/6Gux6Sh35z8heTP+TQCHC+PKOmXStDv2fi2qRXVFaPnFs1oPn69FKQY+m0IOTk7aV9+9VgMNZmR5YfeSoFHs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jrW/JYM3; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B2961F00A3A;
	Mon, 13 Jul 2026 02:39:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783910372;
	bh=qHUq8H2gRat8UEbbTCOj349IaUIr6uNiumAUkOuvUW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jrW/JYM3ACUG+nhVVkCsyXJIFV5lZoq4QSBhj7fBWsGJSoRCWJYLRmhzHkAJGqMVe
	 8GZ5fICsJYPHOGTlUM5gr8uGyFKiOAe1vf3DYrG2UtDStan2eFVA870cmpg/X0PaKx
	 ccev9HVIMioftE4tyM/MJODhjjuyBCOiwQ3s+pogXjAn4Rxx/F1gKG2TcU1xNyOO4A
	 W5Y26dhNgqIR7Amh9UJgzoFB9y/DQA6EHwk4/o8cHbjtF9kdlffr9IB1mZ88xeOjb8
	 OIbzkJzROp8E4DhAFrHBB14HnhBZ7pa/85bX5Za/6UkCddKiwmyAGBRdQv7OfIg0GV
	 1DR9mnRxmQsxA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-ext4@vger.kernel.org,
	linux-f2fs-devel@lists.sourceforge.net,
	linux-block@vger.kernel.org,
	Christoph Hellwig <hch@lst.de>,
	Theodore Ts'o <tytso@mit.edu>,
	Andreas Dilger <adilger.kernel@dilger.ca>,
	Baokun Li <libaokun@linux.alibaba.com>,
	Jan Kara <jack@suse.cz>,
	Ojaswin Mujoo <ojaswin@linux.ibm.com>,
	Ritesh Harjani <ritesh.list@gmail.com>,
	Zhang Yi <yi.zhang@huawei.com>,
	Jaegeuk Kim <jaegeuk@kernel.org>,
	Chao Yu <chao@kernel.org>,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v3 01/17] blk-crypto: Simplify check for fallback support
Date: Sun, 12 Jul 2026 22:36:52 -0400
Message-ID: <20260713023708.9245-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260713023708.9245-1-ebiggers@kernel.org>
References: <20260713023708.9245-1-ebiggers@kernel.org>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-2.16 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	SUSPICIOUS_RECIPS(1.50)[];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	R_MISSING_CHARSET(0.50)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c04:e001:36c::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1758-lists,linux-fscrypt=lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_RECIPIENTS(0.00)[m:linux-fscrypt@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-ext4@vger.kernel.org,m:linux-f2fs-devel@lists.sourceforge.net,m:linux-block@vger.kernel.org,m:hch@lst.de,m:tytso@mit.edu,m:adilger.kernel@dilger.ca,m:libaokun@linux.alibaba.com,m:jack@suse.cz,m:ojaswin@linux.ibm.com,m:ritesh.list@gmail.com,m:yi.zhang@huawei.com,m:jaegeuk@kernel.org,m:chao@kernel.org,m:ebiggers@kernel.org,m:riteshlist@gmail.com,s:lists@lfdr.de];
	RCPT_COUNT_TWELVE(0.00)[16];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_COUNT_THREE(0.00)[4];
	FORGED_SENDER_MAILLIST(0.00)[];
	FORGED_SENDER(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	MIME_TRACE(0.00)[0:+];
	DKIM_TRACE(0.00)[kernel.org:+];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	FREEMAIL_CC(0.00)[vger.kernel.org,lists.sourceforge.net,lst.de,mit.edu,dilger.ca,linux.alibaba.com,suse.cz,linux.ibm.com,gmail.com,huawei.com,kernel.org];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:2600:3c04::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[tor.lore.kernel.org:helo,tor.lore.kernel.org:rdns,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: DCDF3746A97

Since blk-crypto-fallback supports all blk_crypto_keys except wrapped
keys, just check for that condition directly instead of using
__blk_crypto_cfg_supported().  With this done,
__blk_crypto_cfg_supported() is now used only for the hardware support.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 block/blk-crypto-fallback.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/block/blk-crypto-fallback.c b/block/blk-crypto-fallback.c
index 2a5c52ab74b4..2a8f40a65158 100644
--- a/block/blk-crypto-fallback.c
+++ b/block/blk-crypto-fallback.c
@@ -496,8 +496,7 @@ bool blk_crypto_fallback_bio_prep(struct bio *bio)
 		return false;
 	}
 
-	if (!__blk_crypto_cfg_supported(blk_crypto_fallback_profile,
-					&bc->bc_key->crypto_cfg)) {
+	if (bc->bc_key->crypto_cfg.key_type != BLK_CRYPTO_KEY_TYPE_RAW) {
 		bio_endio_status(bio, BLK_STS_NOTSUPP);
 		return false;
 	}
-- 
2.55.0


