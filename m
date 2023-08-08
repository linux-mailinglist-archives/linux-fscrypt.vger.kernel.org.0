Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4388577443F
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:16:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233324AbjHHSQQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:16:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232864AbjHHSP4 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:15:56 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78DAA1F40C;
        Tue,  8 Aug 2023 10:22:18 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 016B78354F;
        Tue,  8 Aug 2023 13:22:17 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691515338; bh=PYXYRGTxzf2mT8aQvtS64Oy9XHNpPxgL/l5PEONJa0A=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=md0/SRAy/lGS01fQdNMFysv9kvTGeMRYsQwSM6CYwnOdzRKuA9ufS4JO57TEwaue1
         Br8D5ufY6/NyCEc5TAeQ5Bbn+ck4WqL0wPD4TYGxvN3vuVBTFvlMGA5UZkUl8wiju8
         C9EerO3sXwOJ8OA9dzrkw6N2SZDKh9QjDnE4UMSv3Q4sRg2Rd7EFyP6E37IUP0rDwX
         I+jL1HDZ78pZ6ZqYXLoPBPoE5o5ANHVNVDcGimwdsgXzj0wuKQdwfOp/brg8ywV7O2
         nAXrgxuaT2tcdYrGNjsq/wFpbbUPLuGL40agGuHjmjueuvOOAV0Swp8Z+NH5vLfDYz
         GLG1SECtZhVdQ==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@meta.com, ebiggers@google.com, anand.jain@oracle.com,
        fdmanana@suse.com, linux-fscrypt@vger.kernel.org,
        fsverity@lists.linux.dev, zlang@kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH v3 7/9] common/verity: explicitly don't allow btrfs encryption
Date:   Tue,  8 Aug 2023 13:21:26 -0400
Message-ID: <27188582f31ad7e6e7027170a81fa84d77815868.1691530000.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1691530000.git.sweettea-kernel@dorminy.me>
References: <cover.1691530000.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
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
index e0937717..5e651316 100644
--- a/common/verity
+++ b/common/verity
@@ -224,6 +224,10 @@ _scratch_mkfs_encrypted_verity()
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
2.41.0

