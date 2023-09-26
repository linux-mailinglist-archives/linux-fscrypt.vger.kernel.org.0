Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 970257AF254
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Sep 2023 20:04:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235488AbjIZSDt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Sep 2023 14:03:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235476AbjIZSDr (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Sep 2023 14:03:47 -0400
Received: from mail-qk1-x736.google.com (mail-qk1-x736.google.com [IPv6:2607:f8b0:4864:20::736])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99818180
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:41 -0700 (PDT)
Received: by mail-qk1-x736.google.com with SMTP id af79cd13be357-77411614b57so563392685a.0
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 Sep 2023 11:03:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1695751420; x=1696356220; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:from:to:cc:subject:date:message-id
         :reply-to;
        bh=D//MPuNLkzciDWq9dR0jaALrWtf+3iz7sP2AlyCcVRQ=;
        b=KMQwh9l9axjwB8mxld6xIyW6q/O9O5mHNIWvQvB3EcighyRUuDI8LAgBDUJzvyEnmN
         fBuuU/TBGGGiurPVZDyRUud8CZA+2oTql6WwrQbZTIq60pUNKy+y9DXjbW9my9m949ev
         5PBc9z0SFd8hiLTBcSBrh1tKGETR5d8JwemZFrMyGnE0AxbhhWavJ94kT5J17/ZhkMim
         RiDUH8srVLGxlJUgNfUEEI9bm8TtR6cJki7PGejN4jDUKNwsWcDQJC1djFPwLSk+MDhU
         OzvSNZtfUw8XtsPGtYYrSYtshZGm8M3LkYsiDU7nL8qbpdEY7zswyMY97uzV6i5Quy61
         ch+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1695751420; x=1696356220;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=D//MPuNLkzciDWq9dR0jaALrWtf+3iz7sP2AlyCcVRQ=;
        b=AYt1g8m+ixbGKsn1ZndfVRZv+sDx1c09DgGNtG4RREPYw3DSFdH1kcZgOcgyvHglYY
         uFj3e6U5eoV+Tld4LmYOU7wNJbZzg1kVy4mgzMAhN4V1upeZ9ESVY/r4zow7qGx36k0E
         /JhN7iz7bIy64/V/z0g7TLzCjtGE05US+trKyU7ox8TaBqkUOuQ8gNy4RZfos/W6yf3c
         NIiax3WWh2WtKm2CgUf9iAosg2tj4Uae2Gxq8FFxMHCWnhHXzzYjzSRYiDFDoHbcOLTe
         oXh0Oa2v1WGdFZRdFioQRlsG/Gywnb1bRZnO9pSGoQNX15/gXJ81kfprrHtlTVb1AjF9
         D9GA==
X-Gm-Message-State: AOJu0YwqtbE85JHTnz66nIKiKAdlLvHfykiVVvZHn8FkXJObJxRMh+lo
        W0w3mUL8my7mQA0N/g/l8C7f0Q==
X-Google-Smtp-Source: AGHT+IHeHyWXXybZzqU0PeU94MZuzH8je++ilLv7T7ADS8MV7IzztIR/78JpnKNOKFTrstDNb/kijg==
X-Received: by 2002:a05:6214:f04:b0:655:d6af:1c32 with SMTP id gw4-20020a0562140f0400b00655d6af1c32mr13956040qvb.15.1695751420545;
        Tue, 26 Sep 2023 11:03:40 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id c20-20020a0ce154000000b0065b31dfdf70sm279665qvl.11.2023.09.26.11.03.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 26 Sep 2023 11:03:40 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        ebiggers@kernel.org, linux-fscrypt@vger.kernel.org,
        ngompa13@gmail.com
Subject: [PATCH 24/35] btrfs: keep track of fscrypt info and orig_start for dio reads
Date:   Tue, 26 Sep 2023 14:01:50 -0400
Message-ID: <9428dcaea310bb715222e231b71e5ea39ea5d383.1695750478.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1695750478.git.josef@toxicpanda.com>
References: <cover.1695750478.git.josef@toxicpanda.com>
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

We keep track of this information in the ordered extent for writes, but
we need it for reads as well.  Add fscrypt_extent_info and orig_start to
the dio_data so we can populate this on reads.  This will be used later
when we attach the fscrypt context to the bios.

Signed-off-by: Josef Bacik <josef@toxicpanda.com>
---
 fs/btrfs/inode.c | 11 +++++++++++
 1 file changed, 11 insertions(+)

diff --git a/fs/btrfs/inode.c b/fs/btrfs/inode.c
index 19831291fb54..89cb09a40f58 100644
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
@@ -7729,6 +7731,10 @@ static int btrfs_dio_iomap_begin(struct inode *inode, loff_t start,
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
@@ -7810,6 +7816,11 @@ static int btrfs_dio_iomap_end(struct inode *inode, loff_t pos, loff_t length,
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

