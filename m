Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 599DB466BEE
	for <lists+linux-fscrypt@lfdr.de>; Thu,  2 Dec 2021 23:08:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231365AbhLBWLX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Dec 2021 17:11:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56090 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231210AbhLBWLW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Dec 2021 17:11:22 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17CBCC06174A;
        Thu,  2 Dec 2021 14:08:00 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B793B62876;
        Thu,  2 Dec 2021 22:07:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 007C5C00446;
        Thu,  2 Dec 2021 22:07:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638482878;
        bh=CfMssIAvzeTzGxLKQ92CmTNaGanKM9UxFjN/LwST5Rk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n/VWCC19Ckmx89AdHTh5R1aiB9KwY2I+ebjblK2RzeURINUa4PqUgZ+br2r2lpz19
         CS9zvlleNjir+0hgaEes0WFVVt6omC8k2xzVav/Jeqv0TQCt1ENuTHBee3+vxBlPt/
         gTGlK6HsVMNwMfG2dLabvaL1CQpgEr34g7DfYOfE0b92+STsPXNb9pdWSpL4uWePuJ
         j3RRnVS/28TPfFuNg7ZFyrSazDO+ep6klcvypfszza8i12VCybor0DjT2rauwRr7K4
         fJaWcNJQhqzeA190UxxP5ykUrlp1TLHMdDDmOn68eoN8iFXQxm6IsmLvYs7AvvLxH9
         mrJuPnaTuOudA==
Date:   Thu, 2 Dec 2021 14:07:56 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1 4/5] ima: support fs-verity file digest based
 signatures
Message-ID: <YalDvGjq0inMFKln@sol.localdomain>
References: <20211202215507.298415-1-zohar@linux.ibm.com>
 <20211202215507.298415-5-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211202215507.298415-5-zohar@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 02, 2021 at 04:55:06PM -0500, Mimi Zohar wrote:
>  	case IMA_VERITY_DIGSIG:
> -		fallthrough;
> +		set_bit(IMA_DIGSIG, &iint->atomic_flags);
> +
> +		/*
> +		 * The IMA signature is based on a hash of IMA_VERITY_DIGSIG
> +		 * and the fs-verity file digest, not directly on the
> +		 * fs-verity file digest.  Both digests should probably be
> +		 * included in the IMA measurement list, but for now this
> +		 * digest is only used for verifying the IMA signature.
> +		 */
> +		verity_digest[0] = IMA_VERITY_DIGSIG;
> +		memcpy(verity_digest + 1, iint->ima_hash->digest,
> +		       iint->ima_hash->length);
> +
> +		hash.hdr.algo = iint->ima_hash->algo;
> +		hash.hdr.length = iint->ima_hash->length;

This is still wrong because the bytes being signed don't include the hash
algorithm.  Unless you mean for it to be implicitly always SHA-256?  fs-verity
supports SHA-512 too, and it may support other hash algorithms in the future.

- Eric
