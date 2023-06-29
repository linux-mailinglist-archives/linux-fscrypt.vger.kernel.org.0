Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE501743049
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Jun 2023 00:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231546AbjF2WRu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Jun 2023 18:17:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229668AbjF2WRp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Jun 2023 18:17:45 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F024E30F7;
        Thu, 29 Jun 2023 15:17:43 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 418048082B;
        Thu, 29 Jun 2023 18:17:43 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688077063; bh=KsB5sQbySYMhE+PMRxhIhPEsjLq+a0xS6NkFqRAT2JM=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=Gy5MvQKnjArRiu9JZMSBgQ4sQMwGCZFCPvgKafVg/j4tHWSO0NsHfqWmBaZ3g7vyW
         nmsrXQFocRQuxsc0HACBkI3Jex5sr1r6p0UIocF7tVI6qc6tRGAUjOfSH9OkRN67eS
         6WtfKKB7DizkqdJEY+ZLLR4rntD/x8W8/OdBVfN473YfVpVUWvUFoObtinm/5NqOkW
         hLutD4sWe9P8+PiOJl0MenXVn2KImgLo+JEONzHHKX46KJ1ALtxrdhv3R74f0Esvei
         ahRajI1yBzjeNwyw4EwRDfWmnuvYRyqD8mFZU3G0hBYJbRAWXIOa53TWQw97whqAPY
         61aDrhMsuZ5Eg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@meta.com, ebiggers@google.com, anand.jain@oracle.com,
        fdmanana@suse.com, linux-fscrypt@vger.kernel.org,
        fsverity@lists.linux.dev, zlang@kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH 7/8] common/verity: explicitly don't allow btrfs encryption
Date:   Thu, 29 Jun 2023 18:17:22 -0400
Message-Id: <ea067593c9bc754c6194607ad9ef5b1ef37afd2d.1688076612.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1688076612.git.sweettea-kernel@dorminy.me>
References: <cover.1688076612.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_SBL_CSS,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Currently btrfs encryption doesn't support verity, but it is planned to
one day. To be explicit about the lack of support, add a custom error
message to the combination.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 common/verity | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/common/verity b/common/verity
index 77c257d3..5002dd71 100644
--- a/common/verity
+++ b/common/verity
@@ -218,6 +218,10 @@ _scratch_mkfs_encrypted_verity()
 		# features with -O.  Instead -O must be supplied multiple times.
 		_scratch_mkfs -O encrypt -O verity
 		;;
+	btrfs)
+		# currently verity + encryption is not supported
+		_notrun "btrfs doesn't currently support verity + encryption"
+		;;
 	*)
 		_notrun "$FSTYP not supported in _scratch_mkfs_encrypted_verity"
 		;;
-- 
2.40.1

