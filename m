Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 435AE7CBA34
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Oct 2023 07:37:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234361AbjJQFhk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Oct 2023 01:37:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230343AbjJQFhk (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Oct 2023 01:37:40 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BAF9E;
        Mon, 16 Oct 2023 22:37:38 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F318C433C7;
        Tue, 17 Oct 2023 05:37:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697521058;
        bh=W4J6FKP6Ta5txRq1YRpQfPMKuTyjmTXWGJCOIXaVeSA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=LfgJ4KawEKiuzLRus80aTiby52h6jHjxdBfzmZSj4f8/8slvzlvnmugWPOBxDCVVi
         MtU6+byYsTGa0g5hvuX4DESZxWRWMd+CZkYmBx1ubrJzqFF3j43Pt/hA+LgvxUw3MU
         18cgtI+974ooKxUCqKfh7kumikfgW7lehq9rwKUoWHYoCxk0QEA2n2C/RR2ZPmCehr
         bA8eNjefkc10hi1wYTlrUmkYPFgz6QiyCO4uBxAiKtr0eyb17t6CYix9SkygpGLRl7
         xp1m002li+j1ihqNMp5om+VM5z4t4ilXifO5SWDlqM9wYxdTe1mVxM1z9Qw5pnA6k0
         MCekzuDzQTvfw==
Date:   Mon, 16 Oct 2023 22:37:36 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 08/12] fstests: properly test for v1 encryption policies
 in encrypt tests
Message-ID: <20231017053736.GG1907@sol.localdomain>
References: <cover.1696969376.git.josef@toxicpanda.com>
 <c77a1a8ca09b2738f432d586177801a579a775e4.1696969376.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c77a1a8ca09b2738f432d586177801a579a775e4.1696969376.git.josef@toxicpanda.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 10, 2023 at 04:26:01PM -0400, Josef Bacik wrote:
> With btrfs adding fscrypt support we're limiting the usage to plain v2
> policies only.  This means we need to update the _require's for
> generic/593 that tests both v1 and v2 policies.  The other sort of tests
> will be split into two tests in later patches.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  common/encrypt    | 2 ++
>  tests/generic/593 | 1 +
>  2 files changed, 3 insertions(+)
> 
> diff --git a/common/encrypt b/common/encrypt
> index 1372af66..120ca612 100644
> --- a/common/encrypt
> +++ b/common/encrypt
> @@ -59,6 +59,8 @@ _require_scratch_encryption()
>  	# policy required by the test.
>  	if [ $# -ne 0 ]; then
>  		_require_encryption_policy_support $SCRATCH_MNT "$@"
> +	else
> +		_require_encryption_policy_support $SCRATCH_MNT -v 1
>  	fi

I guess this is okay for a start, but even after the test splits that this
patchset does, this will result in quite a few of the encrypt tests being
skipped on btrfs: generic/{395-399,419,429,435,440}.

I'm hoping that we can migrate most of them to support a v2-only world.  I'm not
sure what the best way to go about it would be.  I suppose one option would be
to just make copies of them and change those copies to test v2 instead of v1...
We could then consider removing or stripping down the v1 tests as appropriate.

- Eric
