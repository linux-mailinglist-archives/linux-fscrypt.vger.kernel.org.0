Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D59A58A74C
	for <lists+linux-fscrypt@lfdr.de>; Fri,  5 Aug 2022 09:41:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237415AbiHEHlf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 5 Aug 2022 03:41:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237353AbiHEHlf (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 5 Aug 2022 03:41:35 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C50E5F6A;
        Fri,  5 Aug 2022 00:41:33 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 73310B82759;
        Fri,  5 Aug 2022 07:41:32 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A518C433C1;
        Fri,  5 Aug 2022 07:41:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659685291;
        bh=6xfzsmSwG4n6DAhQBW6+bDy9rq6JYsFlWd9Gil0J5RY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=j3Q7AaLWBaNHjPxlrLzNpEPnmHLVTNZxZAbohK1RRRhpuMlfxzES8JMnG7GzlQu8v
         dCr5xr6gtXrIPQQpyI2Pa+W9c1hwDVayE/Ed+NeguD9s3xmxd2GXh492eefvMWIs5N
         mPiYBpthZRIdBxrTfSd1D/QR0dZUg8SCuoNszh9uNPixT954uwwz+u1Nrqh8Yf/ZpX
         0QShyJL2d66NFpnf3N0j8WLNoiz1zXy/JJ+1GTiHQC4B20emHgX08tDU4Z12eq1jiu
         IUm1C6wXNgMOebydFy0u7SkCKnASRnavx+PdaqXxGd+HCJtkTuDHlq3nknFsyFIbs2
         ZkfkMKts99x7A==
Date:   Fri, 5 Aug 2022 00:41:29 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [PATCH v5 2/2] generic: add tests for fscrypt policies with HCTR2
Message-ID: <YuzJqZLP69y6A6fS@sol.localdomain>
References: <20220803224121.420705-1-nhuck@google.com>
 <20220803224121.420705-3-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220803224121.420705-3-nhuck@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Aug 03, 2022 at 03:41:21PM -0700, Nathan Huckleberry wrote:
> This patch adds fscrypt policy tests for filename encryption using
> HCTR2.
> 
> More information on HCTR2 can be found here: "Length-preserving
> encryption with HCTR2" https://ia.cr/2021/1441
> 
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>

Looks good,

Reviewed-by: Eric Biggers <ebiggers@google.com>
Tested-by: Eric Biggers <ebiggers@google.com>

- Eric
