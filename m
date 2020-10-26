Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C7811299441
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Oct 2020 18:48:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1788378AbgJZRsS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Oct 2020 13:48:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1788178AbgJZRsR (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Oct 2020 13:48:17 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66E632225C;
        Mon, 26 Oct 2020 17:48:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603734496;
        bh=Y/klYQ1p93ZgHujrbQV8uGGng+pmCbRu1+oBcbn1WDI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=WsgG1r9Q+WI3vpxe6p59BgwU2MRDuJ7Bg1fpD6yLuZ8tUHXZh/KCsYKlKAEHt4StJ
         wvjYnu+2baBe/Uj4dXUF+P55R3S99w6NnVQLfawwGmtpVkNkSRQNl0siZOmZ9qaF0b
         ha7sRS7fBc5cfjHdCR0WuCnPv6EYtkwkD9fYtpig=
Date:   Mon, 26 Oct 2020 10:48:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     luca.boccassi@gmail.com
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH v2] Add digest sub command
Message-ID: <20201026174814.GF858@sol.localdomain>
References: <20201022172155.2994326-1-luca.boccassi@gmail.com>
 <20201026114007.3218645-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201026114007.3218645-1-luca.boccassi@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Oct 26, 2020 at 11:40:07AM +0000, luca.boccassi@gmail.com wrote:
> +/* Compute a file's fs-verity measurement, then print it in hex format. */
> +int fsverity_cmd_digest(const struct fsverity_command *cmd,
> +		      int argc, char *argv[])
> +{
> +	struct filedes file = { .fd = -1 };
> +	u8 *salt = NULL;
> +	struct libfsverity_merkle_tree_params tree_params = { .version = 1 };
> +	struct libfsverity_digest *digest = NULL;
> +	struct fsverity_signed_digest *d = NULL;
> +	char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 + sizeof(struct fsverity_signed_digest) * 2 + 1];
> +	bool compact = false, for_builtin_sig = false;
> +	int status;
> +	int c;
> +
> +	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
> +		switch (c) {
> +		case OPT_HASH_ALG:
> +			if (!parse_hash_alg_option(optarg,
> +						   &tree_params.hash_algorithm))
> +				goto out_usage;
> +			break;
> +		case OPT_BLOCK_SIZE:
> +			if (!parse_block_size_option(optarg,
> +						     &tree_params.block_size))
> +				goto out_usage;
> +			break;
> +		case OPT_SALT:
> +			if (!parse_salt_option(optarg, &salt,
> +					       &tree_params.salt_size))
> +				goto out_usage;
> +			tree_params.salt = salt;
> +			break;
> +		case OPT_COMPACT:
> +			compact = true;
> +			break;
> +		case OPT_FOR_BUILTIN_SIG:
> +			for_builtin_sig = true;
> +			break;
> +		default:
> +			goto out_usage;
> +		}
> +	}
> +
> +	argv += optind;
> +	argc -= optind;
> +
> +	if (argc != 1)
> +		goto out_usage;

I think this should allow specifying multiple files, like 'fsverity measure'
does.  'fsverity measure' is intended to behave like the sha256sum program.

> +	/* The kernel expects more than the digest as the signed payload */
> +	if (for_builtin_sig) {
> +		d = xzalloc(sizeof(*d) + digest->digest_size);
> +		if (!d)
> +			goto out_err;

No need to check the return value of xzalloc(), since it exits on error.

> +	if (compact)
> +		printf("%s", digest_hex);
> +	else
> +		printf("File '%s' (%s:%s)\n", argv[0],
> +			   libfsverity_get_hash_name(tree_params.hash_algorithm),
> +			   digest_hex);

Please make the output in the !compact case match 'fsverity measure':

	printf("%s:%s %s\n",
	       libfsverity_get_hash_name(tree_params.hash_algorithm),
	       digest_hex, argv[i]);

- Eric
