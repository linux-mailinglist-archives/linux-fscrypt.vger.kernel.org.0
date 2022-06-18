Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B123555052E
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 15:52:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233932AbiFRNwj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 09:52:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232528AbiFRNwV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:52:21 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7EC1D328
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:52:19 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id ED05213C4;
        Sat, 18 Jun 2022 09:52:13 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id E3D7CFD3BF; Sat, 18 Jun 2022 09:52:13 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 03/28] lnet: support removal of kernel_setsockopt()
Date:   Sat, 18 Jun 2022 09:51:45 -0400
Message-Id: <1655560330-30743-4-git-send-email-jsimmons@infradead.org>
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

Linux 5.8 removes kernel_setsockopt() and kernel_getsockopt(), and
provides some helper functions for some accesses that are
not trivial.

This patch adds those helpers to libcfs when they are not available,
and changes (nearly) all calls to kernel_[gs]etsockopt() to
either use direct access to a helper call.

->keepalive() is not available before v4.11-rc1~94^2~43^2~14
and there is no helper function, so for SO_KEEPALIVE we
need to have #ifdef code in the C file.

TCP_BACKOFF* setting are not converted as they are not available in
any upstream kernel, so no conversion is possible.

Also include some minor style fixes and change lnet_sock_setbuf() and
 lnet_sock_getbuf() to be 'void' functions.

WC-bug-id: https://jira.whamcloud.com/browse/LU-13783
Lustre-commit: 99d9638d6c074b48 ("LU-13783 libcfs: support removal of kernel_setsockopt()")
Signed-off-by: Mr NeilBrown <neilb@suse.de>
Reviewed-on: https://review.whamcloud.com/39259
Reviewed-by: Aurelien Degremont <degremoa@amazon.com>
Reviewed-by: Chris Horn <chris.horn@hpe.com>
Reviewed-by: James Simmons <jsimmons@infradead.org>
Reviewed-by: Oleg Drokin <green@whamcloud.com>
Signed-off-by: James Simmons <jsimmons@infradead.org>
---
 include/linux/lnet/lib-lnet.h        |   4 +-
 net/lnet/klnds/socklnd/socklnd_lib.c | 123 ++++++++++-------------------------
 net/lnet/lnet/lib-socket.c           |  41 +++---------
 3 files changed, 47 insertions(+), 121 deletions(-)

diff --git a/include/linux/lnet/lib-lnet.h b/include/linux/lnet/lib-lnet.h
index ca2a565..ceb12b1 100644
--- a/include/linux/lnet/lib-lnet.h
+++ b/include/linux/lnet/lib-lnet.h
@@ -827,8 +827,8 @@ struct lnet_inetdev {
 };
 
 int lnet_inet_enumerate(struct lnet_inetdev **dev_list, struct net *ns);
-int lnet_sock_setbuf(struct socket *socket, int txbufsize, int rxbufsize);
-int lnet_sock_getbuf(struct socket *socket, int *txbufsize, int *rxbufsize);
+void lnet_sock_setbuf(struct socket *socket, int txbufsize, int rxbufsize);
+void lnet_sock_getbuf(struct socket *socket, int *txbufsize, int *rxbufsize);
 int lnet_sock_getaddr(struct socket *socket, bool remote,
 		      struct sockaddr_storage *peer);
 int lnet_sock_write(struct socket *sock, void *buffer, int nob, int timeout);
diff --git a/net/lnet/klnds/socklnd/socklnd_lib.c b/net/lnet/klnds/socklnd/socklnd_lib.c
index 78e58f6..047e7a6 100644
--- a/net/lnet/klnds/socklnd/socklnd_lib.c
+++ b/net/lnet/klnds/socklnd/socklnd_lib.c
@@ -147,17 +147,13 @@
 void
 ksocknal_lib_eager_ack(struct ksock_conn *conn)
 {
-	int opt = 1;
 	struct socket *sock = conn->ksnc_sock;
 
-	/*
-	 * Remind the socket to ACK eagerly.  If I don't, the socket might
-	 * think I'm about to send something it could piggy-back the ACK
-	 * on, introducing delay in completing zero-copy sends in my
-	 * peer_ni.
+	/* Remind the socket to ACK eagerly.  If I don't, the socket might
+	 * think I'm about to send something it could piggy-back the ACK on,
+	 * introducing delay in completing zero-copy sends in my peer_ni.
 	 */
-	kernel_setsockopt(sock, SOL_TCP, TCP_QUICKACK, (char *)&opt,
-			  sizeof(opt));
+	tcp_sock_set_quickack(sock->sk, 1);
 }
 
 static int lustre_csum(struct kvec *v, void *context)
@@ -235,87 +231,47 @@ static int lustre_csum(struct kvec *v, void *context)
 			       int *rxmem, int *nagle)
 {
 	struct socket *sock = conn->ksnc_sock;
-	int len;
-	int rc;
+	struct tcp_sock *tp = tcp_sk(sock->sk);
 
-	rc = ksocknal_connsock_addref(conn);
-	if (rc) {
+	if (ksocknal_connsock_addref(conn) < 0) {
 		LASSERT(conn->ksnc_closing);
-		*txmem = *rxmem = *nagle = 0;
+		*txmem = 0;
+		*rxmem = 0;
+		*nagle = 0;
 		return -ESHUTDOWN;
 	}
 
-	rc = lnet_sock_getbuf(sock, txmem, rxmem);
-	if (!rc) {
-		len = sizeof(*nagle);
-		rc = kernel_getsockopt(sock, SOL_TCP, TCP_NODELAY,
-				       (char *)nagle, &len);
-	}
+	lnet_sock_getbuf(sock, txmem, rxmem);
 
-	ksocknal_connsock_decref(conn);
+	*nagle = !(tp->nonagle & TCP_NAGLE_OFF);
 
-	if (!rc)
-		*nagle = !*nagle;
-	else
-		*txmem = *rxmem = *nagle = 0;
+	ksocknal_connsock_decref(conn);
 
-	return rc;
+	return 0;
 }
 
 int
 ksocknal_lib_setup_sock(struct socket *sock)
 {
 	int rc;
-	int option;
 	int keep_idle;
 	int keep_intvl;
 	int keep_count;
 	int do_keepalive;
-	struct linger linger;
+	struct tcp_sock *tp = tcp_sk(sock->sk);
 
 	sock->sk->sk_allocation = GFP_NOFS;
 
-	/*
-	 * Ensure this socket aborts active sends immediately when we close
-	 * it.
-	 */
-	linger.l_onoff = 0;
-	linger.l_linger = 0;
-
-	rc = kernel_setsockopt(sock, SOL_SOCKET, SO_LINGER, (char *)&linger,
-			       sizeof(linger));
-	if (rc) {
-		CERROR("Can't set SO_LINGER: %d\n", rc);
-		return rc;
-	}
-
-	option = -1;
-	rc = kernel_setsockopt(sock, SOL_TCP, TCP_LINGER2, (char *)&option,
-			       sizeof(option));
-	if (rc) {
-		CERROR("Can't set SO_LINGER2: %d\n", rc);
-		return rc;
-	}
-
-	if (!*ksocknal_tunables.ksnd_nagle) {
-		option = 1;
+	/* Ensure this socket aborts active sends immediately when closed. */
+	sock_reset_flag(sock->sk, SOCK_LINGER);
 
-		rc = kernel_setsockopt(sock, SOL_TCP, TCP_NODELAY,
-				       (char *)&option, sizeof(option));
-		if (rc) {
-			CERROR("Can't disable nagle: %d\n", rc);
-			return rc;
-		}
-	}
+	tp->linger2 = -1;
+	if (!*ksocknal_tunables.ksnd_nagle)
+		tcp_sock_set_nodelay(sock->sk);
 
-	rc = lnet_sock_setbuf(sock, *ksocknal_tunables.ksnd_tx_buffer_size,
-			      *ksocknal_tunables.ksnd_rx_buffer_size);
-	if (rc) {
-		CERROR("Can't set buffer tx %d, rx %d buffers: %d\n",
-		       *ksocknal_tunables.ksnd_tx_buffer_size,
-		       *ksocknal_tunables.ksnd_rx_buffer_size, rc);
-		return rc;
-	}
+	lnet_sock_setbuf(sock,
+			 *ksocknal_tunables.ksnd_tx_buffer_size,
+			 *ksocknal_tunables.ksnd_rx_buffer_size);
 
 	/* TCP_BACKOFF_* sockopt tunables unsupported in stock kernels */
 
@@ -326,34 +282,30 @@ static int lustre_csum(struct kvec *v, void *context)
 
 	do_keepalive = (keep_idle > 0 && keep_count > 0 && keep_intvl > 0);
 
-	option = (do_keepalive ? 1 : 0);
-	rc = kernel_setsockopt(sock, SOL_SOCKET, SO_KEEPALIVE, (char *)&option,
-			       sizeof(option));
-	if (rc) {
-		CERROR("Can't set SO_KEEPALIVE: %d\n", rc);
-		return rc;
-	}
+	if (sock->sk->sk_prot->keepalive)
+		sock->sk->sk_prot->keepalive(sock->sk, do_keepalive);
+	if (do_keepalive)
+		sock_set_flag(sock->sk, SOCK_KEEPOPEN);
+	else
+		sock_reset_flag(sock->sk, SOCK_KEEPOPEN);
 
 	if (!do_keepalive)
 		return 0;
 
-	rc = kernel_setsockopt(sock, SOL_TCP, TCP_KEEPIDLE, (char *)&keep_idle,
-			       sizeof(keep_idle));
-	if (rc) {
+	rc = tcp_sock_set_keepidle(sock->sk, keep_idle);
+	if (rc != 0) {
 		CERROR("Can't set TCP_KEEPIDLE: %d\n", rc);
 		return rc;
 	}
 
-	rc = kernel_setsockopt(sock, SOL_TCP, TCP_KEEPINTVL,
-			       (char *)&keep_intvl, sizeof(keep_intvl));
-	if (rc) {
+	rc = tcp_sock_set_keepintvl(sock->sk, keep_intvl);
+	if (rc != 0) {
 		CERROR("Can't set TCP_KEEPINTVL: %d\n", rc);
 		return rc;
 	}
 
-	rc = kernel_setsockopt(sock, SOL_TCP, TCP_KEEPCNT, (char *)&keep_count,
-			       sizeof(keep_count));
-	if (rc) {
+	rc = tcp_sock_set_keepcnt(sock->sk, keep_count);
+	if (rc != 0) {
 		CERROR("Can't set TCP_KEEPCNT: %d\n", rc);
 		return rc;
 	}
@@ -367,7 +319,6 @@ static int lustre_csum(struct kvec *v, void *context)
 	struct sock *sk;
 	struct tcp_sock *tp;
 	int nonagle;
-	int val = 1;
 	int rc;
 
 	rc = ksocknal_connsock_addref(conn);
@@ -379,12 +330,10 @@ static int lustre_csum(struct kvec *v, void *context)
 
 	lock_sock(sk);
 	nonagle = tp->nonagle;
-	tp->nonagle = 1;
+	tp->nonagle = TCP_NAGLE_OFF;
 	release_sock(sk);
 
-	rc = kernel_setsockopt(conn->ksnc_sock, SOL_TCP, TCP_NODELAY,
-			       (char *)&val, sizeof(val));
-	LASSERT(!rc);
+	tcp_sock_set_nodelay(conn->ksnc_sock->sk);
 
 	lock_sock(sk);
 	tp->nonagle = nonagle;
diff --git a/net/lnet/lnet/lib-socket.c b/net/lnet/lnet/lib-socket.c
index 7deb48a..7bb8d5c 100644
--- a/net/lnet/lnet/lib-socket.c
+++ b/net/lnet/lnet/lib-socket.c
@@ -182,7 +182,6 @@ int choose_ipv4_src(u32 *ret, int interface, u32 dst_ipaddr, struct net *ns)
 {
 	struct socket *sock;
 	int rc;
-	int option;
 	int family;
 
 	family = AF_INET6;
@@ -200,13 +199,7 @@ int choose_ipv4_src(u32 *ret, int interface, u32 dst_ipaddr, struct net *ns)
 		return ERR_PTR(rc);
 	}
 
-	option = 1;
-	rc = kernel_setsockopt(sock, SOL_SOCKET, SO_REUSEADDR,
-			       (char *)&option, sizeof(option));
-	if (rc) {
-		CERROR("Can't set SO_REUSEADDR for socket: %d\n", rc);
-		goto failed;
-	}
+	sock->sk->sk_reuseport = 1;
 
 	if (interface >= 0 || local_port) {
 		struct sockaddr_storage locaddr = {};
@@ -296,34 +289,21 @@ int choose_ipv4_src(u32 *ret, int interface, u32 dst_ipaddr, struct net *ns)
 	return ERR_PTR(rc);
 }
 
-int
+void
 lnet_sock_setbuf(struct socket *sock, int txbufsize, int rxbufsize)
 {
-	int option;
-	int rc;
+	struct sock *sk = sock->sk;
 
 	if (txbufsize) {
-		option = txbufsize;
-		rc = kernel_setsockopt(sock, SOL_SOCKET, SO_SNDBUF,
-				       (char *)&option, sizeof(option));
-		if (rc) {
-			CERROR("Can't set send buffer %d: %d\n",
-			       option, rc);
-			return rc;
-		}
+		sk->sk_userlocks |= SOCK_SNDBUF_LOCK;
+		sk->sk_sndbuf = txbufsize;
+		sk->sk_write_space(sk);
 	}
 
 	if (rxbufsize) {
-		option = rxbufsize;
-		rc = kernel_setsockopt(sock, SOL_SOCKET, SO_RCVBUF,
-				       (char *)&option, sizeof(option));
-		if (rc) {
-			CERROR("Can't set receive buffer %d: %d\n",
-			       option, rc);
-			return rc;
-		}
+		sk->sk_userlocks |= SOCK_RCVBUF_LOCK;
+		sk->sk_sndbuf = rxbufsize;
 	}
-	return 0;
 }
 EXPORT_SYMBOL(lnet_sock_setbuf);
 
@@ -359,16 +339,13 @@ int choose_ipv4_src(u32 *ret, int interface, u32 dst_ipaddr, struct net *ns)
 }
 EXPORT_SYMBOL(lnet_sock_getaddr);
 
-int
-lnet_sock_getbuf(struct socket *sock, int *txbufsize, int *rxbufsize)
+void lnet_sock_getbuf(struct socket *sock, int *txbufsize, int *rxbufsize)
 {
 	if (txbufsize)
 		*txbufsize = sock->sk->sk_sndbuf;
 
 	if (rxbufsize)
 		*rxbufsize = sock->sk->sk_rcvbuf;
-
-	return 0;
 }
 EXPORT_SYMBOL(lnet_sock_getbuf);
 
-- 
1.8.3.1

