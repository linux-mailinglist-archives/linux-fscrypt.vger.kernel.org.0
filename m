Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 07D1B74C7C9
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jul 2023 21:11:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229989AbjGITL0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jul 2023 15:11:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229840AbjGITLZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jul 2023 15:11:25 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 44690106;
        Sun,  9 Jul 2023 12:11:24 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 9E15880534;
        Sun,  9 Jul 2023 15:11:23 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688929884; bh=pjiL7vMc1tS4xjdyuCuwVl+RbRize4yAL3Or4y1gyuk=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=dX6jk15odijY8cEEN6QvbxUloTg1Fg4rHDPTAHiF3mK9IGo+WB980GGBYbJcmxzvn
         gV3bxQr6JDECDEjjTBEMpzaOf+Mql4GZjTvQ8LJIFjnMgGM1oIcimgBU3sOulZaoMC
         IfaexxFy69zooiqH0oW6rUtU8UUhpMviWwMG8Xq+Q8+eSI1hDhUO9cZeDzAbKA3Qi8
         PM3mHpbmt1lSbPbjooFk8GUcrjKm3hTPEQdcSsFR2t5epYZ7vVLRsnYAlrBOlJbbkt
         9Sp5mKf1Jy0UGxzhjfM7Abtvu9Ax57VAl5f56MyYQoXy9dZKOtdyDqS7L2l/l4UNlQ
         BYfwO4OZwfERA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@meta.com, ebiggers@google.com, anand.jain@oracle.com,
        fdmanana@suse.com, linux-fscrypt@vger.kernel.org,
        fsverity@lists.linux.dev, zlang@kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH v2 6/8] tests: adjust generic/429 for extent encryption
Date:   Sun,  9 Jul 2023 15:11:09 -0400
Message-Id: <e891b87b67add59ed8816575de8c6c7aeb3bf0ac.1688929294.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1688929294.git.sweettea-kernel@dorminy.me>
References: <cover.1688929294.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Extent encryption is different from the existing inode-based encryption
insofar as it only generates encryption keys for data encryption at the
moment at which the data is written. This means that when a session key is
removed, even if there's an open file using it, that file immediately
becomes unreadable and unwritable.

This isn't an issue for non-session keys, which are soft deleted by
fscrypt and stick around until there are no more open files with extent
encryption using them. But for session keys, which are managed by the
kernel keyring directly instead of through fscrypt, when they're removed
they're removed.

generic/429 uses session keys and expects to use the written data after
key removal; while it's not quite what the test means for other
filesystems, most of the test is still meaningful if we push the dirty
data into the filesystem with a sync before dropping the key.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 tests/generic/429 | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/tests/generic/429 b/tests/generic/429
index 2cf12316..1d26deda 100755
--- a/tests/generic/429
+++ b/tests/generic/429
@@ -68,6 +68,12 @@ show_directory_with_key()
 	show_file_contents
 }
 
+# btrfs needs to have dirty data pushed into it before session keyring
+# is unlinked, as it doesn't set up the data encryption key until then.	
+if [ "$FSTYP" = "btrfs" ]; then
+	sync
+fi
+
 # View the directory without the encryption key.  The plaintext names shouldn't
 # exist, but 'cat' each to verify this, which also should create negative
 # dentries.  The no-key names are unpredictable by design, but verify that the
-- 
2.40.1

