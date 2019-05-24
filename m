Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BF832926C
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 May 2019 10:07:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389412AbfEXIGi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 May 2019 04:06:38 -0400
Received: from smtp.codeaurora.org ([198.145.29.96]:45050 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389046AbfEXIGi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 May 2019 04:06:38 -0400
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id BC43F60E40; Fri, 24 May 2019 08:06:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558685196;
        bh=HFahEd1e9otwuYSiHy1qPYvBNA3cY2td10pq593gtdw=;
        h=From:To:Cc:Subject:Date:From;
        b=o0Dk7f3+hdz7aLAyaH+W2bwHvC2BB+Qo7wch7/PP9JDnDkcfeQL3QIBvBweFT/5Hw
         XS8fzRC1wLadBfl4wxjqJ5IZEcUs6TlNd1ZqDXwBc6gawFGgTgvx6XRoSSGAyTR9fy
         Sa6xsgNpqk6Jyk005JTE9Rkg7+Prbf5tR/gJmIIM=
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
        pdx-caf-mail.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.7 required=2.0 tests=ALL_TRUSTED,BAYES_00,
        DKIM_INVALID,DKIM_SIGNED,SPF_NONE autolearn=no autolearn_force=no
        version=3.4.0
Received: from codeaurora.org (blr-c-bdr-fw-01_globalnat_allzones-outside.qualcomm.com [103.229.19.19])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: stummala@smtp.codeaurora.org)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 3FC7C60716;
        Fri, 24 May 2019 08:06:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1558685195;
        bh=HFahEd1e9otwuYSiHy1qPYvBNA3cY2td10pq593gtdw=;
        h=From:To:Cc:Subject:Date:From;
        b=kE4NYJ/hbdpoJMFmQboUNCozSkfLhIstHc2jckprU6iCfY++FGxUi0PuBJuCb2yGb
         72EfNaAjfosSNFJm6llDdqSxPceH2w1ay4QaS73iKcXMWqbjCRmejXDuPzVug4udpX
         gB9LczQo46sRD5H9Llx+DAkvtItJUD1AnpKIzayM=
DMARC-Filter: OpenDMARC Filter v1.3.2 smtp.codeaurora.org 3FC7C60716
Authentication-Results: pdx-caf-mail.web.codeaurora.org; dmarc=none (p=none dis=none) header.from=codeaurora.org
Authentication-Results: pdx-caf-mail.web.codeaurora.org; spf=none smtp.mailfrom=stummala@codeaurora.org
From:   Sahitya Tummala <stummala@codeaurora.org>
To:     Andrew Morton <akpm@linux-foundation.org>,
        Kirill Tkhai <ktkhai@virtuozzo.com>,
        Michal Hocko <mhocko@suse.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Vladimir Davydov <vdavydov.dev@gmail.com>,
        Yafang Shao <laoar.shao@gmail.com>,
        Roman Gushchin <guro@fb.com>,
        Mel Gorman <mgorman@techsingularity.net>, linux-mm@kvack.org,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org
Cc:     linux-kernel@vger.kernel.org,
        Sahitya Tummala <stummala@codeaurora.org>
Subject: [PATCH] mm/vmscan.c: drop all inode/dentry cache from LRU
Date:   Fri, 24 May 2019 13:36:01 +0530
Message-Id: <1558685161-860-1-git-send-email-stummala@codeaurora.org>
X-Mailer: git-send-email 1.9.1
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This is important for the scenario where FBE (file based encryption)
is enabled. With FBE, the encryption context needed to en/decrypt a file
will be stored in inode and any inode that is left in the cache after
drop_caches is done will be a problem. For ex, in Android, drop_caches
will be used when switching work profiles.

Signed-off-by: Sahitya Tummala <stummala@codeaurora.org>
---
 mm/vmscan.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/vmscan.c b/mm/vmscan.c
index d96c547..b48926f 100644
--- a/mm/vmscan.c
+++ b/mm/vmscan.c
@@ -730,7 +730,7 @@ void drop_slab_node(int nid)
 		do {
 			freed += shrink_slab(GFP_KERNEL, nid, memcg, 0);
 		} while ((memcg = mem_cgroup_iter(NULL, memcg, NULL)) != NULL);
-	} while (freed > 10);
+	} while (freed != 0);
 }
 
 void drop_slab(void)
-- 
Qualcomm India Private Limited, on behalf of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, a Linux Foundation Collaborative Project.

