Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DFFD535903F
	for <lists+linux-fscrypt@lfdr.de>; Fri,  9 Apr 2021 01:16:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232426AbhDHXQm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 8 Apr 2021 19:16:42 -0400
Received: from mail.kernel.org ([198.145.29.99]:54796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232404AbhDHXQm (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 8 Apr 2021 19:16:42 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4CAE7610E6;
        Thu,  8 Apr 2021 23:16:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617923790;
        bh=swRCHV0p3PGGDhnHqfpetux8QlQ2FrwF2AGg9EvG/Q4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cbWZJQsrjGVmy/VJEo21IvSe82+VKtrNEKK4JfAhThQo3C4g3Z/NLbTmf1SDaNNu7
         ZnOe+Ih9DY7Gez/07gL7f6W2fyA79fsuODnhNhIMlu72eYA94UPUiksBtiQA8rgNaC
         7CcreXo8ULrPsoJVwn60gEuzGbuH4iZ4JuFDqHUU4l9FQRfOmOHfGWIGD8Q7roY/H7
         65qgQ5CvWLNvXORlSFTkj+Wy3x1m5MG6qTTNNSCit64blWeaUnJWxhgDUJd9z3mXVR
         +FH8gvH53oYnucvXc6pFkXiYQQSlKmZb7rbPmq2HOxDKCxqwxdDwnMY1580AjbTjYp
         9AO6vcxh+v9aw==
Date:   Thu, 8 Apr 2021 16:16:28 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v2 2/3] generic/574: corrupt btrfs merkle tree data
Message-ID: <YG+OzCaTUvp20w2/@sol.localdomain>
References: <cover.1617906318.git.boris@bur.io>
 <ca320cd0c8427458828cc36d5d5168bbe6b6bab2.1617906318.git.boris@bur.io>
 <YG9OZseq1nGv/wMk@sol.localdomain>
 <YG9QQUHzoA045Ngt@zen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YG9QQUHzoA045Ngt@zen>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Apr 08, 2021 at 11:49:37AM -0700, Boris Burkov wrote:
> On Thu, Apr 08, 2021 at 11:41:42AM -0700, Eric Biggers wrote:
> > On Thu, Apr 08, 2021 at 11:30:12AM -0700, Boris Burkov wrote:
> > > 
> > > Note that there is a bit of a kludge here: since btrfs_corrupt_block
> > > doesn't handle streaming corruption bytes from stdin (I could change
> > > that, but it feels like overkill for this purpose), I just read the
> > > first corruption byte and duplicate it for the desired length. That is
> > > how the test is using the interface in practice, anyway.
> > 
> > If that's the problem, couldn't you just write the data to a temporary file?
> 
> Sorry, I was a bit too vague. It doesn't have a file or stdin interface,
> as far as I know.
> 
> btrfs-corrupt-block has your typical "kitchen sink of flags" interface and
> doesn't currently read input from streams/files. I extended that
> interface in the simplest way to support arbitrary corruption, which
> didn't fit with the stream based corruption this test does.
> 
> my options seem to be:
> shoehorn the "byte, length" interface into this test or
> shoehorn the "stream corruption input in" interface into
> btrfs-corrupt-block.
> 
> I have no problem with either, the former was just less work because I
> already wrote it that way. If the junk I did here is a deal-breaker, I
> don't mind modifying btrfs-corrupt-block.
> 

If it's a lot of trouble to handle arbitrary data, then I think you should
change _fsv_scratch_corrupt_merkle_tree() to actually take a (byte, length) pair
instead of data on stdin.  Otherwise, _fsv_scratch_corrupt_merkle_tree() would
claim to do one thing but actually would do a different thing on one specific
filesystem.

- Eric
