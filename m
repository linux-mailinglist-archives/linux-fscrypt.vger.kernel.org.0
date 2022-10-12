Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3D18B5FC3B5
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 Oct 2022 12:26:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229704AbiJLK0a (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 12 Oct 2022 06:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55722 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229682AbiJLK03 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 12 Oct 2022 06:26:29 -0400
Received: from mail-lf1-x129.google.com (mail-lf1-x129.google.com [IPv6:2a00:1450:4864:20::129])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79F86B5166
        for <linux-fscrypt@vger.kernel.org>; Wed, 12 Oct 2022 03:26:23 -0700 (PDT)
Received: by mail-lf1-x129.google.com with SMTP id bu25so25116197lfb.3
        for <linux-fscrypt@vger.kernel.org>; Wed, 12 Oct 2022 03:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=rCtqbtuul6Phe1lX48/9+aSyo6AqZCVbumJmeR7I48s=;
        b=arQaDwDVoAEBgiAya9baEkymKax5nw2Ijw7myQvIck9F+SD2Yimm+M/Czfsvoqqlo5
         aviYAv18cUX/JOl8QxtukoUgryI79NZmVZNORUaLMjBMFY2lSeTsqY7Zi4Lj+6AZTS/s
         ooDCAuUGBCi+Xt1P/RSc6LhlCJdSqeU0mBQdFFBM8gmMb/ayx3KMFiaIR6zp0bjOEOmq
         1Qj9rR9idKBkg8xU5f14EGZnWyiDsi+sJdfF0zCbi2pBxDq1icJdAfVagyi4laRzjOgm
         Lic+5VF9NBwU//XZ4VeBAC9FCRKn6qeYk1FanQDdjtO9wuzykwvuQ3b3VMRnapB2SdTI
         2joQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=rCtqbtuul6Phe1lX48/9+aSyo6AqZCVbumJmeR7I48s=;
        b=2tPQxXuXDiHVn/frI64kGC1oMfL9xFrd2/jqMpyGl7ojouPKPYRiLU932CvV6w5rXz
         51/wtHJiVLv8Cc+ICcRisYdPDmmilYn27jHpH6k9+L0NeZQmYBQHPorDLI3ZuYFkcXYh
         CGXQ78Gf3n6NTsTHGozDVPkIncL0i96SooFcnvw2p3i9WSh8ZSOr8EIKB3DS6AwPsFVH
         fJmmDw/KD+7uijxAHOJWD+/ychRYxPbNzXUB6dqVhqhNiHmr1zk2kfrnguTPK4diqY93
         KFEPoSsu5jOTKgoEsFx+YeyygM51s6WXsgNqL36Ty3TjjgL78KWLujBesoXzSJL++C2F
         OYTg==
X-Gm-Message-State: ACrzQf1RCpn0Qqg+nAnCEl8RFYfNZuuqS5NzEnAsxxoNU0dFqstFLAxH
        jZuWPvSOoys4CMF4i5ilPVT0kFrUy12uSj/R16XZJA==
X-Google-Smtp-Source: AMsMyM7HmOtJYq7TijFDL0sAk8TgcfE/RuUliz5TNdszRjudTG7NVNUhHIHpeOoonmSStG+6f1HdD02gP+Rc+jCkG7c=
X-Received: by 2002:a05:6512:104c:b0:4a2:6cee:ae17 with SMTP id
 c12-20020a056512104c00b004a26ceeae17mr9785191lfb.417.1665570381301; Wed, 12
 Oct 2022 03:26:21 -0700 (PDT)
MIME-Version: 1.0
References: <0000000000009aad5e05eac85f36@google.com> <Y0aHieBUF+CY2rTT@gondor.apana.org.au>
In-Reply-To: <Y0aHieBUF+CY2rTT@gondor.apana.org.au>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 12 Oct 2022 12:26:09 +0200
Message-ID: <CACT4Y+bATweY=FD-9+FN3nyTjuN7mNy6QM8y6GeSzPdjzo4R-w@mail.gmail.com>
Subject: Re: [syzbot] memory leak in crypto_create_tfm_node
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     syzbot <syzbot+104c2a89561289cec13e@syzkaller.appspotmail.com>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        linux-fscrypt@vger.kernel.org, davem@davemloft.net,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, 12 Oct 2022 at 11:23, Herbert Xu <herbert@gondor.apana.org.au> wrote:
>
> Hi:
>
> I presume this is a leak in fscrypt (or perhaps something at an
> even higher level).

Eric sent this:

[PATCH] fscrypt: fix keyring memory leak on mount failure
https://lore.kernel.org/all/20221011213838.209879-1-ebiggers@kernel.org/



> Thanks,
>
> On Tue, Oct 11, 2022 at 01:46:41PM -0700, syzbot wrote:
> > Hello,
> >
> > syzbot found the following issue on:
> >
> > HEAD commit:    4c86114194e6 Merge tag 'iomap-6.1-merge-1' of git://git.ke..
> > git tree:       upstream
> > console output: https://syzkaller.appspot.com/x/log.txt?x=104827bc880000
> > kernel config:  https://syzkaller.appspot.com/x/.config?x=10f41fbb818af57a
> > dashboard link: https://syzkaller.appspot.com/bug?extid=104c2a89561289cec13e
> > compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.2
> > syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=17a1d5fa880000
> > C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=12f77e34880000
> >
> > Downloadable assets:
> > disk image: https://storage.googleapis.com/syzbot-assets/47a35ffaaa39/disk-4c861141.raw.xz
> > vmlinux: https://storage.googleapis.com/syzbot-assets/cc11d48eaf17/vmlinux-4c861141.xz
> > mounted in repro: https://storage.googleapis.com/syzbot-assets/c14465c5ddba/mount_0.gz
> >
> > IMPORTANT: if you fix the issue, please add the following tag to the commit:
> > Reported-by: syzbot+104c2a89561289cec13e@syzkaller.appspotmail.com
> >
> > BUG: memory leak
> > unreferenced object 0xffff8881024bd800 (size 512):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 21.340s)
> >   hex dump (first 32 bytes):
> >     d8 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff  ................
> >     e0 be 2a 82 ff ff ff ff 68 fc 1c 08 81 88 ff ff  ..*.....h.......
> >   backtrace:
> >     [<ffffffff822a2f30>] kmalloc_node include/linux/slab.h:623 [inline]
> >     [<ffffffff822a2f30>] kzalloc_node include/linux/slab.h:744 [inline]
> >     [<ffffffff822a2f30>] crypto_create_tfm_node+0x30/0x130 crypto/api.c:504
> >     [<ffffffff822a3816>] crypto_alloc_tfm_node+0x96/0x180 crypto/api.c:588
> >     [<ffffffff8168ccdc>] fscrypt_init_hkdf+0x3c/0x180 fs/crypto/hkdf.c:75
> >     [<ffffffff8168eb90>] add_master_key+0x160/0x370 fs/crypto/keyring.c:535
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810eb2e740 (size 32):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 21.340s)
> >   hex dump (first 32 bytes):
> >     d0 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff  ................
> >     00 00 00 00 00 00 00 00 20 cb c7 85 ff ff ff ff  ........ .......
> >   backtrace:
> >     [<ffffffff822a2f30>] kmalloc_node include/linux/slab.h:623 [inline]
> >     [<ffffffff822a2f30>] kzalloc_node include/linux/slab.h:744 [inline]
> >     [<ffffffff822a2f30>] crypto_create_tfm_node+0x30/0x130 crypto/api.c:504
> >     [<ffffffff822a50f5>] crypto_create_tfm crypto/internal.h:92 [inline]
> >     [<ffffffff822a50f5>] crypto_spawn_tfm2+0x45/0x90 crypto/algapi.c:803
> >     [<ffffffff822b4c1b>] crypto_spawn_shash include/crypto/internal/hash.h:231 [inline]
> >     [<ffffffff822b4c1b>] hmac_init_tfm+0x3b/0xa0 crypto/hmac.c:152
> >     [<ffffffff822ac8c7>] crypto_shash_init_tfm+0x77/0xf0 crypto/shash.c:440
> >     [<ffffffff822a2f52>] crypto_create_tfm_node+0x52/0x130 crypto/api.c:512
> >     [<ffffffff822a3816>] crypto_alloc_tfm_node+0x96/0x180 crypto/api.c:588
> >     [<ffffffff8168ccdc>] fscrypt_init_hkdf+0x3c/0x180 fs/crypto/hkdf.c:75
> >     [<ffffffff8168eb90>] add_master_key+0x160/0x370 fs/crypto/keyring.c:535
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810a9a1800 (size 2048):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 21.340s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<ffffffff8168ecf6>] kmalloc include/linux/slab.h:600 [inline]
> >     [<ffffffff8168ecf6>] kzalloc include/linux/slab.h:733 [inline]
> >     [<ffffffff8168ecf6>] allocate_filesystem_keyring fs/crypto/keyring.c:194 [inline]
> >     [<ffffffff8168ecf6>] do_add_master_key fs/crypto/keyring.c:502 [inline]
> >     [<ffffffff8168ecf6>] add_master_key+0x2c6/0x370 fs/crypto/keyring.c:554
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810a820800 (size 1024):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 21.340s)
> >   hex dump (first 32 bytes):
> >     00 b0 a4 0e 81 88 ff ff 00 00 00 00 00 00 00 00  ................
> >     58 19 9a 0a 81 88 ff ff 00 00 00 00 00 00 00 00  X...............
> >   backtrace:
> >     [<ffffffff8168e25a>] kmalloc include/linux/slab.h:600 [inline]
> >     [<ffffffff8168e25a>] kzalloc include/linux/slab.h:733 [inline]
> >     [<ffffffff8168e25a>] add_new_master_key+0x4a/0x250 fs/crypto/keyring.c:418
> >     [<ffffffff8168ec10>] do_add_master_key fs/crypto/keyring.c:504 [inline]
> >     [<ffffffff8168ec10>] add_master_key+0x1e0/0x370 fs/crypto/keyring.c:554
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > BUG: memory leak
> > unreferenced object 0xffff8881024bd800 (size 512):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 24.890s)
> >   hex dump (first 32 bytes):
> >     d8 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff  ................
> >     e0 be 2a 82 ff ff ff ff 68 fc 1c 08 81 88 ff ff  ..*.....h.......
> >   backtrace:
> >     [<ffffffff822a2f30>] kmalloc_node include/linux/slab.h:623 [inline]
> >     [<ffffffff822a2f30>] kzalloc_node include/linux/slab.h:744 [inline]
> >     [<ffffffff822a2f30>] crypto_create_tfm_node+0x30/0x130 crypto/api.c:504
> >     [<ffffffff822a3816>] crypto_alloc_tfm_node+0x96/0x180 crypto/api.c:588
> >     [<ffffffff8168ccdc>] fscrypt_init_hkdf+0x3c/0x180 fs/crypto/hkdf.c:75
> >     [<ffffffff8168eb90>] add_master_key+0x160/0x370 fs/crypto/keyring.c:535
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810eb2e740 (size 32):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 24.890s)
> >   hex dump (first 32 bytes):
> >     d0 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff  ................
> >     00 00 00 00 00 00 00 00 20 cb c7 85 ff ff ff ff  ........ .......
> >   backtrace:
> >     [<ffffffff822a2f30>] kmalloc_node include/linux/slab.h:623 [inline]
> >     [<ffffffff822a2f30>] kzalloc_node include/linux/slab.h:744 [inline]
> >     [<ffffffff822a2f30>] crypto_create_tfm_node+0x30/0x130 crypto/api.c:504
> >     [<ffffffff822a50f5>] crypto_create_tfm crypto/internal.h:92 [inline]
> >     [<ffffffff822a50f5>] crypto_spawn_tfm2+0x45/0x90 crypto/algapi.c:803
> >     [<ffffffff822b4c1b>] crypto_spawn_shash include/crypto/internal/hash.h:231 [inline]
> >     [<ffffffff822b4c1b>] hmac_init_tfm+0x3b/0xa0 crypto/hmac.c:152
> >     [<ffffffff822ac8c7>] crypto_shash_init_tfm+0x77/0xf0 crypto/shash.c:440
> >     [<ffffffff822a2f52>] crypto_create_tfm_node+0x52/0x130 crypto/api.c:512
> >     [<ffffffff822a3816>] crypto_alloc_tfm_node+0x96/0x180 crypto/api.c:588
> >     [<ffffffff8168ccdc>] fscrypt_init_hkdf+0x3c/0x180 fs/crypto/hkdf.c:75
> >     [<ffffffff8168eb90>] add_master_key+0x160/0x370 fs/crypto/keyring.c:535
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810a9a1800 (size 2048):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 24.890s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<ffffffff8168ecf6>] kmalloc include/linux/slab.h:600 [inline]
> >     [<ffffffff8168ecf6>] kzalloc include/linux/slab.h:733 [inline]
> >     [<ffffffff8168ecf6>] allocate_filesystem_keyring fs/crypto/keyring.c:194 [inline]
> >     [<ffffffff8168ecf6>] do_add_master_key fs/crypto/keyring.c:502 [inline]
> >     [<ffffffff8168ecf6>] add_master_key+0x2c6/0x370 fs/crypto/keyring.c:554
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810a820800 (size 1024):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 24.890s)
> >   hex dump (first 32 bytes):
> >     00 b0 a4 0e 81 88 ff ff 00 00 00 00 00 00 00 00  ................
> >     58 19 9a 0a 81 88 ff ff 00 00 00 00 00 00 00 00  X...............
> >   backtrace:
> >     [<ffffffff8168e25a>] kmalloc include/linux/slab.h:600 [inline]
> >     [<ffffffff8168e25a>] kzalloc include/linux/slab.h:733 [inline]
> >     [<ffffffff8168e25a>] add_new_master_key+0x4a/0x250 fs/crypto/keyring.c:418
> >     [<ffffffff8168ec10>] do_add_master_key fs/crypto/keyring.c:504 [inline]
> >     [<ffffffff8168ec10>] add_master_key+0x1e0/0x370 fs/crypto/keyring.c:554
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > BUG: memory leak
> > unreferenced object 0xffff8881024bd800 (size 512):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 27.260s)
> >   hex dump (first 32 bytes):
> >     d8 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff  ................
> >     e0 be 2a 82 ff ff ff ff 68 fc 1c 08 81 88 ff ff  ..*.....h.......
> >   backtrace:
> >     [<ffffffff822a2f30>] kmalloc_node include/linux/slab.h:623 [inline]
> >     [<ffffffff822a2f30>] kzalloc_node include/linux/slab.h:744 [inline]
> >     [<ffffffff822a2f30>] crypto_create_tfm_node+0x30/0x130 crypto/api.c:504
> >     [<ffffffff822a3816>] crypto_alloc_tfm_node+0x96/0x180 crypto/api.c:588
> >     [<ffffffff8168ccdc>] fscrypt_init_hkdf+0x3c/0x180 fs/crypto/hkdf.c:75
> >     [<ffffffff8168eb90>] add_master_key+0x160/0x370 fs/crypto/keyring.c:535
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810eb2e740 (size 32):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 27.260s)
> >   hex dump (first 32 bytes):
> >     d0 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff  ................
> >     00 00 00 00 00 00 00 00 20 cb c7 85 ff ff ff ff  ........ .......
> >   backtrace:
> >     [<ffffffff822a2f30>] kmalloc_node include/linux/slab.h:623 [inline]
> >     [<ffffffff822a2f30>] kzalloc_node include/linux/slab.h:744 [inline]
> >     [<ffffffff822a2f30>] crypto_create_tfm_node+0x30/0x130 crypto/api.c:504
> >     [<ffffffff822a50f5>] crypto_create_tfm crypto/internal.h:92 [inline]
> >     [<ffffffff822a50f5>] crypto_spawn_tfm2+0x45/0x90 crypto/algapi.c:803
> >     [<ffffffff822b4c1b>] crypto_spawn_shash include/crypto/internal/hash.h:231 [inline]
> >     [<ffffffff822b4c1b>] hmac_init_tfm+0x3b/0xa0 crypto/hmac.c:152
> >     [<ffffffff822ac8c7>] crypto_shash_init_tfm+0x77/0xf0 crypto/shash.c:440
> >     [<ffffffff822a2f52>] crypto_create_tfm_node+0x52/0x130 crypto/api.c:512
> >     [<ffffffff822a3816>] crypto_alloc_tfm_node+0x96/0x180 crypto/api.c:588
> >     [<ffffffff8168ccdc>] fscrypt_init_hkdf+0x3c/0x180 fs/crypto/hkdf.c:75
> >     [<ffffffff8168eb90>] add_master_key+0x160/0x370 fs/crypto/keyring.c:535
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810a9a1800 (size 2048):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 27.260s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<ffffffff8168ecf6>] kmalloc include/linux/slab.h:600 [inline]
> >     [<ffffffff8168ecf6>] kzalloc include/linux/slab.h:733 [inline]
> >     [<ffffffff8168ecf6>] allocate_filesystem_keyring fs/crypto/keyring.c:194 [inline]
> >     [<ffffffff8168ecf6>] do_add_master_key fs/crypto/keyring.c:502 [inline]
> >     [<ffffffff8168ecf6>] add_master_key+0x2c6/0x370 fs/crypto/keyring.c:554
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810a820800 (size 1024):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 27.260s)
> >   hex dump (first 32 bytes):
> >     00 b0 a4 0e 81 88 ff ff 00 00 00 00 00 00 00 00  ................
> >     58 19 9a 0a 81 88 ff ff 00 00 00 00 00 00 00 00  X...............
> >   backtrace:
> >     [<ffffffff8168e25a>] kmalloc include/linux/slab.h:600 [inline]
> >     [<ffffffff8168e25a>] kzalloc include/linux/slab.h:733 [inline]
> >     [<ffffffff8168e25a>] add_new_master_key+0x4a/0x250 fs/crypto/keyring.c:418
> >     [<ffffffff8168ec10>] do_add_master_key fs/crypto/keyring.c:504 [inline]
> >     [<ffffffff8168ec10>] add_master_key+0x1e0/0x370 fs/crypto/keyring.c:554
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > BUG: memory leak
> > unreferenced object 0xffff8881024bd800 (size 512):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 28.460s)
> >   hex dump (first 32 bytes):
> >     d8 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff  ................
> >     e0 be 2a 82 ff ff ff ff 68 fc 1c 08 81 88 ff ff  ..*.....h.......
> >   backtrace:
> >     [<ffffffff822a2f30>] kmalloc_node include/linux/slab.h:623 [inline]
> >     [<ffffffff822a2f30>] kzalloc_node include/linux/slab.h:744 [inline]
> >     [<ffffffff822a2f30>] crypto_create_tfm_node+0x30/0x130 crypto/api.c:504
> >     [<ffffffff822a3816>] crypto_alloc_tfm_node+0x96/0x180 crypto/api.c:588
> >     [<ffffffff8168ccdc>] fscrypt_init_hkdf+0x3c/0x180 fs/crypto/hkdf.c:75
> >     [<ffffffff8168eb90>] add_master_key+0x160/0x370 fs/crypto/keyring.c:535
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810eb2e740 (size 32):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 28.460s)
> >   hex dump (first 32 bytes):
> >     d0 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff  ................
> >     00 00 00 00 00 00 00 00 20 cb c7 85 ff ff ff ff  ........ .......
> >   backtrace:
> >     [<ffffffff822a2f30>] kmalloc_node include/linux/slab.h:623 [inline]
> >     [<ffffffff822a2f30>] kzalloc_node include/linux/slab.h:744 [inline]
> >     [<ffffffff822a2f30>] crypto_create_tfm_node+0x30/0x130 crypto/api.c:504
> >     [<ffffffff822a50f5>] crypto_create_tfm crypto/internal.h:92 [inline]
> >     [<ffffffff822a50f5>] crypto_spawn_tfm2+0x45/0x90 crypto/algapi.c:803
> >     [<ffffffff822b4c1b>] crypto_spawn_shash include/crypto/internal/hash.h:231 [inline]
> >     [<ffffffff822b4c1b>] hmac_init_tfm+0x3b/0xa0 crypto/hmac.c:152
> >     [<ffffffff822ac8c7>] crypto_shash_init_tfm+0x77/0xf0 crypto/shash.c:440
> >     [<ffffffff822a2f52>] crypto_create_tfm_node+0x52/0x130 crypto/api.c:512
> >     [<ffffffff822a3816>] crypto_alloc_tfm_node+0x96/0x180 crypto/api.c:588
> >     [<ffffffff8168ccdc>] fscrypt_init_hkdf+0x3c/0x180 fs/crypto/hkdf.c:75
> >     [<ffffffff8168eb90>] add_master_key+0x160/0x370 fs/crypto/keyring.c:535
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810a9a1800 (size 2048):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 28.460s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<ffffffff8168ecf6>] kmalloc include/linux/slab.h:600 [inline]
> >     [<ffffffff8168ecf6>] kzalloc include/linux/slab.h:733 [inline]
> >     [<ffffffff8168ecf6>] allocate_filesystem_keyring fs/crypto/keyring.c:194 [inline]
> >     [<ffffffff8168ecf6>] do_add_master_key fs/crypto/keyring.c:502 [inline]
> >     [<ffffffff8168ecf6>] add_master_key+0x2c6/0x370 fs/crypto/keyring.c:554
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810a820800 (size 1024):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 28.460s)
> >   hex dump (first 32 bytes):
> >     00 b0 a4 0e 81 88 ff ff 00 00 00 00 00 00 00 00  ................
> >     58 19 9a 0a 81 88 ff ff 00 00 00 00 00 00 00 00  X...............
> >   backtrace:
> >     [<ffffffff8168e25a>] kmalloc include/linux/slab.h:600 [inline]
> >     [<ffffffff8168e25a>] kzalloc include/linux/slab.h:733 [inline]
> >     [<ffffffff8168e25a>] add_new_master_key+0x4a/0x250 fs/crypto/keyring.c:418
> >     [<ffffffff8168ec10>] do_add_master_key fs/crypto/keyring.c:504 [inline]
> >     [<ffffffff8168ec10>] add_master_key+0x1e0/0x370 fs/crypto/keyring.c:554
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > BUG: memory leak
> > unreferenced object 0xffff8881024bd800 (size 512):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 29.660s)
> >   hex dump (first 32 bytes):
> >     d8 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff  ................
> >     e0 be 2a 82 ff ff ff ff 68 fc 1c 08 81 88 ff ff  ..*.....h.......
> >   backtrace:
> >     [<ffffffff822a2f30>] kmalloc_node include/linux/slab.h:623 [inline]
> >     [<ffffffff822a2f30>] kzalloc_node include/linux/slab.h:744 [inline]
> >     [<ffffffff822a2f30>] crypto_create_tfm_node+0x30/0x130 crypto/api.c:504
> >     [<ffffffff822a3816>] crypto_alloc_tfm_node+0x96/0x180 crypto/api.c:588
> >     [<ffffffff8168ccdc>] fscrypt_init_hkdf+0x3c/0x180 fs/crypto/hkdf.c:75
> >     [<ffffffff8168eb90>] add_master_key+0x160/0x370 fs/crypto/keyring.c:535
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810eb2e740 (size 32):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 29.660s)
> >   hex dump (first 32 bytes):
> >     d0 00 00 00 00 00 00 00 00 00 00 00 ff ff ff ff  ................
> >     00 00 00 00 00 00 00 00 20 cb c7 85 ff ff ff ff  ........ .......
> >   backtrace:
> >     [<ffffffff822a2f30>] kmalloc_node include/linux/slab.h:623 [inline]
> >     [<ffffffff822a2f30>] kzalloc_node include/linux/slab.h:744 [inline]
> >     [<ffffffff822a2f30>] crypto_create_tfm_node+0x30/0x130 crypto/api.c:504
> >     [<ffffffff822a50f5>] crypto_create_tfm crypto/internal.h:92 [inline]
> >     [<ffffffff822a50f5>] crypto_spawn_tfm2+0x45/0x90 crypto/algapi.c:803
> >     [<ffffffff822b4c1b>] crypto_spawn_shash include/crypto/internal/hash.h:231 [inline]
> >     [<ffffffff822b4c1b>] hmac_init_tfm+0x3b/0xa0 crypto/hmac.c:152
> >     [<ffffffff822ac8c7>] crypto_shash_init_tfm+0x77/0xf0 crypto/shash.c:440
> >     [<ffffffff822a2f52>] crypto_create_tfm_node+0x52/0x130 crypto/api.c:512
> >     [<ffffffff822a3816>] crypto_alloc_tfm_node+0x96/0x180 crypto/api.c:588
> >     [<ffffffff8168ccdc>] fscrypt_init_hkdf+0x3c/0x180 fs/crypto/hkdf.c:75
> >     [<ffffffff8168eb90>] add_master_key+0x160/0x370 fs/crypto/keyring.c:535
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810a9a1800 (size 2048):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 29.660s)
> >   hex dump (first 32 bytes):
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >     00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
> >   backtrace:
> >     [<ffffffff8168ecf6>] kmalloc include/linux/slab.h:600 [inline]
> >     [<ffffffff8168ecf6>] kzalloc include/linux/slab.h:733 [inline]
> >     [<ffffffff8168ecf6>] allocate_filesystem_keyring fs/crypto/keyring.c:194 [inline]
> >     [<ffffffff8168ecf6>] do_add_master_key fs/crypto/keyring.c:502 [inline]
> >     [<ffffffff8168ecf6>] add_master_key+0x2c6/0x370 fs/crypto/keyring.c:554
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > BUG: memory leak
> > unreferenced object 0xffff88810a820800 (size 1024):
> >   comm "syz-executor361", pid 3670, jiffies 4294954234 (age 29.660s)
> >   hex dump (first 32 bytes):
> >     00 b0 a4 0e 81 88 ff ff 00 00 00 00 00 00 00 00  ................
> >     58 19 9a 0a 81 88 ff ff 00 00 00 00 00 00 00 00  X...............
> >   backtrace:
> >     [<ffffffff8168e25a>] kmalloc include/linux/slab.h:600 [inline]
> >     [<ffffffff8168e25a>] kzalloc include/linux/slab.h:733 [inline]
> >     [<ffffffff8168e25a>] add_new_master_key+0x4a/0x250 fs/crypto/keyring.c:418
> >     [<ffffffff8168ec10>] do_add_master_key fs/crypto/keyring.c:504 [inline]
> >     [<ffffffff8168ec10>] add_master_key+0x1e0/0x370 fs/crypto/keyring.c:554
> >     [<ffffffff8168f233>] fscrypt_add_test_dummy_key+0x93/0xc0 fs/crypto/keyring.c:801
> >     [<ffffffff8180b59a>] ext4_check_test_dummy_encryption fs/ext4/super.c:2680 [inline]
> >     [<ffffffff8180b59a>] ext4_check_opt_consistency+0x79a/0xb80 fs/ext4/super.c:2735
> >     [<ffffffff818119f6>] __ext4_fill_super fs/ext4/super.c:5095 [inline]
> >     [<ffffffff818119f6>] ext4_fill_super+0xb66/0x5080 fs/ext4/super.c:5648
> >     [<ffffffff815e7851>] get_tree_bdev+0x1f1/0x320 fs/super.c:1323
> >     [<ffffffff815e5a88>] vfs_get_tree+0x28/0x100 fs/super.c:1530
> >     [<ffffffff81629be7>] do_new_mount fs/namespace.c:3040 [inline]
> >     [<ffffffff81629be7>] path_mount+0xc37/0x10d0 fs/namespace.c:3370
> >     [<ffffffff8162a7ce>] do_mount fs/namespace.c:3383 [inline]
> >     [<ffffffff8162a7ce>] __do_sys_mount fs/namespace.c:3591 [inline]
> >     [<ffffffff8162a7ce>] __se_sys_mount fs/namespace.c:3568 [inline]
> >     [<ffffffff8162a7ce>] __x64_sys_mount+0x18e/0x1d0 fs/namespace.c:3568
> >     [<ffffffff8460f1e5>] do_syscall_x64 arch/x86/entry/common.c:50 [inline]
> >     [<ffffffff8460f1e5>] do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
> >     [<ffffffff84800087>] entry_SYSCALL_64_after_hwframe+0x63/0xcd
> >
> > executing program
> > executing program
> > executing program
> >
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > See https://goo.gl/tpsmEJ for more information about syzbot.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > syzbot will keep track of this issue. See:
> > https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> > syzbot can test patches for this issue, for details see:
> > https://goo.gl/tpsmEJ#testing-patches
>
> --
> Email: Herbert Xu <herbert@gondor.apana.org.au>
> Home Page: http://gondor.apana.org.au/~herbert/
> PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
> To view this discussion on the web visit https://groups.google.com/d/msgid/syzkaller-bugs/Y0aHieBUF%2BCY2rTT%40gondor.apana.org.au.
