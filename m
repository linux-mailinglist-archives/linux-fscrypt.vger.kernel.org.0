Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32F912B147C
	for <lists+linux-fscrypt@lfdr.de>; Fri, 13 Nov 2020 03:57:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726017AbgKMC5k (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 12 Nov 2020 21:57:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:54976 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725965AbgKMC5k (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 12 Nov 2020 21:57:40 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EE72920A8B;
        Fri, 13 Nov 2020 02:57:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605236260;
        bh=2wN3lqPPGVPacP2VEcKydls6XJJaUzqDhHB6a+6UYE0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Or1Xb8/yMxVK5ZFmeV484FdrrgCKe/m2SbKPdLhYxJGQhUgBufGUDR47D65f0Jctp
         6WbXQaYzk9o3GD6ZS2+GIf2HiWWiZDh6bFmVDBnDHVtXhHJKtWUzwKFwpibtwnEx4z
         B7ZbKl14Rb2f2DlbMUfApjX2l4OEy7tMvW1J2ahc=
Date:   Thu, 12 Nov 2020 18:57:38 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Lihong Kou <koulihong@huawei.com>
Cc:     yuchao0@huawei.com, jaegeuk@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Satya Tangirala <satyat@google.com>,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] f2fs: fix the bug in f2fs_direct_IO with inline
 encryption
Message-ID: <X632Ivd2KfuUrGzx@sol.localdomain>
References: <20201113034348.12131-1-koulihong@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201113034348.12131-1-koulihong@huawei.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Nov 13, 2020 at 11:43:48AM +0800, Lihong Kou wrote:
> Now we have inline encrytion and fs layer encrption in the kernel, when we
> choose inline encryption, we should not use bufferd IO instead of direct IO.
> 
> Signed-off-by: Lihong Kou <koulihong@huawei.com>
> ---
>  fs/f2fs/f2fs.h | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/f2fs/f2fs.h b/fs/f2fs/f2fs.h
> index cb700d797296..ccc5c9734f55 100644
> --- a/fs/f2fs/f2fs.h
> +++ b/fs/f2fs/f2fs.h
> @@ -3889,8 +3889,8 @@ static inline void f2fs_set_encrypted_inode(struct inode *inode)
>   */
>  static inline bool f2fs_post_read_required(struct inode *inode)
>  {
> -	return f2fs_encrypted_file(inode) || fsverity_active(inode) ||
> -		f2fs_compressed_file(inode);
> +	return (f2fs_encrypted_file(inode) && fscrypt_inode_uses_fs_layer_crypto(inode))
> +		|| fsverity_active(inode) || f2fs_compressed_file(inode);
>  }

This isn't correct for upstream because upstream doesn't support direct I/O with
fscrypt inline encryption yet.  The patchset to support direct I/O with fscrypt
inline encryption was last sent out at
https://lkml.kernel.org/linux-fscrypt/20200720233739.824943-1-satyat@google.com.
I believe that Satya is planning to send it again soon.

On the other hand, downstream, the Android common kernels have the fscrypt
direct I/O support already, and f2fs_force_buffered_io() has been updated
accordingly.  If you're using one of the Android common kernels, can you make
sure it's up-to-date?

- Eric
