Return-Path: <linux-fscrypt+bounces-585-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A6D87A15BBC
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jan 2025 08:24:23 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id C087516858C
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jan 2025 07:24:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 49C41136658;
	Sat, 18 Jan 2025 07:24:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="S0W4nNkT"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1D050A32;
	Sat, 18 Jan 2025 07:24:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737185059; cv=none; b=WMOiEGvFitRqvMWrLCiuRPJsYyRJfYh1dQnfPaw2qImNTQWSYqDsp0U1iDKJI6oFkUh8Ms+U87KzbXkEqYJ/e9Gs37cwKSthBi/nmRU3GRgv+gKS1udPtsEdOthcmM/zT+9YFtOBsEq0+Q6pZcbb0JZne6fkblhLqa/WorxYae8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737185059; c=relaxed/simple;
	bh=1C8W/Q5ujXglYgPyJOK/n1BDEy6mDnLv36PS0bVeOSg=;
	h=From:To:Cc:Subject:Date:Message-ID:MIME-Version; b=ehBfb4/Q5lau4ZhDU/lcaevKwTyT68sFW0SOkoOwVsOX6NVjLuLv5QVLRAKzEfQMmbn/DXDr/eyt1m+IjSrhcDlECUtHhve+VrYy+flQApIUQ8DZm7kjKXQMOtGOyA48mLd84O/3IdKYM809WDocisc508VkcoYInUIcDC7QuSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=S0W4nNkT; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7050EC4CED1;
	Sat, 18 Jan 2025 07:24:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1737185058;
	bh=1C8W/Q5ujXglYgPyJOK/n1BDEy6mDnLv36PS0bVeOSg=;
	h=From:To:Cc:Subject:Date:From;
	b=S0W4nNkTKQunFBY+GiJ5mqX5wj1A6ggyFnrPy7sC2mWfpRc2GLImyqJ8DNnQ87UEu
	 R22/LphbGqh/psOfzGcVTyP3xZ3mFkPpg8OOlJc274PGaiLMgtVuk7/sYETCtKdq3I
	 hX1I3stVSADog7OBusHq84HrjfjNc71fc2DDRT6BJQ2q/FdrZ1W8ayBXw9i+Ik8zq3
	 lUo/IeQU5x+avxaR9Wy7nUOs5n+/wWHFUOXoZ/L6slY3kEvc8qvHrF+zrcBfWEJL4+
	 KNkrgodcQwBlmCQFGzVFiBUZvaeTCEgIYc6FpTqwoK5AS4hBzMSQQBxSLCcdXpUIki
	 FipN3a4FwHv7w==
From: Eric Biggers <ebiggers@kernel.org>
To: fstests@vger.kernel.org
Cc: linux-fscrypt@vger.kernel.org,
	Bartosz Golaszewski <brgl@bgdev.pl>,
	Gaurav Kashyap <quic_gaurkash@quicinc.com>
Subject: [xfstests PATCH] fscrypt-crypt-util: fix KDF contexts for SM8650
Date: Fri, 17 Jan 2025 23:23:36 -0800
Message-ID: <20250118072336.605023-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Update the KDF contexts to match those actually used on SM8650.  This
turns out to be needed for the hardware-wrapped key tests generic/368
and generic/369 to pass on the SM8650 HDK (now that I have one to
actually test it).  Apparently the contexts changed between the
prototype version I tested a couple years ago and the final version.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 src/fscrypt-crypt-util.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
index 4dde1d4a..f51b3669 100644
--- a/src/fscrypt-crypt-util.c
+++ b/src/fscrypt-crypt-util.c
@@ -2278,21 +2278,21 @@ static void hw_kdf(const u8 *master_key, size_t master_key_size,
 static void derive_inline_encryption_key(const u8 *master_key,
 					 size_t master_key_size,
 					 u8 inlinecrypt_key[INLINECRYPT_KEY_SIZE])
 {
 	static const u8 ctx[36] =
-		"inline encryption key\0\0\0\0\0\0\x03\x43\0\x82\x50\0\0\0\0";
+		"inline encryption key\0\0\0\0\0\0\x02\x43\0\x82\x50\0\0\0\0";
 
 	hw_kdf(master_key, master_key_size, ctx, sizeof(ctx),
 	       inlinecrypt_key, INLINECRYPT_KEY_SIZE);
 }
 
 static void derive_sw_secret(const u8 *master_key, size_t master_key_size,
 			     u8 sw_secret[SW_SECRET_SIZE])
 {
 	static const u8 ctx[28] =
-		"raw secret\0\0\0\0\0\0\0\0\0\x03\x17\0\x80\x50\0\0\0\0";
+		"raw secret\0\0\0\0\0\0\0\0\0\x02\x17\0\x80\x50\0\0\0\0";
 
 	hw_kdf(master_key, master_key_size, ctx, sizeof(ctx),
 	       sw_secret, SW_SECRET_SIZE);
 }
 

base-commit: dec8cfb46ba0f19d29d13412841f68ebf119a452
-- 
2.48.1


