Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188106BD329
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Mar 2023 16:15:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231205AbjCPPPD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 16 Mar 2023 11:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40712 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230258AbjCPPPC (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 16 Mar 2023 11:15:02 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 513B1CD66A;
        Thu, 16 Mar 2023 08:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=M7NmYC/Iylm9myghHwqILim55SAUt9QrM+UZYk0eJlw=; b=zRNICJ9f1ohwZdw0QHlWmhLRvd
        C7ApS1LWJV6qffldqGI7XinByNvasxq7TEpxla8f8NCACFDu+BJ5w9EL2SlgJUihI5PRxgV2r86H+
        tRk2sYVBHgnpX3f2N8CXmYVZOiDCfnY7G/VXMrJiEf34R2EAykRcN0vO9lChO57PC4m/GpBblj6e2
        K5XELHa62xKtUbINAWSqKBPuQhtS9w5HFu5aAVPQhBQJcMk4DOi+yWBEdSp2Qy7vmFtyy+yNmQ7QK
        bI934szTRwvaX+2wN+rZ80GqGT9coFnMQIURwT/A0O22fZWcs95Udp9OicyEhkTPUCFIPFGn3RACK
        UUwvTy5A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.96 #2 (Red Hat Linux))
        id 1pcpJl-00GmwH-0O;
        Thu, 16 Mar 2023 15:15:01 +0000
Date:   Thu, 16 Mar 2023 08:15:01 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>
Subject: Re: [PATCH v3 4/6] blk-crypto: remove
 blk_crypto_insert_cloned_request()
Message-ID: <ZBMydZedtJYmS84M@infradead.org>
References: <20230315183907.53675-1-ebiggers@kernel.org>
 <20230315183907.53675-5-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315183907.53675-5-ebiggers@kernel.org>
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
