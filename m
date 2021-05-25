Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CA1E390A6F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 25 May 2021 22:24:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233219AbhEYUZn (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 25 May 2021 16:25:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:59466 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233048AbhEYUZn (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 25 May 2021 16:25:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EA59E613CD;
        Tue, 25 May 2021 20:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621974253;
        bh=rI509idxZaXU3p0x4ACjK1JgRUuxZjhnwyX3VTewr4g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=BOWcYdtYSvlR7jsZ2AuctiKTJcvG25FFZxfCSrEc2PkA/KBrak1/g6sJ6Jhv7HTj4
         k8LHPamZ9rGgE54KxYGefQhh4aC5UdYq1eHHyI9LCXEawUonvNXkffA02YFIXPUsjn
         O6UVddaBPpIBjw3NxMy/qID/NJD9z8DtDq6OeZ+R7mLeCkpQwtQCN6PVsm+zeO2Bc6
         buvoiC/N9Tvg+NaxIRKSxyujTkrhrPtwGrHMVFRp+K9WzRHD5FNHYqxJHQHslhE+F2
         TwH0azqjJ/WsWROvr8W0tviS7PDqofh1fsb6H5fmot2nRnSP7evjNrid83NVcOb7Q4
         et1iRUBrkfWFQ==
Date:   Tue, 25 May 2021 13:24:11 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 4/4] generic: test fs-verity EFBIG scenarios
Message-ID: <YK1c62bh1WQ/h45O@sol.localdomain>
References: <cover.1620248200.git.boris@bur.io>
 <508058f805a45808764a477e9ad04353a841cf53.1620248200.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <508058f805a45808764a477e9ad04353a841cf53.1620248200.git.boris@bur.io>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 05, 2021 at 02:04:46PM -0700, Boris Burkov wrote:
> diff --git a/tests/generic/632 b/tests/generic/632
> new file mode 100755
> index 00000000..5a5ed576
> --- /dev/null
> +++ b/tests/generic/632
> @@ -0,0 +1,86 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2021 Facebook, Inc.  All Rights Reserved.
> +#
> +# FS QA Test 632
> +#
> +# Test some EFBIG scenarios with very large files.
> +# To create the files, use pwrite with an offset close to the
> +# file system's max file size.

Can you please make this comment properly describe the purpose of this test?
As-is it doesn't mention that it is related to fs-verity at all, let alone to
specific filesystems' implementations of fs-verity.

> +max_sz=$(_get_max_file_size)
> +_fsv_scratch_begin_subtest "way too big: fail on first merkle block"
> +# have to go back by 4096 from max to not hit the fsverity MAX_DEPTH check.

What is meant by the "fsverity MAX_DEPTH" check?

> +$XFS_IO_PROG -fc "pwrite -q $(($max_sz - 4096)) 1" $fsv_file
> +_fsv_enable $fsv_file |& _filter_scratch

Using the "truncate" xfs_io command instead of "pwrite" would probably make more
sense here, as the goal is to just create a file of a specific size.

> +
> +# The goal of this second test is to make a big enough file that we trip the
> +# EFBIG codepath, but not so big that we hit it immediately as soon as we try
> +# to write a Merkle leaf. Because of the layout of the Merkle tree that
> +# fs-verity uses, this is a bit complicated to compute dynamically.
> +
> +# The layout of the Merkle tree has the leaf nodes last, but writes them first.
> +# To get an interesting overflow, we need the start of L0 to be < MAX but the
> +# end of the merkle tree (EOM) to be past MAX. Ideally, the start of L0 is only
> +# just smaller than MAX, so that we don't have to write many blocks to blow up.
> +
> +# 0                        EOF round-to-64k L7L6L5 L4   L3    L2    L1  L0 MAX  EOM
> +# |-------------------------|               ||-|--|---|----|-----|------|--|!!!!!|
> +
> +# Given this structure, we can compute the size of the file that yields the
> +# desired properties:
> +# sz + 64k + sz/128^8 + sz/128^7 + ... + sz/128^2 < MAX
> +# (128^8)sz + (128^8)64k + sz + (128)sz + (128^2)sz + ... + (128^6)sz < (128^8)MAX
> +# sz(128^8 + 128^6 + 128^5 + 128^4 + 128^3 + 128^2 + 128 + 1) < (128^8)(MAX - 64k)
> +# sz < (128^8/(128^8 + (128^6 + ... 1))(MAX - 64k)
> +#
> +# Do the actual caclulation with 'bc' and 20 digits of precision.

This calculation isn't completely accurate because it doesn't round the levels
to a block boundary.  Nor does it consider that the 64K is an alignment rather
than a fixed amount added.

But for the test you don't need the absolute largest file whose level 1 doesn't
exceed the limit, but rather just one almost that large.

So it would be okay to add 64K as a fixed amount, along with 4K for every level
on top of the 'sz/128^(level+1)' you already have, to get an over-estimate of
the amount of extra space needed to cache the Merkle tree.

But please make it clear that it's an over-estimate, and hence an under-estimate
of the file size desired for the test.

Also please document that this is all assuming SHA-256 with 4K blocks, and also
that the maximum file size is assumed to fit in 64 bits; hence the consideration
of 8 levels is sufficient.

- Eric
