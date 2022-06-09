Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 94E57544C13
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jun 2022 14:33:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245198AbiFIMde (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jun 2022 08:33:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244894AbiFIMdW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jun 2022 08:33:22 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C44B4192AB
        for <linux-fscrypt@vger.kernel.org>; Thu,  9 Jun 2022 05:33:17 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id 2F1DFEEF;
        Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id 278D8D4381; Thu,  9 Jun 2022 08:33:16 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 00/18] lustre: sync with OpenSFS tree June 8, 2022
Date:   Thu,  9 Jun 2022 08:32:56 -0400
Message-Id: <1654777994-29806-1-git-send-email-jsimmons@infradead.org>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Sync with the new work coming in for 2.16 development branch.
Hold back the LU-15189 work since it introduced a regression
that has an outstanding fix.

Alexander Boyko (1):
  lustre: ptlrpc: send disconnected events

Alexey Lyashkov (1):
  lnet: selftest: improve lnet_selftest speed

Arshad Hussain (1):
  lustre: quota: fallocate does not increase projectid usage

Chris Horn (1):
  lnet: Avoid redundant peer NI lookups

Etienne AUJAMES (2):
  lustre: llog: read canceled records in llog_backup
  lustre: mdc: Use early cancels for hsm requests

John L. Hammond (1):
  lustre: llite: reenable fast_read by default

Lai Siyao (1):
  lustre: llite: access lli_lsm_md with lock in all places

Mr NeilBrown (8):
  lnet: change LNetPrimaryNID to use struct lnet_nid
  lnet: alter lnet_drop_rule_match() to take lnet_nid
  lnet: Change LNetDist to work with struct lnet_nid
  lnet: convert LNetPut to take 16byte nid and pid.
  lnet: change LNetGet to take 16byte nid and pid.
  lnet: socklnd: pass large processid to ksocknal_add_peer
  lnet: socklnd: large processid for ksocknal_get_peer_info
  lnet: socklnd: switch ksocknal_del_peer to lnet_processid

Oleg Drokin (1):
  lustre: update version to 2.15.50

Patrick Farrell (1):
  lustre: llite: Check vmpage in releasepage

 fs/lustre/include/cl_object.h          |  10 +++
 fs/lustre/include/lustre_log.h         |  11 +++
 fs/lustre/include/obd_class.h          |   3 +-
 fs/lustre/llite/dir.c                  |   6 +-
 fs/lustre/llite/file.c                 |  26 ++++---
 fs/lustre/llite/llite_internal.h       |  17 ++++-
 fs/lustre/llite/llite_lib.c            |  22 +++---
 fs/lustre/llite/namei.c                |   7 +-
 fs/lustre/llite/rw26.c                 |  19 +++--
 fs/lustre/llite/statahead.c            |   2 +
 fs/lustre/llite/vvp_object.c           |   3 +-
 fs/lustre/lmv/lmv_obd.c                |   3 +-
 fs/lustre/lov/lov_io.c                 |   2 +
 fs/lustre/mdc/mdc_request.c            |  37 ++++++++--
 fs/lustre/obdclass/llog.c              |  22 ++++--
 fs/lustre/obdclass/llog_cat.c          |   5 +-
 fs/lustre/obdclass/lustre_peer.c       |   4 +-
 fs/lustre/obdclass/obd_config.c        |   1 +
 fs/lustre/osc/osc_io.c                 |   9 ++-
 fs/lustre/osc/osc_page.c               |   9 ++-
 fs/lustre/ptlrpc/connection.c          |   2 +-
 fs/lustre/ptlrpc/events.c              |  12 ++--
 fs/lustre/ptlrpc/import.c              |   4 ++
 fs/lustre/ptlrpc/niobuf.c              |  15 ++--
 include/linux/lnet/api.h               |  12 ++--
 include/linux/lnet/lib-lnet.h          |   4 +-
 include/uapi/linux/lustre/lustre_ver.h |   4 +-
 net/lnet/klnds/socklnd/socklnd.c       |  77 +++++++++------------
 net/lnet/klnds/socklnd/socklnd.h       |   2 +-
 net/lnet/klnds/socklnd/socklnd_cb.c    |  28 +++++---
 net/lnet/lnet/api-ni.c                 |  29 ++++----
 net/lnet/lnet/lib-move.c               | 100 ++++++++++++---------------
 net/lnet/lnet/lib-msg.c                |   3 +-
 net/lnet/lnet/net_fault.c              |  40 ++++++-----
 net/lnet/lnet/peer.c                   | 105 +++++++++++++---------------
 net/lnet/lnet/router.c                 |   6 +-
 net/lnet/selftest/rpc.c                | 122 +++++++++++++++++++--------------
 net/lnet/selftest/selftest.h           |   1 -
 38 files changed, 447 insertions(+), 337 deletions(-)

-- 
1.8.3.1

