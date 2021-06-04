Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3888739BDC1
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Jun 2021 18:55:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229850AbhFDQ5Z (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Jun 2021 12:57:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:36502 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbhFDQ5Z (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Jun 2021 12:57:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CFDDB613B4;
        Fri,  4 Jun 2021 16:55:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622825738;
        bh=6TUleeBxMycMAjQItLB0G+hRako0syJLhA3Ykdueq+o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vItcd5e5fAS1jUQTvpwu2/XUGxYfRn7D7ize1Mt96yGYY3NLLpr7A9Ei7dUMt6tPw
         4/0Nr0D4UFfxsCYrFa5g/cfEcZaTZzlmcnqs8v/bjh3vGw+u3C38vdvQZom8cZ8KoO
         OoLUX0GKPPUxGAdlRGVvoaDsDQzPUs38A7pbPscawzi8+S/bZ2ErAOkZsvzW8+uUVS
         6dez1ZKvI8hIdkQ5kbxv0aqfQ1uskacGf0on9Z/VHMcfVfgiLSC4aPVPI1pbGN0AgD
         Ojlj1Ul/dP7swLd2oh4P1/r5zZjxcrCpgQwfrbKoXRZVN8iek/IxPbM1w2aOM0pr7d
         6tETMUQI1u2Ng==
Date:   Fri, 4 Jun 2021 09:55:37 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Victor Hsieh <victorhsieh@google.com>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH 3/4] programs/utils: add full_pwrite() and
 preallocate_file()
Message-ID: <YLpbCRnVVGGkjl19@sol.localdomain>
References: <20210603195812.50838-1-ebiggers@kernel.org>
 <20210603195812.50838-4-ebiggers@kernel.org>
 <CAFCauYO9Hrg-jjNzfMwruU4BQTOD5dFbPnASJXPRKdCQH5tETw@mail.gmail.com>
 <YLl6l0MKaWGR08Tv@sol.localdomain>
 <CAFCauYNPvC=otUWXD5ytqM5rvoaMBLXXfdGHTUcCvWwFG4PEmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFCauYNPvC=otUWXD5ytqM5rvoaMBLXXfdGHTUcCvWwFG4PEmw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jun 04, 2021 at 08:24:50AM -0700, Victor Hsieh wrote:
> On Thu, Jun 3, 2021 at 5:58 PM Eric Biggers <ebiggers@kernel.org> wrote:
> >
> > On Thu, Jun 03, 2021 at 05:33:18PM -0700, Victor Hsieh wrote:
> > > > +
> > > > +bool full_pwrite(struct filedes *file, const void *buf, size_t count,
> > > > +                u64 offset)
> > > > +{
> > > > +       while (count) {
> > > > +               int n = raw_pwrite(file->fd, buf, min(count, INT_MAX), offset);
> > > > +
> > > > +               if (n < 0) {
> > > > +                       error_msg_errno("writing to '%s'", file->name);
> > > > +                       return false;
> > > > +               }
> > > > +               buf += n;
> > > I think this pointer arithmetic is not portable?  Consider changing
> > > the type of buf to "const char*".
> > >
> >
> > fsverity-utils is already using void pointer arithmetic elsewhere, for example
> > in full_read() and full_write().
> >
> > I am allowing the use of some gcc/clang extensions which are widely used,
> > including in the Linux kernel (which fsverity-utils is generally trying to
> > follow the coding style of), and are annoying to do without.  Void pointer
> > arithmetic is one of these.
> >
> > If we really needed to support someone compiling fsverity-utils with e.g.
> > Visual Studio, we could add -Wpedantic to the compiler flags and get rid of all
> > the gcc/clang extensions.  But I don't see a reason to do that now.
> 
> Yeah, that's what I was thinking since the code has #ifdef _WIN32.
> I'd think the
> "host" side program should be more portable than the kernel itself.
> But if this is
> already used elsewhere, no objection to keeping assuming so.
> 
> Reviewed-by: Victor Hsieh <victorhsieh@google.com>
> 

Windows builds are supported with Mingw-w64, not with Visual Studio.  So that
isn't an issue.

- Eric
