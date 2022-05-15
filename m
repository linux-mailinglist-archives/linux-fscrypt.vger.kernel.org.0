Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D854527610
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 May 2022 08:38:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235798AbiEOGiB (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 15 May 2022 02:38:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235781AbiEOGh5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 15 May 2022 02:37:57 -0400
Received: from mail-pj1-x102c.google.com (mail-pj1-x102c.google.com [IPv6:2607:f8b0:4864:20::102c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8946718E32;
        Sat, 14 May 2022 23:37:55 -0700 (PDT)
Received: by mail-pj1-x102c.google.com with SMTP id gg20so1520495pjb.1;
        Sat, 14 May 2022 23:37:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ioWvRqhvqb48224ZFdSGcfAp8lOwvU9bWxoPkmvl+ls=;
        b=ewivkQO4iaR3iq1+4rgzgv7T9chMODABlsNs8Vg7KTiNOnHu7MNfceawEqA9NFw99w
         RorhfXXYheUD3gFazu1d+nvkVLwubLDCGZs+1RatjndH2gInSCny8oSWn71T6qJ2aBLa
         a+sCvBKFynUOsVrYfqKa/RWdEx+YU9+zY5OrO9pDfApCMXlk0MyleMY/x+rCEnyGL6XR
         Xng7CYsqtB4Dq6kk2y9eNVX8zd5pv3TG0qyWKU5UjWR9a6N9KeTtBAUG0QKIJ1MeB5LE
         CROTthHe6TPwrxnv1HYHKjTOX+5aDhtoD+ecqAHneezGinlxl7Xezm9whV+Pbg9uivHi
         PibQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=ioWvRqhvqb48224ZFdSGcfAp8lOwvU9bWxoPkmvl+ls=;
        b=YSCgkU7Q+oc4AL/RPaucDGhc0/LP1iwhsF0r+NuWk4xjyUauvd7JHojCi5P0Ne258V
         +gwVOyBh4VSeHhWrHWmJOaCwKEt7Mrk4w13UwjFese5C0YQznOl98Ddap8a8KK78VG34
         KZjldjdAQ+RJiAOm6UORGY3oNP9w9McXsWT2PlvkcI2B7sGj2fVVCEyGjRfmh8hBlCbs
         V9PX6wsNeMHEDB5DFvmkNpqwgDTpZcYwF4wZI3tr5uB4Vi4ANMdF9Nf+2oGqaYmpoyRf
         K6um5960UY59dyrxcMyIBGus1mkT9ALTHBD/d7mNljrDnPnsnh7Zm05wXYeHczEfanks
         4cYg==
X-Gm-Message-State: AOAM531jsoZKQCt8yVQEieSwjKBsisdXSSKWDbhFMQSqziGJEU9++H2Q
        aGN2Gch9xrvKzjWk3HcePUam4JU5MYw=
X-Google-Smtp-Source: ABdhPJyRHZUetb/n1fLDOKwCPD3DBxzzyJ4GugXT1HIKSuQK2ZfVTmDho6gAUz/Gw7IfTlPBAWnU1w==
X-Received: by 2002:a17:90b:384d:b0:1dc:a631:e356 with SMTP id nl13-20020a17090b384d00b001dca631e356mr24150558pjb.82.1652596675049;
        Sat, 14 May 2022 23:37:55 -0700 (PDT)
Received: from localhost ([2406:7400:63:532d:c4bb:97f7:b03d:2c53])
        by smtp.gmail.com with ESMTPSA id cu5-20020a056a00448500b0050dc76281b2sm4624754pfb.140.2022.05.14.23.37.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 14 May 2022 23:37:54 -0700 (PDT)
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     linux-ext4@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        Eric Biggers <ebiggers@kernel.org>, Jan Kara <jack@suse.cz>,
        Ritesh Harjani <ritesh.list@gmail.com>
Subject: [PATCHv3 0/3] ext4/crypto: Move out crypto related ops to crypto.c
Date:   Sun, 15 May 2022 12:07:45 +0530
Message-Id: <cover.1652595565.git.ritesh.list@gmail.com>
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

Please find the v3 of this cleanup series. Thanks to Eric for his quick
review of the patch series.

Description
=============
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


v2 -> v3
=========
1. Addressed review comments from Eric.

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

[v2] - https://lore.kernel.org/linux-ext4/cover.1652539361.git.ritesh.list@gmail.com/T/#t
[RFC] - https://lore.kernel.org/linux-ext4/cover.1650517532.git.ritesh.list@gmail.com/

Ritesh Harjani (3):
  ext4: Move ext4 crypto code to its own file crypto.c
  ext4: Cleanup function defs from ext4.h into crypto.c
  ext4: Refactor and move ext4_ioctl_get_encryption_pwsalt()

 fs/ext4/Makefile |   1 +
 fs/ext4/crypto.c | 246 +++++++++++++++++++++++++++++++++++++++++++++++
 fs/ext4/ext4.h   |  76 +++------------
 fs/ext4/ioctl.c  |  59 +-----------
 fs/ext4/super.c  | 122 -----------------------
 5 files changed, 263 insertions(+), 241 deletions(-)
 create mode 100644 fs/ext4/crypto.c

--
2.31.1

