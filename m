Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5C9A058DFC0
	for <lists+linux-fscrypt@lfdr.de>; Tue,  9 Aug 2022 21:05:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345287AbiHITFK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 9 Aug 2022 15:05:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344773AbiHITEH (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 9 Aug 2022 15:04:07 -0400
Received: from mail-qt1-x84a.google.com (mail-qt1-x84a.google.com [IPv6:2607:f8b0:4864:20::84a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 825B67665
        for <linux-fscrypt@vger.kernel.org>; Tue,  9 Aug 2022 11:40:40 -0700 (PDT)
Received: by mail-qt1-x84a.google.com with SMTP id bl15-20020a05622a244f00b0034218498b06so9649571qtb.14
        for <linux-fscrypt@vger.kernel.org>; Tue, 09 Aug 2022 11:40:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:from:to:cc;
        bh=1zWpWT+dDLKtaXv3odJUGYprUkEzrz7PQwCnoeb3LLM=;
        b=ZkXl682ZDr+pglw3RZo9b/aeGI2yf8sm2Wo+W9VKaqmM79+6+pmnQHOXapWBfEnB1Y
         CtLCVagG/pnI+HI0yyKZS8pp/aXgp5M1ifkDUOhb2kgYmcf7kJF1voChXR9NTTZZpolZ
         jnMSW7KB1od8o76CqJcu6z6VryiZZk38Ycs3m9KKEhecofD3uO0953R9m2SKttlEDQls
         CtW/yQgkPZ7UvsVdUVMNBTBTvli3mU4UVvQgWH19Oy9Bsjz4WNVtl9SScL96w/Xbq8sO
         8KOVCoOKFsRGltiVcv/5wZwobhZlwnBZ2mSxi+RwvBGEIJRne0R/csII/2s8bN/wspCW
         3foQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:from:subject:mime-version:message-id:date:x-gm-message-state
         :from:to:cc;
        bh=1zWpWT+dDLKtaXv3odJUGYprUkEzrz7PQwCnoeb3LLM=;
        b=JjV16mC38HdP9kW9z7n1H9fPNkdfXztUBXn97fBUL8B6blaJ4DPViGL/gz1nVS84sO
         dCLNMEtAtH65tg8dyzE9/O7HFxIUX6cexAn7g7pMvdaMs0rNJlIz6OAi86TSS8m+8oea
         8/15EQwXX795VQpXnhWCi9NL9taStrrvXHcwu3aMPCKI2VGtljZtgd3PCdbyOVSV8Z14
         uW0VGaI0p2iqAyGGneFiLkA/fKrB0P77O8/y3R9xiWQgaCd5cpoKmJEp6wb3RqSPk1ug
         ZwUd/QUGKcYSB0kBlW8DPrmWqCr4nD9iy2rq+mtwz5WllmaG//Pa+8c+2acARHJpVrpf
         ToNg==
X-Gm-Message-State: ACgBeo0RR60AaZrzv40lrrsXDie0SDx/n0mbUquHbJc8n6tbAK3pPCeV
        WPpXwyAKFJWxbxSHEX62ZCr+HbBXXA==
X-Google-Smtp-Source: AA6agR60MQCbCSzDBNWfSbcCJA3zw056vNqhWXxNcnr1nj9VLoORUyg1RO4w6/mK4RbMyUaNCOOsbtJqhQ==
X-Received: from nhuck.c.googlers.com ([fda3:e722:ac3:cc00:14:4d90:c0a8:39cc])
 (user=nhuck job=sendgmr) by 2002:a05:6214:5290:b0:479:5df:e654 with SMTP id
 kj16-20020a056214529000b0047905dfe654mr18976501qvb.97.1660070439687; Tue, 09
 Aug 2022 11:40:39 -0700 (PDT)
Date:   Tue,  9 Aug 2022 11:40:35 -0700
Message-Id: <20220809184037.636578-1-nhuck@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.37.1.559.g78731f0fdb-goog
Subject: [PATCH v6 0/2] generic: test HCTR2 filename encryption
From:   Nathan Huckleberry <nhuck@google.com>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>,
        Sami Tolvanen <samitolvanen@google.com>,
        Nathan Huckleberry <nhuck@google.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-9.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

HCTR2 is a new wide-block encryption mode that can used for filename encryption
in fscrypt.  This patchset adds a reference implementation of HCTR2 to the
fscrypt testing utility and adds tests for filename encryption with HCTR2.

More information on HCTR2 can be found here: "Length-preserving encryption with
HCTR2": https://ia.cr/2021/1441

The patchset introducing HCTR2 to the kernel can be found here:
https://lore.kernel.org/linux-crypto/20220520181501.2159644-1-nhuck@google.com/

Changes in v6:
* Remove unused variable
* Rework cover letter

Changes in v5:
* Added links to relevant references for POLYVAL and HCTR2
* Removed POLYVAL partial block handling
* Referenced HCTR2 commit in test

Changes in v4:
* Add helper functions for HCTR2 hashing
* Fix accumulator alignment bug
* Small style fixes

Changes in v3:
* Consolidate tests into one file

Changes in v2:
* Use POLYVAL multiplication directly instead of using GHASH trick
* Split reference implementation and tests into two patches
* Remove v1 policy tests
* Various small style fixes

Nathan Huckleberry (2):
  fscrypt-crypt-util: add HCTR2 implementation
  generic: add tests for fscrypt policies with HCTR2

 common/encrypt           |   2 +
 src/fscrypt-crypt-util.c | 357 ++++++++++++++++++++++++++++++++-------
 tests/generic/900        |  31 ++++
 tests/generic/900.out    |  16 ++
 4 files changed, 349 insertions(+), 57 deletions(-)
 create mode 100755 tests/generic/900
 create mode 100644 tests/generic/900.out

-- 
2.37.1.559.g78731f0fdb-goog

