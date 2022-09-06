Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB1685ADC8D
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 Sep 2022 02:37:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236506AbiIFAgS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 5 Sep 2022 20:36:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40252 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232772AbiIFAgP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 5 Sep 2022 20:36:15 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DC9616A4A8;
        Mon,  5 Sep 2022 17:36:11 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 60AC781158;
        Mon,  5 Sep 2022 20:36:11 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1662424571; bh=qs/PbHgqpvuCxRL5lwfqdPPBlbi/vM+biDOAKHz7sn4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=DKzy3x6o+19lIA+lYi8qQtQWOXgfDwFIZp+PTVQcddHbhFXfDb9tjGVUFUYhG4ww7
         t7jDBHz8tEYBzRb+0yGI7IIvMoI8K+7x1nz13/RZGTGUNurqMn6spgtbYGPG041bLZ
         V8zeW78NVqRgzL7Iho7+zDrWhtiEidCnD7tT7aFoSilNP4RBWIcpkmRml0plSbUg0C
         aPj/OxYQqbSSDOCTnWVf/WxRPW6cdnx/whv+Sbv427Q0DLOeS68dCDV2yadkKxJBTV
         Y/Ncg+PYzmXacbiCKc3zZNV5Rt3Gwu66fAsIV4ZKbjbRqkSrqfY31oWHtr0MT4Hyxn
         qAxh/HzLaZh/Q==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 17/20] btrfs: reuse encrypted filename hash when possible.
Date:   Mon,  5 Sep 2022 20:35:32 -0400
Message-Id: <d0957b6aa0847fed100765d9268e4919265fabe9.1662420176.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1662420176.git.sweettea-kernel@dorminy.me>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Omar Sandoval <osandov@osandov.com>

For encrypted fscrypt_names, we can reuse fscrypt's precomputed hash of
the encrypted name to generate our own hash, instead of rehashing the
unencrypted name (which may not be possible if it's a nokey name).

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/ctree.h | 21 ++++++++++++++++++---
 1 file changed, 18 insertions(+), 3 deletions(-)

diff --git a/fs/btrfs/ctree.h b/fs/btrfs/ctree.h
index e8d000fcc85d..aa599518c057 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2842,7 +2842,10 @@ static inline void btrfs_crc32c_final(u32 crc, u8 *result)
 
 static inline u64 btrfs_name_hash(const struct fscrypt_name *name)
 {
-	return crc32c((u32)~1, fname_name(name), fname_len(name));
+	if (fname_name(name))
+		return crc32c((u32)~1, fname_name(name), fname_len(name));
+	else
+		return name->hash | ((u64)name->minor_hash << 32);
 }
 
 /*
@@ -2851,8 +2854,20 @@ static inline u64 btrfs_name_hash(const struct fscrypt_name *name)
 static inline u64 btrfs_extref_hash(u64 parent_objectid,
 				    const struct fscrypt_name *name)
 {
-	return (u64) crc32c(parent_objectid, fname_name(name),
-			    fname_len(name));
+	/*
+	 * If the name is encrypted and we don't have the key, we can use the
+	 * fscrypt-provided hash instead of the normal name, and do the steps
+	 * of crc32c() manually. Else, just hash the name, parent objectid,
+	 * and name length.
+	 */
+	if (fname_name(name))
+		return (u64) crc32c(parent_objectid, fname_name(name),
+				    fname_len(name));
+	else
+		return (__crc32c_le_combine(parent_objectid,
+					    name->hash,
+					    fname_len(name)) ^
+			__crc32c_le_shift(~1, fname_len(name)));
 }
 
 static inline gfp_t btrfs_alloc_write_mask(struct address_space *mapping)
-- 
2.35.1

