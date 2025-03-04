Return-Path: <linux-fscrypt+bounces-624-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 93086A4EEFC
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Mar 2025 22:02:06 +0100 (CET)
Received: from smtp.subspace.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id BDAFB171F4C
	for <lists+linux-fscrypt@lfdr.de>; Tue,  4 Mar 2025 21:02:05 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B29C413B58B;
	Tue,  4 Mar 2025 21:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DEWEOD2x"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CE9D33062
	for <linux-fscrypt@vger.kernel.org>; Tue,  4 Mar 2025 21:02:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741122123; cv=none; b=Ufux/H69rjgPSmlm8cdMCepPy7knMQj49sr3+etHMp/eH8n1hctlo/aoGbVxl96z9M/BxId68q1Bv/+Vu2okuklzTFXTUR8MMf/QqByOufcrI59JO9jKzDLwPchodytSKnRUyR3SOih6vvy4E5oYAZlje3YhGYD3yhkzjljGbuo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741122123; c=relaxed/simple;
	bh=dEbGPZWfuVC1CBRiNRqzsUA2M7D91sjHWxknLEm7c9Q=;
	h=From:To:Subject:Date:Message-ID:MIME-Version; b=KZ0h43tS0mIrfFve1nnRNLrdwn4YeqDfcdgIDbvcNRtIoIqDFAznty9EOEaZBmuyEKrtTPSTP1LrypW1/RhDm70w/A32QME4gxERFQpZXwmwHtZNkWPoXSs1DatUQmB0XVBow/GCAjadRfI1vG3jJowmEns1R0iQTEKmYElEo20=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DEWEOD2x; arc=none smtp.client-ip=10.30.226.201
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E205BC4CEE5
	for <linux-fscrypt@vger.kernel.org>; Tue,  4 Mar 2025 21:02:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1741122123;
	bh=dEbGPZWfuVC1CBRiNRqzsUA2M7D91sjHWxknLEm7c9Q=;
	h=From:To:Subject:Date:From;
	b=DEWEOD2xQUlxboUk9QNYVbvkYkApAJZH5EsXu9VtmOizuzUjqHE5Lc2yMdRKEPLI7
	 YtoDt2t39dKykfjfzkMAVRacHXN4zNbIZUVAtpSPrwAQGm7ErCx7mDZLVcP0O0iehk
	 EC5WAaAQ5qOafFAXYIjWeZbtP84QlFDj7uFSAyvJXx7es8HlpRdv7roNNQpkNta58h
	 Jvp+Gn9m0H2/+9E/KVeaXctbhEBtNYzaEhjbt+n1dpUEZ3vbFNcXQkGd1KLVISQQrO
	 ndPvyb6EEMFha4GVVT0MaIORw35fOmYU/tuuNeXuEubMOAYu6RM8xPvpIX6sB0cmhb
	 ttuGdi6KX6TTw==
From: Eric Biggers <ebiggers@kernel.org>
To: linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: mention init_on_free instead of page poisoning
Date: Tue,  4 Mar 2025 13:01:56 -0800
Message-ID: <20250304210156.14912-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.48.1
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

From: Eric Biggers <ebiggers@google.com>

Page poisoning is an older debug option.  The modern way to initialize
memory on free for security reasons is to set init_on_free=1.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 Documentation/filesystems/fscrypt.rst | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 004f7fa48a469..e803299085492 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -135,13 +135,12 @@ However, these ioctls have some limitations:
   containing keys to prevent it from being swapped out.
 
 - In general, decrypted contents and filenames in the kernel VFS
   caches are freed but not wiped.  Therefore, portions thereof may be
   recoverable from freed memory, even after the corresponding key(s)
-  were wiped.  To partially solve this, you can set
-  CONFIG_PAGE_POISONING=y in your kernel config and add page_poison=1
-  to your kernel command line.  However, this has a performance cost.
+  were wiped.  To partially solve this, you can add init_on_free=1 to
+  your kernel command line.  However, this has a performance cost.
 
 - Secret keys might still exist in CPU registers, in crypto
   accelerator hardware (if used by the crypto API to implement any of
   the algorithms), or in other places not explicitly considered here.
 

base-commit: eea957d8db1d1764c9c4b3c7fc5c86dbccb71fdc
-- 
2.48.1


