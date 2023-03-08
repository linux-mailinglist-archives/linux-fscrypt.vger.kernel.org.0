Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7E1E6B1224
	for <lists+linux-fscrypt@lfdr.de>; Wed,  8 Mar 2023 20:39:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbjCHTji (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 8 Mar 2023 14:39:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229580AbjCHTjh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 8 Mar 2023 14:39:37 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1788624CB9;
        Wed,  8 Mar 2023 11:39:37 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B07B561927;
        Wed,  8 Mar 2023 19:39:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F29F3C433EF;
        Wed,  8 Mar 2023 19:39:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678304376;
        bh=KFNaBnZEVpESsOn2FHhHRQl3mEKvHz+3fHz1Jou7Nas=;
        h=From:To:Cc:Subject:Date:From;
        b=Pj1vIO/ClRzGkydYrA3NygDz51qm4hxdZmjACCmk6XCt99SSkWcs6eDulS0ioach/
         ZMvtSxry900W4zRAOF6O5bgcr21yNTTjnJ7q+hqNFOfPRmC18ENmcrObmxIOHnaLLP
         rWHuiGJCA+UB9hTSlIzlR0Weug5vXtWAC6buulQvZNE6shNTqIMv7++lxEtMYA1mVn
         /KYlleXdTkT/YdPPnR8xMMfX8fQLiBmYbRxAt8c5eRDWPeMDnNrJ2dZAIbLBnEMg8N
         VYTLJx8GVYe53sDD4dnaRJvCp2eGcXQDYKPleLCF+OiVYHHOX3vcYtLFs7B1if+nDP
         RyHEfJC03hcmA==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>
Subject: [PATCH v2 0/4] Fix blk-crypto keyslot race condition
Date:   Wed,  8 Mar 2023 11:36:41 -0800
Message-Id: <20230308193645.114069-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

This series fixes a race condition in blk-crypto keyslot management and
makes some related cleanups.  It replaces
"[PATCH] blk-crypto: make blk_crypto_evict_key() always try to evict"
(https://lore.kernel.org/r/20230226203816.207449-1-ebiggers@kernel.org),
which was a simpler fix but didn't fix the keyslot reference counting to
work as expected.

Changed in v2:
  - Call blk_crypto_rq_put_keyslot() when requests are merged
  - Add and use blk_crypto_rq_has_keyslot()
  - Add patch "blk-crypto: drop the NULL check from blk_crypto_put_keyslot()"

Eric Biggers (4):
  blk-mq: release crypto keyslot before reporting I/O complete
  blk-crypto: make blk_crypto_evict_key() more robust
  blk-crypto: remove blk_crypto_insert_cloned_request()
  blk-crypto: drop the NULL check from blk_crypto_put_keyslot()

 Documentation/block/inline-encryption.rst |  3 +-
 block/blk-crypto-internal.h               | 38 +++++++-------
 block/blk-crypto-profile.c                | 64 ++++++++---------------
 block/blk-crypto.c                        | 47 +++++++++--------
 block/blk-merge.c                         |  2 +
 block/blk-mq.c                            | 17 +++++-
 6 files changed, 87 insertions(+), 84 deletions(-)


base-commit: 63355b9884b3d1677de6bd1517cd2b8a9bf53978
-- 
2.39.2

