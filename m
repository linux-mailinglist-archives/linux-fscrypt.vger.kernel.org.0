Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEC572A1930
	for <lists+linux-fscrypt@lfdr.de>; Sat, 31 Oct 2020 19:10:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728224AbgJaSKv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 31 Oct 2020 14:10:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:45398 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728211AbgJaSKu (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 31 Oct 2020 14:10:50 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 20FC12068D;
        Sat, 31 Oct 2020 18:10:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604167850;
        bh=z7eLb6mT4ZNOM7Y1jKdRASrr1qXT+vc1NOboctZGTSQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=b42ncufVY6xwyISzZL6ljJRP2KAyBYar9tO6moqofidmLIsBVVC05i+cleBc3ESuu
         QVOCAaeGhTKPeAfVvXOIu0MwhS+3ohE+JwLZcb+QPgJrANwFgPxQBFbWvZ1L3o/lhG
         xPZgdcgEa5gFGXwleMTCZ6+d9HW3dxLh9Ph0l6zw=
Date:   Sat, 31 Oct 2020 11:10:48 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] generic/395: remove workarounds for wrong error codes
Message-ID: <20201031181048.GA936@sol.localdomain>
References: <20201031054018.695314-1-ebiggers@kernel.org>
 <20201031173439.GA1750809@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201031173439.GA1750809@mit.edu>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Oct 31, 2020 at 01:34:39PM -0400, Theodore Y. Ts'o wrote:
> On Fri, Oct 30, 2020 at 10:40:18PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > generic/395 contains workarounds to allow for some of the fscrypt ioctls
> > to fail with different error codes.  However, the error codes were all
> > fixed up and documented years ago:
> > 
> > - FS_IOC_GET_ENCRYPTION_POLICY on ext4 failed with ENOENT instead of
> >   ENODATA on unencrypted files.  Fixed by commit db717d8e26c2
> >   ("fscrypto: move ioctl processing more fully into common code").
> > 
> > - FS_IOC_SET_ENCRYPTION_POLICY failed with EINVAL instead of EEXIST
> >   on encrypted files.  Fixed by commit 8488cd96ff88 ("fscrypt: use
> >   EEXIST when file already uses different policy").
> > 
> > - FS_IOC_SET_ENCRYPTION_POLICY failed with EINVAL instead of ENOTDIR
> >   on nondirectories.  Fixed by commit dffd0cfa06d4 ("fscrypt: use
> >   ENOTDIR when setting encryption policy on nondirectory").
> > 
> > It's been long enough, so update the test to expect the correct behavior
> > only, so we don't accidentally reintroduce the wrong behavior.
> > 
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> LGTM
> 
> Did these fixes get backported into the stable kernels (and the
> relevant Android trees)?
> 

Some of them.  Regarding stable kernels, currently if these 3 xfstests patches
are applied, generic/395 will fail on 4.9 and earlier, generic/397 will fail on
ubifs on 4.19 and earlier, and generic/398 will fail on 4.19 and earlier.

In Android kernels, the fscrypt support tends to be somewhat more up-to-date
than in the corresponding LTS kernels, as the latest fscrypt-related patches
were backported to them while they were open for development.  E.g., the latest
3.18, 4.4, and 4.9 Android common kernels have fs/crypto/ at the equivalent of
upstream 4.17 or 4.18.  Those branches are closed for development though, so
they won't be getting anything newer than that except through LTS.  (And devices
using those kernel versions don't necessarily get kernel updates anymore.)

Backporting these patches can be tricky since the fscrypt code has changed a
lot, so in most cases they would require writing custom backports.

So there's only so much I can do about older kernels.

But probably the most important patch I should backport to LTS is f5e55e777cc9
("fscrypt: return -EXDEV for incompatible rename or link into encrypted dir"),
as that would get the tests passing on ext4 and f2fs on 4.14 and 4.19, and that
patch was a fix for a bug that was causing problems for people.

- Eric
