Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6CEC7B9771
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 Oct 2023 00:21:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237177AbjJDWKN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Oct 2023 18:10:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233516AbjJDWJ5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Oct 2023 18:09:57 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 80E98DC;
        Wed,  4 Oct 2023 15:09:54 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id C517A20B74D6; Wed,  4 Oct 2023 15:09:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com C517A20B74D6
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1696457390;
        bh=cW99n8OXkptGYBwo2lvuMipxJldHT9R48ujQFfMBHAE=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=HlbE3xQQD91xPZObjg/CgUE2QU0zJNs+fz69nDWpG2Pro/oeWXN/aaXplO/MMdwnC
         flp9VyW+sc5xtgwh7Sv8472Td4ThXyh32Q2LzLtm/FCK7mFyD2as88RP80K0dMVIxo
         bet1LExMUHKfFUO1fcNWYtbZGl7LrIidZ5H9/AcQ=
From:   Fan Wu <wufan@linux.microsoft.com>
To:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
        axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org,
        eparis@redhat.com, paul@paul-moore.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Fan Wu <wufan@linux.microsoft.com>
Subject: [RFC PATCH v11 11/19] dm verity: set DM_TARGET_SINGLETON feature flag
Date:   Wed,  4 Oct 2023 15:09:38 -0700
Message-Id: <1696457386-3010-12-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1696457386-3010-1-git-send-email-wufan@linux.microsoft.com>
References: <1696457386-3010-1-git-send-email-wufan@linux.microsoft.com>
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,SPF_HELO_PASS,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

The device-mapper has a flag to mark targets as singleton, which is a
required flag for immutable targets. Without this flag, multiple
dm-verity targets can be added to a mapped device, which has no
practical use cases and will let dm_table_get_immutable_target return
NULL. This patch adds the missing flag, restricting only one
dm-verity target per mapped device.

Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v1-v10:
  + Not present
---
 drivers/md/dm-verity-target.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/md/dm-verity-target.c b/drivers/md/dm-verity-target.c
index 26adcfea0302..80673b66c194 100644
--- a/drivers/md/dm-verity-target.c
+++ b/drivers/md/dm-verity-target.c
@@ -1503,7 +1503,7 @@ int dm_verity_get_root_digest(struct dm_target *ti, u8 **root_digest, unsigned i
 
 static struct target_type verity_target = {
 	.name		= "verity",
-	.features	= DM_TARGET_IMMUTABLE,
+	.features	= DM_TARGET_SINGLETON | DM_TARGET_IMMUTABLE,
 	.version	= {1, 9, 0},
 	.module		= THIS_MODULE,
 	.ctr		= verity_ctr,
-- 
2.25.1

