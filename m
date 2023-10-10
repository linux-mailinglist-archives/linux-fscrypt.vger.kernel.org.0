Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BDE667C4197
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:41:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344040AbjJJUlt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:41:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234732AbjJJUlk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:41:40 -0400
Received: from mail-yb1-xb2e.google.com (mail-yb1-xb2e.google.com [IPv6:2607:f8b0:4864:20::b2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75016E0
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:33 -0700 (PDT)
Received: by mail-yb1-xb2e.google.com with SMTP id 3f1490d57ef6-d9a6b21d1daso1113735276.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:41:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696970492; x=1697575292; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=i20kOvsTj8UHy3VlsyWZ2ukU/TrpdD90cKWJsB2jbGw=;
        b=tKaYImHr/Wz1mFkxnqK8G5u50El9N79yut+Rm1gV0Sr8yqK7ZPUqoX+Xfw0bvXPwYf
         JT2KSvRrFvgBytUuUMgV5h9GHjTNSVIBTXhqusHL366RKyE8hEIx6jqdQIF4F10F7Nz+
         QSJCecy6tonNO+dgcCuMvDFjzxxVxcbGgim2bc8ng16/0eJd17oVkciCe3howb7g8zAj
         NNaR9HiArTANgqNL1bySjA5WAICDUo2nyBQyqCRl+ml+9UmpHRLyN3KcwZbgtuAvjrwW
         i6Ewh/NPvsY9G1TLtAtehIxAK/4vJSkz1kzQBeqq7L1W/k/NdLXALkGgbZ8AWTPpZbQh
         /2zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696970492; x=1697575292;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=i20kOvsTj8UHy3VlsyWZ2ukU/TrpdD90cKWJsB2jbGw=;
        b=JgAaQraWYmwmoaptFsbKY9HS10wj+369DrBD2UilolhgzxrT7kjSr9eudc9Ii9ICse
         VaVQA49KFCx64lbbWtmY2qiVx1XarKIkKWVSDcRtFbwNisRdpiTii7eSfulJpSt6eZi/
         LQ2Qo6WkMsAjaG8r6YExeEA+1Io+RlGngIuoSREZCzO+Uy/wQhzmF8PuPI6AAbQ2H7Cu
         xpdPFQ4brXHx3B2J2Z8qGDMSC/6EQmHFOHaXMoUDFOUJuen8EgWr22PCtkemg3jcDJBT
         gK2RD+Y+UqAbS+R2qjo+vRmQZ+RFzbVzuQ7Ozl8x5mx3Fn+vCQIzZcaidr8dVvUYii8R
         aZ+Q==
X-Gm-Message-State: AOJu0Yy9w3b2I+Fdbi+8bFwrKpkIK4jpfA23nZBY2f8QsiP798ZssGsi
        E4HhPp0ZrmDjTbtNR3Nu9gx4xmWLoAcuEh3a63u03g==
X-Google-Smtp-Source: AGHT+IF6/P0RC5ugj8FbxDoA6rzOYfZdz//IF5d8Y8n8HFMre6qnLlII9u3DC5bRx1NPrUOd5hh7SA==
X-Received: by 2002:a25:654:0:b0:d81:599f:a538 with SMTP id 81-20020a250654000000b00d81599fa538mr16230001ybg.51.1696970492507;
        Tue, 10 Oct 2023 13:41:32 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id y7-20020a25ad07000000b00c64533e4e20sm502675ybi.33.2023.10.10.13.41.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:41:32 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-fscrypt@vger.kernel.org, ebiggers@kernel.org,
        linux-btrfs@vger.kernel.org
Subject: [PATCH v2 25/36] btrfs: keep track of fscrypt info and orig_start for dio reads
Date:   Tue, 10 Oct 2023 16:40:40 -0400
Message-ID: <a09fab56e39f0332d9103f96a69d1450653c4884.1696970227.git.josef@toxicpanda.com>
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

We keep track of this information in the ordered extent for writes, but
we need it for reads as well.  Add fscrypt_extent_info and orig_start to
the dio_data so we can populate this on reads.  This will be used later
when we attach the fscrypt context to the bios.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 7d859e327485..d20ccfc5038f 100644
--- a/fs/btrfs/inode.c
+++ b/fs/btrfs/inode.c
@@ -83,6 +83,8 @@ struct btrfs_dio_data {
 	ssize_t submitted;
 	struct extent_changeset *data_reserved;
 	struct btrfs_ordered_extent *ordered;
+	struct fscrypt_extent_info *fscrypt_info;
+	u64 orig_start;
 	bool data_space_reserved;
 	bool nocow_done;
 };
@@ -7727,6 +7729,10 @@ static int btrfs_dio_iomap_begin(struct inode *inode, loff_t start,
 							       release_len);
 		}
 	} else {
+		dio_data->fscrypt_info =
+			fscrypt_get_extent_info(em->fscrypt_info);
+		dio_data->orig_start = em->orig_start;
+
 		/*
 		 * We need to unlock only the end area that we aren't using.
 		 * The rest is going to be unlocked by the endio routine.
@@ -7808,6 +7814,11 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
 		dio_data->ordered = NULL;
 	}
 
+	if (dio_data->fscrypt_info) {
+		fscrypt_put_extent_info(dio_data->fscrypt_info);
+		dio_data->fscrypt_info = NULL;
+	}
+
 	if (write)
 		extent_changeset_free(dio_data->data_reserved);
 	return ret;
-- 
2.41.0

