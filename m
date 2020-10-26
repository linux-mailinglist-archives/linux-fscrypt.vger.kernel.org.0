Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6320829964E
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Oct 2020 19:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1791092AbgJZS6b (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Oct 2020 14:58:31 -0400
Received: from mail.kernel.org ([198.145.29.99]:46692 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1791036AbgJZS6I (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Oct 2020 14:58:08 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D2C12168B;
        Mon, 26 Oct 2020 18:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603738688;
        bh=9OmM1TGc2mfuTLnDbUUC0BvWm2ESUjdiFa5S0pZCNUY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LUkPip5bFbKEsm6qCtbDcD6ADGnZ+IzfWH006wqULQRDw3wGgjpdJaUL4qX2BWZJx
         CbDexs5RPShUnpLiAKsH8X2/2EaHAlA40w9NhuM8tdmSy8MlygxXIoI58RTKmg62v5
         6xz0er6SGu2khoDIWpGaWt8HS+3KuM6pDY9l+0So=
Date:   Mon, 26 Oct 2020 11:58:06 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     luca.boccassi@gmail.com
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH v4] Add digest sub command
Message-ID: <20201026185806.GK858@sol.localdomain>
References: <20201026181105.3322022-1-luca.boccassi@gmail.com>
 <20201026181729.3322756-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026181729.3322756-1-luca.boccassi@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Oct 26, 2020 at 06:17:29PM +0000, luca.boccassi@gmail.com wrote:
> +/* Compute a file's fs-verity measurement, then print it in hex format. */
> +int fsverity_cmd_digest(const struct fsverity_command *cmd,
> +		      int argc, char *argv[])

Since it can be more than one file now:

/* Compute the fs-verity measurement of the given file(s), for offline signing */

> +	for (int i = 0; i < argc; i++) {
> +		struct filedes file = { .fd = -1 };
> +		struct fsverity_signed_digest *d = NULL;
> +		struct libfsverity_digest *digest = NULL;
> +		char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 + sizeof(struct fsverity_signed_digest) * 2 + 1];
> +
> +		if (!open_file(&file, argv[i], O_RDONLY, 0))
> +			goto out_err;
> +
> +		if (!get_file_size(&file, &tree_params.file_size))
> +			goto out_err;

'file' doesn't get closed on error.  Making it back to the outer scope would fix
that.

> +		if (compact)
> +			printf("%s\n", digest_hex);
> +		else
> +			printf("%s:%s %s\n",
> +				libfsverity_get_hash_name(tree_params.hash_algorithm),
> +				digest_hex, argv[i]);

I don't think the hash algorithm should be printed in the
'!compact && for_builtin_sig' case, since it's already included in the struct
that gets hex-encoded.  I.e.

		else if (for_builtin_sig)
			printf("%s %s\n", digest_hex, argv[i]);

> diff --git a/programs/fsverity.c b/programs/fsverity.c
> index 95f6964..c7c4f75 100644
> --- a/programs/fsverity.c
> +++ b/programs/fsverity.c
> @@ -21,6 +21,14 @@ static const struct fsverity_command {
>  	const char *usage_str;
>  } fsverity_commands[] = {
>  	{
> +		.name = "digest",
> +		.func = fsverity_cmd_digest,
> +		.short_desc = "Compute and print hex-encoded fs-verity digest of a file, for offline signing",

Likewise, since this can now accept multiple files:

"Compute the fs-verity measurement of the given file(s), for offline signing"

(I don't think that "printed as hex" needs to be explicitly mentioned here.)

- Eric
