Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9E8412D3751
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Dec 2020 01:02:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730540AbgLIACU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Dec 2020 19:02:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730353AbgLIACU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Dec 2020 19:02:20 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 96561C0613D6
        for <linux-fscrypt@vger.kernel.org>; Tue,  8 Dec 2020 16:01:40 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id c12so208465pfo.10
        for <linux-fscrypt@vger.kernel.org>; Tue, 08 Dec 2020 16:01:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=IlcbnJ0w3R+raMjtafxvAzYGmc8w8Z5llSlkQt901bM=;
        b=nyk6eQgHhGSw071rTSS7MzO4THWk1VUrsRI/LHpf87JsjEQzsqgPeJlpnG+Hi4W6Br
         85UL+4mXvVvl37wJWbCgGKcTIN3sAzcxlsczb1vzy/GdWovHnnDqyygu1x/iLbrEvB9i
         1lkfhmEYOJ+4MR3l8WWlliON1fsd0GJ7eDhp+wIXNBNm9/kxSrHgnaQ1ISfUkZkF/rUm
         Bb0KCIR+NQj96+8B8tj5PoLbmCTDB7XO9BtH819J7b0E8WXSjUV4uDYyI6owO7RlLLY5
         WOaOKFe4QHDUE/oaEmMpY5vqRXqx8E1P7XAgCv7DqMWsAs9aoW/v0NSLfPX7WFkAkHMF
         wqMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=IlcbnJ0w3R+raMjtafxvAzYGmc8w8Z5llSlkQt901bM=;
        b=m7SDwvd0FxNZLIULbjmyvpG24UTeD7BCe/vBaZq/wMFx6mOVPpLGgeUcVIm7WY1oEI
         5KqQXza+R6KgQIpN2pjwgojTiXxU/sRWf3hS0TM3GvnroAHT8UreIeJ/ADLQ7BGwz4/6
         1lLldcHfHcQHOltyUfpapq0+YQgMdInL/JwHVWTOjvw54QDs9HlZOMvvNMAoaZY6/a02
         24lf1MIVZTjrdHTbsxvvd/TUYZiQPwarJ/A6IpF+/iNetUyFxwPcMP42st0VwrFj6h+i
         8kGj5GFlyp+JCeksgVf8ejFW1OHvA9Jx9e4PD7t2GpuAjF3X5JyDY2FtWNQ3e+noqGFP
         FHBg==
X-Gm-Message-State: AOAM5309j8Zev2/a9qJyiAsF8WU1bSq2qYVpZe4A9AWpRrAi6GyV1ItZ
        S1iBvLiYqK0J8l5joWhFTnH78Q==
X-Google-Smtp-Source: ABdhPJwCARYoRL9G+IP7htAPzDlrlYCs3aFvtjKiyWGKHZBF8E3q9b6+koRUn49SD/YXs0ZaalRNOg==
X-Received: by 2002:a17:90a:a393:: with SMTP id x19mr13184pjp.68.1607472100086;
        Tue, 08 Dec 2020 16:01:40 -0800 (PST)
Received: from google.com (154.137.233.35.bc.googleusercontent.com. [35.233.137.154])
        by smtp.gmail.com with ESMTPSA id y189sm302341pfb.155.2020.12.08.16.01.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 16:01:39 -0800 (PST)
Date:   Wed, 9 Dec 2020 00:01:35 +0000
From:   Satya Tangirala <satyat@google.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-mmc@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Rob Herring <robh+dt@kernel.org>,
        Neeraj Soni <neersoni@codeaurora.org>,
        Barani Muthukumaran <bmuthuku@codeaurora.org>,
        Peng Zhou <peng.zhou@mediatek.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Konrad Dybcio <konradybcio@gmail.com>
Subject: Re: [PATCH v2 4/9] mmc: cqhci: add support for inline encryption
Message-ID: <X9AT3zULeDB+edNj@google.com>
References: <20201203020516.225701-1-ebiggers@kernel.org>
 <20201203020516.225701-5-ebiggers@kernel.org>
 <X8t82HijJtbHVyLM@google.com>
 <X8vMZBSP0hQSOqlA@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <X8vMZBSP0hQSOqlA@sol.localdomain>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Dec 05, 2020 at 10:07:32AM -0800, Eric Biggers wrote:
> (Please quote just the part that you're actually replying to -- thanks!)
> 
Sorry about that. Will do so in future :)
> The comment gives the typical value that is stored in data_unit_size,
> but yeah it's a bad comment.  I'll just remove it.
> 
Cool. Please feel free to add
Reviewed-by: Satya Tangirala <satyat@google.com>
> - Eric
