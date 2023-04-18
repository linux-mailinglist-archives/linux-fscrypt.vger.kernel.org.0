Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 105506E6A7D
	for <lists+linux-fscrypt@lfdr.de>; Tue, 18 Apr 2023 19:05:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232137AbjDRRFL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Apr 2023 13:05:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230257AbjDRRFK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Apr 2023 13:05:10 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 768901719
        for <linux-fscrypt@vger.kernel.org>; Tue, 18 Apr 2023 10:05:09 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id C080780349;
        Tue, 18 Apr 2023 13:05:08 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681837509; bh=Odb8uB/9CJfwZKBREH3PMv47B2f4ylD2kdvW9fudEpY=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
        b=sxSyZ1iiSGcxnQ1RAxagPl2HyUoFXrB7ywDmw9IRlSpTMzLsTxJbTCqu177fn/uRa
         BrA1TwHzSuj1eOYFRrW6zvxCz44B6N0Iz8Ryk0PRZQN89NPO+St08umz5KH+nikcrP
         wP1EWcugPq5ZzfjXiwBzS4yXErpvzkysnNSyDQlrGwOYcmeB/E7ww/XYucQCn/1hvf
         DUQjXsrMlr8Y9WLeutmG6ruwPrLN78i99A1ri+sJ2HJ5RMYv7vKNOzfoYxr6IRZUKn
         7zFe8r+WGy5NVJkXDwEHuMakc1H2MBQyn5fFT4LqgV5SxS1MFFwN7ELmFV5HHyVtEr
         26Ch9Hw7fFbPw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v3 00/11] fscrypt: rearrangements preliminary to extent encryption
Date:   Tue, 18 Apr 2023 13:04:37 -0400
Message-Id: <cover.1681837335.git.sweettea-kernel@dorminy.me>
In-Reply-To: <1edeb5c4936667b6493b50776cd1cbf5e4cf2fdd.1681837291.git.sweettea-kernel@dorminy.me>
References: <1edeb5c4936667b6493b50776cd1cbf5e4cf2fdd.1681837291.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

As per [1], extent-based encryption needs to split allocating and
preparing crypto_skciphers, since extent infos will be loaded at IO time
and crypto_skciphers cannot be allocated at IO time. 

This changeset undertakes to split the existing code to clearly
distinguish preparation and allocation of fscrypt_prepared_keys,
wrapping crypto_skciphers. Elegance of code is in the eye of the
beholder, but I've tried a decent variety of arrangements here and this
seems like the clearest result to me; happy to adjust as desired, and
more changesets coming soon, this just seemed like the clearest cutoff
point for preliminaries without being pure refactoring.

Patchset should apply cleanly to fscrypt/for-next (as per base-commit
below), and pass ext4/f2fs tests (kvm-xfstests is not currently
succesfully setting up ubifs volumes for me).

[1] https://lore.kernel.org/linux-btrfs/Y7NQ1CvPyJiGRe00@sol.localdomain/ 

Changes from v2:
Combined the two changes affecting ci->ci_direct_key.
Combined last two changes in v2 and rearranged to lock for every check
of mode keys.
Addressed hopefully all style comments.
Added another change, a tiny helper.

Changes from v1:
Included change 1, erroneously dropped, and generated patches using --base.

Sweet Tea Dorminy (11):
  fscrypt: move inline crypt decision to info setup.
  fscrypt: split and rename setup_file_encryption_key()
  fscrypt: split setup_per_mode_enc_key()
  fscrypt: move dirhash key setup away from IO key setup
  fscrypt: reduce special-casing of IV_INO_LBLK_32
  fscrypt: make infos have a pointer to prepared keys
  fscrypt: move all the shared mode key setup deeper
  fscrypt: make prepared keys record their type.
  fscrypt: lock every time a info needs a mode key
  fscrypt: split key alloc and preparation
  fscrypt: factor helper for locking master key

 fs/crypto/crypto.c          |   2 +-
 fs/crypto/fname.c           |   4 +-
 fs/crypto/fscrypt_private.h |  67 ++++--
 fs/crypto/inline_crypt.c    |  29 +--
 fs/crypto/keysetup.c        | 454 +++++++++++++++++++++++-------------
 fs/crypto/keysetup_v1.c     |  15 +-
 6 files changed, 362 insertions(+), 209 deletions(-)

-- 
2.40.0

