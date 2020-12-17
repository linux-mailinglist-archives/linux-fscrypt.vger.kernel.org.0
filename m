Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 86F012DD4D6
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Dec 2020 17:05:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729183AbgLQQEx (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Dec 2020 11:04:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729150AbgLQQEx (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Dec 2020 11:04:53 -0500
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D033EC061794
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 08:04:12 -0800 (PST)
Received: by mail-pl1-x62c.google.com with SMTP id s2so15368639plr.9
        for <linux-fscrypt@vger.kernel.org>; Thu, 17 Dec 2020 08:04:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=v0aU55AeE8gyXrbegCxUISckiU90mOhoLtQhJSg8JO4=;
        b=A9C57Z98L1giiuA7maT0m//MwSxIA652SxKShGSsp+xshw7II7UqQ4aKf0KJPiQM+Q
         cAxRmvwycU14T3/dMyM8xGIXJDMmE7SBL6wpvXltPidw0GJZHUMHBx2ZRcXG7e698sUS
         Gy89AOJi0bvmWGsNqYs7I5gnCZTiouV6W6RMzB4Bn2wGvKNtKkLozQLBbHwfazFTT2qS
         LiRibMZtBBIkew1t/kpPnCZ3OBs9ZFHod4z/vzAmJ7TdSTD1qw+ZIE3A4xMzen34uumL
         WW6CKtpYNIpwiElwWLZ60bme/uV/rkgsbYJR/U1t6hzqlZZzan8DnWWMh+tB7z/43eTD
         Z27w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=v0aU55AeE8gyXrbegCxUISckiU90mOhoLtQhJSg8JO4=;
        b=PaR2Oe899vu8wI+aJ7xE9HPBJxHdarm7LqdwAvJXz3qt89vStmbDneVkn6YWycuuKo
         1I9/7M/JZmou+ggz6r5EkWTAcBz3Y5JpSU+FQCzUYx1LWp5xg4Mk2Akm1Ots8IkzG3bQ
         2q2jYTAzbcmD+ysVLAZnXPnYQ+5pP6p8ggqIqEpkiWVseFGkXRP90CwHSS24bTFFrVih
         CoVeD8SI4/zwr81wTRjWdf/N6GyxJ4RTt8mx3Ol6xad0khPIvjM/WOzz2ayUHcRZ7AtS
         yQ5kf/P0DwhSxbTPSsreNOvJnfwRmggafWrA8zpQtxJUogiwvFB8dZ/td6crJ7PPa+cF
         NZ0A==
X-Gm-Message-State: AOAM531t5Q1b4FEDl7xUawBB6Re8BeopVZKJhishhTC/BhCJ8y53iCHQ
        V1izl3jWJQa291Xl3MMKrST/T5p2IElAxg==
X-Google-Smtp-Source: ABdhPJxVczb5sHNjrNkJDOgnTO+pA1tagXIwhGzrpyaPMVEbk/tWgO49rZ7hu5TvNgpu/peKrWDFFA==
X-Received: by 2002:a17:90a:d48f:: with SMTP id s15mr8560649pju.137.1608221052223;
        Thu, 17 Dec 2020 08:04:12 -0800 (PST)
Received: from google.com (139.60.82.34.bc.googleusercontent.com. [34.82.60.139])
        by smtp.gmail.com with ESMTPSA id b197sm1488240pfb.42.2020.12.17.08.04.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Dec 2020 08:04:11 -0800 (PST)
Date:   Thu, 17 Dec 2020 16:04:07 +0000
From:   Satya Tangirala <satyat@google.com>
To:     jaegeuk@kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 1/1] f2fs-tools: Introduce metadata encryption support
Message-ID: <X9uBd0ubFD4ZO+T5@google.com>
References: <20201005074133.1958633-1-satyat@google.com>
 <20201005074133.1958633-2-satyat@google.com>
 <20201007194209.GB611836@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007194209.GB611836@google.com>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Oct 07, 2020 at 12:42:09PM -0700, jaegeuk@kernel.org wrote:
> Hi Satya,
> 
> On 10/05, Satya Tangirala wrote:
> > This patch introduces two new options '-A' and '-M' for specifying metadata
> > crypt options. '-A' takes the desired metadata encryption algorithm as
> > argument. '-M' takes the linux key_serial of the metadata encryption key as
> > the argument. The keyring key provided must be of a key type that supports
> > reading the payload from userspace.
> 
> Could you please update manpages as well?
> 
Done
> > diff --git a/lib/f2fs_metadata_crypt.c b/lib/f2fs_metadata_crypt.c
> > new file mode 100644
> > index 0000000..faf399a
> > --- /dev/null
> > +++ b/lib/f2fs_metadata_crypt.c
> > @@ -0,0 +1,226 @@
> > +/**
> > + * f2fs_metadata_crypt.c
> > + *
> > + * Copyright (c) 2020 Google LLC
> > + *
> > + * Dual licensed under the GPL or LGPL version 2 licenses.
> > + */
> > +#include <string.h>
> > +#include <stdio.h>
> > +#include <stdlib.h>
> > +#include <unistd.h>
> > +#include <sys/socket.h>
> > +#include <linux/if_alg.h>
> > +#include <linux/socket.h>
> > +#include <assert.h>
> > +#include <errno.h>
> > +#include <keyutils.h>
> > +
> > +#include "f2fs_fs.h"
> > +#include "f2fs_metadata_crypt.h"
> > +
> > +extern struct f2fs_configuration c;
> > +struct f2fs_crypt_mode {
> > +	const char *friendly_name;
> > +	const char *cipher_str;
> > +	unsigned int keysize;
> > +	unsigned int ivlen;
> > +} f2fs_crypt_modes[] = {
> > +	[FSCRYPT_MODE_AES_256_XTS] = {
> > +		.friendly_name = "AES-256-XTS",
> > +		.cipher_str = "xts(aes)",
> > +		.keysize = 64,
> > +		.ivlen = 16,
> > +	},
> > +	[FSCRYPT_MODE_ADIANTUM] = {
> > +		.friendly_name = "Adiantum",
> > +		.cipher_str = "adiantum(xchacha12,aes)",
> > +		.keysize = 32,
> > +		.ivlen = 32,
> > +	},
> > +};
> > +#define MAX_IV_LEN 32
> > +
> > +void f2fs_print_crypt_algs(void)
> > +{
> > +	int i;
> > +
> > +	for (i = 1; i <= __FSCRYPT_MODE_MAX; i++) {
> > +		if (!f2fs_crypt_modes[i].friendly_name)
> > +			continue;
> > +		MSG(0, "\t%s\n", f2fs_crypt_modes[i].friendly_name);
> > +	}
> > +}
> > +
> > +int f2fs_get_crypt_alg(const char *optarg)
> > +{
> > +	int i;
> > +
> > +	for (i = 1; i <= __FSCRYPT_MODE_MAX; i++) {
> > +		if (f2fs_crypt_modes[i].friendly_name &&
> > +		    !strcmp(f2fs_crypt_modes[i].friendly_name, optarg)) {
> > +			return i;
> > +		}
> > +	}
> > +
> > +	return 0;
> > +}
> > +
> > +int f2fs_metadata_process_key(const char *key_serial_str)
> > +{
> > +	key_serial_t key_serial = strtol(key_serial_str, NULL, 10);
> > +
> > +	c.metadata_crypt_key_len =
> > +		keyctl_read_alloc(key_serial, (void **)&c.metadata_crypt_key);
> > +
> > +	if (c.metadata_crypt_key_len < 0)
> > +		return errno;
> > +
> > +	return 0;
> > +}
> > +
> > +int f2fs_metadata_verify_args(void)
> > +{
> > +	/* If neither specified, nothing to do */
> > +	if (!c.metadata_crypt_key && !c.metadata_crypt_alg)
> > +		return 0;
> > +
> > +	/* We need both specified */
> > +	if (!c.metadata_crypt_key || !c.metadata_crypt_alg)
> > +		return -EINVAL;
> > +
> > +	if (c.metadata_crypt_key_len !=
> > +	    f2fs_crypt_modes[c.metadata_crypt_alg].keysize) {
> > +		MSG(0, "\tMetadata encryption key length %d didn't match required size %d\n",
> > +		    c.metadata_crypt_key_len,
> > +		    f2fs_crypt_modes[c.metadata_crypt_alg].keysize);
> > +
> > +		return -EINVAL;
> > +	}
> 
> Need to check sparse mode here?
> 
I tried to support sparse mode with metadata encryption in v2 (that I
just sent out), but I haven't been able to even compile or test it yet.
Would you happen to know where I might find some info on how to compile
and test sparse mode?
> And, what about multiple partition case?
> 
IIUC I think multiple devices are handled correctly by the code - is there
something I'm missing?
> > @@ -138,6 +147,14 @@ static void f2fs_parse_options(int argc, char *argv[])
> >  		case 'a':
> >  			c.heap = atoi(optarg);
> >  			break;
> > +		case 'A':
> > +			c.metadata_crypt_alg = f2fs_get_crypt_alg(optarg);
> > +			if (c.metadata_crypt_alg < 0) {
> > +				MSG(0, "Error: invalid crypt algorithm specified. The choices are:");
> > +				f2fs_print_crypt_algs();
> > +				exit(1);
> > +			}
> > +			break;
> >  		case 'c':
> >  			if (c.ndevs >= MAX_DEVICES) {
> >  				MSG(0, "Error: Too many devices\n");
> > @@ -178,6 +195,12 @@ static void f2fs_parse_options(int argc, char *argv[])
> >  		case 'm':
> >  			c.zoned_mode = 1;
> >  			break;
> > +		case 'M':
> > +			if (f2fs_metadata_process_key(optarg)) {
> > +				MSG(0, "Error: Invalid metadata key\n");
> > +				mkfs_usage();
> > +			}
> > +			break;
> >  		case 'o':
> >  			c.overprovision = atof(optarg);
> >  			break;
> > @@ -244,6 +267,14 @@ static void f2fs_parse_options(int argc, char *argv[])
> >  		}
> >  	}
> >  
> > +	if ((!!c.metadata_crypt_key) != (!!c.metadata_crypt_alg)) {
> > +		MSG(0, "\tError: Both the metadata crypt key and crypt algorithm must be specified!");
> > +		exit(1);
> > +	}
> > +
> > +	if (f2fs_metadata_verify_args())
> > +		exit(1);
> > +
> >  	add_default_options();
> 
> Need to check options after add_default_options()?
> 
As in, you're suggesting moving the metadata_crypt_key and
metadata_crypt_alg check and the 
+ if (f2fs_metadata_verify_args())
to below the add_default_options() call? If so, I'll do that in v3 of
this patch series
> Thanks,
> 
> >  
> >  	if (!(c.feature & cpu_to_le32(F2FS_FEATURE_EXTRA_ATTR))) {
> > -- 
> > 2.28.0.806.g8561365e88-goog
