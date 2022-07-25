Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A6647580425
	for <lists+linux-fscrypt@lfdr.de>; Mon, 25 Jul 2022 20:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231523AbiGYSln (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 25 Jul 2022 14:41:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230468AbiGYSlm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 25 Jul 2022 14:41:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E3B065F6;
        Mon, 25 Jul 2022 11:41:42 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B7DE660B08;
        Mon, 25 Jul 2022 18:41:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3189C341C6;
        Mon, 25 Jul 2022 18:41:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658774501;
        bh=lQGgDSz3+cGUuGPCfuYaCnTtlQX+yRwOAyABp+OtEKc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=JY9BWaRWzP8pPurtbLJvNDWinRzYyoVYM9Xb0wlwj1UhrA5ZWCdDg+H4crJo9dppF
         1i7QE2FTY6weObQkPp2z6n6iQbm3BOist5gJT550B9TwGmxnkwqrr84qBKuptcYUqv
         GM3B0ni1RcJNODcsk3VwSN41SSSJJlyeQ1m676SobgNWq2FsZ2LjZsNYEZF7qdxBAV
         gRs1nQya8woaA9lTnyY3KH9Vj6F6HpzCATh7Dl71Z9e27g43w6bnVQBW4ZBRrly5Nb
         0J31AHJxdloeszTeSGlHu30LZDUIFECDVTUv75qYjtFdrJlmkBSFmkuFvYqLHnIF6i
         SrLBN37+Y5ztg==
Date:   Mon, 25 Jul 2022 11:41:39 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v13 2/5] common/verity: support btrfs in generic fsverity
 tests
Message-ID: <Yt7j4511xArl+1mn@sol.localdomain>
References: <cover.1658277755.git.boris@bur.io>
 <2bbb68b90691a82b8143ba4612ea2cc761e44ecb.1658277755.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2bbb68b90691a82b8143ba4612ea2cc761e44ecb.1658277755.git.boris@bur.io>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jul 19, 2022 at 05:49:47PM -0700, Boris Burkov wrote:
> generic/572-579 have tests for fsverity. Now that btrfs supports
> fsverity, make these tests function as well. For a majority of the tests
> that pass, simply adding the case to mkfs a btrfs filesystem with no
> extra options is sufficient.
> 
> However, generic/574 has tests for corrupting the merkle tree itself.
> Since btrfs uses a different scheme from ext4 and f2fs for storing this
> data, the existing logic for corrupting it doesn't work out of the box.
> Adapt it to properly corrupt btrfs merkle items.
> 
> 576 does not run because btrfs does not support transparent encryption.
> 
> This test relies on the btrfs implementation of fsverity in the patch:
> btrfs: initial fsverity support
> 
> and on btrfs-corrupt-block for corruption in the patches titled:
> btrfs-progs: corrupt generic item data with btrfs-corrupt-block
> btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  common/btrfs          |  5 +++++
>  common/config         |  1 +
>  common/verity         | 31 +++++++++++++++++++++++++++++++
>  tests/generic/574     | 37 ++++++++++++++++++++++++++++++++++---
>  tests/generic/574.out | 13 ++++---------
>  5 files changed, 75 insertions(+), 12 deletions(-)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
