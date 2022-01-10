Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B91F48A31C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Jan 2022 23:45:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242232AbiAJWpm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Jan 2022 17:45:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241804AbiAJWpm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Jan 2022 17:45:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42D25C06173F;
        Mon, 10 Jan 2022 14:45:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD15EB81809;
        Mon, 10 Jan 2022 22:45:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54162C36AE9;
        Mon, 10 Jan 2022 22:45:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641854738;
        bh=qImdSLTuJfMY5HYLu9wyX2EynZn4qMBdqyfdFxh35Rk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kTGVE5yWDjRzi44VdBFnXNuz6opIMZgwnVeV9j4oVc2rmdUGLtkksBlktdIErZmld
         pKupJYcLrH32aB9OZBOij5mLeIm/lA23nl2yqrENkikiSv3NvRt6NvcNQvOI8hmJ8q
         U6ZtziL/5AZtdrD/iNQypS48ONhMzJ1xSKO+8o9nE0Y4tft7KFnomEbrQucwtXm6hq
         1uIuxPR3O+FkuqpGAUn4PNPPujY4AWWrjty+ni5ZD/sWDHs/3uyYKs9N6mu5hI8yGK
         064MJex2h3XU3raw0TFUBitywe1eY9R9slw/SPbzN0xR7IRFHwmUt7lPx+htO0FgWB
         i7n1sQVlCildg==
Date:   Mon, 10 Jan 2022 14:45:36 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 5/6] ima: support fs-verity file digest based
 signatures
Message-ID: <Ydy3EA9ONY3kn1xr@gmail.com>
References: <20220109185517.312280-1-zohar@linux.ibm.com>
 <20220109185517.312280-6-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220109185517.312280-6-zohar@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Jan 09, 2022 at 01:55:16PM -0500, Mimi Zohar wrote:
> +	case IMA_VERITY_DIGSIG:
> +		set_bit(IMA_DIGSIG, &iint->atomic_flags);
> +
> +		algo = iint->ima_hash->algo;
> +		hash = kzalloc(sizeof(*hash) + hash_digest_size[algo],
> +			       GFP_KERNEL);
> +		if (!hash) {
> +			*cause = "verity-hashing-error";
> +			*status = INTEGRITY_FAIL;
> +			break;
> +		}
> +
> +		rc = calc_tbs_hash(IMA_VERITY_DIGSIG, iint->ima_hash->algo,
> +				   iint->ima_hash->digest, hash);
> +		if (rc) {
> +			*cause = "verity-hashing-error";
> +			*status = INTEGRITY_FAIL;
> +			break;
> +		}
> +
> +		rc = integrity_digsig_verify(INTEGRITY_KEYRING_IMA,
> +					     (const char *)xattr_value,
> +					     xattr_len, hash->digest,
> +					     hash->length);

This is still verifying a raw hash value, which is wrong as I've explained
several times.  Yes, you are now hashing the hash algorithm ID together with the
original hash value, but at the end the thing being signed/verified is still a
raw hash value, which is ambigious.

I think I see where the confusion is.  If rsa-pkcs1pad is used, then the
asymmetric algorithm is parameterized by a hash algorithm, and this hash
algorithm's identifier is automatically built-in to the data which is
signed/verified.  And the data being signed/verified is assumed to be a hash
value of the same type.  So in this case, the caller doesn't need to handle
disambiguating raw hashes.

However, asymmetric_verify() also supports ecdsa and ecrdsa signatures.  As far
as I can tell, those do *not* have the hash algorithm identifier built-in to the
data which is signed/verified; they just sign/verify the data given.  That
creates an ambiguity if the hash algorithm identifier is not included.  For
example, someone might have intended to sign the SHA-256 hash
01ba4719c80b6fe911b091a7c05124b64eeece964e09c058ef8f9805daca546b.  However, the
Streebog or SM3 hash
01ba4719c80b6fe911b091a7c05124b64eeece964e09c058ef8f9805daca546b would also pass
the signature check too.  That's wrong; to have a valid cryptosystem, you
mustn't let the adversary choose the crypto algorithms for you.

I'm not sure how this can be reconciled, given the differences between
rsa-pkcs1pad and ecdsa and ecrdsa.  Could you just use the lowest common
denominator and prepend the hash algorithm ID to the hash value, or would that
cause issues with rsa-pkcs1pad?  In any case, to move forward you're going to
need to solve this problem.

- Eric
