Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 830E46E7129
	for <lists+linux-fscrypt@lfdr.de>; Wed, 19 Apr 2023 04:42:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjDSCmZ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 18 Apr 2023 22:42:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229867AbjDSCmZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 18 Apr 2023 22:42:25 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77ACF6193
        for <linux-fscrypt@vger.kernel.org>; Tue, 18 Apr 2023 19:42:23 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id D7B8980528;
        Tue, 18 Apr 2023 22:42:22 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681872143; bh=Q0zhgxJk0QOQkVZXxR+InaxEMY7Z7Lq802colCsU6qw=;
        h=From:To:Cc:Subject:Date:From;
        b=OAqv4TK8o4CGSVF6oyIZIjAhnMprjOvGZe14/VDPYQxrwdzQbmWOm0lKz18LHV3LY
         oQwg3Se57J0NuBsXtRDPuLmAQ3/X7/02XDu2DUaC/dTCLAi2TlTKtqkM7e3U1mV1Yj
         KFLQTqaWdg0oh/Jwtu9UmeW86Z6j37hy03g41MqdWmXtZFTuCAuwmDQxw4cxm89iFh
         kcPZUnEyZgmM8hr8U3X9sxflBlZEzANjBIfNky5og261XfWiYQZsf0Wr3Qbq7HIisE
         vh8NY7maR9VK+2aibp/pvIqVtvGh8PMqdxrMfXeD5z1wJIN/x5/o43ZwdHnnbTJB9u
         bQ/g19H0qwdrg==
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Subject: [PATCH v1 0/7] fscrypt: add pooled prepared keys facility
Date:   Tue, 18 Apr 2023 22:42:09 -0400
Message-Id: <cover.1681871298.git.sweettea-kernel@dorminy.me>
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

This is part two of two of preliminaries to extent-based encryption,
adding a facility to pool pre-allocated prepared keys and use them at IO
time.

While arguably one structure within the feature, and not actually used
in this changeset at that, it's a disjoint piece that has various taste
questions so I've put it in its own changeset here for good or ill.

The change has been tested by switching a false to true so as to use it
for leaf inodes which are doing contents encryption, and then running
the standard tests. Such a thing changes the timing of when the prepared
key is set up, obviously, so that IO which begins after a master key
secret is removed no longer succeeds; this fails generic/{580,581,593}
which don't have that expectation. However, this code has no impact on
tests if disabled.

Known suboptimalities:
-right now at the end nothing calls fscrypt_shrink_key_pool() and it
throws an unused function warning.
-right now it's hooked up to be used by leaf inodes not using inline
encryption only. I don't know if there's any interest in pooling inode
keys -- it could reduce memory usage on memory-constrained platforms --
and if so using it for filename encryption also might make sense. On the
other hand, if there's no interest, the code allowing use of it in the normal
inode-info path is unnecessary.
-right now it doesn't pool inline encryption objects either.
-the initialization of a key pool for each mode spams the log with
"Missing crypto API support" messages. Maybe the init of key pools
should be the first time an info using pooled prepared keys is observed?

Some questions:

-does the pooling mechanism need to be extended to mode keys, which can
easily be pre-allocated if needed?
-does it need to be extended to v1 policies?
-does it need to be behind a config option, perhaps with extent
encryption?
-should it be in its own, new file, since it adds a decent chunk of code
to keysetup.c most of which is arguably key-agnostic?

This changeset should apply atop the previous one, entitled
'fscrypt: rearrangements preliminary to extent encryption'
lore.kernel.org/r/cover.1681837335.git.sweettea-kernel@dorminy.me


Sweet Tea Dorminy (7):
  fscrypt: add new pooled prepared keys.
  fscrypt: set up pooled keys upon first use
  fscrypt: add pooling of pooled prepared keys.
  fscrypt: add pooled prepared key locking around use
  fscrypt: reclaim pooled prepared keys under pressure
  fscrypt: add facility to shrink a pool of keys
  fscrypt: add lru mechanism to choose pooled key

 fs/crypto/crypto.c          |  28 ++-
 fs/crypto/fscrypt_private.h |  37 +++
 fs/crypto/keyring.c         |   7 +
 fs/crypto/keysetup.c        | 440 +++++++++++++++++++++++++++++++++---
 4 files changed, 468 insertions(+), 44 deletions(-)

-- 
2.40.0

