Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C39C339AF43
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Jun 2021 02:58:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbhFDA7q (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 3 Jun 2021 20:59:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:34722 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229656AbhFDA7q (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 3 Jun 2021 20:59:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E51D5613F6;
        Fri,  4 Jun 2021 00:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622768281;
        bh=q3tJrwC8GDlPPWdaFKyoPJ2E4EFO5SG4e9SilD7zpCk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o/fjn3O8OPCOcwNnZvY5zNlyoiRh8V3k31Xg6WqFQvscOqRAE+XzUOtDBwBs7ySQw
         jynBPKwBvxAw4+bYpxiecYNQyTtRO68L1vNEYF7JEqFrD4Tr0IUNrVuiNuuhKPNhWx
         7PuUAz6oWIdr3mvMT4LEywcjwKIVvc+ZlQeBwQ2QJwchfT1w76pfR+cAOGvqot8pVv
         GDHlvLYaPt8muZXXBZxdW2fTk9Ls6PLA23KFeQnStZz4nrN6ZTPBLow+nDZAALeWgt
         FUwg2jkGw4xJbnk2lbPGhWSj4SmYrEnyN5x8aC33AIou4zc7YDQg3WbLYXn6q/oYig
         0lXImqN2T40ZQ==
Date:   Thu, 3 Jun 2021 17:57:59 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Victor Hsieh <victorhsieh@google.com>
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH 3/4] programs/utils: add full_pwrite() and
 preallocate_file()
Message-ID: <YLl6l0MKaWGR08Tv@sol.localdomain>
References: <20210603195812.50838-1-ebiggers@kernel.org>
 <20210603195812.50838-4-ebiggers@kernel.org>
 <CAFCauYO9Hrg-jjNzfMwruU4BQTOD5dFbPnASJXPRKdCQH5tETw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFCauYO9Hrg-jjNzfMwruU4BQTOD5dFbPnASJXPRKdCQH5tETw@mail.gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jun 03, 2021 at 05:33:18PM -0700, Victor Hsieh wrote:
> > +
> > +bool full_pwrite(struct filedes *file, const void *buf, size_t count,
> > +                u64 offset)
> > +{
> > +       while (count) {
> > +               int n = raw_pwrite(file->fd, buf, min(count, INT_MAX), offset);
> > +
> > +               if (n < 0) {
> > +                       error_msg_errno("writing to '%s'", file->name);
> > +                       return false;
> > +               }
> > +               buf += n;
> I think this pointer arithmetic is not portable?  Consider changing
> the type of buf to "const char*".
> 

fsverity-utils is already using void pointer arithmetic elsewhere, for example
in full_read() and full_write().

I am allowing the use of some gcc/clang extensions which are widely used,
including in the Linux kernel (which fsverity-utils is generally trying to
follow the coding style of), and are annoying to do without.  Void pointer
arithmetic is one of these.

If we really needed to support someone compiling fsverity-utils with e.g.
Visual Studio, we could add -Wpedantic to the compiler flags and get rid of all
the gcc/clang extensions.  But I don't see a reason to do that now.

- Eric
