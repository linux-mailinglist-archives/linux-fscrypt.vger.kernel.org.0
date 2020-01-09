Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 49D6F1353FD
	for <lists+linux-fscrypt@lfdr.de>; Thu,  9 Jan 2020 09:01:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728273AbgAIIBV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 9 Jan 2020 03:01:21 -0500
Received: from mail-wm1-f67.google.com ([209.85.128.67]:53574 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728267AbgAIIBV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 9 Jan 2020 03:01:21 -0500
Received: by mail-wm1-f67.google.com with SMTP id m24so1756775wmc.3
        for <linux-fscrypt@vger.kernel.org>; Thu, 09 Jan 2020 00:01:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mM7vPg0AhQaknvqOPVsXZOVjGRK92DcXE5AgwuDYIHo=;
        b=lwAnWsv3oq7ad8CFOberR0NQ6hDV2J1HMsYX+rMrcX5IbWj7GtEJEABU2+67ir5FeF
         WC21IhRA5W+VDlCPqGR3l8NC2UMuKWlRQ9eiS3uewowKwpjmXQMzveEUG8UZXWzlclxq
         oOlFf1xm+9I7J1hs2pybUuvUUXbih+XkGK/wxooVGxnyZ2WAu6i0tb/Z2FHUoweaTBeW
         NddgWCkxkiIr+EGrNy4HzcWbbjoK5qoGvCmuTz7QS7Ye5lEROzzdbngUMBLwtKC9Vnty
         +fckvR3KTbWezTwnNMbIX2coZYqn4jglLOKv/1F9TNpK653AzshpedKWwLfH+mX4C6hq
         gJIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mM7vPg0AhQaknvqOPVsXZOVjGRK92DcXE5AgwuDYIHo=;
        b=aso1K4OS7lVeeUhFcusssKm1h0+EIH8tVSQMuP1I0Y9bWkVMo4Mkm1JmFZjue7Um6d
         bl6cvT3XYJUaTzKkMrRneY+ZELY2WWNRYtJoNvfi1oMxjI6TzjKvnHYNUZ0nxBA18ucG
         daaWzhmGKEIAUK0GKZm31Ahj3WIlP6Sg8gj6V0Mb5a7GxYDbJyYY3Z3k8krg0iR0rL/f
         J/FkjivAu96R4klsbHL3sMs5ytShTJwCZ3ySY/lZF2mhfrrFTPlEdSq/hKaBoNRpn20F
         TV0MwiAi6Vxc73q/K9qr+uCjFCTLvEVjo2ftRhOSsGbpCWELdjes+3wVJboaTntBI5Q+
         JeJA==
X-Gm-Message-State: APjAAAUGGgcfhzvANQdd5ueiTk+DXT5eRQnm7gMZupOPf9k3qzjbWkze
        KXfda2N39gQwV1xWqJrJ/UyND7ojocBJb6uxDhI=
X-Google-Smtp-Source: APXvYqyK8tMCjb2q0F/zY/NxYO5hT8twzh58hRo/ALDAQCuK0Gvez9RnhPzksN01eRQqyasbLGmqZMOSNf7Y63vKQ3A=
X-Received: by 2002:a1c:184:: with SMTP id 126mr3126631wmb.127.1578556880370;
 Thu, 09 Jan 2020 00:01:20 -0800 (PST)
MIME-Version: 1.0
References: <20191209212721.244396-1-ebiggers@kernel.org> <20200103170927.GO19521@gmail.com>
In-Reply-To: <20200103170927.GO19521@gmail.com>
From:   Richard Weinberger <richard.weinberger@gmail.com>
Date:   Thu, 9 Jan 2020 09:01:09 +0100
Message-ID: <CAFLxGvwA6y2+Azm1Xc+-cz1N_jjJXY3uZBVDqGGLvc6GMcb5JA@mail.gmail.com>
Subject: Re: [PATCH] ubifs: use IS_ENCRYPTED() instead of ubifs_crypt_is_encrypted()
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org,
        linux-fscrypt@vger.kernel.org,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jan 3, 2020 at 6:09 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Mon, Dec 09, 2019 at 01:27:21PM -0800, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> >
> > There's no need for the ubifs_crypt_is_encrypted() function anymore.
> > Just use IS_ENCRYPTED() instead, like ext4 and f2fs do.  IS_ENCRYPTED()
> > checks the VFS-level flag instead of the UBIFS-specific flag, but it
> > shouldn't change any behavior since the flags are kept in sync.
> >
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> > ---
> >  fs/ubifs/dir.c     | 8 ++++----
> >  fs/ubifs/file.c    | 4 ++--
> >  fs/ubifs/journal.c | 6 +++---
> >  fs/ubifs/ubifs.h   | 7 -------
> >  4 files changed, 9 insertions(+), 16 deletions(-)
>
> Richard, can you consider applying this to the UBIFS tree for 5.6?

Sure. I'm back from the x-mas break and start collecting patches.

-- 
Thanks,
//richard
