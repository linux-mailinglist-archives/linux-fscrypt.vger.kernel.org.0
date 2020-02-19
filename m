Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A4E3516532F
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Feb 2020 00:49:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726731AbgBSXtK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 19 Feb 2020 18:49:10 -0500
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44850 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726613AbgBSXtK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 19 Feb 2020 18:49:10 -0500
Received: by mail-qk1-f194.google.com with SMTP id j8so1897594qka.11
        for <linux-fscrypt@vger.kernel.org>; Wed, 19 Feb 2020 15:49:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9dBEr17xKa8CN2aFxMMPprH1ybkSOkDAoAwl6F5enJ4=;
        b=sY3cx9r87oI7B9Sdsu/TzFfDuFBr7L2bysfc4955RejTuORayTawRixlTXH3eXMv+5
         RJKs06B/SFKzPjZzfPMZOuBXlW4QAoxRaytslc/PWg1VtzpCZKYJbltLAP1QTlSUFST9
         o4rmszyLFHFwIfkd5x57FJ5JwNbsCNlkooRdwjvPbayC6J5WiJBjI9ZSLuh1UCX349X0
         OdwPX6t7N319/c+gZiV0Wkzo1PZFDV/vv0cAD1wMpsy+H90G+lpdmU+IOMqJJeJQYfIe
         ASevVVf0Msm08yhV8Ssy+hRjwSTV2FqIIFmeCZWJrOxUf+ikj+4fmXdiZnm0aokWKSmT
         iKUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9dBEr17xKa8CN2aFxMMPprH1ybkSOkDAoAwl6F5enJ4=;
        b=TtqxpIN8tpH5OhdEB5lL951AYZ8EmeYk9Dhri/nuGgmKvgSUhoUxLpiOiRGxRm1gXy
         UqBaZmpAdgU46mO9KaT5BCypj+QQFmJUlhwo5un041TGhqLi/ug6vHMjFq3kdS7DsjKr
         1ISYHyA2qo7DYVoLVNgky+dzG4I5IEGJU4LXmX9jvM4PR/m88JOh66vRjbOttrNYLXyw
         9QAianD9juAwFAmH+Ye7FuNLGBDURWI2ta7++qflvo1p2o5eCi+AetwH/QRaMvofWmM6
         E5E5IKHP2+oPViZTxVFdgQjfe28QZskDdS392Js6U4/fn//eHBkE1Ng08O2OZrHMZGqW
         n+8w==
X-Gm-Message-State: APjAAAUaoiF0jvkLPzlNJU+aoEh2ibOvV0vh7OYqQqfnnZdW1VkETw0V
        VKmfTir2BtzHK7pyaC4Ypr0=
X-Google-Smtp-Source: APXvYqyOEXvV6VO3qaUe6w+APSJ2HBJgAmU1+ZRGtkcuF30Czfnw27A3wRwi1QyA7nH5UelhSlE8RA==
X-Received: by 2002:a37:9fcf:: with SMTP id i198mr10911937qke.36.1582156148820;
        Wed, 19 Feb 2020 15:49:08 -0800 (PST)
Received: from ?IPv6:2620:10d:c0a3:10e0::379d? ([2620:10d:c091:500::c882])
        by smtp.gmail.com with ESMTPSA id f2sm634132qkm.81.2020.02.19.15.49.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 19 Feb 2020 15:49:08 -0800 (PST)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH 0/7] Split fsverity-utils into a shared library
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
References: <20200211000037.189180-1-Jes.Sorensen@gmail.com>
 <20200211192209.GA870@sol.localdomain>
 <b49b4367-51e7-f62a-6209-b46a6880824b@gmail.com>
 <20200211231454.GB870@sol.localdomain>
 <c39f57d5-c9a4-5fbb-3ce3-cd21e90ef921@gmail.com>
 <20200214203510.GA1985@gmail.com>
Message-ID: <479b0fff-6af2-32e6-a645-03fcfc65ad59@gmail.com>
Date:   Wed, 19 Feb 2020 18:49:07 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
In-Reply-To: <20200214203510.GA1985@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

On 2/14/20 3:35 PM, Eric Biggers wrote:
> Well, this might be a legitimate use case then.  We need to define the library
> interface as simply as possible, though, so that we can maintain this code in
> the future without breaking users.  I suggest starting with something along the
> lines of:
> 
> #ifndef _LIBFSVERITY_H
> #define _LIBFSVERITY_H
> 
> #include <stddef.h>
> #include <stdint.h>
> 
> #define FS_VERITY_HASH_ALG_SHA256       1
> #define FS_VERITY_HASH_ALG_SHA512       2
> 
> struct libfsverity_merkle_tree_params {
> 	uint32_t version;
> 	uint32_t hash_algorithm;
> 	uint32_t block_size;
> 	uint32_t salt_size;
> 	const uint8_t *salt;
> 	size_t reserved[11];
> };
> 
> struct libfsverity_digest {
> 	uint16_t digest_algorithm;
> 	uint16_t digest_size;
> 	uint8_t digest[];
> };
> 
> struct libfsverity_signature_params {
> 	const char *keyfile;
> 	const char *certfile;
> 	size_t reserved[11];
> };

This looks reasonable to me - I would do the reserved fields as void *
or uint32_t, but that is a detail.

> int libfsverity_compute_digest(int fd,
> 			       const struct libfsverity_merkle_tree_params *params,
> 			       struct libfsverity_digest **digest_ret);
> 
> int libfsverity_sign_digest(const struct libfsverity_digest *digest,
> 			    const struct libfsverity_signature_params *sig_params,
> 			    void **sig_ret, size_t *sig_size_ret);
> 
> #endif /* _LIBFSVERITY_H */

Looks good too, I deliberately named the functions as fsverity, but
happy to prepend them with 'lib'. Didn't want to have a clash with
'sign_hash' as a function is actually named in a related library.

> I.e.:
> 
> - The stuff in util.h and hash_algs.h isn't exposed to library users.
> - Then names of all library functions and structs are appropriately prefixed
>   and avoid collisions with the kernel header.
> - Only signing functionality is included.
> - There are reserved fields, so we can add more parameters later.

I was debating whether to expect the library to do the open or have the
caller be responsible for that. Given we have to play the song and dance
with the signing key and certificate filenames, it's a little quirky,
but we're passing those to libopenssl so no way to really get around it.

> Before committing to any stable API, it would also be helpful to see the RPM
> patches to see what it actually does.

Absolutely, I wanted to have us agree on the strategy first before
taking it to the next step.

I'll take a stab at this.

> We'd also need to follow shared library best practices like compiling with
> -fvisibility=hidden and marking the API functions explicitly with
> __attribute__((visibility("default"))), and setting the 'soname' like
> -Wl,-soname=libfsverity.so.0.
> 
> Also, is the GPLv2+ license okay for the use case?

Personally I only care about linking it into rpm, which is GPL v2, so
from my perspective, that is sufficient. I am also fine making it LGPL,
but given it's your code I am stealing, I cannot make that call.

Cheers,
Jes


