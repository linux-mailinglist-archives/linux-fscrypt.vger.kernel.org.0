Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32B537BF149
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Oct 2023 05:21:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1441951AbjJJDVP convert rfc822-to-8bit (ORCPT
        <rfc822;lists+linux-fscrypt@lfdr.de>); Mon, 9 Oct 2023 23:21:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56334 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1441964AbjJJDVO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 Oct 2023 23:21:14 -0400
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B2C69CF;
        Mon,  9 Oct 2023 20:21:11 -0700 (PDT)
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-5347e657a11so8584229a12.2;
        Mon, 09 Oct 2023 20:21:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696908070; x=1697512870;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=x+OgkZUadfjoEZL7fmzof6YYlwLrC/x1bfRHtSLtmb0=;
        b=LEMgQqA97CodUdBqw4zeaqmJckE6ysyX+7EMWByrPF2Gm52vY86KuqjDZlPqG6fDZA
         uVIxNUty7DMwuuSdeZZkUlEV8AFAqR38eoK2yAQNLscYKaJKLntePTM/5A49tnleHf8+
         lUd/GhkKzAe18Q+Lnk/fHJO1SE06e6rpsr8cHSxbnxo0G1lgYpNJF/L2bq1xZ0sL9664
         9SWpuLNRcmPKyitZ4nLptyzdO1jSdvsMAkb8zLVDs3FJ1afafqP2S5hL+/ck8MUAjqiz
         qipALqYlotUarvze1gf3BzVwNH8Qer0DuJBktbfcXpwaXLVZjZ+7wUQU22+E6pdgsXEy
         s1Yg==
X-Gm-Message-State: AOJu0Yw4fkk3EMCNjU2/k96KDoJkbyyTTtUHQRz95D1j11S4dWNQo1Gw
        Ngw3ifJYKJT+lIjW1dUcF4BRTbjUhnDC4w==
X-Google-Smtp-Source: AGHT+IHJkXOejY7VwM9QUnQdY6ldReqeoLPKPER/CGfjLJQq5nLmnYu8/dfnXxwOSeRL+mDNs7Zvnw==
X-Received: by 2002:a17:906:29c:b0:9b2:7584:80dc with SMTP id 28-20020a170906029c00b009b2758480dcmr13705996ejf.20.1696908069692;
        Mon, 09 Oct 2023 20:21:09 -0700 (PDT)
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com. [209.85.208.54])
        by smtp.gmail.com with ESMTPSA id p16-20020a170906b21000b009b9a1714524sm7759943ejz.12.2023.10.09.20.21.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 Oct 2023 20:21:09 -0700 (PDT)
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-534659061afso8582053a12.3;
        Mon, 09 Oct 2023 20:21:09 -0700 (PDT)
X-Received: by 2002:a50:ee8b:0:b0:530:e180:ab9a with SMTP id
 f11-20020a50ee8b000000b00530e180ab9amr15111170edr.3.1696908069234; Mon, 09
 Oct 2023 20:21:09 -0700 (PDT)
MIME-Version: 1.0
References: <20231005025757.33521-1-ebiggers@kernel.org> <CAEg-Je9giOLBVwuXAQ+F6do7sTBcCpP_ARbGA6TowTT+6GBc4g@mail.gmail.com>
 <20231009034416.GA279961@sol.localdomain>
In-Reply-To: <20231009034416.GA279961@sol.localdomain>
From:   Neal Gompa <neal@gompa.dev>
Date:   Mon, 9 Oct 2023 23:20:32 -0400
X-Gmail-Original-Message-ID: <CAEg-Je-RzwMPhoKGN73QBkKmfxeSDkFi6yJNaBF6Gxz8YBd-Wg@mail.gmail.com>
Message-ID: <CAEg-Je-RzwMPhoKGN73QBkKmfxeSDkFi6yJNaBF6Gxz8YBd-Wg@mail.gmail.com>
Subject: Re: [PATCH] fscrypt: rename fscrypt_info => fscrypt_inode_info
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Josef Bacik <josef@toxicpanda.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Spam-Status: No, score=-1.1 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_BLOCKED,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Oct 8, 2023 at 11:44 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> On Sun, Oct 08, 2023 at 02:11:36AM -0400, Neal Gompa wrote:
> >
> > Looks reasonable to me.
> >
> > Reviewed-by: Neal Gompa <neal@gompa.dev>
> >
>
> Thanks.  BTW, please only quote the part that you're replying to.
>

Well, I was replying to the whole patch, so that's why I put my r-b at the end.


-- 
真実はいつも一つ！/ Always, there's only one truth!
