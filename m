Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 490552DD51D
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 17:24:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727260AbgLQQYB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 11:24:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:60970 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726999AbgLQQYA (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 11:24:00 -0500
Date:   Thu, 17 Dec 2020 08:23:18 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608222200;
        bh=FMmMjljEOp+bHuNqcOl5KSSyovWSAAXnB0VcyxYZPgw=;
        h=From:To:Cc:Subject:References:In-Reply-To:From;
        b=LqK0/OvtFHpE9TkJ+OoRyMv/mwPGyfTqxyGRFUmS78LFm5x8LiDzl/X0FmhruF81W
         L034jf4Pp65ZCKO7fDmUgDHh5n/dBM/5crmNlQpUBCPwRWi4W2EpgrQ1T3qxHw9bLI
         MFKSmidrJAHQNhS/gYj0kzmRbdrc8kaabVHxjm+jHNwkNWUY7/t9NN6tjtls+RLjyK
         0PeufVFjZIPnw0kiFjMcF9Z0NQUxligxxEofDHCougp61E+FGehJtlETIMnkR38GRK
         uVB9c6Azmmfai7FqL1SYaT0YWTwXtUt9Wjz30uC2U0nI1/QpcDtDX7JuwwUIeJhbnm
         mRKjEWgIkM/VQ==
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     Eric Biggers <ebiggers@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 0/1] userspace support for F2FS metadata encryption
Message-ID: <X9uF9kNjWFq8KlL9@google.com>
References: <20201005074133.1958633-1-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005074133.1958633-1-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Satya,

Could you please consider to rebase the patches on f2fs-tools/dev branch?
I've applied compression support which will have some conflicts with this
series. And, could you check this works with multi-partition support?

Thanks,

On 10/05, Satya Tangirala wrote:
> The kernel patches for F2FS metadata encryption are at:
> 
> https://lore.kernel.org/linux-fscrypt/20201005073606.1949772-4-satyat@google.com/
> 
> This patch implements the userspace changes required for metadata
> encryption support as implemented in the kernel changes above. All blocks
> in the filesystem are encrypted with the user provided metadata encryption
> key except for the superblock (and its redundant copy). The DUN for a block
> is its offset from the start of the filesystem.
> 
> This patch introduces two new options for the userspace tools: '-A' to
> specify the encryption algorithm, and '-M' to specify the encryption key.
> mkfs.f2fs will store the encryption algorithm used for metadata encryption
> in the superblock itself, so '-A' is only applicable to mkfs.f2fs. The rest
> of the tools only take the '-M' option, and will obtain the encryption
> algorithm from the superblock of the FS.
> 
> Limitations: 
> Metadata encryption with sparse storage has not been implemented yet in
> this patch.
> 
> This patch requires the metadata encryption key to be readable from
> userspace, and does not ensure that it is zeroed before the program exits
> for any reason.
> 
> Satya Tangirala (1):
>   f2fs-tools: Introduce metadata encryption support
> 
>  fsck/main.c                   |  47 ++++++-
>  fsck/mount.c                  |  33 ++++-
>  include/f2fs_fs.h             |  10 +-
>  include/f2fs_metadata_crypt.h |  21 ++++
>  lib/Makefile.am               |   4 +-
>  lib/f2fs_metadata_crypt.c     | 226 ++++++++++++++++++++++++++++++++++
>  lib/libf2fs_io.c              |  87 +++++++++++--
>  mkfs/f2fs_format.c            |   5 +-
>  mkfs/f2fs_format_main.c       |  33 ++++-
>  9 files changed, 446 insertions(+), 20 deletions(-)
>  create mode 100644 include/f2fs_metadata_crypt.h
>  create mode 100644 lib/f2fs_metadata_crypt.c
> 
> -- 
> 2.28.0.806.g8561365e88-goog
