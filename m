Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 344AC7C4175
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:41:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343647AbjJJUlU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234442AbjJJUlP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:15 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E3B891
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:13 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-59bebd5bdadso75469567b3.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970472; x=1697575272; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=04NXAXYAL76rZFvqx8617y1QivsQaz2o0HkmETeNnJo=;
        b=lM7P5Us7VcNlJkQwcpe0kT7qPTAi32j9o+e5Z8XCWMTd410DKf5bjw6OlKq+BpnVmo
         f7QIp7P8/+PLr6pR5DbGZpjovCQ/SDVhdZltsO0HJutfAf+waf3SZardf9TnYlYuixEu
         o+drhTwQed7kmDkCNNQHmB/ISW++a6h4vsmQRK0Vc2LFnbfuduWQn2D/WjxnkxhzU3Yu
         BauHWhoHRNh/Ns9sISO/Da11RiRUNiZZCkVYwRdizLR9N4V0HqxAT5Y5fRsBjpPzkE+I
         46XCVXU87T/IeH/MNW/s6TYFd8k1gyf34LhH3g0A6ctlhEq9Q2gGHBpqgjWVhADcPNs3
         wCnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970472; x=1697575272;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=04NXAXYAL76rZFvqx8617y1QivsQaz2o0HkmETeNnJo=;
        b=wddHGzEkdfHbcU1RlmwdORBw5ocZN+e0EfMN4t0r7maTJHNeVu0jytYaebHw6DM+1R
         Hdu1m+PwK9M5rMwJEuwtsZWA6NF0hARa7y0cC5s1MEivL79R5w5r3pQTXl+8OUHMcYFF
         CqEUg7v2B7ZHMh9/bqqtHIkt9dwfT6AkeITYfB1jihT7Wk5AOIFvOM9r/QHd1t5cfKwG
         voJRck0y6483BJChOs2GZqwbHfA8TBP5xTgh9UxVvR3nF0FXS5MgTijHKwf5i8gO14I5
         x9OLMHFZLXNrpBYCJB3uLkPwFLJDZiPlKyKdXWS2Q5ER1FQbpAWUdfyQrzIPJqVIl7eJ
         j1xA==
X-Gm-Message-State: AOJu0YxTKn4lIgI4eMYyvTTINR5EGZ3KTadgYDNHOaRINpolOt85RwWg
        PHqUSyTEuP/fPI9xWiBKMQ5xJdvv6fTg4ZuL0lFeig==
X-Google-Smtp-Source: AGHT+IGmi7RnyAArKPVXwSMJyCrhSIl3U3g2YRLot+FS8OSdQ1I1a+5v9lOo+SGVn0zVU+Ma7bA0ww==
X-Received: by 2002:a0d:cac5:0:b0:59f:5895:6e38 with SMTP id m188-20020a0dcac5000000b0059f58956e38mr21172770ywd.4.1696970472539;
        Tue, 10 Oct 2023 13:41:12 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id c65-20020a0df344000000b005925765aa30sm4697647ywf.135.2023.10.10.13.41.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:12 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v2 07/36] fscrypt: add documentation about extent encryption
Date:   Tue, 10 Oct 2023 16:40:22 -0400
Message-ID: <68d59d78499743cecf1cdde9d77bfc6fbe1e6a0c.1696970227.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696970227.git.josef@toxicpanda.com>
References: <cover.1696970227.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
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
index 28700fb41a00..6235b1caec2d 100644
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
 
@@ -1394,6 +1409,27 @@ by the kernel and is used as KDF input or as a tweak to cause
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

