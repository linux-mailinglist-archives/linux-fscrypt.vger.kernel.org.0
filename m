Return-Path: <linux-fscrypt+bounces-689-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 263FEAFD634
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Jul 2025 20:14:18 +0200 (CEST)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id E4B927A6827
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Jul 2025 18:12:51 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E395122FDE8;
	Tue,  8 Jul 2025 18:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VgM1+I3e"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4F9B21CC47;
	Tue,  8 Jul 2025 18:14:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751998450; cv=none; b=aUsKEXQNOPVL+yGkx3BQjhgFG72kTezji5aFYi3iZtAPLJzsb6S56w3JlkkkUeOrbMmgKYZ9/mdOPmS6ruBkPl8NYSMeRyQHG38r9k/zoCZmraKt+AzC/PZRpzULE3V14cFjmk4vhVnJVA8GCJfxy2QjNiaaQR95JeIbs+hBuo8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751998450; c=relaxed/simple;
	bh=jvHDiPD2nNW76WlUGqlnLD7ew9f5nj0TUxpArZtudsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=VqMmUj7/QvMM0VJHQyC6RDw0k6mezXLvuDGhj5P7GG2BcLYQABppNCX8zeoAjVaOVrmVROLoUVH6Cy+jSdxOgR2qNVI6bmHZ35VevqGZG8cJo7Xv5SEKOuBPqPJ8wyoqvvaZEe/vS2D+HqAo7mSEVDP+E/Rtx2k6v3A2hJKODxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VgM1+I3e; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 08647C4CEED;
	Tue,  8 Jul 2025 18:14:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751998450;
	bh=jvHDiPD2nNW76WlUGqlnLD7ew9f5nj0TUxpArZtudsQ=;
	h=From:To:Cc:Subject:Date:From;
	b=VgM1+I3eFBT0IBmUc5BOTBIhYyThXXiDllR1bJ7Xw1HGKrBabn/RHajszDkib+se+
	 vmWKMKBQY7SDRPnUpAokBe1FgaiLREIcI3gIP7yOF4H/RDVVxpbyo6TTb86L5N8OYa
	 9DAYvafwcmDFNRVBDF7kktwEwt7uDc/iPEovdwl4h1hrQyyFGJnPckBwkmZoIrb0lV
	 ql6tB9KiBYFMNu0IOmXIRtXiBPKWLBIvkmB6PJ6XqXbhDBuKbv644akVvHhlwihg4n
	 8QJV1jhttR5eNDLIq/Q1fhdKlOLV6JPUANOrUwuzwAvjD8q+otC2l+Zrn29O2vhUh6
	 PF1dDZbJZVHrg==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Cc: Yuwen Chen <ywen.chen@foxmail.com>,
	linux-crypto@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 0/3] fscrypt: Switch to sync_skcipher and on-stack requests
Date: Tue,  8 Jul 2025 11:13:10 -0700
Message-ID: <20250708181313.66961-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.50.0
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

Eric Biggers (3):
  fscrypt: Don't use asynchronous CryptoAPI algorithms
  fscrypt: Drop FORBID_WEAK_KEYS flag for AES-ECB
  fscrypt: Switch to sync_skcipher and on-stack requests

 fs/crypto/crypto.c          | 27 ++++++----------
 fs/crypto/fname.c           | 63 +++++++++++++------------------------
 fs/crypto/fscrypt_private.h |  7 +++--
 fs/crypto/keysetup.c        | 23 +++++++-------
 fs/crypto/keysetup_v1.c     | 56 +++++++++++++++------------------
 5 files changed, 71 insertions(+), 105 deletions(-)


base-commit: b41c1d8d07906786c60893980d52688f31d114a6
-- 
2.50.0


