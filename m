Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23EE11DD1DF
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 May 2020 17:29:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbgEUP3D (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 May 2020 11:29:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728266AbgEUP3C (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 May 2020 11:29:02 -0400
Received: from mail-qk1-x741.google.com (mail-qk1-x741.google.com [IPv6:2607:f8b0:4864:20::741])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81722C061A0E
        for <linux-fscrypt@vger.kernel.org>; Thu, 21 May 2020 08:29:02 -0700 (PDT)
Received: by mail-qk1-x741.google.com with SMTP id 190so7643701qki.1
        for <linux-fscrypt@vger.kernel.org>; Thu, 21 May 2020 08:29:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XQHC/ywE97NJ6N6VhOSflNErtxc/kQnLl750HDMmmwc=;
        b=h1dKftB5hfw4DEFlG4FfmhkYSeoZXBL2whlA95pToPbB4xyEfIvsbzcfSkddnuyaSs
         WVlR6Nk9t7ozxhb/S9ogPxb3kmgJkmqW9rUP/Q1ptyNeV5VvF9Sli5yq6DcH6b9pPzdg
         XpBaerZn75Zp49RK7gPCCxwUiQMK1RjX6zKycuAejyyjga3SArt/at06kTo+BoRhlcUU
         S/QRWeLRAC5SzFXizXZfMd55Y0AwVENu7ujLKA/eM6dT1pulubD4N2WvuL8Bv3MdGlSk
         UIeyl1yfxvsFCWO/qUx4CWKGolELF1b/Mb2rQUFE+LFDToEZP3GoYrNzzva0ehCTwXMI
         yLpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XQHC/ywE97NJ6N6VhOSflNErtxc/kQnLl750HDMmmwc=;
        b=QGGACpznZ0Utj+Vxt0bOEh2xpKV0TLPSdKeKcqIqqOimLv3UKq7nV3ySHq3gtkBhtM
         Qrl6YeidjaLwcMmsWmBjMwc4rnhSJB06vRnKWqXCNz4bmMeOmhDj1DA7GMjwrwRlPOMI
         zDUPoipZWKdKVUn4rE0QYSobxXX0wnmcKxf7Q46vWP9ZyifOR4fDcdn7zktBxK789Fnk
         aY4FX6f6yFajnYaeVXXaTuAB3wXHBAPTFrqSgV0qk+6ueKIAPcRzfOh5dnRgIxenNVuE
         uj+Mu+ydpzevnK7q5lT0fENX/VM9XaG5GkMZ+gxkqiCqGBLJLIUtJ8ivsbthpcyHRNv2
         iFtg==
X-Gm-Message-State: AOAM531T9Gr+eIH9UIVUNcLCLHkL7OSQrgIZhpiJtwn481IHRl/QbpDN
        XGo1Az9xJGs8bKQT6yvEF34=
X-Google-Smtp-Source: ABdhPJwJ8S8oGVFPLkkS59nl7eJl8X9/R4Wefs1loGcVhY29Sg7T65mAc8wxrlPOK8yfdbu16UV1vA==
X-Received: by 2002:a05:620a:1009:: with SMTP id z9mr10241196qkj.319.1590074941553;
        Thu, 21 May 2020 08:29:01 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d9::10af? ([2620:10d:c091:480::1:2725])
        by smtp.gmail.com with ESMTPSA id u3sm5734987qtk.63.2020.05.21.08.29.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 08:29:00 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH 3/3] Add some basic test programs for libfsverity
To:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org
Cc:     jsorensen@fb.com, kernel-team@fb.com
References: <20200515041042.267966-1-ebiggers@kernel.org>
 <20200515041042.267966-4-ebiggers@kernel.org>
Message-ID: <5928b89f-3c8d-6f8a-85e2-2e44792d1656@gmail.com>
Date:   Thu, 21 May 2020 11:29:00 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200515041042.267966-4-ebiggers@kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 5/15/20 12:10 AM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add three test programs: 'test_hash_algs', 'test_compute_digest', and
> 'test_sign_digest'.  Nothing fancy yet, just some basic tests to test
> each library function.
> 
> With the new Makefile, these get run by 'make check'.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  programs/test_compute_digest.c |  54 +++++++++++++++++++++++++++++++++
>  programs/test_hash_algs.c      |  27 +++++++++++++++++
>  programs/test_sign_digest.c    |  44 +++++++++++++++++++++++++++
>  testdata/cert.pem              |  31 +++++++++++++++++++
>  testdata/file.sig              | Bin 0 -> 708 bytes
>  testdata/key.pem               |  52 +++++++++++++++++++++++++++++++
>  6 files changed, 208 insertions(+)
>  create mode 100644 programs/test_compute_digest.c
>  create mode 100644 programs/test_hash_algs.c
>  create mode 100644 programs/test_sign_digest.c
>  create mode 100644 testdata/cert.pem
>  create mode 100644 testdata/file.sig
>  create mode 100644 testdata/key.pem
> 
> diff --git a/programs/test_compute_digest.c b/programs/test_compute_digest.c
> new file mode 100644
> index 0000000..5d00576
> --- /dev/null
> +++ b/programs/test_compute_digest.c
> @@ -0,0 +1,54 @@
> +// SPDX-License-Identifier: GPL-2.0+
> +#include "utils.h"
> +
> +struct file {
> +	u8 *data;
> +	size_t size;
> +	size_t offset;
> +};

The only issue I have here is the use of u8/u16/u32 in userland.

Reviewed-by: Jes Sorensen <jsorensen@fb.com>

Cheers,
Jes

