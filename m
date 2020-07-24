Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 70AB922C4D3
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Jul 2020 14:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727014AbgGXMMN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Jul 2020 08:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53720 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727115AbgGXMME (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Jul 2020 08:12:04 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E2DAC0619E4
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Jul 2020 05:12:02 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id d202so10143439ybh.12
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Jul 2020 05:12:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=j09FJFOs7ox27oQ/jw0Hg/h+WWOfzzYjATzxUrwtjag=;
        b=uinx4umNBzjZNhDldRFu/4q/KRDj/aDyTI/UPTsQCLp9QNIT/Pkx3JVsXg/gNYy18X
         8fzYbL2l+0BjejTs82TRocYlvCmHfn64VAHgBtAoxl223aUkRG3nBLgaaC3G9xOT+Ee1
         rnavYw4RFQWWpr4kEAgcyApl0DBMmQqQ425gWWhdRZjgy/8fQlCPdngERjFBN7JGM4dr
         U8tyJmjfakSMtKlyzL3/ej5FMsNjZGA0nrRghc67idy4m8GhAjIfh7Nj6B8JlxuCnCUI
         kVLkYfz/3ijWwgCZz1ul3FHiFmKsgTc48xkeKY1rm28DffqkcvD9qA1RRrydNx89Ft+E
         K0ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=j09FJFOs7ox27oQ/jw0Hg/h+WWOfzzYjATzxUrwtjag=;
        b=uERieHeDvcd82pyfTYB9Lg49ejgN81Dt2mJh4GXoiBzZGDeImyRoZiBQnScfXBL1hO
         +7lsvsp39OsgqmiiRZD6dFiWgywOEgsJBbn0al1Pqid+vLsWnMp2bDifb+fOSaygCkJB
         zVhGFZk5VaC5br5JiBxfYScbtXGNdMikewVGHcWsTNLFsOGkzXESUBj+GGj6wsCe7NlX
         vGqX7MuYQIJU3V+ASGejY+NG4GXssM60Ax/YyDpgo2Db8lBWNOnsZslDX9smLwMVmi+T
         fYGNIwPlgRT7JR32S+YeREpnMtul43fP6KSefKFe2RDcfq7SYUOjnB4OtzPeY8XGpGM3
         Ghow==
X-Gm-Message-State: AOAM530gc3BYirQv2gHGFV9/oXdrYg4CQoTad23JKuryo0SI0vCqPm17
        wVWo+g+aigbQDK+jC7F1omrC3ieg5YGKvEjBiAZLTb5ptzpuPUUK7P9z2rRNs+wAwTxXWgaUp+q
        +8FVSCrpx1fXz5WEVOTitaCCjEeSicmcTXXXxSbTjbYzNvZ3+T7mzP4szenrrsXnonyCDuRg=
X-Google-Smtp-Source: ABdhPJx/kR9OGGrb08Cms1pOt8vKHYWUtxe5tDqnionkhbA71lMBxyPqAWtadG1S0CUcqUHbUujo0btmzCE=
X-Received: by 2002:a25:385:: with SMTP id 127mr14857247ybd.141.1595592721412;
 Fri, 24 Jul 2020 05:12:01 -0700 (PDT)
Date:   Fri, 24 Jul 2020 12:11:43 +0000
In-Reply-To: <20200724121143.1589121-1-satyat@google.com>
Message-Id: <20200724121143.1589121-8-satyat@google.com>
Mime-Version: 1.0
References: <20200724121143.1589121-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v5 7/7] fscrypt: update documentation for direct I/O support
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
index ec81598477fc..5367c03b17bb 100644
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

