Return-Path: <linux-fscrypt+bounces-1652-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id ckFnGuhlO2pIXQgAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1652-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 07:06:48 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id D015A6BB600
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 07:06:47 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=hLmfBDEM;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1652-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1652-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C023C3065932
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2026 05:06:03 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 337B23815D0;
	Wed, 24 Jun 2026 05:06:01 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA68A380FD1;
	Wed, 24 Jun 2026 05:05:59 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782277561; cv=none; b=I7rxl7U7wRN93kYyOYAH9YxRHmg7SOfzNjIGXRXYqRe9RcTDkogPSWVwtptoRO13LsTNzRgZgW8XTheXNiegdPyVeXYBAIXssEJQB4h272nQr9XjKVB3l5F2C1tkKMposLzHwe74IdqLUnFvLf5dy3AvHqR8sR81fBsVxUNc29Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782277561; c=relaxed/simple;
	bh=s4ul5693h1oDY7rJmadlv+yYhnSinAAHxoW0oiL9Pp8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z2o+y1tgkccB2kwJu5yPq11fXOwsfyEmheN+K1i9bgVAr6ByTuPtEQ+szI+0W2rZRoKITacJWk+IGgNSEFGk87Yo4KpUcDaiR0BCOc42IcryVsR+9Doz6fDh+KOjyWMz+sF7lRG5AqIPH1xV5nIz87/eNbfmpR0eK8CNIpL+Sdc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hLmfBDEM; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D4B71F00A3E;
	Wed, 24 Jun 2026 05:05:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782277559;
	bh=lPH0UMQfDl3YAr28CUIry+4cjf/OMOF0bylodk25xRQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hLmfBDEMQ1hPOMkn+crXMjxoKmNS8pwqRQPDc87m7MZhhsJsdluEsetaSm8iNfGgi
	 jtOGZbJ07b6SUVMsztjXRSMa0QjckjRO2vvrdtVgv03mej4b37jEO7AFBuNalp2Bux
	 mmcFc0UnhOhzsWjPYaAiScfH+5RRl7qUkRWveNu8eBqmfuzO5lbcUfpg6BqgiPwIh0
	 xTogghjFT5ZjnZ/2Qfy7gZYpmBR8z79KQgfmY4Prl7vuxIH1QHJUk5SIm096oCO3CG
	 ZzfLhqsw2oOE+1QtIEEsQm+1D2oFniOJ6xtrONIPHI5dd5dgvAKlskkf47qvussjdp
	 Fy5mq8BfYEpJQ==
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
Subject: [PATCH 02/16] blk-crypto: Fold __blk_crypto_cfg_supported() into its caller
Date: Tue, 23 Jun 2026 22:03:20 -0700
Message-ID: <20260624050334.124606-3-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260624050334.124606-1-ebiggers@kernel.org>
References: <20260624050334.124606-1-ebiggers@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	TAGGED_FROM(0.00)[bounces-1652-lists,linux-fscrypt=lfdr.de];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: D015A6BB600

__blk_crypto_cfg_supported() is called only by
blk_crypto_config_supported_natively(), so fold it in.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 block/blk-crypto-profile.c | 22 ----------------------
 block/blk-crypto.c         | 23 +++++++++++++++++++++--
 2 files changed, 21 insertions(+), 24 deletions(-)

diff --git a/block/blk-crypto-profile.c b/block/blk-crypto-profile.c
index cf447ba4a66e..53126c091b0b 100644
--- a/block/blk-crypto-profile.c
+++ b/block/blk-crypto-profile.c
@@ -333,32 +333,10 @@ void blk_crypto_put_keyslot(struct blk_crypto_keyslot *slot)
 		spin_unlock_irqrestore(&profile->idle_slots_lock, flags);
 		wake_up(&profile->idle_slots_wait_queue);
 	}
 }
 
-/**
- * __blk_crypto_cfg_supported() - Check whether the given crypto profile
- *				  supports the given crypto configuration.
- * @profile: the crypto profile to check
- * @cfg: the crypto configuration to check for
- *
- * Return: %true if @profile supports the given @cfg.
- */
-bool __blk_crypto_cfg_supported(struct blk_crypto_profile *profile,
-				const struct blk_crypto_config *cfg)
-{
-	if (!profile)
-		return false;
-	if (!(profile->modes_supported[cfg->crypto_mode] & cfg->data_unit_size))
-		return false;
-	if (profile->max_dun_bytes_supported < cfg->dun_bytes)
-		return false;
-	if (!(profile->key_types_supported & cfg->key_type))
-		return false;
-	return true;
-}
-
 /*
  * This is an internal function that evicts a key from an inline encryption
  * device that can be either a real device or the blk-crypto-fallback "device".
  * It is used only by blk_crypto_evict_key(); see that function for details.
  */
diff --git a/block/blk-crypto.c b/block/blk-crypto.c
index 15e25e41b166..dd83fc5af282 100644
--- a/block/blk-crypto.c
+++ b/block/blk-crypto.c
@@ -349,15 +349,34 @@ int blk_crypto_init_key(struct blk_crypto_key *blk_key,
 
 	return 0;
 }
 EXPORT_SYMBOL_GPL(blk_crypto_init_key);
 
+
+/**
+ * blk_crypto_config_supported_natively() - Check whether a block device
+ *					    supports hardware inline encryption
+ *					    with the given configuration.
+ * @bdev: the block device
+ * @cfg: the crypto configuration to check for
+ *
+ * Return: %true if @bdev supports hardware inline encryption with @cfg.
+ */
 bool blk_crypto_config_supported_natively(struct block_device *bdev,
 					  const struct blk_crypto_config *cfg)
 {
-	return __blk_crypto_cfg_supported(bdev_get_queue(bdev)->crypto_profile,
-					  cfg);
+	struct blk_crypto_profile *profile = bdev_get_queue(bdev)->crypto_profile;
+
+	if (!profile)
+		return false;
+	if (!(profile->modes_supported[cfg->crypto_mode] & cfg->data_unit_size))
+		return false;
+	if (profile->max_dun_bytes_supported < cfg->dun_bytes)
+		return false;
+	if (!(profile->key_types_supported & cfg->key_type))
+		return false;
+	return true;
 }
 
 /*
  * Check if bios with @cfg can be en/decrypted by blk-crypto (i.e. either the
  * block_device it's submitted to supports inline crypto, or the
-- 
2.54.0


