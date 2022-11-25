Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 390CE638FA8
	for <lists+linux-fscrypt@lfdr.de>; Fri, 25 Nov 2022 19:24:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229931AbiKYSYL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 25 Nov 2022 13:24:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42214 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiKYSYK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 25 Nov 2022 13:24:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BE3F1144B;
        Fri, 25 Nov 2022 10:24:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 06AE560ADC;
        Fri, 25 Nov 2022 18:24:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18488C433D6;
        Fri, 25 Nov 2022 18:24:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669400649;
        bh=UB/6VuW6a7ynj0jFuUpMvx4UWz72yWtQ5l1fc/HCPM0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Eoz7ku9gVq5fMqJViH4Smf9hUU0hN9cNOwGyDNxFCgtdhX47lHmGi6PckKBlAaX/h
         swWyAIzF5FPgsYt66PwZu6iZiuv8PwC3EKMh45TNa60nHwnj85TJcjxSBZHp2gPukh
         57pQuVWOerWidBE6bQQvOGkniqdXlyywNMhmJwxCZvCKUlei+MrQJdpIruoT9PTHjw
         i9YMjsY7p1o54Qt5CghvextJiC7+akKh43AmykapDZmbfs/Zep5O/M8hnD0EPCP1RA
         BQUOX7sUE/6PYVxlEwboKdvCo5NAKGGi5vEb6jwWTUU5Q9kskv0Rq/cyWFJrC/kF+w
         il3mkKgAxIJ0Q==
Date:   Fri, 25 Nov 2022 10:24:07 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "Theodore Y. Ts o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v3 2/2] fscrypt: Add SM4 XTS/CTS symmetric algorithm
 support
Message-ID: <Y4EIR+n8aKutuLo0@sol.localdomain>
References: <20221125121630.87793-1-tianjia.zhang@linux.alibaba.com>
 <20221125121630.87793-3-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221125121630.87793-3-tianjia.zhang@linux.alibaba.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Nov 25, 2022 at 08:16:30PM +0800, Tianjia Zhang wrote:
> diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
> index 46757c3052ef..8e69bc0c35cd 100644
> --- a/fs/crypto/policy.c
> +++ b/fs/crypto/policy.c
> @@ -71,6 +71,10 @@ static bool fscrypt_valid_enc_modes_v1(u32 contents_mode, u32 filenames_mode)
>  	    filenames_mode == FSCRYPT_MODE_AES_128_CTS)
>  		return true;
>  
> +	if (contents_mode == FSCRYPT_MODE_SM4_XTS &&
> +	    filenames_mode == FSCRYPT_MODE_SM4_CTS)
> +		return true;
> +
>  	if (contents_mode == FSCRYPT_MODE_ADIANTUM &&
>  	    filenames_mode == FSCRYPT_MODE_ADIANTUM)
>  		return true;

Sorry, one more thing I didn't notice before.  Since this is a new feature,
please only allow it in fscrypt_valid_enc_modes_v2(), not in
fscrypt_valid_enc_modes_v1().  That's what we did for AES-256-XTS +
AES-256-HCTR2 recently.  There should be no need to add new features to
v1 encryption policies, which have been deprecated for several years.

- Eric
