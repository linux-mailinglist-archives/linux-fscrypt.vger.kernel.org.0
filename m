Return-Path: <linux-fscrypt+bounces-1647-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from mail.lfdr.de
	by mail.lfdr.de with LMTP
	id vC0wC8DPNGpShgYAu9opvQ
	(envelope-from <linux-fscrypt+bounces-1647-lists+linux-fscrypt=lfdr.de@vger.kernel.org>)
	for <lists+linux-fscrypt@lfdr.de>; Fri, 19 Jun 2026 07:12:32 +0200
X-Original-To: lists+linux-fscrypt@lfdr.de
Received: from sea.lore.kernel.org (sea.lore.kernel.org [IPv6:2600:3c0a:e001:db::12fc:5321])
	by mail.lfdr.de (Postfix) with ESMTPS id 756636A3EBA
	for <lists+linux-fscrypt@lfdr.de>; Fri, 19 Jun 2026 07:12:31 +0200 (CEST)
Authentication-Results: mail.lfdr.de;
	dkim=pass header.d=kernel.org header.s=k20260515 header.b=jITgX4un;
	spf=pass (mail.lfdr.de: domain of "linux-fscrypt+bounces-1647-lists+linux-fscrypt=lfdr.de@vger.kernel.org" designates 2600:3c0a:e001:db::12fc:5321 as permitted sender) smtp.mailfrom="linux-fscrypt+bounces-1647-lists+linux-fscrypt=lfdr.de@vger.kernel.org";
	dmarc=pass (policy=quarantine) header.from=kernel.org;
	arc=pass ("subspace.kernel.org:s=arc-20240116:i=1")
Received: from smtp.subspace.kernel.org (conduit.subspace.kernel.org [100.90.174.1])
	by sea.lore.kernel.org (Postfix) with ESMTP id C6D53304D738
	for <lists+linux-fscrypt@lfdr.de>; Fri, 19 Jun 2026 05:12:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1DD0E306743;
	Fri, 19 Jun 2026 05:12:28 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F3DB1C862D;
	Fri, 19 Jun 2026 05:12:26 +0000 (UTC)
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781845948; cv=none; b=YB8QmYxRS5Ru4VHPHAtpD6qSuiIaL1sq8mt6BcULg7fVSXwkcroxtFwkx2qsTSRSro4PNog8pJhNRPphWgga1jNq1dkIeNkci5g3xotfEtSXsVUFK/fRHboe4zzB0uoYMDVxVIYKkE79Ba7spDd6oXuMbkA+wbCwPoC41oo/Vdk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781845948; c=relaxed/simple;
	bh=RVcNG2MygTD8imRDyXIhjolFwbi4HfvkuycDzJQOp/E=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=SdUr2TsaJUbouGdqcfHeors/yXzEBef0jWyEUvgvfPo9obaaBQfwOQjrx/6hMeLR1oPTm8q9RCH2VyOxxcmE8h+1TD1My7MJ5k5BnzyAhMgIvi1uKoK3DM8O+a2jKLiQTqzT3NcV30Jzx/K7cBzBbPXtpeVtT3Ge+/vaVTfZYkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jITgX4un; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72D161F000E9;
	Fri, 19 Jun 2026 05:12:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1781845946;
	bh=rqTQoq17YZTaOUHBaqZGUDrKN1ugZvGwuK8pCcEVFc4=;
	h=From:To:Cc:Subject:Date;
	b=jITgX4ung7nDZb/MMIVAha58FxjsLQxpE/A41+NKn2Hy1ykT46Tq0X0sFgpD6GBRm
	 MqCQ2mzwnJ0dNYDCf++D+j8+QPS7jhdQNsk2zL1OFt9Ijn/VjLch2RtpCeMS8R3ueu
	 aGUS9I0JRCvIGIg08+3FD+Li0tFP2TdaPm98jeio3okKucLvv6c4gt0cmi027g6gql
	 /k36gGJhkLJrHmHgnTgmjHVNTaUvgzy0h2xtrBWOZSffxcgU45LTXAdXrk1YPexiQt
	 x3DxLdbjZdHS7WtiXZj0P9zu9AOpZGJe5SNpjGa4jSNwt1LyrdVmqa+OykSA1Z1hc7
	 oUNl3epaE50Jg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH] fscrypt: Remove workaround for bug in gcc 7 and earlier
Date: Thu, 18 Jun 2026 22:10:08 -0700
Message-ID: <20260619051008.51223-1-ebiggers@kernel.org>
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
	R_SPF_ALLOW(-0.20)[+ip6:2600:3c0a:e001:db::/64:c];
	R_DKIM_ALLOW(-0.20)[kernel.org:s=k20260515];
	MAILLIST(-0.15)[generic];
	MIME_GOOD(-0.10)[text/plain];
	HAS_LIST_UNSUB(-0.01)[];
	FORGED_RECIPIENTS(0.00)[m:linux-fscrypt@vger.kernel.org,m:linux-fsdevel@vger.kernel.org,m:linux-kernel@vger.kernel.org,m:ebiggers@kernel.org,s:lists@lfdr.de];
	TAGGED_FROM(0.00)[bounces-1647-lists,linux-fscrypt=lfdr.de];
	FORGED_RECIPIENTS_MAILLIST(0.00)[];
	FORWARDED(0.00)[lists@lfdr.de];
	RCVD_TLS_LAST(0.00)[];
	FORGED_SENDER_MAILLIST(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FORGED_SENDER(0.00)[ebiggers@kernel.org,linux-fscrypt@vger.kernel.org];
	RCVD_COUNT_THREE(0.00)[4];
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
	ASN(0.00)[asn:63949, ipnet:2600:3c0a::/32, country:SG];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[vger.kernel.org:from_smtp,sea.lore.kernel.org:rdns,sea.lore.kernel.org:helo]
X-Rspamd-Server: lfdr
X-Rspamd-Queue-Id: 756636A3EBA

Since the kernel's minimum gcc version is now 8.1, the workaround for a
strange gcc bug in fscrypt_ioctl_set_policy() is no longer needed.

Signed-off-by: Eric Biggers <ebiggers@kernel.org>
---
 fs/crypto/policy.c | 17 ++---------------
 1 file changed, 2 insertions(+), 15 deletions(-)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index 9915e39362db..f40fb5924e75 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -505,36 +505,23 @@ static int set_encryption_policy(struct inode *inode,
 int fscrypt_ioctl_set_policy(struct file *filp, const void __user *arg)
 {
 	union fscrypt_policy policy;
 	union fscrypt_policy existing_policy;
 	struct inode *inode = file_inode(filp);
-	u8 version;
 	int size;
 	int ret;
 
 	if (get_user(policy.version, (const u8 __user *)arg))
 		return -EFAULT;
 
 	size = fscrypt_policy_size(&policy);
 	if (size <= 0)
 		return -EINVAL;
 
-	/*
-	 * We should just copy the remaining 'size - 1' bytes here, but a
-	 * bizarre bug in gcc 7 and earlier (fixed by gcc r255731) causes gcc to
-	 * think that size can be 0 here (despite the check above!) *and* that
-	 * it's a compile-time constant.  Thus it would think copy_from_user()
-	 * is passed compile-time constant ULONG_MAX, causing the compile-time
-	 * buffer overflow check to fail, breaking the build. This only occurred
-	 * when building an i386 kernel with -Os and branch profiling enabled.
-	 *
-	 * Work around it by just copying the first byte again...
-	 */
-	version = policy.version;
-	if (copy_from_user(&policy, arg, size))
+	if (copy_from_user((u8 *)&policy + 1, (const u8 __user *)arg + 1,
+			   size - 1))
 		return -EFAULT;
-	policy.version = version;
 
 	if (!inode_owner_or_capable(&nop_mnt_idmap, inode))
 		return -EACCES;
 
 	ret = mnt_want_write_file(filp);

base-commit: 83f1454877cc292b88baf13c829c16ce6937d120
-- 
2.54.0


