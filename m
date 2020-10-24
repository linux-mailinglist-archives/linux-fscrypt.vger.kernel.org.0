Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAD2D297AA7
	for <lists+linux-fscrypt@lfdr.de>; Sat, 24 Oct 2020 06:23:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1759480AbgJXEXQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 24 Oct 2020 00:23:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:43414 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759479AbgJXEXQ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 24 Oct 2020 00:23:16 -0400
Received: from sol.localdomain (172-10-235-113.lightspeed.sntcca.sbcglobal.net [172.10.235.113])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A92202226B;
        Sat, 24 Oct 2020 04:23:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603513395;
        bh=ZG8s0yBLcZqLqIPgjnFpXuxS2idzA9F+vTcXAY10la4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EzNDRikVF/PkZYN0QwTwsLtFQNl90+rw81KU+5gfe5UqtlQ/J4OJMNorRuCm5rLy2
         yn/3FqpJ0i3kFIRCYIkNzF4W776xjqgg8kpoMjPZVMsiamGVH6b4qZ0q6RjZ/Zguc5
         0FJ1UNoJdX/kqCu1aelD2G+cT56hdNIkSo6Tl3AM=
Date:   Fri, 23 Oct 2020 21:23:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     luca.boccassi@gmail.com
Cc:     linux-fscrypt@vger.kernel.org
Subject: Re: [fsverity-utils PATCH] Add digest sub command
Message-ID: <20201024042314.GC83494@sol.localdomain>
References: <20201022172155.2994326-1-luca.boccassi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201022172155.2994326-1-luca.boccassi@gmail.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 22, 2020 at 06:21:55PM +0100, luca.boccassi@gmail.com wrote:
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
> +    bool compact = false;
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
> +
> +	if (tree_params.hash_algorithm == 0)
> +		tree_params.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
> +
> +	if (tree_params.block_size == 0)
> +		tree_params.block_size = get_default_block_size();
> +
> +	if (!open_file(&file, argv[0], O_RDONLY, 0))
> +		goto out_err;
> +
> +	if (!get_file_size(&file, &tree_params.file_size))
> +		goto out_err;
> +
> +	if (libfsverity_compute_digest(&file, read_callback,
> +				       &tree_params, &digest) != 0) {
> +		error_msg("failed to compute digest");
> +		goto out_err;
> +	}
> +
> +	ASSERT(digest->digest_size <= FS_VERITY_MAX_DIGEST_SIZE);
> +
> +	d = xzalloc(sizeof(*d) + digest->digest_size);
> +	if (!d)
> +		goto out_err;
> +	memcpy(d->magic, "FSVerity", 8);
> +	d->digest_algorithm = cpu_to_le16(digest->digest_algorithm);
> +	d->digest_size = cpu_to_le16(digest->digest_size);
> +	memcpy(d->digest, digest->digest, digest->digest_size);
> +
> +	bin2hex((const u8 *)d, sizeof(*d) + digest->digest_size, digest_hex);
> +
> +	if (compact)
> +		printf("%s", digest_hex);
> +	else
> +		printf("File '%s' (%s:%s)\n", argv[0],
> +			   libfsverity_get_hash_name(tree_params.hash_algorithm),
> +			   digest_hex);

Can you make this command format its output in the same way as
'fsverity measure' by default, and put the 'struct fsverity_signed_digest'
formatted output behind an option, like --for-builtin-sig?

The 'struct fsverity_signed_digest' is specific to the builtin (in-kernel)
signature support, which isn't the only way to use fs-verity.  The signature
verification can also be done in userspace, which is more flexible.  (And you
should consider doing it that way, if you haven't already.  I'm not sure exactly
what your use case is.)

So when possible, I'd like to have the default be the basic fs-verity feature.
If someone then specifically wants to use the builtin signature support on top
of that, as opposed to using fs-verity in another way, then they can provide the
option they need to do that.

Separately, it would also be nice to share more code with cmd_sign.c, as they
both have to parse a lot of the same options.  Maybe it doesn't work out,
though.

- Eric
