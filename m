Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DE4F76BBC7B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Mar 2023 19:42:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbjCOSmI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 15 Mar 2023 14:42:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35268 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230106AbjCOSmH (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 15 Mar 2023 14:42:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5F69F2CFD0;
        Wed, 15 Mar 2023 11:41:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A34CB81ED4;
        Wed, 15 Mar 2023 18:40:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7F3C433EF;
        Wed, 15 Mar 2023 18:40:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678905632;
        bh=A9CDt2T2bSgHBYCuFLZU5l1szdQcB7LuRR7PmZw2Nfo=;
        h=From:To:Cc:Subject:Date:From;
        b=DgBPNufh+Yo4pDS7QWDgzAlec0QUL/BlA05u9mUfLG/SslHoGEACkueoQIsyKT5B+
         mJ0f2hUmVaR9rYSKpj0P5YccXB+1H7ZW6Vow9g4VNjjsFkFNrOsifs0KjZzjfFu1iC
         RDaHatSsHWO6pvpzd3CBM24fKCh4oHG7LHJp/W/dd8kQj7ww5vtvirV31x/BRKYAWe
         0xDyrigprgkOBXCE7KH5mN9wg/nNsBh1fgvOr0s0l+hO8BspDKeVryMupMNpxQUKsd
         qzdNM3al8jQalz8v+DGjj9phB/MPDT5/bQA7mMXTIFJRLCr/ykmwIUPh6/z9NMR6oJ
         RCuTr2xkAVnbw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>
Subject: [PATCH v3 0/6] Fix blk-crypto keyslot race condition
Date:   Wed, 15 Mar 2023 11:39:01 -0700
Message-Id: <20230315183907.53675-1-ebiggers@kernel.org>
X-Mailer: git-send-email 2.39.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
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

Changed in v3:
  - Add a patch that makes blk_crypto_evict_key() return void
  - Add a patch that makes blk_insert_cloned_request() pass on the
    actual error code from blk_crypto_rq_put_keyslot()
  - Use gotos in __blk_crypto_evict_key()

Changed in v2:
  - Call blk_crypto_rq_put_keyslot() when requests are merged
  - Add and use blk_crypto_rq_has_keyslot()
  - Add patch "blk-crypto: drop the NULL check from blk_crypto_put_keyslot()"

Eric Biggers (6):
  blk-mq: release crypto keyslot before reporting I/O complete
  blk-crypto: make blk_crypto_evict_key() return void
  blk-crypto: make blk_crypto_evict_key() more robust
  blk-crypto: remove blk_crypto_insert_cloned_request()
  blk-mq: return actual keyslot error in blk_insert_cloned_request()
  blk-crypto: drop the NULL check from blk_crypto_put_keyslot()

 Documentation/block/inline-encryption.rst |  3 +-
 block/blk-crypto-internal.h               | 38 ++++++-------
 block/blk-crypto-profile.c                | 60 +++++++++------------
 block/blk-crypto.c                        | 66 +++++++++++++----------
 block/blk-merge.c                         |  2 +
 block/blk-mq.c                            | 20 +++++--
 drivers/md/dm-table.c                     | 19 ++-----
 include/linux/blk-crypto.h                |  4 +-
 8 files changed, 110 insertions(+), 102 deletions(-)


base-commit: eeac8ede17557680855031c6f305ece2378af326
-- 
2.39.2

