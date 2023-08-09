Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B13357766B7
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Aug 2023 19:53:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230421AbjHIRxU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 9 Aug 2023 13:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbjHIRxU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 9 Aug 2023 13:53:20 -0400
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 767E410D2
        for <linux-fscrypt@vger.kernel.org>; Wed,  9 Aug 2023 10:53:19 -0700 (PDT)
Received: by mail-qv1-xf36.google.com with SMTP id 6a1803df08f44-63cf96c37beso424566d6.0
        for <linux-fscrypt@vger.kernel.org>; Wed, 09 Aug 2023 10:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20221208.gappssmtp.com; s=20221208; t=1691603598; x=1692208398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=LsA/drctXSaf1UIFLSiL6b4ntZoEKtHHfxR1OvwDa90=;
        b=o4CDzwVhseoLLhDEGSWnT5AuzDhYkHnLNeIwp7d6zZ9YNm56cajLJEyKpMQvhxvA3O
         Jzgn5+3SazbtiKXXOFStbOtXzicYQfUnSwlNZVP++ipCxlXqgaMP1404rE4gXl9lsmVh
         xxMfp335hCH+1VRM8AUHGA1KTz6AtxYUxhoQhsQw4cLJ4Udr7s2SArW+lEut17MizIrC
         RYStISJSXn3YeuMKGKLmLw3EUCvAX2gw+4Ye2waAst+qvx4/F+h/IllZ16NrURdzbHbi
         d5D9pSsLCnae4V/b4/XI6b9d2h+UPKYYhTPf6Sp508kIhHI3p6biBwsmMsRYZrx3VW2K
         J24g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1691603598; x=1692208398;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LsA/drctXSaf1UIFLSiL6b4ntZoEKtHHfxR1OvwDa90=;
        b=cdpQF+7oUD1cDlpFmGauUopYX35cBqR0etmSNyCz9UT077C9wDYjKoCVhi2TFGRlA1
         4ihbv5y+vkBVLdvpVv/gRNhZlK75pSHKgQvTvCTPkrIcXQ8i3J+dKPqdFsA0C/4jHbD4
         hoK8ligmE3n5iwu/DSDS4HptR8zC7I9/08eX6vowHLvPBcG+ZDwtDqeUONeCxgXLy1lO
         yWhMrksX9zJbnzPwwa1cJsCxu6Wu040eyFCuuFAqKnmDpqrxB3Vdan14GHyMviMnVWNt
         ei4+BetmLMTI4Zk2dOvlGnT3yJtgRmliWmcV8FqSGrtEZEbNzy1WXy7ZjSdrOOPH09Lf
         madA==
X-Gm-Message-State: AOJu0YzPwYU+EOtDM691WoZFZFUV3eI02SqSBeSpE5yZ4GJogF5LL+9t
        e2Pn4Mn1hnSHD9/5+UU+Q5pNzg==
X-Google-Smtp-Source: AGHT+IFtvKeSUm0p78M2GW4M3BRjAU3xyDIus+jsHV5GDjZnPWKztMPrIjmcOa6jkozUPfhj8YZJXQ==
X-Received: by 2002:a0c:e1ce:0:b0:63d:6138:1030 with SMTP id v14-20020a0ce1ce000000b0063d61381030mr232696qvl.5.1691603598574;
        Wed, 09 Aug 2023 10:53:18 -0700 (PDT)
Received: from localhost (cpe-76-182-20-124.nc.res.rr.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id p9-20020a0ce189000000b0063f822dae2csm3271733qvl.54.2023.08.09.10.53.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Aug 2023 10:53:18 -0700 (PDT)
Date:   Wed, 9 Aug 2023 13:53:17 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Subject: Re: [PATCH v3 01/16] fscrypt: factor helper for locking master key
Message-ID: <20230809175317.GH2516732@perftesting>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
 <5b791b93e0697db89c8a02df633f7be97f5ba58c.1691505882.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5b791b93e0697db89c8a02df633f7be97f5ba58c.1691505882.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 08, 2023 at 01:08:18PM -0400, Sweet Tea Dorminy wrote:
> When we are making extent infos, we'll need to lock the master key in
> more places, so go on and factor out a helper.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>

You factor this out, but I went and checked your tree with all of your patches
and this is only ever used in this one case, so do you actually need this patch
anymore?  Thanks,

Josef
