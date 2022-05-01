Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 31A765168A8
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 May 2022 00:34:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377823AbiEAWiU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 May 2022 18:38:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233440AbiEAWiT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 May 2022 18:38:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B099275F1;
        Sun,  1 May 2022 15:34:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 85037B80E33;
        Sun,  1 May 2022 22:34:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 13FD3C385A9;
        Sun,  1 May 2022 22:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651444487;
        bh=3zSbtcYblyqu5SolmZNKxYiAs4qYGOMfRwt5qpDXaO4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=XihuWf2/gXNu+569dOzC+mLgOA1bS1t9RlmT1Wvmux22psCrJU4+ny2hJxsbCffKO
         iQdd81vT4D1jd7ST1h1CdMzs1Pa+sCp+6vr/0gU92WSNKdS5zL4WmouAAIBJSUAOPZ
         wL2y+mM01ojiO6XY4pTdYbwrlaMFg3RUImhIXnipWQP8NL3HZGaYGeUIbxKWSpny2J
         pB0Yt+7/4HcLkInILSfflC6u73aZrgFw3YF6sfPOngQ8XjZUlx/+PNaepffs1uGSfD
         d/Bu8xmUvyo9t7ifFmDk42cE+/fD2kyGVMNZ9FH5ptwm05N5ssIZ2ZJU+o9O5uGC+a
         WfuXpY4fd6aIQ==
Date:   Sun, 1 May 2022 15:34:41 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v9 1/5] common/verity: require corruption functionality
Message-ID: <Ym8LARSMOYxJtA9n@sol.localdomain>
References: <cover.1651012461.git.boris@bur.io>
 <657cd5facdbd0b41ee99ab18ad0bba9f0d690729.1651012461.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <657cd5facdbd0b41ee99ab18ad0bba9f0d690729.1651012461.git.boris@bur.io>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Apr 26, 2022 at 03:40:12PM -0700, Boris Burkov wrote:
> Corrupting ext4 and f2fs relies on xfs_io fiemap. Btrfs corruption
> testing will rely on a btrfs specific corruption utility. Add the
> ability to require corruption functionality to make this properly
> modular. To start, just check for fiemap, as that is needed
> universally for _fsv_scratch_corrupt_bytes.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  common/verity     | 6 ++++++
>  tests/generic/574 | 1 +
>  tests/generic/576 | 1 +
>  3 files changed, 8 insertions(+)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
