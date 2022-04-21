Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97F2E50947B
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Apr 2022 03:05:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1383415AbiDUBIO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 Apr 2022 21:08:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1383539AbiDUBIN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 Apr 2022 21:08:13 -0400
Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C65DEE4
        for <linux-fscrypt@vger.kernel.org>; Wed, 20 Apr 2022 18:05:25 -0700 (PDT)
Received: by mail-il1-f200.google.com with SMTP id j16-20020a056e02125000b002cc39632ab9so1830127ilq.9
        for <linux-fscrypt@vger.kernel.org>; Wed, 20 Apr 2022 18:05:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:date:message-id:subject:from:to;
        bh=a9pH5rcH6cZW4gCODSOkvWJMXRWe4itgqzAkMUc2mXM=;
        b=2BdbDtcEafcH1LrXZL5fM/0OzQUQXA5C//opeYxen1GnCibzYxcVPPby2yPSzIJPbT
         KLo6becnX999TJOzGo9mbPxh8c9V5m5aOC1mMI5JmWBFJgvO/2epvmytqIwLMdGhX0Er
         up7/sM87B+O612qSa8fd7kNTIaSbAIE/QdkfPNQ7dp1Ul4IphDjZjVOOkAjDs8VJTzUI
         uRL6UE6toGbCEwsGQhr7KgTxeIT1ikhe/mqsYFOeUyhpk9jHgyhGBJwxhivzWZvrrJjs
         ih5xSTdzoJfrneX2TQs4Hhsd1HI+HrnW7L+4KpqmL20Yc98riIpEiFNmVdIwVoH2qhcE
         DD9Q==
X-Gm-Message-State: AOAM531WdE5uUxX/WdscXWDaagAhv4PlVxI9IdOvv4t+rBNvUZeZmnrh
        Vjgb9WA6q4ymFvctpn7evlLplBkIGaRQ0oEUM5vH1HUmPUi0
X-Google-Smtp-Source: ABdhPJx9jyN2bwFSEOIs3D0/FO5AZ2aeascI5ph6L8J2M69QhfjlS+BUqJl7JXNVq1CQK+63dXgqXNkEWtfnYM3MAJrixBrV1OfS
MIME-Version: 1.0
X-Received: by 2002:a05:6638:4919:b0:326:5cde:6fe0 with SMTP id
 cx25-20020a056638491900b003265cde6fe0mr11558568jab.34.1650503124527; Wed, 20
 Apr 2022 18:05:24 -0700 (PDT)
Date:   Wed, 20 Apr 2022 18:05:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <00000000000070395e05dd1fb4d7@google.com>
Subject: [syzbot] possible deadlock in fscrypt_initialize
From:   syzbot <syzbot+1a748d0007eeac3ab079@syzkaller.appspotmail.com>
To:     ebiggers@kernel.org, jaegeuk@kernel.org,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,FROM_LOCAL_HEX,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

syzbot found the following issue on:

HEAD commit:    90ea17a9e27b Merge tag 'scsi-fixes' of git://git.kernel.or..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=16bf09d0f00000
kernel config:  https://syzkaller.appspot.com/x/.config?x=ac042ae170e2c50f
dashboard link: https://syzkaller.appspot.com/bug?extid=1a748d0007eeac3ab079
compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2

Unfortunately, I don't have any reproducer for this issue yet.

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+1a748d0007eeac3ab079@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
5.18.0-rc2-syzkaller-00291-g90ea17a9e27b #0 Not tainted
------------------------------------------------------
syz-executor.0/3694 is trying to acquire lock:
ffffffff8bf36428 (fscrypt_init_mutex){+.+.}-{3:3}, at: fscrypt_initialize+0x3c/0xa0 fs/crypto/crypto.c:324

but task is already holding lock:
ffff8880430c8990 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xfb4/0x14a0 fs/jbd2/transaction.c:461

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #2 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0xfe7/0x14a0 fs/jbd2/transaction.c:463
       jbd2__journal_start+0x399/0x930 fs/jbd2/transaction.c:520
       __ext4_journal_start_sb+0x3a8/0x4a0 fs/ext4/ext4_jbd2.c:105
       __ext4_journal_start fs/ext4/ext4_jbd2.h:326 [inline]
       ext4_dirty_inode+0x9d/0x110 fs/ext4/inode.c:5932
       __mark_inode_dirty+0x45b/0xfe0 fs/fs-writeback.c:2367
       mark_inode_dirty_sync include/linux/fs.h:2329 [inline]
       iput.part.0+0x57/0x820 fs/inode.c:1767
       iput+0x58/0x70 fs/inode.c:1760
       dentry_unlink_inode+0x2b1/0x460 fs/dcache.c:401
       __dentry_kill+0x3c0/0x640 fs/dcache.c:607
       shrink_dentry_list+0x23c/0x800 fs/dcache.c:1201
       prune_dcache_sb+0xe7/0x140 fs/dcache.c:1282
       super_cache_scan+0x336/0x590 fs/super.c:104
       do_shrink_slab+0x42d/0xbd0 mm/vmscan.c:774
       shrink_slab+0x17c/0x6f0 mm/vmscan.c:934
       shrink_node_memcgs mm/vmscan.c:3100 [inline]
       shrink_node+0x8b3/0x1df0 mm/vmscan.c:3221
       shrink_zones mm/vmscan.c:3458 [inline]
       do_try_to_free_pages+0x3b5/0x1700 mm/vmscan.c:3516
       try_to_free_pages+0x2ac/0x840 mm/vmscan.c:3751
       __perform_reclaim mm/page_alloc.c:4624 [inline]
       __alloc_pages_direct_reclaim mm/page_alloc.c:4646 [inline]
       __alloc_pages_slowpath.constprop.0+0xac7/0x20e0 mm/page_alloc.c:5046
       __alloc_pages+0x412/0x500 mm/page_alloc.c:5421
       __alloc_pages_node include/linux/gfp.h:587 [inline]
       khugepaged_alloc_page+0xa0/0x170 mm/khugepaged.c:868
       collapse_huge_page mm/khugepaged.c:1071 [inline]
       khugepaged_scan_pmd mm/khugepaged.c:1357 [inline]
       khugepaged_scan_mm_slot mm/khugepaged.c:2167 [inline]
       khugepaged_do_scan mm/khugepaged.c:2248 [inline]
       khugepaged+0x3474/0x66e0 mm/khugepaged.c:2293
       kthread+0x2e9/0x3a0 kernel/kthread.c:376
       ret_from_fork+0x1f/0x30 arch/x86/entry/entry_64.S:298

-> #1 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:4572 [inline]
       fs_reclaim_acquire+0x115/0x160 mm/page_alloc.c:4586
       might_alloc include/linux/sched/mm.h:254 [inline]
       slab_pre_alloc_hook mm/slab.h:722 [inline]
       slab_alloc_node mm/slab.c:3214 [inline]
       kmem_cache_alloc_node_trace+0x48/0x5b0 mm/slab.c:3625
       kmalloc_node include/linux/slab.h:599 [inline]
       kzalloc_node include/linux/slab.h:725 [inline]
       mempool_create_node mm/mempool.c:266 [inline]
       mempool_create+0x4e/0xc0 mm/mempool.c:255
       mempool_create_page_pool include/linux/mempool.h:107 [inline]
       fscrypt_initialize+0x86/0xa0 fs/crypto/crypto.c:330
       fscrypt_setup_encryption_info+0xef/0xf00 fs/crypto/keysetup.c:545
       fscrypt_get_encryption_info+0x34a/0x3f0 fs/crypto/keysetup.c:654
       fscrypt_setup_filename+0x238/0xec0 fs/crypto/fname.c:426
       __fscrypt_prepare_lookup+0x28/0xf0 fs/crypto/hooks.c:102
       fscrypt_prepare_lookup include/linux/fscrypt.h:898 [inline]
       ext4_fname_prepare_lookup+0x2b1/0x330 fs/ext4/ext4.h:2770
       ext4_lookup_entry fs/ext4/namei.c:1694 [inline]
       ext4_lookup fs/ext4/namei.c:1769 [inline]
       ext4_lookup+0x12d/0x730 fs/ext4/namei.c:1760
       lookup_open.isra.0+0x9aa/0x1690 fs/namei.c:3308
       open_last_lookups fs/namei.c:3400 [inline]
       path_openat+0x9a2/0x2910 fs/namei.c:3606
       do_filp_open+0x1aa/0x400 fs/namei.c:3636
       do_sys_openat2+0x16d/0x4c0 fs/open.c:1213
       do_sys_open fs/open.c:1229 [inline]
       __do_sys_openat fs/open.c:1245 [inline]
       __se_sys_openat fs/open.c:1240 [inline]
       __x64_sys_openat+0x13f/0x1f0 fs/open.c:1240
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

-> #0 (fscrypt_init_mutex){+.+.}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3065 [inline]
       check_prevs_add kernel/locking/lockdep.c:3188 [inline]
       validate_chain kernel/locking/lockdep.c:3803 [inline]
       __lock_acquire+0x2ac6/0x56c0 kernel/locking/lockdep.c:5029
       lock_acquire kernel/locking/lockdep.c:5641 [inline]
       lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5606
       __mutex_lock_common kernel/locking/mutex.c:600 [inline]
       __mutex_lock+0x12f/0x12f0 kernel/locking/mutex.c:733
       fscrypt_initialize+0x3c/0xa0 fs/crypto/crypto.c:324
       fscrypt_setup_encryption_info+0xef/0xf00 fs/crypto/keysetup.c:545
       fscrypt_get_encryption_info+0x34a/0x3f0 fs/crypto/keysetup.c:654
       fscrypt_setup_filename+0x238/0xec0 fs/crypto/fname.c:426
       ext4_fname_setup_filename+0x8d/0x240 fs/ext4/ext4.h:2751
       ext4_find_entry+0x8c/0x170 fs/ext4/namei.c:1674
       __ext4_unlink+0x92/0x920 fs/ext4/namei.c:3155
       ext4_unlink+0x346/0x9e0 fs/ext4/namei.c:3231
       vfs_unlink+0x351/0x920 fs/namei.c:4148
       do_unlinkat+0x3c9/0x650 fs/namei.c:4216
       __do_sys_unlink fs/namei.c:4264 [inline]
       __se_sys_unlink fs/namei.c:4262 [inline]
       __x64_sys_unlink+0xc6/0x110 fs/namei.c:4262
       do_syscall_x64 arch/x86/entry/common.c:50 [inline]
       do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
       entry_SYSCALL_64_after_hwframe+0x44/0xae

other info that might help us debug this:

Chain exists of:
  fscrypt_init_mutex --> fs_reclaim --> jbd2_handle

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(jbd2_handle);
                               lock(fs_reclaim);
                               lock(jbd2_handle);
  lock(fscrypt_init_mutex);

 *** DEADLOCK ***

4 locks held by syz-executor.0/3694:
 #0: ffff8880434f6460 (sb_writers#5){.+.+}-{0:0}, at: do_unlinkat+0x17f/0x650 fs/namei.c:4195
 #1: ffff8880784f46c0 (&type->i_mutex_dir_key#3/1){+.+.}-{3:3}, at: inode_lock_nested include/linux/fs.h:783 [inline]
 #1: ffff8880784f46c0 (&type->i_mutex_dir_key#3/1){+.+.}-{3:3}, at: do_unlinkat+0x269/0x650 fs/namei.c:4199
 #2: ffff88801b236440 (&sb->s_type->i_mutex_key#8){++++}-{3:3}, at: inode_lock include/linux/fs.h:748 [inline]
 #2: ffff88801b236440 (&sb->s_type->i_mutex_key#8){++++}-{3:3}, at: vfs_unlink+0xd5/0x920 fs/namei.c:4137
 #3: ffff8880430c8990 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0xfb4/0x14a0 fs/jbd2/transaction.c:461

stack backtrace:
CPU: 0 PID: 3694 Comm: syz-executor.0 Not tainted 5.18.0-rc2-syzkaller-00291-g90ea17a9e27b #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.14.0-2 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:106
 check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2145
 check_prev_add kernel/locking/lockdep.c:3065 [inline]
 check_prevs_add kernel/locking/lockdep.c:3188 [inline]
 validate_chain kernel/locking/lockdep.c:3803 [inline]
 __lock_acquire+0x2ac6/0x56c0 kernel/locking/lockdep.c:5029
 lock_acquire kernel/locking/lockdep.c:5641 [inline]
 lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5606
 __mutex_lock_common kernel/locking/mutex.c:600 [inline]
 __mutex_lock+0x12f/0x12f0 kernel/locking/mutex.c:733
 fscrypt_initialize+0x3c/0xa0 fs/crypto/crypto.c:324
 fscrypt_setup_encryption_info+0xef/0xf00 fs/crypto/keysetup.c:545
 fscrypt_get_encryption_info+0x34a/0x3f0 fs/crypto/keysetup.c:654
 fscrypt_setup_filename+0x238/0xec0 fs/crypto/fname.c:426
 ext4_fname_setup_filename+0x8d/0x240 fs/ext4/ext4.h:2751
 ext4_find_entry+0x8c/0x170 fs/ext4/namei.c:1674
 __ext4_unlink+0x92/0x920 fs/ext4/namei.c:3155
 ext4_unlink+0x346/0x9e0 fs/ext4/namei.c:3231
 vfs_unlink+0x351/0x920 fs/namei.c:4148
 do_unlinkat+0x3c9/0x650 fs/namei.c:4216
 __do_sys_unlink fs/namei.c:4264 [inline]
 __se_sys_unlink fs/namei.c:4262 [inline]
 __x64_sys_unlink+0xc6/0x110 fs/namei.c:4262
 do_syscall_x64 arch/x86/entry/common.c:50 [inline]
 do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f7581288a27
Code: 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 57 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd33ea0ca8 EFLAGS: 00000206 ORIG_RAX: 0000000000000057
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f7581288a27
RDX: 00007ffd33ea0ce0 RSI: 00007ffd33ea0ce0 RDI: 00007ffd33ea0d70
RBP: 00007ffd33ea0d70 R08: 0000000000000001 R09: 00007ffd33ea0b40
R10: 0000555556665893 R11: 0000000000000206 R12: 00007f75812e21f8
R13: 00007ffd33ea1e70 R14: 0000555556665850 R15: 00007ffd33ea2f70
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
