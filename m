Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 662B34D9280
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Mar 2022 03:16:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344421AbiCOCRq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 14 Mar 2022 22:17:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237208AbiCOCRp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 14 Mar 2022 22:17:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E80BD3ED22;
        Mon, 14 Mar 2022 19:16:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 74C35B810DC;
        Tue, 15 Mar 2022 02:16:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06445C340E9;
        Tue, 15 Mar 2022 02:16:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647310592;
        bh=N3l5h0HSnJSFnf5tii3zND3WVlw885lYcYbglKJCG6o=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NIYvAaB01YTiL7ROHsjbljX6002DqyJqFOv/GTzHZwB97kqeZeW1n9Dkkjlx0qNGr
         Ku75EjZne9Rmt8heugBzn5s3T46GBSOUWGas4L/Exfgjr00RM1KHKm+Azu7TxlapIy
         6VBF+oq4oTE0oD0MmvXoveliAre0xSfifpefW6Bnki7OWaR103NQteJjATnitr2yXz
         noa94jCFi1IS63YFQ3IfGUcfE9f7nwTmAuKiPF8BY4Yd/TfmTlQ4E1N7cNIpnaomTg
         A3McoEZGpXFVXkQNRJstfy8XRFFeZS0sqO3MUMwmx3idkrRwzyK8D3A2TI44Lfv67c
         KR0gQ4GFPK+TA==
Date:   Tue, 15 Mar 2022 02:16:30 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v6 4/4] generic: test fs-verity EFBIG scenarios
Message-ID: <Yi/2/isOZMX3Riww@gmail.com>
References: <cover.1644883592.git.boris@bur.io>
 <f8189930d20888a7ac95b7fc2fbb0d522e8851fc.1644883592.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f8189930d20888a7ac95b7fc2fbb0d522e8851fc.1644883592.git.boris@bur.io>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Feb 14, 2022 at 04:09:58PM -0800, Boris Burkov wrote:
> diff --git a/tests/generic/690 b/tests/generic/690
> new file mode 100755
> index 00000000..77906dd8
> --- /dev/null
> +++ b/tests/generic/690
> @@ -0,0 +1,66 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Facebook, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 690
> +#
> +# fs-verity requires the filesystem to decide how it stores the Merkle tree,
> +# which can be quite large.
> +# It is convenient to treat the Merkle tree as past EOF, and ext4, f2fs, and
> +# btrfs do so in at least some fashion. This leads to an edge case where a
> +# large file can be under the file system file size limit, but trigger EFBIG
> +# on enabling fs-verity. Test enabling verity on some large files to exercise
> +# EFBIG logic for filesystems with fs-verity specific limits.
> +#
> +. ./common/preamble
> +_begin_fstest auto quick verity
> +
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/verity
> +
> +# real QA test starts here
> +_supported_fs generic
> +_require_test
> +_require_math
> +_require_scratch_verity
> +_require_fsverity_max_file_size_limit
> +_require_scratch_nocheck

Why is _require_scratch_nocheck() needed?  _require_scratch_verity() already
does _require_scratch(), and I don't see why skipping fsck would be needed.

> +# have to go back by 4096 from max to not hit the fsverity MAX_LEVELS check.
> +truncate -s $max_sz $fsv_file

The above comment should be removed.

- Eric
