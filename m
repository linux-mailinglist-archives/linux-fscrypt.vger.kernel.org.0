Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E76FE18E6B2
	for <lists+linux-fscrypt@lfdr.de>; Sun, 22 Mar 2020 06:27:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725892AbgCVF1G (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 22 Mar 2020 01:27:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:46416 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725825AbgCVF1G (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 22 Mar 2020 01:27:06 -0400
Received: from sol.localdomain (c-107-3-166-239.hsd1.ca.comcast.net [107.3.166.239])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8916C20714;
        Sun, 22 Mar 2020 05:27:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1584854825;
        bh=3tPqKskSr5lQsX9WP7rT/fLJSZJLoBMJXat8RRRPd3Y=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kFR1+5H+Dl5O0XDw/wI6HXzky8HrE6kEPvlgXqE6fX/cxeX+MmtJuYk+o+owr8/fa
         KmJz7ey/Qb6Vqn3YqptzSG59lKQqwhL8piTsni24GmFnZAehwjUFkmUjPTVLsnasai
         mjzYtQSJ9DaSb9mvVXDHI3Rpq4V8hAe4kMzhX+iM=
Date:   Sat, 21 Mar 2020 22:27:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jes Sorensen <jes.sorensen@gmail.com>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: Re: [PATCH 8/9] Validate input parameters for
 libfsverity_sign_digest()
Message-ID: <20200322052704.GF111151@sol.localdomain>
References: <20200312214758.343212-1-Jes.Sorensen@gmail.com>
 <20200312214758.343212-9-Jes.Sorensen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200312214758.343212-9-Jes.Sorensen@gmail.com>
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Mar 12, 2020 at 05:47:57PM -0400, Jes Sorensen wrote:
> From: Jes Sorensen <jsorensen@fb.com>
> 
> Return -EINVAL on any invalid input argument, as well
> as if any of the reserved fields are set in
> struct libfsverity_signature_digest
> 
> Signed-off-by: Jes Sorensen <jsorensen@fb.com>
> ---
>  libverity.c | 34 ++++++++++++++++++++++++++--------
>  1 file changed, 26 insertions(+), 8 deletions(-)
> 
> diff --git a/libverity.c b/libverity.c
> index 1cef544..e16306d 100644
> --- a/libverity.c
> +++ b/libverity.c
> @@ -494,18 +494,36 @@ libfsverity_sign_digest(const struct libfsverity_digest *digest,
>  	X509 *cert = NULL;
>  	const EVP_MD *md;
>  	size_t data_size;
> -	uint16_t alg_nr;
> -	int retval = -EAGAIN;
> +	uint16_t alg_nr, digest_size;
> +	int i, retval = -EAGAIN;
> +	const char magic[8] = "FSVerity";
> +
> +	if (!digest || !sig_params || !sig_ret || !sig_size_ret)
> +		return -EINVAL;
> +
> +	if (strncmp(digest->magic, magic, sizeof(magic)))
> +		return -EINVAL;
> +
> +	if (!sig_params->keyfile || !sig_params->certfile)
> +		return -EINVAL;
> +
> +	for (i = 0; i < sizeof(sig_params->reserved) /
> +		     sizeof(sig_params->reserved[0]); i++) {
> +		if (sig_params->reserved[i])
> +			return -EINVAL;
> +	}

This can use ARRAY_SIZE().

- Eric
