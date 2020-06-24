Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F13DA206B3A
	for <lists+linux-fscrypt@lfdr.de>; Wed, 24 Jun 2020 06:34:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388550AbgFXEeG (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 24 Jun 2020 00:34:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388714AbgFXEeA (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 24 Jun 2020 00:34:00 -0400
Received: from mail-qk1-x74a.google.com (mail-qk1-x74a.google.com [IPv6:2607:f8b0:4864:20::74a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DAEC2C061755
        for <linux-fscrypt@vger.kernel.org>; Tue, 23 Jun 2020 21:33:58 -0700 (PDT)
Received: by mail-qk1-x74a.google.com with SMTP id i82so762529qke.10
        for <linux-fscrypt@vger.kernel.org>; Tue, 23 Jun 2020 21:33:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=wjYzq7dNm+b/15M65eILIbgPJ/utRyDEBt1j+IyIFNc=;
        b=tZlQ1+jyfoR+7clXo6vrzd7pzgmnVS1pNwJ0UpJnMv8xv9+lzT5abGBMINYUNEUfgy
         wdW429okaRdglWfYGu7Ufv0UtQ5ZeFFeGzVjbeo0Xr8kg504XwZmBSE6aggZ+/vpQUXr
         jf/RyvipjXVfAL3RKcKQ3/zZm23wd9GYDVLGifCgvkc9Nu3e3J5/r9Fbt9l4vnko05Lw
         3KLoYb78+1YFNX3aWw3/90HzD3sa+Per824hrr4K1hxgUMUJe5rxLQdxiTtq4A22HSw6
         tZDO7K5LI3nuAlIbk0UEgIYk7QPJ35tPLzqslI5XJF8EJLq4Utbmj6YYPnRXMwnzxzf2
         GSzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=wjYzq7dNm+b/15M65eILIbgPJ/utRyDEBt1j+IyIFNc=;
        b=KaYeDPkmahCTZ8aLqPDPkmgZM3jVL4OXjQ6xNWxc3OO8qZvP5jhY436m/BDsL58Gp/
         +TazSVVaKNO6jT7UUqyhA4vcwkbBtW25eyP2AuaYqpbhkDiEdaXMiwZiH/SLBfb6KImy
         WA14hmy7DWbqKDB7/HZGgbLDyaDdJVc3BCw/ccTnudGTn8nzWFL9UJPBz1jCmbU9lCps
         pZY85WyAnNgqynx0Do+NqVrfy7D83IGWGbTjVGugcJo9nWugWjcToXhkZWgwcCFV/xer
         6C75KfNXUBKgZA/6B0zqRx9IDaX+Qbt9VcvXLBQzZcWRtebyUMWSx/yemgV5mNsuKvcH
         xhzg==
X-Gm-Message-State: AOAM5339TExvSzHyqiztzALpHZChHOoJ1X6NBvdki7ojUlRrJBB/Nwml
        wg/9fWAv7R3Cu41sBwfZoxtOVEnKRtM=
X-Google-Smtp-Source: ABdhPJwQv3r1LvOO9FWS3NA1m0vFrLjIyQEAcgvFUZrYFA3esKkj7HG6enTwbe1RS/YIKDoAxkLiThK0vyo=
X-Received: by 2002:ad4:49aa:: with SMTP id u10mr30687919qvx.162.1592973237877;
 Tue, 23 Jun 2020 21:33:57 -0700 (PDT)
Date:   Tue, 23 Jun 2020 21:33:38 -0700
In-Reply-To: <20200624043341.33364-1-drosen@google.com>
Message-Id: <20200624043341.33364-2-drosen@google.com>
Mime-Version: 1.0
References: <20200624043341.33364-1-drosen@google.com>
X-Mailer: git-send-email 2.27.0.111.gc72c7da667-goog
Subject: [PATCH v9 1/4] unicode: Add utf8_casefold_hash
From:   Daniel Rosenberg <drosen@google.com>
To:     "Theodore Ts'o" <tytso@mit.edu>, linux-ext4@vger.kernel.org,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Richard Weinberger <richard@nod.at>
Cc:     linux-mtd@lists.infradead.org,
        Andreas Dilger <adilger.kernel@dilger.ca>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        kernel-team@android.com, Daniel Rosenberg <drosen@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This adds a case insensitive hash function to allow taking the hash
without needing to allocate a casefolded copy of the string.

Signed-off-by: Daniel Rosenberg <drosen@google.com>
---
 fs/unicode/utf8-core.c  | 23 ++++++++++++++++++++++-
 include/linux/unicode.h |  3 +++
 2 files changed, 25 insertions(+), 1 deletion(-)

diff --git a/fs/unicode/utf8-core.c b/fs/unicode/utf8-core.c
index 2a878b739115d..90656b9980720 100644
--- a/fs/unicode/utf8-core.c
+++ b/fs/unicode/utf8-core.c
@@ -6,6 +6,7 @@
 #include <linux/parser.h>
 #include <linux/errno.h>
 #include <linux/unicode.h>
+#include <linux/stringhash.h>
 
 #include "utf8n.h"
 
@@ -122,9 +123,29 @@ int utf8_casefold(const struct unicode_map *um, const struct qstr *str,
 	}
 	return -EINVAL;
 }
-
 EXPORT_SYMBOL(utf8_casefold);
 
+int utf8_casefold_hash(const struct unicode_map *um, const void *salt,
+		       struct qstr *str)
+{
+	const struct utf8data *data = utf8nfdicf(um->version);
+	struct utf8cursor cur;
+	int c;
+	unsigned long hash = init_name_hash(salt);
+
+	if (utf8ncursor(&cur, data, str->name, str->len) < 0)
+		return -EINVAL;
+
+	while ((c = utf8byte(&cur))) {
+		if (c < 0)
+			return c;
+		hash = partial_name_hash((unsigned char)c, hash);
+	}
+	str->hash = end_name_hash(hash);
+	return 0;
+}
+EXPORT_SYMBOL(utf8_casefold_hash);
+
 int utf8_normalize(const struct unicode_map *um, const struct qstr *str,
 		   unsigned char *dest, size_t dlen)
 {
diff --git a/include/linux/unicode.h b/include/linux/unicode.h
index 990aa97d80496..74484d44c7554 100644
--- a/include/linux/unicode.h
+++ b/include/linux/unicode.h
@@ -27,6 +27,9 @@ int utf8_normalize(const struct unicode_map *um, const struct qstr *str,
 int utf8_casefold(const struct unicode_map *um, const struct qstr *str,
 		  unsigned char *dest, size_t dlen);
 
+int utf8_casefold_hash(const struct unicode_map *um, const void *salt,
+		       struct qstr *str);
+
 struct unicode_map *utf8_load(const char *version);
 void utf8_unload(struct unicode_map *um);
 
-- 
2.27.0.111.gc72c7da667-goog

