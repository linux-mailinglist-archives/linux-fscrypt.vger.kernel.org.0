Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4A552353F8
	for <lists+linux-fscrypt@lfdr.de>; Sat,  1 Aug 2020 20:13:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725939AbgHASMD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 1 Aug 2020 14:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:58310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725883AbgHASMC (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 1 Aug 2020 14:12:02 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 43A5F206E6;
        Sat,  1 Aug 2020 18:12:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596305522;
        bh=cI5hP7evA8RuEle36LCwJzIgjQXpLORnks5Xyu3ifE8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=zsZBdwr9eUU6pU2Zi2zzov28YXAtWWU2M5kpklxkOm0FthAgzb6MvECVQGd+/I60u
         zxR0cy8A/8zmmojpOGHN1HaUp6U2lf2G8TxbHtfXy0tT+jJHKhrHJVRPrExsggfJ50
         6lr+Be8CHBxU2n4ghTjtJmixOC0SCkcujwThZAPY=
Date:   Sat, 1 Aug 2020 11:12:00 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] Makefile: improve the cc-option compatibility
Message-ID: <20200801181200.GB14666@sol.localdomain>
References: <20200730093520.26905-1-po-hsu.lin@canonical.com>
 <CAMy_GT-JNP0aTM3wC2mniMrREGkHGHuc2G=4Wmj99AFXULa6hQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAMy_GT-JNP0aTM3wC2mniMrREGkHGHuc2G=4Wmj99AFXULa6hQ@mail.gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jul 30, 2020 at 09:21:38PM +0800, Po-Hsu Lin wrote:
> BTW this is for fsverity-utils.
> 
> I should put a [fsverity-utils] in the title, sorry about this.
> I can resubmit one if you need.
> 
> Thank you
> PHLin
> 
> On Thu, Jul 30, 2020 at 5:35 PM Po-Hsu Lin <po-hsu.lin@canonical.com> wrote:
> >
> > The build on Ubuntu Xenial with GCC 5.4.0 will fail with:
> >     cc: error: unrecognized command line option ‘-Wimplicit-fallthrough’
> >
> > This unsupported flag is not skipped as expected.
> >
> > It is because of the /bin/sh shell on Ubuntu, DASH, which does not
> > support this &> redirection. Use 2>&1 to solve this problem.
> >
> > Signed-off-by: Po-Hsu Lin <po-hsu.lin@canonical.com>
> > ---
> >  Makefile | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/Makefile b/Makefile
> > index 7d7247c..a4ce55a 100644
> > --- a/Makefile
> > +++ b/Makefile
> > @@ -27,7 +27,7 @@
> >  #
> >  ##############################################################################
> >
> > -cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null &>/dev/null; \
> > +cc-option = $(shell if $(CC) $(1) -c -x c /dev/null -o /dev/null > /dev/null 2>&1; \
> >               then echo $(1); fi)
> >
> >  CFLAGS ?= -O2 -Wall -Wundef                                    \
> > --

Looks good, thanks!  I'll also want to add a test for building with dash to
scripts/run-tests.sh, but I can do that.

Note that we've just changed the license of fsverity-utils to the MIT license.
Can you rebase onto the latest master branch (commit ab794fd56511) and resend to
indicate that you agree?  And yes, I suggest "[fsverity-utils PATCH]", as this
mailing list is mostly used for kernel patches.  Thanks!

- Eric
