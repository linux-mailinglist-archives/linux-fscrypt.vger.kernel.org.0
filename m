Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89FD57B9761
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 Oct 2023 00:20:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239398AbjJDWKo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 4 Oct 2023 18:10:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233563AbjJDWJ5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 4 Oct 2023 18:09:57 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 811D3E4;
        Wed,  4 Oct 2023 15:09:54 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id D315F20B74D8; Wed,  4 Oct 2023 15:09:50 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D315F20B74D8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1696457390;
        bh=eJS+kBKHSIzGbwwv49yX5DCUKZVKLPE/A7wfEDIcA9E=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=kivRmiQvs0LNuyzLsMCEEVEdqNtf6L5xl16co++lbJNojj2N7CnDAjy+8HfjVqa3s
         DI8XBOrh8ocu5/dAKmmJnSU0tv9SUOOLCgLQQKevgS84tyQYx8ciXVaHBv2Q7ijzXh
         hX5dxUtiY48KK7vGUG+7aj/jEn3ihq7B4AgdN2lw=
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
Subject: [RFC PATCH v11 12/19] dm: add finalize hook to target_type
Date:   Wed,  4 Oct 2023 15:09:39 -0700
Message-Id: <1696457386-3010-13-git-send-email-wufan@linux.microsoft.com>
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

This patch adds a target finalize hook.

The hook is triggered just before activating an inactive table of a
mapped device. If it returns an error the __bind get cancelled.

The dm-verity target will use this hook to attach the dm-verity's
roothash metadata to the block_device struct of the mapped device.

Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v1-v10:
  + Not present
---
 drivers/md/dm.c               | 12 ++++++++++++
 include/linux/device-mapper.h |  7 +++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 64a1f306c96c..3be9cc35306d 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2239,6 +2239,18 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
 		goto out;
 	}
 
+	for (unsigned int i = 0; i < t->num_targets; i++) {
+		struct dm_target *ti = dm_table_get_target(t, i);
+
+		if (ti->type->finalize) {
+			ret = ti->type->finalize(ti);
+			if (ret) {
+				old_map = ERR_PTR(ret);
+				goto out;
+			}
+		}
+	}
+
 	old_map = rcu_dereference_protected(md->map, lockdep_is_held(&md->suspend_lock));
 	rcu_assign_pointer(md->map, (void *)t);
 	md->immutable_target_type = dm_table_get_immutable_target_type(t);
diff --git a/include/linux/device-mapper.h b/include/linux/device-mapper.h
index 69d0435c7ebb..4040e84a8ec7 100644
--- a/include/linux/device-mapper.h
+++ b/include/linux/device-mapper.h
@@ -160,6 +160,12 @@ typedef int (*dm_dax_zero_page_range_fn)(struct dm_target *ti, pgoff_t pgoff,
  */
 typedef size_t (*dm_dax_recovery_write_fn)(struct dm_target *ti, pgoff_t pgoff,
 		void *addr, size_t bytes, struct iov_iter *i);
+/*
+ * Returns:
+ *  < 0 : error
+ *  = 0 : success
+ */
+typedef int (*dm_finalize_fn) (struct dm_target *target);
 
 void dm_error(const char *message);
 
@@ -209,6 +215,7 @@ struct target_type {
 	dm_dax_direct_access_fn direct_access;
 	dm_dax_zero_page_range_fn dax_zero_page_range;
 	dm_dax_recovery_write_fn dax_recovery_write;
+	dm_finalize_fn finalize;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
-- 
2.25.1

