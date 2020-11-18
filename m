Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 66D0F2B743E
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 Nov 2020 03:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726249AbgKRCid (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Nov 2020 21:38:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:51716 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725771AbgKRCid (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Nov 2020 21:38:33 -0500
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7974820DD4;
        Wed, 18 Nov 2020 02:38:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605667112;
        bh=0xBS4bl1HG6FHMZyBv854rnwnYW4g9JK5pyX1iZXkXQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=CcVCAHnfikOI7obL4iDkX+pvxV6BkoVhq3i/nMv2YQGL3dWvNP1JNTF5fTrtwpN93
         f73dmtTBLP6+ftYAdEFbfMbYoah6meAKGR7YgEn/KW+Ly6WbpnJD6yQ/YU4YuTsvDG
         n9jx4eTxwSArJUNexi06Kz57cAZar0eTEOVpb7nY=
Date:   Tue, 17 Nov 2020 18:38:30 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v7 8/8] fscrypt: update documentation for direct I/O
 support
Message-ID: <X7SJJp7yBhp1t1VX@sol.localdomain>
References: <20201117140708.1068688-1-satyat@google.com>
 <20201117140708.1068688-9-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117140708.1068688-9-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Nov 17, 2020 at 02:07:08PM +0000, Satya Tangirala wrote:
> +Direct I/O support
> +==================
> +
> +Direct I/O on encrypted files is supported through blk-crypto. In
> +particular, this means the kernel must have CONFIG_BLK_INLINE_ENCRYPTION
> +enabled, the filesystem must have had the 'inlinecrypt' mount option
> +specified, and either hardware inline encryption must be present, or
> +CONFIG_BLK_INLINE_ENCRYPTION_FALLBACK must have been enabled. Further,
> +the length of any I/O must be aligned to the filesystem block size
> +(*not* necessarily the same as the block device's block size). If any of
> +these conditions isn't met, attempts to do direct I/O on an encrypted file
> +will fall back to buffered I/O. However, there aren't any additional
> +requirements on user buffer alignment (apart from those already present
> +when using direct I/O on unencrypted files).

Actually the position in the file the I/O is targeting must be fs-block aligned
too, not just the length of the I/O.

It's only the pointer to the user data buffer that no longer needs to be
fs-block aligned (this changed between v6 and v7).

- Eric
