Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DCD4D60669E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Oct 2022 19:00:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229986AbiJTRAS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 13:00:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229998AbiJTRAQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 13:00:16 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 058259AF80;
        Thu, 20 Oct 2022 10:00:10 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 27563811D7;
        Thu, 20 Oct 2022 12:59:39 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1666285179; bh=3LGhGx+DVMJdPU0aZqSOrMi0E7gESXwazg7yDLKnx58=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=xGL3EISPUMovbSyRBawkfTzaclVpdq1Ytc0J0nVkSQAbrQhpx/vglddAqqnRS2szs
         rF9mMV0/oJ0R28jJDY/iNe5rqaGSAvHjfakMy0iscnPE0+wlXyZA+hHlkjkJNbGKBK
         eUaLqDW3E0syGKpADgOepGtm/x+rgmJ6+viJqZjdD51j7rzuARC+esc30ZiMfa+1Vo
         xjsfVD31lR/3G/dmNsL7+y5Rg67xhKkLvw5a4lmThI5it+5oyaw6TKoLxxEXuvswln
         iArZg5+NAyXz8TJm0nACPLAulnH5CFpr8yHhKrenyR74uLlcUgmHoynS0LKE9r8HL/
         F4KKYcHQMLNmA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Omar Sandoval <osandov@osandov.com>,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 21/22] fscrypt: add flag allowing partially-encrypted directories
Date:   Thu, 20 Oct 2022 12:58:40 -0400
Message-Id: <2664d197270314e809421f58aaeb728df3a3daf4.1666281277.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1666281276.git.sweettea-kernel@dorminy.me>
References: <cover.1666281276.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
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
index b3e7e3a66312..16b64e0589e4 100644
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
index 4143c722ea1b..485471174594 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -109,6 +109,8 @@ struct fscrypt_nokey_name {
  * pages for writes and therefore won't need the fscrypt bounce page pool.
  */
 #define FS_CFLG_OWN_PAGES (1U << 1)
+/* The filesystem allows partially encrypted directories/files. */
+#define FS_CFLG_ALLOW_PARTIAL (1U << 2)
 
 /* Crypto operations for filesystems */
 struct fscrypt_operations {
-- 
2.35.1

