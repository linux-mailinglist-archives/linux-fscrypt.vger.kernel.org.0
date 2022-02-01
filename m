Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F30AB4A543C
	for <lists+linux-fscrypt@lfdr.de>; Tue,  1 Feb 2022 01:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230449AbiBAAoj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 31 Jan 2022 19:44:39 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:32996 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiBAAoj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 31 Jan 2022 19:44:39 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00826B82CA2;
        Tue,  1 Feb 2022 00:44:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 813BEC340E8;
        Tue,  1 Feb 2022 00:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643676276;
        bh=ju/X/GGaFTTEk2f18Uuh2WjARBDQWIrw62FMJwxvO54=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=bABGfsqZD/n58k6aXZV1OvrVOyRvUI23u8fEqdQwIRo43D6bRAs/NUSSlzDHPiIGk
         rUkSllcxL95IgaOeolfnRwFWUp8N6s4NVk5SR52BzLVPjCNzHvJr75zZdLUDpRD43U
         SNX8sIlhU1FhYQKBIHgZlVuBKmDuMK12Jl5hfUVF7YkGh0JUHKa7g3q0Z6tqzGxZu1
         ASFJzRZS5GLH/ts9Yx2vLR9tLHvkYnWsla+SDA8JXr0NWWQc9DOFpredj93xp6S0Gt
         AqZrRkK4h/coMKcSOuqItPy8wKMyGZ3LKGbAI4KJwew8gc4AvFYRJlDJUuOJSy2SsI
         u0lM2QWih4GBg==
Date:   Mon, 31 Jan 2022 16:44:35 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org,
        Stefan Berger <stefanb@linux.ibm.com>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 3/8] fs-verity: define a function to return the
 integrity protected file digest
Message-ID: <YfiCc9XXzbQz9rqy@sol.localdomain>
References: <20220126000658.138345-1-zohar@linux.ibm.com>
 <20220126000658.138345-4-zohar@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220126000658.138345-4-zohar@linux.ibm.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jan 25, 2022 at 07:06:53PM -0500, Mimi Zohar wrote:
> +	hash_alg = vi->tree_params.hash_alg;
> +	memset(digest, 0, FS_VERITY_MAX_DIGEST_SIZE);
> +
> +	/* convert hash algorithm to hash_algo_name */
> +	i = match_string(hash_algo_name, HASH_ALGO__LAST, hash_alg->name);
> +	if (i < 0)
> +		return -EINVAL;
> +	*alg = i;

The above comment is backwards.  This code is converting a hash algorithm name
to an ID.  The comment is unclear, but it sounds like it's saying the opposite.

> +
> +	memcpy(digest, vi->file_digest, hash_alg->digest_size);

Here there are two "sources of truth" for the digest size.  How about checking
that they are the same:

	if (WARN_ON_ONCE(hash_alg->digest_size != hash_digest_size[*alg]))
		return -EINVAL;

- Eric
