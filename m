Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 374CB615C60
	for <lists+linux-fscrypt@lfdr.de>; Wed,  2 Nov 2022 07:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229462AbiKBGle (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 2 Nov 2022 02:41:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229436AbiKBGld (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 2 Nov 2022 02:41:33 -0400
Received: from mail-ej1-x629.google.com (mail-ej1-x629.google.com [IPv6:2a00:1450:4864:20::629])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D191025EAE;
        Tue,  1 Nov 2022 23:41:31 -0700 (PDT)
Received: by mail-ej1-x629.google.com with SMTP id y14so42732356ejd.9;
        Tue, 01 Nov 2022 23:41:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=ypTbJ376EOLt/ST14iIVRPV6JdKL7100xY4zsvFdU5A=;
        b=BwYR+IbgACJR4a1qRB6Z49qV7Qo7eIzuHQcYG/xZdC9O76rnJGk/kh/luezjqhXg8/
         KKdbxJcs90ehHxAZ5C4/mp7eqgzw8dfBJ6PGhbmYETWScA2ps0E/jcXkQgprsQu89/VX
         X5x9RUCbRSblKsSYGyVut+DQcygKuWCvpkZ3vuY6G1BxAU6n7vgJ1v4Gm/aoHf7O8ZJ+
         L5bzhbD7rSeMhRfaUddOjvNNtGeQQm636HBH9hl/NE49ezlk5jMnaR8/c2MHvoEN0smn
         bazdxeW9DOscEvULNaZdxukKDHWnOGJniQZkNixoskdCOdAMlPvfBFW9mO5tR5UsI19l
         yyNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ypTbJ376EOLt/ST14iIVRPV6JdKL7100xY4zsvFdU5A=;
        b=17T/aajq9Hvx3uzBCI03CltcGRxpx8jZlb+cP+QWerYbwNSPgbSNs9QW9S/Ta6t5Xl
         vh6evVPjjy0pwVIUhjti9GhWYmC+C1GRijXhwnViUc2vxIzG7anYUlHwAFYcYH8zW/YL
         nGH3zdvtj82rQEEWz4By9BlW2Nv3Q9MdCqRhl1jtuHkvm+hXhuiXj5GWElrpXdN5h1Bk
         +yEHWQWBkKsbr8FSmc9FsH1WM8hWpgWf70wlt/nTo76IuAjfKSuvEqdKIHzBWoou7UW1
         EN6Uu/bRvqXZYbArAmIJK68KR1SEutVPfeW6pm18h1L8ukb1V59clBFl9L4E8fAISml1
         4scA==
X-Gm-Message-State: ACrzQf2hDukdOLRllXYjIGnf07ZnZg+Ys40feoJVMIOthyThr2fPmSvk
        qBWlR0vce+HwYL66yAL9oYhGP202c/ZJiPmheDk+BTSkfyI=
X-Google-Smtp-Source: AMsMyM49xO3cCF+FoWUO6im/FUC2j0mVnNLDSWinvuTjxdK6ijZZseFDAUJxk29F6EY8v6RDAk6QJrDe3Cldhetrqrc=
X-Received: by 2002:a17:907:a05c:b0:7ad:f563:815d with SMTP id
 gz28-20020a170907a05c00b007adf563815dmr5120608ejc.371.1667371289978; Tue, 01
 Nov 2022 23:41:29 -0700 (PDT)
MIME-Version: 1.0
References: <CAO4mrfc3sbZVj3QOdAVFqrZp+mEuPQTtQCQsQy-07W_BEFqZ2Q@mail.gmail.com>
 <CAO4mrfexzxeYwAkvWGfg=tEiczUWarO6y68KFD9EG9qZtGejng@mail.gmail.com> <Y2ILlpqFQVO9fH8B@sol.localdomain>
In-Reply-To: <Y2ILlpqFQVO9fH8B@sol.localdomain>
From:   Wei Chen <harperchen1110@gmail.com>
Date:   Wed, 2 Nov 2022 14:40:54 +0800
Message-ID: <CAO4mrfdDexaWy9jGg2exsUA=9fYt-vsQGv=JzQMe1Dd4jkig+Q@mail.gmail.com>
Subject: Re: f2fs_empty_dir() can be extremely slow on malicious disk images
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net, tytso@mit.edu,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
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

Dear Eric,

Thank you for the email and advice. The bug persists in upstream Linux
6.0 4fe89d07dc.

[  222.604894][   T23] INFO: task a.out:6867 blocked for more than 143 seconds.
[  222.606536][   T23]       Not tainted 6.0.0 #35
[  222.606833][   T23] "echo 0 >
/proc/sys/kernel/hung_task_timeout_secs" disables this message.
[  222.607369][   T23] task:a.out           state:D stack:25312 pid:
6867 ppid:  6611 flags:0x00004004
[  222.607948][   T23] Call Trace:
[  222.608161][   T23]  <TASK>
[  222.608369][   T23]  __schedule+0xbc5/0x1180
[  222.608673][   T23]  ? __sched_text_start+0x8/0x8
[  222.608986][   T23]  ? print_irqtrace_events+0x220/0x220
[  222.609333][   T23]  ? _raw_spin_lock_irq+0xba/0xf0
[  222.609669][   T23]  schedule+0xcb/0x190
[  222.609949][   T23]  rwsem_down_write_slowpath+0xf1c/0x1340
[  222.610326][   T23]  ? rwsem_down_read_slowpath+0x920/0x920
[  222.610689][   T23]  ? read_lock_is_recursive+0x10/0x10
[  222.611031][   T23]  ? read_lock_is_recursive+0x10/0x10
[  222.611379][   T23]  ? __lock_acquire+0x6080/0x6080
[  222.611696][   T23]  ? rcu_read_lock_any_held+0xb1/0x130
[  222.612036][   T23]  down_write+0x163/0x170
[  222.612308][   T23]  ? down_read_killable+0x80/0x80
[  222.612639][   T23]  ? __mnt_want_write+0x221/0x2a0
[  222.612963][   T23]  fscrypt_ioctl_set_policy+0x249/0x1500
[  222.613318][   T23]  ? arch_stack_walk+0x98/0xe0
[  222.613629][   T23]  ? fscrypt_policy_from_context+0x600/0x600
[  222.614017][   T23]  ? stack_trace_save+0x104/0x1e0
[  222.614344][   T23]  ? stack_trace_snprint+0xf0/0xf0
[  222.614681][   T23]  ? __stack_depot_save+0x33/0x490
[  222.656775][   T23]  ? kfree+0xda/0x350
[  222.657043][   T23]  ? kasan_set_track+0x4f/0x60
[  222.657345][   T23]  ? kasan_set_track+0x3d/0x60
[  222.657642][   T23]  ? kasan_set_free_info+0x1f/0x40
[  222.657967][   T23]  ? ____kasan_slab_free+0xd8/0x120
[  222.658295][   T23]  ? slab_free_freelist_hook+0x12e/0x1a0
[  222.658645][   T23]  ? tomoyo_path_number_perm+0x5be/0x790
[  222.658992][   T23]  ? security_file_ioctl+0x55/0xb0
[  222.659326][   T23]  ? __se_sys_ioctl+0x48/0x170
[  222.659629][   T23]  ? do_syscall_64+0x3d/0x90
[  222.659925][   T23]  __f2fs_ioctl+0x2ee5/0xf320
[  222.660232][   T23]  ? rcu_read_lock_sched_held+0x87/0x110
[  222.660597][   T23]  ? __bpf_trace_rcu_stall_warning+0x10/0x10
[  222.660969][   T23]  ? lockdep_hardirqs_on_prepare+0x428/0x790
[  222.661357][   T23]  ? do_vfs_ioctl+0xc35/0x29e0
[  222.661671][   T23]  ? __ia32_compat_sys_ioctl+0xb90/0xb90
[  222.662035][   T23]  ? __lock_acquire+0x6080/0x6080
[  222.662369][   T23]  ? f2fs_ioctl+0x1d0/0x1d0
[  222.662652][   T23]  ? slab_free_freelist_hook+0x12e/0x1a0
[  222.663004][   T23]  ? tomoyo_path_number_perm+0x5be/0x790
[  222.663372][   T23]  ? kfree+0xda/0x350
[  222.663630][   T23]  ? tomoyo_path_number_perm+0x627/0x790
[  222.663992][   T23]  ? tomoyo_check_path_acl+0x1c0/0x1c0
[  222.664348][   T23]  ? rcu_read_lock_sched_held+0x87/0x110
[  222.664706][   T23]  ? read_lock_is_recursive+0x10/0x10
[  222.669813][   T23]  ? f2fs_ioctl+0x130/0x1d0
[  222.670117][   T23]  ? f2fs_precache_extents+0x3c0/0x3c0
[  222.670474][   T23]  __se_sys_ioctl+0xfb/0x170
[  222.670776][   T23]  do_syscall_64+0x3d/0x90
[  222.671063][   T23]  entry_SYSCALL_64_after_hwframe+0x63/0xcd
[  222.671441][   T23] RIP: 0033:0x7fb0400e4469
[  222.671736][   T23] RSP: 002b:00007fb040b45ef8 EFLAGS: 00000246
ORIG_RAX: 0000000000000010
[  222.672288][   T23] RAX: ffffffffffffffda RBX: 0000000000000000
RCX: 00007fb0400e4469
[  222.672786][   T23] RDX: 0000000020002900 RSI: 00000000800c6613
RDI: 0000000000000003
[  222.673293][   T23] RBP: 00007fb040b45f20 R08: 0000000000000000
R09: 0000000000000000
[  222.673798][   T23] R10: 0000000000000000 R11: 0000000000000246
R12: 00007ffc3dcf28be
[  222.674303][   T23] R13: 00007ffc3dcf28bf R14: 00007fb040b26000
R15: 0000000000000003
[  222.684859][   T23]  </TASK>
[  222.685083][   T23]
[  222.685083][   T23] Showing all locks held in the system:
[  222.685564][   T23] 1 lock held by rcu_tasks_kthre/13:
[  222.685897][   T23]  #0: ffffffff8cf22530
(rcu_tasks.tasks_gp_mutex){+.+.}-{3:3}, at:
rcu_tasks_one_gp+0x30/0xbd0
[  222.686559][   T23] 1 lock held by rcu_tasks_trace/14:
[  222.686886][   T23]  #0: ffffffff8cf22d30
(rcu_tasks_trace.tasks_gp_mutex){+.+.}-{3:3}, at:
rcu_tasks_one_gp+0x30/0xbd0
[  222.687596][   T23] 1 lock held by khungtaskd/23:
[  222.687895][   T23]  #0: ffffffff8cf22360
(rcu_read_lock){....}-{1:2}, at: rcu_lock_acquire+0x0/0x30
[  222.688519][   T23] 1 lock held by in:imklog/6313:
[  222.688829][   T23]  #0: ffff888021796368
(&f->f_pos_lock){+.+.}-{3:3}, at: __fdget_pos+0x23a/0x2d0
[  222.689420][   T23] 3 locks held by a.out/6858:
[  222.689716][   T23] 2 locks held by a.out/6867:
[  222.697525][   T23]  #0: ffff88802484c460
(sb_writers#14){.+.+}-{0:0}, at: mnt_want_write_file+0x5a/0x1f0
[  222.698147][   T23]  #1: ffff88802e539300
(&type->i_mutex_dir_key#8){+.+.}-{3:3}, at:
fscrypt_ioctl_set_policy+0x249/0x1500
[  222.698876][   T23]
[  222.699030][   T23] =============================================
[  222.699030][   T23]
[  222.699551][   T23] NMI backtrace for cpu 0
[  222.699816][   T23] CPU: 0 PID: 23 Comm: khungtaskd Not tainted 6.0.0 #35
[  222.700232][   T23] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[  222.700852][   T23] Call Trace:
[  222.701056][   T23]  <TASK>
[  222.701254][   T23]  dump_stack_lvl+0x1b1/0x28e
[  222.701550][   T23]  ? io_alloc_page_table+0xfe/0xfe
[  222.701876][   T23]  ? panic+0x81b/0x81b
[  222.702158][   T23]  ? console_unlock+0x6bd/0x6f0
[  222.702482][   T23]  nmi_cpu_backtrace+0x40e/0x440
[  222.702806][   T23]  ? vprintk_emit+0x109/0x1e0
[  222.703109][   T23]  ? nmi_trigger_cpumask_backtrace+0x280/0x280
[  222.703492][   T23]  ? _printk+0xc0/0x100
[  222.703759][   T23]  ? panic+0x81b/0x81b
[  222.704020][   T23]  ? __wake_up_klogd+0xcc/0x100
[  222.704353][   T23]  ? panic+0x81b/0x81b
[  222.704615][   T23]  ? arch_trigger_cpumask_backtrace+0x10/0x10
[  222.704998][   T23]  nmi_trigger_cpumask_backtrace+0x16a/0x280
[  222.705381][   T23]  watchdog+0xcd5/0xd20
[  222.705679][   T23]  kthread+0x266/0x300
[  222.705942][   T23]  ? hungtask_pm_notify+0x50/0x50
[  222.706256][   T23]  ? kthread_blkcg+0xd0/0xd0
[  222.706560][   T23]  ret_from_fork+0x1f/0x30
[  222.706857][   T23]  </TASK>
[  222.724848][   T23] Kernel panic - not syncing: hung_task: blocked tasks
[  222.725269][   T23] CPU: 0 PID: 23 Comm: khungtaskd Not tainted 6.0.0 #35
[  222.725691][   T23] Hardware name: QEMU Standard PC (i440FX + PIIX,
1996), BIOS 1.13.0-1ubuntu1.1 04/01/2014
[  222.726291][   T23] Call Trace:
[  222.726500][   T23]  <TASK>
[  222.726684][   T23]  dump_stack_lvl+0x1b1/0x28e
[  222.726980][   T23]  ? io_alloc_page_table+0xfe/0xfe
[  222.727297][   T23]  ? panic+0x81b/0x81b
[  222.727558][   T23]  panic+0x2c2/0x81b
[  222.727803][   T23]  ? schedule_preempt_disabled+0x20/0x20
[  222.728151][   T23]  ? nmi_trigger_cpumask_backtrace+0x206/0x280
[  222.728532][   T23]  ? asan.module_ctor+0x4/0x4
[  222.728827][   T23]  ? tick_nohz_tick_stopped+0x76/0xb0
[  222.729158][   T23]  ? arch_trigger_cpumask_backtrace+0x10/0x10
[  222.729535][   T23]  ? nmi_trigger_cpumask_backtrace+0x206/0x280
[  222.729918][   T23]  ? nmi_trigger_cpumask_backtrace+0x266/0x280
[  222.730322][   T23]  watchdog+0xd16/0xd20
[  222.730591][   T23]  kthread+0x266/0x300
[  222.730862][   T23]  ? hungtask_pm_notify+0x50/0x50
[  222.731171][   T23]  ? kthread_blkcg+0xd0/0xd0
[  222.731458][   T23]  ret_from_fork+0x1f/0x30
[  222.731742][   T23]  </TASK>
[  222.732155][   T23] Kernel Offset: disabled
[  222.732439][   T23] Rebooting in 86400 seconds..

Best,
Wei

On Wed, 2 Nov 2022 at 14:18, Eric Biggers <ebiggers@kernel.org> wrote:
>
> [+f2fs list and maintainers]
> [changed subject from "INFO: task hung in fscrypt_ioctl_set_policy"]
>
> On Mon, Oct 31, 2022 at 10:18:02PM +0800, Wei Chen wrote:
> > Dear Linux developers,
> >
> > Here is the link to the reproducers.
> >
> > C reproducer: https://drive.google.com/file/d/1mduYsYuoOKemH3qkvpDQwnAHAaaLUp0Y/view?usp=share_link
> > Syz reproducer:
> > https://drive.google.com/file/d/1mu-_w7dy_562vWRlQvTRbcBjG4_G7b2L/view?usp=share_link
> >
> > The bug persists in the latest commit, v5.15.76 (4f5365f77018). I hope
> > it is helpful to you.
> >
> > [ 1782.137186][   T30] INFO: task a.out:6910 blocked for more than 143 seconds.
> > [ 1782.139217][   T30]       Not tainted 5.15.76 #5
> > [ 1782.140388][   T30] "echo 0 >
> > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> > [ 1782.142524][   T30] task:a.out           state:D stack:14296 pid:
> > 6910 ppid:  6532 flags:0x00004004
> > [ 1782.144799][   T30] Call Trace:
> > [ 1782.145623][   T30]  <TASK>
> > [ 1782.146316][   T30]  __schedule+0x3e8/0x1850
> > [ 1782.152029][   T30]  ? mark_held_locks+0x49/0x70
> > [ 1782.153533][   T30]  ? mark_held_locks+0x10/0x70
> > [ 1782.154759][   T30]  ? __down_write_common.part.14+0x31f/0x7b0
> > [ 1782.156159][   T30]  schedule+0x4e/0xe0
> > [ 1782.158314][   T30]  __down_write_common.part.14+0x324/0x7b0
> > [ 1782.159704][   T30]  ? fscrypt_ioctl_set_policy+0xe0/0x200
> > [ 1782.161050][   T30]  fscrypt_ioctl_set_policy+0xe0/0x200
> > [ 1782.162330][   T30]  __f2fs_ioctl+0x9d6/0x45e0
> > [ 1782.163417][   T30]  f2fs_ioctl+0x64/0x240
> > [ 1782.164404][   T30]  ? __f2fs_ioctl+0x45e0/0x45e0
> > [ 1782.165554][   T30]  __x64_sys_ioctl+0xb6/0x100
> > [ 1782.166662][   T30]  do_syscall_64+0x34/0xb0
> > [ 1782.169947][   T30]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
>
> Well, the quality of this bug report has a lot to be desired (not on upstream
> kernel, reproducer is full of totally irrelevant stuff, not sent to the mailing
> list of the filesystem whose disk image is being fuzzed, etc.).  But what is
> going on is that f2fs_empty_dir() doesn't consider the case of a directory with
> an extremely large i_size on a malicious disk image.
>
> Specifically, the reproducer mounts an f2fs image with a directory that has an
> i_size of 14814520042850357248, then calls FS_IOC_SET_ENCRYPTION_POLICY on it.
> That results in a call to f2fs_empty_dir() to check whether the directory is
> empty.  f2fs_empty_dir() then iterates through all 3616826182336513 blocks the
> directory allegedly contains to check whether any contain anything.  i_rwsem is
> held during this, so anything else that tries to take it will hang.
>
> I'll look into this more if needed, but Jaegeuk and Chao, do you happen to have
> any ideas for how f2fs_empty_dir() should be fixed?  Is there an easy way to
> just iterate through the blocks that are actually allocated?
>
> - Eric
