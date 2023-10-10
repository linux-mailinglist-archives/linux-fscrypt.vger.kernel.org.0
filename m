Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E09C7C411B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 22:26:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234473AbjJJU03 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Oct 2023 16:26:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231596AbjJJU0Y (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Oct 2023 16:26:24 -0400
Received: from mail-yw1-x112b.google.com (mail-yw1-x112b.google.com [IPv6:2607:f8b0:4864:20::112b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46ED9DA
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:26:21 -0700 (PDT)
Received: by mail-yw1-x112b.google.com with SMTP id 00721157ae682-5a7ac4c3666so22724587b3.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Oct 2023 13:26:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1696969580; x=1697574380; darn=vger.kernel.org;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to;
        bh=OFwcUtvU3gU5AGXiF/CPujJ+TekA/xyF9zqxriLoMwM=;
        b=gRQAywef0j79nEmibOimvJGCzSWw6Z5UsPLv3u0VpLoOgzrC/IbFEKbTxIgChb6vpj
         lpEUoZcgsE9U6h+a8oJCem/mFWo80th9o0icWOoNFUYB8jPIi9PxNrKNJ0/OypFvj1ir
         319DWod/C8ATKL/diOCnIdtVjapJYZgXg2U+7ZbhsRB9oicVJW0alOM2nzrvG0ATS5Zn
         ym2/jiSHrSrR7nt6TtoZb3PMmT8rHSe/UGb9Q7/ThV2CZzYTyuKba2b8pGZrzIEWUJnr
         U9vtfjeTJxck/6pEA+VVr3alba6n+OFoEEUKNhZQHI7FolqPJvVJS+wX3tC4JxhhiVGo
         sRzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696969580; x=1697574380;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=OFwcUtvU3gU5AGXiF/CPujJ+TekA/xyF9zqxriLoMwM=;
        b=hmcPt+p5C7B2uz/ZyJNMZCkWkj1uBDgEQEDiPCd/mmKj4/BQhr/60bJJekeSZ9g/qg
         nulQbSAyZcQqjZ/0Ri+/u0IyaUVkU6ac2w5fizJZ4U2pBs1AyiUlrNNKvyXjPqI+U1KD
         OWWsvUZyND8BGFWC+WyGFGdzM4gzoK69Zko5LnSRWpqr5OI3jPbEeZuy1VhE+a4R5yxy
         sfwKCOkY2aZpUHYqO8XFljz+s79CZlRPNHD/uy+pgtzEXzyCMMv28ShIPpvLXTP75ZWn
         XznPBjGqSudfzXD3AlFlSCMHCqBgFlELlN3zv+77XJCz/oNQaJtXrojO/MjdRWrrVULi
         bCWg==
X-Gm-Message-State: AOJu0Yw2iIJ9IkjA1e/q+Oo6D5xgpFK56sdrNIQjfNa/FveAsT/Xf84C
        ETk0dofLSnWEPIhNAWoFY482Qw==
X-Google-Smtp-Source: AGHT+IFQoMBF9uhCT0asEEgYDb3P3Co+GNRB/75Q1mdnz6O01l+cwEoqFE71PBDrmralI/v8iQ9RpQ==
X-Received: by 2002:a81:8104:0:b0:59b:bacb:a84f with SMTP id r4-20020a818104000000b0059bbacba84fmr20903470ywf.47.1696969580433;
        Tue, 10 Oct 2023 13:26:20 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id x9-20020a814a09000000b00589b653b7adsm4691229ywa.136.2023.10.10.13.26.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Oct 2023 13:26:20 -0700 (PDT)
From:   Josef Bacik <josef@toxicpanda.com>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH 02/12] common/encrypt: add btrfs to get_encryption_*nonce
Date:   Tue, 10 Oct 2023 16:25:55 -0400
Message-ID: <f751b02bf76ffb24a126016c089dbf04d2e80823.1696969376.git.josef@toxicpanda.com>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <cover.1696969376.git.josef@toxicpanda.com>
References: <cover.1696969376.git.josef@toxicpanda.com>
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

From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Add the modes of getting the encryption nonces, either inode or extent,
to the various get_encryption_nonce functions. For now, no encrypt test
makes a file with more than one extent, so we can just grab the first
extent's nonce for the data nonce; when we write a bigger file test,
we'll need to change that.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 common/encrypt | 31 +++++++++++++++++++++++++++++++
 1 file changed, 31 insertions(+)

diff --git a/common/encrypt b/common/encrypt
index 04b6e5ac..fc1c8cc7 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -531,6 +531,17 @@ _get_encryption_file_nonce()
 				found = 0;
 			}'
 		;;
+	btrfs)
+		# Retrieve the fscrypt context for an inode as a hex string.
+		# btrfs prints these like:
+		#        item 14 key ($inode FSCRYPT_CTXT_ITEM 0) itemoff 15491 itemsize 40
+		#                value: 02010400000000008fabf3dd745d41856e812458cd765bf0140f41d62853f4c0351837daff4dcc8f
+
+		$BTRFS_UTIL_PROG inspect-internal dump-tree $device | \
+			grep -A 1 "key ($inode FSCRYPT_CTXT_ITEM 0)" | \
+			grep --only-matching 'value: [[:xdigit:]]\+' | \
+			tr -d ' \n' | tail -c 32
+		;;
 	*)
 		_fail "_get_encryption_file_nonce() isn't implemented on $FSTYP"
 		;;
@@ -550,6 +561,23 @@ _get_encryption_data_nonce()
 	ext4|f2fs)
 		_get_encryption_file_nonce $device $inode
 		;;
+	btrfs)
+		# Retrieve the encryption IV of the first file extent in an inode as a hex
+		# string. btrfs prints the file extents (for simple unshared
+		# inodes) like:
+		#         item 21 key ($inode EXTENT_DATA 0) itemoff 2534 itemsize 69
+		#                generation 7 type 1 (regular)
+                #		 extent data disk byte 5304320 nr 1048576
+                #		 extent data offset 0 nr 1048576 ram 1048576
+                #		 extent compression 0 (none)
+                #		 extent encryption 161 ((1, 40: context 0201040200000000116a77667261d7422a4b1ed8c427e685edb7a0d370d0c9d40030333033333330))
+
+
+		$BTRFS_UTIL_PROG inspect-internal dump-tree $device | \
+			grep -A 5 "key ($inode EXTENT_DATA 0)" | \
+			grep --only-matching 'context [[:xdigit:]]\+' | \
+			tr -d ' \n' | tail -c 32
+		;;
 	*)
 		_fail "_get_encryption_data_nonce() isn't implemented on $FSTYP"
 		;;
@@ -572,6 +600,9 @@ _require_get_encryption_nonce_support()
 		# Otherwise the xattr is incorrectly parsed as v1.  But just let
 		# the test fail in that case, as it was an f2fs-tools bug...
 		;;
+	btrfs)
+		_require_command "$BTRFS_UTIL_PROG" btrfs
+		;;
 	*)
 		_notrun "_get_encryption_*nonce() isn't implemented on $FSTYP"
 		;;
-- 
2.41.0

