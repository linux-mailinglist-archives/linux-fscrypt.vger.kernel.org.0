Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B8346DCBB0
	for <lists+linux-fscrypt@lfdr.de>; Mon, 10 Apr 2023 21:40:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbjDJTkS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 15:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229485AbjDJTkR (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 15:40:17 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 292DC1BD9
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 12:40:16 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 68E898023A;
        Mon, 10 Apr 2023 15:40:15 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681155615; bh=yVyMZB8dbfQ8pyLrHRN3tDUUdFY/eRH5fpoJqp9J+S8=;
        h=From:To:Cc:Subject:Date:From;
        b=GxRdo4j6J4veCsyO7okblrp1D7sFquCJsn6yJJ2Y5f3ZDt+uI0dwBhWF1Yq9kwZIS
         P2hISLoVGzBX4iT629Otzbk2GeeG3VW/A0UevYJwyQFNGdw7kawQDVDOHdj//w0wE5
         zb75ayY6orDgWRCmtShKsv1Ttw5gL+1G2YHW1EOxz73Wf6Ik9J6ZoOiRZlY+8wUbPk
         JBkqLo2Z4K/c2XkDHzrFOie2pBqOC0pIsBb5rJZF3cUYrW4e7Rzi24rT/KNkCoRmFh
         zKGZHbvNvFevZ3pVvVjQ5DDEF31EIy+WIGyy3+c5BzK72ZoJFgeyCh0+BdNJlirmum
         SFkq7HLg/SA5w==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v2 00/11] fscrypt: rearrangements preliminary to extent encryption
Date:   Mon, 10 Apr 2023 15:39:53 -0400
Message-Id: <cover.1681155143.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
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

Changes from v1:
Included change 1, erroneously dropped, and generated patches using --base.

Sweet Tea Dorminy (11):
  fscrypt: move inline crypt decision to info setup.
  fscrypt: split and rename setup_file_encryption_key()
  fscrypt: split and rename setup_per_mode_enc_key()
  fscrypt: move dirhash key setup away from IO key setup
  fscrypt: reduce special-casing of IV_INO_LBLK_32
  fscrypt: make infos have a pointer to prepared keys
  fscrypt: move all the shared mode key setup deeper
  fscrypt: make ci->ci_direct_key a bool not a pointer
  fscrypt: make prepared keys record their type.
  fscrypt: explicitly track prepared parts of key
  fscrypt: split key alloc and preparation

 fs/crypto/crypto.c          |   2 +-
 fs/crypto/fname.c           |   4 +-
 fs/crypto/fscrypt_private.h |  73 +++++--
 fs/crypto/inline_crypt.c    |  30 +--
 fs/crypto/keysetup.c        | 387 ++++++++++++++++++++++++------------
 fs/crypto/keysetup_v1.c     |  13 +-
 6 files changed, 340 insertions(+), 169 deletions(-)


base-commit: 83e57e47906ce0e99bd61c70fae514e69960d274
-- 
2.40.0

