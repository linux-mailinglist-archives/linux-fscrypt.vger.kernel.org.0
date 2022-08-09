Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E309A58DFD1
	for <lists+linux-fscrypt@lfdr.de>; Tue,  9 Aug 2022 21:09:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345390AbiHITHl (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 9 Aug 2022 15:07:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38692 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347399AbiHITG2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 9 Aug 2022 15:06:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 065FF1CB1D;
        Tue,  9 Aug 2022 11:48:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98B38B816EC;
        Tue,  9 Aug 2022 18:48:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BCE4EC433D6;
        Tue,  9 Aug 2022 18:48:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660070905;
        bh=KDjLZfZKk5p+iqbsWFja1ZBsHYDrWv9/93Yvy/BtmLQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fW4BZ8iImzfjx7wrCMoWFf7OamP4/gbTphsAJb5FJly3pD6kNVUf0cLIYR3SZRw9s
         l6IlBLkn+/4rC1dvqINn3zSXz7Kn0DHjejkLFCBSl6h9J9TdZBk88IlEFFHPGSYAit
         8QQEBoq162vmqVvXQXTuljv7QKAyVF/hRgawYU9dJVf0Jq27k7Qk/qTcGfWe3ZuT9q
         6NYdTZasrBbPrEZ4HQAG/e913bbHcUAQbz6ihsj9XRGjCRwGWCidsKi/L8GJucYrHN
         Bl06xy1Pnxc+j27X7yw6QfCK4KcqGDO9ji9w6fa1wOu4Xhjy1XZZh6uKI1WT7Kc9g0
         Ulwdd2+ftt9pg==
Date:   Tue, 9 Aug 2022 18:48:23 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v6 0/2] generic: test HCTR2 filename encryption
Message-ID: <YvKr97mYRUF5m4h8@gmail.com>
References: <20220809184037.636578-1-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220809184037.636578-1-nhuck@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 09, 2022 at 11:40:35AM -0700, Nathan Huckleberry wrote:
> HCTR2 is a new wide-block encryption mode that can used for filename encryption
> in fscrypt.  This patchset adds a reference implementation of HCTR2 to the
> fscrypt testing utility and adds tests for filename encryption with HCTR2.
> 
> More information on HCTR2 can be found here: "Length-preserving encryption with
> HCTR2": https://ia.cr/2021/1441
> 
> The patchset introducing HCTR2 to the kernel can be found here:
> https://lore.kernel.org/linux-crypto/20220520181501.2159644-1-nhuck@google.com/

Thanks Huck.  Zorro already applied v5 to the for-next branch, with the
chunk_size variable removed (which is the only code you changed in v6), and with
generic/900 renamed to its final name of generic/693.  See
https://lore.kernel.org/fstests/20220807155112.E0989C433D6@smtp.kernel.org/T/#u

So I think everything is good to go already.

- Eric
