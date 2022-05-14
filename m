Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 951C052734A
	for <lists+linux-fscrypt@lfdr.de>; Sat, 14 May 2022 19:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbiENRXA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 14 May 2022 13:23:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34442 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229447AbiENRW7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 14 May 2022 13:22:59 -0400
Received: from mail-pj1-x1035.google.com (mail-pj1-x1035.google.com [IPv6:2607:f8b0:4864:20::1035])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD90D338;
        Sat, 14 May 2022 10:22:58 -0700 (PDT)
Received: by mail-pj1-x1035.google.com with SMTP id b12so1397052pju.3;
        Sat, 14 May 2022 10:22:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rk+OnoyCyKQ3XweVmr37RzRSyNn03EYrvRCJHsWrTmM=;
        b=pUVQRojpci1wU5oYXyjfkzIh6tYeowDFOYSzEw/6LB1zQrGIykRbbGptC5ZdtsXnda
         Hl8vk0lHEKJp7nPr/L9biCo1/jU7BNH6wy34Qq6T95HJZImdXuqWFlc32sXt7nQktkSA
         iWBUEoUUHBYH60Qb/QadeygzWQ4ZGfILDCtfTA/SIKqFsN1lpUMcJnJp2WDSbR/fi1b3
         CrID6mNM6wITIZdGYlCrd5bmC9neqeSJNG3zdbPjH7IOuCAWUVUrjDj/y3GwhmxhdKfX
         kRlNvFJ+ea2DI+t+190jW/8K4chSTIOeU2UnDx3kj4ijEVBo8yRjjryLcJepR2UzdAbv
         XS+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=rk+OnoyCyKQ3XweVmr37RzRSyNn03EYrvRCJHsWrTmM=;
        b=xwiLO3chgSWw0RU9m5OiGgW1NBFTLDI45ppZDYf5v6EFC6RcCtBs6kUXMzyA/c7Hof
         cmLfuxn9SzXLRhssdtjAKiCOnqi9zshgfwRKFXhcfeQgNUzI4w7+MpwtFePIEJYpvtTn
         DL4q6lC784DaegX9ghmZdwnqe08kn+CBiyT9fQjxFkOpSyaXxLdpSIJ3Uf0EnCTZ7icI
         S2fY+nbSYvkSUJMhqlKjHHaZCvXtA/n7f/JqL2rNtcREgIntv0sR3czqCWnl8w8ih98I
         MNpvMB8ebRmhOa1Y92vmDdEz4+bgY1QS1OzwxCBWXjsiHdphFpl1A3OQDUQ9lLgXmOQN
         AujQ==
X-Gm-Message-State: AOAM531IfGY7Up9CMJSPOYQeYWd7g30agii8qCV0lRVStedBeo1qvhsv
        p4lUTg1/tKK8ewUBmnfs8yySmNexXQs=
X-Google-Smtp-Source: ABdhPJz2WeUZ6QWYYWFDj2OURs8/11yIXxhgP8vAMk3lr0x+U24qZ6idUjaAyqsallwXszbI1iTmrQ==
X-Received: by 2002:a17:90a:5215:b0:1ca:79cf:f3dd with SMTP id v21-20020a17090a521500b001ca79cff3ddmr10782084pjh.6.1652548978162;
        Sat, 14 May 2022 10:22:58 -0700 (PDT)
Received: from localhost ([2406:7400:63:532d:c4bb:97f7:b03d:2c53])
        by smtp.gmail.com with ESMTPSA id d15-20020aa7868f000000b0050dc76281d5sm3963093pfo.175.2022.05.14.10.22.57
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 10:22:57 -0700 (PDT)
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>, Jan Kara <jack@suse.cz>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: [PATCHv2 0/3] ext4/crypto: Move out crypto related ops to crypto.c
Date:   Sat, 14 May 2022 22:52:45 +0530
Message-Id: <cover.1652539361.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

This is 1st in the series to cleanup ext4/super.c, since it has grown quite
large. This moves out crypto related ops and few fs encryption related
definitions to fs/ext4/crypto.c

I have tested "-g encrypt" xfstests group and don't see any surprises there.
The changes are relatively straight forward since it is just moving/refactoring.

Currently these patches apply cleanly on ext4 tree's dev branch.
Since in these series test_dummy_encryption related changes are dropped, hence
I don't think that this should give any major conflict with Eric's series.


NOTE: I noticed we could move both ext4 & f2fs to use uuid_t lib API from
include/linux/uuid.h for managing sb->s_encrypt_pw_salt.
That should kill custom implementations of uuid_is_zero()/uuid_is_nonzero().
But since I noticed it while writing this cover letter, so I would like to
do those changes in a seperate patch series if that is ok. That way maybe we
could cleanup tree wide changes in fs/ (if there are others too).


RFC -> v2
==========
1. Dropped all test_dummy_encryption related changes
   (Eric has separately submitted a v3 for fixing more general problems with
    that mount option).
2. Addressed Eric comments to:-
	1. rename ext4_crypto.c -> crypto.c
	2. Refactor out ext4_ioc_get_encryption_pwsalt() into crypto.c
3. Made ext4_fname_from_fscrypt_name() static since it is only being called
   from within crypto.c functions.

[RFC] - https://lore.kernel.org/linux-ext4/cover.1650517532.git.ritesh.list@gmail.com/

Ritesh Harjani (3):
  ext4: Move ext4 crypto code to its own file crypto.c
  ext4: Cleanup function defs from ext4.h into crypto.c
  ext4: Refactor and move ext4_ioc_get_encryption_pwsalt()

 fs/ext4/Makefile |   1 +
 fs/ext4/crypto.c | 245 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h   |  79 ++++-----------
 fs/ext4/ioctl.c  |  58 +----------
 fs/ext4/super.c  | 122 -----------------------
 5 files changed, 264 insertions(+), 241 deletions(-)
 create mode 100644 fs/ext4/crypto.c

--
2.31.1

