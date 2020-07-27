Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C558022F57C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 27 Jul 2020 18:35:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732375AbgG0QfW (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 27 Jul 2020 12:35:22 -0400
Received: from mail.kernel.org ([198.145.29.99]:33874 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729315AbgG0QfV (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 27 Jul 2020 12:35:21 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1886C20729;
        Mon, 27 Jul 2020 16:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1595867721;
        bh=Najnwn6ct2tS23uzjWWO8aAe31i35Vpz52OO8sKRDZM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=sqfNr5jE3Q7DGAj+IYToNrMuvjqaJg4KuB2rk+RFFpAP619xIZIVo/IX2AgfYRtM4
         kDT90jODcRriTGURbrxNmJqDJgz+f0UZW2l2hhzEEhOYmz24f7ML6RDyfgrzsrRyll
         3XYnn3SR8g5gboxlByBVl86Y9Q622I7sE2y9BDPg=
Date:   Mon, 27 Jul 2020 09:35:19 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Cc:     linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net,
        Paul Crowley <paulcrowley@google.com>,
        Satya Tangirala <satyat@google.com>
Subject: Re: [PATCH] fscrypt: restrict IV_INO_LBLK_* to AES-256-XTS
Message-ID: <20200727163519.GB1138@sol.localdomain>
References: <20200721181012.39308-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200721181012.39308-1-ebiggers@kernel.org>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jul 21, 2020 at 11:10:12AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> IV_INO_LBLK_* exist only because of hardware limitations, and currently
> the only known use case for them involves AES-256-XTS.  Therefore, for
> now only allow them in combination with AES-256-XTS.  This way we don't
> have to worry about them being combined with other encryption modes.
> 
> (To be clear, combining IV_INO_LBLK_* with other encryption modes
> *should* work just fine.  It's just not being tested, so we can't be
> 100% sure it works.  So with no known use case, it's best to disallow it
> for now, just like we don't allow other weird combinations like
> AES-256-XTS contents encryption with Adiantum filenames encryption.)
> 
> This can be relaxed later if a use case for other combinations arises.
> 
> Fixes: b103fb7653ff ("fscrypt: add support for IV_INO_LBLK_64 policies")
> Fixes: e3b1078bedd3 ("fscrypt: add support for IV_INO_LBLK_32 policies")
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/policy.c | 14 ++++++++++++++
>  1 file changed, 14 insertions(+)
> 
> diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
> index 8a8ad0e44bb8..8e667aadf271 100644
> --- a/fs/crypto/policy.c
> +++ b/fs/crypto/policy.c
> @@ -77,6 +77,20 @@ static bool supported_iv_ino_lblk_policy(const struct fscrypt_policy_v2 *policy,
>  	struct super_block *sb = inode->i_sb;
>  	int ino_bits = 64, lblk_bits = 64;
>  
> +	/*
> +	 * IV_INO_LBLK_* exist only because of hardware limitations, and
> +	 * currently the only known use case for them involves AES-256-XTS.
> +	 * That's also all we test currently.  For these reasons, for now only
> +	 * allow AES-256-XTS here.  This can be relaxed later if a use case for
> +	 * IV_INO_LBLK_* with other encryption modes arises.
> +	 */
> +	if (policy->contents_encryption_mode != FSCRYPT_MODE_AES_256_XTS) {
> +		fscrypt_warn(inode,
> +			     "Can't use %s policy with contents mode other than AES-256-XTS",
> +			     type);
> +		return false;
> +	}
> +
>  	/*
>  	 * It's unsafe to include inode numbers in the IVs if the filesystem can
>  	 * potentially renumber inodes, e.g. via filesystem shrinking.
> -- 

Applied to fscrypt.git#master for 5.9.

- Eric
