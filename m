Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BC1D555054D
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 16:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbiFRNxL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 09:53:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48178 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234164AbiFRNw6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:52:58 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C31BCE2E
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:52:55 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 1C98313E7;
        Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 19855DC803; Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        Cyril Bordage <cbordage@whamcloud.com>,
        Chris Horn <chris.horn@hpe.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 13/28] lnet: set max recovery interval duration
Date:   Sat, 18 Jun 2022 09:51:55 -0400
Message-Id: <1655560330-30743-14-git-send-email-jsimmons@infradead.org>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1655560330-30743-1-git-send-email-jsimmons@infradead.org>
References: <1655560330-30743-1-git-send-email-jsimmons@infradead.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Cyril Bordage <cbordage@whamcloud.com>

Add a tunable parameter to limit the recovery ping interval which was
previously statically set to 900.
This can be done by using:

lnetctl set max_recovery_ping_interval <value>

WC-bug-id: https://jira.whamcloud.com/browse/LU-14979
Lustre-commit: 4027395fe463b6ea1 ("LU-14979 lnet: set max recovery interval duration")
Signed-off-by: Cyril Bordage <cbordage@whamcloud.com>
Signed-off-by: Chris Horn <chris.horn@hpe.com>
Reviewed-on: https://review.whamcloud.com/44927
Reviewed-by: Serguei Smirnov <ssmirnov@whamcloud.com>
Reviewed-by: Frank Sehr <fsehr@whamcloud.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 include/linux/lnet/lib-lnet.h |  9 ++++----
 net/lnet/lnet/api-ni.c        | 49 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 54 insertions(+), 4 deletions(-)

diff --git a/include/linux/lnet/lib-lnet.h b/include/linux/lnet/lib-lnet.h
index ceb12b1..e21866b 100644
--- a/include/linux/lnet/lib-lnet.h
+++ b/include/linux/lnet/lib-lnet.h
@@ -559,6 +559,8 @@ unsigned int lnet_nid_cpt_hash(struct lnet_nid *nid,
 extern unsigned int lnet_recovery_limit;
 extern unsigned int lnet_peer_discovery_disabled;
 extern unsigned int lnet_drop_asym_route;
+extern unsigned int lnet_max_recovery_ping_interval;
+extern unsigned int lnet_max_recovery_ping_count;
 extern unsigned int router_sensitivity_percentage;
 extern int alive_router_check_interval;
 extern int live_router_check_interval;
@@ -1009,15 +1011,14 @@ int lnet_get_peer_ni_info(u32 peer_index, u64 *nid,
 	return false;
 }
 
-#define LNET_RECOVERY_INTERVAL_MAX 900
 static inline unsigned int
 lnet_get_next_recovery_ping(unsigned int ping_count, time64_t now)
 {
 	unsigned int interval;
 
-	/* 2^9 = 512, 2^10 = 1024 */
-	if (ping_count > 9)
-		interval = LNET_RECOVERY_INTERVAL_MAX;
+	/* lnet_max_recovery_interval <= 2^lnet_max_recovery_ping_count */
+	if (ping_count > lnet_max_recovery_ping_count)
+		interval = lnet_max_recovery_ping_interval;
 	else
 		interval = 1 << ping_count;
 
diff --git a/net/lnet/lnet/api-ni.c b/net/lnet/lnet/api-ni.c
index 8643ac8d..165728d 100644
--- a/net/lnet/lnet/api-ni.c
+++ b/net/lnet/lnet/api-ni.c
@@ -117,6 +117,22 @@ static int recovery_interval_set(const char *val,
 MODULE_PARM_DESC(lnet_recovery_limit,
 		 "How long to attempt recovery of unhealthy peer interfaces in seconds. Set to 0 to allow indefinite recovery");
 
+unsigned int lnet_max_recovery_ping_interval = 900;
+unsigned int lnet_max_recovery_ping_count = 9;
+static int max_recovery_ping_interval_set(const char *val,
+					  const struct kernel_param *kp);
+
+#define param_check_max_recovery_ping_interval(name, p) \
+		__param_check(name, p, int)
+
+static struct kernel_param_ops param_ops_max_recovery_ping_interval = {
+	.set = max_recovery_ping_interval_set,
+	.get = param_get_int,
+};
+module_param(lnet_max_recovery_ping_interval, max_recovery_ping_interval, 0644);
+MODULE_PARM_DESC(lnet_max_recovery_ping_interval,
+		 "The max interval between LNet recovery pings, in seconds");
+
 static int lnet_interfaces_max = LNET_INTERFACES_MAX_DEFAULT;
 static int intf_max_set(const char *val, const struct kernel_param *kp);
 module_param_call(lnet_interfaces_max, intf_max_set, param_get_int,
@@ -258,6 +274,39 @@ static int lnet_discover(struct lnet_process_id id, u32 force,
 }
 
 static int
+max_recovery_ping_interval_set(const char *val, const struct kernel_param *kp)
+{
+	int rc;
+	unsigned long value;
+
+	rc = kstrtoul(val, 0, &value);
+	if (rc) {
+		CERROR("Invalid module parameter value for 'lnet_max_recovery_ping_interval'\n");
+		return rc;
+	}
+
+	if (!value) {
+		CERROR("Invalid max ping timeout. Must be strictly positive\n");
+		return -EINVAL;
+	}
+
+	/* The purpose of locking the api_mutex here is to ensure that
+	 * the correct value ends up stored properly.
+	 */
+	mutex_lock(&the_lnet.ln_api_mutex);
+	lnet_max_recovery_ping_interval = value;
+	lnet_max_recovery_ping_count = 0;
+	value >>= 1;
+	while (value) {
+		lnet_max_recovery_ping_count++;
+		value >>= 1;
+	}
+	mutex_unlock(&the_lnet.ln_api_mutex);
+
+	return 0;
+}
+
+static int
 discovery_set(const char *val, const struct kernel_param *kp)
 {
 	int rc;
-- 
1.8.3.1

