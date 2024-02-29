Return-Path: <linux-fscrypt+bounces-197-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E0C8C86BD4D
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Feb 2024 01:57:01 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 5D1D0B2624D
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Feb 2024 00:56:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A97A83BB48;
	Thu, 29 Feb 2024 00:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="FbpDpkpo"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9104F364BF;
	Thu, 29 Feb 2024 00:55:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709168127; cv=none; b=c/Qf/8Wlh4qc/xEk7OLcLBr1O77bohpSBIjjO7EondGfJu4lIOgDvJDlCWoRx8G35aRSYR63XVO+Yupi8HxfYEzjm/WEfPr4Xbi2X2RttJDFvjZK6bKScw11JoW3vvj752GRWR/U3T49QZcvveWSoF4LCrWr00lXTLxVaq6k9uc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709168127; c=relaxed/simple;
	bh=LGzD4DUlk5m+6PqDuOP70cYPyfFeTyVT9sEJQWfpMgk=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=pVJSDDzpQ7uEM3X9C7XgjKkfrau06xbWgq3YvrbiyogaVfkEtxTsnaKJzYMuDTldG9FR4cUayRkDvnyWGQOx6G/GiGDxQ1exEjgIx6ct4sFNeXlTVpQZk5SLsss0fxquPPERacfAE2ww8WFFg77Ey/hvUZNfQlfk88vbo80p6uU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=FbpDpkpo; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id 23B7120B74D9; Wed, 28 Feb 2024 16:55:18 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 23B7120B74D9
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1709168119;
	bh=YwptEEL5y7/tJ0FsiRUIXARo6KLdEYznOkxZQ8U/PTU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FbpDpkpo1MPGUITN9TGJl7T/8cAIj5J54faNJqgEg6GyP8r7yCsqOTZzIluiBx4jM
	 qWmjSU6D9grE799L0/ca8ayEAFivDJXvNb+1xhpPH3YJcK5fbapbhlqpEzRDaI0u53
	 3jiNlAhs7dE/PZJ28FyR9u7t/c6YKEftfH80gwok=
From: Fan Wu <wufan@linux.microsoft.com>
To: corbet@lwn.net,
	zohar@linux.ibm.com,
	jmorris@namei.org,
	serge@hallyn.com,
	tytso@mit.edu,
	ebiggers@kernel.org,
	axboe@kernel.dk,
	agk@redhat.com,
	snitzer@kernel.org,
	eparis@redhat.com,
	paul@paul-moore.com
Cc: linux-doc@vger.kernel.org,
	linux-integrity@vger.kernel.org,
	linux-security-module@vger.kernel.org,
	linux-fscrypt@vger.kernel.org,
	linux-block@vger.kernel.org,
	dm-devel@lists.linux.dev,
	audit@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	Fan Wu <wufan@linux.microsoft.com>
Subject: [RFC PATCH v13 13/20] dm: add finalize hook to target_type
Date: Wed, 28 Feb 2024 16:54:55 -0800
Message-Id: <1709168102-7677-14-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1709168102-7677-1-git-send-email-wufan@linux.microsoft.com>
References: <1709168102-7677-1-git-send-email-wufan@linux.microsoft.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>

This patch adds a target finalize hook.

The hook is triggered just before activating an inactive table of a
mapped device. If it returns an error the __bind get cancelled.

The dm-verity target will use this hook to attach the dm-verity's
roothash metadata to the block_device struct of the mapped device.

Signed-off-by: Fan Wu <wufan@linux.microsoft.com>

---
v1-v10:
  + Not present

v11:
  + Introduced

v12:
  + No changes

v13:
  + No changes
---
 drivers/md/dm.c               | 12 ++++++++++++
 include/linux/device-mapper.h |  7 +++++++
 2 files changed, 19 insertions(+)

diff --git a/drivers/md/dm.c b/drivers/md/dm.c
index 8dcabf84d866..15b46edae49f 100644
--- a/drivers/md/dm.c
+++ b/drivers/md/dm.c
@@ -2266,6 +2266,18 @@ static struct dm_table *__bind(struct mapped_device *md, struct dm_table *t,
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
index 772ab4d74d94..627400b2d9af 100644
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
 
@@ -210,6 +216,7 @@ struct target_type {
 	dm_dax_direct_access_fn direct_access;
 	dm_dax_zero_page_range_fn dax_zero_page_range;
 	dm_dax_recovery_write_fn dax_recovery_write;
+	dm_finalize_fn finalize;
 
 	/* For internal device-mapper use. */
 	struct list_head list;
-- 
2.43.1


