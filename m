Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 871EF298C39
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Oct 2020 12:49:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1770791AbgJZLtZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Oct 2020 07:49:25 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:35403 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1736795AbgJZLtZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Oct 2020 07:49:25 -0400
Received: by mail-wr1-f66.google.com with SMTP id n15so12113541wrq.2
        for <linux-fscrypt@vger.kernel.org>; Mon, 26 Oct 2020 04:49:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=oqRluCnoHw8Lfmk1ATTDT3MaJeE6uwhJOSx3CM1rkwM=;
        b=CjBIDN5cu5eJOUSFLuZZ3IUTRwxIWy+A3Nkd9eto2qXemQp05HAmwzPCPb23K9KtqQ
         tQDRIj3x7tDJXG8eMeQTSxHosl97dRtLGXogKbfcXQ6aPqD9/l9g2RlxO346WEzXjAsy
         3Rw78Akx6zbsQcQEDTmEoqv9/uSPwLsNPGjQpciwpxgeaWXs4fRXgGKdlVBuw7eLQbTc
         O7C5eLjt16uD5Lua1ZATdHlVCt+2rJORCNU24bE7FQAHNF3K4E3SsqZrbZssy1G3EORi
         GXnGjW4FGiZ0XsIWdh8qLOVajj/dp4fSVm9Nz2MsVmqvjAgp8QUkKwYiknkLbVoFSiaH
         1CuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=oqRluCnoHw8Lfmk1ATTDT3MaJeE6uwhJOSx3CM1rkwM=;
        b=XdKmdwrZ3VrGEdAQDUAAfFvrgK/QKNYLjLnpXofiZitF2+89U1PybjqwSYkvQnQxSu
         lwMoLYuAQKLozc3XfES8Fu5D2C8ELq6+Lj2miW1aTKHCboiAk633AuJh9WGd7ybQnSjt
         Pd3LmT7+YjM2uRnmrO3WvlvgSxfNXN24mHtx+kz3lIY4uFtyqy75dj00Q2Oho4p4K84O
         ByNCy+nBddHxP5quVait/XxxETEChaErZUZLZ9po3dvTuBcqCeT6WUQXR14e+SjvspKc
         nslDZH8uCCrvzEU4HwtkuSRNfaLeN/xLmfzQfwG/WTogSUx1AAAVlWywOsI3IbrYTTGA
         v6zA==
X-Gm-Message-State: AOAM5307sgety3VGtDCuUu8dfg3dqTXFGtHPw+Qn4XjlDUZk2gufGzhQ
        Dv9RIuskYPECodKSxh+ZySpdIIUoRYmQNkIS
X-Google-Smtp-Source: ABdhPJyu1T7uiq23f/1CyJ7dRCsPre+9btTHL6lhOvi6Xfv9/NMQkiPs1ea/nq/t56pq5txYtUvlnA==
X-Received: by 2002:a5d:640d:: with SMTP id z13mr16756033wru.28.1603712961554;
        Mon, 26 Oct 2020 04:49:21 -0700 (PDT)
Received: from bluca-lenovo ([2a01:4b00:f419:6f00:7a8e:ed70:5c52:ea3])
        by smtp.gmail.com with ESMTPSA id j5sm24077622wrx.88.2020.10.26.04.49.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 04:49:20 -0700 (PDT)
Message-ID: <f82ee84b97d194a8512bc5385a2012b42f78b55f.camel@gmail.com>
Subject: Re: [fsverity-utils PATCH] Add digest sub command
From:   Luca Boccassi <luca.boccassi@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Date:   Mon, 26 Oct 2020 11:49:20 +0000
In-Reply-To: <20201024042314.GC83494@sol.localdomain>
References: <20201022172155.2994326-1-luca.boccassi@gmail.com>
         <20201024042314.GC83494@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, 2020-10-23 at 21:23 -0700, Eric Biggers wrote:
> On Thu, Oct 22, 2020 at 06:21:55PM +0100, luca.boccassi@gmail.com wrote:
> > +/* Compute a file's fs-verity measurement, then print it in hex format. */
> > +int fsverity_cmd_digest(const struct fsverity_command *cmd,
> > +		      int argc, char *argv[])
> > +{
> > +	struct filedes file = { .fd = -1 };
> > +	u8 *salt = NULL;
> > +	struct libfsverity_merkle_tree_params tree_params = { .version = 1 };
> > +	struct libfsverity_digest *digest = NULL;
> > +	struct fsverity_signed_digest *d = NULL;
> > +	char digest_hex[FS_VERITY_MAX_DIGEST_SIZE * 2 + sizeof(struct fsverity_signed_digest) * 2 + 1];
> > +    bool compact = false;
> > +	int status;
> > +	int c;
> > +
> > +	while ((c = getopt_long(argc, argv, "", longopts, NULL)) != -1) {
> > +		switch (c) {
> > +		case OPT_HASH_ALG:
> > +			if (!parse_hash_alg_option(optarg,
> > +						   &tree_params.hash_algorithm))
> > +				goto out_usage;
> > +			break;
> > +		case OPT_BLOCK_SIZE:
> > +			if (!parse_block_size_option(optarg,
> > +						     &tree_params.block_size))
> > +				goto out_usage;
> > +			break;
> > +		case OPT_SALT:
> > +			if (!parse_salt_option(optarg, &salt,
> > +					       &tree_params.salt_size))
> > +				goto out_usage;
> > +			tree_params.salt = salt;
> > +			break;
> > +		case OPT_COMPACT:
> > +			compact = true;
> > +			break;
> > +		default:
> > +			goto out_usage;
> > +		}
> > +	}
> > +
> > +	argv += optind;
> > +	argc -= optind;
> > +
> > +	if (argc != 1)
> > +		goto out_usage;
> > +
> > +	if (tree_params.hash_algorithm == 0)
> > +		tree_params.hash_algorithm = FS_VERITY_HASH_ALG_DEFAULT;
> > +
> > +	if (tree_params.block_size == 0)
> > +		tree_params.block_size = get_default_block_size();
> > +
> > +	if (!open_file(&file, argv[0], O_RDONLY, 0))
> > +		goto out_err;
> > +
> > +	if (!get_file_size(&file, &tree_params.file_size))
> > +		goto out_err;
> > +
> > +	if (libfsverity_compute_digest(&file, read_callback,
> > +				       &tree_params, &digest) != 0) {
> > +		error_msg("failed to compute digest");
> > +		goto out_err;
> > +	}
> > +
> > +	ASSERT(digest->digest_size <= FS_VERITY_MAX_DIGEST_SIZE);
> > +
> > +	d = xzalloc(sizeof(*d) + digest->digest_size);
> > +	if (!d)
> > +		goto out_err;
> > +	memcpy(d->magic, "FSVerity", 8);
> > +	d->digest_algorithm = cpu_to_le16(digest->digest_algorithm);
> > +	d->digest_size = cpu_to_le16(digest->digest_size);
> > +	memcpy(d->digest, digest->digest, digest->digest_size);
> > +
> > +	bin2hex((const u8 *)d, sizeof(*d) + digest->digest_size, digest_hex);
> > +
> > +	if (compact)
> > +		printf("%s", digest_hex);
> > +	else
> > +		printf("File '%s' (%s:%s)\n", argv[0],
> > +			   libfsverity_get_hash_name(tree_params.hash_algorithm),
> > +			   digest_hex);
> 
> Can you make this command format its output in the same way as
> 'fsverity measure' by default, and put the 'struct fsverity_signed_digest'
> formatted output behind an option, like --for-builtin-sig?

Sure, done in v2.

> The 'struct fsverity_signed_digest' is specific to the builtin (in-kernel)
> signature support, which isn't the only way to use fs-verity.  The signature
> verification can also be done in userspace, which is more flexible.  (And you
> should consider doing it that way, if you haven't already.  I'm not sure exactly
> what your use case is.)

Our use case is to ultimately add kernel-side policy enforcement of
integrity via the IPE LSM: https://microsoft.github.io/ipe/ so we can't
do without kernel verification. I need the new command as I've got some
teams building and signing on Windows, using whatever native API is
available there, so can't use the 'fsverity sign' command.

> So when possible, I'd like to have the default be the basic fs-verity feature.
> If someone then specifically wants to use the builtin signature support on top
> of that, as opposed to using fs-verity in another way, then they can provide the
> option they need to do that.
> 
> Separately, it would also be nice to share more code with cmd_sign.c, as they
> both have to parse a lot of the same options.  Maybe it doesn't work out,
> though.

I did have a look at this at the beginning, but I was not happy with
how it looked like - both are using APIs from the public library and
are compact enough, so it felt a bit awkward to add yet another shim
layer, and opted to avoid it. If you feel strongly about it let me know
and I can revise.

-- 
Kind regards,
Luca Boccassi

