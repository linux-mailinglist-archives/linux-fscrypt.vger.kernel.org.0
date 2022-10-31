Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 217376138CF
	for <lists+linux-fscrypt@lfdr.de>; Mon, 31 Oct 2022 15:18:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231187AbiJaOSm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 31 Oct 2022 10:18:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34582 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231221AbiJaOSl (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 31 Oct 2022 10:18:41 -0400
Received: from mail-ed1-x52b.google.com (mail-ed1-x52b.google.com [IPv6:2a00:1450:4864:20::52b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D200B1006;
        Mon, 31 Oct 2022 07:18:38 -0700 (PDT)
Received: by mail-ed1-x52b.google.com with SMTP id z97so17628974ede.8;
        Mon, 31 Oct 2022 07:18:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=Tcfg9cnC5DgS/ceRVQLEBuHqbTgIx/JU/ra9EigpGYk=;
        b=BSA5yIEGUsg6m9PuFLnhxqTQbSn8twJWCsBKC6ILmBsugeDdPaezrV2xM1KM7WIyqq
         87LxanNDa7VKpakgNYw7MCEtfhjzsU78/qo6eGvwhmut/qwZEA4RHQycdsWMb+nAptTu
         fxxfBLmBAALBc9nKjDtmwTDxx4rYEWGcF/HY8UIf4XxNwXw+0rEG85jx4/nGw+xWwBPJ
         tqpVXbs6tAtkd1HKHP5w/6JOrsDAOWaaTq2TTaoKPsl22Thzh85vkBV9F04qZ9/nTICa
         HsArv1I5RG41SX4dasvsXawdhL5DGMb5L0B3RG6s2jdmWNzHGsTPHcJuURIMQ5TFCoT9
         bkfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Tcfg9cnC5DgS/ceRVQLEBuHqbTgIx/JU/ra9EigpGYk=;
        b=InfTZozz75Ff52+nRD4ECxGERI7XCjC3wnH/r8iBsgdPoelvepUmFEnSPx4/IucSYa
         ux2hzLrN+qADrC4W3oe/IY0l/jZ1ka9Y2Eu9ahq0PfLtrtbkLfUiYOF7+ylqAqZyX/aJ
         JdOXG2RTFVo0JoaV28UqlIZEA/KUj3vtIwIcTOlhTQ2qfeEshCsk+r2J35T5h/jwY2M9
         tBblAD3IvA/DoMdwJFO22f+Kx7l6ZO/NGwYGT1eiitpOlIZJZUQMzf8M4uwt48AUCl2o
         kAtzgMeZXdObmnIwj1sG0+qkTvWe67ey86e3D06wH9Csi1DG+vHhPHMaxBSym1/KoYl5
         8orA==
X-Gm-Message-State: ACrzQf3Xw0/mmFX/jvi86i6jfJB+TMvqBmnBQttQnb9kyY6a9fJPy84l
        PUzZN7DhLep5cA6YxH8JXa8r1LAyqjaV22OmRxTcTs4Z9cbZwA==
X-Google-Smtp-Source: AMsMyM7f5dppb6YXW7S8Qmt83maW4M80LAkJ0RcW1m+e0LtiRKc67madka8tYzZoGwXRr2cfJ+ygb911FtDgsv8O0Uk=
X-Received: by 2002:aa7:c14b:0:b0:461:c47d:48cf with SMTP id
 r11-20020aa7c14b000000b00461c47d48cfmr13495724edp.83.1667225917051; Mon, 31
 Oct 2022 07:18:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAO4mrfc3sbZVj3QOdAVFqrZp+mEuPQTtQCQsQy-07W_BEFqZ2Q@mail.gmail.com>
In-Reply-To: <CAO4mrfc3sbZVj3QOdAVFqrZp+mEuPQTtQCQsQy-07W_BEFqZ2Q@mail.gmail.com>
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Mon, 31 Oct 2022 22:18:02 +0800
Message-ID: <CAO4mrfexzxeYwAkvWGfg=tEiczUWarO6y68KFD9EG9qZtGejng@mail.gmail.com>
Subject: Re: INFO: task hung in fscrypt_ioctl_set_policy
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

Dear Linux developers,

Here is the link to the reproducers.

C reproducer: https://drive.google.com/file/d/1mduYsYuoOKemH3qkvpDQwnAHAaaLUp0Y/view?usp=share_link
Syz reproducer:
https://drive.google.com/file/d/1mu-_w7dy_562vWRlQvTRbcBjG4_G7b2L/view?usp=share_link

The bug persists in the latest commit, v5.15.76 (4f5365f77018). I hope
it is helpful to you.

[ 1782.137186][   T30] INFO: task a.out:6910 blocked for more than 143 seconds.
[ 1782.139217][   T30]       Not tainted 5.15.76 #5
[ 1782.140388][   T30] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[ 1782.142524][   T30] task:a.out           state:D stack:14296 pid:
6910 ppid:  6532 flags:0x00004004
[ 1782.144799][   T30] Call Trace:
[ 1782.145623][   T30]  <TASK>
[ 1782.146316][   T30]  __schedule+0x3e8/0x1850
[ 1782.152029][   T30]  ? mark_held_locks+0x49/0x70
[ 1782.153533][   T30]  ? mark_held_locks+0x10/0x70
[ 1782.154759][   T30]  ? __down_write_common.part.14+0x31f/0x7b0
[ 1782.156159][   T30]  schedule+0x4e/0xe0
[ 1782.158314][   T30]  __down_write_common.part.14+0x324/0x7b0
[ 1782.159704][   T30]  ? fscrypt_ioctl_set_policy+0xe0/0x200
[ 1782.161050][   T30]  fscrypt_ioctl_set_policy+0xe0/0x200
[ 1782.162330][   T30]  __f2fs_ioctl+0x9d6/0x45e0
[ 1782.163417][   T30]  f2fs_ioctl+0x64/0x240
[ 1782.164404][   T30]  ? __f2fs_ioctl+0x45e0/0x45e0
[ 1782.165554][   T30]  __x64_sys_ioctl+0xb6/0x100
[ 1782.166662][   T30]  do_syscall_64+0x34/0xb0
[ 1782.169947][   T30]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
[ 1782.171348][   T30] RIP: 0033:0x7f55690bb469
[ 1782.172385][   T30] RSP: 002b:00007f556976aef8 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[ 1782.174344][   T30] RAX: ffffffffffffffda RBX: 0000000000000000
RCX: 00007f55690bb469
[ 1782.176198][   T30] RDX: 0000000020002900 RSI: 00000000800c6613
RDI: 0000000000000003
[ 1782.179056][   T30] RBP: 00007f556976af20 R08: 0000000000000000
R09: 0000000000000000
[ 1782.180945][   T30] R10: 0000000000000000 R11: 0000000000000246
R12: 00007ffee37a15ce
[ 1782.182812][   T30] R13: 00007ffee37a15cf R14: 00007f556974b000
R15: 0000000000000003
[ 1782.184690][   T30]  </TASK>
[ 1782.185445][   T30]
[ 1782.185445][   T30] Showing all locks held in the system:
[ 1782.189142][   T30] 1 lock held by khungtaskd/30:
[ 1782.190295][   T30]  #0: ffffffff85a1dc60
(rcu_read_lock){....}-{1:2}, at: debug_show_all_locks+0xe/0x1a0
[ 1782.192615][   T30] 1 lock held by in:imklog/6238:
[ 1782.193768][   T30]  #0: ffff88810a68f6f0
(&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x55/0x60
[ 1782.204980][   T30] 2 locks held by a.out/6900:
[ 1782.206094][   T30] 2 locks held by a.out/6910:
[ 1782.208314][   T30]  #0: ffff888011f73460
(sb_writers#14){.+.+}-{0:0}, at: fscrypt_ioctl_set_policy+0xc6/0x200
[ 1782.210728][   T30]  #1: ffff888013f49350
(&type->i_mutex_dir_key#8){+.+.}-{3:3}, at:
fscrypt_ioctl_set_policy+0xe0/0x200
[ 1782.213346][   T30]
[ 1782.213891][   T30] =============================================
[ 1782.213891][   T30]
[ 1782.215851][   T30] NMI backtrace for cpu 1
[ 1782.216913][   T30] CPU: 1 PID: 30 Comm: khungtaskd Not tainted 5.15.76 #5
[ 1782.218539][   T30] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
[ 1782.221460][   T30] Call Trace:
[ 1782.222289][   T30]  <TASK>
[ 1782.223009][   T30]  dump_stack_lvl+0x8d/0xcf
[ 1782.224108][   T30]  nmi_cpu_backtrace+0x1e9/0x210
[ 1782.225309][   T30]  ? lapic_can_unplug_cpu+0x90/0x90
[ 1782.226550][   T30]  nmi_trigger_cpumask_backtrace+0x129/0x190
[ 1782.228048][   T30]  watchdog+0x4e1/0x970
[ 1782.229093][   T30]  ? hungtask_pm_notify+0x70/0x70
[ 1782.230337][   T30]  kthread+0x178/0x1b0
[ 1782.231359][   T30]  ? set_kthread_struct+0x50/0x50
[ 1782.232617][   T30]  ret_from_fork+0x1f/0x30
[ 1782.233731][   T30]  </TASK>
[ 1782.234606][   T30] Sending NMI from CPU 1 to CPUs 0:
[ 1782.235927][    C0] NMI backtrace for cpu 0
[ 1782.235933][    C0] CPU: 0 PID: 2974 Comm: systemd-journal Not
tainted 5.15.76 #5
[ 1782.235940][    C0] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
[ 1782.235946][    C0] RIP: 0010:__lock_acquire+0x840/0x1d90
[ 1782.235958][    C0] Code: d2 75 17 e8 e2 26 ff 00 85 c0 74 0e 8b 05
60 e4 e1 04 85 c0 0f 84 29 02 00 00 31 c0 48 83 78 40 00 75 02 0f 0b
0f b7 44 24 28 <8b> 4c 24 30 c1 e0 0d 66 0b 44 24 20 98 2b 44 24 18 33
44 24 10 89
[ 1782.235965][    C0] RSP: 0018:ffffc9000080bdb0 EFLAGS: 00000082
[ 1782.235971][    C0] RAX: 0000000000000000 RBX: ffff88801024dd60
RCX: 0000000000000008
[ 1782.235975][    C0] RDX: 0000000000000008 RSI: 0000000000000000
RDI: 0000000000000000
[ 1782.235979][    C0] RBP: 00000000000000a4 R08: 0000000000000000
R09: 0000000000000001
[ 1782.235983][    C0] R10: 0000000000000000 R11: 0000000000000000
R12: 0000000000000001
[ 1782.235986][    C0] R13: ffff88801024d340 R14: ffff88801024dd60
R15: ffffffffffffffff
[ 1782.235991][    C0] FS:  00007f88e2cda8c0(0000)
GS:ffff88807dc00000(0000) knlGS:0000000000000000
[ 1782.235999][    C0] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1782.236003][    C0] CR2: 00007f88e0039008 CR3: 0000000011fc2000
CR4: 00000000003506f0
[ 1782.236007][    C0] DR0: 0000000000000000 DR1: 0000000000000000
DR2: 0000000000000000
[ 1782.236011][    C0] DR3: 0000000000000000 DR6: 00000000fffe0ff0
DR7: 0000000000000400
[ 1782.236015][    C0] Call Trace:
[ 1782.236017][    C0]  <TASK>
[ 1782.236022][    C0]  lock_acquire+0x294/0x350
[ 1782.236030][    C0]  ? __context_tracking_exit+0x88/0x1f0
[ 1782.236040][    C0]  ? __context_tracking_enter+0x100/0x210
[ 1782.236047][    C0]  vtime_user_exit+0x50/0xe0
[ 1782.236056][    C0]  ? __context_tracking_exit+0x88/0x1f0
[ 1782.236062][    C0]  __context_tracking_exit+0x88/0x1f0
[ 1782.236069][    C0]  syscall_enter_from_user_mode+0x4a/0x70
[ 1782.236077][    C0]  do_syscall_64+0x15/0xb0
[ 1782.236083][    C0]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
[ 1782.236092][    C0] RIP: 0033:0x7f88e1f73f17
[ 1782.236098][    C0] Code: ff ff ff 48 8b 4d a0 0f b7 51 fe 48 8b 4d
a8 66 89 54 08 fe e9 1a ff ff ff 66 2e 0f 1f 84 00 00 00 00 00 b8 27
00 00 00 0f 05 <c3> 0f 1f 84 00 00 00 00 00 b8 6e 00 00 00 0f 05 c3 0f
1f 84 00 00
[ 1782.236104][    C0] RSP: 002b:00007fff9ce26b28 EFLAGS: 00000202
ORIG_RAX: 0000000000000027
[ 1782.236110][    C0] RAX: ffffffffffffffda RBX: 000055d5d4d9d1e0
RCX: 00007f88e1f73f17
[ 1782.236114][    C0] RDX: 00000000ffffffff RSI: 00007fff9ce26bb0
RDI: 000055d5d4d9d1e0
[ 1782.236118][    C0] RBP: 0000000000000b9e R08: 00007fff9cedf080
R09: 00007fff9cedf080
[ 1782.236122][    C0] R10: 0000000000034d62 R11: 0000000000000202
R12: 00007fff9ce26bb0
[ 1782.236126][    C0] R13: 00007fff9ce26ba8 R14: 000055d5d3122958
R15: 0005ec5535de5711
[ 1782.236132][    C0]  </TASK>
[ 1782.267071][   T30] Kernel panic - not syncing: hung_task: blocked tasks
[ 1782.301186][   T30] CPU: 1 PID: 30 Comm: khungtaskd Not tainted 5.15.76 #5
[ 1782.302914][   T30] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
[ 1782.305923][   T30] Call Trace:
[ 1782.306711][   T30]  <TASK>
[ 1782.307482][   T30]  dump_stack_lvl+0x8d/0xcf
[ 1782.308605][   T30]  panic+0x165/0x3ed
[ 1782.309572][   T30]  ? watchdog+0x4f8/0x970
[ 1782.310645][   T30]  watchdog+0x504/0x970
[ 1782.311670][   T30]  ? hungtask_pm_notify+0x70/0x70
[ 1782.312906][   T30]  kthread+0x178/0x1b0
[ 1782.313914][   T30]  ? set_kthread_struct+0x50/0x50
[ 1782.315142][   T30]  ret_from_fork+0x1f/0x30
[ 1782.316235][   T30]  </TASK>
[ 1782.317156][   T30] Kernel Offset: disabled
[ 1782.318271][   T30] Rebooting in 86400 seconds..

Best,
Wei


On Sun, 30 Oct 2022 at 18:40, Wei Chen <harperchen1110@gmail.com> wrote:
>
> Dear Linux Developer,
>
> Recently when using our tool to fuzz kernel, the following crash was triggered:
>
> HEAD commit: 64570fbc14f8 Linux 5.15-rc5
> git tree: upstream
> compiler: gcc 8.0.1
> console output:
> https://drive.google.com/file/d/1QcXGrdd3Li0ylo1WBfswWukWV__QZS4h/view?usp=share_link
> kernel config: https://drive.google.com/file/d/1uDOeEYgJDcLiSOrx9W8v2bqZ6uOA_55t/view?usp=share_link
>
> Unfortunately, I don't have any reproducer for this crash yet.
>
> IMPORTANT: if you fix the bug, please add the following tag to the commit:
> Reported-by: Wei Chen <harperchen1110@gmail.com>
>
> INFO: task syz-executor.0:29056 blocked for more than 143 seconds.
>       Not tainted 5.15.0-rc5 #1
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor.0  state:D stack:14632 pid:29056 ppid:  6574 flags:0x00000004
> Call Trace:
>  __schedule+0x4a1/0x1720
>  schedule+0x36/0xe0
>  rwsem_down_write_slowpath+0x322/0x7a0
>  fscrypt_ioctl_set_policy+0x11f/0x2a0
>  __f2fs_ioctl+0x1a9f/0x5780
>  f2fs_ioctl+0x89/0x3a0
>  __x64_sys_ioctl+0xe8/0x140
>  do_syscall_64+0x34/0xb0
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x4692c9
> RSP: 002b:00007f9fecafbc38 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00000000004692c9
> RDX: 0000000020002900 RSI: 00000000800c6613 RDI: 0000000000000003
> RBP: 000000000119c1d8 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 000000000119c1d4
> R13: 0000000000000000 R14: 000000000119c1c8 R15: 00007fffbfabbc40
>
> Showing all locks held in the system:
> 1 lock held by khungtaskd/29:
>  #0: ffffffff8641dee0 (rcu_read_lock){....}-{1:2}, at:
> debug_show_all_locks+0x15/0x17a
> 1 lock held by kswapd0/269:
> 1 lock held by in:imklog/6194:
>  #0: ffff888100174ef0 (&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x92/0xa0
> 1 lock held by systemd-udevd/16539:
> 3 locks held by syz-executor.0/29046:
> 2 locks held by syz-executor.0/29056:
>  #0: ffff88811912f460 (sb_writers#22){.+.+}-{0:0}, at:
> fscrypt_ioctl_set_policy+0xfc/0x2a0
>  #1: ffff88810a98e3f8 (&type->i_mutex_dir_key#12){++++}-{3:3}, at:
> fscrypt_ioctl_set_policy+0x11f/0x2a0
>
> =============================================
>
> NMI backtrace for cpu 1
> CPU: 1 PID: 29 Comm: khungtaskd Not tainted 5.15.0-rc5 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
> Call Trace:
>  dump_stack_lvl+0xcd/0x134
>  nmi_cpu_backtrace.cold.8+0xf3/0x118
>  nmi_trigger_cpumask_backtrace+0x18f/0x1c0
>  watchdog+0x9a0/0xb10
>  kthread+0x1a6/0x1e0
>  ret_from_fork+0x1f/0x30
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0
> CPU: 0 PID: 2973 Comm: systemd-journal Not tainted 5.15.0-rc5 #1
> Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS
> rel-1.13.0-48-gd9c812dda519-prebuilt.qemu.org 04/01/2014
> RIP: 0010:lock_is_held_type+0xff/0x140
> Code: 10 00 00 ba ff ff ff ff 65 0f c1 15 cb 92 43 7b 83 fa 01 75 28
> 9c 58 f6 c4 02 75 3c 41 f7 c7 00 02 00 00 74 01 fb 48 83 c4 08 <44> 89
> e8 5b 5d 41 5c 41 5d 41 5e 41 5f c3 45 31 ed eb ba 0f 0b 48
> RSP: 0018:ffffc9000079bd80 EFLAGS: 00000292
> RAX: 0000000000000046 RBX: 0000000000000000 RCX: 0000000000000001
> RDX: 0000000000000001 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffffff8641dea0 R08: 0000000000000000 R09: 0000000000000001
> R10: ffffffff86462280 R11: 0000000000000000 R12: ffff8881050bd280
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000246
> FS:  00007f0a317238c0(0000) GS:ffff88807dc00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f0a2d3c2000 CR3: 0000000012f8f000 CR4: 00000000003506f0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
>  ___might_sleep+0x21/0x150
>  kmem_cache_alloc+0x279/0x310
>  getname_flags+0x5f/0x2c0
>  do_sys_openat2+0x3c8/0x6a0
>  do_sys_open+0x84/0xe0
>  do_syscall_64+0x34/0xb0
>  entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x7f0a30cb385d
> Code: bb 20 00 00 75 10 b8 02 00 00 00 0f 05 48 3d 01 f0 ff ff 73 31
> c3 48 83 ec 08 e8 1e f6 ff ff 48 89 04 24 b8 02 00 00 00 0f 05 <48> 8b
> 3c 24 48 89 c2 e8 67 f6 ff ff 48 89 d0 48 83 c4 08 48 3d 01
> RSP: 002b:00007fff8f43b630 EFLAGS: 00000293 ORIG_RAX: 0000000000000002
> RAX: ffffffffffffffda RBX: 00007fff8f43b940 RCX: 00007f0a30cb385d
> RDX: 00000000000001a0 RSI: 0000000000080042 RDI: 0000555919efe460
> RBP: 000000000000000d R08: 000000000000ffc0 R09: 00000000ffffffff
> R10: 0000000000000069 R11: 0000000000000293 R12: 00000000ffffffff
> R13: 0000555919ef1040 R14: 00007fff8f43b900 R15: 0000555919efe280
> ----------------
> Code disassembly (best guess):
>    0: 10 00                adc    %al,(%rax)
>    2: 00 ba ff ff ff ff    add    %bh,-0x1(%rdx)
>    8: 65 0f c1 15 cb 92 43 xadd   %edx,%gs:0x7b4392cb(%rip)        # 0x7b4392db
>    f: 7b
>   10: 83 fa 01              cmp    $0x1,%edx
>   13: 75 28                jne    0x3d
>   15: 9c                    pushfq
>   16: 58                    pop    %rax
>   17: f6 c4 02              test   $0x2,%ah
>   1a: 75 3c                jne    0x58
>   1c: 41 f7 c7 00 02 00 00 test   $0x200,%r15d
>   23: 74 01                je     0x26
>   25: fb                    sti
>   26: 48 83 c4 08          add    $0x8,%rsp
> * 2a: 44 89 e8              mov    %r13d,%eax <-- trapping instruction
>   2d: 5b                    pop    %rbx
>   2e: 5d                    pop    %rbp
>   2f: 41 5c                pop    %r12
>   31: 41 5d                pop    %r13
>   33: 41 5e                pop    %r14
>   35: 41 5f                pop    %r15
>   37: c3                    retq
>   38: 45 31 ed              xor    %r13d,%r13d
>   3b: eb ba                jmp    0xfffffff7
>   3d: 0f 0b                ud2
>   3f: 48                    rex.W
>
> Best,
> Wei
