Return-Path: <linux-fscrypt+bounces-623-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A96A9A4EEDD
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Mar 2025 21:55:11 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 659963A9D8C
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Mar 2025 20:54:57 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A3E3825290A;
	Tue,  4 Mar 2025 20:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="U8GGWdV9"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8049E1C84D7
	for <linux-fscrypt@vger.kernel.org>; Tue,  4 Mar 2025 20:55:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741121705; cv=none; b=fm1+Tv7cpvTh+2kSiAXQ4TugYHF/UdMbQ0stPU+AGSslerzfDQdT6owAV1a2e9qsxmg2aY9xi9xxrye6cBRBw9/tFQGmekr84RuexcbNNCvImLMio9HfxdsrnDzUPFTnUhWXduHJjiLEl1AMCK9jvCOze3l7otCOYNp1NeTbN8g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741121705; c=relaxed/simple;
	bh=85ln5zEEYKhAD5lP/savkHjbaYwvlLgi0ixsL/79GZ8=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=F6mBBvIOZOMoPhlIMV+giz9JrcRjt2WgwxvGU7sqprWRFxgUeEz8A/6DzzgesgiAx5ldI9EXFFoXW8A0nOx+yP+5DiJ27BYuZ7D5pmIHKU6HUjKS6MpGOGRTvKDyAcURQkwGz+Gd8l9ft/p2uMlllbb7b/lUYG8CU71x5ZhqYT0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=U8GGWdV9; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 53E29C4CEE5
	for <linux-fscrypt@vger.kernel.org>; Tue,  4 Mar 2025 20:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741121705;
	bh=85ln5zEEYKhAD5lP/savkHjbaYwvlLgi0ixsL/79GZ8=;
	h=From:To:Subject:Date:From;
	b=U8GGWdV9k06l/C/i5gHTp5reBe5OejjaCCoBlrnjphQYI47g3OMwPviY986mZgLH9
	 EUMCI2SxemyAUETMQ+Bu0lsSx7Pd9l1iOxcy7zdm4XEckTukPfKxc6Y4g8hnzXWlbg
	 0tcFbZ7uixbYo9qcLQnpCRIsQZ7FP5e8TGIijxz+n2gLoQgubmyhdogbStLQVzK3XW
	 saptqenkeQ7RVvUlXeV84IgBmfXcMCzS/9YqK4/r1qEzCVLy2DwDrsP5z/dseOalVV
	 7YiqN+VEdIOTZ3PV57d21DX8itpFaIOS5AjxJcjdYN+OdnbIHGtcFcBA2oTWkdPwru
	 oMmupxI21Bxtw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: drop obsolete recommendation to enable optimized ChaCha20
Date: Tue,  4 Mar 2025 12:55:01 -0800
Message-ID: <20250304205501.13797-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Since the crypto kconfig options are being fixed to enable optimized
ChaCha20 automatically
(https://lore.kernel.org/r/Z8AY16EIqAYpfmRI@gondor.apana.org.au/), it is
no longer necessary to give a recommendation to enable it.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fscrypt.rst | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 04eaab01314bc..004f7fa48a469 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -426,15 +426,12 @@ API, but the filenames mode still does.
 
 - Adiantum
     - Mandatory:
         - CONFIG_CRYPTO_ADIANTUM
     - Recommended:
-        - arm32: CONFIG_CRYPTO_CHACHA20_NEON
         - arm32: CONFIG_CRYPTO_NHPOLY1305_NEON
-        - arm64: CONFIG_CRYPTO_CHACHA20_NEON
         - arm64: CONFIG_CRYPTO_NHPOLY1305_NEON
-        - x86: CONFIG_CRYPTO_CHACHA20_X86_64
         - x86: CONFIG_CRYPTO_NHPOLY1305_SSE2
         - x86: CONFIG_CRYPTO_NHPOLY1305_AVX2
 
 - AES-128-CBC-ESSIV and AES-128-CBC-CTS:
     - Mandatory:

base-commit: 75eb8b9410ee5f75851cfda9a328dab891e452d8
-- 
2.48.1


