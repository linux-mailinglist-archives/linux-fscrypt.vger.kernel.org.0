Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BE08055052C
	for <lists+linux-fscrypt@lfdr.de>; Sat, 18 Jun 2022 15:52:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233376AbiFRNwZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 18 Jun 2022 09:52:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230469AbiFRNwS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 18 Jun 2022 09:52:18 -0400
Received: from smtp3.ccs.ornl.gov (smtp3.ccs.ornl.gov [160.91.203.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1DA1D328
        for <linux-fscrypt@vger.kernel.org>; Sat, 18 Jun 2022 06:52:15 -0700 (PDT)
Received: from star.ccs.ornl.gov (star.ccs.ornl.gov [160.91.202.134])
        by smtp3.ccs.ornl.gov (Postfix) with ESMTP id E8F2313C2;
        Sat, 18 Jun 2022 09:52:13 -0400 (EDT)
Received: by star.ccs.ornl.gov (Postfix, from userid 2004)
        id D8867DC803; Sat, 18 Jun 2022 09:52:13 -0400 (EDT)
From:   James Simmons <jsimmons@infradead.org>
To:     Eric Biggers <ebiggers@google.com>,
        Andreas Dilger <adilger@whamcloud.com>,
        NeilBrown <neilb@suse.de>
Cc:     linux-fscrypt@vger.kernel.org,
        James Simmons <jsimmons@infradead.org>
Subject: [PATCH 00/28] lustre: sync to OpenSFS June 15, 2022
Date:   Sat, 18 Jun 2022 09:51:42 -0400
Message-Id: <1655560330-30743-1-git-send-email-jsimmons@infradead.org>
X-Mailer: git-send-email 1.8.3.1
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Backport OpenSFS work as of June 15, 2022. Move to a Linux 5.9
kernel.

Alex Zhuravlev (2):
  lnet: libcfs: reset hs_rehash_bits
  lustre: ptlrpc: don't report eviction for light weigth connections

Alexander Boyko (2):
  lustre: lmv: try another MDT if statfs failed
  lustre: lmv: skip qos for qos_threshold_rr=100

Andreas Dilger (1):
  lnet: libcfs: add "default" keyword for debug mask

Andrew Elwell (1):
  lustre: ptlrpc: Rearrange version mismatch message

Bobi Jam (1):
  lustre: ec: add necessary structure member for EC file

Chris Horn (4):
  lnet: Ping buffer ref leak in lnet_peer_data_present
  lnet: DLC sets map_on_demand incorrectly
  lnet: Return ESHUTDOWN in lnet_parse()
  lnet: libcfs: libcfs_debug_mb set incorrectly on init

Cyril Bordage (1):
  lnet: set max recovery interval duration

James Simmons (2):
  lustre: sec: support test_dummy_encryption=v2
  lustre: uapi: avoid gcc-11 -Werror=stringop-overread warning

John L. Hammond (1):
  lustre: lov: remove lov_page

Lai Siyao (1):
  lustre: llite: add option to disable Lustre inode cache

Mr NeilBrown (4):
  lustre: osc: handle removal of NR_UNSTABLE_NFS
  lustre: llite: switch from ->mmap_sem to mmap_lock()
  lnet: support removal of kernel_setsockopt()
  lnet: improve compat code for IPV6_V6ONLY sock opt

Patrick Farrell (6):
  lustre: llite: Correct cl_env comments
  lustre: llite: Make iotrace logging quieter
  lustre: llite: Add strided readahead to iotrace
  lustre: llite: Add FID to async ra iotrace
  lustre: llite: Add COMPLETED iotrace messages
  lustre: osc: Add RPC to iotrace

Sergey Gorenko (1):
  lnet: o2ib: Fix compilation with Linux 5.8

Serguei Smirnov (1):
  lnet: o2iblnd: clean up zombie connections on shutdown

 fs/lustre/include/cl_object.h              |  13 ++-
 fs/lustre/include/lu_object.h              |   1 +
 fs/lustre/include/lustre_crypto.h          |  15 ++--
 fs/lustre/include/lustre_disk.h            |   3 +
 fs/lustre/llite/crypto.c                   |  30 +++----
 fs/lustre/llite/dir.c                      |   2 +-
 fs/lustre/llite/file.c                     |  12 +++
 fs/lustre/llite/llite_internal.h           |  17 ++--
 fs/lustre/llite/llite_lib.c                |  34 ++++++--
 fs/lustre/llite/llite_mmap.c               |  20 +++--
 fs/lustre/llite/lproc_llite.c              |  31 +++++++
 fs/lustre/llite/namei.c                    |   3 +-
 fs/lustre/llite/pcc.c                      |   6 +-
 fs/lustre/llite/rw.c                       |  17 ++--
 fs/lustre/llite/super25.c                  |   7 +-
 fs/lustre/llite/vvp_io.c                   |   4 +-
 fs/lustre/lmv/lmv_obd.c                    |  11 ++-
 fs/lustre/lmv/lproc_lmv.c                  |   5 +-
 fs/lustre/lov/lov_cl_internal.h            |  32 +++----
 fs/lustre/lov/lov_object.c                 |   5 +-
 fs/lustre/lov/lov_page.c                   |  46 ++--------
 fs/lustre/obdclass/cl_object.c             |  32 +++----
 fs/lustre/obdclass/lu_tgt_descs.c          |  12 ++-
 fs/lustre/osc/osc_page.c                   |   4 +-
 fs/lustre/osc/osc_request.c                |  16 +++-
 fs/lustre/ptlrpc/import.c                  |  10 ++-
 fs/lustre/ptlrpc/pack_generic.c            |   4 +
 fs/lustre/ptlrpc/wiretest.c                |  24 +++++-
 include/linux/libcfs/libcfs_string.h       |   3 +-
 include/linux/lnet/lib-lnet.h              |  13 +--
 include/uapi/linux/lnet/libcfs_debug.h     | 129 +++++++++++++++--------------
 include/uapi/linux/lustre/lustre_user.h    |  46 ++++++----
 net/lnet/klnds/o2iblnd/o2iblnd.c           |   6 ++
 net/lnet/klnds/o2iblnd/o2iblnd_cb.c        |   3 +-
 net/lnet/klnds/o2iblnd/o2iblnd_modparams.c |   3 +
 net/lnet/klnds/socklnd/socklnd_lib.c       | 123 ++++++++-------------------
 net/lnet/libcfs/debug.c                    |  20 ++---
 net/lnet/libcfs/hash.c                     |  11 ++-
 net/lnet/libcfs/libcfs_string.c            |  11 ++-
 net/lnet/libcfs/tracefile.c                |   5 +-
 net/lnet/lnet/api-ni.c                     |  49 +++++++++++
 net/lnet/lnet/lib-move.c                   |   2 +-
 net/lnet/lnet/lib-socket.c                 |  57 ++++---------
 net/lnet/lnet/peer.c                       |   9 +-
 44 files changed, 506 insertions(+), 400 deletions(-)

-- 
1.8.3.1

