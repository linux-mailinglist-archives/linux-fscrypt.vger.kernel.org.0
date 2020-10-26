Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E57762994E6
	for <lists+linux-fscrypt@lfdr.de>; Mon, 26 Oct 2020 19:12:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1789263AbgJZSMQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 26 Oct 2020 14:12:16 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:35794 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1783561AbgJZSMP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 26 Oct 2020 14:12:15 -0400
Received: by mail-wr1-f67.google.com with SMTP id n15so13791454wrq.2
        for <linux-fscrypt@vger.kernel.org>; Mon, 26 Oct 2020 11:12:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ZnAtPEkAP4Odmo/mV5DxsOm5M/D4Q4qg9voCPQPhCA4=;
        b=T6cXIiVrY0kMuAQOFkOxEPYmjFrsfOqcuKSDaicYGvf82hxM9tigwsnu/MxxQbBzi7
         ArZrDvi+AgSdPTY1b3TZ2jDIrK7tfZvnmhR6udGm/WeOUeyObZ8QsmjBdH7KrCscaHhR
         /EODTwVj6k5Zp2MaTri9ZtCHV+WAEBKpSUvsOjO3f3rVmo9PQZSkAhsOZZ6+rQGRaSjk
         nMLN76WFZvYcAUhRx7D2+vuAHXiVSaph/YjoMb54Wmfrc2Ed3Tkm/PABnJ+6HkElpN5B
         vEJQvDGRHfpTph1t9UTvAjU/XXFy7uJ/I7reVzs+iQMfvN7ZMu32icVnmSuJyvdscpP0
         1H6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ZnAtPEkAP4Odmo/mV5DxsOm5M/D4Q4qg9voCPQPhCA4=;
        b=WskVryhAji3EEeFEpjRPqTotC+/niXe1srJnHQwgXXCM3BtIVTUMXEZkDjRlQ0KHPQ
         e5BcFFMdebg3hKxKF8NyevuxiY1dUf3o4HlguvtuvOAZf6MiijR6qlOQUztxOOawTKt9
         +15XfRDXn0JxQIca1ZZn4w0+V/byqnfO9hDiOl4XjQaww/57x6YiX55DkN4aohjC4gpb
         sh7KSKaFmv2VTAoltFd3DAO0Lr7zWiaOoefR5m/tswtDgxXpbRoizdbJalwx6VZWtgWh
         u1a+iVpUeY5TctBaMHtD6krnm3C1HBeMiDzJEB0p3v5ynxt13TacrbSPLGra1uBozBoe
         MHlw==
X-Gm-Message-State: AOAM531hTCotG9lDWH277m1vl1seGQhB0djg3tocIAoORG+rPP117Gpl
        pbqqgrwrK1G8JjOvAwmwrM4=
X-Google-Smtp-Source: ABdhPJznvnqoKdPt1t12679I4K0xXrCrIJstbVS6gs2bqhh28T4fOoEBD0zZceOI1uyRAY7HIAVhGA==
X-Received: by 2002:adf:f3d2:: with SMTP id g18mr19028579wrp.367.1603735932175;
        Mon, 26 Oct 2020 11:12:12 -0700 (PDT)
Received: from bluca-lenovo ([2a01:4b00:f419:6f00:7a8e:ed70:5c52:ea3])
        by smtp.gmail.com with ESMTPSA id m1sm21836794wmm.34.2020.10.26.11.12.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2020 11:12:11 -0700 (PDT)
Message-ID: <8a5b5f20576841f13ad67f777d56b4e5d0819558.camel@gmail.com>
Subject: Re: [fsverity-utils PATCH v2] Add digest sub command
From:   Luca Boccassi <luca.boccassi@gmail.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org
Date:   Mon, 26 Oct 2020 18:12:10 +0000
In-Reply-To: <20201026174814.GF858@sol.localdomain>
References: <20201022172155.2994326-1-luca.boccassi@gmail.com>
         <20201026114007.3218645-1-luca.boccassi@gmail.com>
         <20201026174814.GF858@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, 2020-10-26 at 10:48 -0700, Eric Biggers wrote:
> On Mon, Oct 26, 2020 at 11:40:07AM +0000, luca.boccassi@gmail.com wrote:
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
> > +	bool compact = false, for_builtin_sig = false;
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
> > +		case OPT_FOR_BUILTIN_SIG:
> > +			for_builtin_sig = true;
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
> 
> I think this should allow specifying multiple files, like 'fsverity measure'
> does.  'fsverity measure' is intended to behave like the sha256sum program.

Added in v3.

> > +	/* The kernel expects more than the digest as the signed payload */
> > +	if (for_builtin_sig) {
> > +		d = xzalloc(sizeof(*d) + digest->digest_size);
> > +		if (!d)
> > +			goto out_err;
> 
> No need to check the return value of xzalloc(), since it exits on error.

Removed in v3.

> > +	if (compact)
> > +		printf("%s", digest_hex);
> > +	else
> > +		printf("File '%s' (%s:%s)\n", argv[0],
> > +			   libfsverity_get_hash_name(tree_params.hash_algorithm),
> > +			   digest_hex);
> 
> Please make the output in the !compact case match 'fsverity measure':
> 
> 	printf("%s:%s %s\n",
> 	       libfsverity_get_hash_name(tree_params.hash_algorithm),
> 	       digest_hex, argv[i]);
> 
> - Eric

Done with v3, sorry got confused with the 'sign' output.

-- 
Kind regards,
Luca Boccassi

