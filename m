Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F9543D41AC
	for <lists+linux-fscrypt@lfdr.de>; Fri, 23 Jul 2021 22:43:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229657AbhGWUCX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 23 Jul 2021 16:02:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37160 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229530AbhGWUCW (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 23 Jul 2021 16:02:22 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 75F8160F23;
        Fri, 23 Jul 2021 20:42:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627072975;
        bh=TQl9qpbSL80dQcAC9WCWLAGTK4VIfAAnAyZ6NEgT94M=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=T1+CBtZyuA9OIlEWZhVkp/TH/VYyWc/syzT/QR7XR/sSNAqlNn4jkiyy5MWY4ad6H
         /Um9CPCGc2BTgVe5udLbu6YXr3zNu3Tj5HTvkQldQws8yBAst9mXG058FjKfPYm8FG
         lFJv6t0o9xd+CM25ebapR9MFZ743Q7FMKIF+9QvEHFTAhKIuHuJaYlfVVWUROJlykA
         9LGt8F0IwH4Yu59CYyJB1g283VPmCE8tIHrKm3ZwrE5NG7h+eag7crHnaHOCMmKILg
         pfBQULmJlkI7OqponWRHDB+NsVIcDvIZxNi9duVI8cF5ib/oA7qYRGN+5NBvFy7E3B
         i+m57No0e/C6w==
Date:   Fri, 23 Jul 2021 13:42:54 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chao Yu <chao@kernel.org>,
        Jens Axboe <axboe@kernel.dk>,
        "Darrick J . Wong" <darrick.wong@oracle.com>,
        linux-kernel@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, linux-xfs@vger.kernel.org,
        linux-block@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH v9 3/9] fscrypt: add functions for direct I/O support
Message-ID: <YPspzik6k71BD/EJ@gmail.com>
References: <20210604210908.2105870-1-satyat@google.com>
 <20210604210908.2105870-4-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210604210908.2105870-4-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Jun 04, 2021 at 09:09:02PM +0000, Satya Tangirala wrote:
> +bool fscrypt_dio_supported(struct kiocb *iocb, struct iov_iter *iter)
> +{
> +	const struct inode *inode = file_inode(iocb->ki_filp);
> +	const unsigned int blocksize = i_blocksize(inode);
> +
> +	/* If the file is unencrypted, no veto from us. */
> +	if (!fscrypt_needs_contents_encryption(inode))
> +		return true;
> +
> +	/* We only support direct I/O with inline crypto, not fs-layer crypto */
> +	if (!fscrypt_inode_uses_inline_crypto(inode))
> +		return false;
> +
> +	/*
> +	 * Since the granularity of encryption is filesystem blocks, the I/O
> +	 * must be block aligned -- not just disk sector aligned.
> +	 */
> +	if (!IS_ALIGNED(iocb->ki_pos | iov_iter_count(iter), blocksize))
> +		return false;

The above comment should make it clear that "block aligned" here intentionally
applies to just the position and total length, not to the individual data
buffers, for which only disk sector alignment is required.

- Eric
