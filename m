Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDDB86C1B98
	for <lists+linux-fscrypt@lfdr.de>; Mon, 20 Mar 2023 17:28:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbjCTQ2o (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 20 Mar 2023 12:28:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231732AbjCTQ21 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 20 Mar 2023 12:28:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3754E38018;
        Mon, 20 Mar 2023 09:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 118D66164F;
        Mon, 20 Mar 2023 16:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E4D3C433A0;
        Mon, 20 Mar 2023 16:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679329219;
        bh=uD7tFlYygnM0Nz8LoRx1yUEH6hOCdKID6ZBO8i8zs7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=nhAo+bxibffdU/UNSx7HZlk0+AlV2UrXEuUcKStEiGZb+Q49Ulnihyjy+ktm25zjR
         WLn335cwsaBc/PWaXrQeEnw6nNfatNfKvGibGi6/pjYG2CXQ9eiWOWgA5NN0370yom
         8N9nEhN910PMoyez/LIqX1QV5C5AmLf1NMHKTp61rAAZgh4JuzAWSgkSoXTpPWeLoa
         2OK+Uguqi82GIowRbEZFLOPWuPQuK3tAUmyglvdf8TUKqBIMN9uGSx+pL0x6QfpH5d
         WSVFnYXnyN10TZynOv98IfEcaESU364ReSQdXqTqDPReREQlgI+DkjqMLFbkIl8ms5
         5CPmjbkuuU0vw==
Date:   Mon, 20 Mar 2023 16:20:17 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH 0/3] xfstests: make fscrypt-crypt-util self-tests work
 with OpenSSL 3.0
Message-ID: <ZBiHwYDLPk5gBWec@gmail.com>
References: <20230319193847.106872-1-ebiggers@kernel.org>
 <20230320140350.w4gg32a4f2kpv62s@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230320140350.w4gg32a4f2kpv62s@zlang-mailbox>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Mar 20, 2023 at 10:03:50PM +0800, Zorro Lang wrote:
> Just one tiny review point, I'd like to keep using same comment format, especially
> in same source file. As src/fscrypt-crypt-util.c generally use "/* ... */", so
> I'll change your "//..." to "/* ... */" when I merge it, if you don't mind.

Yes that's fine.

- Eric
