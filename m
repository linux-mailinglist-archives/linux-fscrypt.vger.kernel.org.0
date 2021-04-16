Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EA969362528
	for <lists+linux-fscrypt@lfdr.de>; Fri, 16 Apr 2021 18:07:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239729AbhDPQHV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 16 Apr 2021 12:07:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:37438 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239183AbhDPQHU (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 16 Apr 2021 12:07:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 24F9C6113D;
        Fri, 16 Apr 2021 16:06:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618589215;
        bh=rTkLI/G7keGXQVgDyrI7UE8GeDTwoxdlSggyy76+H4g=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Y6gVbgDxaz/ZztWn7rWw5DW6/Swqkno/dGBQ0fhO3aHMiuaY/kd/YOVkyCU4suAio
         fm6sZKg1DezRKaqo0OSX/WYpxo4nvopfoUd5t9BMaL34lQBU3EJy1bXzwRWPUJPnef
         0xZ351NAknAzONLoPA/txYI2w2KytoQZ5W5WzMdHi+aph0HIuQZhAhpVdA0Y5JRos5
         7LKTuoufSK7STg44rpcrOViMO67VolqQLpXli9poWOgm5FFrWeGlCV0PF+TqcsDfIT
         Uak50ip4IVV1EorGmBMESs02rndc2AnTQfIXAxWcgWPXIuRXSBe4W/Tu7wffRi2zUK
         Iihedt1/QqAEg==
From:   Ard Biesheuvel <ardb@kernel.org>
To:     linux-crypto@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Ard Biesheuvel <ardb@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>
Subject: [PATCH 2/2] fsverity: relax build time dependency on CRYPTO_SHA256
Date:   Fri, 16 Apr 2021 18:06:42 +0200
Message-Id: <20210416160642.85387-3-ardb@kernel.org>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20210416160642.85387-1-ardb@kernel.org>
References: <20210416160642.85387-1-ardb@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

CONFIG_CRYPTO_SHA256 denotes the generic C implementation of the SHA-256
shash algorithm, which is selected as the default crypto shash provider
for fsverity. However, fsverity has no strict link time dependency, and
the same shash could be exposed by an optimized implementation, and arm64
has a number of those (scalar, NEON-based and one based on special crypto
instructions). In such cases, it makes little sense to require that the
generic C implementation is incorporated as well, given that it will never
be called.

To address this, relax the 'select' clause to 'imply' so that the generic
driver can be omitted from the build if desired.

Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
---
 fs/verity/Kconfig | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/fs/verity/Kconfig b/fs/verity/Kconfig
index 88fb25119899..24d1b54de807 100644
--- a/fs/verity/Kconfig
+++ b/fs/verity/Kconfig
@@ -3,9 +3,13 @@
 config FS_VERITY
 	bool "FS Verity (read-only file-based authenticity protection)"
 	select CRYPTO
-	# SHA-256 is selected as it's intended to be the default hash algorithm.
+	# SHA-256 is implied as it's intended to be the default hash algorithm.
 	# To avoid bloat, other wanted algorithms must be selected explicitly.
-	select CRYPTO_SHA256
+	# Note that CRYPTO_SHA256 denotes the generic C implementation, but
+	# some architectures provided optimized implementations of the same
+	# algorithm that may be used instead. In this case, CRYPTO_SHA256 may
+	# be omitted even if SHA-256 is being used.
+	imply CRYPTO_SHA256
 	help
 	  This option enables fs-verity.  fs-verity is the dm-verity
 	  mechanism implemented at the file level.  On supported
-- 
2.30.2

