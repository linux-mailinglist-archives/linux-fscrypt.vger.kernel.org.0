Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 357697AF23F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:04:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235413AbjIZSD3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235301AbjIZSD2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:28 -0400
Received: from mail-qv1-xf2c.google.com (mail-qv1-xf2c.google.com [IPv6:2607:f8b0:4864:20::f2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64770120
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:21 -0700 (PDT)
Received: by mail-qv1-xf2c.google.com with SMTP id 6a1803df08f44-6588cc0e238so50300876d6.1
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751400; x=1696356200; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ZQ+glbh3WDNJDZmVH3FQJ5H+z2bjYTLVZgaDFi04Qw0=;
        b=agnLSMLDpmxiOGaTroiEEOEr3EUzBgptjq49ShrQY5DPpES+j0jY2wHANu/F4tAknH
         Z5GTFju0bHD8jQjJ7B0+3jLNfVvutAVCI9pAsLjqWe6cyKuj78X3O7ANisie47rb4kT5
         MebSpRua+3YJqENBW/ButkQQHPmSKXuUNBhI0E/I6j/tODx7C7E9zwQ4AITLxzPpRgS2
         M12T+/862a/iYSrizbvBt0yPljSHeMGy3k3LOxYJAssmvV3OnjlYGzRA+jQcVl1q7sEW
         tnYJ+hZCz7oJWxbsqEhmn32afDVqPF5yAulOnt9cG3lWhXWGPrUgH7Ann7r6cDKSxme7
         ZKoQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751400; x=1696356200;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ZQ+glbh3WDNJDZmVH3FQJ5H+z2bjYTLVZgaDFi04Qw0=;
        b=QZ4QOSwenL0oaWNZ8RNs0jj3P1um1gtm2MD+SQr1RBazuQ60aqzu/nEiCe0oKFUSIT
         7Yomhu+iCWf9f6IPt/Hi2Tl73h6GnAhNFnsMo2MvQZz1VjUiofHLYyQ2NS52dRpHSHkK
         UqILJYcwcDKM4JZh29sMXCNGbdTvii4cSTlfmnZso+oZJUeSGWhBzA51BxUFuMXGsB5M
         0IapojwijRyQevLF/wkgemx37n9tCNDh4cYNAuWIl6AzebYixdErBRVwmxJYNfdJzmHD
         VOt0YOvlxXGoKlkP7BpKymtphd17tG/qkBhhCnz1QuRWruSU8gN0yRkkmr47+Cu78AKb
         c0jg==
X-Gm-Message-State: AOJu0YwEjXwsA7nkgfz+zre/qCLfNKfLBE58+WaXflBgfK5okE0armFv
        AAtDLbuR+X/wxMHMJtMwbYjCaA==
X-Google-Smtp-Source: AGHT+IET3lpee/aysQzVIayOhVk8cRngwDrCawKohmO5XD5Ik4CvYNwMMYAVXSTGfWpMqnC3L8S3lw==
X-Received: by 2002:a05:6214:a63:b0:656:25a5:7060 with SMTP id ef3-20020a0562140a6300b0065625a57060mr9886946qvb.59.1695751400378;
        Tue, 26 Sep 2023 11:03:20 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id u18-20020a0cb412000000b0065896b9fb15sm1676173qve.29.2023.09.26.11.03.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:20 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Subject: [PATCH 06/35] fscrypt: add documentation about extent encryption
Date:   Tue, 26 Sep 2023 14:01:32 -0400
Message-ID: <ef1f0f9bc0040a3cc3216d417365f8636dca25a5.1695750478.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1695750478.git.josef@toxicpanda.com>
References: <cover.1695750478.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Add a couple of sections to the fscrypt documentation about per-extent
encryption.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 Documentation/filesystems/fscrypt.rst | 36 +++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index a624e92f2687..9981eaf61f32 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -256,6 +256,21 @@ alternative master keys or to support rotating master keys.  Instead,
 the master keys may be wrapped in userspace, e.g. as is done by the
 `fscrypt <https://github.com/google/fscrypt>`_ tool.
 
+Per-extent encryption keys
+--------------------------
+
+For certain file systems, such as btrfs, it's desired to derive a
+per-extent encryption key.  This is to enable features such as snapshots
+and reflink, where you could have different inodes pointing at the same
+extent.  When a new extent is created fscrypt randomly generates a
+16-byte nonce and the file system stores it along side the extent.
+Then, it uses a KDF (as described in `Key derivation function`_) to
+derive the extent's key from the master key and nonce.
+
+Currently the inode's master key and encryption policy must match the
+extent, so you cannot share extents between inodes that were encrypted
+differently.
+
 DIRECT_KEY policies
 -------------------
 
@@ -1339,6 +1354,27 @@ by the kernel and is used as KDF input or as a tweak to cause
 different files to be encrypted differently; see `Per-file encryption
 keys`_ and `DIRECT_KEY policies`_.
 
+Extent encryption context
+-------------------------
+
+The extent encryption context mirrors the important parts of the above
+`Encryption context`_, with a few ommisions.  The struct is defined as
+follows::
+
+        struct fscrypt_extent_context {
+                u8 version;
+                u8 encryption_mode;
+                u8 master_key_identifier[FSCRYPT_KEY_IDENTIFIER_SIZE];
+                u8 nonce[FSCRYPT_FILE_NONCE_SIZE];
+        };
+
+Currently all fields much match the containing inode's encryption
+context, with the exception of the nonce.
+
+Additionally extent encryption is only supported with
+FSCRYPT_EXTENT_CONTEXT_V2 using the standard policy, all other policies
+are disallowed.
+
 Data path changes
 -----------------
 
-- 
2.41.0

