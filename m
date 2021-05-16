Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EABF382012
	for <lists+linux-fscrypt@lfdr.de>; Sun, 16 May 2021 18:47:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231755AbhEPQsi (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 May 2021 12:48:38 -0400
Received: from out20-61.mail.aliyun.com ([115.124.20.61]:44968 "EHLO
        out20-61.mail.aliyun.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230499AbhEPQsi (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 May 2021 12:48:38 -0400
X-Alimail-AntiSpam: AC=CONTINUE;BC=0.07488514|-1;CH=green;DM=|CONTINUE|false|;DS=CONTINUE|ham_alarm|0.0430146-0.000721126-0.956264;FP=0|0|0|0|0|-1|-1|-1;HT=ay29a033018047198;MF=guan@eryu.me;NM=1;PH=DS;RN=5;RT=5;SR=0;TI=SMTPD_---.KEG3o1R_1621183641;
Received: from localhost(mailfrom:guan@eryu.me fp:SMTPD_---.KEG3o1R_1621183641)
          by smtp.aliyun-inc.com(10.147.40.233);
          Mon, 17 May 2021 00:47:21 +0800
Date:   Mon, 17 May 2021 00:47:20 +0800
From:   Eryu Guan <guan@eryu.me>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 4/4] generic: test fs-verity EFBIG scenarios
Message-ID: <YKFMmGKS2C55wgwY@desktop>
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
> btrfs, ext4, and f2fs cache the Merkle tree past EOF, which restricts
> the maximum file size beneath the normal maximum. Test the logic in
> those filesystems against files with sizes near the maximum.
> 
> To work properly, this does require some understanding of the practical
> but not standardized layout of the Merkle tree. This is a bit unpleasant
> and could make the test incorrect in the future, if the implementation
> changes. On the other hand, it feels quite useful to test this tricky
> edge case. It could perhaps be made more generic by adding some ioctls
> to let the file system communicate the maximum file size for a verity
> file or some information about the storage of the Merkle tree.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  tests/generic/632     | 86 +++++++++++++++++++++++++++++++++++++++++++
>  tests/generic/632.out |  7 ++++
>  tests/generic/group   |  1 +
>  3 files changed, 94 insertions(+)
>  create mode 100755 tests/generic/632
>  create mode 100644 tests/generic/632.out
> 
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
> +#
> +seq=`basename $0`
> +seqres=$RESULT_DIR/$seq
> +echo "QA output created by $seq"
> +
> +here=`pwd`
> +tmp=/tmp/$$
> +status=1	# failure is the default!
> +trap "_cleanup; exit \$status" 0 1 2 3 15
> +
> +_cleanup()
> +{
> +	cd /
> +	rm -f $tmp.*
> +}
> +
> +# get standard environment, filters and checks
> +. ./common/rc
> +. ./common/filter
> +. ./common/verity
> +
> +# remove previous $seqres.full before test
> +rm -f $seqres.full
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs btrfs ext4 f2fs

A generic test should '_supported_fs generic', and use proper _require
rules to filter unsupported filesystems.

> +_require_test
> +_require_math
> +_require_scratch_verity
> +
> +_scratch_mkfs_verity &>> $seqres.full
> +_scratch_mount
> +
> +fsv_file=$SCRATCH_MNT/file.fsv
> +
> +max_sz=$(_get_max_file_size)
> +_fsv_scratch_begin_subtest "way too big: fail on first merkle block"
> +# have to go back by 4096 from max to not hit the fsverity MAX_DEPTH check.
> +$XFS_IO_PROG -fc "pwrite -q $(($max_sz - 4096)) 1" $fsv_file
> +_fsv_enable $fsv_file |& _filter_scratch
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
> +set -f
> +calc="scale=20; ($max_sz - 65536) * ((128^8) / (1 + 128 + 128^2 + 128^3 + 128^4 + 128^5 + 128^6 + 128^8))"
> +sz=$(echo $calc | $BC -q | cut -d. -f1)
> +set +f

Now sure why set -f is needed here, add some comments about it as well?

Thanks,
Eryu

> +
> +
> +_fsv_scratch_begin_subtest "still too big: fail on first invalid merkle block"
> +$XFS_IO_PROG -fc "pwrite -q $sz 1" $fsv_file
> +_fsv_enable $fsv_file |& _filter_scratch
> +
> +# success, all done
> +status=0
> +exit
> diff --git a/tests/generic/632.out b/tests/generic/632.out
> new file mode 100644
> index 00000000..59602c24
> --- /dev/null
> +++ b/tests/generic/632.out
> @@ -0,0 +1,7 @@
> +QA output created by 632
> +
> +# way too big: fail on first merkle block
> +ERROR: FS_IOC_ENABLE_VERITY failed on 'SCRATCH_MNT/file.fsv': File too large
> +
> +# still too big: fail on first invalid merkle block
> +ERROR: FS_IOC_ENABLE_VERITY failed on 'SCRATCH_MNT/file.fsv': File too large
> diff --git a/tests/generic/group b/tests/generic/group
> index ab00cc04..76d46e86 100644
> --- a/tests/generic/group
> +++ b/tests/generic/group
> @@ -634,3 +634,4 @@
>  629 auto quick rw copy_range
>  630 auto quick rw dedupe clone
>  631 auto rw overlay rename
> +632 auto quick verity
> -- 
> 2.30.2
