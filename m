Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7D91161FF69
	for <lists+linux-fscrypt@lfdr.de>; Mon,  7 Nov 2022 21:18:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231866AbiKGUSN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Nov 2022 15:18:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232191AbiKGUSM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Nov 2022 15:18:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4618519035;
        Mon,  7 Nov 2022 12:18:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 07E97B81699;
        Mon,  7 Nov 2022 20:18:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 59D1CC433C1;
        Mon,  7 Nov 2022 20:18:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667852289;
        bh=Bd+WJuXFN3kIB+rh/B/wGneGMrh4YMoA06a7tH110Cg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BeUjfFPWEfF53+kVV04wqpBE+76hyhpGOuEDGcLOYT04qB9MBGvVr9liyumK5Tq6P
         d43/LrwoALvMm859BW4M0SjfuSGkwkRxY0sBkQcx6WsqAJAGFOY7TFJBRu0SS2UZPu
         OmmnOcS64hxDNciAd/Lqz7ZIk9BY/xY0FfihLYSSmYMuZ+lJA6U+WB82PnRJ+Anwvi
         hezh3s1Ph+czU4b9afgXt2oddnK7Dmxih0AFkE6Chk+UF6qRJfKZ7Yx+lWQY6fecde
         0h3yNdC1JVoxPZIA9xaM1lBRYbRbOpYpV2QIPcBxL5nEFxBpntyDOPvlshLID8tKHy
         h0O+1rcyh2TLQ==
Date:   Mon, 7 Nov 2022 12:18:07 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Mike Snitzer <snitzer@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, dm-devel@redhat.com,
        linux-block@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 2/3] blk-crypto: add a
 blk_crypto_config_supported_natively helper
Message-ID: <Y2ln/953uv8Zg1jC@sol.localdomain>
References: <20221107144229.1547370-1-hch@lst.de>
 <20221107144229.1547370-3-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221107144229.1547370-3-hch@lst.de>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Nov 07, 2022 at 03:42:28PM +0100, Christoph Hellwig wrote:
> Add a blk_crypto_cfg_supported helper that wraps

s/blk_crypto_cfg_supported/blk_crypto_config_supported_natively/

> __blk_crypto_cfg_supported to retreive the crypto_profile from the

s/retreive/retrieve/.  checkpatch warns about this.

Otherwise this patch look good, thanks!

- Eric
