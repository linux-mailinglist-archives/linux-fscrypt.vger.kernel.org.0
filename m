Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CFCB77C4178
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:41:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343793AbjJJUlW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33448 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234546AbjJJUlS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:18 -0400
Received: from mail-yw1-x1132.google.com (mail-yw1-x1132.google.com [IPv6:2607:f8b0:4864:20::1132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6FCE94
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:16 -0700 (PDT)
Received: by mail-yw1-x1132.google.com with SMTP id 00721157ae682-579de633419so74993277b3.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970475; x=1697575275; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1X/0Zt7z+oOh2YdMAkIlfw4aC9CST8nDgU19CDUdTeo=;
        b=teVsTdd4szHuSRdAaNWifrVhPc0k+riHYOoxOIcXixJ1Pi3Td8JeeeCXNo4q9g5WUn
         v1AKOcL2oFVDu9/8hxxFVtbIRuqpUoQsoNQzTZVcu9ssfciuMfaDx3JEKgLZARSmr6Yt
         JbmPBz8CAp6q7Op9jn2+UXVkiBZGqNb+b4I3DGV774kVSXdU+/dFkAY6uQDwa1QuU5Z6
         8Tx00Zq6u5vUYat5llAyLrRANOrrQqMOn/MKcB8/D+c4uLtoKzunrelxVxiZ4whDSBMz
         yv6/ro5N+jE7wepdeNgiVWcX3wf6KR+JqX3l7v4ohjZ2tZOML2LpT4GFMErikp88/FOd
         FeJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970475; x=1697575275;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1X/0Zt7z+oOh2YdMAkIlfw4aC9CST8nDgU19CDUdTeo=;
        b=TM7yABnTeTpz6hx50pCzpbFxuOPHyFwomWoJ3zoyB18NLgT9xUgbkC1bquNN2MJvq+
         84Opv0Mz5EsTxjDvp4IHX2ipGLGJIVjY0E9LYK8UT6s3IDwOCR2ecxPorSdy6OGV4LEu
         P51NMj4HuwIDYZcUF+OGdng1XzuxeImzJztLVi0uBpLahEJWpbG47jg+76Tl/F8le1JV
         rmPaJSzDzUP5tG1DLp4RosrIznfAx0Ua4DyrIKmq/Pw2JFuZosDlwwtwMyeqMdgsgcjX
         KMI8cBEyBqf08SAG8HieNMwDYgmVjejpBMnnB43FUV2DTIjWm5fkT+89i9EkBG1cj/y2
         6Iag==
X-Gm-Message-State: AOJu0Yz3Wlt/PEowwmnm0V9OZ88FiBGRrff4Kn07iBNSqQ4SW3Xwy26o
        bVlvcfDmUdaS+kwj+68W2xFsLaRw8uljnde3n7D/SQ==
X-Google-Smtp-Source: AGHT+IF2iWI7A9wE0CIU+MsdZuyW9o5G9Md2jSIowPav1/vMVNXMclVs/CcYmtHAA5wT5BpHhVF6Aw==
X-Received: by 2002:a0d:d546:0:b0:58f:a19f:2b79 with SMTP id x67-20020a0dd546000000b0058fa19f2b79mr20759539ywd.9.1696970475587;
        Tue, 10 Oct 2023 13:41:15 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id x132-20020a817c8a000000b005925c896bc3sm4700587ywc.53.2023.10.10.13.41.15
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:15 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 10/36] btrfs: disable verity on encrypted inodes
Date:   Tue, 10 Oct 2023 16:40:25 -0400
Message-ID: <f61fb12657e5b29a27c73dc3b5bd175aaf4269ee.1696970227.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696970227.git.josef@toxicpanda.com>
References: <cover.1696970227.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Right now there isn't a way to encrypt things that aren't either
filenames in directories or data on blocks on disk with extent
encryption, so for now, disable verity usage with encryption on btrfs.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/verity.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index 66e2270b0dae..92536913df04 100644
--- a/fs/btrfs/verity.c
+++ b/fs/btrfs/verity.c
@@ -588,6 +588,9 @@ static int btrfs_begin_enable_verity(struct file *filp)
 
 	ASSERT(inode_is_locked(file_inode(filp)));
 
+	if (IS_ENCRYPTED(&inode->vfs_inode))
+		return -EINVAL;
+
 	if (test_bit(BTRFS_INODE_VERITY_IN_PROGRESS, &inode->runtime_flags))
 		return -EBUSY;
 
-- 
2.41.0

