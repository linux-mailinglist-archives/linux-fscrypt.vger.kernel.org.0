Return-Path: <linux-fscrypt+bounces-674-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9CAF1AE0E0C
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 Jun 2025 21:32:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id EF5847A1AAF
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 Jun 2025 19:31:17 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E639730E83E;
	Thu, 19 Jun 2025 19:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EZ/KQB6f"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C183330E82B
	for <linux-fscrypt@vger.kernel.org>; Thu, 19 Jun 2025 19:32:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750361554; cv=none; b=HO2ans2XDp2JnU197GwudmuMZ5MDJq6a+kPTutAwsf9jD2AibvP0pLdvL3bKzbXGgUyqPGihLfye38RLPLag7+JCJ2MXxT4htWOVXsgw4Z7zSMFzVxhH4cMF+nAelkjXz2jOaFMJ6dMZp53K8IeQAO6gfdxnOVvMRCX0HPyC4S0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750361554; c=relaxed/simple;
	bh=ZD6pPs7Oet5E4cXNVHbncT/yNS0lXqmv6p4pqwP9XrQ=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=AdU1xYHNJMjaqQQJDHmE+rpmPmRNYgyJMytWeq3fEb9xA9SEVpgijSC0XcimrzKrndfBtKL1J01j9lxCK+eiCf1TbI6EfszmMfJRe2Ah42mVr++1moBlnSvouNPQhnSJKaw2hUa0OgEBS1GZL1pCin17UjDIMyYBENK+N8/5yjk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EZ/KQB6f; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53F95C4CEEA
	for <linux-fscrypt@vger.kernel.org>; Thu, 19 Jun 2025 19:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1750361554;
	bh=ZD6pPs7Oet5E4cXNVHbncT/yNS0lXqmv6p4pqwP9XrQ=;
	h=From:To:Subject:Date:From;
	b=EZ/KQB6fLrGj4YAIoIW9dpiV/7FL5ufVl1cLIM8JzEtH4l5peguYpgSR7ukofjsrC
	 h65SpPeDmB1dKtHk/XAZiWb2h2+xisQEFtE3aMVNOJJBAePQ7gWw7EXohd8OpiYJM+
	 xI61NDubPNLvz77EdbBPNWLgpfCmlVMtFyiltqfyIaxBXQsvsbyHKYh54OOOZYLLnf
	 aB46XKT+Jf5ZKI1tmA8aj/jlz/xs2kYxrqY6Fmtgtl+zpxgbiQxAZZUj3lKlEay7EN
	 nvc1cwoTYZVlp3QUx/+iyESTknT4eRP2S4to7Syj3HxJZErGr9fbG1h7eA0P8bJDB5
	 CE/c1BYUF6w5A==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: drop obsolete recommendation to enable optimized SHA-512
Date: Thu, 19 Jun 2025 12:31:49 -0700
Message-ID: <20250619193149.138315-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Since the crypto kconfig options are being fixed to enable optimized
SHA-512 automatically
(https://lore.kernel.org/linux-crypto/20250616014019.415791-1-ebiggers@kernel.org/),
it is no longer necessary to give a recommendation to enable it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fscrypt.rst | 8 --------
 1 file changed, 8 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 29e84d125e024..f63791641c1d9 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -466,18 +466,10 @@ API, but the filenames mode still does.
         - CONFIG_CRYPTO_ESSIV
         - CONFIG_CRYPTO_SHA256 or another SHA-256 implementation
     - Recommended:
         - AES-CBC acceleration
 
-fscrypt also uses HMAC-SHA512 for key derivation, so enabling SHA-512
-acceleration is recommended:
-
-- SHA-512
-    - Recommended:
-        - arm64: CONFIG_CRYPTO_SHA512_ARM64_CE
-        - x86: CONFIG_CRYPTO_SHA512_SSSE3
-
 Contents encryption
 -------------------
 
 For contents encryption, each file's contents is divided into "data
 units".  Each data unit is encrypted independently.  The IV for each

base-commit: 19272b37aa4f83ca52bdf9c16d5d81bdd1354494
-- 
2.50.0


