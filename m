Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0DAC174C781
	for <lists+linux-fscrypt@lfdr.de>; Sun,  9 Jul 2023 20:53:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229534AbjGISxS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 9 Jul 2023 14:53:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57538 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229766AbjGISxQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 9 Jul 2023 14:53:16 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BDF7C124;
        Sun,  9 Jul 2023 11:53:14 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id C23F980AE0;
        Sun,  9 Jul 2023 14:53:13 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1688928794; bh=Pw7gt8twiV6Nw6iEio2pPj76SM11QXNxjimBXweF3l0=;
        h=From:To:Cc:Subject:Date:From;
        b=myGhlnmq4v+iLiTPGzvCGabkLNECiEbuhra3jyaJz637IMGeEOw23BQKuYZFMru25
         wyofvB49mCjZqhBjDDf7zZk1TPNA2SqITQ0B4iIQnwpRp/rLPfkdSHG0rQn2WoSJQV
         KdPa7qczMzmkormRmbdmxMoPRO4VIFQpZNaZfWFP6mgX7l2NBV6brDHpbXgkXfZl0J
         9zzgWp3fQIueXzFwuCSdqAGVNe0z8T4xbmO2zfjXeQKUYLo7AyJ3h0AdHetYxe6nWU
         1OaeOUe6UcKJmFp1OB5l+EqFUHYFOgrQ879U3AEYfc4G4TcPHRAkjDUYPkBOSXnteE
         Ryr+v4+5p76Zw==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v5 0/8] fscrypt: some rearrangements of key setup
Date:   Sun,  9 Jul 2023 14:53:00 -0400
Message-Id: <cover.1688927423.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This is a patchset designed to make key setup slightly clearer to me
ahead of rearranging it to add extent-based encryption. It is basically
a subset of my prior changeset [1] for elegance. The subsequent changes
have minor dependencies on it; I can drop this changeset if it's
preferable, although I do think it makes everything cleaner.

Patchset is built on kdave/misc-next as per base commit and needs a tiny
fixup to apply to fscrypt/for-next. It passes ext4/f2fs tests for me.

[1] https://lore.kernel.org/linux-fscrypt/cover.1681837335.git.sweettea-kernel@dorminy.me/

Changelog:

v5:
- Fixed kernel build robot complaint in patch 3.

v4:
- https://lore.kernel.org/linux-fscrypt/cover.1687988119.git.sweettea-kernel@dorminy.me/T/#t

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
 fs/crypto/keysetup.c        | 375 +++++++++++++++++++++++-------------
 fs/crypto/keysetup_v1.c     |   9 +-
 6 files changed, 274 insertions(+), 153 deletions(-)


base-commit: e0144e6be2ec62c8d874076a6292a8d83b00ee32
-- 
2.40.1

