Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A97D661901C
	for <lists+linux-fscrypt@lfdr.de>; Fri,  4 Nov 2022 06:46:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229745AbiKDFqa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 4 Nov 2022 01:46:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229646AbiKDFq3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 4 Nov 2022 01:46:29 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E9DC5F94;
        Thu,  3 Nov 2022 22:46:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        MIME-Version:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=+tnMKXf+vNlxPQqnC37CevJqqfXK3FDu+tVcxBjiuOU=; b=GLk1+8NeHrAHJbqCrl13BEEHoP
        Vh+edhRhy3gqe7ShdokfyFSZ6rKA32YLuSGUI7PcmPoIo60fEmaGO5fPnVIoLGF8dmndcqE6PXvw1
        LNDaSlygs0POyxEelvnnRA2ZLlnmlj1P1DO/wgt7rDWBUIigCdX9hmobDayJ6TVK10QVAffQAJ/0K
        mpeOMUSqErJCPpoLvxCLpLl5acyRei+48G/fYYOPhXwDJV27fMb3NGhVMfEP48ruOtbtFx4KgNdhS
        +upAkqU2cT/YfgqphgcMJyxJq42vb05kj9kGW6tnDaD3FJCLbXaTJB+V5qf39qEOJIR9PtHqVVLWD
        ZCmZmwHw==;
Received: from [2001:4bb8:182:29ca:9be5:7ea:ab68:47c9] (helo=localhost)
        by bombadil.infradead.org with esmtpsa (Exim 4.94.2 #2 (Red Hat Linux))
        id 1oqpX5-002S1R-La; Fri, 04 Nov 2022 05:46:24 +0000
From:   Christoph Hellwig <hch@lst.de>
To:     Jens Axboe <axboe@kernel.dk>
Cc:     Mike Snitzer <snitzer@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: pass a struct block_device to the blk-crypto interfaces
Date:   Fri,  4 Nov 2022 06:46:19 +0100
Message-Id: <20221104054621.628369-1-hch@lst.de>
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

Diffstat:
 Documentation/block/inline-encryption.rst |   24 ++++++++++++------------
 block/blk-crypto-profile.c                |    7 +++++++
 block/blk-crypto.c                        |   25 ++++++++++++-------------
 drivers/md/dm-table.c                     |    2 +-
 fs/crypto/inline_crypt.c                  |   12 ++++--------
 include/linux/blk-crypto-profile.h        |    2 ++
 include/linux/blk-crypto.h                |    8 ++++----
 7 files changed, 42 insertions(+), 38 deletions(-)
