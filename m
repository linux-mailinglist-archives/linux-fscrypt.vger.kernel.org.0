Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3C21F776652
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Aug 2023 19:22:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232923AbjHIRWV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 9 Aug 2023 13:22:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232911AbjHIRWU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 9 Aug 2023 13:22:20 -0400
Received: from mail-vk1-xa29.google.com (mail-vk1-xa29.google.com [IPv6:2607:f8b0:4864:20::a29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E2C02108
        for <linux-fscrypt@vger.kernel.org>; Wed,  9 Aug 2023 10:22:20 -0700 (PDT)
Received: by mail-vk1-xa29.google.com with SMTP id 71dfb90a1353d-4871e54ee84so29078e0c.2
        for <linux-fscrypt@vger.kernel.org>; Wed, 09 Aug 2023 10:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1691601739; x=1692206539;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=9LH5YqhPSZ5QpOregHu1NuMgeldEQ8bAarb691+Nqf0=;
        b=kYL2ipIdGKNz1u4+3H1vR/vk4QeEmo8wXc2xqx8n/PLR5nf2M+lFyRZsovtIX+OEXg
         hNxs9oAJvuyManDsY5M46Ti7xa1Ln+hiKPIDr/yvKIvTvrR+6G2EUPtYbgvM2/gg7e60
         T7r+sOC7A59rxcvfau+p1FoP3jO/4+BTr0LA31JtjSeqJnLuWro6ErJrkVfd44RTfrsH
         lAPnG1rfjHrudiqgLMNHt1ST/TnrA1jEzURolfH6PvaINPKklAirHro5E3McCnQ8eNXw
         AmdyInPj7HkGZP210YAqA1eaPbiTjEHBE/bvc+xDvFHj3f3hge2dELXrNnMArDfcm2rf
         CedA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691601739; x=1692206539;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9LH5YqhPSZ5QpOregHu1NuMgeldEQ8bAarb691+Nqf0=;
        b=eeks/GuGQlMzgub6qWf/xNVC9C+BBnCeJF4J57Vo2NhOnZfPsrcrnzR+JJ7t+wFUCK
         bRZ4wiNpIYQw0Ijgj65fz0aQtAhIS3BLhuZr8VLvQUmyEFfxew3KCG5UYWuNzuhAWfhN
         8+FpX33cMoQumB9TuNQqlCKEBjAGVK4q1HvaStvfDuBIqZzUyKIVaxMV7LYAXCmLM4cH
         LT6oJtV7bvxbBS+BDfWZyXt7aSts3D3YaOlStLRHzyQBZZ3otKVMeuZHTG/PnDYt8Hof
         RE1crMLsKmIgAHPAvk+IpPCYzEIrac90uygUSA/+3NkufWaylyANW94KqFpiAG4OixPo
         6c6Q==
X-Gm-Message-State: AOJu0YzYyaaEJDFoTvyE+pDPc+NEtVWR4CVFkpss8T+zLTMxhL54HjlM
        sf9KumfXzgbUBpVPZ7rIFHkNKA==
X-Google-Smtp-Source: AGHT+IG2khZS7Tc4rkD6MRnzaAaIXX0Cynbzh5aEUkUwsjE6NmCpv7t08TOyEUYKdpCzIeHtjVhszw==
X-Received: by 2002:a1f:4556:0:b0:47e:9bbb:103b with SMTP id s83-20020a1f4556000000b0047e9bbb103bmr81641vka.6.1691601739222;
        Wed, 09 Aug 2023 10:22:19 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id q5-20020a0cf5c5000000b00626362f1bf1sm4548268qvm.63.2023.08.09.10.22.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 10:22:18 -0700 (PDT)
Date:   Wed, 9 Aug 2023 13:22:17 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v6 3/8] fscrypt: split setup_per_mode_enc_key()
Message-ID: <20230809172217.GC2516732@perftesting>
References: <cover.1691505830.git.sweettea-kernel@dorminy.me>
 <cd8fffce4ec37af89c5f92fd8077e7f055fccc0e.1691505830.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd8fffce4ec37af89c5f92fd8077e7f055fccc0e.1691505830.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 08, 2023 at 01:08:03PM -0400, Sweet Tea Dorminy wrote:
> At present, setup_per_mode_enc_key() tries to find, within an array of
> mode keys in the master key, an already prepared key, and if it doesn't
> find a pre-prepared key, sets up a new one. This caching is not super
> clear, at least to me, and splitting this function makes it clearer.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

Reviewed-by: Josef Bacik <josef@toxicpanda.com>

Thanks,

Josef
