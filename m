Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2367C5ADC76
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 Sep 2022 02:36:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232283AbiIFAfr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 5 Sep 2022 20:35:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229575AbiIFAfp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 5 Sep 2022 20:35:45 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1A5C269F73;
        Mon,  5 Sep 2022 17:35:43 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 39A37810F2;
        Mon,  5 Sep 2022 20:35:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1662424543; bh=J9xEJcGuisIywcmBd5rr30DtjcJrVtrqQjsjYA+j1YU=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Esp7J6Tgm0RMzFOQAgPzd5SO0FTrT5N5GZMJzx2uygPAw5py4uCVwWYcJksOinWJi
         5TFkw/Ecr/DKfZBgZFExlUwyi3H8Jxs7KkgdItb8tMwzYvr+xKDHVlizrg72HIX+5k
         9yvK7eHVtQoOcsg0Xsnk8IiGr16xpnV6QnwC9ObO2axVZv/W4tCm8+6r+E4CLnXUN+
         9KYHBnTpl+0zeNLbdFkg6v/KRfdrTCOh8FSgBfExi9DYD3nerssnXoEWcP72OlNs9d
         bA57vxSb2Nq/5rY1B3f4X1jo02tUtV3HBrzkl/qikTRbL990D5vYjLG9yo5yYrzqea
         FGNzh+i9MYgWQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 02/20] fscrypt: add flag allowing partially-encrypted directories
Date:   Mon,  5 Sep 2022 20:35:17 -0400
Message-Id: <5e762e300535cbb9f04b25a97e1d13fd082f5b0e.1662420176.git.sweettea-kernel@dorminy.me>
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

Creating several new subvolumes out of snapshots of another subvolume,
each for a different VM's storage, is a important usecase for btrfs.  We
would like to give each VM a unique encryption key to use for new writes
to its subvolume, so that secure deletion of the VM's data is as simple
as securely deleting the key; to avoid needing multiple keys in each VM,
we envision the initial subvolume being unencrypted. However, this means
that the snapshot's directories would have a mix of encrypted and
unencrypted files. During lookup with a key, both unencrypted and
encrypted forms of the desired name must be queried.

To allow this, add another FS_CFLG to allow filesystems to opt into
partially encrypted directories.

Signed-off-by: Omar Sandoval <osandov@osandov.com>
Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/crypto/fname.c       | 17 ++++++++++++++++-
 include/linux/fscrypt.h |  2 ++
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 6c092a1533f7..3bdece33e14d 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -414,6 +414,7 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
 	fname->usr_fname = iname;
 
 	if (!IS_ENCRYPTED(dir) || fscrypt_is_dot_dotdot(iname)) {
+unencrypted:
 		fname->disk_name.name = (unsigned char *)iname->name;
 		fname->disk_name.len = iname->len;
 		return 0;
@@ -448,8 +449,16 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
 	 * user-supplied name
 	 */
 
-	if (iname->len > FSCRYPT_NOKEY_NAME_MAX_ENCODED)
+	if (iname->len > FSCRYPT_NOKEY_NAME_MAX_ENCODED) {
+		/*
+		 * This isn't a valid nokey name, but it could be an unencrypted
+		 * name if the filesystem allows partially encrypted
+		 * directories.
+		 */
+		if (dir->i_sb->s_cop->flags & FS_CFLG_ALLOW_PARTIAL)
+			goto unencrypted;
 		return -ENOENT;
+	}
 
 	fname->crypto_buf.name = kmalloc(FSCRYPT_NOKEY_NAME_MAX, GFP_KERNEL);
 	if (fname->crypto_buf.name == NULL)
@@ -460,6 +469,12 @@ int fscrypt_setup_filename(struct inode *dir, const struct qstr *iname,
 	if (ret < (int)offsetof(struct fscrypt_nokey_name, bytes[1]) ||
 	    (ret > offsetof(struct fscrypt_nokey_name, sha256) &&
 	     ret != FSCRYPT_NOKEY_NAME_MAX)) {
+		/* Again, this could be an unencrypted name. */
+		if (dir->i_sb->s_cop->flags & FS_CFLG_ALLOW_PARTIAL) {
+			kfree(fname->crypto_buf.name);
+			fname->crypto_buf.name = NULL;
+			goto unencrypted;
+		}
 		ret = -ENOENT;
 		goto errout;
 	}
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index a236d8c6d0da..a4e00314c91b 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -102,6 +102,8 @@ struct fscrypt_nokey_name {
  * pages for writes and therefore won't need the fscrypt bounce page pool.
  */
 #define FS_CFLG_OWN_PAGES (1U << 1)
+/* The filesystem allows partially encrypted directories/files. */
+#define FS_CFLG_ALLOW_PARTIAL (1U << 2)
 
 /* Crypto operations for filesystems */
 struct fscrypt_operations {
-- 
2.35.1

