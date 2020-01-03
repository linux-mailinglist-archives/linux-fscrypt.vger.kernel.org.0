Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 79A3612FAFC
	for <lists+linux-fscrypt@lfdr.de>; Fri,  3 Jan 2020 17:58:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727994AbgACQ6Q (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 3 Jan 2020 11:58:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:51928 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727969AbgACQ6Q (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 3 Jan 2020 11:58:16 -0500
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 637B2206DB
        for <linux-fscrypt@vger.kernel.org>; Fri,  3 Jan 2020 16:58:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1578070695;
        bh=YOjAfPhT0RplAxeR04xru2egqefA61SRCIkmZZ6DL5A=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=PtFbi3CEJtQn4qSa7ma1La2Ut1rpDnlk3EElO9UlWoDhjF/y+hJfZ1azZ1goKir0Q
         wRvyK1+rhG/6mtewT9aJoxk7JEPlW/HMU49GvH9rxewijjyM2BpAMonNUJCHMRlxvD
         Z5D58uMwnSQh6L6P7zf2ENCcIpkcrrn3oiNMiu1g=
Date:   Fri, 3 Jan 2020 08:58:14 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] fscrypt: verify that the crypto_skcipher has the correct
 ivsize
Message-ID: <20200103165813.GD19521@gmail.com>
References: <20191209203918.225691-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191209203918.225691-1-ebiggers@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Dec 09, 2019 at 12:39:18PM -0800, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> As a sanity check, verify that the allocated crypto_skcipher actually
> has the ivsize that fscrypt is assuming it has.  This will always be the
> case unless there's a bug.  But if there ever is such a bug (e.g. like
> there was in earlier versions of the ESSIV conversion patch [1]) it's
> preferable for it to be immediately obvious, and not rely on the
> ciphertext verification tests failing due to uninitialized IV bytes.
> 
> [1] https://lkml.kernel.org/linux-crypto/20190702215517.GA69157@gmail.com/
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  fs/crypto/keysetup.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
> index c9f4fe955971f..39fdea79e912f 100644
> --- a/fs/crypto/keysetup.c
> +++ b/fs/crypto/keysetup.c
> @@ -91,6 +91,10 @@ struct crypto_skcipher *fscrypt_allocate_skcipher(struct fscrypt_mode *mode,
>  		pr_info("fscrypt: %s using implementation \"%s\"\n",
>  			mode->friendly_name, crypto_skcipher_driver_name(tfm));
>  	}
> +	if (WARN_ON(crypto_skcipher_ivsize(tfm) != mode->ivsize)) {
> +		err = -EINVAL;
> +		goto err_free_tfm;
> +	}
>  	crypto_skcipher_set_flags(tfm, CRYPTO_TFM_REQ_FORBID_WEAK_KEYS);
>  	err = crypto_skcipher_setkey(tfm, raw_key, mode->keysize);
>  	if (err)
> -- 
> 2.24.0.393.g34dc348eaf-goog
> 

Applied to fscrypt.git#master for 5.6.

- Eric
