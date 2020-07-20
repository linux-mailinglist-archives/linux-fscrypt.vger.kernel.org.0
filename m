Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B97D5227327
	for <lists+linux-fscrypt@lfdr.de>; Tue, 21 Jul 2020 01:38:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728160AbgGTXiA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Jul 2020 19:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728108AbgGTXhv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Jul 2020 19:37:51 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3240FC0619D9
        for <linux-fscrypt@vger.kernel.org>; Mon, 20 Jul 2020 16:37:51 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id t18so11375051plo.13
        for <linux-fscrypt@vger.kernel.org>; Mon, 20 Jul 2020 16:37:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=ORAQciKgJGVxLPMl88O8FRaS7Y2vfgBBYDIN8L834Cw=;
        b=lw5TetxAIlCI7U6av5shkKyjO6ThYv7yDbySa3SgWcGSwSgPPaWjP++XkjFPG4OI6Z
         zWsLpvD626keD3tI0jFOivGvaW9+0l5eZ4l7hYSrpPYOPlwsi9MGB5ODpbI/7AA04Zb6
         tCC6woja7XRBkrAJHy6DcRwqP6vgX9nv2QZPhmI0hiNoTeqEbeuJdvn+TgYDZ0U60y3g
         wohrCT9NyZKibcZkl+RWiaSOHqiofv/sVgqViMF4tlhAtCQWBZ6HI7L1fDpq7bbcky5t
         iAtFFwrxXVO/FU54Nfq5i3XKHkcF5DMzbZKLz73/s51/PlZliyzBh0FjxR+L3S2QGwsQ
         HjDw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=ORAQciKgJGVxLPMl88O8FRaS7Y2vfgBBYDIN8L834Cw=;
        b=XotFTW+h77Yr3YpHgrdYcWL+Nds8liq7UViTV67oismWx8DzUTzLnT2QZpl93TgTpa
         0pMWEy3luUwRLEWIvTTUbETF/paoccrZFVrBUaFx22JXm8eRE+8TYPPJtIEMoRmkMQIF
         +RtkFJXoGdwYINzU+5Yi/uV+/+1kM1HAaR0vuiFZpbHel6+1ydx+0WGjm/yJ25vxM8so
         5X4ZdpP6ZYfXUrGZ6d2M2s910bMyteNUEALj44365hNuNFS98zE11PYZqDAJmwpj7XK3
         Hj+5VyMn35rk1IST7oon+KTsyus2p8JsfAj6NBiCbZtpxaeOm+tqmLQXLI26/jAHJOwJ
         shyg==
X-Gm-Message-State: AOAM533TCZthSQhcreLy4RelbmBy9KNqMqjuMFqP2JSMi/+xKADM9dC1
        2WN7BbArPPgs9vsfym7sOPM0m3RlQj8dxbwx8ax3DeTCHrClUB2Jedwbz6dVlIU0KXcJuofiYEU
        jDNjUAFC1nwbGZBSJ168IiTYgpz4VbGg8G8U+Dy5nu5AzUTKW4didVfkVnF6t6oK6DrK4QnA=
X-Google-Smtp-Source: ABdhPJzbpOkXCUZlTjezDtyNTQJ78cDjswr6o9ZRsmmCMJPX/pJ7vOwFhl9AcEfTreNpJVDB8ZhoYLeMtXM=
X-Received: by 2002:a17:90b:358e:: with SMTP id mm14mr1889035pjb.54.1595288270643;
 Mon, 20 Jul 2020 16:37:50 -0700 (PDT)
Date:   Mon, 20 Jul 2020 23:37:37 +0000
In-Reply-To: <20200720233739.824943-1-satyat@google.com>
Message-Id: <20200720233739.824943-6-satyat@google.com>
Mime-Version: 1.0
References: <20200720233739.824943-1-satyat@google.com>
X-Mailer: git-send-email 2.28.0.rc0.105.gf9edc3c819-goog
Subject: [PATCH v4 5/7] f2fs: support direct I/O with fscrypt using blk-crypto
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

