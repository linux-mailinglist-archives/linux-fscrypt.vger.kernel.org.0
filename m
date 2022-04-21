Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 30C005096A3
	for <lists+linux-fscrypt@lfdr.de>; Thu, 21 Apr 2022 07:23:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344458AbiDUF0U (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 21 Apr 2022 01:26:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56780 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbiDUF0T (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 21 Apr 2022 01:26:19 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4027DFAB;
        Wed, 20 Apr 2022 22:23:31 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id g9so3711364pgc.10;
        Wed, 20 Apr 2022 22:23:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JOMb/ac9GEQhxgFWy102RrBi/96CWNQGAWYx4cSN7Pg=;
        b=W/QJvfOG1S2aw8AHHspRF+F0Cru7bxKMKGSudgHFMjdbTFkvXsRrjzzksoSshU0943
         dOjSY3fEilKzrKvAMX5fVeyO08Sls0cy1RE7lMKrJMbwHWYq7HcDrH9pnO2CHCug1OzH
         EFpkodl8l8NxmF6befdxKXa0AoV0LN1QV3vVIJFuYQJFE0+U4NUtvZv9acGMs0aLid7E
         ytZWOM394ILDE2kRiKz6Yi39QBTtKqP2sFs1nwBHLRPkrpeaGqlmZPkghmVuE+Qa6ICk
         k8Yh445dfJID57bZePoeLSV5SpHMDWOUN2vrYddEV9/h1uDcAvIM5YDyN7JKzYNE/aQ2
         0wLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=JOMb/ac9GEQhxgFWy102RrBi/96CWNQGAWYx4cSN7Pg=;
        b=qNz+uBo6mRWadKp7XyNiDbfVHZ3nChTupNXFjKT9Zs1RNwd778q7BsO7FhB1riJUzS
         KJOOOqzjk5hK2ZF7H/8dLfqRIe9COkehizhAyleqZNu3gu1izhHXbEuc10SI4J/3z8Vb
         kI0x88eSbKnI873+Nq6ocgz5tq1DWgn0y3ky/RKBm7K6Alpjw+5TKXfyNIWbTGcWJl5M
         ge+lZj/bccNxxZ3GxeaZUsYldho6/HCYbUmvDH8dgvVWEHVE7kP33m7ZTDN4r2bxwfxX
         IrYRv2Boh/4BJ10wgdaQlEyCORUmIcDOlGxz4IhHnjhwz5oBbcKUxqZ58q7TEf0Ba9zN
         2+hg==
X-Gm-Message-State: AOAM533eYF8yeOCzaQMFKf5nkUxPrfPDLRtQm3UkT+C6pjtASpTfVbOY
        qxi28L4bYe+DbvGCtbwhV4WaVhHQric=
X-Google-Smtp-Source: ABdhPJzuJPtls9PlUdw/9htvfh5whOq8fXTZ/myjZqwTXiDdhJoKdphLV50VILbFYEDY7RX8kpp0eA==
X-Received: by 2002:a05:6a00:b52:b0:508:31e1:7d35 with SMTP id p18-20020a056a000b5200b0050831e17d35mr27122648pfo.33.1650518611169;
        Wed, 20 Apr 2022 22:23:31 -0700 (PDT)
Received: from localhost ([2406:7400:63:fca5:5639:1911:2ab6:cfe6])
        by smtp.gmail.com with ESMTPSA id bc11-20020a656d8b000000b0039cc4dbb295sm20479937pgb.60.2022.04.20.22.23.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 20 Apr 2022 22:23:30 -0700 (PDT)
From:   Ritesh Harjani <ritesh.list@gmail.com>
To:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org
Cc:     Eric Biggers <ebiggers@kernel.org>, Theodore Ts'o <tytso@mit.edu>,
        Jan Kara <jack@suse.cz>, Ritesh Harjani <ritesh.list@gmail.com>
Subject: [RFC 0/6] ext4: Move out crypto ops to ext4_crypto.c
Date:   Thu, 21 Apr 2022 10:53:16 +0530
Message-Id: <cover.1650517532.git.ritesh.list@gmail.com>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello,

This is 1st in the series to cleanup ext4/super.c, since it has grown quite large.
This moves out crypto related ops and few definitions to fs/ext4/ext4_crypto.c

Testing
=========
1. Tested "-g encrypt" with default configs.
2. Compiled tested on x86 & Power.


Ritesh Harjani (6):
  fscrypt: Provide definition of fscrypt_set_test_dummy_encryption
  ext4: Move ext4 crypto code to its own file ext4_crypto.c
  ext4: Directly opencode ext4_set_test_dummy_encryption
  ext4: Cleanup function defs from ext4.h into ext4_crypto.c
  ext4: Move all encryption related into a common #ifdef
  ext4: Use provided macro for checking dummy_enc_policy

 fs/ext4/Makefile        |   1 +
 fs/ext4/ext4.h          |  81 +++--------------
 fs/ext4/ext4_crypto.c   | 192 ++++++++++++++++++++++++++++++++++++++++
 fs/ext4/super.c         | 158 ++++-----------------------------
 include/linux/fscrypt.h |   7 ++
 5 files changed, 227 insertions(+), 212 deletions(-)
 create mode 100644 fs/ext4/ext4_crypto.c

--
2.31.1

