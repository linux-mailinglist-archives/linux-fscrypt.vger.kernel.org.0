Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23630649306
	for <lists+linux-fscrypt@lfdr.de>; Sun, 11 Dec 2022 08:08:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiLKHIB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Dec 2022 02:08:01 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42604 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230139AbiLKHHy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Dec 2022 02:07:54 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 603C0BE3A;
        Sat, 10 Dec 2022 23:07:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9249B808C8;
        Sun, 11 Dec 2022 07:07:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 75D03C433F2;
        Sun, 11 Dec 2022 07:07:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670742465;
        bh=gahW09+3l+fw+3uIQS4lcxLRkJ6BbxZYWnSjC+cmIws=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=AKT/gC7rOkzWf7slo3ggRc/4BooZ3kn+hc8OdW6DYOrUz7uegHmAos8ZUhXmppUUc
         mKNaTsdoaqPP2nUNG9hmVSIxJtoPqRwZ47QpwCqCWx3QlPqmFiIr4cgA6FoGHvSmav
         40eGARbix0mLBEc0Ntf+XiXNOEZPml+9eeeqw5pmtkjGHxuiq6URb+OEAy3SGG6nus
         3Sbf2X5sWWcxr2F7pSH0SKCpJLm6CRxnh3bAGjER3rVr53JpnDFjK3qYiISouYGAyB
         9IAdVHUUUER/HChUb6wd5DtnKROZnDL5cu7kv2PwFtv0AD87/tXRE3bDrSKHdfi4Qt
         UajUm59h0qA+w==
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org
Subject: [PATCH 04/10] common/verity: add _filter_fsverity_digest()
Date:   Sat, 10 Dec 2022 23:06:57 -0800
Message-Id: <20221211070704.341481-5-ebiggers@kernel.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221211070704.341481-1-ebiggers@kernel.org>
References: <20221211070704.341481-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Eric Biggers <ebiggers@google.com>

Add a filter that replaces fs-verity digests with a fixed string.  This
is needed because the fs-verity digests that some tests print are going
to start depending on the default Merkle tree block size.

Signed-off-by: Eric Biggers <ebiggers@google.com>
---
 common/verity | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/common/verity b/common/verity
index 1c706b80..b88e839b 100644
--- a/common/verity
+++ b/common/verity
@@ -406,3 +406,11 @@ _require_fsverity_max_file_size_limit()
 		;;
 	esac
 }
+
+# Replace fs-verity digests, as formatted by the 'fsverity' tool, with <digest>.
+# This function can be used by tests where fs-verity digests depend on the
+# default Merkle tree block size (FSV_BLOCK_SIZE).
+_filter_fsverity_digest()
+{
+	sed -E 's/\b(sha(256|512)):[a-f0-9]{64,}\b/\1:<digest>/'
+}
-- 
2.38.1

