Return-Path: <linux-fscrypt+bounces-694-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from am.mirrors.kernel.org (am.mirrors.kernel.org [147.75.80.249])
	by mail.lfdr.de (Postfix) with ESMTPS id D6BB4AFF95C
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Jul 2025 08:14:13 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by am.mirrors.kernel.org (Postfix) with ESMTPS id 266951C85A82
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Jul 2025 06:13:32 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id CF0EE288512;
	Thu, 10 Jul 2025 06:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="s9Zov/HU"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9CB4428750F;
	Thu, 10 Jul 2025 06:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752127804; cv=none; b=oNA3GbYkbBr4qcXR8f1MbV/ieqhXVCPqnAS4ILPhmWTyE5mM4MCImC4O2GpRiUY0Y9c5gG5uUJBD5VoXQv7jbjau7B0tWvTor7RUuip0X7P25CMbgrZm0r8ENTOxrm2BGowqZJp61bbHrvTQVpIU/4mKLo8kIA9XfPah9+bRTUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752127804; c=relaxed/simple;
	bh=A3irvs3v7PeKCQdQ382HRWJhQhk42uJw8OaFzTK/jwY=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=Nz5zKewoGzxqwZXzKaCuKTMUsdq1CMl0tymMdjzer4tcJOJU+FvuvZnVHcRVSQAd6+M1vJvTmFsrDeVjXomITj6TNn/eJsZqo3A6oYG1zQnfHNzlAhXKDzhwi5rm3DNcrespcWppY8w8aVRT9w0n91J/iUqvXRhpo3cQH1LZjok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=s9Zov/HU; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A90C4CEE3;
	Thu, 10 Jul 2025 06:10:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1752127804;
	bh=A3irvs3v7PeKCQdQ382HRWJhQhk42uJw8OaFzTK/jwY=;
	h=From:To:Cc:Subject:Date:From;
	b=s9Zov/HUucOp8tvLbXEgwce5AL6ve4tknQy4CUaMJSs32zOki/FDKYJ+T4ISkPv4f
	 5OnIcVmzIBJsAguAGhqYWArSGIfvUG9cGL1pF4TPDA2vTb9dqivxAb1t6fxOsOljIW
	 tC9CbGFllXrNC5+7hZ9ZnIaWCNHIc0iwBsbQhncDdFG0kmc5k5Hx/6Eh7iAy8eBv0V
	 LeaVm9fr03M8tjFggiVDqe4/dUj8QIlekG7LjnG96rctZ/+qFDLvnNNH93t0L2lXcY
	 gX+70CUs9eri1BkneIBwFfnCuixDGPWsWKJTrioINVNN82f24Yo/BpUaKYGhfItrQW
	 rjxOGfkQ1MgFA==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: linux-crypto@vger.kernel.org,
	Yuwen Chen <ywen.chen@foxmail.com>,
	linux-mtd@lists.infradead.org,
	ceph-devel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH v2 0/6] fscrypt: Switch to sync_skcipher and on-stack requests
Date: Wed,  9 Jul 2025 23:07:47 -0700
Message-ID: <20250710060754.637098-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Simplify the code and eliminate per-encryption-op dynamic memory
allocations by switching from crypto_skcipher to crypto_sync_skcipher,
and from dynamic request allocation to SYNC_SKCIPHER_REQUEST_ON_STACK.

Previously, this change would have made the x86 accelerated AES code no
longer be used, which would have been very bad.  However, I fixed that
in 6.16.  So we can make this simplification now.

This patchset applies to fscrypt/for-next.  The base-commit (listed
below) can be found in next-20250708

Changed in v2:
- Added patches that remove the gfp_t argument from functions that no
  longer need it.
- Eliminated the goto in derive_key_aes().
- Improved commit messages.

Eric Biggers (6):
  fscrypt: Don't use asynchronous CryptoAPI algorithms
  fscrypt: Drop FORBID_WEAK_KEYS flag for AES-ECB
  fscrypt: Switch to sync_skcipher and on-stack requests
  fscrypt: Remove gfp_t argument from fscrypt_crypt_data_unit()
  fscrypt: Remove gfp_t argument from fscrypt_encrypt_block_inplace()
  ceph: Remove gfp_t argument from ceph_fscrypt_encrypt_*()

 fs/ceph/crypto.c            | 13 +++-----
 fs/ceph/crypto.h            | 10 +++---
 fs/ceph/file.c              |  3 +-
 fs/ceph/inode.c             |  3 +-
 fs/crypto/bio.c             |  3 +-
 fs/crypto/crypto.c          | 44 +++++++++-----------------
 fs/crypto/fname.c           | 63 +++++++++++++------------------------
 fs/crypto/fscrypt_private.h | 10 +++---
 fs/crypto/keysetup.c        | 23 +++++++-------
 fs/crypto/keysetup_v1.c     | 56 ++++++++++++++-------------------
 fs/ubifs/crypto.c           |  2 +-
 include/linux/fscrypt.h     |  5 ++-
 12 files changed, 91 insertions(+), 144 deletions(-)


base-commit: b41c1d8d07906786c60893980d52688f31d114a6
-- 
2.50.1


