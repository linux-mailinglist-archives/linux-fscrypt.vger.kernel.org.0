Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63FBC63EA0E
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Dec 2022 07:59:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229848AbiLAG7F (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 1 Dec 2022 01:59:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53446 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229449AbiLAG7D (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 1 Dec 2022 01:59:03 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3C913FBB4
        for <linux-fscrypt@vger.kernel.org>; Wed, 30 Nov 2022 22:58:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1669877888;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=vQSeo5WRJUG0Y0WkiQ/AFBMQlfNS5mfy/wwYdfC0c2o=;
        b=VIF8mjau7RhJY0Q9SodIZkG7BY7SvgiRPkSzgKBeeKRqodZhS601gZKfazzjFCizcRR6SS
        uMYfxqdgT96+wkHvX9MzdFboSCdVBwX4CIcpzq+fvdnejqkQWn+kwz1D7+0XVjN7ufezsC
        ssVdEvnINsydUZzH8GR8JE7BnX+hrAU=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-435-tk6vhfkeNtqGRPrDHrX08w-1; Thu, 01 Dec 2022 01:58:06 -0500
X-MC-Unique: tk6vhfkeNtqGRPrDHrX08w-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.rdu2.redhat.com [10.11.54.4])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 2F2E13C01D90;
        Thu,  1 Dec 2022 06:58:06 +0000 (UTC)
Received: from lxbceph1.gsslab.pek2.redhat.com (unknown [10.72.47.117])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 96F412028CE4;
        Thu,  1 Dec 2022 06:58:03 +0000 (UTC)
From:   xiubli@redhat.com
To:     idryomov@gmail.com, ceph-devel@vger.kernel.org
Cc:     jlayton@kernel.org, khiremat@redhat.com,
        linux-fscrypt@vger.kernel.org, Xiubo Li <xiubli@redhat.com>
Subject: [PATCH] ceph: make sure all the files successfully put before unmounting
Date:   Thu,  1 Dec 2022 14:58:00 +0800
Message-Id: <20221201065800.18149-1-xiubli@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.4
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Xiubo Li <xiubli@redhat.com>

When close a file it will be deferred to call the fput(), which
will hold the inode's i_count. And when unmounting the mountpoint
the evict_inodes() may skip evicting some inodes.

If encrypt is enabled the kernel generate a warning when removing
the encrypt keys when the skipped inodes still hold the keyring:

WARNING: CPU: 4 PID: 168846 at fs/crypto/keyring.c:242 fscrypt_destroy_keyring+0x7e/0xd0
CPU: 4 PID: 168846 Comm: umount Tainted: G S  6.1.0-rc5-ceph-g72ead199864c #1
Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 2.0 12/17/2015
RIP: 0010:fscrypt_destroy_keyring+0x7e/0xd0
RSP: 0018:ffffc9000b277e28 EFLAGS: 00010202
RAX: 0000000000000002 RBX: ffff88810d52ac00 RCX: ffff88810b56aa00
RDX: 0000000080000000 RSI: ffffffff822f3a09 RDI: ffff888108f59000
RBP: ffff8881d394fb88 R08: 0000000000000028 R09: 0000000000000000
R10: 0000000000000001 R11: 11ff4fe6834fcd91 R12: ffff8881d394fc40
R13: ffff888108f59000 R14: ffff8881d394f800 R15: 0000000000000000
FS:  00007fd83f6f1080(0000) GS:ffff88885fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f918d417000 CR3: 000000017f89a005 CR4: 00000000003706e0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
<TASK>
generic_shutdown_super+0x47/0x120
kill_anon_super+0x14/0x30
ceph_kill_sb+0x36/0x90 [ceph]
deactivate_locked_super+0x29/0x60
cleanup_mnt+0xb8/0x140
task_work_run+0x67/0xb0
exit_to_user_mode_prepare+0x23d/0x240
syscall_exit_to_user_mode+0x25/0x60
do_syscall_64+0x40/0x80
entry_SYSCALL_64_after_hwframe+0x63/0xcd
RIP: 0033:0x7fd83dc39e9b

URL: https://tracker.ceph.com/issues/58126
Signed-off-by: Xiubo Li <xiubli@redhat.com>
---
 fs/ceph/super.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/fs/ceph/super.c b/fs/ceph/super.c
index 3db6f95768a3..1f46db92e81f 100644
--- a/fs/ceph/super.c
+++ b/fs/ceph/super.c
@@ -9,6 +9,7 @@
 #include <linux/in6.h>
 #include <linux/module.h>
 #include <linux/mount.h>
+#include <linux/file.h>
 #include <linux/fs_context.h>
 #include <linux/fs_parser.h>
 #include <linux/sched.h>
@@ -1477,6 +1478,14 @@ static void ceph_kill_sb(struct super_block *s)
 	ceph_mdsc_pre_umount(fsc->mdsc);
 	flush_fs_workqueues(fsc);
 
+	/*
+	 * If the encrypt is enabled we need to make sure the delayed
+	 * fput to finish, which will make sure all the inodes will
+	 * be evicted before removing the encrypt keys.
+	 */
+	if (s->s_master_keys)
+		flush_delayed_fput();
+
 	kill_anon_super(s);
 
 	fsc->client->extra_mon_dispatch = NULL;
-- 
2.31.1

