Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 175FC5F4D91
	for <lists+linux-fscrypt@lfdr.de>; Wed,  5 Oct 2022 03:58:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229806AbiJEB6c (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 4 Oct 2022 21:58:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229534AbiJEB61 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 4 Oct 2022 21:58:27 -0400
Received: from mail-ua1-x92d.google.com (mail-ua1-x92d.google.com [IPv6:2607:f8b0:4864:20::92d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23A1C61DAF
        for <linux-fscrypt@vger.kernel.org>; Tue,  4 Oct 2022 18:58:26 -0700 (PDT)
Received: by mail-ua1-x92d.google.com with SMTP id a8so4078535uaj.11
        for <linux-fscrypt@vger.kernel.org>; Tue, 04 Oct 2022 18:58:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=+SZZfGZF1zkfL37zLQhqycOdSF/H73O9942naxPeX4E=;
        b=TWpVMHAwxdKh5uN6u1Ci1BuR3qZyjBFZ/wwrncQ2YRXP6Ca7+fe3/X/iOv8uTzxQkO
         h+i64+OzcZpcImUDt5IAvSTaiOywOA4N33xXcSIwWLxhMB2YQgE8xrKl25dxVccIpcmC
         jFUZFE3XBKEeq/hzg3Prw3f6oWyp712P/2nPy3lk6DdYT2qKWbWEdbT4lxRg7isGAiQU
         D/9oITsifzQ6mP85GZ7U72Agr80QhCwwDBUYSHsRq0jsHYZnBuGP8GzUVPRm0j6BluLK
         +S2DQIs/55VCywuUcKPJwt8MCSNvnOzaVC53Q+dDuV/qe0jbl3E1eOsKf7jv1Q4Y60no
         GeCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=+SZZfGZF1zkfL37zLQhqycOdSF/H73O9942naxPeX4E=;
        b=zY6PaP9CK02edgifvbKQF0w/gYDZMdgh2fgr9BjouMDvMOsl8ujisy0kJEJawLtIJ/
         XFDH2ZUHTMqpoBFXMJ4/PUS+AQry6jWFQDAe7uPZPv+uh/QEX33C9jzZbmtkf2HrPK8g
         QPVhANk7gdjicKeO+eH44YFG+urkh4KyIW1U/rXTYGd9APKgohg+w+4JfSbi8XByZn8l
         HR0ajT5y53Jhgyg8cTAZBsAP7K94Rq0uP2HmTmdp+bniFb98I4t66gmZHK3b+2tYbTMl
         WjVnC9wtjwmaSlHv7uMjv0TmQgSNn5efE7o2hBsCI636FSH/ebuQPqrpR6mOLdsXfCIO
         XyOg==
X-Gm-Message-State: ACrzQf0gD+tHhcOW2dDJGWpHQmI+BrxT8z3cdiBnyhvfVY/CruwZqd8C
        sAOwxOc1FBLmPbLlKU86qO7uHrAbVdKlBFLvkH25fw==
X-Google-Smtp-Source: AMsMyM7yxJU80zWZ1uKd4oR1re+mK1VModWgU67aU2Wf3hD8kgTYIY2782FJK+fOriP502LYGp4KF1D27e3CU9dSrvw=
X-Received: by 2002:ab0:1322:0:b0:390:e7af:a87c with SMTP id
 g31-20020ab01322000000b00390e7afa87cmr13877100uae.113.1664935105157; Tue, 04
 Oct 2022 18:58:25 -0700 (PDT)
MIME-Version: 1.0
References: <20221005001326.157644-1-yuzhao@google.com> <YzzgSYiCCO8dbms8@sol.localdomain>
In-Reply-To: <YzzgSYiCCO8dbms8@sol.localdomain>
From:   Yu Zhao <yuzhao@google.com>
Date:   Tue, 4 Oct 2022 19:57:48 -0600
Message-ID: <CAOUHufZM3JefcJNc-fwCJG8hEVmvAx1yWxPGgTJyneTOT93ZwA@mail.gmail.com>
Subject: Re: [PATCH] fscrypt: fix lockdep warning
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 4, 2022 at 7:39 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Tue, Oct 04, 2022 at 06:13:26PM -0600, Yu Zhao wrote:
> > fscrypt_initialize() shouldn't allocate memory without GFP_NOFS.
> >
> > The problem seems to go back to 2015
> > commit 57e5055b0a5e ("f2fs crypto: add f2fs encryption facilities")
> > but I have never heard of any complaints, hence not CC'ing stable.
> >
> >   ======================================================
> >   WARNING: possible circular locking dependency detected
> >   6.0.0-lockdep #1 Not tainted
> >   ------------------------------------------------------
> >   kswapd0/77 is trying to acquire lock:
> >   71ffff808b254a18 (jbd2_handle){++++}-{0:0}, at: start_this_handle+0x76c/0x8dc
> >
> >   but task is already holding lock:
> >   ffffffea26533310 (fs_reclaim){+.+.}-{0:0}, at: 0x1
> >
> >   which lock already depends on the new lock.
> >
> >   <snipped>
> >
> >   other info that might help us debug this:
> >
> >   Chain exists of:
> >     jbd2_handle --> fscrypt_init_mutex --> fs_reclaim
> >
> >    Possible unsafe locking scenario:
> >
> >          CPU0                    CPU1
> >          ----                    ----
> >     lock(fs_reclaim);
> >                                  lock(fscrypt_init_mutex);
> >                                  lock(fs_reclaim);
> >     lock(jbd2_handle);
> >
> >    *** DEADLOCK ***
> >
> >   3 locks held by kswapd0/77:
> >    #0: ffffffea26533310 (fs_reclaim){+.+.}-{0:0}, at: 0x1
> >    #1: ffffffea26529220 (shrinker_rwsem){++++}-{3:3}, at: shrink_slab+0x54/0x464
> >    #2: 6dffff808abe90e8 (&type->s_umount_key#47){++++}-{3:3}, at: trylock_super+0x2c/0x8c
> >
> >   <snipped>
> >
> > Signed-off-by: Yu Zhao <yuzhao@google.com>
> > ---
> >  fs/crypto/crypto.c | 3 +++
> >  1 file changed, 3 insertions(+)
> >
> > diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
> > index e78be66bbf01..e10fc30142a6 100644
> > --- a/fs/crypto/crypto.c
> > +++ b/fs/crypto/crypto.c
> > @@ -316,6 +316,7 @@ EXPORT_SYMBOL(fscrypt_decrypt_block_inplace);
> >  int fscrypt_initialize(unsigned int cop_flags)
> >  {
> >       int err = 0;
> > +     unsigned int flags;
> >
> >       /* No need to allocate a bounce page pool if this FS won't use it. */
> >       if (cop_flags & FS_CFLG_OWN_PAGES)
> > @@ -326,8 +327,10 @@ int fscrypt_initialize(unsigned int cop_flags)
> >               goto out_unlock;
> >
> >       err = -ENOMEM;
> > +     flags = memalloc_nofs_save();
> >       fscrypt_bounce_page_pool =
> >               mempool_create_page_pool(num_prealloc_crypto_pages, 0);
> > +     memalloc_nofs_restore(flags);
> >       if (!fscrypt_bounce_page_pool)
> >               goto out_unlock;
>
> Thanks, but this isn't the correct fix.  The real problem is that ext4 is
> calling fscrypt_get_encryption_info() from within a jbd2 transaction, which is
> fundamentally unsafe.

 Thanks. So the jbd2_handle -> fscrypt_init_mutex dependency is bad.

> It's a known regression from commit a80f7fcf1867
> ("ext4: fixup ext4_fc_track_* functions' signature"), which extended the scope
> of the transaction in ext4_unlink() too far.
>
> Sorry for not getting around to fixing this earlier.  Are you interested in
> sending a patch for it?

I have no idea how to move fscrypt_get_encryption_info() out of jbd2
transactions. I'll just leave it to you.

> If you do, please make sure to include
> "Reported-by: syzbot+1a748d0007eeac3ab079@syzkaller.appspotmail.com",
> as there's a syzbot report open already
> (https://lore.kernel.org/all/00000000000070395e05dd1fb4d7@google.com/T/#u).
>
> - Eric
