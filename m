Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17A00234B7D
	for <lists+linux-fscrypt@lfdr.de>; Fri, 31 Jul 2020 21:14:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728086AbgGaTOy (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 31 Jul 2020 15:14:54 -0400
Received: from mail.kernel.org ([198.145.29.99]:35560 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726726AbgGaTOy (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 31 Jul 2020 15:14:54 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 17ECF21744;
        Fri, 31 Jul 2020 19:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596222893;
        bh=yDUMHAutsuG8eBiDswnmTI5W5AVOWyH5v67BHEc1KVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kY/c//rqZ+Zozgx+rbkAdCkjTgbqhVi/lTw+tBEaHttPc0t2kBzik3Iv19GFA1nRX
         JDoc+LWnl6q73LtEFVXbJ7EGRntYbI8Out7MbXkvvU5CY7xDEK1qE+0UyoxoG3PA37
         Tp/PmHHFFWSpjfvD/VDc9zZbEU9ePA5Aanl+Qc7o=
Date:   Fri, 31 Jul 2020 12:14:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Chris Mason <clm@fb.com>
Cc:     Jes Sorensen <jes.sorensen@gmail.com>,
        Jes Sorensen <jsorensen@fb.com>, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH 0/7] Split fsverity-utils into a shared library
Message-ID: <20200731191451.GA840@sol.localdomain>
References: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
 <20200211192209.GA870@sol.localdomain>
 <b49b4367-51e7-f62a-6209-b46a6880824b@gmail.com>
 <20200211231454.GB870@sol.localdomain>
 <c39f57d5-c9a4-5fbb-3ce3-cd21e90ef921@gmail.com>
 <20200214203510.GA1985@gmail.com>
 <479b0fff-6af2-32e6-a645-03fcfc65ad59@gmail.com>
 <20200730175252.GA1074@sol.localdomain>
 <0d5c5b1d-2170-025e-2cc1-75169bb33008@gmail.com>
 <6CCA1B7E-63A2-4E8C-BD9D-A7F34E6F488D@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6CCA1B7E-63A2-4E8C-BD9D-A7F34E6F488D@fb.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jul 31, 2020 at 01:47:36PM -0400, Chris Mason wrote:
> On 31 Jul 2020, at 13:40, Jes Sorensen wrote:
> 
> > On 7/30/20 1:52 PM, Eric Biggers wrote:
> > > On Wed, Feb 19, 2020 at 06:49:07PM -0500, Jes Sorensen wrote:
> > > > > We'd also need to follow shared library best practices like
> > > > > compiling with
> > > > > -fvisibility=hidden and marking the API functions explicitly with
> > > > > __attribute__((visibility("default"))), and setting the
> > > > > 'soname' like
> > > > > -Wl,-soname=libfsverity.so.0.
> > > > > 
> > > > > Also, is the GPLv2+ license okay for the use case?
> > > > 
> > > > Personally I only care about linking it into rpm, which is GPL
> > > > v2, so
> > > > from my perspective, that is sufficient. I am also fine making
> > > > it LGPL,
> > > > but given it's your code I am stealing, I cannot make that call.
> > > > 
> > > 
> > > Hi Jes, I'd like to revisit this, as I'm concerned about future use
> > > cases where
> > > software under other licenses (e.g. LGPL, MIT, or Apache 2.0) might
> > > want to use
> > > libfsverity -- especially if libfsverity grows more functionality.
> > > 
> > > Also, fsverity-utils links to OpenSSL, which some people (e.g.
> > > Debian) consider
> > > to be incompatible with GPLv2.
> > > 
> > > We think the MIT license would offer the
> > > most flexibility.  Are you okay with changing the license of
> > > fsverity-utils to
> > > MIT?  If so, I'll send a patch and you can give an Acked-by on it.
> > > 
> > > Thanks!
> > > 
> > > - Eric
> > 
> > Hi Eric,
> > 
> > I went back through my patches to make sure I didn't reuse code from
> > other GPL projects. I don't see anything that looks like it was reused
> > except from fsverity-utils itself, so it should be fine.
> > 
> > I think it's fair to relax the license so other projects can link to it.
> > I would prefer we use the LGPL rather than the MIT license though?
> > 
> > CC'ing Chris Mason as well, since he has the auth to ack it on behalf of
> > the company.
> 
> MIT, BSD, LGPL are Signed-off-by: Chris Mason <clm@fb.com>
> 
> We’re flexible, the goal is just to fit into the rest of fsverity overall.
> 
> -chris

Thanks Chris and Jes.

At least on Google's side, a permissive license generally makes things easier
for people -- even though in practice we'll be upstreaming all changes anyway.
Since fsverity-utils is only a small project and is unlikely to be customized
much by people (as it's closely tied to the upstream kernel support), for now
I'd rather not create problems for users or cause duplication of effort.

If it were a larger project, or something people would be more likely to
customize, the case for LGPL would be stronger IMO.

There are also OpenSSL linking exceptions out there even for the LGPL (!), so
I'm not sure everyone agrees that one isn't needed...  I'd like to avoid wasting
time on any such issues and just write code :-)

Note that we can always choose to move to LGPL later, but LGPL => MIT won't be
possible (since in line with kernel community norms, for fsverity-utils we're
only requiring the DCO, not a CLA).  I think we shouldn't go down a one-way
street too early.

I've send out a patch to change the license.  Can you two explicitly give
Acked-by on the patch itself?  Thanks!

- Eric
