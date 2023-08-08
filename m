Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 32705774397
	for <lists+linux-fscrypt@lfdr.de>; Tue,  8 Aug 2023 20:08:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231750AbjHHSIA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 14:08:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231835AbjHHSHY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 14:07:24 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A2A315A8D1;
        Tue,  8 Aug 2023 10:08:16 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 1A13D83533;
        Tue,  8 Aug 2023 13:08:16 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691514496; bh=jeYQA7/njT8jvaAwldD3M+z3nL1zGvL3hNq+18LLvR8=;
        h=From:To:Cc:Subject:Date:From;
        b=cK0AzV3wosKqI/BauERrxjRIRR4wAD6Lbxxpd8kZ68Bwanybfl+LMQW7zqftPu3A+
         HsJuTAgmAkxchPdymkPJIiSyVztKqTG99x9qa0qJOgfqFz2lt5xej6S8wz6a+DZTqc
         vIvZXSjf29pfq+3CmZdWxf/i7tvMn5g/BTzey3sYm+as1aA/cp4qgbS8E9MM26CbRv
         0urPnjSb7hudr+5bW3S0JHnxe4foRpF+KfvNLOXGF1mdo0qCbHYxffnrvxBPjslHix
         wvskOZYTYJV/DdvX8oBUMd8sePZpG+XDHf8qSt6z5fUlhYH05KDRgxQ8HG4g5C2iTv
         qMz+gqq/aQxJA==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v6 0/8] fscrypt: preliminary rearrangmeents of key setup
Date:   Tue,  8 Aug 2023 13:08:00 -0400
Message-ID: <cover.1691505830.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

For btrfs extent encryption, prepared keys need to be asynchronously
freed after the fscrypt_info is freed. This set of various
rearrangements of key setup turns the prepared key member of the info
into a pointer so this is possible.

Patchset is built on kdave/misc-next as per base commit and needs a tiny
fixup to apply to fscrypt/for-next. It passes ext4/f2fs tests for me.

[1] https://lore.kernel.org/linux-fscrypt/cover.1681837335.git.sweettea-kernel@dorminy.me/

Changelog:
v6:
 - Reword 'make infos have a pointer to prepared keys' to elaborate
   on why it is a useful change.

Sweet Tea Dorminy (8):
  fscrypt: move inline crypt decision to info setup
  fscrypt: split and rename setup_file_encryption_key()
  fscrypt: split setup_per_mode_enc_key()
  fscrypt: move dirhash key setup away from IO key setup
  fscrypt: reduce special-casing of IV_INO_LBLK_32
  fscrypt: move all the shared mode key setup deeper
  fscrypt: make infos have a pointer to prepared keys
  fscrypt: make prepared keys record their type

 fs/crypto/crypto.c          |   2 +-
 fs/crypto/fname.c           |   4 +-
 fs/crypto/fscrypt_private.h |  33 +++-
 fs/crypto/inline_crypt.c    |   4 +-
 fs/crypto/keysetup.c        | 357 +++++++++++++++++++++++-------------
 fs/crypto/keysetup_v1.c     |   9 +-
 6 files changed, 265 insertions(+), 144 deletions(-)


base-commit: 54d2161835d828a9663f548f61d1d9c3d3482122
-- 
2.41.0

