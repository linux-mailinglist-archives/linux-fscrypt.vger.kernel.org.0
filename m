Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9DF34612A2E
	for <lists+linux-fscrypt@lfdr.de>; Sun, 30 Oct 2022 11:41:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229746AbiJ3KlT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 30 Oct 2022 06:41:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52072 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229651AbiJ3KlT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 30 Oct 2022 06:41:19 -0400
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 305262BB;
        Sun, 30 Oct 2022 03:41:18 -0700 (PDT)
Received: by mail-ej1-x633.google.com with SMTP id n12so22858218eja.11;
        Sun, 30 Oct 2022 03:41:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=5pcTjlVcCbLXyhugBFvbltydCNqisX8sC5t+otcJDPU=;
        b=kB9KiBhqiTeOdu6SgwCtrZ7TA2NBZ1bOoFLLkdUe94CmRGLnzrs9CcXN4tLiZZ5vYL
         nMKqiK1c/nvWgRxhrgG0hm9UkvlLSAc67HMkTpCbw1Ijm6kC9P2RU66tEIe5RFS0nNxG
         N6ZVryKFY7fqNdLhrabNOwY2gr9XVGjs3ub9xaifodOsiDrzSEUlckO7hUisq+7Bi5q7
         kKR8yKYxpriG5Z3JhfpT5W+bwH51kQy6wRDh8efG+86aMpZFaakjZ2ctfwGng0h7s45Y
         Bj6CRHw5KUKDB/PogkmQTaw/NPSoWLJNN35fbPsVAGiobGPiI5swhtbi9vjeo1X5qNbL
         4ItA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5pcTjlVcCbLXyhugBFvbltydCNqisX8sC5t+otcJDPU=;
        b=Hw2C9lQ2Ci2iHWv7YfUqAaswmR1bkzqkNJXTfPaEsYkRwB6OQrBhzsjmsTJUfX9buo
         fep/yecOyVX0r/nxkv8djv3BQX2PTZxKU01b81F3LzVEwPIcVTkUFnjqPqeuK6dvP8Iy
         s/dhRhQN8LPhebgxpigGmsCIWIC92iOa9HNjv7db3r+dtf0AxnRFIFwzvIccB+a+B1eC
         2SMFg2lD9JeXwwnsjvzoHD/zWFxLIffyE+CKmai6gdXTtcphHosB6LID+ECSX7z1L93/
         qfPOoE8cYXZTXQ4A3STxMojT64ewCpXcTX8MIcThMlVXut+zInvi5u04HGDF22AEP9dn
         0IYg==
X-Gm-Message-State: ACrzQf1pjZ2HFIaJxLL2xD6Nxk0o3kZpGx5Lf5dLsqZ/h+Lf4VpHT5Rm
        QP0M9Km8S7CUxzYy7rSSu+cGyRqfCxuZCa49CB0=
X-Google-Smtp-Source: AMsMyM6NCYekgHM9rv/dW387chTV1IB4ry+zxrY9HaV9/N6RLNY/HZ1vgWspcOy3Cq+AW/Pw+HwduLXsuo069p96DGg=
X-Received: by 2002:a17:907:7f8b:b0:7ad:b45d:4e9a with SMTP id
 qk11-20020a1709077f8b00b007adb45d4e9amr5646257ejc.421.1667126476654; Sun, 30
 Oct 2022 03:41:16 -0700 (PDT)
MIME-Version: 1.0
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Sun, 30 Oct 2022 18:40:40 +0800
Message-ID: <CAO4mrfc3sbZVj3QOdAVFqrZp+mEuPQTtQCQsQy-07W_BEFqZ2Q@mail.gmail.com>
Subject: INFO: task hung in fscrypt_ioctl_set_policy
To:     tytso@mit.edu, jaegeuk@kernel.org, ebiggers@kernel.org
Cc:     linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Dear Linux Developer,

Recently when using our tool to fuzz kernel, the following crash was triggered:

HEAD commit: 64570fbc14f8 Linux 5.15-rc5
git tree: upstream
compiler: gcc 8.0.1
console output:
https://drive.google.com/file/d/1QcXGrdd3Li0ylo1WBfswWukWV__QZS4h/view?usp=share_link
kernel config: https://drive.google.com/file/d/1uDOeEYgJDcLiSOrx9W8v2bqZ6uOA_55t/view?usp=share_link

Unfortunately, I don't have any reproducer for this crash yet.

IMPORTANT: if you fix the bug, please add the following tag to the commit:
Reported-by: Wei Chen <harperchen1110@gmail.com>

INFO: task syz-executor.0:29056 blocked for more than 143 seconds.
      Not tainted 5.15.0-rc5 #1
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor.0  state:D stack:14632 pid:29056 ppid:  6574 flags:0x00000004
Call Trace:
 __schedule+0x4a1/0x1720
 schedule+0x36/0xe0
 rwsem_down_write_slowpath+0x322/0x7a0
 fscrypt_ioctl_set_policy+0x11f/0x2a0
 __f2fs_ioctl+0x1a9f/0x5780
 f2fs_ioctl+0x89/0x3a0
 __x64_sys_ioctl+0xe8/0x140
 do_syscall_64+0x34/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x4692c9
RSP: 002b:00007f9fecafbc38 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004692c9
RDX: 0000000020002900 RSI: 00000000800c6613 RDI: 0000000000000003
RBP: 000000000119c1d8 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119c1d4
R13: 0000000000000000 R14: 000000000119c1c8 R15: 00007fffbfabbc40

Showing all locks held in the system:
1 lock held by khungtaskd/29:
 #0: ffffffff8641dee0 (rcu_read_lock){....}-{1:2}, at:
debug_show_all_locks+0x15/0x17a
1 lock held by kswapd0/269:
1 lock held by in:imklog/6194:
 #0: ffff888100174ef0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x92/0xa0
1 lock held by systemd-udevd/16539:
3 locks held by syz-executor.0/29046:
2 locks held by syz-executor.0/29056:
 #0: ffff88811912f460 (sb_writers#22){.+.+}-{0:0}, at:
fscrypt_ioctl_set_policy+0xfc/0x2a0
 #1: ffff88810a98e3f8 (&type->i_mutex_dir_key#12){++++}-{3:3}, at:
fscrypt_ioctl_set_policy+0x11f/0x2a0

=============================================

NMI backtrace for cpu 1
CPU: 1 PID: 29 Comm: khungtaskd Not tainted 5.15.0-rc5 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
Call Trace:
 dump_stack_lvl+0xcd/0x134
 nmi_cpu_backtrace.cold.8+0xf3/0x118
 nmi_trigger_cpumask_backtrace+0x18f/0x1c0
 watchdog+0x9a0/0xb10
 kthread+0x1a6/0x1e0
 ret_from_fork+0x1f/0x30
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 PID: 2973 Comm: systemd-journal Not tainted 5.15.0-rc5 #1
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
RIP: 0010:lock_is_held_type+0xff/0x140
Code: 10 00 00 ba ff ff ff ff 65 0f c1 15 cb 92 43 7b 83 fa 01 75 28
9c 58 f6 c4 02 75 3c 41 f7 c7 00 02 00 00 74 01 fb 48 83 c4 08 <44> 89
e8 5b 5d 41 5c 41 5d 41 5e 41 5f c3 45 31 ed eb ba 0f 0b 48
RSP: 0018:ffffc9000079bd80 EFLAGS: 00000292
RAX: 0000000000000046 RBX: 0000000000000000 RCX: 0000000000000001
RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffffff8641dea0 R08: 0000000000000000 R09: 0000000000000001
R10: ffffffff86462280 R11: 0000000000000000 R12: ffff8881050bd280
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000246
FS:  00007f0a317238c0(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0a2d3c2000 CR3: 0000000012f8f000 CR4: 00000000003506f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 ___might_sleep+0x21/0x150
 kmem_cache_alloc+0x279/0x310
 getname_flags+0x5f/0x2c0
 do_sys_openat2+0x3c8/0x6a0
 do_sys_open+0x84/0xe0
 do_syscall_64+0x34/0xb0
 entry_SYSCALL_64_after_hwframe+0x44/0xae
RIP: 0033:0x7f0a30cb385d
Code: bb 20 00 00 75 10 b8 02 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31
c3 48 83 ec 08 e8 1e f6 ff ff 48 89 04 24 b8 02 00 00 00 0f 05 <48> 8b
3c 24 48 89 c2 e8 67 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
RSP: 002b:00007fff8f43b630 EFLAGS: 00000293 ORIG_RAX: 0000000000000002
RAX: ffffffffffffffda RBX: 00007fff8f43b940 RCX: 00007f0a30cb385d
RDX: 00000000000001a0 RSI: 0000000000080042 RDI: 0000555919efe460
RBP: 000000000000000d R08: 000000000000ffc0 R09: 00000000ffffffff
R10: 0000000000000069 R11: 0000000000000293 R12: 00000000ffffffff
R13: 0000555919ef1040 R14: 00007fff8f43b900 R15: 0000555919efe280
----------------
Code disassembly (best guess):
   0: 10 00                adc    %al,(%rax)
   2: 00 ba ff ff ff ff    add    %bh,-0x1(%rdx)
   8: 65 0f c1 15 cb 92 43 xadd   %edx,%gs:0x7b4392cb(%rip)        # 0x7b4392db
   f: 7b
  10: 83 fa 01              cmp    $0x1,%edx
  13: 75 28                jne    0x3d
  15: 9c                    pushfq
  16: 58                    pop    %rax
  17: f6 c4 02              test   $0x2,%ah
  1a: 75 3c                jne    0x58
  1c: 41 f7 c7 00 02 00 00 test   $0x200,%r15d
  23: 74 01                je     0x26
  25: fb                    sti
  26: 48 83 c4 08          add    $0x8,%rsp
* 2a: 44 89 e8              mov    %r13d,%eax <-- trapping instruction
  2d: 5b                    pop    %rbx
  2e: 5d                    pop    %rbp
  2f: 41 5c                pop    %r12
  31: 41 5d                pop    %r13
  33: 41 5e                pop    %r14
  35: 41 5f                pop    %r15
  37: c3                    retq
  38: 45 31 ed              xor    %r13d,%r13d
  3b: eb ba                jmp    0xfffffff7
  3d: 0f 0b                ud2
  3f: 48                    rex.W

Best,
Wei
