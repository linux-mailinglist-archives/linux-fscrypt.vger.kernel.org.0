Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C8636BD32C
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Mar 2023 16:15:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230510AbjCPPPV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 16 Mar 2023 11:15:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbjCPPPU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 16 Mar 2023 11:15:20 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9D3AC5AF3;
        Thu, 16 Mar 2023 08:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=OemlEVHTlSMrkA2pGR3uUJ08PC
        KWxbLrxILxREYSizCKhotf+bXs/ZhabwyJF3XPBBzb51Pxc93Ftkopa51SpwOsVytb4OLbG1/2zKY
        siPmy4XFcdqRzR++w47d0zCS9Gx1Sn3H0npWXcRzmjiDiTvjMn5Rglhe1viyqPDtMMyJbABf8gca6
        To6fvube2MMMpQffuLBduGbWqI60GP/HQ8O9F6alyP3B5l0q04cVQDhm9qaf5H7LqnUbUvquOeUGJ
        stvaRrdbpg4IOMqme+6F2lQ1WYk2oVvRy8MyayWCjPugTgg1fohCC2WYts22DClvwKUzRBK6Wu+co
        ysKIu0Iw==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pcpJx-00GmyJ-2A;
        Thu, 16 Mar 2023 15:15:13 +0000
Date:   Thu, 16 Mar 2023 08:15:13 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>
Subject: Re: [PATCH v3 5/6] blk-mq: return actual keyslot error in
 blk_insert_cloned_request()
Message-ID: <ZBMygd/O4ZbwZhYE@infradead.org>
References: <20230315183907.53675-1-ebiggers@kernel.org>
 <20230315183907.53675-6-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315183907.53675-6-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
