Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C7A550532
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 15:52:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234073AbiFRNwl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 09:52:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233887AbiFRNwb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:52:31 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0E481DA48
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:52:30 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 080FA13D5;
        Sat, 18 Jun 2022 09:52:14 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id EC7551002D3; Sat, 18 Jun 2022 09:52:13 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 05/28] lnet: improve compat code for IPV6_V6ONLY sock opt
Date:   Sat, 18 Jun 2022 09:51:47 -0400
Message-Id: <1655560330-30743-6-git-send-email-jsimmons@infradead.org>
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

From: Mr NeilBrown <neilb@suse.de>

Since linux 5.9 (v5.8-rc4-1952-ga7b75c5a8c41) it has been
possible to pass a "sockptr" to ->setsockopt() which can provide
a kernel address.

WC-bug-id: https://jira.whamcloud.com/browse/LU-14195
Lustre-commit: 6d111ff0dde182bfb ("LU-14195 lnet: improve compat code for IPV6_V6ONLY sock opt")
Signed-off-by: Mr NeilBrown <neilb@suse.de>
Reviewed-on: https://review.whamcloud.com/43559
Reviewed-by: James Simmons <jsimmons@infradead.org>
Reviewed-by: Arshad Hussain <arshad.hussain@aeoncomputing.com>
Reviewed-by: Chris Horn <chris.horn@hpe.com>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 net/lnet/lnet/lib-socket.c | 16 +++++-----------
 1 file changed, 5 insertions(+), 11 deletions(-)

diff --git a/net/lnet/lnet/lib-socket.c b/net/lnet/lnet/lib-socket.c
index 7bb8d5c..3a99cb6 100644
--- a/net/lnet/lnet/lib-socket.c
+++ b/net/lnet/lnet/lib-socket.c
@@ -237,18 +237,12 @@ int choose_ipv4_src(u32 *ret, int interface, u32 dst_ipaddr, struct net *ns)
 			 * This is the default, but it can be overridden so we
 			 * force it back.
 			 */
-			/* From v5.7-rc6-2614-g5a892ff2facb when
-			 * kernel_setsockopt() was removed until
-			 * sockptr_t (above) there is no clean way to
-			 * pass kernel address to setsockopt.  We could
-			 * use get_fs()/set_fs(), but in this particular
-			 * situation there is an easier way.  It depends
-			 * on the fact that at least for these few
-			 * kernels a NULL address to ipv6_setsockopt()
-			 * is treated like the address of a zero.
+			/* sockptr_t was introduced around
+			 * v5.8-rc4-1952-ga7b75c5a8c41 and allows a
+			 * kernel address to be passed to ->setsockopt
 			 */
-			if (ipv6_only_sock(sock->sk) && !val) {
-				void *optval = NULL;
+			if (ipv6_only_sock(sock->sk)) {
+				sockptr_t optval = KERNEL_SOCKPTR(&val);
 
 				sock->ops->setsockopt(sock,
 						      IPPROTO_IPV6, IPV6_V6ONLY,
-- 
1.8.3.1

