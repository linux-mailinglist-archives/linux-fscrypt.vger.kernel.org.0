Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7E7634476
	for <lists+linux-fscrypt@lfdr.de>; Tue, 22 Nov 2022 20:23:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233443AbiKVTW6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 22 Nov 2022 14:22:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234716AbiKVTW6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 22 Nov 2022 14:22:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5525CE12;
        Tue, 22 Nov 2022 11:22:57 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 419B7B81D50;
        Tue, 22 Nov 2022 19:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9177BC433C1;
        Tue, 22 Nov 2022 19:22:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669144974;
        bh=Nd2SSpX2rnlORZIuluFSyUmIIouCQL/zDa4vN299e4E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=GKVDKeWRBnacfdNcZLokrwElYe4jvGQbxsQh6kyyDkSFllijnHydQhaBmNaHeQJ7Y
         bTMQU8GPNnMcWnjL9KwMShGAnxkAZs9zAyGKWEGnJqdTMB9PM2S/U03A+S9tIF95yc
         EBcrcd0NzWG3KOwQNIH97dxyqqIb/F0wWvx2xblEWrKRvXKOD+/JO+HlfQCZhU9UnE
         L/oHVpRp++M6DClMKF+/tPdg3IwjBB8KaPfju8bePj8YYc0hcQ3gqIv17g516fkmb7
         hvLqLXpc6kvu3V09n+TIzbqIuala1T/vjmSnVR5fih7B7Rd20xe7St7pUSVdwwmPCZ
         fi7K81DyYHCTg==
Date:   Tue, 22 Nov 2022 11:22:52 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     "Theodore Y. Ts o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
Subject: Re: [PATCH v2 2/2] fscrypt: Add SM4 XTS/CTS symmetric algorithm
 support
Message-ID: <Y30hjJq1Vwl4k1dJ@sol.localdomain>
References: <20221122070632.21910-1-tianjia.zhang@linux.alibaba.com>
 <20221122070632.21910-3-tianjia.zhang@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221122070632.21910-3-tianjia.zhang@linux.alibaba.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Nov 22, 2022 at 03:06:32PM +0800, Tianjia Zhang wrote:
> SM4 is a symmetric algorithm widely used in China, this patch enables
> to use SM4-XTS mode to encrypt file content, and use SM4-CBC-CTS to
> encrypt filename.
> 
> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

There is still no explanation here about why you believe this algorithm is
useful to support in fscrypt.

- Eric
