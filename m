Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 81B1B19B70F
	for <lists+linux-fscrypt@lfdr.de>; Wed,  1 Apr 2020 22:35:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733065AbgDAUe7 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 1 Apr 2020 16:34:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:54402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733008AbgDAUe4 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 1 Apr 2020 16:34:56 -0400
Received: from ebiggers-linuxstation.mtv.corp.google.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E3BA1208FE;
        Wed,  1 Apr 2020 20:34:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1585773296;
        bh=5e/Y+DpQuAnaUyh7Fynhd3HWaNOkr6/qj0jz1CifLP4=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=u6ei9k92ro9BSBgwA/aBAWTLPBkDZQOrDOUe+O/JUn7Ij35Qx/ZtCaDclMSQ6gwAL
         hplacUVQW29LYFuXOg4diN2AKRytaD2yf0teOXqEms7RP9U9F3rkV9PMNAjMcfUQH5
         /gX+fEaPOHfvueBVws2FLK3Zi2mObxKqCmAwkZEA=
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 1/4] tune2fs: prevent changing UUID of fs with stable_inodes feature
Date:   Wed,  1 Apr 2020 13:32:36 -0700
Message-Id: <20200401203239.163679-2-ebiggers@kernel.org>
X-Mailer: git-send-email 2.26.0.rc2.310.g2932bb562d-goog
In-Reply-To: <20200401203239.163679-1-ebiggers@kernel.org>
References: <20200401203239.163679-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

The stable_inodes feature is intended to indicate that it's safe to use
IV_INO_LBLK_64 encryption policies, where the encryption depends on the
inode numbers and thus filesystem shrinking is not allowed.  However
since inode numbers are not unique across filesystems, the encryption
also depends on the filesystem UUID, and I missed that there is a
supported way to change the filesystem UUID (tune2fs -U).

So, make 'tune2fs -U' report an error if stable_inodes is set.

We could add a separate stable_uuid feature flag, but it seems unlikely
it would be useful enough on its own to warrant another flag.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 misc/tune2fs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/misc/tune2fs.c b/misc/tune2fs.c
index 314cc0d0..ca06c98b 100644
--- a/misc/tune2fs.c
+++ b/misc/tune2fs.c
@@ -3236,6 +3236,13 @@ _("Warning: The journal is dirty. You may wish to replay the journal like:\n\n"
 		char buf[SUPERBLOCK_SIZE] __attribute__ ((aligned(8)));
 		__u8 old_uuid[UUID_SIZE];
 
+		if (ext2fs_has_feature_stable_inodes(fs->super)) {
+			fputs(_("Cannot change the UUID of this filesystem "
+				"because it has the stable_inodes feature "
+				"flag.\n"), stderr);
+			exit(1);
+		}
+
 		if (!ext2fs_has_feature_csum_seed(fs->super) &&
 		    (ext2fs_has_feature_metadata_csum(fs->super) ||
 		     ext2fs_has_feature_ea_inode(fs->super))) {
-- 
2.26.0.rc2.310.g2932bb562d-goog

