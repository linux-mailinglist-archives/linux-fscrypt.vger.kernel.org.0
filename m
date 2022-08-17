Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAF15971CB
	for <lists+linux-fscrypt@lfdr.de>; Wed, 17 Aug 2022 16:54:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240465AbiHQOu5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 17 Aug 2022 10:50:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240464AbiHQOu4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 17 Aug 2022 10:50:56 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D83C43E749;
        Wed, 17 Aug 2022 07:50:55 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 8A1198042B;
        Wed, 17 Aug 2022 10:50:54 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1660747854; bh=Wj5zQSc6tWfXdik16XxEGRmNwVcIzILAIatwxRAZUI8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=XBFSfzUBSoWiLXeZVmridWYJSdJnutH2sPux8OYMiY4afKe/dF1HlfHA+ueYbEgyP
         QC5jK7cWYi1llZLloozWRDy/WIFGFIDfVP3tZwzuukp/DZn7AmzoTS6w0NWBiFzPYF
         /RSqVTGPaXUDShqbbP042H9sA5fWOwo8+vQAraeTLkbDCznJd8hUhjyvJS/Llbvxxg
         bw7rYcoErk+2pu1kYAMj2Z26/Rp6JAmOQwFOkjbOHem2jdMlOfLnnaIG0JItvxISqD
         Fp3NyWpx3VQkmNMu/F24WATv/d/nIx5WN5/XPz7vp2XyOoo7sQ8YyAwbAv+WI4YyWD
         7+X2nDcAmcDBA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o " <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 18/21] btrfs: reuse encrypted filename hash when possible.
Date:   Wed, 17 Aug 2022 10:50:02 -0400
Message-Id: <00906e96b2da0184dfac91b34814d8aa6177da4f.1660744500.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1660744500.git.sweettea-kernel@dorminy.me>
References: <cover.1660744500.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
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
index be4a3458b4d6..12a9341bb13b 100644
--- a/fs/btrfs/ctree.h
+++ b/fs/btrfs/ctree.h
@@ -2861,7 +2861,10 @@ static inline void btrfs_crc32c_final(u32 crc, u8 *result)
 
 static inline u64 btrfs_name_hash(const struct fscrypt_name *name)
 {
-	return crc32c((u32)~1, fname_name(name), fname_len(name));
+	if (fname_name(name))
+		return crc32c((u32)~1, fname_name(name), fname_len(name));
+	else
+		return name->hash | ((u64)name->minor_hash << 32);
 }
 
 /*
@@ -2870,8 +2873,20 @@ static inline u64 btrfs_name_hash(const struct fscrypt_name *name)
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

