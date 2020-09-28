Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C276627B7C7
	for <lists+linux-fscrypt@lfdr.de>; Tue, 29 Sep 2020 01:15:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727346AbgI1XPc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Sep 2020 19:15:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:60210 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727145AbgI1XPb (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Sep 2020 19:15:31 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C032B21D41;
        Mon, 28 Sep 2020 21:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601330159;
        bh=6z91mKn6qjuem7zZtYDzbCSm4BYLZg64yE8VCJOoMxw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PjVti+/d6/LARjkYevcmTfmDAbtEZwPm5zllEgC+l1/f3jnBjeRBhkbxdDhtbZwsD
         M9iaw83EBAmwBx920b7jFyftZLQ3qF9s2nENfvDC/lr595X7CjWN9fd3DBp92cO9Ru
         MgWunJMvRxRGUCBbbn7UNs1IaCDXfauboH8LY7co=
Date:   Mon, 28 Sep 2020 14:55:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        ceph-devel@vger.kernel.org, Daniel Rosenberg <drosen@google.com>,
        Jeff Layton <jlayton@kernel.org>
Subject: Re: [PATCH] fscrypt: export fscrypt_d_revalidate()
Message-ID: <20200928215558.GD1340@sol.localdomain>
References: <20200924054721.187797-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200924054721.187797-1-ebiggers@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Sep 23, 2020 at 10:47:21PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Dentries that represent no-key names must have a dentry_operations that
> includes fscrypt_d_revalidate().  Currently, this is handled by
> fscrypt_prepare_lookup() installing fscrypt_d_ops.
> 
> However, ceph support for encryption
> (https://lore.kernel.org/r/20200914191707.380444-1-jlayton@kernel.org)
> can't use fscrypt_d_ops, since ceph already has its own
> dentry_operations.
> 
> Similarly, ext4 and f2fs support for directories that are both encrypted
> and casefolded
> (https://lore.kernel.org/r/20200923010151.69506-1-drosen@google.com)
> can't use fscrypt_d_ops either, since casefolding requires some dentry
> operations too.
> 
> To satisfy both users, we need to move the responsibility of installing
> the dentry_operations to filesystems.
> 
> In preparation for this, export fscrypt_d_revalidate() and give it a
> !CONFIG_FS_ENCRYPTION stub.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
> 
> Compared to the versions of this patch from Jeff and Daniel, I've
> improved the commit message and added a !CONFIG_FS_ENCRYPTION stub,
> which was missing.  I'm planning to apply this for 5.10 in preparation
> for both the ceph patchset and the encrypt+casefold patchset.
> 
> 
>  fs/crypto/fname.c       | 3 ++-
>  include/linux/fscrypt.h | 7 +++++++
>  2 files changed, 9 insertions(+), 1 deletion(-)

Applied to fscrypt.git#master for 5.10.

- Eric
