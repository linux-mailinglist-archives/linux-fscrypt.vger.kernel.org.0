Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D05BD2230B2
	for <lists+linux-fscrypt@lfdr.de>; Fri, 17 Jul 2020 03:46:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726593AbgGQBqC (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 16 Jul 2020 21:46:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39462 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbgGQBpx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 16 Jul 2020 21:45:53 -0400
Received: from mail-pg1-x549.google.com (mail-pg1-x549.google.com [IPv6:2607:f8b0:4864:20::549])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B276C08C5E0
        for <linux-fscrypt@vger.kernel.org>; Thu, 16 Jul 2020 18:45:53 -0700 (PDT)
Received: by mail-pg1-x549.google.com with SMTP id v15so6868415pgi.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 16 Jul 2020 18:45:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ORAQciKgJGVxLPMl88O8FRaS7Y2vfgBBYDIN8L834Cw=;
        b=ng8R1/65DV2iU+IQ306zEBb/0gZuzKY2wd9E8N5W+UqslArMsttZ5glLKrikl28eKb
         mHq69ANYkDbSrWX4gfqMUWI2ZBqFfFly0rtpiO9z2tckqlbPuAu+WgKmohY8YtajbC7y
         TAkC3td2D69tT+i8RxwKdpD86ImI888MHpVaS3zpZqe2TBh09T3GOUsEhGrYpq7qszO9
         0eL1IJrZbZyK33JvINmsQYzOQns4GWk/EypSIDCE0Bw5rjnxJookR+K0w4fiVIfjkP4l
         48dzxFnzHST1VX+U4ko1hntKzQ14Ezmb2zBJCYDs2eKpTWvdT0fsRQhtyl4OAmHbNGpd
         7XZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ORAQciKgJGVxLPMl88O8FRaS7Y2vfgBBYDIN8L834Cw=;
        b=dFZiKt+ESLb6Spbls3RimgX0KMuNjbLn/loVvqu24MMsjKRT3Zo3c0p+qyZEAwYa/x
         qFR3gzjsA6NRog2FdEKBin8Yvwm8Pz7AgEe1auZ5KZz9oUcjcN6/BeE+GTJj0g5OxnIQ
         6fVeyxPaerPeCUbC34VFg7Srngr4NZduJ4qHIDSRLFHbIVEKCnP4RcV8/dVDpup6xO4e
         4aEJYlfuuU7rGgmv4HflJvUQFIute9xlvtvXc6DjXxJDSZLDSH0Tsyh3mRsz/n3ld+j1
         P0PNxvj3mQ+FO1wIJDxev44uoDGFff4JNYjtxApnIKrMJM5NcHUwCqcrC6WWrvtTLlI5
         efJQ==
X-Gm-Message-State: AOAM531MG+YsnE/pjQ6AJYebAtrWSiI7/V21hcbPP2EnNtVfq0dLA3LE
        CJIVN9cqEMxSdaIK0zJo/9zFKfsZWHJYsuxmUUFsX0FnIULaBNk5UwI1omyFfFBuMbpLU0nGK2O
        gkZoXiyIIlFhwPbYjyW61WkN+3YKpc/Lye+C0hO/y3rmDHZGXI6N6ae04ut4Y7GvNpkziG8U=
X-Google-Smtp-Source: ABdhPJypMvXx5XgQi+oxPJJGIhfKX32tGeIjNcFpR4zHf1BJbMQwMi373dkhjOi4KnE/mp1ikT0bXUTweTE=
X-Received: by 2002:a17:90a:2b8f:: with SMTP id u15mr7349194pjd.98.1594950352671;
 Thu, 16 Jul 2020 18:45:52 -0700 (PDT)
Date:   Fri, 17 Jul 2020 01:45:38 +0000
In-Reply-To: <20200717014540.71515-1-satyat@google.com>
Message-Id: <20200717014540.71515-6-satyat@google.com>
Mime-Version: 1.0
References: <20200717014540.71515-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v3 5/7] f2fs: support direct I/O with fscrypt using blk-crypto
From:   Satya Tangirala <satyat@google.com>
To:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-ext4@vger.kernel.org
Cc:     linux-xfs@vger.kernel.org, Eric Biggers <ebiggers@google.com>,
        Satya Tangirala <satyat@google.com>
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
2.28.0.rc0.105.gf9edc3c819-goog

