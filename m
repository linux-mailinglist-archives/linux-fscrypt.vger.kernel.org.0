Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1437A6BBC06
	for <lists+linux-fscrypt@lfdr.de>; Wed, 15 Mar 2023 19:27:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231253AbjCOS10 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 15 Mar 2023 14:27:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230393AbjCOS1U (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 15 Mar 2023 14:27:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 111C82B9DE;
        Wed, 15 Mar 2023 11:27:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BB390B81ECD;
        Wed, 15 Mar 2023 18:27:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4966CC433EF;
        Wed, 15 Mar 2023 18:27:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678904837;
        bh=cBSW5MAk8JFfbILsNyK0bqYjy53aCjn/X/DKS7WmeSo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LF5bDRioKxsCKBT41CU1vUYF3QuAC2BPqzlqbAFXsyegcTBjB+6TFDX7DRCQATNiF
         q+N6FKtoKlOeJxixHS1N7jhyYXXNb/8KCuIq5AxnQQ13WW9OUqvY8mzF5G3AD+ztNn
         UdR6JvVf/cg5zURH8UVxkmdelqZxPAHxKnWJm4qOAlhgUJvvCkb7YZRj881SmPCMJX
         MDdWnHu4W0vDpjfCH76U9d+wLH8B230W6hX84x7n3V/wTEcRads5PRXKylSE6lD9NZ
         ZMvB4fwDPC5f5wCKsYSMDl+phsyOKIpQ16nzKtPONzLvKAny21mAxbp4EG3bUWVYYV
         ym2ky4ejWjJsw==
Date:   Wed, 15 Mar 2023 11:27:15 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        linux-fscrypt@vger.kernel.org,
        Nathan Huckleberry <nhuck@google.com>
Subject: Re: [PATCH v2 3/4] blk-crypto: remove
 blk_crypto_insert_cloned_request()
Message-ID: <20230315182715.GC975@sol.localdomain>
References: <20230308193645.114069-1-ebiggers@kernel.org>
 <20230308193645.114069-4-ebiggers@kernel.org>
 <ZBHxJK+MAGIBmHOU@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBHxJK+MAGIBmHOU@infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Mar 15, 2023 at 09:24:04AM -0700, Christoph Hellwig wrote:
> > -	if (blk_crypto_insert_cloned_request(rq))
> > +	if (blk_crypto_rq_get_keyslot(rq))
> >  		return BLK_STS_IOERR;
> 
> Wouldn't it be better to propagate the actual error from
> blk_crypto_rq_get_keyslot?
> 

I'll add a patch that does that.

- Eric
