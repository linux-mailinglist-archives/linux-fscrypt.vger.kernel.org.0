Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BEC8163F82B
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Dec 2022 20:29:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229773AbiLAT3T (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 1 Dec 2022 14:29:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229810AbiLAT3S (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 1 Dec 2022 14:29:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57D41C7D27;
        Thu,  1 Dec 2022 11:29:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09BCBB8201E;
        Thu,  1 Dec 2022 19:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B662C433C1;
        Thu,  1 Dec 2022 19:29:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669922954;
        bh=J43MOZ0js3CHpA7AwpgZh/EydKVlRQh87fdR90KbnRY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=rD8FMgQukf48d4Y/QPh3LFy1sKkP4JdDiYxMhNO1HuDyXbeuu2h1PdaNULgR0hGQe
         wFaZCPUQEb8RU91EGwviDwhqZdxY3AfXn8b2kbTP04i0meZBQANgEIK1A0ERAoDAei
         5TUlrcpjwRQTyIh2gzYQFKPbq4mvlYEmtW7+vbZRkVljcGHrWVckv6QevxieIcM5N4
         OFfoeVkAHCG6dWQW7KVJeRWJesoh6r0LHfe9JUbGVABT96mHwUORX8oD3f3olmsJtk
         7DwwqZXiVIe+eRWKqD39Lqf35JDJHlfySWNA7riEZS6sCn+3OyuRSYJQ8RB5vAs/am
         XhhuxhCEN9G2Q==
Date:   Thu, 1 Dec 2022 11:29:12 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "Theodore Y. Ts o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        linux-fscrypt@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v4 0/2] Add SM4 XTS symmetric algorithm for blk-crypto
 and fscrypt
Message-ID: <Y4kAiKhZL4Ucv3MI@sol.localdomain>
References: <20221201125819.36932-1-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221201125819.36932-1-tianjia.zhang@linux.alibaba.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 01, 2022 at 08:58:17PM +0800, Tianjia Zhang wrote:
> SM4 is widely used in China's data encryption software and hardware.
> these algoritms are mandatory in many scenarios. This serial of
> patches enables the SM4-XTS algorithm in blk-crypto and enables the
> SM4-XTS/CTS algorithm in fscrypt to encrypt file content and filename.
> 
> v4 changes:
>   - only allow the SM4 XTS/CTS algorithm in policy v2 for fscrypt
>   - update git commit message
> 
> v3 change:
>   - update git commit message
> 
> v2 change:
>   - As Eric said, the new FSCRYPT_MODE is defined for the unused numbers 7 and 8
> 
> Tianjia Zhang (2):
>   blk-crypto: Add support for SM4-XTS blk crypto mode
>   fscrypt: Add SM4 XTS/CTS symmetric algorithm support
> 
>  Documentation/filesystems/fscrypt.rst |  1 +
>  block/blk-crypto.c                    |  6 ++++++
>  fs/crypto/keysetup.c                  | 15 +++++++++++++++
>  fs/crypto/policy.c                    |  5 +++++
>  include/linux/blk-crypto.h            |  1 +
>  include/uapi/linux/fscrypt.h          |  2 ++
>  6 files changed, 30 insertions(+)

Applied.  I don't think anyone should actually use this, but with the SM*
algorithms turning up everywhere these days, and people seemingly being totally
okay with that for some reason, I don't think it's fair for me to reject this.

- Eric
