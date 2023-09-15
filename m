Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4170A7A1289
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Sep 2023 02:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231190AbjIOAs6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 14 Sep 2023 20:48:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231186AbjIOAs4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 14 Sep 2023 20:48:56 -0400
Received: from mail-qt1-x833.google.com (mail-qt1-x833.google.com [IPv6:2607:f8b0:4864:20::833])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7795C2700
        for <linux-fscrypt@vger.kernel.org>; Thu, 14 Sep 2023 17:48:52 -0700 (PDT)
Received: by mail-qt1-x833.google.com with SMTP id d75a77b69052e-4121b5334f3so9608111cf.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 14 Sep 2023 17:48:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1694738931; x=1695343731; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Womolcib5URMwFyFAQh+64A3zCjTa6snjpP67OrY8xM=;
        b=uFdAi6XMrYOOxFvb+M2n6FRGfhqRG4jgVXHhVJ+W0T9K0GzWxKG83vFHfMEXXD9eXs
         lOhilneSoB+o64U5aLoXVQV9JDbQXhU6sp5RmVwY6vcgaEwUBrYKlwojkZLDi3Is26Kq
         nf+5TwXdbmxEVyup/Q2+IaTMssU2I44TshDvcSgvL/xMNKtI2zQxRbDIIkJ0zr19FAr5
         hqcsGD+xvNZ5lR8YUpyeceM7n6jPvyMY00k/tWhrMIiTxtlfSbPzvJ+TKcdFpI4x2Wnp
         V4sX9N9RGQvt84VD4A2JJUqjlhx9k60ACcYkc5041+NNvWNPUzKlGeTkDyHimg2q7Cpl
         8GpA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694738931; x=1695343731;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Womolcib5URMwFyFAQh+64A3zCjTa6snjpP67OrY8xM=;
        b=PBH4zFhPtfOC/knOAuHabgnzFw1z0oHAtTRHQczKlnmzLYEq+NZDV1CFnekbZ9hXTN
         ENn6R204krtg4+NCY+4l+Fb4xwK+IZH/cRISjd8SGzdXd0PDuokgit+DrlakkNmbAtLS
         oZOYctxAZyA4BwqJTJiu5upFls/dkeWa2B2c7k+CHzAOyLN496AvIg+rkEg/jIIMvabL
         TDqyTz72sX7UwZmxihDheG/nYUDhTg8z2yjrFEWCKI6Q91C94yqadI06bN8SBUJpSDNP
         C1vHckD+6IGLFO6WyXw+K+I1QEygePlcpXJyCXPW5b3NagUYOTYtY8Bdorc4nBh6He2q
         LXiA==
X-Gm-Message-State: AOJu0YxdqHoonZN6zT5xInb/hd/FX4CYOGhiW0bLArTIJkqiMmS8SZ8v
        jhTje07HGYgMCz9Gkta0vQnB/g==
X-Google-Smtp-Source: AGHT+IEoRLy/d8dWr3MMr5dWNOGCqBfv/m8rFpQAZWiAAHtXb7MshEixBrw1F2K3EAu4PGovlP4Rxg==
X-Received: by 2002:ac8:5905:0:b0:3f8:4905:9533 with SMTP id 5-20020ac85905000000b003f849059533mr260545qty.50.1694738931575;
        Thu, 14 Sep 2023 17:48:51 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id hz11-20020a05622a678b00b0040fcf8c0aaasm812977qtb.54.2023.09.14.17.48.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 14 Sep 2023 17:48:51 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        clm@fb.com, ebiggers@kernel.org, ngompa13@gmail.com,
        sweettea-kernel@dorminy.me, kernel-team@meta.com
Subject: [PATCH 3/4] fscrypt: disable all but standard v2 policies for extent encryption
Date:   Thu, 14 Sep 2023 20:47:44 -0400
Message-ID: <040503c718bab5ea5a95294c366f28dcc475cc3f.1694738282.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1694738282.git.josef@toxicpanda.com>
References: <cover.1694738282.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The different encryption related options for fscrypt are too numerous to
support for extent based encryption.  Support for a few of these options
could possibly be added, but since they're niche options simply reject
them for file systems using extent based encryption.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/crypto/policy.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
index cb944338271d..3c8665c21ee8 100644
--- a/fs/crypto/policy.c
+++ b/fs/crypto/policy.c
@@ -198,6 +198,12 @@ static bool fscrypt_supported_v1_policy(const struct fscrypt_policy_v1 *policy,
 		return false;
 	}
 
+	if (inode->i_sb->s_cop->flags & FS_CFLG_EXTENT_ENCRYPTION) {
+		fscrypt_warn(inode,
+			     "v1 policies can't be used on file systems that use extent encryption");
+		return false;
+	}
+
 	return true;
 }
 
@@ -233,6 +239,12 @@ static bool fscrypt_supported_v2_policy(const struct fscrypt_policy_v2 *policy,
 		return false;
 	}
 
+	if ((inode->i_sb->s_cop->flags & FS_CFLG_EXTENT_ENCRYPTION) && count) {
+		fscrypt_warn(inode,
+			     "Encryption flags aren't supported on file systems that use extent encryption");
+		return false;
+	}
+
 	if ((policy->flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY) &&
 	    !supported_direct_key_modes(inode, policy->contents_encryption_mode,
 					policy->filenames_encryption_mode))
-- 
2.41.0

