Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 69409774437
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235555AbjHHSQO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:16:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234958AbjHHSPz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:15:55 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EBBCC72BA;
        Tue,  8 Aug 2023 10:22:16 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 868BC8354E;
        Tue,  8 Aug 2023 13:22:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691515336; bh=p0lhrwRpH0M08g76wr/r8ueKNz5/IfAaaBLhtQvn+Po=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=JULWczvRUBLxdZcdp04IbpPnHo4zu+K8pB7HAS8HjKcIz+L9GtjY2H43j9OFxRvvJ
         5qXoYchSa9DeV/WCGLCuIRuaMctWnM5jEMYy02QXXJH5e2eeIMMSPDQuv+ZW1Lju5g
         fLR0xEFF5whXC27nKEpNEXV3HXty1c2Yjohm58JcP3ja/mxuJvG6vfKgKvQSnbWu9f
         0KsWQKw41rPlJLOF39aH+epy1dPvnNgHNpnVWcnE2E7WsfmaNUY0QvsaeJV7DpqwLy
         bT8DsQq61CfR8v6Nm4qPc9oNVhHjYG6dIORsGHvziGVpb3ecgNhKa4yD62aNX5gFXv
         Pp4dNl8YcpX+w==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@meta.com, ebiggers@google.com, anand.jain@oracle.com,
        fdmanana@suse.com, linux-fscrypt@vger.kernel.org,
        fsverity@lists.linux.dev, zlang@kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [RFC PATCH v3 6/9] tests: adjust generic/429 for extent encryption
Date:   Tue,  8 Aug 2023 13:21:25 -0400
Message-ID: <0952e60c8e73a41a0448e3ada8172744a6882550.1691530000.git.sweettea-kernel@dorminy.me>
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
2.41.0

