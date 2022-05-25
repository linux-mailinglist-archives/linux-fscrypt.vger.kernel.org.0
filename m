Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4AAD534411
	for <lists+linux-fscrypt@lfdr.de>; Wed, 25 May 2022 21:16:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344089AbiEYTQS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 25 May 2022 15:16:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344832AbiEYTPW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 25 May 2022 15:15:22 -0400
Received: from mail-vk1-xa30.google.com (mail-vk1-xa30.google.com [IPv6:2607:f8b0:4864:20::a30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89C4EBDB
        for <linux-fscrypt@vger.kernel.org>; Wed, 25 May 2022 12:15:15 -0700 (PDT)
Received: by mail-vk1-xa30.google.com with SMTP id e144so10331559vke.9
        for <linux-fscrypt@vger.kernel.org>; Wed, 25 May 2022 12:15:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=V3ilouT9genmWgVMdUNI5P/LrIsW5jIirCBfI8vk+4c=;
        b=VNL84agSPUNMz5ZHn5hB8GKcuYXWF3UmMPWc7Bb+LTV1k24f+olrtYnNlECI/5grU/
         gJfb9UnvXZhJDQqxsv/dzXgW1bjbq6IyojfmDsYouIZcF/WLojUh+pm2fw627QIhk2g/
         McEXiBrW7myNWu/lTrZvV8JW18fcv6SsDZ/36tX/pTSJWvCIFih0lZxPpUgHRWNLrUle
         p51+K/qbZ2PDQN0m49bSNWKknBDBPc4o0UNjJrkblUW7AxjIR7wXBWHyN8I3iTp4HVMq
         y0q/tTDGDPnjhRXcTELUkXzKa/fVcyoZ9W4DIAPSTdDiTGXbXBGKFL0k9dTRI7X3nIhl
         +vlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc
         :content-transfer-encoding;
        bh=V3ilouT9genmWgVMdUNI5P/LrIsW5jIirCBfI8vk+4c=;
        b=jJAaY4mAp109PGqj5dTwCGpSM177+I8z7kOsFAxas0t3JFlBYk5BgtvIboi1OzGHkH
         gjSRmwNNZSKl75yYaMUwtfecAmjK34k4pDRpUjbjFvBcUbtezzzotGqOwoDX+J2tmHwN
         YbBSOMbj81YrspDeG0dVEEG6kvLW1hX6M/A9Wp/Z8JHfTQc3AiWTz3rDwAFxRQBFKMdt
         cAJZ4ZklBwq5CexT2yjmOXJoVMw2oTAvNMTQ5lPaOxyceUZGZ3mXvU8LEjZ76xsXwRux
         uXWien5l4XmOHtV6RYgAW1Pyy4tIPfWOzjyHlpLKLIw38C/5J8U0dOpzj2CuHRm/2EpM
         dydg==
X-Gm-Message-State: AOAM532WeSObp7PX50MsTTCcg4BmV80Z376l16/NsDItpyrD7pFiybKf
        4k325X15PBBHPtr0wZsMATXPwCthuq0IQqtiCqM=
X-Google-Smtp-Source: ABdhPJxvbXspaz4zW4ghROwe7mtZm5WXla6DcckQd/HYDwGnn3YvHT4Qg0k+dKQaME7SWYaZN0WbIPCLHXqJnnpri0k=
X-Received: by 2002:a05:6122:2228:b0:32d:e4e:a79a with SMTP id
 bb40-20020a056122222800b0032d0e4ea79amr12275696vkb.27.1653506113167; Wed, 25
 May 2022 12:15:13 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a59:d484:0:b0:2bc:cae4:6d22 with HTTP; Wed, 25 May 2022
 12:15:12 -0700 (PDT)
From:   Rolf Benra <olfbenra@gmail.com>
Date:   Wed, 25 May 2022 21:15:12 +0200
Message-ID: <CA+z==VuwuBBVBk+=-U0t779uO36bFwSsYR6Qwgz2z9Wbkk3iGw@mail.gmail.com>
Subject: Bitte kontaktaufnahme Erforderlich !!! Please Contact Required !!!
To:     contact@firstdiamondbk.com
Cc:     info@firstdiamondbk.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.6 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Guten Tag,

Ich habe mich nur gefragt, ob Sie meine vorherige E-Mail bekommen

haben ?

Ich habe versucht, Sie per E-Mail zu erreichen.

Kommen Sie bitte schnell zu mir zur=C3=BCck, es ist sehr wichtig.

Danke

Rolf Benra

olfbenra@gmail.com







----------------------------------




Good Afternoon,

I was just wondering if you got my Previous E-mail
have ?

I tried to reach you by E-mail.

Please come back to me quickly, it is very Important.

Thanks

Rolf Benra

olfbenra@gmail.com
