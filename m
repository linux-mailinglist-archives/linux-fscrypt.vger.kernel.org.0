Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB2D360BFD8
	for <lists+linux-fscrypt@lfdr.de>; Tue, 25 Oct 2022 02:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230134AbiJYAme (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 24 Oct 2022 20:42:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230206AbiJYAmP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 24 Oct 2022 20:42:15 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F0FC248C9E;
        Mon, 24 Oct 2022 16:13:50 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id DC6AC811C7;
        Mon, 24 Oct 2022 19:13:48 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1666653229; bh=hkm29219cjhG47udzMGOngSYw5XLKm31YZTeT6o+iws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=keY80div4MLHkzpm7T/NPOsWUESahtdaw8pxAemQAgPOjP+BA8tlsCkX9SYFf4gAH
         rrswzrRGMVfY6hOawb0Af6J0DBHtBi0RhX9JsJyjYueYNt7Tm2cNESghYHXaDsFm+j
         +5G63iIoFZjx7Pgm+E44sUCVtj5jh2LGgeJEz2VjFcr97MKqAwrFrafy4HBPaB/lnt
         YXOdYzRQAGQDuShmWsLOf8fniQCIFvRCqlnGmC3yghkbGhKg+ul6Ee4Bnlr51XHlmA
         H1lQWjZ37JTAFo9qntt3ke6Y/jzmvGeFy2FFUNpWeaLQGnodriSZpd08C3Qv9jVaJ5
         48cnCwv9xmomA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v4 06/21] fscrypt: document btrfs' fscrypt quirks.
Date:   Mon, 24 Oct 2022 19:13:16 -0400
Message-Id: <686fce255e979bd8805e194c7288b80f2ceddbe0.1666651724.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1666651724.git.sweettea-kernel@dorminy.me>
References: <cover.1666651724.git.sweettea-kernel@dorminy.me>
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

As btrfs has a couple of quirks in its encryption compared to other
filesystems, they should be documented like ext4's quirks. Additionally,
extent-based contents encryption, being wholly new, deserves its own
section to compare against inode-based contents encryption.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Reviewed-by: Josef Bacik <josef@toxicpanda.com>
---
 Documentation/filesystems/fscrypt.rst | 31 +++++++++++++++++++++------
 1 file changed, 25 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 5ba5817c17c2..2ced42afd58b 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -31,7 +31,7 @@ However, except for filenames, fscrypt does not encrypt filesystem
 metadata.
 
 Unlike eCryptfs, which is a stacked filesystem, fscrypt is integrated
-directly into supported filesystems --- currently ext4, F2FS, and
+directly into supported filesystems --- currently btrfs, ext4, F2FS, and
 UBIFS.  This allows encrypted files to be read and written without
 caching both the decrypted and encrypted pages in the pagecache,
 thereby nearly halving the memory used and bringing it in line with
@@ -280,6 +280,11 @@ included in the IV.  Moreover:
   key derived using the KDF.  Users may use the same master key for
   other v2 encryption policies.
 
+For filesystems with extent-based content encryption (e.g. btrfs),
+this is the only choice. Data shared among multiple inodes must share
+the exact same key, therefore necessitating inodes using the same key
+for contents encryption.
+
 IV_INO_LBLK_64 policies
 -----------------------
 
@@ -374,12 +379,12 @@ to individual filesystems.  However, authenticated encryption (AE)
 modes are not currently supported because of the difficulty of dealing
 with ciphertext expansion.
 
-Contents encryption
--------------------
+Inode-based contents encryption
+------------------------------
 
-For file contents, each filesystem block is encrypted independently.
-Starting from Linux kernel 5.5, encryption of filesystems with block
-size less than system's page size is supported.
+For most filesystems, each filesystem block within each file is
+encrypted independently.  Starting from Linux kernel 5.5, encryption of
+filesystems with block size less than system's page size is supported.
 
 Each block's IV is set to the logical block number within the file as
 a little endian number, except that:
@@ -403,6 +408,20 @@ Note that because file logical block numbers are included in the IVs,
 filesystems must enforce that blocks are never shifted around within
 encrypted files, e.g. via "collapse range" or "insert range".
 
+Extent-based contents encryption
+--------------------------------
+
+For certain filesystems (currently only btrfs), data is encrypted on a
+per-extent basis. Each filesystem block in a data extent is encrypted
+independently. Multiple files may refer to the extent, as long as they
+all share the same key.  The filesystem may relocate the extent on disk,
+as long as the encrypted data within the extent retains its offset
+within the data extent.
+
+Each extent stores a nonce; each block within the extent has an IV
+based on this nonce and the logical block number within the extent as a
+little endian number.
+
 Filenames encryption
 --------------------
 
-- 
2.35.1

