Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 519AB1E326F
	for <lists+linux-fscrypt@lfdr.de>; Wed, 27 May 2020 00:25:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391834AbgEZWZ0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 May 2020 18:25:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2389889AbgEZWZZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 May 2020 18:25:25 -0400
Received: from mail-qk1-x742.google.com (mail-qk1-x742.google.com [IPv6:2607:f8b0:4864:20::742])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92545C061A0F
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 May 2020 15:25:24 -0700 (PDT)
Received: by mail-qk1-x742.google.com with SMTP id 205so9355645qkg.3
        for <linux-fscrypt@vger.kernel.org>; Tue, 26 May 2020 15:25:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=kwl4vL5j/aTvghb1Sr8fDxlNf8+iSiVa6E2jmOBws30=;
        b=VYKt1rqMG+Pcb1RS0jLOAwQMUZZIgCb7nAgJFWaBgsz0p78drt4KTS9FyZV/v3Rfbp
         lHzg4yadnARYZUvIFnUWrPaOutxTlM2TruolrKd0ThAxOw7uUHxpszW51j5zgUkeXeM4
         qcyOYY4LN4hbNUx3dRNT+d+xJJ6kn3A+xTpk5HXFkQZm431ZnbxenhM/CbEW6t8IsGGu
         heYExgBW1uOYVEzW8SUst9DtF0GmbTkgb8QVDWq2ufE2G/4KOXTz0PZ3y1JZVQSfhKIx
         Hh9Yif3yOa4oYQmBGh8DOScgXfRCEuvMHwnix1M+nx5M1Nxc5Lgjem2ZxsnpMgX6ZaCG
         Yp5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=kwl4vL5j/aTvghb1Sr8fDxlNf8+iSiVa6E2jmOBws30=;
        b=I9r09LLgwRtt6AyeEcFY0A+A/Q5lWfjWK6MkBPVdX4ypGi/9dicZl/vvyKCkIpCV0N
         /FiN/7SylFo8OMMLfXhpMimxsxT4D2izSfVjZPIymqVQetDVpI8rkZSG81DXVKaJff1f
         wJnv93zlGtb+PjGvQCIGtvWeC1DLMY5uiTv9BeJyqaIf/5Mt3wIKuiy0u3fVDz9zc77p
         upymFAhejfsQO/rsrRuZqwnth6BxxT2rzTMfIQUDNj9mqXMEVdg7nb0foAqBaXrVD2yk
         k2nMkjMWq8N3rME2iLVx41G2m9JUHJOQqsu24rfIEVNiYeeeDAKswr5RHmLztiyawJJm
         Ck7Q==
X-Gm-Message-State: AOAM531hTOUBbusXtWWgud0McLvAxPbRjSVnBBGVfikUjfIG+0gwmvIW
        tpdYHBeT+PzoWYpmt4/6ZtMztgWc
X-Google-Smtp-Source: ABdhPJwpUzLsfpNNyrqlE/RMT1jZ8bov3feLpCkSKAmZxjLsNkp7XsHTDqI/GUcZFcm8ZeFVKfWizQ==
X-Received: by 2002:a37:ef12:: with SMTP id j18mr1075624qkk.306.1590531923718;
        Tue, 26 May 2020 15:25:23 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11e8::11c5? ([2620:10d:c091:480::1:50da])
        by smtp.gmail.com with ESMTPSA id u7sm756729qku.119.2020.05.26.15.25.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 26 May 2020 15:25:22 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH v2 0/3] fsverity-utils: introduce libfsverity
To:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org
Cc:     jsorensen@fb.com, kernel-team@fb.com
References: <20200525205432.310304-1-ebiggers@kernel.org>
Message-ID: <4d485877-9506-b15a-f2f9-c087f1a5d8a2@gmail.com>
Date:   Tue, 26 May 2020 18:25:22 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200525205432.310304-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 5/25/20 4:54 PM, Eric Biggers wrote:
> From the 'fsverity' program, split out a library 'libfsverity'.
> Currently it supports computing file measurements ("digests"), and
> signing those file measurements for use with the fs-verity builtin
> signature verification feature.
> 
> Rewritten from patches by Jes Sorensen <jsorensen@fb.com>.
> I made a lot of improvements; see patch 2 for details.
> 
> This patchset can also be found at branch "libfsverity" of
> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git/
> 
> Changes v1 => v2:
>   - Fold in the Makefile fixes from Jes
>   - Rename libfsverity_digest_size() and libfsverity_hash_name()
>   - Improve the documentation slightly
>   - If a memory allocation fails, print the allocation size
>   - Use EBADMSG for invalid cert or keyfile, not EINVAL
>   - Make libfsverity_find_hash_alg_by_name() handle NULL
>   - Avoid introducing compiler warnings with AOSP's default cflags
>   - Don't assume that BIO_new_file() sets errno
>   - Other small cleanups
> 
> Eric Biggers (3):
>   Split up cmd_sign.c
>   Introduce libfsverity
>   Add some basic test programs for libfsverity

Hi Eric,

Assuming you didn't make any big changes since the previous rev. I have
tested this here, and I can build an fsverity-utils RPM from it, and
build my RPM support with this version, so looks all good from my side.

One feature I would like to have, and this is what I confused in my
previous comments. In addition to a get_digset_size() function, it would
be really useful to also have a get_signature_size() function. This
would be really useful when trying to pre-allocate space for an array of
signatures, or is there no way to get that info from openssl without
creating an actual signature?

Cheers,
Jes
