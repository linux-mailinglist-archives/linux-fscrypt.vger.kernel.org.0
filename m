Return-Path: <linux-fscrypt+bounces-146-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 43ACB842FF3
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jan 2024 23:38:35 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6F4021C2417F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Jan 2024 22:38:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 406FD146910;
	Tue, 30 Jan 2024 22:37:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="Kc98gZRW"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6D68512DDB1;
	Tue, 30 Jan 2024 22:37:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706654249; cv=none; b=SxG0e9zeN1UompBzQkz1uH92FfU5ryD8IxeAQGNeQZfxJiyC7ayuFxc8J3AfsU6vzqTeom/K1HHOWTryyHr8cphpZfy/roD+qvf2f9udpdtlKQcHZyueeaHKMLz/uiC2E5huxW+VB27zMBCOg9FZkcfCH+1lAt4qldmV8lkD9po=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706654249; c=relaxed/simple;
	bh=eLIcp+RfhTmSVlQgiky/TjFgWoyQ2RKCvw2xGagb5Mg=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References; b=bYXuI5sleb02bVb2dWLDECmt17P/66g3SjN+d0WkkrBezPnU5zUlxPSGe5E1ADXA1Hok85wnt7CAhU07SwC/CrCoQT2B1WlFcQGRd9eMS8mXCSUBzrlqEcvzhNTbkSOH3+fuVk8+i5GcBc5bE4fthrSNc/92ul/Zotg0Stifr0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=Kc98gZRW; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: by linux.microsoft.com (Postfix, from userid 1052)
	id A7F7C20B2000; Tue, 30 Jan 2024 14:37:22 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com A7F7C20B2000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1706654242;
	bh=PtmOIQ7QWnbnzGtRuZgd0CdiM9rCu5SOwNE3ANWLE5o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kc98gZRW0srsHTjaCzahcz71kDwclORU59tvva+3PQN+3ieolBmu31ER45H4z7Gsv
	 uvg41k26PMjO6ACwXpa3u+3Jmjxk5FpNF7kKgCWodzlo3SCmQqk4SLR4WvTaWXE9Zk
	 yCpBWElQg0pXCzDZmecTWqjyr+3Vs/S4wlvIXHQE=
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
Subject: [RFC PATCH v12 13/20] dm: add finalize hook to target_type
Date: Tue, 30 Jan 2024 14:37:01 -0800
Message-Id: <1706654228-17180-14-git-send-email-wufan@linux.microsoft.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
References: <1706654228-17180-1-git-send-email-wufan@linux.microsoft.com>
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
2.43.0


