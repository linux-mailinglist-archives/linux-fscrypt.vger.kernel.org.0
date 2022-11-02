Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD5E461622C
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Nov 2022 12:54:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiKBLxR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Nov 2022 07:53:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229618AbiKBLxQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Nov 2022 07:53:16 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBEA228714;
        Wed,  2 Nov 2022 04:53:15 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 3DB5D81480;
        Wed,  2 Nov 2022 07:53:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1667389995; bh=OI2zMAYFyYpaswq4kOyLZ4AvuIXk2wStaybbpLyZrgg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=rVb+R3xy+Oj+UO8Ez3t+b/CEJIDMt7y9rUBBRK6rCOayTybvOrDNZUp+nxpq1HoHP
         iYp3er4FREXe+Pyaf1keP7krGaMxpdBCBMJfcXX6AWMEkqHcEI6HbDPgCXXmrpQZSb
         EDP6pxk62ctnrn0fzTdCWs+6gV94Ok2QzMEhXTurDe2LswtQA19skElKP3Y7bP9s4F
         zDCXIiBaI5W1JM4WwnmYGXF7n5Sq3qJ82X8trEY5V62DmXT3yeRzJYr5c2fjTkOdJe
         k7TZcxf+D3ZG4ZWLIvokm4gL28VSqD45a9Fw+2lUoEL5l1e34sCzKkiV6JgKc9tqmB
         YbInL1N+apgQg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v5 03/18] fscrypt: allow fscrypt_generate_iv() to distinguish filenames
Date:   Wed,  2 Nov 2022 07:52:52 -0400
Message-Id: <6140620518064e2ddbc362dba38e44f51651fc8c.1667389115.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1667389115.git.sweettea-kernel@dorminy.me>
References: <cover.1667389115.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

For extent-based file contents encryption, filenames will need to
generate an IV based on the inode context, while file contents will need
to generate an IV based on the extent context. Currently filenames and
the first block of file contents both pass fscrypt_generate_iv() a block
number of 0, making it hard to distinguish the two cases.

To enable distinguishing these two cases for extent-based encryption,
this change adjusts all callers to pass U64_MAX when requesting an IV
for filename encryption, and then changes fscrypt_generate_iv() to
convert U64_MAX to 0 for traditional inode-context encryption. For
extent-based encryption, any block number other than U64_MAX will get an
IV from the extent context, while U64_MAX will indicate falling back to
inode contexts.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/crypto.c | 9 ++++++++-
 fs/crypto/fname.c  | 4 ++--
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
index e78be66bbf01..7fe5979fbea2 100644
--- a/fs/crypto/crypto.c
+++ b/fs/crypto/crypto.c
@@ -71,7 +71,7 @@ EXPORT_SYMBOL(fscrypt_free_bounce_page);
 
 /*
  * Generate the IV for the given logical block number within the given file.
- * For filenames encryption, lblk_num == 0.
+ * For filenames encryption, lblk_num == U64_MAX.
  *
  * Keep this in sync with fscrypt_limit_io_blocks().  fscrypt_limit_io_blocks()
  * needs to know about any IV generation methods where the low bits of IV don't
@@ -84,6 +84,13 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
 
 	memset(iv, 0, ci->ci_mode->ivsize);
 
+	/*
+	 * Filename encryption. For inode-based policies, filenames are
+	 * encrypted as though they are lblk 0.
+	 */
+	if (lblk_num == U64_MAX)
+		lblk_num = 0;
+
 	if (flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64) {
 		WARN_ON_ONCE(lblk_num > U32_MAX);
 		WARN_ON_ONCE(ci->ci_inode->i_ino > U32_MAX);
diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 6c092a1533f7..b3e7e3a66312 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -79,7 +79,7 @@ int fscrypt_fname_encrypt(const struct inode *inode, const struct qstr *iname,
 	memset(out + iname->len, 0, olen - iname->len);
 
 	/* Initialize the IV */
-	fscrypt_generate_iv(&iv, 0, ci);
+	fscrypt_generate_iv(&iv, U64_MAX, ci);
 
 	/* Set up the encryption request */
 	req = skcipher_request_alloc(tfm, GFP_NOFS);
@@ -134,7 +134,7 @@ static int fname_decrypt(const struct inode *inode,
 		crypto_req_done, &wait);
 
 	/* Initialize IV */
-	fscrypt_generate_iv(&iv, 0, ci);
+	fscrypt_generate_iv(&iv, U64_MAX, ci);
 
 	/* Create decryption request */
 	sg_init_one(&src_sg, iname->name, iname->len);
-- 
2.37.3

