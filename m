Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5E5E550536
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 15:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230356AbiFRNw6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 09:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233293AbiFRNwu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:52:50 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 755E1206
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:52:40 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 1327713D8;
        Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 0C78FE9152; Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        Serguei Smirnov <ssmirnov@whamcloud.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 10/28] lnet: o2iblnd: clean up zombie connections on shutdown
Date:   Sat, 18 Jun 2022 09:51:52 -0400
Message-Id: <1655560330-30743-11-git-send-email-jsimmons@infradead.org>
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

From: Serguei Smirnov <ssmirnov@whamcloud.com>

Clean up zombie connections on net shutdown in o2iblnd
Wake up connd threads and wait for them to do the clean-up
before proceeding.

WC-bug-id: https://jira.whamcloud.com/browse/LU-14503
Lustre-commit: 2a183829cdcc7008f ("LU-14503 o2iblnd: clean up zombie connections on shutdown")
Signed-off-by: Serguei Smirnov <ssmirnov@whamcloud.com>
Reviewed-on: https://review.whamcloud.com/42068
Reviewed-by: Cyril Bordage <cbordage@whamcloud.com>
Reviewed-by: Chris Horn <chris.horn@hpe.com>
Reviewed-by: Alexey Lyashkov <alexey.lyashkov@hpe.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 net/lnet/klnds/o2iblnd/o2iblnd.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/net/lnet/klnds/o2iblnd/o2iblnd.c b/net/lnet/klnds/o2iblnd/o2iblnd.c
index 8dce4179..65bc89b 100644
--- a/net/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/net/lnet/klnds/o2iblnd/o2iblnd.c
@@ -2609,6 +2609,12 @@ static void kiblnd_shutdown(struct lnet_ni *ni)
 		list_del(&net->ibn_list);
 		write_unlock_irqrestore(g_lock, flags);
 
+		wake_up_all(&kiblnd_data.kib_connd_waitq);
+		wait_var_event_warning(&net->ibn_nconns,
+				       atomic_read(&net->ibn_nconns) == 0,
+				       "%s: waiting for %d conns to clean\n",
+				       libcfs_nidstr(&ni->ni_nid),
+				       atomic_read(&net->ibn_nconns));
 		/* fall through */
 
 	case IBLND_INIT_NOTHING:
-- 
1.8.3.1

