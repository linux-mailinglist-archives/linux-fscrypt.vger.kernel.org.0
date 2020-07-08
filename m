Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 516B82192F1
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Jul 2020 23:56:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725446AbgGHV4S (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Jul 2020 17:56:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:38686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726116AbgGHV4Q (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Jul 2020 17:56:16 -0400
Received: from sol.hsd1.ca.comcast.net (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 86A1220775
        for <linux-fscrypt@vger.kernel.org>; Wed,  8 Jul 2020 21:56:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1594245376;
        bh=p/CH4nsNT9ydV+9pFJipS4F+E2CrjTkanGrU5mFFnMQ=;
        h=From:To:Subject:Date:From;
        b=t/wkfh3qi7Ja+Q9IlzWnu65xM5dIZ4m4XuIXBanzoJp1iL96UP6EKAepTHzymEJOa
         tOppd9U1uAcaOVi7Q2XD/bxfQj8ltl/6NWQzR0BoDo8M5/fFolNIhKXM3HVruivcEh
         xDxd3BFYgRzMzvIaFSuBpoRgCxv1b1nQHs/RsXR4=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: [PATCH] fscrypt: add comments that describe the HKDF info strings
Date:   Wed,  8 Jul 2020 14:55:29 -0700
Message-Id: <20200708215529.146890-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Each HKDF context byte is associated with a specific format of the
remaining part of the application-specific info string.  Add comments so
that it's easier to keep track of what these all are.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 fs/crypto/fscrypt_private.h | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
index 5bb40d0109c8..0f154bdbc14b 100644
--- a/fs/crypto/fscrypt_private.h
+++ b/fs/crypto/fscrypt_private.h
@@ -312,13 +312,13 @@ int fscrypt_init_hkdf(struct fscrypt_hkdf *hkdf, const u8 *master_key,
  * outputs are unique and cryptographically isolated, i.e. knowledge of one
  * output doesn't reveal another.
  */
-#define HKDF_CONTEXT_KEY_IDENTIFIER	1
-#define HKDF_CONTEXT_PER_FILE_ENC_KEY	2
-#define HKDF_CONTEXT_DIRECT_KEY		3
-#define HKDF_CONTEXT_IV_INO_LBLK_64_KEY	4
-#define HKDF_CONTEXT_DIRHASH_KEY	5
-#define HKDF_CONTEXT_IV_INO_LBLK_32_KEY	6
-#define HKDF_CONTEXT_INODE_HASH_KEY	7
+#define HKDF_CONTEXT_KEY_IDENTIFIER	1 /* info=<empty>		*/
+#define HKDF_CONTEXT_PER_FILE_ENC_KEY	2 /* info=file_nonce		*/
+#define HKDF_CONTEXT_DIRECT_KEY		3 /* info=mode_num		*/
+#define HKDF_CONTEXT_IV_INO_LBLK_64_KEY	4 /* info=mode_num||fs_uuid	*/
+#define HKDF_CONTEXT_DIRHASH_KEY	5 /* info=file_nonce		*/
+#define HKDF_CONTEXT_IV_INO_LBLK_32_KEY	6 /* info=mode_num||fs_uuid	*/
+#define HKDF_CONTEXT_INODE_HASH_KEY	7 /* info=<empty>		*/
 
 int fscrypt_hkdf_expand(const struct fscrypt_hkdf *hkdf, u8 context,
 			const u8 *info, unsigned int infolen,
-- 
2.27.0

