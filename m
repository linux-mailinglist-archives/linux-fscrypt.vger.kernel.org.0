Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 939B81B6DCF
	for <lists+linux-fscrypt@lfdr.de>; Fri, 24 Apr 2020 08:12:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725898AbgDXGMd (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 24 Apr 2020 02:12:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49644 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725868AbgDXGMd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 24 Apr 2020 02:12:33 -0400
Received: from mail-yb1-xb41.google.com (mail-yb1-xb41.google.com [IPv6:2607:f8b0:4864:20::b41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4B0FFC09B045
        for <linux-fscrypt@vger.kernel.org>; Thu, 23 Apr 2020 23:12:33 -0700 (PDT)
Received: by mail-yb1-xb41.google.com with SMTP id n188so4472555ybc.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 23 Apr 2020 23:12:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=wZ8j/xdgMsKpOJAmCNNXEQfFBbRfK1kX1ZtWHixWTgQ=;
        b=bjGlxndmMS+AyE6uXae+TAMMOkCQt7uF2Iv6ji8GDw46qDywCee8hLsnroh2PU0fmI
         26qRzU4xXFCDgPPhUZ9rk3HcJVAmKoWfLfukWL7km16OWkM3/ZtCsPGtaYzChfg24dwR
         vV+q31RhNmaZaXTK48jSwtI5NjTgP1nYWygrM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wZ8j/xdgMsKpOJAmCNNXEQfFBbRfK1kX1ZtWHixWTgQ=;
        b=YmOpS92IWm9/ET2ssflZIRr5Ia4JBc9p9cmCBz2lDBMFMSziZwxgL94oLk+rwCCnlQ
         eNfksyiznhpX2XC+5TWp3miQjiTgAfWup4gVdjyq2+e8uj3Ee9CmJa1I8E2y10Ca/V6n
         qphrSKOfZSAXC0bpon2vKgWcVyw0JgNPp0BZfr7f+iZkECAqkXNEINM9pajjpboG6S7l
         JJKrcWg1dIyr6+J5go/wNJ2iwFnq2qa+/4jdfThDWd/SLYRWcVieMOrmLcsLBDavXLRb
         dClveP6nPg6BEzJlCayQH8rF6fmL3CBAznAIypEkAZKGEhsDGrbk3pMdVCY1+56n4z5V
         R2+g==
X-Gm-Message-State: AGi0PubwAjYb9cx0bBlmhvG2hjzAVM/Mzs/VlLn8Z4WTmv6MQuKv8wZM
        oYnXiT+ds3Ts+fN0F0aDLgt32bVIqnKRqmRhFTAnPQ==
X-Google-Smtp-Source: APiQypI0vq/PY2DK09vsLNi5f3RCTEIsBJgKRTY1XSQ0SlHTEYOI80GSMnzmKQOPIAnEsOjspzJp4X/FB71lzkKq+0A=
X-Received: by 2002:a25:308a:: with SMTP id w132mr13339515ybw.496.1587708752179;
 Thu, 23 Apr 2020 23:12:32 -0700 (PDT)
MIME-Version: 1.0
References: <20200423074706.107016-1-chirantan@chromium.org> <20200423153807.GA205729@gmail.com>
In-Reply-To: <20200423153807.GA205729@gmail.com>
From:   Chirantan Ekbote <chirantan@chromium.org>
Date:   Fri, 24 Apr 2020 15:12:21 +0900
Message-ID: <CAJFHJrqN6rFTqo+-TSWNgQ4ett25L_BFGd8cep70_Nknt2K7zQ@mail.gmail.com>
Subject: Re: [PATCH] fuse: Mark fscrypt ioctls as unrestricted
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "=Miklos Szeredi" <miklos@szeredi.hu>,
        linux-fsdevel@vger.kernel.org, Dylan Reid <dgreid@chromium.org>,
        Suleiman Souhlal <suleiman@chromium.org>,
        linux-fscrypt@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Apr 24, 2020 at 12:38 AM Eric Biggers <ebiggers@kernel.org> wrote:
>
> [+Cc linux-fscrypt@vger.kernel.org]
>
> On Thu, Apr 23, 2020 at 04:47:06PM +0900, Chirantan Ekbote wrote:
> > The definitions for these 2 ioctls have been reversed: "get" is marked
> > as a write ioctl and "set" is marked as a read ioctl.  Moreover, since
> > these are now part of the public kernel interface they can never be
> > fixed because fixing them might break userspace applications compiled
> > with the older headers.
> >
> > Since the fuse module strictly enforces the ioctl encodings, it will
> > reject any attempt by the fuse server to correctly implement these
> > ioctls.  Instead, check if the process is trying to make one of these
> > ioctls and mark it unrestricted.  This will allow the server to fix the
> > encoding by reading/writing the correct data.
> >
> > Signed-off-by: Chirantan Ekbote <chirantan@chromium.org>
> > ---
> >  fs/fuse/file.c | 11 +++++++++++
> >  1 file changed, 11 insertions(+)
> >
> > diff --git a/fs/fuse/file.c b/fs/fuse/file.c
> > index 9d67b830fb7a2..9b6d993323d53 100644
> > --- a/fs/fuse/file.c
> > +++ b/fs/fuse/file.c
> > @@ -18,6 +18,7 @@
> >  #include <linux/swap.h>
> >  #include <linux/falloc.h>
> >  #include <linux/uio.h>
> > +#include <linux/fscrypt.h>
> >
> >  static struct page **fuse_pages_alloc(unsigned int npages, gfp_t flags,
> >                                     struct fuse_page_desc **desc)
> > @@ -2751,6 +2752,16 @@ long fuse_do_ioctl(struct file *file, unsigned int cmd, unsigned long arg,
> >
> >       fuse_page_descs_length_init(ap.descs, 0, fc->max_pages);
> >
> > +     /*
> > +      * These commands are encoded backwards so it is literally impossible
> > +      * for a fuse server to implement them. Instead, mark them unrestricted
> > +      * so that the server can deal with the broken encoding itself.
> > +      */
> > +     if (cmd == FS_IOC_GET_ENCRYPTION_POLICY ||
> > +         cmd == FS_IOC_SET_ENCRYPTION_POLICY) {
> > +             flags |= FUSE_IOCTL_UNRESTRICTED;
> > +     }
>
> Are there any security concerns with marking these ioctls unrestricted, as
> opposed to dealing with the payload in the kernel?
>

The concern would be that the fuse server would be able to read/write
arbitrary memory in the calling process.  This isn't a concern for
something like virtiofs because the device already has access to all
of the VM's memory but it can be a concern with regular fuse servers.

> Also, can you elaborate on why you need only these two specific ioctls?
> FS_IOC_GET_ENCRYPTION_POLICY_EX and FS_IOC_ADD_ENCRYPTION_KEY take a
> variable-length payload and thus are similarly incompatible with FUSE, right?
> I thought we had discussed that for your use case the ioctl you actually need
> isn't the above two, but rather FS_IOC_GET_ENCRYPTION_POLICY_EX.  So I'm a bit
> confused by this patch.
>

It seems I have misunderstood the requirements.  Let's continue the
discussion off-list.

Chirantan
