Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 30D22286A84
	for <lists+linux-fscrypt@lfdr.de>; Wed,  7 Oct 2020 23:53:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728753AbgJGVwZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 7 Oct 2020 17:52:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:50754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728649AbgJGVwZ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 7 Oct 2020 17:52:25 -0400
Received: from gmail.com (unknown [104.132.1.76])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 274382083B;
        Wed,  7 Oct 2020 21:52:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602107544;
        bh=VdkmJJp1c5bqqhJdGgZSlalw2xii9IqwJrWwX4QLgLg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=n0l98GHSsSAUDO5qxArcBpKiEq304YkENSqz44eeuuMHonjCZvtr4abAPrp1dGixU
         WY33tKU2Z8ldxpWtt86sKQjSq5FPmcnD+bJX1TcqQMMZgrF8+dt9NQR3Z+kqXJLOAh
         K7KivvQcZO6Jhnyy+eMGrHbzQx+nr6r6G2pg76CY=
Date:   Wed, 7 Oct 2020 14:52:22 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Satya Tangirala <satyat@google.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 1/1] f2fs-tools: Introduce metadata encryption support
Message-ID: <20201007215222.GF1530638@gmail.com>
References: <20201005074133.1958633-1-satyat@google.com>
 <20201005074133.1958633-2-satyat@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201005074133.1958633-2-satyat@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Oct 05, 2020 at 07:41:33AM +0000, Satya Tangirala wrote:
> diff --git a/lib/Makefile.am b/lib/Makefile.am
> index 871d773..a82d753 100644
> --- a/lib/Makefile.am
> +++ b/lib/Makefile.am
> @@ -2,10 +2,10 @@
>  
>  lib_LTLIBRARIES = libf2fs.la
>  
> -libf2fs_la_SOURCES = libf2fs.c libf2fs_io.c libf2fs_zoned.c nls_utf8.c
> +libf2fs_la_SOURCES = libf2fs.c libf2fs_io.c libf2fs_zoned.c nls_utf8.c f2fs_metadata_crypt.c
>  libf2fs_la_CFLAGS = -Wall
>  libf2fs_la_CPPFLAGS = -I$(top_srcdir)/include
> -libf2fs_la_LDFLAGS = -version-info $(LIBF2FS_CURRENT):$(LIBF2FS_REVISION):$(LIBF2FS_AGE)
> +libf2fs_la_LDFLAGS = -lkeyutils -version-info $(LIBF2FS_CURRENT):$(LIBF2FS_REVISION):$(LIBF2FS_AGE)

This introduces a dependency on libkeyutils.  Doesn't that need to be checked in
configure.ac?

> diff --git a/lib/f2fs_metadata_crypt.c b/lib/f2fs_metadata_crypt.c
> new file mode 100644
> index 0000000..faf399a
> --- /dev/null
> +++ b/lib/f2fs_metadata_crypt.c
> @@ -0,0 +1,226 @@
> +/**
> + * f2fs_metadata_crypt.c
> + *
> + * Copyright (c) 2020 Google LLC
> + *
> + * Dual licensed under the GPL or LGPL version 2 licenses.
> + */
> +#include <string.h>
> +#include <stdio.h>
> +#include <stdlib.h>
> +#include <unistd.h>
> +#include <sys/socket.h>
> +#include <linux/if_alg.h>
> +#include <linux/socket.h>
> +#include <assert.h>
> +#include <errno.h>
> +#include <keyutils.h>
> +
> +#include "f2fs_fs.h"
> +#include "f2fs_metadata_crypt.h"
> +
> +extern struct f2fs_configuration c;
> +struct f2fs_crypt_mode {
> +	const char *friendly_name;
> +	const char *cipher_str;
> +	unsigned int keysize;
> +	unsigned int ivlen;
> +} f2fs_crypt_modes[] = {

Use 'const' for static or global data that isn't modified.

> +void f2fs_print_crypt_algs(void)
> +{
> +	int i;
> +
> +	for (i = 1; i <= __FSCRYPT_MODE_MAX; i++) {
> +		if (!f2fs_crypt_modes[i].friendly_name)
> +			continue;
> +		MSG(0, "\t%s\n", f2fs_crypt_modes[i].friendly_name);
> +	}
> +}
> +
> +int f2fs_get_crypt_alg(const char *optarg)
> +{
> +	int i;
> +
> +	for (i = 1; i <= __FSCRYPT_MODE_MAX; i++) {
> +		if (f2fs_crypt_modes[i].friendly_name &&
> +		    !strcmp(f2fs_crypt_modes[i].friendly_name, optarg)) {
> +			return i;
> +		}
> +	}
> +
> +	return 0;
> +}

Although __FSCRYPT_MODE_MAX is defined in <linux/fscrypt.h>, it isn't intended
to be used in userspace programs, as its value will change depending on the
version of the kernel headers.  Just use ARRAY_SIZE(f2fs_crypt_modes) instead.

> +int f2fs_metadata_crypt_block(void *buf, size_t len, __u64 blk_addr,
> +			      bool encrypt)
> +{
> +	struct f2fs_crypt_mode *crypt_mode;
> +	int sockfd, fd;
> +	struct sockaddr_alg sa = {
> +		.salg_family = AF_ALG,
> +		.salg_type = "skcipher",
> +	};
> +	struct msghdr msg = {};
> +	struct cmsghdr *cmsg;
> +	char cbuf[CMSG_SPACE(4) + CMSG_SPACE(4 + MAX_IV_LEN)] = {0};
> +	int blk_offset;
> +	struct af_alg_iv *iv;
> +	struct iovec iov;
> +	int err;
> +
> +	crypt_mode = &f2fs_crypt_modes[c.metadata_crypt_alg];
> +	memcpy(sa.salg_name, crypt_mode->cipher_str,
> +	       strlen(crypt_mode->cipher_str));
> +
> +	sockfd = socket(AF_ALG, SOCK_SEQPACKET, 0);
> +	if (sockfd < 0)
> +		return errno;

This will fail if AF_ALG isn't enabled in the kernel config, or if the process
isn't allowed to use AF_ALG by SELinux policy.  Can you show a proper error
message?

> +	err = bind(sockfd, (struct sockaddr *)&sa, sizeof(sa));
> +	if (err) {
> +		MSG(0, "\tCouldn't bind crypto socket. Maybe support for the crypto algorithm isn't enabled?\n");
> +		close(sockfd);
> +		return errno;
> +	}

This will fail if either CRYPTO_USER_API_SKCIPHER isn't enabled in the kernel
config, or if the required crypto algorithm isn't enabled in the kernel config.
Can you show a better error message?

Also, these new kernel config option dependencies should be documented in the
documentation for f2fs-tools.

> +	err = setsockopt(sockfd, SOL_ALG, ALG_SET_KEY, c.metadata_crypt_key,
> +			 crypt_mode->keysize);
> +	if (err) {
> +		MSG(0, "\tCouldn't set crypto socket options.\n");
> +		close(sockfd);
> +		return errno;
> +	}
> +	fd = accept(sockfd, NULL, 0);
> +	if (fd < 0)
> +		goto err_out;

It's a lot of work to allocate an AF_ALG algorithm socket, set the key, and
allocate a request socket for every block.  Can any of this be cached?  For
single threaded use, it seems the request socket can be cached; otherwise the
algorithm socket with a key set can be cached.

- Eric
