Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E85DF7C416B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:41:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231825AbjJJUlP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234393AbjJJUlJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:09 -0400
Received: from mail-yw1-x1136.google.com (mail-yw1-x1136.google.com [IPv6:2607:f8b0:4864:20::1136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36ECC94
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:07 -0700 (PDT)
Received: by mail-yw1-x1136.google.com with SMTP id 00721157ae682-5a7afd45199so21354477b3.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970466; x=1697575266; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=fkPDGYDbzsyT2iviorbG84fmLsSBIDBYGMivDDhcaSA=;
        b=Fw12OkQzJz1RqOIy5OpR4Cy7l7SIn84viBkp36/p04qC2CLP6ebe34hP9ZoxPltmEd
         pVn1HTMK3VTJIxIr4J5fT3wVDrLvSBPx7tzV9AKA/aRVRc0qE3X9+RPT3Kt4rBj/SqZy
         sknmKjtZedi63p56frXZy/tZYILauVt+Ibl96h8Kuw9r+ZjJ1GDVQn7wZpUIlJX+D5qV
         zBHa9yHrL+uc6wrWDDnsWXrLQvCy7MHfnKhYBPEsPPoOUtShOx2wuZP75hITrWbrRxcu
         Brs/s7KGnbDCNM5h/IfZL+xzF/FvkCi85wHQZxo17HN2X1OlTmyZIWq4hRqtd0vrKr0d
         oSOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970466; x=1697575266;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=fkPDGYDbzsyT2iviorbG84fmLsSBIDBYGMivDDhcaSA=;
        b=B9MVw7keOWpWYlZsJqvFq7d4Mx8HPnkgwcITtKIas3PlZp9dqF0xNhe4nxJNOnHgZk
         1OtFKfaTJo+cmgsMjXMFOkce6fnzhcxECOdA0FREvCNYcpcXDNhwfh4oPGmZ4b31Jp1I
         QmEae2fnybUp1hxMm9yh1tor64Il+T7O0RlZ8UNmKyT/Wgvt7bhvwiyqtkcv2/qlr305
         pFNd6FX+jqeGW4D15tUznP0iRaNSGOkxIJb5pn/vn85oPtAByNnAqh6/6jo89u9O1oKT
         K5kfSMbJ6HtFMjLtWuPQhoMH+f0HjJsghEzqh5ITDpkcLuHoR585ZYwgr4WneO5l+F+H
         D2WA==
X-Gm-Message-State: AOJu0Yz15wkGq58IXKDPWn/Kw3OBXsYJvsYYGR1j9/iXOVb3pnZAdayt
        jJfPqdIVkzZ+SNpv0N0Vliy7PhfK9LRg01cMMA+pIw==
X-Google-Smtp-Source: AGHT+IF3+989+mVbsCnTHYZ6gvtzCY6x1ia4u7mwISczqB7A5h4+dXkdgsfoaI3v75hIIbv4o4zN9Q==
X-Received: by 2002:a81:6f85:0:b0:569:e7cb:cd4e with SMTP id k127-20020a816f85000000b00569e7cbcd4emr18009889ywc.48.1696970466174;
        Tue, 10 Oct 2023 13:41:06 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id c65-20020a0df344000000b005925765aa30sm4697589ywf.135.2023.10.10.13.41.05
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:05 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v2 02/36] fscrypt: don't wipe mk secret until the last active user is gone
Date:   Tue, 10 Oct 2023 16:40:17 -0400
Message-ID: <e5cce8880fd1072bd08988ddd8fb2d619445bda3.1696970227.git.josef@toxicpanda.com>
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

Previously we were wiping the master key secret when we do
FS_IOC_REMOVE_ENCRYPTION_KEY, and then using the fact that it was
cleared as the mechanism from keeping new users from being setup.  This
works with inode based encryption, as the per-inode key is derived at
setup time, so the secret disappearing doesn't affect any currently open
files from being able to continue working.

However for extent based encryption we do our key derivation at page
writeout and readpage time, which means we need the master key secret to
be available while we still have our file open.

Since the master key lifetime is controlled by a flag, move the clearing
of the secret to the mk_active_users cleanup stage.  This counter
represents the actively open files that still exist on the file system,
and thus should still be able to operate normally.  Once the last user
is closed we can clear the secret.  Until then no new users are allowed,
and this allows currently open files to continue to operate until
they're closed.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/crypto/keyring.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/fs/crypto/keyring.c b/fs/crypto/keyring.c
index e0e311ed6b88..31ea81d97075 100644
--- a/fs/crypto/keyring.c
+++ b/fs/crypto/keyring.c
@@ -116,6 +116,7 @@ void fscrypt_put_master_key_activeref(struct super_block *sb,
 	memzero_explicit(&mk->mk_ino_hash_key,
 			 sizeof(mk->mk_ino_hash_key));
 	mk->mk_ino_hash_key_initialized = false;
+	wipe_master_key_secret(&mk->mk_secret);
 
 	/* Drop the structural ref associated with the active refs. */
 	fscrypt_put_master_key(mk);
@@ -245,7 +246,6 @@ void fscrypt_destroy_keyring(struct super_block *sb)
 			WARN_ON_ONCE(refcount_read(&mk->mk_active_refs) != 1);
 			WARN_ON_ONCE(refcount_read(&mk->mk_struct_refs) != 1);
 			WARN_ON_ONCE(!is_master_key_secret_present(mk));
-			wipe_master_key_secret(&mk->mk_secret);
 			set_bit(FSCRYPT_MK_FLAG_EVICTED, &mk->mk_flags);
 			fscrypt_put_master_key_activeref(sb, mk);
 		}
@@ -1064,7 +1064,6 @@ static int do_remove_key(struct file *filp, void __user *_uarg, bool all_users)
 	/* No user claims remaining.  Go ahead and wipe the secret. */
 	err = -ENOKEY;
 	if (!test_and_set_bit(FSCRYPT_MK_FLAG_EVICTED, &mk->mk_flags)) {
-		wipe_master_key_secret(&mk->mk_secret);
 		fscrypt_put_master_key_activeref(sb, mk);
 		err = 0;
 	}
-- 
2.41.0

