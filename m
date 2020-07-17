Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3251A223076
	for <lists+linux-fscrypt@lfdr.de>; Fri, 17 Jul 2020 03:35:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726973AbgGQBfk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 16 Jul 2020 21:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726974AbgGQBfg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 16 Jul 2020 21:35:36 -0400
Received: from mail-pg1-x54a.google.com (mail-pg1-x54a.google.com [IPv6:2607:f8b0:4864:20::54a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CBD91C08C5C0
        for <linux-fscrypt@vger.kernel.org>; Thu, 16 Jul 2020 18:35:36 -0700 (PDT)
Received: by mail-pg1-x54a.google.com with SMTP id s1so6813388pge.16
        for <linux-fscrypt@vger.kernel.org>; Thu, 16 Jul 2020 18:35:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=M2BARCIgcttWxNELPw4zNOFpxD9+a8coXLhy2/p7EJA=;
        b=ScOd4eVdydlkWQWlLKjntUWKsksUG68MvUJTiQKD/1j4ez9IPtZHneB7t7Ah8qMNyc
         MHTRFtyHLSVQuzXvDGfcq1tmzfAdCtLSmZIu8QiLrxTH5oPYRpc6Xm8acH/i/frdbEfg
         qAGhkmd5lTbDuYireEzW2VFzMdyc3o3Ix94XFQPXLGMjKcpyqYukSAR/2bsRkAy9pBhB
         04thfYfEh36yMRz9fE7EiL6Rb5v/6cBI7oGtqnFqKH9w4ZHgI7/tLWdLQ9a6EuFnbIRP
         YWzo3NcnvBJXf0IanbogryzR0zhzkrtHOFHVCRcHUwUgvU/7rQQ2KBsuYyow/vQSkZkO
         l60g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=M2BARCIgcttWxNELPw4zNOFpxD9+a8coXLhy2/p7EJA=;
        b=jiIJSepXQrIl8t8B8lp7VsNTW6UjTs76Cbm0ugyQ5VlM+S4Gg5lUyMD0XwRG0Qj90p
         SJaAnksUT8/07uSB1ZtT92MJtahXStVaUhz6fj5nkcSryl+DONCe0WDY5GjywoNukusG
         n7OLdM0/GruNKoV/uFABmG0uJaV4n6xqhyYGpl9PsDaN4xDBWPO6d7r4VFliDj4J/v0h
         H/IMAffnghMdELHkRodWiGRi1PN5F2ez8wSlyI0hrcpFRgkHjAk/oc9BgnUGOiWiFWwS
         yOImmcAigi7t/sNViMOpH1CbiAtyoYCWnn9Xq2NvEtGzI+iw+2JlNXnGuFlc9xVvkcIY
         XNVQ==
X-Gm-Message-State: AOAM530WntTq0RbYrNUhLI9Euu4bry++7H7Bb47BsrLynQnF/W46cxjq
        wSd3gQAO4O0O63P5vtDX3NUgXO6Uku5iCtldLpd8zcSckdq/vP7zjW5FtTGXO7YJ1rG5o7PQw+R
        A+cIXj1+Zs+MEA+F9uxzlBc3oPbP2k7fkaulikuhsrmwI9/eSromEV5+S1zuRimw85NUyKUo=
X-Google-Smtp-Source: ABdhPJwgAFskhvgfu4vtFSTvQKdAqkDng2ZY6RLfUv2eaMhfxGJSBKlELwg44/Lye+vEDWsHb/qZyTbtD8k=
X-Received: by 2002:a17:902:7008:: with SMTP id y8mr5639281plk.85.1594949736186;
 Thu, 16 Jul 2020 18:35:36 -0700 (PDT)
Date:   Fri, 17 Jul 2020 01:35:17 +0000
In-Reply-To: <20200717013518.59219-1-satyat@google.com>
Message-Id: <20200717013518.59219-7-satyat@google.com>
Mime-Version: 1.0
References: <20200717013518.59219-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v2 6/7] fscrypt: document inline encryption support
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Satya Tangirala <satyat@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Update the fscrypt documentation file for inline encryption support.

Signed-off-by: Satya Tangirala <satyat@google.com>
---
 Documentation/filesystems/fscrypt.rst | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index f5d8b0303ddf..f3d87a1a0a7f 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -1204,6 +1204,18 @@ buffer.  Some filesystems, such as UBIFS, already use temporary
 buffers regardless of encryption.  Other filesystems, such as ext4 and
 F2FS, have to allocate bounce pages specially for encryption.
 
+Fscrypt is also able to use inline encryption hardware instead of the
+kernel crypto API for en/decryption of file contents.  When possible, and
+if directed to do so (by specifying the 'inlinecrypt' mount option for
+an ext4/F2FS filesystem), it adds encryption contexts to bios and
+uses blk-crypto to perform the en/decryption instead of making use
+of the above read/write path changes.  Of course, even if directed to make
+use of inline encryption, fscrypt will only be able to do so if either
+hardware inline encryption support is available for the selected encryption
+algorithm or CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK is selected.  If neither
+is the case, fscrypt will fall back to using the above mentioned read/write
+path changes for en/decryption.
+
 Filename hashing and encoding
 -----------------------------
 
@@ -1250,7 +1262,9 @@ Tests
 
 To test fscrypt, use xfstests, which is Linux's de facto standard
 filesystem test suite.  First, run all the tests in the "encrypt"
-group on the relevant filesystem(s).  For example, to test ext4 and
+group on the relevant filesystem(s).  One can also run the tests
+with the 'inlinecrypt' mount option to test the implementation for
+inline encryption support.  For example, to test ext4 and
 f2fs encryption using `kvm-xfstests
 <https://github.com/tytso/xfstests-bld/blob/master/Documentation/kvm-quickstart.md>`_::
 
-- 
2.28.0.rc0.105.gf9edc3c819-goog

