Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70122627545
	for <lists+linux-fscrypt@lfdr.de>; Mon, 14 Nov 2022 05:29:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235814AbiKNE3x (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 13 Nov 2022 23:29:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235771AbiKNE3w (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 13 Nov 2022 23:29:52 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B883563A1;
        Sun, 13 Nov 2022 20:29:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=kHAhMV0dMLA9XhA9abFZTXHHXS3ctIoOZbWM9h9KFRE=; b=v3cXPa8DoS92RX01FUbgZDoP0b
        IJ6o8qqruhm8krEwgqxXhYaGFUgRn3olOWGhKn+NWBghzXiq0UEMp0qB+CjcK52W6+G9c0qm3NdRt
        p5tlImP04aZa5alICyRuoFaoCbaGuzo+cZAGDs4mNdb6iINzz+gls9hmjzBUVMy6IsKmaCMujOC18
        Xy3vmH891B/2oTnOWDg5ci2OlzS6vX9p7OItlOKiFjNOCIdzKhDYsxJUolEcTvWXLmn9hfCddMlKH
        uGh9COLhhbglFXFalOeStt0nzWG3+v8hfqKPYg0n0bynjdSSEUPu6heUFJIXtr/+MYc/vxqndiVBy
        LTZWBifw==;
Received: from [2001:4bb8:191:2606:c70:4a89:bc61:2] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1ouR6Q-00FvTJ-RA; Mon, 14 Nov 2022 04:29:47 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Mike Snitzer <snitzer@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: pass a struct block_device to the blk-crypto interfaces v3
Date:   Mon, 14 Nov 2022 05:29:41 +0100
Message-Id: <20221114042944.1009870-1-hch@lst.de>
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

Changes since v2:
 - update a few comments
 - fix a whitespace error
 - remove now unused forward declarations
 - fix spelling errors an not precise enough wording in commit messages
 - move a few more declarations around inside or between headers

Changes since v1:
 - keep using request_queue in the Documentation for driver interfaces
 - rename to blk_crypto_cfg_supported to
   blk_crypto_config_supported_natively and move it to blk-crypto.[ch]
 - mark __blk_crypto_cfg_supported private

Diffstat:
 Documentation/block/inline-encryption.rst |   12 ++++-----
 block/blk-crypto-internal.h               |   12 +++++++++
 block/blk-crypto.c                        |   37 +++++++++++++++++-------------
 drivers/md/dm-table.c                     |    2 -
 fs/crypto/inline_crypt.c                  |   14 ++++-------
 include/linux/blk-crypto-profile.h        |   12 ---------
 include/linux/blk-crypto.h                |   13 ++++------
 7 files changed, 52 insertions(+), 50 deletions(-)
