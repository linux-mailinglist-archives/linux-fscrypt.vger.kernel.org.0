Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9347C7CB9F4
	for <lists+linux-fscrypt@lfdr.de>; Tue, 17 Oct 2023 07:23:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233862AbjJQFXO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 17 Oct 2023 01:23:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232701AbjJQFXN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 17 Oct 2023 01:23:13 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF86EA4;
        Mon, 16 Oct 2023 22:23:12 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D8E5C433C7;
        Tue, 17 Oct 2023 05:23:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697520192;
        bh=8a9rutlwqfj5Q4pk1Kspv2LSYZQ6AbZdXsVPFocNvz4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jfhD4QD0UM4TUcFKBSg6e0WWz3CxX8rnwJZyLndz514KYAlz2SL3wQ21Wq2kAtB6r
         DoAiBcy9SHr+uqv/T22p5/V9UwLfLCrbRfXZKUYeoaQC9bFqsHEn0O8Q/ItXjAeiMk
         WYVG6Aysaihf4feN6d5sN5cqoquwZpKcjUdnXny/ZR14yFgX2KXuurZyx5GNyOIrWz
         gjubEAGbdExLN568JEUbBS3vq+XlyMmqry8czJlHh3LHRL1LV/dbeaQ+kvYfLG8Gac
         oMGhq3KxV4LRfpuJUVgtoUB5oIUlUmcn3QgjfxXPsvduFZ7yepAtjOk33kbK7SFvE7
         HY+3+a6n/qrNg==
Date:   Mon, 16 Oct 2023 22:23:10 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 12/12] fstest: add a fsstress+fscrypt test
Message-ID: <20231017052310.GF1907@sol.localdomain>
References: <cover.1696969376.git.josef@toxicpanda.com>
 <936037a6c2bcf5553145862c5358e175621983b0.1696969376.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <936037a6c2bcf5553145862c5358e175621983b0.1696969376.git.josef@toxicpanda.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 10, 2023 at 04:26:05PM -0400, Josef Bacik wrote:
> I noticed we don't run fsstress with fscrypt in any of our tests, and
> this was helpful in uncovering a couple of symlink related corner cases
> for the btrfs support work.  Add a basic test that creates a encrypted
> directory and runs fsstress in that directory.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  tests/generic/736     | 38 ++++++++++++++++++++++++++++++++++++++
>  tests/generic/736.out |  3 +++
>  2 files changed, 41 insertions(+)
>  create mode 100644 tests/generic/736
>  create mode 100644 tests/generic/736.out

This might be worth adding, but the way this sort of thing is tested on other
filesystems is through implementing the test_dummy_encryption mount option and
then doing a full run of xfstests with test_dummy_encryption enabled.  That's
more comprehensive than just running fsstress.

- Eric
