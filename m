Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F4F86A91A2
	for <lists+linux-fscrypt@lfdr.de>; Fri,  3 Mar 2023 08:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229725AbjCCHXb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 3 Mar 2023 02:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbjCCHXa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 3 Mar 2023 02:23:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F3301352D;
        Thu,  2 Mar 2023 23:23:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 09C306176B;
        Fri,  3 Mar 2023 07:23:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4785EC433D2;
        Fri,  3 Mar 2023 07:23:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677828208;
        bh=H0vgaS3qOJJopQo5ihGBje3nOX8FoYe6iwbI5I5QK/I=;
        h=From:To:Cc:Subject:Date:From;
        b=Ka5VvvopH4WuH4cUTg9PmDffE8YF3jAyVNvGnhNF9HV1YwKkaXvrBTK5vhIVxeL7S
         /D+bToOAH3NDxj7LOgR+EXIA1XoB43RvZDwNBgi/w7ysKpNeL+Bed2l868I9MaQrR8
         9/aWUjNctoAdDzmj0fzBDjhydtvnlGwTqT0eHBX7MOhny3yeLmhScRr4UF7TacUp3Z
         V4reXT70bB3R7/6hdqj+ClyCK5dLf+YFRkZOaEO51WMVMP8SLjqny/syzMS+aIhxBP
         yOdnEa7/k28X+74d6v9i6hhK7zUJIlgGgHPqp/NPqFOr8UtZxLlKRmrvjD3whR9dck
         nuIw+4h9H2Tyw==
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>
Cc:     linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>
Subject: [PATCH 0/3] Fix blk-crypto keyslot race condition
Date:   Thu,  2 Mar 2023 23:19:56 -0800
Message-Id: <20230303071959.144604-1-ebiggers@kernel.org>
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

Eric Biggers (3):
  blk-mq: release crypto keyslot before reporting I/O complete
  blk-crypto: make blk_crypto_evict_key() more robust
  blk-crypto: remove blk_crypto_insert_cloned_request()

 Documentation/block/inline-encryption.rst |  3 +-
 block/blk-crypto-internal.h               | 28 +++++--------
 block/blk-crypto-profile.c                | 50 +++++++++--------------
 block/blk-crypto.c                        | 47 +++++++++++----------
 block/blk-mq.c                            | 17 +++++++-
 5 files changed, 71 insertions(+), 74 deletions(-)


base-commit: 2eb29d59ddf02e39774abfb60b2030b0b7e27c1f
-- 
2.39.2

