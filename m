Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7DCA22CE0D
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Jul 2020 20:45:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgGXSpU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Jul 2020 14:45:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726877AbgGXSpT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Jul 2020 14:45:19 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0388DC0619D3
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Jul 2020 11:45:19 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id p8so6949833pgj.14
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Jul 2020 11:45:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=xyIxbqTzEFkSiRwtwQaLWA16wfxvhvC5m78qlSH1ff0=;
        b=mBULbubnOs99wcWvCkuB8DaDJihSO0xMIW84PX5bW6WTDj309RqVaJPHsyAy2kaKCY
         sOD/egWqVHLZ7OUz7656r6qh6CE0O+9+ekoTB8ggySlZKOVBPFRyQhOpz3iP8O3KzA66
         TlNycAcYS2Bt5YOOhe3NHBNfRzmIluIfVqVEZaOTBNsFH2DN2tFUJgfwzvHk+Cfu4ktE
         Ux2qbNoUcHcJSGpYoyJrtPpZVCLD/G+F6TaLMtwwue8ZozjlRyZ5Pqd2SCUqaAjZRuwa
         2twdFk1AzPx/nwa4i8eqkv4wxZlZ4QpFLnVvKFEWArFlrDNn6OdFdOF+0n5c6jitoG4w
         V/dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=xyIxbqTzEFkSiRwtwQaLWA16wfxvhvC5m78qlSH1ff0=;
        b=CcJrcXzxPertdsRh0sb8g/WnxGAkoegKuPw5WlIq44L51CPWx7a33THx4aC3R4p7uW
         3Mq3aS/4AtgBll2TPrSU9p3Jh/Rg/rKkqA+vKJpUh3nxNrd7ACvsZxH83uk/hLTFB3Za
         uU3VCrwt1NuqE0edet5AqZJOTXqa7F8fs4tCaGTcFzzImQ3A5/0BO/PEFmPosHluNbs7
         M/scRtoHfH949F3ob63Wn2oeAx+uqgUWzgC48yoMFlcL6nqbfMx4xDPWAcfdKJO/zRsu
         T8QG+S+O+5zMggdHO8Ww9teghg12UaZqhDVJiyQ10Cnpe1SvdtjQ8IVK3Lz+HYMOpFgL
         ikeA==
X-Gm-Message-State: AOAM5313Udd0tdBpZhDyP1V9AqHu1D/TI+qOGOhEB2pu+F7vKbhjiLrW
        icW5VHtfSwDBRtmMYyYwEAr9/PIN5C9PMz0fzSgWD/4QdOAUwlLF8eo84P6FCpa7xehC/gHUZIC
        DElIdZX8zZg4zGHq2I5I16x4gOW5/6eoTf6r+uhnGlKbwipGsBFE1XFebWjjxO7IESzqJPoM=
X-Google-Smtp-Source: ABdhPJzkqIhgfmuH4Tw2HNitGStx6+I2VoJ2h2ZcDf2nCz9kSOHpDDkKAQY+0hH0A++BUEd5FyALMx/aU4Y=
X-Received: by 2002:a17:90a:1fcb:: with SMTP id z11mr1970016pjz.1.1595616317802;
 Fri, 24 Jul 2020 11:45:17 -0700 (PDT)
Date:   Fri, 24 Jul 2020 18:45:01 +0000
In-Reply-To: <20200724184501.1651378-1-satyat@google.com>
Message-Id: <20200724184501.1651378-8-satyat@google.com>
Mime-Version: 1.0
References: <20200724184501.1651378-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v6 7/7] fscrypt: update documentation for direct I/O support
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Satya Tangirala <satyat@google.com>,
        Eric Biggers <ebiggers@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Update fscrypt documentation to reflect the addition of direct I/O support
and document the necessary conditions for direct I/O on encrypted files.

Signed-off-by: Satya Tangirala <satyat@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 Documentation/filesystems/fscrypt.rst | 20 ++++++++++++++++++--
 1 file changed, 18 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 423c5a0daf45..b9bbd6c612ff 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -1049,8 +1049,10 @@ astute users may notice some differences in behavior:
   may be used to overwrite the source files but isn't guaranteed to be
   effective on all filesystems and storage devices.
 
-- Direct I/O is not supported on encrypted files.  Attempts to use
-  direct I/O on such files will fall back to buffered I/O.
+- Direct I/O is supported on encrypted files only under some
+  circumstances (see `Direct I/O support`_ for details). When these
+  circumstances are not met, attempts to use direct I/O on encrypted
+  files will fall back to buffered I/O.
 
 - The fallocate operations FALLOC_FL_COLLAPSE_RANGE and
   FALLOC_FL_INSERT_RANGE are not supported on encrypted files and will
@@ -1123,6 +1125,20 @@ It is not currently possible to backup and restore encrypted files
 without the encryption key.  This would require special APIs which
 have not yet been implemented.
 
+Direct I/O support
+==================
+
+Direct I/O on encrypted files is supported through blk-crypto. In
+particular, this means the kernel must have CONFIG_BLK_INLINE_ENCRYPTION
+enabled, the filesystem must have had the 'inlinecrypt' mount option
+specified, and either hardware inline encryption must be present, or
+CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK must have been enabled. Further,
+any I/O must be aligned to the filesystem block size (*not* necessarily
+the same as the block device's block size) - in particular, any userspace
+buffer into which data is read/written from must also be aligned to the
+filesystem block size. If any of these conditions isn't met, attempts to do
+direct I/O on an encrypted file will fall back to buffered I/O.
+
 Encryption policy enforcement
 =============================
 
-- 
2.28.0.rc0.142.g3c755180ce-goog

