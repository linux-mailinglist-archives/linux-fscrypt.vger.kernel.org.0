Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7FE1040EC51
	for <lists+linux-fscrypt@lfdr.de>; Thu, 16 Sep 2021 23:18:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236611AbhIPVT6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 16 Sep 2021 17:19:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:40128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S238340AbhIPVT5 (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 16 Sep 2021 17:19:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1909160F8F;
        Thu, 16 Sep 2021 21:18:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631827116;
        bh=Aj7S6TSdOs1muBd4Yq+x62hBo15kKwVKqbt2uFFY170=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=YLdeGsC52wekfUcun+JKsAiXb8otOFWTDMbIbOeAJ24BeWvvvYUH/Q94vhpi75sv3
         NkkIOO0I6hhfcbS/SGXm9WFF1pPKCHU2FtcLmZdY8BSUFhdkNEGdA3CUAGrIb3R7I/
         ZPijnMPq+ik1oCHFJwNxsDbMWm99J8J5fheOV97nR8KDBGNSVh9ooer5HrVm37inus
         bzTZMlCtxNg0hGL/FjJHBqy6zOIb5hY3PpmiB8nmgJR5PbsD+Gk3Bnlovj4jlLaAXT
         XM2bn6P8imtIqaoApubR2lNJk2AoTL8a3oBBhz9Hw5F3jIuul7oWhe7dbtATN+SqwU
         P/32IPdtU6YpA==
Date:   Thu, 16 Sep 2021 14:18:34 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v5 4/4] generic: test fs-verity EFBIG scenarios
Message-ID: <YUO0qg3bqxsCy/iT@sol.localdomain>
References: <cover.1631558495.git.boris@bur.io>
 <b1d116cd4d0ea74b9cd86f349c672021e005a75c.1631558495.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1d116cd4d0ea74b9cd86f349c672021e005a75c.1631558495.git.boris@bur.io>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Sep 13, 2021 at 11:44:37AM -0700, Boris Burkov wrote:
> +_fsv_scratch_begin_subtest "way too big: fail on first merkle block"
> +# have to go back by 4096 from max to not hit the fsverity MAX_LEVELS check.
> +truncate -s $(($max_sz - 4095)) $fsv_file
> +_fsv_enable $fsv_file |& _filter_scratch

This is actually a kernel bug, so please don't work around it in the test :-(

It will be fixed by the kernel patch
https://lore.kernel.org/linux-fscrypt/20210916203424.113376-1-ebiggers@kernel.org

> +
> +# The goal of this second test is to make a big enough file that we trip the
> +# EFBIG codepath, but not so big that we hit it immediately as soon as we try
> +# to write a Merkle leaf. Because of the layout of the Merkle tree that
> +# fs-verity uses, this is a bit complicated to compute dynamically.
> +
> +# The layout of the Merkle tree has the leaf nodes last, but writes them first.
> +# To get an interesting overflow, we need the start of L0 to be < MAX but the
> +# end of the merkle tree (EOM) to be past MAX. Ideally, the start of L0 is only
> +# just smaller than MAX, so that we don't have to write many blocks to blow up,
> +# but we take some liberties with adding alignments rather than computing them
> +# correctly, so we under-estimate the perfectly sized file.
> +
> +# We make the following assumptions to arrive at a Merkle tree layout:
> +# The Merkle tree is stored past EOF aligned to 64k.
> +# 4K blocks and pages
> +# Merkle tree levels aligned to the block (not pictured)
> +# SHA-256 hashes (32 bytes; 128 hashes per block/page)
> +# 64 bit max file size (and thus 8 levels)
> +
> +# 0                        EOF round-to-64k L7L6L5 L4   L3    L2    L1  L0 MAX  EOM
> +# |-------------------------|               ||-|--|---|----|-----|------|--|!!!!!|
> +
> +# Given this structure, we can compute the size of the file that yields the
> +# desired properties. (NB the diagram skips the block alignment of each level)
> +# sz + 64k + sz/128^8 + 4k + sz/128^7 + 4k + ... + sz/128^2 + 4k < MAX
> +# sz + 64k + 7(4k) + sz/128^8 + sz/128^7 + ... + sz/128^2 < MAX
> +# sz + 92k + sz/128^2 < MAX
> +# (128^8)sz + (128^8)92k + sz + (128)sz + (128^2)sz + ... + (128^6)sz < (128^8)MAX
> +# sz(128^8 + 128^6 + 128^5 + 128^4 + 128^3 + 128^2 + 128 + 1) < (128^8)(MAX - 92k)
> +# sz < (128^8/(128^8 + (128^6 + ... + 128 + 1)))(MAX - 92k)
> +#
> +# Do the actual caclulation with 'bc' and 20 digits of precision.
> +# set -f prevents the * from being expanded into the files in the cwd.
> +set -f
> +calc="scale=20; ($max_sz - 94208) * ((128^8) / (1 + 128 + 128^2 + 128^3 + 128^4 + 128^5 + 128^6 + 128^8))"
> +sz=$(echo $calc | $BC -q | cut -d. -f1)
> +set +f

It's hard to follow the above explanation.  I'm still wondering whether it could
be simplified a lot.  Maybe something like the following:

# The goal of this second test is to make a big enough file that we trip the
# EFBIG codepath, but not so big that we hit it immediately when writing the
# first Merkle leaf.
#
# The Merkle tree is stored with the leaf node level (L0) last, but it is
# written first.  To get an interesting overflow, we need the maximum file size
# (MAX) to be in the middle of L0 -- ideally near the beginning of L0 so that we
# don't have to write many blocks before getting an error.
# 
# With SHA-256 and 4K blocks, there are 128 hashes per block.  Thus, ignoring
# padding, L0 is 1/128 of the file size while the other levels in total are
# 1/128**2 + 1/128**3 + 1/128**4 + ... = 1/16256 of the file size.  So still
# ignoring padding, for L0 start exactly at MAX, the file size must be s such
# that s + s/16256 = MAX, i.e. s = MAX * (16256/16257).  Then to get a file size
# where MAX occurs *near* the start of L0 rather than *at* the start, we can
# just subtract an overestimate of the padding: 64K after the file contents,
# then 4K per level, where the consideration of 8 levels is sufficient.
sz=$(echo "scale=20; $max_sz * (16256/16257) - 65536 - 4096*8" | $BC -q | cut -d. -f1)


That gives a size only 4103 bytes different from your calculation, and IMO is
much easier to understand.

- Eric
