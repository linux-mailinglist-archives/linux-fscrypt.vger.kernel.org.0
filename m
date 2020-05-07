Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31E201C8BC9
	for <lists+linux-fscrypt@lfdr.de>; Thu,  7 May 2020 15:09:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725857AbgEGNJh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 7 May 2020 09:09:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:44652 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725879AbgEGNJg (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 7 May 2020 09:09:36 -0400
Received: from localhost (unknown [104.132.1.66])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4765220735;
        Thu,  7 May 2020 13:09:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588856976;
        bh=Do7HGl6Ox7RO6UdN7qPim7FWib9PeRQn2XalXmCIyYY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=pGtQGKB8/0XDpDTTYfFqHNDk737vPATiU0pUZ9bibPwe1c4oNFPvJHhZP+SwCwNHB
         T6RRL3BYQE9jayW9v1Vvh67M+4RkYsrd2PJXzfeYtxTEFQXk0hiCh2QauNj5FRWNKb
         AZv1ysOumvyt+0BVxtP/PzX4N2IeHqPBScPX0F00=
Date:   Thu, 7 May 2020 06:09:35 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org,
        Gabriel Krisman Bertazi <krisman@collabora.com>,
        Daniel Rosenberg <drosen@google.com>
Subject: Re: [f2fs-dev] [PATCH 0/4] f2fs: rework filename handling
Message-ID: <20200507130935.GB197114@google.com>
References: <20200507075905.953777-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200507075905.953777-1-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

Thank you so much for the hard work. :P
Looks good to me in general, so let me kick off some tests.

On 05/07, Eric Biggers wrote:
> This patchset reworks f2fs's handling of filenames to make it much
> easier to correctly implement all combinations of normal, encrypted,
> casefolded, and encrypted+casefolded directories.  It also optimizes all
> filesystem operations to compute the dirhash and casefolded name only
> once, rather than once per directory level or directory block.
> 
> Patch 4 is RFC and shows how we can add support for encrypted+casefolded
> directories fairly easily after this rework -- including support for
> roll-forward recovery.  (It's incomplete as it doesn't include the
> needed dentry_ops -- those can be found in Daniel's patchset
> https://lkml.kernel.org/r/20200307023611.204708-1-drosen@google.com)
> 
> So far this is only lightly tested, e.g. with the xfstests in the
> 'encrypt' and 'casefold' groups.  I haven't tested patch 4 yet.
> 
> Eric Biggers (4):
>   f2fs: don't leak filename in f2fs_try_convert_inline_dir()
>   f2fs: split f2fs_d_compare() from f2fs_match_name()
>   f2fs: rework filename handling
>   f2fs: Handle casefolding with Encryption (INCOMPLETE)
> 
>  fs/f2fs/dir.c      | 415 +++++++++++++++++++++++++++------------------
>  fs/f2fs/f2fs.h     |  85 +++++++---
>  fs/f2fs/hash.c     |  87 +++++-----
>  fs/f2fs/inline.c   |  49 +++---
>  fs/f2fs/namei.c    |   6 +-
>  fs/f2fs/recovery.c |  61 +++++--
>  6 files changed, 430 insertions(+), 273 deletions(-)
> 
> -- 
> 2.26.2
> 
> 
> 
> _______________________________________________
> Linux-f2fs-devel mailing list
> Linux-f2fs-devel@lists.sourceforge.net
> https://lists.sourceforge.net/lists/listinfo/linux-f2fs-devel
