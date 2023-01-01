Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBAF865A8FD
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 Jan 2023 06:13:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbjAAFNw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 Jan 2023 00:13:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229589AbjAAFNr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 Jan 2023 00:13:47 -0500
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E95A46400
        for <linux-fscrypt@vger.kernel.org>; Sat, 31 Dec 2022 21:13:46 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id A69EF8266A;
        Sun,  1 Jan 2023 00:07:01 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672549622; bh=KL0C188g9dt8V5OCaIsMkxn7efCcK8iX1m7ko9JcsjU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xN6Q6qC0IxAg1SYgRWq4KG77gilR4NS+5D70ViSupI1m43/tWvUNJR7ctAdhi+RFE
         89Hlx3I1ez6KQyVefMyXYpsWLrSUxwxWDHGuerLP/iQSoU6QXpsKDI3jQsTa+PbzSS
         xHxgAZt6bajWcrOQYrt0Uava2NgJM6cU3vw8rLGhnGIXzix/33KxyAu3TtORW/Cor4
         0SetUHBs2Y0RZVzbO5vjm8+jptTf144Zlx3aD/uAQ3VUKlZdutqeeQ799Tr5oTuNlU
         RWBupxRG8ei7OCPC1HCq5FCbsSu+65Q4aHXMWh1Ax1Q48fvklHxVM701K/E3ZN40xZ
         zndxWV3D1BvZA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        paulcrowley@google.com, linux-btrfs@vger.kernel.org,
        kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 17/17] fscrypt: update documentation to mention per-extent keys.
Date:   Sun,  1 Jan 2023 00:06:21 -0500
Message-Id: <5cb75138545bc865a42fb389519ad2adc9d2b678.1672547582.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1672547582.git.sweettea-kernel@dorminy.me>
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 Documentation/filesystems/fscrypt.rst | 38 ++++++++++++++++++++++-----
 1 file changed, 32 insertions(+), 6 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 5ba5817c17c2..0ff8abf89422 100644
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
 
@@ -374,12 +379,13 @@ to individual filesystems.  However, authenticated encryption (AE)
 modes are not currently supported because of the difficulty of dealing
 with ciphertext expansion.
 
-Contents encryption
--------------------
+Inode-based contents encryption
+-------------------------------
 
-For file contents, each filesystem block is encrypted independently.
-Starting from Linux kernel 5.5, encryption of filesystems with block
-size less than system's page size is supported.
+Most filesystems use the previously discussed per-file keys. For these
+filesystems, for file contents, each filesystem block is encrypted
+independently.  Starting from Linux kernel 5.5, encryption of filesystems
+with block size less than system's page size is supported.
 
 Each block's IV is set to the logical block number within the file as
 a little endian number, except that:
@@ -403,6 +409,26 @@ Note that because file logical block numbers are included in the IVs,
 filesystems must enforce that blocks are never shifted around within
 encrypted files, e.g. via "collapse range" or "insert range".
 
+Extent-based contents encryption
+--------------------------------
+
+For certain filesystems (currently only btrfs), data is encrypted on a
+per-extent basis, for whatever the filesystem's notion of an extent is. The
+scheme is exactly as with inode-based contents encryption, except that the
+'inode number' for an extent is requested from the filesystem instead of from
+the file's inode, and the 'logical block number' refers to an offset within the
+extent.
+
+Because the encryption material is per-extent instead of per-inode, as long 
+as the extent's encryption context does not change, the filesystem may shift
+around the position of the extent, and may have multiple files referring to
+the same encrypted extent.
+
+Not all extents within a file are decrypted simultaneously, so it is possible
+for a file read to fail partway through the file if it crosses into an extent
+whose key is unavailable.  However, all writes will succeed, unless the key is
+removed mid-write.
+
 Filenames encryption
 --------------------
 
-- 
2.38.1

