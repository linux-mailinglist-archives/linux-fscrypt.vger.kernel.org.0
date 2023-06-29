Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 17778741D22
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jun 2023 02:35:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbjF2Afy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jun 2023 20:35:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231453AbjF2Afv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jun 2023 20:35:51 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B4F2972;
        Wed, 28 Jun 2023 17:35:49 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 3F26580727;
        Wed, 28 Jun 2023 20:35:49 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1687998949; bh=AtxgWhk5lNBLM6gRG58Tv02HFvsxRv3MxdlBvwTanfs=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=GTlmXPw4dsJg4K++rqUa3lRarPKkWCe6BjnxuypVM9CCL7E6/xnyjJn5dlBBfv+xX
         i1O2xmPw7F5q4Gv9rLyHRpmA/s5QS4eA5N5LsO55m4ouZuxYoKnIsBawNhG166cCsX
         twYJXhe4DuxcGwioApoxjWt0gEtGpYTLXniNvWbH5q7TKXD+fDfefmQ+hYl0uar7tb
         jU8yv3roN0xfISi1got2Vv3coJoL9G0vz20TLfxQ7ILz1O0LdBVewDqSpnzlShbvzG
         zh0Ms8ZxMlF4jtkwxig8DYwws/kwtUyHScKLde1AYgncTaR3rguHb/NK+05jbgJqei
         WwlTPvONPbB4w==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 02/17] btrfs: disable verity on encrypted inodes
Date:   Wed, 28 Jun 2023 20:35:25 -0400
Message-Id: <3179a926bcc5e7fd138f9c1d6766b7412c3af5ec.1687988380.git.sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1687988380.git.sweettea-kernel@dorminy.me>
References: <cover.1687988380.git.sweettea-kernel@dorminy.me>
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

Right now there isn't a way to encrypt things that aren't either
filenames in directories or data on blocks on disk with extent
encryption, so for now, disable verity usage with encryption on btrfs.

Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
---
 fs/btrfs/verity.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/fs/btrfs/verity.c b/fs/btrfs/verity.c
index c5ff16f9e9fa..cda969c6cb0c 100644
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
2.40.1

