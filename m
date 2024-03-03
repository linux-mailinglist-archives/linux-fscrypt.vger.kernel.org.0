Return-Path: <linux-fscrypt+bounces-214-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 5B1C386F36F
	for <lists+linux-fscrypt@lfdr.de>; Sun,  3 Mar 2024 03:54:26 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 77F291C20DCE
	for <lists+linux-fscrypt@lfdr.de>; Sun,  3 Mar 2024 02:54:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EED5233E5;
	Sun,  3 Mar 2024 02:54:19 +0000 (UTC)
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09AFE29AF
	for <linux-fscrypt@vger.kernel.org>; Sun,  3 Mar 2024 02:54:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709434459; cv=none; b=asDTyCCrFrdsGCuxg7gqVsyGDlH0OwuOZI+qGsBhHXaBu7TQvKNGPOOVHR8Euguq3rNxC/nZLCm4G+DVMyH89VadIFSpOkLCgoYyah/XwyYE94is+pZHRvD/bfBQfoB7Eu/z9xZU+rM+q9oauAboQsKWnfFq/2eeXC9/d3dwII8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709434459; c=relaxed/simple;
	bh=FwrnCITE8BGr/MdGehUpv3w6mcg362NzIGJeqGZQqQo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Content-Type; b=QGyfbWlXbqGDV3dPDB+B13PvwW0SSeYUn0fsLbEo8ihxOJhiXrcI4/r2G9qPzQ8ih4mpYXBTAzbwMBWC/a7uCVei7n3vUrM67argoIzJ9zwVubS5ygkt7gugzoOKhe6L1KT574YIsiuRIP6T+aNNTfOnNswFi963wq6zgKdBZfk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3657abf644fso38278215ab.3
        for <linux-fscrypt@vger.kernel.org>; Sat, 02 Mar 2024 18:54:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1709434457; x=1710039257;
        h=to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=kz8I53N5f5EgUZa+//307lJaWy+VlbE0qgGaxMVUTm8=;
        b=WtJJ3hoAOYH7IelYyhlPtGNpWdqDyp1TKW2FVSUNeV1vdy7SF0/Ad0QvH4/Hj1/KwZ
         HdHMP2M6cUPLaGzZg1lY7SIyZt18GOJaaoxqww3b/K7rLHGkWYZ4v1BG36RqTpgEQkaw
         NupPzWnwpsnTLYrJNMlGl6A2cI57YvOE39dFx5rmZNAk4Y3IGFX2fQGaK610yXX6qCBP
         XGbshfbFa4KVIqgr/typBshs+yJ/omn7+Xh8f3KoWqTARsIqcukTUErAOxraH6fozoF2
         djHGUBG57ef4Ez1vGLkbdsTpK8/7cdol48DwTZqnB+EQaI09dKDim84XbnWqOnLmGtwV
         B+/Q==
X-Forwarded-Encrypted: i=1; AJvYcCXi7cj+IwBC4VlGQtBTJ0lEiMbRyqK6tN16CvXNRQyjhB0CW148Kfz+bVD91QWSdf5yRagJJbC0tgooqJM2gV1uHpfcBMawv/iwq13njw==
X-Gm-Message-State: AOJu0YwEeHr0I2MYubU9o+IbniuJmKDJQAZyFViJiXr2sCSxgac2dAsB
	tcEWi/By7vjFMdwigESfcc/c/vwHVXoV78z9lb5kWfyiC19tCLTwNf6Ke6pxhT49/7ggvf0grIm
	wmzmK5HP8f2tdEXJmBLm9vo9OeRuNj02ZFTvpUuwhPT84J6OGbffFlgE=
X-Google-Smtp-Source: AGHT+IEbO/g+8ISYHt1uvX/Gb9QZ8yjt3dRKjqrDY0iyCSqMaBhdzPJdphEZd+zqMuYitR3OYB36QRtbEAz+EUt1k1GFjDwLnvVU
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1c8e:b0:365:c659:58f3 with SMTP id
 w14-20020a056e021c8e00b00365c65958f3mr380219ill.6.1709434457227; Sat, 02 Mar
 2024 18:54:17 -0800 (PST)
Date: Sat, 02 Mar 2024 18:54:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <000000000000970da80612b8b99d@google.com>
Subject: [syzbot] [fscrypt?] possible deadlock in fscrypt_setup_encryption_info
From: syzbot <syzbot+8d26c0204f49ec0b3ed0@syzkaller.appspotmail.com>
To: ebiggers@kernel.org, jaegeuk@kernel.org, linux-fscrypt@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, tytso@mit.edu
Content-Type: text/plain; charset="UTF-8"

Hello,

syzbot found the following issue on:

HEAD commit:    cf1182944c7c Merge tag 'lsm-pr-20240227' of git://git.kern..
git tree:       upstream
console output: https://syzkaller.appspot.com/x/log.txt?x=136f0f4a180000
kernel config:  https://syzkaller.appspot.com/x/.config?x=be0288b26c967205
dashboard link: https://syzkaller.appspot.com/bug?extid=8d26c0204f49ec0b3ed0
compiler:       gcc (Debian 12.2.0-14) 12.2.0, GNU ld (GNU Binutils for Debian) 2.40

Unfortunately, I don't have any reproducer for this issue yet.

Downloadable assets:
disk image (non-bootable): https://storage.googleapis.com/syzbot-assets/7bc7510fe41f/non_bootable_disk-cf118294.raw.xz
vmlinux: https://storage.googleapis.com/syzbot-assets/2ca1f7923b9b/vmlinux-cf118294.xz
kernel image: https://storage.googleapis.com/syzbot-assets/6070ed6e6026/bzImage-cf118294.xz

IMPORTANT: if you fix the issue, please add the following tag to the commit:
Reported-by: syzbot+8d26c0204f49ec0b3ed0@syzkaller.appspotmail.com

======================================================
WARNING: possible circular locking dependency detected
6.8.0-rc6-syzkaller-00021-gcf1182944c7c #0 Not tainted
------------------------------------------------------
syz-executor.0/30319 is trying to acquire lock:
ffff8880569c4080 (&mk->mk_sem){++++}-{3:3}, at: setup_file_encryption_key fs/crypto/keysetup.c:487 [inline]
ffff8880569c4080 (&mk->mk_sem){++++}-{3:3}, at: fscrypt_setup_encryption_info+0x5da/0x1080 fs/crypto/keysetup.c:590

but task is already holding lock:
ffff888024868950 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x10dd/0x15e0 fs/jbd2/transaction.c:463

which lock already depends on the new lock.


the existing dependency chain (in reverse order) is:

-> #3 (jbd2_handle){++++}-{0:0}:
       start_this_handle+0x1103/0x15e0 fs/jbd2/transaction.c:463
       jbd2__journal_start+0x395/0x850 fs/jbd2/transaction.c:520
       __ext4_journal_start_sb+0x347/0x5e0 fs/ext4/ext4_jbd2.c:112
       ext4_sample_last_mounted fs/ext4/file.c:837 [inline]
       ext4_file_open+0x636/0xc80 fs/ext4/file.c:866
       do_dentry_open+0x8da/0x18c0 fs/open.c:953
       do_open fs/namei.c:3645 [inline]
       path_openat+0x1e00/0x29a0 fs/namei.c:3802
       do_filp_open+0x1de/0x440 fs/namei.c:3829
       do_sys_openat2+0x17a/0x1e0 fs/open.c:1404
       do_sys_open fs/open.c:1419 [inline]
       __do_sys_openat fs/open.c:1435 [inline]
       __se_sys_openat fs/open.c:1430 [inline]
       __x64_sys_openat+0x175/0x210 fs/open.c:1430
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xd5/0x270 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x6f/0x77

-> #2 (sb_internal){.+.+}-{0:0}:
       percpu_down_read include/linux/percpu-rwsem.h:51 [inline]
       __sb_start_write include/linux/fs.h:1641 [inline]
       sb_start_intwrite include/linux/fs.h:1824 [inline]
       ext4_evict_inode+0xe5f/0x1a40 fs/ext4/inode.c:212
       evict+0x2ed/0x6c0 fs/inode.c:665
       iput_final fs/inode.c:1739 [inline]
       iput.part.0+0x563/0x7b0 fs/inode.c:1765
       iput+0x5c/0x80 fs/inode.c:1755
       dentry_unlink_inode+0x295/0x440 fs/dcache.c:400
       __dentry_kill+0x1d0/0x600 fs/dcache.c:603
       shrink_kill fs/dcache.c:1048 [inline]
       shrink_dentry_list+0x140/0x5d0 fs/dcache.c:1075
       prune_dcache_sb+0xeb/0x150 fs/dcache.c:1156
       super_cache_scan+0x32a/0x550 fs/super.c:221
       do_shrink_slab+0x426/0x1120 mm/shrinker.c:435
       shrink_slab_memcg mm/shrinker.c:548 [inline]
       shrink_slab+0xa87/0x1310 mm/shrinker.c:626
       shrink_one+0x493/0x7b0 mm/vmscan.c:4767
       shrink_many mm/vmscan.c:4828 [inline]
       lru_gen_shrink_node mm/vmscan.c:4929 [inline]
       shrink_node+0x214d/0x3750 mm/vmscan.c:5888
       kswapd_shrink_node mm/vmscan.c:6693 [inline]
       balance_pgdat+0x9d2/0x1a90 mm/vmscan.c:6883
       kswapd+0x5be/0xc00 mm/vmscan.c:7143
       kthread+0x2c6/0x3b0 kernel/kthread.c:388
       ret_from_fork+0x45/0x80 arch/x86/kernel/process.c:147
       ret_from_fork_asm+0x1b/0x30 arch/x86/entry/entry_64.S:243

-> #1 (fs_reclaim){+.+.}-{0:0}:
       __fs_reclaim_acquire mm/page_alloc.c:3692 [inline]
       fs_reclaim_acquire+0x104/0x150 mm/page_alloc.c:3706
       might_alloc include/linux/sched/mm.h:303 [inline]
       slab_pre_alloc_hook mm/slub.c:3761 [inline]
       slab_alloc_node mm/slub.c:3842 [inline]
       __do_kmalloc_node mm/slub.c:3980 [inline]
       __kmalloc_node+0xb8/0x470 mm/slub.c:3988
       kmalloc_node include/linux/slab.h:610 [inline]
       kzalloc_node include/linux/slab.h:722 [inline]
       crypto_alloc_tfmmem.isra.0+0x38/0x110 crypto/api.c:496
       crypto_create_tfm_node+0x83/0x320 crypto/api.c:516
       crypto_alloc_tfm_node+0x102/0x260 crypto/api.c:623
       fscrypt_allocate_skcipher fs/crypto/keysetup.c:106 [inline]
       fscrypt_prepare_key+0x92/0x410 fs/crypto/keysetup.c:158
       fscrypt_set_per_file_enc_key fs/crypto/keysetup.c:185 [inline]
       fscrypt_setup_v2_file_key+0x3fb/0x5f0 fs/crypto/keysetup.c:374
       setup_file_encryption_key fs/crypto/keysetup.c:505 [inline]
       fscrypt_setup_encryption_info+0xdf1/0x1080 fs/crypto/keysetup.c:590
       fscrypt_get_encryption_info+0x3d7/0x4b0 fs/crypto/keysetup.c:675
       fscrypt_setup_filename+0x238/0xd80 fs/crypto/fname.c:458
       __fscrypt_prepare_lookup+0x2c/0xf0 fs/crypto/hooks.c:100
       fscrypt_prepare_lookup include/linux/fscrypt.h:979 [inline]
       ext4_fname_prepare_lookup+0x1e0/0x350 fs/ext4/crypto.c:48
       ext4_lookup_entry fs/ext4/namei.c:1764 [inline]
       ext4_lookup+0x14b/0x740 fs/ext4/namei.c:1839
       lookup_one_qstr_excl+0x11d/0x190 fs/namei.c:1608
       filename_create+0x1ed/0x530 fs/namei.c:3896
       do_mkdirat+0xab/0x3a0 fs/namei.c:4141
       __do_sys_mkdirat fs/namei.c:4164 [inline]
       __se_sys_mkdirat fs/namei.c:4162 [inline]
       __x64_sys_mkdirat+0x115/0x170 fs/namei.c:4162
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xd5/0x270 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x6f/0x77

-> #0 (&mk->mk_sem){++++}-{3:3}:
       check_prev_add kernel/locking/lockdep.c:3134 [inline]
       check_prevs_add kernel/locking/lockdep.c:3253 [inline]
       validate_chain kernel/locking/lockdep.c:3869 [inline]
       __lock_acquire+0x244f/0x3b40 kernel/locking/lockdep.c:5137
       lock_acquire kernel/locking/lockdep.c:5754 [inline]
       lock_acquire+0x1ae/0x520 kernel/locking/lockdep.c:5719
       down_read+0x9a/0x330 kernel/locking/rwsem.c:1526
       setup_file_encryption_key fs/crypto/keysetup.c:487 [inline]
       fscrypt_setup_encryption_info+0x5da/0x1080 fs/crypto/keysetup.c:590
       fscrypt_get_encryption_info+0x3d7/0x4b0 fs/crypto/keysetup.c:675
       fscrypt_setup_filename+0x238/0xd80 fs/crypto/fname.c:458
       ext4_fname_setup_filename+0xa3/0x260 fs/ext4/crypto.c:28
       ext4_add_entry+0x2e3/0xdf0 fs/ext4/namei.c:2401
       __ext4_link+0x40b/0x570 fs/ext4/namei.c:3474
       ext4_link+0x1fb/0x2a0 fs/ext4/namei.c:3515
       vfs_link+0x841/0xdf0 fs/namei.c:4608
       do_linkat+0x553/0x600 fs/namei.c:4679
       __do_sys_linkat fs/namei.c:4707 [inline]
       __se_sys_linkat fs/namei.c:4704 [inline]
       __x64_sys_linkat+0xf3/0x140 fs/namei.c:4704
       do_syscall_x64 arch/x86/entry/common.c:52 [inline]
       do_syscall_64+0xd5/0x270 arch/x86/entry/common.c:83
       entry_SYSCALL_64_after_hwframe+0x6f/0x77

other info that might help us debug this:

Chain exists of:
  &mk->mk_sem --> sb_internal --> jbd2_handle

 Possible unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  rlock(jbd2_handle);
                               lock(sb_internal);
                               lock(jbd2_handle);
  rlock(&mk->mk_sem);

 *** DEADLOCK ***

4 locks held by syz-executor.0/30319:
 #0: ffff88802486c420 (sb_writers#5){.+.+}-{0:0}, at: filename_create+0x10d/0x530 fs/namei.c:3888
 #1: ffff88802f4ff200 (&type->i_mutex_dir_key#3/1){+.+.}-{3:3}, at: inode_lock_nested include/linux/fs.h:839 [inline]
 #1: ffff88802f4ff200 (&type->i_mutex_dir_key#3/1){+.+.}-{3:3}, at: filename_create+0x1c2/0x530 fs/namei.c:3895
 #2: ffff88802f408e00 (&sb->s_type->i_mutex_key#7){++++}-{3:3}, at: inode_lock include/linux/fs.h:804 [inline]
 #2: ffff88802f408e00 (&sb->s_type->i_mutex_key#7){++++}-{3:3}, at: vfs_link+0x655/0xdf0 fs/namei.c:4599
 #3: ffff888024868950 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x10dd/0x15e0 fs/jbd2/transaction.c:463

stack backtrace:
CPU: 2 PID: 30319 Comm: syz-executor.0 Not tainted 6.8.0-rc6-syzkaller-00021-gcf1182944c7c #0
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 __dump_stack lib/dump_stack.c:88 [inline]
 dump_stack_lvl+0xd9/0x1b0 lib/dump_stack.c:106
 check_noncircular+0x31b/0x400 kernel/locking/lockdep.c:2187
 check_prev_add kernel/locking/lockdep.c:3134 [inline]
 check_prevs_add kernel/locking/lockdep.c:3253 [inline]
 validate_chain kernel/locking/lockdep.c:3869 [inline]
 __lock_acquire+0x244f/0x3b40 kernel/locking/lockdep.c:5137
 lock_acquire kernel/locking/lockdep.c:5754 [inline]
 lock_acquire+0x1ae/0x520 kernel/locking/lockdep.c:5719
 down_read+0x9a/0x330 kernel/locking/rwsem.c:1526
 setup_file_encryption_key fs/crypto/keysetup.c:487 [inline]
 fscrypt_setup_encryption_info+0x5da/0x1080 fs/crypto/keysetup.c:590
 fscrypt_get_encryption_info+0x3d7/0x4b0 fs/crypto/keysetup.c:675
 fscrypt_setup_filename+0x238/0xd80 fs/crypto/fname.c:458
 ext4_fname_setup_filename+0xa3/0x260 fs/ext4/crypto.c:28
 ext4_add_entry+0x2e3/0xdf0 fs/ext4/namei.c:2401
 __ext4_link+0x40b/0x570 fs/ext4/namei.c:3474
 ext4_link+0x1fb/0x2a0 fs/ext4/namei.c:3515
 vfs_link+0x841/0xdf0 fs/namei.c:4608
 do_linkat+0x553/0x600 fs/namei.c:4679
 __do_sys_linkat fs/namei.c:4707 [inline]
 __se_sys_linkat fs/namei.c:4704 [inline]
 __x64_sys_linkat+0xf3/0x140 fs/namei.c:4704
 do_syscall_x64 arch/x86/entry/common.c:52 [inline]
 do_syscall_64+0xd5/0x270 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x6f/0x77
RIP: 0033:0x7f626787dda9
Code: 28 00 00 00 75 05 48 83 c4 28 c3 e8 e1 20 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 b0 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f62685710c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000109
RAX: ffffffffffffffda RBX: 00007f62679abf80 RCX: 00007f626787dda9
RDX: 0000000000000006 RSI: 00000000200003c0 RDI: 0000000000000003
RBP: 00007f62678ca47a R08: 0000000000000000 R09: 0000000000000000
R10: 00000000200004c0 R11: 0000000000000246 R12: 0000000000000000
R13: 000000000000000b R14: 00007f62679abf80 R15: 00007ffcf764da78
 </TASK>


---
This report is generated by a bot. It may contain errors.
See https://goo.gl/tpsmEJ for more information about syzbot.
syzbot engineers can be reached at syzkaller@googlegroups.com.

syzbot will keep track of this issue. See:
https://goo.gl/tpsmEJ#status for how to communicate with syzbot.

If the report is already addressed, let syzbot know by replying with:
#syz fix: exact-commit-title

If you want to overwrite report's subsystems, reply with:
#syz set subsystems: new-subsystem
(See the list of subsystem names on the web dashboard)

If the report is a duplicate of another one, reply with:
#syz dup: exact-subject-of-another-report

If you want to undo deduplication, reply with:
#syz undup

