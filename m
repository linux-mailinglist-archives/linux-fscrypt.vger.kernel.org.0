Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840B1274E2C
	for <lists+linux-fscrypt@lfdr.de>; Wed, 23 Sep 2020 03:09:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726825AbgIWBJ1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 22 Sep 2020 21:09:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726811AbgIWBJY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 22 Sep 2020 21:09:24 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4C1C0613D3
        for <linux-fscrypt@vger.kernel.org>; Tue, 22 Sep 2020 18:09:24 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id y10so6123167pll.6
        for <linux-fscrypt@vger.kernel.org>; Tue, 22 Sep 2020 18:09:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=sender:date:in-reply-to:message-id:mime-version:references:subject
         :from:to:cc;
        bh=Iygja5AJutfHm4YvnlwM0dTYeIXTivBw9HNzBAy37AM=;
        b=uuOUEWPHZPuw+wZv2NxYlk5b4qARvVhk9l5VutTgoWWyZcZuyFizEpd19JZZxiAyOb
         N8d29un2MtSSLuDqVDdx9nztGjWduT3vGmFgDh4JHNW7EtDxLNSGgrYx1Rc7lzW4b3I8
         sSdyPuacc0AOb0wygCNqd6lnNi9/DX4DMjG3C2FBiP1Pu9EdYhx1oFuiAV6dTxk7Siks
         /ElKvk36qbnET7SIYDn4ZKBN7NYUpL1HndaHubTYMsiBJU2Z2BhnhFlzXILr7DkR/VMK
         WQG+cZoJpfNOQxgiYQTj/NE4KPzx1aIFC1HCVvXnLQbft4QsCMTIFurk39tiFbW3k595
         L4Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=Iygja5AJutfHm4YvnlwM0dTYeIXTivBw9HNzBAy37AM=;
        b=g7WegCWckc//jRN0wYOcvcQsVE+fcQxNP5DdTTISudmnBlwFmux4denp/d6u7YVb8I
         7uaL46bkHJkyUnBzxu7QCxJoHl3APBYTYiw6KNP8Fz3Pi/sr9HdCg3jU78lWhlCaM/AG
         J24yzbrD6Hq90+98kn62HoBsZXz48RoBAPs9doIjQPXMq/7YeWJLkHs5Nt9Nogt+H7S9
         xkLBRyvzuecTihbnSIpxmhjqTUAogNU2TaXmzLAH4aI2UCfwnoO0DsbDDaq2T9fZKxVR
         GWSsasOLaphNgfh4sy+xtl7nvA9zkHJUy/h67BOkT5OFZsVAb5GgOiCCCrKBXQQGG+C6
         ljmQ==
X-Gm-Message-State: AOAM530OrUR+O0+3auG0CSA1g0TijBDs0A3trizclKupwlYnp4/2MT5a
        lOBD/4IVtjb6BqOOzUK9bfGiYOV8nxk=
X-Google-Smtp-Source: ABdhPJweQ2fLHpSG59qNGPeo45kVpwuKLLDae76QKJ3/73ksJ2F3VdQo0rXG32bWWdxvVzGJGgieliFiQ6Y=
Sender: "drosen via sendgmr" <drosen@drosen.c.googlers.com>
X-Received: from drosen.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:4e6f])
 (user=drosen job=sendgmr) by 2002:a63:c34b:: with SMTP id e11mr5777378pgd.25.1600823363879;
 Tue, 22 Sep 2020 18:09:23 -0700 (PDT)
Date:   Wed, 23 Sep 2020 01:01:48 +0000
In-Reply-To: <20200923010151.69506-1-drosen@google.com>
Message-Id: <20200923010151.69506-3-drosen@google.com>
Mime-Version: 1.0
References: <20200923010151.69506-1-drosen@google.com>
X-Mailer: git-send-email 2.28.0.681.g6f77f65b4e-goog
Subject: [PATCH 2/5] fscrypt: Export fscrypt_d_revalidate
From:   Daniel Rosenberg <drosen@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Chao Yu <chao@kernel.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Richard Weinberger <richard@nod.at>,
        linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-mtd@lists.infradead.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, Daniel Rosenberg <drosen@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This is in preparation for shifting the responsibility of setting the
dentry_operations to the filesystem, allowing it to maintain its own
operations.

Signed-off-by: Daniel Rosenberg <drosen@google.com>
---
 fs/crypto/fname.c       | 3 ++-
 include/linux/fscrypt.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/fs/crypto/fname.c b/fs/crypto/fname.c
index 011830f84d8d..d45db23ff6c4 100644
--- a/fs/crypto/fname.c
+++ b/fs/crypto/fname.c
@@ -541,7 +541,7 @@ EXPORT_SYMBOL_GPL(fscrypt_fname_siphash);
  * Validate dentries in encrypted directories to make sure we aren't potentially
  * caching stale dentries after a key has been added.
  */
-static int fscrypt_d_revalidate(struct dentry *dentry, unsigned int flags)
+int fscrypt_d_revalidate(struct dentry *dentry, unsigned int flags)
 {
 	struct dentry *dir;
 	int err;
@@ -580,6 +580,7 @@ static int fscrypt_d_revalidate(struct dentry *dentry, unsigned int flags)
 
 	return valid;
 }
+EXPORT_SYMBOL_GPL(fscrypt_d_revalidate);
 
 const struct dentry_operations fscrypt_d_ops = {
 	.d_revalidate = fscrypt_d_revalidate,
diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
index 991ff8575d0e..265b1e9119dc 100644
--- a/include/linux/fscrypt.h
+++ b/include/linux/fscrypt.h
@@ -207,6 +207,7 @@ int fscrypt_fname_disk_to_usr(const struct inode *inode,
 bool fscrypt_match_name(const struct fscrypt_name *fname,
 			const u8 *de_name, u32 de_name_len);
 u64 fscrypt_fname_siphash(const struct inode *dir, const struct qstr *name);
+extern int fscrypt_d_revalidate(struct dentry *dentry, unsigned int flags);
 
 /* bio.c */
 void fscrypt_decrypt_bio(struct bio *bio);
-- 
2.28.0.681.g6f77f65b4e-goog

