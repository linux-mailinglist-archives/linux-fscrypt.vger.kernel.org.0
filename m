Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CDBC863F12B
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Dec 2022 14:05:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231497AbiLANFU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 1 Dec 2022 08:05:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231504AbiLANE6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 1 Dec 2022 08:04:58 -0500
Received: from mail-ej1-x62e.google.com (mail-ej1-x62e.google.com [IPv6:2a00:1450:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C6462A9E91;
        Thu,  1 Dec 2022 05:04:15 -0800 (PST)
Received: by mail-ej1-x62e.google.com with SMTP id vp12so4023504ejc.8;
        Thu, 01 Dec 2022 05:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=QPGelvmsI89Ej4e2JFJ6sgo5JuCOzgtXISwq322PGrQ=;
        b=bALNbsAllhsQJa8q3SYlESLLKeh1I4FBziNuoIln8Ln9erlb/mMjSJxny7dkKosauM
         qqk1xBtxZ4FtwPEYauSL29kGbWjNHo4YNeSTnhcbxiNrnfBQFbBKtqXu7UC6ECAnIfgp
         ZvUoqfUJ4o8qu9QFX2TfdC48X2k+jDmeh8q+JBzIoYUKj5H1GFv3m9O1ooLpna6qnhdd
         sr6pC88ck1Jrwog1A5YbllH4HED78nfUWvgy+anZcROnPsobhcEskOSvVfo7wP88aySd
         RiT3XJIYo6erIRrPeXtFfclT8EdEIOLAA51Q5GzrFBQt87HNIS9LlSkwYFvswy/Hwacm
         TX0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QPGelvmsI89Ej4e2JFJ6sgo5JuCOzgtXISwq322PGrQ=;
        b=V1VkYjflADQoqpEHNdoyPYo/c+vFq9May1TPNej3nfLQ8dTHYc84cYIR/HgahtcUwx
         UPBo3ffREp5rocq7dpfFLrvc1dlQq7Jn6wjwsILdPYIoQeoWwDOtPAl79gmLJCaVfPvl
         ENYhyHBEemN17rdiO2Wyxwf7bvKnWhvwlpoMgKHrBI2WsC2cZuup9Ty7M8KdQSxdworB
         sng/2Nk2SisTmMnk77li+YHEbIYTeQ8Ew0SCGI9BB1qpDR//fYOaR4dpOYAXSjURr0K0
         2n6rTeiYuI50y2gGgQZ3puYcFIPf8IHNzmugBYK7kt3DmWWu/TWh1HK6/KYvFsY9VYrC
         xnzg==
X-Gm-Message-State: ANoB5pnVgNYI7lzORxSHzRK3SvImewhctbyNZlXC8+JNKHkHiXuaF+LQ
        SpvxBWGmWHy3O8UUaaGbvIABHheahBbhI8S6DuDwrjqeyGs=
X-Google-Smtp-Source: AA0mqf6yWIsHxshQUqiftjjzxnie46pev1HgezpSc6diCaqyiShQ/nKQE/U+MIpXPqd1nfXiCt4U+j3DqVPNU+cFpWo=
X-Received: by 2002:a17:906:3289:b0:78d:4cb3:f65d with SMTP id
 9-20020a170906328900b0078d4cb3f65dmr45709955ejw.79.1669899854237; Thu, 01 Dec
 2022 05:04:14 -0800 (PST)
MIME-Version: 1.0
References: <20221201065800.18149-1-xiubli@redhat.com>
In-Reply-To: <20221201065800.18149-1-xiubli@redhat.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Thu, 1 Dec 2022 14:04:01 +0100
Message-ID: <CAOi1vP8u7fenJyH02=O1R9Q+2CrsM2Q5thrnKFCMWH0HiGz9pA@mail.gmail.com>
Subject: Re: [PATCH] ceph: make sure all the files successfully put before unmounting
To:     xiubli@redhat.com
Cc:     ceph-devel@vger.kernel.org, jlayton@kernel.org,
        khiremat@redhat.com, linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 1, 2022 at 7:58 AM <xiubli@redhat.com> wrote:
>
> From: Xiubo Li <xiubli@redhat.com>
>
> When close a file it will be deferred to call the fput(), which
> will hold the inode's i_count. And when unmounting the mountpoint
> the evict_inodes() may skip evicting some inodes.
>
> If encrypt is enabled the kernel generate a warning when removing
> the encrypt keys when the skipped inodes still hold the keyring:
>
> WARNING: CPU: 4 PID: 168846 at fs/crypto/keyring.c:242 fscrypt_destroy_keyring+0x7e/0xd0
> CPU: 4 PID: 168846 Comm: umount Tainted: G S  6.1.0-rc5-ceph-g72ead199864c #1
> Hardware name: Supermicro SYS-5018R-WR/X10SRW-F, BIOS 2.0 12/17/2015
> RIP: 0010:fscrypt_destroy_keyring+0x7e/0xd0
> RSP: 0018:ffffc9000b277e28 EFLAGS: 00010202
> RAX: 0000000000000002 RBX: ffff88810d52ac00 RCX: ffff88810b56aa00
> RDX: 0000000080000000 RSI: ffffffff822f3a09 RDI: ffff888108f59000
> RBP: ffff8881d394fb88 R08: 0000000000000028 R09: 0000000000000000
> R10: 0000000000000001 R11: 11ff4fe6834fcd91 R12: ffff8881d394fc40
> R13: ffff888108f59000 R14: ffff8881d394f800 R15: 0000000000000000
> FS:  00007fd83f6f1080(0000) GS:ffff88885fd00000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f918d417000 CR3: 000000017f89a005 CR4: 00000000003706e0
> DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
> DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
> Call Trace:
> <TASK>
> generic_shutdown_super+0x47/0x120
> kill_anon_super+0x14/0x30
> ceph_kill_sb+0x36/0x90 [ceph]
> deactivate_locked_super+0x29/0x60
> cleanup_mnt+0xb8/0x140
> task_work_run+0x67/0xb0
> exit_to_user_mode_prepare+0x23d/0x240
> syscall_exit_to_user_mode+0x25/0x60
> do_syscall_64+0x40/0x80
> entry_SYSCALL_64_after_hwframe+0x63/0xcd
> RIP: 0033:0x7fd83dc39e9b
>
> URL: https://tracker.ceph.com/issues/58126
> Signed-off-by: Xiubo Li <xiubli@redhat.com>
> ---
>  fs/ceph/super.c | 9 +++++++++
>  1 file changed, 9 insertions(+)
>
> diff --git a/fs/ceph/super.c b/fs/ceph/super.c
> index 3db6f95768a3..1f46db92e81f 100644
> --- a/fs/ceph/super.c
> +++ b/fs/ceph/super.c
> @@ -9,6 +9,7 @@
>  #include <linux/in6.h>
>  #include <linux/module.h>
>  #include <linux/mount.h>
> +#include <linux/file.h>
>  #include <linux/fs_context.h>
>  #include <linux/fs_parser.h>
>  #include <linux/sched.h>
> @@ -1477,6 +1478,14 @@ static void ceph_kill_sb(struct super_block *s)
>         ceph_mdsc_pre_umount(fsc->mdsc);
>         flush_fs_workqueues(fsc);
>
> +       /*
> +        * If the encrypt is enabled we need to make sure the delayed
> +        * fput to finish, which will make sure all the inodes will
> +        * be evicted before removing the encrypt keys.
> +        */
> +       if (s->s_master_keys)
> +               flush_delayed_fput();

Hi Xiubo,

In the tracker ticket comments, you are wondering whether this
is a generic fscrypt bug but then proceed with working around it
in CephFS:

> By reading the code it should be a bug in fs/crypto/ code. When
> closing the file it will be delayed in kernel space by adding it into
> the delayed_fput_list delay queue.
> And if that queue is delayed for some reasons and when unmounting the
> mountpoint it will skip evicting the corresponding inode in
> evict_inodes(). So the fscrypt_put_encryption_info(), which will
> decrease the mk->mk_active_refs reference count, will be missed. And
> at last in generic_shutdown_super() will hit this warning.

> Still reading the code to see whether could I fix this in ceph layer.

If the root cause lies in fs/crypto, I'd rather see it fixed there
than papered over in fs/ceph.

Thanks,

                Ilya

> +
>         kill_anon_super(s);
>
>         fsc->client->extra_mon_dispatch = NULL;
> --
> 2.31.1
>
