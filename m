Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2DD514278A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 Jan 2020 10:44:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726607AbgATJod convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Jan 2020 04:44:33 -0500
Received: from lithops.sigma-star.at ([195.201.40.130]:59232 "EHLO
        lithops.sigma-star.at" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726075AbgATJoc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Jan 2020 04:44:32 -0500
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id 6D4AE6088963;
        Mon, 20 Jan 2020 10:44:30 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id KPxdARioXyAh; Mon, 20 Jan 2020 10:44:29 +0100 (CET)
Received: from localhost (localhost [127.0.0.1])
        by lithops.sigma-star.at (Postfix) with ESMTP id D37CC609D2C6;
        Mon, 20 Jan 2020 10:44:29 +0100 (CET)
Received: from lithops.sigma-star.at ([127.0.0.1])
        by localhost (lithops.sigma-star.at [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id BqmNdpKNn148; Mon, 20 Jan 2020 10:44:29 +0100 (CET)
Received: from lithops.sigma-star.at (lithops.sigma-star.at [195.201.40.130])
        by lithops.sigma-star.at (Postfix) with ESMTP id A8DC66088963;
        Mon, 20 Jan 2020 10:44:29 +0100 (CET)
Date:   Mon, 20 Jan 2020 10:44:29 +0100 (CET)
From:   Richard Weinberger <richard@nod.at>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-mtd <linux-mtd@lists.infradead.org>,
        linux-fscrypt <linux-fscrypt@vger.kernel.org>,
        Chandan Rajendra <chandan@linux.vnet.ibm.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Message-ID: <397871241.24589.1579513469565.JavaMail.zimbra@nod.at>
In-Reply-To: <20200120065422.GA976@sol.localdomain>
References: <20191209212721.244396-1-ebiggers@kernel.org> <20200103170927.GO19521@gmail.com> <CAFLxGvwA6y2+Azm1Xc+-cz1N_jjJXY3uZBVDqGGLvc6GMcb5JA@mail.gmail.com> <20200120065422.GA976@sol.localdomain>
Subject: Re: [PATCH] ubifs: use IS_ENCRYPTED() instead of
 ubifs_crypt_is_encrypted()
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
X-Originating-IP: [195.201.40.130]
X-Mailer: Zimbra 8.8.12_GA_3807 (ZimbraWebClient - FF68 (Linux)/8.8.12_GA_3809)
Thread-Topic: ubifs: use IS_ENCRYPTED() instead of ubifs_crypt_is_encrypted()
Thread-Index: PjfFjglSsxFK8GwPNc8HVEdJvJHlrQ==
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


----- Ursprüngliche Mail -----
> Von: "Eric Biggers" <ebiggers@kernel.org>
> An: "Richard Weinberger" <richard.weinberger@gmail.com>
> CC: "richard" <richard@nod.at>, "linux-mtd" <linux-mtd@lists.infradead.org>, "linux-fscrypt"
> <linux-fscrypt@vger.kernel.org>, "Chandan Rajendra" <chandan@linux.vnet.ibm.com>
> Gesendet: Montag, 20. Januar 2020 07:54:22
> Betreff: Re: [PATCH] ubifs: use IS_ENCRYPTED() instead of ubifs_crypt_is_encrypted()

> On Thu, Jan 09, 2020 at 09:01:09AM +0100, Richard Weinberger wrote:
>> On Fri, Jan 3, 2020 at 6:09 PM Eric Biggers <ebiggers@kernel.org> wrote:
>> >
>> > On Mon, Dec 09, 2019 at 01:27:21PM -0800, Eric Biggers wrote:
>> > > From: Eric Biggers <ebiggers@google.com>
>> > >
>> > > There's no need for the ubifs_crypt_is_encrypted() function anymore.
>> > > Just use IS_ENCRYPTED() instead, like ext4 and f2fs do.  IS_ENCRYPTED()
>> > > checks the VFS-level flag instead of the UBIFS-specific flag, but it
>> > > shouldn't change any behavior since the flags are kept in sync.
>> > >
>> > > Signed-off-by: Eric Biggers <ebiggers@google.com>
>> > > ---
>> > >  fs/ubifs/dir.c     | 8 ++++----
>> > >  fs/ubifs/file.c    | 4 ++--
>> > >  fs/ubifs/journal.c | 6 +++---
>> > >  fs/ubifs/ubifs.h   | 7 -------
>> > >  4 files changed, 9 insertions(+), 16 deletions(-)
>> >
>> > Richard, can you consider applying this to the UBIFS tree for 5.6?
>> 
>> Sure. I'm back from the x-mas break and start collecting patches.
>> 
> 
> Ping?  I see the other UBIFS patches I sent in linux-ubifs.git#linux-next,
> but not this one.

Oh dear, I reviewed but forgot to apply it. Now I'm already traveling without my
kernel.org PGP keys.

The patch is simple and sane, so I'm totally fine if you carry it via fscrypt.
Another option is that Miquel carries it via MTD this time.

In any case:

Acked-by: Richard Weinberger <richard@nod.at>

Sorry for messing this up. :-(

Thanks,
//richard
