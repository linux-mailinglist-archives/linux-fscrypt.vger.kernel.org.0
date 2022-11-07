Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6F65161F65F
	for <lists+linux-fscrypt@lfdr.de>; Mon,  7 Nov 2022 15:42:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231712AbiKGOmo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Nov 2022 09:42:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56136 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230434AbiKGOmn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Nov 2022 09:42:43 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8564312AD0;
        Mon,  7 Nov 2022 06:42:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=HueqHs75+uu16iwiA7HFzJWXHvl6AXbQrRJFOr0opp0=; b=YnnwPV7YIWOZA4ZOWUmHO2Rxnh
        2sCkjNCVt7J98j7YsZs273LaEoV5Hsuu6AEJAscqa1jpzATF3Kyqefgdm1sq5bPjl5ZV7y4t35nLz
        y5jsh8aK5J8WThgh+9sC1UTzZ0SyyUT19OkiR//miYgpkV8JKtYfyoGsWgo6YriYKmBxkrK++0ki4
        JLaZeJAsjfyGcUm+vd14E3rfW3XdtfqnzzMKcoJ33G+eQCjk3zwP3v9xh6AzSqvI7YidqImuR+BiD
        h1xcKLUWLyDOJWjdKpiREW3GJfMXBfODNWWL7OTmThxWH83+I0TCpyHthnr48fA7MK4b56m0ybVr5
        Jle++K9Q==;
Received: from [2001:4bb8:191:2450:bd6a:c86c:b287:8b99] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1os3KZ-00FJWE-PF; Mon, 07 Nov 2022 14:42:32 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Mike Snitzer <snitzer@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: pass a struct block_device to the blk-crypto interfaces v2
Date:   Mon,  7 Nov 2022 15:42:26 +0100
Message-Id: <20221107144229.1547370-1-hch@lst.de>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_EF,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi all,

this series switches the blk-crypto interfaces to take block_device
arguments instead of request_queues, and with that finishes off the
project to hide struct request_queue from file systems.

Changes since v1:
 - keep using request_queue in the Documentation for driver interfaces
 - rename to blk_crypto_cfg_supported to
   blk_crypto_config_supported_natively and move it to blk-crypto.[ch]
 - mark __blk_crypto_cfg_supported private

Diffstat:
 Documentation/block/inline-encryption.rst |   12 +++++-----
 block/blk-crypto-internal.h               |    3 ++
 block/blk-crypto.c                        |   33 ++++++++++++++++++------------
 drivers/md/dm-table.c                     |    2 -
 fs/crypto/inline_crypt.c                  |   14 ++++--------
 include/linux/blk-crypto-profile.h        |    3 --
 include/linux/blk-crypto.h                |   10 +++++----
 7 files changed, 41 insertions(+), 36 deletions(-)
