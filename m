Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4721F22C4C5
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Jul 2020 14:12:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726975AbgGXMMK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Jul 2020 08:12:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726971AbgGXMMB (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Jul 2020 08:12:01 -0400
Received: from mail-yb1-xb4a.google.com (mail-yb1-xb4a.google.com [IPv6:2607:f8b0:4864:20::b4a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1987C08C5E0
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Jul 2020 05:11:58 -0700 (PDT)
Received: by mail-yb1-xb4a.google.com with SMTP id a185so8121892ybg.8
        for <linux-fscrypt@vger.kernel.org>; Fri, 24 Jul 2020 05:11:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oZN8SnIpsU7aOjS5+8MoI/0a82Ym0e3d0O/7K4J6ac4=;
        b=slmTUkhiIwbSQEjfkgmbeV4KCF4u08msiGK6SabnKAiv3CvAYVrGboynyzzbTajxKw
         dZH2xvPQR8jXzK/qntUI9lKlDPtetaRmLCjNT5omgxxhrMizgoRnSC0roIaFgwopHXTv
         IXhLjv+xSOfUUk6gqkYmieytlR1L9nV3xvpbFcQbtEdY9WsWZGStH0uxtSTg0ybo+Yxm
         vNqm/3J1IWd3IHGexMF628lSrVQrvqvd4tFPYBV1UKFjQMZxtGxh9xzY6EDBXANOm8ma
         khmwfHYWnDUYIZDYcO3J3ycu2JUI8GPQwMez8LsY1EOnHkqtMh2j3Mt5z7kSMvf3UCRW
         rFgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oZN8SnIpsU7aOjS5+8MoI/0a82Ym0e3d0O/7K4J6ac4=;
        b=Z24W4kkHKYvTZeR9OohJRnDCICx0k262KtraBumACUd9EyjO1foKpqLwO8FwUdtrl5
         6xDbibHGNsuU5DARtWWNMZGlP7q2rMlCmMsP297lEI0Bgn9Gz06HlxjPSfKkaka544JJ
         K5V8b5vgSG9JZuW9WVTU6eBlTq3xpjP3IdBQi5Ntu2U8wdGcl++V53DIiA0h2kYU8db6
         B5UuSymfAtjI6sUVJP3SibEwUlAAkr5F9M0sB99LEOQH90KYtnTn87MFyK5ICKaeyQdA
         sGxX3SdYAHrnUQeSmhMFMHQuil4eDvyWRcZdNOCEhpKJdIfA2yQO3lWai2hjfeFLexwc
         Jozg==
X-Gm-Message-State: AOAM532KO5ub5qc5PDwfaGrQCKgoiQQCJSPXwmsBFbTNPN/02vtvQqKI
        dUorwJzrVDqXtrcOwoy2aspx14OAGbkXHf+Ty8tlBqgEzAV5A8RCDch2QlQphLWirzsUs7RuXaw
        GQkAtxDjoGQzdJcsdPmTprc+dVWaofzqiTqZ4w196vUbQb7zhS0zkc3cMNL0eAg0OO0tOiRk=
X-Google-Smtp-Source: ABdhPJyouJ1E2gRcgMN/M3G2tNtXRlKvJhp7ZjedMaUfi7bBr8eQzy4Glr/QlcgRyBhW5mboqWuW4qtyaT8=
X-Received: by 2002:a25:bb07:: with SMTP id z7mr13476612ybg.343.1595592718109;
 Fri, 24 Jul 2020 05:11:58 -0700 (PDT)
Date:   Fri, 24 Jul 2020 12:11:41 +0000
In-Reply-To: <20200724121143.1589121-1-satyat@google.com>
Message-Id: <20200724121143.1589121-6-satyat@google.com>
Mime-Version: 1.0
References: <20200724121143.1589121-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.142.g3c755180ce-goog
Subject: [PATCH v5 5/7] f2fs: support direct I/O with fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Satya Tangirala <satyat@google.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Wire up f2fs with fscrypt direct I/O support. direct I/O with fscrypt is
only supported through blk-crypto (i.e. CONFIG_BLK_INLINE_ENCRYPTION must
have been enabled, the 'inlinecrypt' mount option must have been specified,
and either hardware inline encryption support must be present or
CONFIG_BLK_INLINE_ENCYRPTION_FALLBACK must have been enabled). Further,
direct I/O on encrypted files is only supported when I/O is aligned
to the filesystem block size (which is *not* necessarily the same as the
block device's block size).

Signed-off-by: Eric Biggers <ebiggers@google.com>
Co-developed-by: Satya Tangirala <satyat@google.com>
Signed-off-by: Satya Tangirala <satyat@google.com>
Acked-by: Jaegeuk Kim <jaegeuk@kernel.org>
---
 fs/f2fs/f2fs.h | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
index b35a50f4953c..978130b5a195 100644
--- a/fs/f2fs/f2fs.h
+++ b/fs/f2fs/f2fs.h
@@ -4082,7 +4082,11 @@ static inline bool f2fs_force_buffered_io(struct inode *inode,
 	struct f2fs_sb_info *sbi = F2FS_I_SB(inode);
 	int rw = iov_iter_rw(iter);
 
-	if (f2fs_post_read_required(inode))
+	if (!fscrypt_dio_supported(iocb, iter))
+		return true;
+	if (fsverity_active(inode))
+		return true;
+	if (f2fs_compressed_file(inode))
 		return true;
 	if (f2fs_is_multi_device(sbi))
 		return true;
-- 
2.28.0.rc0.142.g3c755180ce-goog

