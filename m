Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6918E63F0F4
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Dec 2022 13:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231235AbiLAM62 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 1 Dec 2022 07:58:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229843AbiLAM62 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 1 Dec 2022 07:58:28 -0500
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8875E578ED;
        Thu,  1 Dec 2022 04:58:25 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R121e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046049;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=12;SR=0;TI=SMTPD_---0VW8xlPK_1669899500;
Received: from localhost(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VW8xlPK_1669899500)
          by smtp.aliyun-inc.com;
          Thu, 01 Dec 2022 20:58:21 +0800
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        linux-fscrypt@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Cc:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Subject: [PATCH v4 0/2] Add SM4 XTS symmetric algorithm for blk-crypto and fscrypt
Date:   Thu,  1 Dec 2022 20:58:17 +0800
Message-Id: <20221201125819.36932-1-tianjia.zhang@linux.alibaba.com>
X-Mailer: git-send-email 2.24.3 (Apple Git-128)
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

SM4 is widely used in China's data encryption software and hardware.
these algoritms are mandatory in many scenarios. This serial of
patches enables the SM4-XTS algorithm in blk-crypto and enables the
SM4-XTS/CTS algorithm in fscrypt to encrypt file content and filename.

v4 changes:
  - only allow the SM4 XTS/CTS algorithm in policy v2 for fscrypt
  - update git commit message

v3 change:
  - update git commit message

v2 change:
  - As Eric said, the new FSCRYPT_MODE is defined for the unused numbers 7 and 8

Tianjia Zhang (2):
  blk-crypto: Add support for SM4-XTS blk crypto mode
  fscrypt: Add SM4 XTS/CTS symmetric algorithm support

 Documentation/filesystems/fscrypt.rst |  1 +
 block/blk-crypto.c                    |  6 ++++++
 fs/crypto/keysetup.c                  | 15 +++++++++++++++
 fs/crypto/policy.c                    |  5 +++++
 include/linux/blk-crypto.h            |  1 +
 include/uapi/linux/fscrypt.h          |  2 ++
 6 files changed, 30 insertions(+)

-- 
2.24.3 (Apple Git-128)

