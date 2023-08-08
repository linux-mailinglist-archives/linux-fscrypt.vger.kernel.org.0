Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B2AE6774438
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235480AbjHHSQO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233327AbjHHSPy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:15:54 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 208DF72B8;
        Tue,  8 Aug 2023 10:22:14 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id B1571809E9;
        Tue,  8 Aug 2023 13:22:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691515333; bh=726Inc6P68BCi0kM+SUSni3m2wN66ATgsTZpdV1YXhA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=w2iw0OWh+nUjaKDkhWMKMEaHCUJawApxUAUe/nrDey15oXBcy2yG3RjrFIwfIKt8F
         pFSpf/AT+avhEWMfnWOmaYswBMTJDEJs18SbdCMKua579tjYZf2FrFFmYYMVHkWVnk
         Bm1zBhLLx8XlN2lS/V76bO4jUujZTnjpbHYepR13pzH35WA2C/iY4EI0r68FJbV+I8
         88/poEu/zzBw6nh7rV/UpCJslz70ATeq1Z++e3i3UUWlBZD9ykSXWoLyGoYOWAxlB9
         gAfxCQHl0feLgtOS5vLV0DsvIzfjz6ICKtvVs87/Zqh04CHZ3CluUSMEKWn3hL4x9a
         LGzme54L6kTsQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@meta.com, ebiggers@google.com, anand.jain@oracle.com,
        fdmanana@suse.com, linux-fscrypt@vger.kernel.org,
        fsverity@lists.linux.dev, zlang@kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH v3 4/9] common/encrypt: enable making a encrypted btrfs filesystem
Date:   Tue,  8 Aug 2023 13:21:23 -0400
Message-ID: <810d879650dd3bd8da1df2e4611d55adaf670ae4.1691530000.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691530000.git.sweettea-kernel@dorminy.me>
References: <cover.1691530000.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 common/encrypt | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/common/encrypt b/common/encrypt
index 2c1925da..1372af66 100644
--- a/common/encrypt
+++ b/common/encrypt
@@ -153,6 +153,9 @@ _scratch_mkfs_encrypted()
 		# erase the UBI volume; reformated automatically on next mount
 		$UBIUPDATEVOL_PROG ${SCRATCH_DEV} -t
 		;;
+	btrfs)
+		_scratch_mkfs
+		;;
 	ceph)
 		_scratch_cleanup_files
 		;;
@@ -168,6 +171,9 @@ _scratch_mkfs_sized_encrypted()
 	ext4|f2fs)
 		MKFS_OPTIONS="$MKFS_OPTIONS -O encrypt" _scratch_mkfs_sized $*
 		;;
+	btrfs)
+		_scratch_mkfs_sized $*
+		;;
 	*)
 		_notrun "Filesystem $FSTYP not supported in _scratch_mkfs_sized_encrypted"
 		;;
-- 
2.41.0

