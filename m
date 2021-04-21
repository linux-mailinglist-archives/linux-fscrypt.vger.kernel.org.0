Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 69CD736725B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 21 Apr 2021 20:18:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245144AbhDUSSn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 21 Apr 2021 14:18:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:47448 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238637AbhDUSSl (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 21 Apr 2021 14:18:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 71C256143B;
        Wed, 21 Apr 2021 18:18:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1619029087;
        bh=vvEJ7OhCNNgyEkrC+b1mnLvIJJr1+wwY1dU/KtzL0Bc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=D/SlkDO9lFoi4+cY9RsVJyQPMOqxLruQDKyEtbWsoqMnw71/p2fzGQybqNDaM1ckS
         RD78VtaHdXvEQbY1bqT57FQWCXkV+9Qkzfbtb1AzahdtsfPXaduLqE6eOsxfM9B1FX
         KwABHPKxiS/pdXrF6nMh8Maamju/mVoj4rltWKH9naUnF25qbs0RbgM6l+gE8rCXMw
         bGp1htEbvhYsMikFMdKdY13zodOGi4krJrdH3FkHKrrYWMhd/0566RYwwt5VLtryf9
         v8yMF31+ajp07dmk4NMmSJbGjHe+jtxtVFVHEJXVaEhu+MtgjDsfcJts1kXxSUsmUg
         y5MFZ/aTUIl0w==
Date:   Wed, 21 Apr 2021 11:18:05 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v2 1/2] fscrypt: relax Kconfig dependencies for crypto
 API algorithms
Message-ID: <YIBsXY5QOcEjnZ6I@gmail.com>
References: <20210421075511.45321-1-ardb@kernel.org>
 <20210421075511.45321-2-ardb@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210421075511.45321-2-ardb@kernel.org>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Apr 21, 2021 at 09:55:10AM +0200, Ard Biesheuvel wrote:
> Even if FS encryption has strict functional dependencies on various
> crypto algorithms and chaining modes. those dependencies could potentially
> be satisified by other implementations than the generic ones, and no link
> time dependency exists on the 'depends on' claused defined by
> CONFIG_FS_ENCRYPTION_ALGS.
> 
> So let's relax these clauses to 'imply', so that the default behavior
> is still to pull in those generic algorithms, but in a way that permits
> them to be disabled again in Kconfig.
> 
> Signed-off-by: Ard Biesheuvel <ardb@kernel.org>
> ---

Acked-by: Eric Biggers <ebiggers@google.com>

Herbert, is there still time for you to take these two patches through the
crypto tree for 5.13?  There aren't any other fscrypt or fsverity patches for
5.13, so that would be easiest for me.

- Eric
