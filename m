Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3A3068F223
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Feb 2023 16:38:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230376AbjBHPir (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Feb 2023 10:38:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231256AbjBHPiq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Feb 2023 10:38:46 -0500
Received: from mail-wr1-x42b.google.com (mail-wr1-x42b.google.com [IPv6:2a00:1450:4864:20::42b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82EA9485BB
        for <linux-fscrypt@vger.kernel.org>; Wed,  8 Feb 2023 07:38:45 -0800 (PST)
Received: by mail-wr1-x42b.google.com with SMTP id bk16so17158412wrb.11
        for <linux-fscrypt@vger.kernel.org>; Wed, 08 Feb 2023 07:38:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linux-foundation.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=5ldS/9lgbAryUlzaEqo027FaU3ababbmuo6baFKv9sM=;
        b=GMKcvLbWgYYOV8D3gsJ1NLFPsx/+rb4QbvXLP5DPdEX/7OtnyJYn0eSEvrkIK19zWo
         BjCy3lR5nl3V/D+qx2u/4QrQu2ABYM65YPAlg3ZH+V2JzoEt7pgPNZH7lJ1yMN2zh5qx
         oiCs2/g3lnxsmmeEgvnZSDKkH0EEM32NJxdQU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5ldS/9lgbAryUlzaEqo027FaU3ababbmuo6baFKv9sM=;
        b=gE95uQ2ssGv0U0H8DxAOuhNSyojnxAnxz8NiTF4X/6wYrno/mmpryrM/LPKK8sz+vv
         HSKssB6/a7otLL4TEDMo+eMWWRF91hUDAlCFeigdQ8/NeixmW1E+kPfW9/PfbZURkhAk
         rBB8emeCZoU+hOGAC8P6jd7rHAD3AfhK0uoWtfe8aYGaTrccW3r8pWXLRtG9zbboHKXS
         lL28ZZsZH9blV/m7nIVDx2bWxR2WpTI4zt0hHwH4AUJnisoH3bgCsqHoVdJHSMWv9HXU
         kcSkwU1WcfEyOV9VCC4WcPxkcS7d05am5We7cUJSLtW1dG+f+15bwubIWOXoxIs0hzrc
         BswQ==
X-Gm-Message-State: AO0yUKUyErdUEXrj9LtzUkSq648/VK62GuzyC4trEBdALPBPq5MMRC3y
        JDmeKsPO301LVJoK+suWk079cDX/1O9ol3p4/fbRFA==
X-Google-Smtp-Source: AK7set8c8ud74CErzD66H9zf+GrdRO4+/xEnFtZx+n0JRpk4xQmU6BXnPnSVe5h4BNJcvRH2pHARRA==
X-Received: by 2002:a5d:420c:0:b0:2c3:daf8:3893 with SMTP id n12-20020a5d420c000000b002c3daf83893mr6805790wrq.32.1675870723698;
        Wed, 08 Feb 2023 07:38:43 -0800 (PST)
Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com. [209.85.208.44])
        by smtp.gmail.com with ESMTPSA id l6-20020a5d4bc6000000b002c3f9dc5a5fsm2310099wrt.114.2023.02.08.07.38.42
        for <linux-fscrypt@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 08 Feb 2023 07:38:42 -0800 (PST)
Received: by mail-ed1-f44.google.com with SMTP id fj20so2499359edb.1
        for <linux-fscrypt@vger.kernel.org>; Wed, 08 Feb 2023 07:38:42 -0800 (PST)
X-Received: by 2002:a50:d0db:0:b0:4a2:6562:f664 with SMTP id
 g27-20020a50d0db000000b004a26562f664mr1769251edf.5.1675870722462; Wed, 08 Feb
 2023 07:38:42 -0800 (PST)
MIME-Version: 1.0
References: <20230208062107.199831-1-ebiggers@kernel.org>
In-Reply-To: <20230208062107.199831-1-ebiggers@kernel.org>
From:   Linus Torvalds <torvalds@linux-foundation.org>
Date:   Wed, 8 Feb 2023 07:38:25 -0800
X-Gmail-Original-Message-ID: <CAHk-=wg=5AqsG_1Td_bOMpFE8odKhsT9Mb3s4Wp+qq_X1Z6gqQ@mail.gmail.com>
Message-ID: <CAHk-=wg=5AqsG_1Td_bOMpFE8odKhsT9Mb3s4Wp+qq_X1Z6gqQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] Add the test_dummy_encryption key on-demand
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-ext4@vger.kernel.org, linux-f2fs-devel@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Feb 7, 2023 at 10:21 PM Eric Biggers <ebiggers@kernel.org> wrote:
>
> I was going back and forth between this solution and instead having ext4
> and f2fs call fscrypt_destroy_keyring() on ->fill_super failure.  (Or
> using Linus's suggestion of adding the test dummy key as the very last
> step of ->fill_super.)  It does seem ideal to add the key at mount time,
> but I ended up going with this solution instead because it reduces the
> number of things the individual filesystems have to handle.

Well, the diffstat certainly looks nice:

>  8 files changed, 34 insertions(+), 51 deletions(-)

with that

>  fs/super.c                  |  1 -

removing the offending line that made Dan's static detection tool so
unhappy, so this all looks lovely to me.

Thanks,
             Linus
