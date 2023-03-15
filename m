Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5D7776BB99A
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Mar 2023 17:24:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231290AbjCOQY2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 15 Mar 2023 12:24:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230421AbjCOQY1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 15 Mar 2023 12:24:27 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C84231DB94;
        Wed, 15 Mar 2023 09:24:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=Q8bUy/7/A4tEFTmIKVtgE6G8ry
        dDERRfcJ0cEYUag7VAjE/RIWIq++JUph2HnrJ1Er3oBkkG/4LU8oPk6Bc2vzrjdbyTrxKms/bMgAs
        E9TeVOfygcMRceck5KNpz25zqRTUAo+n8EeHVcYHltESAlu8QzVZgZcTDBQjjbwT9YDkUPQCJBTkY
        uHrimT5Mee3+ssOio2/T+AmIKfWHQAMc7QfuADtxmHO6QfRAP08QqwCCqP+orJckTSR021go8P6vJ
        hu+tavj514LS5fVeYlfxp8g5qs0t420H1ZkMokDQmLg9x5I/xYHkSOBGc/VYedkSdH6YS6s3Owmoh
        JB9HV29A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pcTvO-00E3BQ-2F;
        Wed, 15 Mar 2023 16:24:26 +0000
Date:   Wed, 15 Mar 2023 09:24:26 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>
Subject: Re: [PATCH v2 4/4] blk-crypto: drop the NULL check from
 blk_crypto_put_keyslot()
Message-ID: <ZBHxOl5hIdO5mINn@infradead.org>
References: <20230308193645.114069-1-ebiggers@kernel.org>
 <20230308193645.114069-5-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230308193645.114069-5-ebiggers@kernel.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_NONE,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
