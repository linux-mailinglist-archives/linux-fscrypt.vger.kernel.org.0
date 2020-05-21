Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 043BE1DD1C0
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 May 2020 17:27:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730456AbgEUP0Y (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 May 2020 11:26:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730490AbgEUP0Y (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 May 2020 11:26:24 -0400
Received: from mail-qv1-xf44.google.com (mail-qv1-xf44.google.com [IPv6:2607:f8b0:4864:20::f44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7873C061A0E
        for <linux-fscrypt@vger.kernel.org>; Thu, 21 May 2020 08:26:23 -0700 (PDT)
Received: by mail-qv1-xf44.google.com with SMTP id er16so3258450qvb.0
        for <linux-fscrypt@vger.kernel.org>; Thu, 21 May 2020 08:26:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:subject:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Fe5BtQNnV5/K+8OxSt+iy/lBiJ/9Nhvov69OPT2BhB4=;
        b=PkMlsyjWADv3TMP6p/ccjF4KN3JikxgDECgPaCQwMe67CcdN7q8aPy6uf61G4Z3sI6
         2kHdxwC61ZEhY3fK6aIGcq0RarwHXCOlJmmc+PWJeQJ2aYmFiID3RtPwRZ4DmOFYB5Ta
         1MafldpcRbZOSzPck6O61lLRPBHR9Yffhqx2/TY+gqsPbY0r8XCG4KA+RimKK2WtPxWa
         Uv2BlKdCM3pMbpa/tcBb47lLhbewzoMyIvCnZKSG9RxTKpFUXIGiSW1fO3Q9M/qE5//3
         O4HL6wkbw4Oin0VNXSXSo0imqm1fVP1Gi5ejqmmLLmFSNgbzm0IHNXS38jDVWZu/Og8n
         3xrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:subject:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Fe5BtQNnV5/K+8OxSt+iy/lBiJ/9Nhvov69OPT2BhB4=;
        b=bonIoD9VeZvtiSgb/VAT/ytN7oO2A3ms/NEMn0p6m7kILGkDOkVM3sDu9EoNjhmxZB
         +2+do8dKZ04L/x4XKuTXzQOBchiGMUuSPvu9bvT8/i03SADQWB7UfDoyvAbEosSkfAy7
         wMRw4gsssJm9CTgxCi2VPA8xbUKoRfkUA17TZy7Bje49ReKvnMCklwaUY5rBUnAaGxr5
         wlTB+kbjsD1rbWo9m3uARItgxVCYAcCmwPzI1UhF5vvtmnVXQwBWxb+TfXX7nlR3klu6
         sXsA0eSvzaxHwDzQBa0a2dHnVdj/UqhO6WIvoW5tGXV/5Gf8H0g/VWuj99WZ7j8Iff7K
         iqlA==
X-Gm-Message-State: AOAM533WbhRIK7Pt77opg7W1Ieab9g9qGIV/hOHmlD9hQx5yEXtLSpA/
        6HecApgtYvTf/TqJeFCSG+M=
X-Google-Smtp-Source: ABdhPJz+B45vT/pR1e5RWIflR4Au9/bXEcFOP638r2e+ASa6bxd13qeLhWCVTdei3pmSgT3poIGjIQ==
X-Received: by 2002:a0c:db03:: with SMTP id d3mr10675963qvk.80.1590074782882;
        Thu, 21 May 2020 08:26:22 -0700 (PDT)
Received: from ?IPv6:2620:10d:c0a8:11d9::10af? ([2620:10d:c091:480::1:2725])
        by smtp.gmail.com with ESMTPSA id i24sm5339585qtm.85.2020.05.21.08.26.21
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 21 May 2020 08:26:22 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
Subject: Re: [PATCH 1/3] Split up cmd_sign.c
To:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org
Cc:     jsorensen@fb.com, kernel-team@fb.com
References: <20200515041042.267966-1-ebiggers@kernel.org>
 <20200515041042.267966-2-ebiggers@kernel.org>
Message-ID: <3ee702b3-f9f8-c7af-2968-59e9ff958566@gmail.com>
Date:   Thu, 21 May 2020 11:26:21 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200515041042.267966-2-ebiggers@kernel.org>
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
> In preparation for moving most of the functionality of 'fsverity sign'
> into a shared library, split up cmd_sign.c into three files:
> 
> - cmd_sign.c: the actual command
> - compute_digest.c: computing the file measurement
> - sign_digest.c: sign the file measurement
> 
> No "real" changes; this is just moving code around.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>  Makefile             |   4 +-
>  cmd_sign.c           | 481 +------------------------------------------
>  lib/compute_digest.c | 184 +++++++++++++++++
>  lib/sign_digest.c    | 304 +++++++++++++++++++++++++++
>  sign.h               |  32 +++
>  5 files changed, 523 insertions(+), 482 deletions(-)
>  create mode 100644 lib/compute_digest.c
>  create mode 100644 lib/sign_digest.c
>  create mode 100644 sign.h

I don't really have specific comments to this one, except for the
u8/u16/u32 datatype issue I mentioned in the the 2/3 patch.

Reviewed-by: Jes Sorensen <jsorensen@fb.com>

Thanks,
Jes

