Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 103EA550559
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 16:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350560AbiFROAx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 10:00:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235656AbiFRNxW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:53:22 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AFE89DEA6
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:53:21 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 4AA8D13FF;
        Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 47A00FD3BF; Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org, Chris Horn <chris.horn@hpe.com>,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 24/28] lnet: DLC sets map_on_demand incorrectly
Date:   Sat, 18 Jun 2022 09:52:06 -0400
Message-Id: <1655560330-30743-25-git-send-email-jsimmons@infradead.org>
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

From: Chris Horn <chris.horn@hpe.com>

When any NET or LND tunable is specified via CLI or yaml, then the
whole tunables struct gets memset to 0, or in the case of yaml config,
0 gets assigned to any tunable that isn't specified in the yaml. This
causes a problem for map_on_demand because 0 is a valid value for that
parameter, and ko2iblnd cannot know whether the user specified that 0
should be used or if DLC is specifying that the parameter was unset.

Rather than setting this parameter to 0 in the LND tunables struct,
have DLC set it to UINT_MAX to indicate that ko2iblnd should use the
value of the kernel module parameter.

HPE-bug-id: LUS-10740
WC-bug-id: https://jira.whamcloud.com/browse/LU-15538
Lustre-commit: 896f4a082b93453f5 ("LU-15538 lnet: DLC sets map_on_demand incorrectly")
Signed-off-by: Chris Horn <chris.horn@hpe.com>
Reviewed-on: https://review.whamcloud.com/46492
Reviewed-by: James Simmons <jsimmons@infradead.org>
Reviewed-by: Serguei Smirnov <ssmirnov@whamcloud.com>
Reviewed-by: Cyril Bordage <cbordage@whamcloud.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 net/lnet/klnds/o2iblnd/o2iblnd_modparams.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/lnet/klnds/o2iblnd/o2iblnd_modparams.c b/net/lnet/klnds/o2iblnd/o2iblnd_modparams.c
index 022ed02..04286e1 100644
--- a/net/lnet/klnds/o2iblnd/o2iblnd_modparams.c
+++ b/net/lnet/klnds/o2iblnd/o2iblnd_modparams.c
@@ -261,6 +261,9 @@ int kiblnd_tunables_setup(struct lnet_ni *ni)
 		net_tunables->lct_peer_tx_credits =
 			net_tunables->lct_max_tx_credits;
 
+	if (tunables->lnd_map_on_demand == UINT_MAX)
+		tunables->lnd_map_on_demand = map_on_demand;
+
 	/*
 	 * For kernels which do not support global memory regions, always
 	 * enable map_on_demand
-- 
1.8.3.1

