Return-Path: <linux-fscrypt+bounces-1645-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id qj/mAth8NGrUZQYAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1645-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 19 Jun 2026 01:18:48 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [172.234.253.10])
	by mail.lfdr.de (Postfix) with ESMTPS id 9A45E6A30FC
	for <lists+linux-fscrypt@lfdr.de>; Fri, 19 Jun 2026 01:18:47 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=Rd10Zra7;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1645-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 172.234.253.10 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1645-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id EBCA0303FF2C
	for <lists+linux-fscrypt@lfdr.de>; Thu, 18 Jun 2026 23:18:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A31423382CB;
	Thu, 18 Jun 2026 23:18:02 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C67054652;
	Thu, 18 Jun 2026 23:18:01 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781824682; cv=none; b=aWrIX5waiBK9FKJcKNzDtjseQCDrMKe9670G0Z76YatcOS0Zh+w9AJtI6KV/2YO4THWCXU9B2ygwTiSVF/GWPdxL48y91GrqfDnD4lq1WgO6DFrTR4Yavbkjss9u8VCbJKS8h81I414aUNEtvbyhh5CtqHruZ6BaYQfpHHPiwRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781824682; c=relaxed/simple;
	bh=AQ9aN/avZH+dC3EJ/xi73ddT75IimODO/c4Su8oqChc=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Np08rV65wxabtMF8PBEh3Dq+f0i/O7XKYMjunVf2YwHUHqCe4bmogLj9Y5NwgLuv8SHtKVrj6Tr2/D1Ky2ogx2aA9hQZ2HLlz+5nOBlhgyZc/fVQdGsH15wp7X3mKNQR5xTRP5GS/Co5Qwba9RQuU/3+ROeLugw61Db/NANSEP0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rd10Zra7; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 094B61F00A3A;
	Thu, 18 Jun 2026 23:18:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781824681;
	bh=hg+xs+/jSzmt7asxD6BemBLz25eZ0+EDLv5XtrFMhDg=;
	h=From:To:Cc:Subject:Date;
	b=Rd10Zra7TESGH13gOVI51QwkVLcD0xfxZDx2R6ZzFTKMCSS30+kpIX8NlHNUPK588
	 jsip9TshBD1zXSzqveChzWXeEAFCAX0VLW4KDafrz+yutYZhd80rEA53l3qI5BJrj+
	 u+2FwAsO9XI2f1VVcHSFQSQrYl7qWe9dbme3QjSXL2qySIE5gr1QvLuaPIC2ux4KbY
	 QJ4BCW0Vo5ghsTZqDUPFSyKT3eNvpRv4nWw6rOD0npCHqP4989zMQX6RyQmceMd/MY
	 bEGRSnfSNYD+tALQSlmM8X/zwRaKr4I6jmwVgpNQ2gks7uNIPOMw39rISeA06L5hcP
	 npUq7fNDizlEg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] fscrypt: Remove FSCRYPT_MODE_MAX
Date: Thu, 18 Jun 2026 16:14:04 -0700
Message-ID: <20260618231404.132829-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.54.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Rspamd-Action: no action
X-Spamd-Result: default: False [-3.66 / 15.00];
	WHITELIST_SPF_DKIM(-3.00)[kernel.org:d:+,kernel.org:s:+];
	ARC_ALLOW(-1.00)[subspace.kernel.org:s=arc-20240116:i=1];
	MID_CONTAINS_FROM(1.00)[];
	DMARC_POLICY_ALLOW(-0.50)[kernel.org,quarantine];
	R_MISSING_CHARSET(0.50)[];
	R_SPF_ALLOW(-0.20)[+ip4:172.234.253.10:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	RCVD_COUNT_THREE(0.00)[4];
	TAGGED_FROM(0.00)[bounces-1645-lists,linux-fscrypt=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FORGED_RECIPIENTS(0.00)[m:linux-fscrypt@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:ebiggers@kernel.org,s:lists@lfdr.de];
	RCPT_COUNT_THREE(0.00)[4];
	TO_DN_SOME(0.00)[];
	PRECEDENCE_BULK(0.00)[];
	FORGED_SENDER_FORWARDING(0.00)[];
	FROM_NEQ_ENVFROM(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	FROM_HAS_DN(0.00)[];
	DKIM_TRACE(0.00)[kernel.org:+];
	ALIAS_RESOLVED(0.00)[];
	TAGGED_RCPT(0.00)[linux-fscrypt];
	FORGED_RECIPIENTS_FORWARDING(0.00)[];
	ASN(0.00)[asn:63949, ipnet:172.234.224.0/19, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo,vger.kernel.org:from_smtp]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 9A45E6A30FC

Now that the arrays of per-mode keys in struct fscrypt_master_key have
been replaced by a linked list, the definition of FSCRYPT_MODE_MAX
doesn't do anything useful.  (Previously it was used to size these
arrays.)  Remove it.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/crypto/fscrypt_private.h        | 3 ---
 fs/crypto/keysetup.c               | 5 -----
 include/uapi/linux/fscrypt.h       | 1 -
 tools/include/uapi/linux/fscrypt.h | 1 -
 4 files changed, 10 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 0053b5c45412..45307f7fa540 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -64,13 +64,10 @@
 	 CRYPTO_ALG_KERN_DRIVER_ONLY)
 
 #define FSCRYPT_CONTEXT_V1	1
 #define FSCRYPT_CONTEXT_V2	2
 
-/* Keep this in sync with include/uapi/linux/fscrypt.h */
-#define FSCRYPT_MODE_MAX	FSCRYPT_MODE_AES_256_HCTR2
-
 struct fscrypt_context_v1 {
 	u8 version; /* FSCRYPT_CONTEXT_V1 */
 	u8 contents_encryption_mode;
 	u8 filenames_encryption_mode;
 	u8 flags;
diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
index 281b5a8b0bcd..cfd348e2252e 100644
--- a/fs/crypto/keysetup.c
+++ b/fs/crypto/keysetup.c
@@ -81,12 +81,10 @@ static DEFINE_MUTEX(fscrypt_mode_key_setup_mutex);
 
 static struct fscrypt_mode *
 select_encryption_mode(const union fscrypt_policy *policy,
 		       const struct inode *inode)
 {
-	BUILD_BUG_ON(ARRAY_SIZE(fscrypt_modes) != FSCRYPT_MODE_MAX + 1);
-
 	if (S_ISREG(inode->i_mode))
 		return &fscrypt_modes[fscrypt_policy_contents_mode(policy)];
 
 	if (S_ISDIR(inode->i_mode) || S_ISLNK(inode->i_mode))
 		return &fscrypt_modes[fscrypt_policy_fnames_mode(policy)];
@@ -227,13 +225,10 @@ static int setup_per_mode_enc_key(struct fscrypt_inode_info *ci,
 	u8 hkdf_info[sizeof(mode_num) + sizeof(sb->s_uuid)];
 	unsigned int hkdf_infolen = 0;
 	bool use_hw_wrapped_key = false;
 	int err;
 
-	if (WARN_ON_ONCE(mode_num > FSCRYPT_MODE_MAX))
-		return -EINVAL;
-
 	if (mk->mk_secret.is_hw_wrapped && S_ISREG(inode->i_mode)) {
 		/* Using a hardware-wrapped key for file contents encryption */
 		if (!fscrypt_using_inline_encryption(ci)) {
 			if (sb->s_flags & SB_INLINECRYPT)
 				fscrypt_warn(ci->ci_inode,
diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
index 3aff99f2696a..84507280b3ea 100644
--- a/include/uapi/linux/fscrypt.h
+++ b/include/uapi/linux/fscrypt.h
@@ -28,11 +28,10 @@
 #define FSCRYPT_MODE_AES_128_CTS		6
 #define FSCRYPT_MODE_SM4_XTS			7
 #define FSCRYPT_MODE_SM4_CTS			8
 #define FSCRYPT_MODE_ADIANTUM			9
 #define FSCRYPT_MODE_AES_256_HCTR2		10
-/* If adding a mode number > 10, update FSCRYPT_MODE_MAX in fscrypt_private.h */
 
 /*
  * Legacy policy version; ad-hoc KDF and no key verification.
  * For new encrypted directories, use fscrypt_policy_v2 instead.
  *
diff --git a/tools/include/uapi/linux/fscrypt.h b/tools/include/uapi/linux/fscrypt.h
index 3aff99f2696a..84507280b3ea 100644
--- a/tools/include/uapi/linux/fscrypt.h
+++ b/tools/include/uapi/linux/fscrypt.h
@@ -28,11 +28,10 @@
 #define FSCRYPT_MODE_AES_128_CTS		6
 #define FSCRYPT_MODE_SM4_XTS			7
 #define FSCRYPT_MODE_SM4_CTS			8
 #define FSCRYPT_MODE_ADIANTUM			9
 #define FSCRYPT_MODE_AES_256_HCTR2		10
-/* If adding a mode number > 10, update FSCRYPT_MODE_MAX in fscrypt_private.h */
 
 /*
  * Legacy policy version; ad-hoc KDF and no key verification.
  * For new encrypted directories, use fscrypt_policy_v2 instead.
  *

base-commit: 83f1454877cc292b88baf13c829c16ce6937d120
prerequisite-patch-id: 319d2891e88c7df1ebb5ebf434d18b68f770399f
prerequisite-patch-id: 5330c9e4b65644baae81bd177a46be6223d2b494
prerequisite-patch-id: f6157c86deab0ff5ec953ae3ed6b0e84f37741bf
-- 
2.54.0


