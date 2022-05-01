Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 575045164B7
	for <lists+linux-fscrypt@lfdr.de>; Sun,  1 May 2022 16:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344897AbiEAObR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 1 May 2022 10:31:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230014AbiEAObQ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 1 May 2022 10:31:16 -0400
Received: from mail-qk1-x734.google.com (mail-qk1-x734.google.com [IPv6:2607:f8b0:4864:20::734])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71968201B9
        for <linux-fscrypt@vger.kernel.org>; Sun,  1 May 2022 07:27:49 -0700 (PDT)
Received: by mail-qk1-x734.google.com with SMTP id 126so8878728qkm.4
        for <linux-fscrypt@vger.kernel.org>; Sun, 01 May 2022 07:27:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20210112.gappssmtp.com; s=20210112;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=BNoEAl2+w9Pw7bv77Y1P5rN/Z5l1DZ6CZxUEP3cNtds=;
        b=333ICC4MsBCZwIzNC25Ft785tl8u8No8PeDh0hh7kxojxkB0P5/yyqSdmSoC+E99Em
         GnHnGfCxU6hBuZc3VXEdjEfN1AmtDWfJ7+D7O4Top+uKPgEUy39FNTSvkzObUpsEnKWJ
         SflTWpsPMNDLMzPoQryVIbXBYGuG+77NBhl5RPw3XPM1E+YSSnc2E6xjzTZl0vXcSurW
         CoB9XUfG9dgVe8h+r8BZ7dfm9yzXgJMUFWVCWujhnCiSYDamdr0XgkbcBJUoUJTgjH+9
         S/XDgEhcm1neCX1IIVZ/hv44HVBn9oBJOL7x51pqEZalTz/q+KsEXugeEHCU/5BwFhVE
         wnvA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=BNoEAl2+w9Pw7bv77Y1P5rN/Z5l1DZ6CZxUEP3cNtds=;
        b=SyYnuh8EHuDah1rVeblEvDnhjwuKE5SdrrHq/I+jqdCxIyKvvOrzkxryr3EIZqVY5/
         P20OajZ5W3s/jj9nVZFr5mNhkfuNremgNikHpR4r/Sqizf8waqgZmO3f4cSwY1o4RDjW
         hxxDPPUU1oTXSKLK+rK76f5KGYnZjdJ3G6jQgjnpQDX34axH/SpumqKTkNPFxcMYE/lw
         l3i4fojNrzy82kjyhRoXOoQL+ZEac4XalWp9/ub+bZ/Ni2WflyMF7PTFv/Q1LCtobCrk
         OnEF8loR595L1veky3RgHzEIZQmPp5xrlNVsfR1DLfmUThIdFaVlG5fH7VnEd+9MkC8U
         Q6lg==
X-Gm-Message-State: AOAM532lqfcAsvr/Ev2MicwzC1gNz33kVd6VslkMTf5+XWB6Tc/msz3X
        jGAgDXXITy+rae8khJKUiKwpDB5HAF+eEA==
X-Google-Smtp-Source: ABdhPJzDBhvsEi3gF0Y6wC+/wT5EL6blEewmJZKHlkwJ7HFiEUoJwszXZb6oyPQ8JureDmfJGC0/HA==
X-Received: by 2002:a05:620a:4507:b0:69f:c12f:d4d2 with SMTP id t7-20020a05620a450700b0069fc12fd4d2mr5492907qkp.172.1651415268476;
        Sun, 01 May 2022 07:27:48 -0700 (PDT)
Received: from localhost ([173.95.209.66])
        by smtp.gmail.com with ESMTPSA id h24-20020a05620a13f800b0069fc13ce210sm2722729qkl.65.2022.05.01.07.27.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 01 May 2022 07:27:48 -0700 (PDT)
Date:   Sun, 1 May 2022 10:27:47 -0400
From:   Josef Bacik <josef@toxicpanda.com>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v9 4/5] btrfs: test verity orphans with dmlogwrites
Message-ID: <Ym6Y41gSkGOr/B8m@localhost.localdomain>
References: <cover.1651012461.git.boris@bur.io>
 <dd3bcd1e7a2b112a10a1cc928448157dbc72110b.1651012461.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dd3bcd1e7a2b112a10a1cc928448157dbc72110b.1651012461.git.boris@bur.io>
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Apr 26, 2022 at 03:40:15PM -0700, Boris Burkov wrote:
> The behavior of orphans is most interesting across mounts, interrupted
> at arbitrary points during fsverity enable. To cover as many such cases
> as possible, use dmlogwrites and dmsnapshot as in
> log-writes/replay-individual.sh. At each log entry, we want to assert a
> somewhat complicated invariant:
> 
> If verity has not yet started: an orphan indicates that verity has
> started.
> If verity has started: mount should handle the orphan and blow away
> verity data: expect 0 merkle items after mounting the snapshot dev. If
> we can measure the file, verity has finished.
> If verity has finished: the orphan should be gone, so mount should not
> blow away merkle items. Expect the same number of merkle items before
> and after mounting the snapshot dev.
> 
> Note that this relies on grepping btrfs inspect-internal dump-tree.
> Until btrfs-progs has the ability to print the new Merkle items, they
> will show up as UNKNOWN.36/37.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  tests/btrfs/291     | 161 ++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/291.out |   2 +
>  2 files changed, 163 insertions(+)
>  create mode 100755 tests/btrfs/291
>  create mode 100644 tests/btrfs/291.out
> 
> diff --git a/tests/btrfs/291 b/tests/btrfs/291
> new file mode 100755
> index 00000000..1bb3f1b3
> --- /dev/null
> +++ b/tests/btrfs/291
> @@ -0,0 +1,161 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (C) 2021 Facebook, Inc. All Rights Reserved.
> +#
> +# FS QA Test 291
> +#
> +# Test btrfs consistency after each FUA while enabling verity on a file
> +# This test works by following the pattern in log-writes/replay-individual.sh:
> +# 1. run a workload (verity + sync) while logging to the log device
> +# 2. replay an entry to the replay device
> +# 3. snapshot the replay device to the snapshot device
> +# 4. run destructive tests on the snapshot device (e.g. mount with orphans)
> +# 5. goto 2
> +#
> +. ./common/preamble
> +_begin_fstest auto verity
> +
> +# Override the default cleanup function.
> +_cleanup()
> +{
> +	cd /
> +	_log_writes_cleanup &> /dev/null
> +	rm -f $img
> +	$LVM_PROG vgremove -f -y $vgname >>$seqres.full 2>&1
> +	losetup -d $loop_dev >>$seqres.full 2>&1
> +}
> +
> +# Import common functions.
> +. ./common/filter
> +. ./common/attr
> +. ./common/dmlogwrites
> +. ./common/verity
> +
> +# real QA test starts here
> +_supported_fs btrfs
> +
> +_require_scratch
> +_require_test
> +_require_log_writes
> +_require_dm_target snapshot
> +_require_command $LVM_PROG lvm
> +_require_scratch_verity
> +_require_btrfs_command inspect-internal dump-tree
> +_require_test_program "log-writes/replay-log"
> +
> +sync_loop() {
> +	i=$1
> +	[ -z "$i" ] && _fail "sync loop needs a number of iterations"
> +	while [ $i -gt 0 ]
> +	do
> +		$XFS_IO_PROG -c sync $SCRATCH_MNT
> +		let i-=1
> +	done
> +}
> +
> +dump_tree() {
> +	local dev=$1
> +	$BTRFS_UTIL_PROG inspect-internal dump-tree $dev
> +}
> +
> +count_item() {
> +	local dev=$1
> +	local item=$2
> +	dump_tree $dev | grep -c $item
> +}
> +
> +_log_writes_init $SCRATCH_DEV
> +_log_writes_mkfs
> +_log_writes_mount
> +
> +f=$SCRATCH_MNT/fsv
> +MB=$((1024 * 1024))
> +img=$TEST_DIR/$$.img
> +$XFS_IO_PROG -fc "pwrite -q 0 $((10 * $MB))" $f
> +$XFS_IO_PROG -c sync $SCRATCH_MNT
> +sync_loop 10 &
> +sync_proc=$!
> +_fsv_enable $f
> +$XFS_IO_PROG -c sync $SCRATCH_MNT
> +wait $sync_proc
> +
> +_log_writes_unmount
> +_log_writes_remove
> +
> +# the snapshot and the replay will each be the size of the log writes dev
> +# so we create a loop device of size 2 * logwrites and then split it into
> +# replay and snapshot with lvm.
> +log_writes_blocks=$(blockdev --getsz $LOGWRITES_DEV)
> +replay_bytes=$((512 * $log_writes_blocks))
> +img_bytes=$((2 * $replay_bytes))
> +
> +$XFS_IO_PROG -fc "pwrite -q -S 0 $img_bytes $MB" $img >>$seqres.full 2>&1 || \
> +	_fail "failed to create image for loop device"
> +loop_dev=$(losetup -f --show $img)

I got bit by this recently, you need

_require_loop

for this test.  Thanks,

Josef
