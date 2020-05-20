Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFB5B1DBFE2
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 May 2020 22:08:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726860AbgETUIS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 May 2020 16:08:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726853AbgETUIS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 May 2020 16:08:18 -0400
Received: from mail-qt1-x834.google.com (mail-qt1-x834.google.com [IPv6:2607:f8b0:4864:20::834])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6C97C061A0E
        for <linux-fscrypt@vger.kernel.org>; Wed, 20 May 2020 13:08:16 -0700 (PDT)
Received: by mail-qt1-x834.google.com with SMTP id m64so3669283qtd.4
        for <linux-fscrypt@vger.kernel.org>; Wed, 20 May 2020 13:08:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mJkqWi9FOvSFBLQJ7qDsRmxj+NusHs9uNG5KB/0L+kU=;
        b=OUdQGqpbIl3I4pI/lWDHhYnwTEhBvC6IIKr6Jn5jT6tf4vxj2MdRlHi/TTkOUvCqFj
         FfmJZMD4k3CgizW/nJdDA2kz0HSgMS0pswJui9zRcrChKfaVFpS8fi1PIdbjwr2lN8FA
         j6IDJlfoqweRZMBS2oZj5WZaWdlfkb1dYUMTZqHz1UL58I5n1KDEF7y/CJD8wgJ2If1v
         HhXmJb7iOKz+7HzPYHskLNtuiAej/x7RN4UBcgbldApDSkOW0QxV5HpK+zu34SBT08nr
         /7/NVO2WMLSIn1H3Ce7okMrepYzeZgGKNff0eN7/JXriFkkoDsacxMzQJ3qR0l0xFnJL
         rrZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=mJkqWi9FOvSFBLQJ7qDsRmxj+NusHs9uNG5KB/0L+kU=;
        b=UJEd8pDS06PXyELseiM9E64o63Ch0npMxz41DRpmyhDlmHZovoMDkutUenwvvwN4Oz
         Ow2wZBQkPvCrTNSjyOuo8lH7HWzvaydj5puWUQ/rubQWKcCMFb+3VEPMP2KKzXgBliNU
         JaFjU6cxDjYQme8BPRWEssbBrsiAwLRigA8XSYkHW/bWlL/VBKbiJL8pw/ouWxpABoWH
         Iis36kcMBK4U9fX474ZM/k80A1oiNGxbMqhY0ABsFqQAzDG1qWPpRebGHxNL9+7COpyl
         ZuQCmr6kcVY134SMFHv/EaEiSSaSWlGr1WMd3/tiGzMMEFBuE6Lcggp93weO7Acw/3lp
         d5GQ==
X-Gm-Message-State: AOAM531+XrztNyaRSy4UDdvKDZ93b9vsmUSzja++aleo2BiUKP8lbVHk
        IhhxSivUTaW2izB2KPO1lJCmc5w0
X-Google-Smtp-Source: ABdhPJx1LauThtmr2dhuJ8y2SfKQii+JL9Pse1rZc3NNqMadL8/ltjU4QKqdFXjnUBAtrgXNLb1umg==
X-Received: by 2002:ac8:341d:: with SMTP id u29mr7079200qtb.282.1590005296038;
        Wed, 20 May 2020 13:08:16 -0700 (PDT)
Received: from localhost ([2620:10d:c091:480::1:2725])
        by smtp.gmail.com with ESMTPSA id l184sm2944159qkf.84.2020.05.20.13.08.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 May 2020 13:08:14 -0700 (PDT)
From:   Jes Sorensen <jes.sorensen@gmail.com>
X-Google-Original-From: Jes Sorensen <Jes.Sorensen@gmail.com>
To:     ebiggers@kernel.org
Cc:     linux-fscrypt@vger.kernel.org, kernel-team@fb.com,
        Jes Sorensen <jsorensen@fb.com>
Subject: [PATCH v2 0/2] fsverity-utils Makefile fixes
Date:   Wed, 20 May 2020 16:08:09 -0400
Message-Id: <20200520200811.257542-1-Jes.Sorensen@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

From: Jes Sorensen <jsorensen@fb.com>

Hi

This addresses the comments to the previous version of these Makefile
changes.

Let me know if you have any additional issues with it?

I'd really love to see an official release soon that includes these
changes, which I can point to when submitting the RPM patches. Any
chance of doing 1.1 or something like that?

Cheers,
Jes


Jes Sorensen (2):
  Fix Makefile to delete objects from the library on make clean
  Let package manager override CFLAGS and CPPFLAGS

 Makefile | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

-- 
2.26.2

