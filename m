Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB85E2DE75C
	for <lists+linux-fscrypt@lfdr.de>; Fri, 18 Dec 2020 17:20:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727787AbgLRQUM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 18 Dec 2020 11:20:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:42262 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726181AbgLRQUM (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 18 Dec 2020 11:20:12 -0500
Date:   Fri, 18 Dec 2020 08:19:30 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608308371;
        bh=UdK9bWHSWwaD8pkbofLQoN+WMmYvS6pnIAYDt9jhLZ8=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=N/VU2QGs9u15hcdNADikNh+/r4kJ4g55G+esAwPY9E+a30b6/6KzrlH03qxYJkJeS
         NVlfbsxKI5TNJ1fAtYXkbtkIn/QlficVuE64rL64/JXfmdovJR+j0uvK2ZWRTMPlH6
         OARzqTsWpWkvdEi12rzmdfGWE4SpK/JRNPrDKUPNxpjAovzhVybf63aSkUX08TVkPT
         ze79c2dzIbVQYnqu11R8z5fTssPZqJwo4OS7/BSpKQLHPfqtUYG8DxHhhheO8wMFwF
         OXe+KfXNgweR8Iujih9pMnNR2oMeyZQr3sQf2V9QvLQAAAVEcOrPAZQE6c+SxFXTQr
         ws7MtN7Z6Zdug==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 0/1] userspace support for F2FS metadata encryption
Message-ID: <X9zWkphqcot8rSZC@google.com>
References: <20201005074133.1958633-1-satyat@google.com>
 <X9uF9kNjWFq8KlL9@google.com>
 <X9xPHDPhsOfGYIgv@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X9xPHDPhsOfGYIgv@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 12/18, Satya Tangirala wrote:
> On Thu, Dec 17, 2020 at 08:23:18AM -0800, Jaegeuk Kim wrote:
> > Hi Satya,
> > 
> > Could you please consider to rebase the patches on f2fs-tools/dev branch?
> > I've applied compression support which will have some conflicts with this
> > series. And, could you check this works with multi-partition support?
> > 
> Sure, I'll do that! I sent out v2 of this patch series earlier today,
> so would you want me to send out a rebased version asap? or when
> I send out v3?

Thank you. Please let me have the latest update like v3.

> 
> Also, newbie question - multi-partition support is the same as
> multi-device support, right?

Yes, right. :)

> > Thanks,
> > 
> > On 10/05, Satya Tangirala wrote:
> > > The kernel patches for F2FS metadata encryption are at:
> > > 
> > > https://lore.kernel.org/linux-fscrypt/20201005073606.1949772-4-satyat@google.com/
> > > 
> > > This patch implements the userspace changes required for metadata
> > > encryption support as implemented in the kernel changes above. All blocks
> > > in the filesystem are encrypted with the user provided metadata encryption
> > > key except for the superblock (and its redundant copy). The DUN for a block
> > > is its offset from the start of the filesystem.
> > > 
> > > This patch introduces two new options for the userspace tools: '-A' to
> > > specify the encryption algorithm, and '-M' to specify the encryption key.
> > > mkfs.f2fs will store the encryption algorithm used for metadata encryption
> > > in the superblock itself, so '-A' is only applicable to mkfs.f2fs. The rest
> > > of the tools only take the '-M' option, and will obtain the encryption
> > > algorithm from the superblock of the FS.
> > > 
> > > Limitations: 
> > > Metadata encryption with sparse storage has not been implemented yet in
> > > this patch.
> > > 
> > > This patch requires the metadata encryption key to be readable from
> > > userspace, and does not ensure that it is zeroed before the program exits
> > > for any reason.
> > > 
> > > Satya Tangirala (1):
> > >   f2fs-tools: Introduce metadata encryption support
> > > 
> > >  fsck/main.c                   |  47 ++++++-
> > >  fsck/mount.c                  |  33 ++++-
> > >  include/f2fs_fs.h             |  10 +-
> > >  include/f2fs_metadata_crypt.h |  21 ++++
> > >  lib/Makefile.am               |   4 +-
> > >  lib/f2fs_metadata_crypt.c     | 226 ++++++++++++++++++++++++++++++++++
> > >  lib/libf2fs_io.c              |  87 +++++++++++--
> > >  mkfs/f2fs_format.c            |   5 +-
> > >  mkfs/f2fs_format_main.c       |  33 ++++-
> > >  9 files changed, 446 insertions(+), 20 deletions(-)
> > >  create mode 100644 include/f2fs_metadata_crypt.h
> > >  create mode 100644 lib/f2fs_metadata_crypt.c
> > > 
> > > -- 
> > > 2.28.0.806.g8561365e88-goog
