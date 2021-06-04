Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79BF039C212
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Jun 2021 23:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhFDVMP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Jun 2021 17:12:15 -0400
Received: from mail-qv1-f74.google.com ([209.85.219.74]:43656 "EHLO
        mail-qv1-f74.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231506AbhFDVMN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Jun 2021 17:12:13 -0400
Received: by mail-qv1-f74.google.com with SMTP id br4-20020ad446a40000b029021addf7b587so7553126qvb.10
        for <linux-fscrypt@vger.kernel.org>; Fri, 04 Jun 2021 14:10:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=8v+WJhPg9I/xdgL6B4MiQX3CWBXyQYuM5MOB3Jc9dDY=;
        b=QRP2TwQixPWYnCinwP+Ayc/NX9oESif3zXsMESiFr/fPmLerJLAJJI31ktNvQoUUi/
         270xuMczduXDEX0vo2WK/GiF+vYlLeW1mKOFuNGgyPlQ58ZhE1qMy99pqSLvPW1zdSpI
         7WHShNVJE/9VUm/dGSwEosOgNVoiQe1PPfDMFzezYnam9YjQYccnGi34ygSa7XEX7oyb
         0LCE4C40aaOhyoeVm54LpIKdrTmC5JktSYenjEnkgNCDh1qyuQ5tx8nGQ9HAf956iCrx
         BD3SroZd7ttHA4w1l8C5fBKwL3tag/vAJxI3kmg5oNF7aOlMV5WLKwZoVqv3hv8mcYMc
         gRcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=8v+WJhPg9I/xdgL6B4MiQX3CWBXyQYuM5MOB3Jc9dDY=;
        b=D6zxKH5Xsol/REjrkG1eQpuxm0ieVTozPuWtEYUc9BCe+jceiQNlazibYgmWIoCiBI
         F4aBnbLLKoiiviUB6/EKT4dHyg3AWPUFQqJ28Or1pyzVWlC/EuoPSl9gpMUVdH/a4gZI
         SGghZRj24gWbToG6oDD3NLkoF3xWjS/L4b3vmWQrDpn62u75u2m6yfhazTgFkGYTQAYb
         gEo5pRzSPBBhTCG3IfVOSr3cRoXENmJ1cLeARCVpqrRQuuj4lO32N3AaG+di+KCgiAW7
         acyFqLs0huy0RffND1pjgA7cKRmxXMYiM5T+Qp2cwlBYHdYw5ZpNoBZa0SmsY/LNlI4A
         uk0A==
X-Gm-Message-State: AOAM532LoasBJwHbPB/XrwCBwtBVUU/UoSWwbwQdEgJltddlFIhE3RJF
        fHN79eD0bp2eHVq3KAWDp682yyAm3kM=
X-Google-Smtp-Source: ABdhPJyjv+YInqbg6KaJ0jOYrxG2sn5YDWcEehU2DlFwYYyA8k2F0TGVXbcKcmz67/7RnRJ6djeyEnwJoGQ=
X-Received: from satyaprateek.c.googlers.com ([fda3:e722:ac3:10:24:72f4:c0a8:1092])
 (user=satyat job=sendgmr) by 2002:ad4:4e68:: with SMTP id ec8mr6758723qvb.62.1622840966813;
 Fri, 04 Jun 2021 14:09:26 -0700 (PDT)
Date:   Fri,  4 Jun 2021 21:09:08 +0000
In-Reply-To: <20210604210908.2105870-1-satyat@google.com>
Message-Id: <20210604210908.2105870-10-satyat@google.com>
Mime-Version: 1.0
References: <20210604210908.2105870-1-satyat@google.com>
X-Mailer: git-send-email 2.32.0.rc1.229.g3e70b5a671-goog
Subject: [PATCH v9 9/9] fscrypt: update documentation for direct I/O support
From:   Satya Tangirala <satyat@google.com>
To:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>
Cc:     linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org,
        Satya Tangirala <satyat@google.com>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Update fscrypt documentation to reflect the addition of direct I/O support
and document the necessary conditions for direct I/O on encrypted files.

Signed-off-by: Satya Tangirala <satyat@google.com>
Reviewed-by: Eric Biggers <ebiggers@google.com>
Reviewed-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 Documentation/filesystems/fscrypt.rst | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
index 44b67ebd6e40..c0c1747fa2fb 100644
--- a/Documentation/filesystems/fscrypt.rst
+++ b/Documentation/filesystems/fscrypt.rst
@@ -1047,8 +1047,10 @@ astute users may notice some differences in behavior:
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
@@ -1121,6 +1123,21 @@ It is not currently possible to backup and restore encrypted files
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
+the starting position in the file and the length of any I/O must be aligned
+to the filesystem block size (*not* necessarily the same as the block
+device's block size). If any of these conditions isn't met, attempts to do
+direct I/O on an encrypted file will fall back to buffered I/O. However,
+there aren't any additional requirements on user buffer alignment (apart
+from those already present when using direct I/O on unencrypted files).
+
 Encryption policy enforcement
 =============================
 
-- 
2.32.0.rc1.229.g3e70b5a671-goog

