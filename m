Return-Path: <linux-fscrypt+bounces-36-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id AF6637FA3FC
	for <lists+linux-fscrypt@lfdr.de>; Mon, 27 Nov 2023 16:03:25 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 60CAA28168A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 27 Nov 2023 15:03:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 445073175C;
	Mon, 27 Nov 2023 15:03:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=toxicpanda-com.20230601.gappssmtp.com header.i=@toxicpanda-com.20230601.gappssmtp.com header.b="da/jJ56H"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from mail-yw1-x1130.google.com (mail-yw1-x1130.google.com [IPv6:2607:f8b0:4864:20::1130])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CDE1F5
	for <linux-fscrypt@vger.kernel.org>; Mon, 27 Nov 2023 07:03:13 -0800 (PST)
Received: by mail-yw1-x1130.google.com with SMTP id 00721157ae682-5b383b4184fso43738827b3.1
        for <linux-fscrypt@vger.kernel.org>; Mon, 27 Nov 2023 07:03:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=toxicpanda-com.20230601.gappssmtp.com; s=20230601; t=1701097392; x=1701702192; darn=vger.kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date:from:to
         :cc:subject:date:message-id:reply-to;
        bh=vXVBwOB9nLusSs7mzP0iFdl0aR0JW9Fm9CGT0DKW2Tg=;
        b=da/jJ56HrwTLyeReKx1nikTYOTGxFSm4s0Z6T4yf3RNc2Twg0UghAOn0JP8FyVNq4f
         mlinlP35AyIzck446UPazZSYnUBXIqbcN1lG+XktVcJwpFQZEt6rWmcnZdNy2M/U9SCz
         qzxlrE8qenCs1XyWv4INUF6ME6SJKKxlNxoWfQEqjEAaWHcVOEjddENRtECR/Ezp8tKq
         K0vh9G7/HHCPoJeuTOOwT54Wb1x/EpGv9ZoCUEdcv7ywl2We3ZzPzvGyhDLIm+PArRwF
         x+e+xlup7OGxU8viRCu/EYpXT8nNWLhDnsHjtQbWG1SRoZl+Z7wzqt/j73XQlT/uXH/r
         nvVg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1701097392; x=1701702192;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :mime-version:references:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vXVBwOB9nLusSs7mzP0iFdl0aR0JW9Fm9CGT0DKW2Tg=;
        b=cS/DV/zxp9zZxZdXgzoVbQZK91fGz2HMyasHrtGtqK/mECnnzgCJH3oPuRko5Hwmex
         Sh/zLBf+1VP8idSthx3S37q03GjvZFmW2a1yHivP/FuqXCMBZq+EygMJxIL6Dxda1fl9
         axc+xrf32/tjQtSvMvwmLI56jsDaD2xXADrHzU3jqyMcb+UvFu216+pPiUyJ/hiDLuj/
         5zI686hqxT868FxorBvZqq3RcFfNEvrZsK46kO2T9j0HxB3Y6fjED0XJ8RGFlajQatsG
         sadUOsXt6bmi+0uHn+/v4QwUBIFI30zs7BvJgoKMzImJ9S0+c/lqhPZZrVhctszgEJlw
         7RPg==
X-Gm-Message-State: AOJu0Yxo1508FkZqwyi7NndBu9kL5LPdzF+4BxggLJGdzWHMljmEj+yC
	c8Gl7Sn6VKrkUebJeXmEPAPimw==
X-Google-Smtp-Source: AGHT+IHz6c6wyrNd3+Y7MUq6OS2h0DIgz7ENzcvGpb/ZaYW309HyOR4TWcaO3oklQA43sRVfbjLSlg==
X-Received: by 2002:a0d:c843:0:b0:5ca:e7e5:e4f9 with SMTP id k64-20020a0dc843000000b005cae7e5e4f9mr12538649ywd.36.1701097391977;
        Mon, 27 Nov 2023 07:03:11 -0800 (PST)
Received: from localhost (076-182-020-124.res.spectrum.com. [76.182.20.124])
        by smtp.gmail.com with ESMTPSA id b64-20020a0df243000000b00598d67585d7sm3347051ywf.117.2023.11.27.07.03.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Nov 2023 07:03:11 -0800 (PST)
Date: Mon, 27 Nov 2023 10:03:10 -0500
From: Josef Bacik <josef@toxicpanda.com>
To: Anand Jain <anand.jain@oracle.com>
Cc: fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
	linux-btrfs@vger.kernel.org,
	Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
	Filipe Manana <fdmanana@kernel.org>
Subject: Re: [PATCH 07/12] btrfs: test snapshotting encrypted subvol
Message-ID: <20231127150310.GA2366036@perftesting>
References: <cover.1696969376.git.josef@toxicpanda.com>
 <9a17afb133849c2321bb98c07c48cff2aaf1d87a.1696969376.git.josef@toxicpanda.com>
 <CAL3q7H5eg0Xs+-JYnHnh11ogUB=GSaCGT_C0a4QFVnj_--oFng@mail.gmail.com>
 <4507f07c-f101-e223-a804-7d0d69b07b76@oracle.com>
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <4507f07c-f101-e223-a804-7d0d69b07b76@oracle.com>

On Mon, Nov 27, 2023 at 10:16:28PM +0800, Anand Jain wrote:
> 
> 
> On 31/10/2023 23:39, Filipe Manana wrote:
> > On Tue, Oct 10, 2023 at 9:26 PM Josef Bacik <josef@toxicpanda.com> wrote:
> > > 
> > > From: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> > > 
> > > Make sure that snapshots of encrypted data are readable and writeable.
> > > 
> > > Test deliberately high-numbered to not conflict.
> > > 
> > > Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> > > ---
> > >   tests/btrfs/614     |  76 ++++++++++++++++++++++++++++++
> > >   tests/btrfs/614.out | 111 ++++++++++++++++++++++++++++++++++++++++++++
> > >   2 files changed, 187 insertions(+)
> > >   create mode 100755 tests/btrfs/614
> > >   create mode 100644 tests/btrfs/614.out
> > > 
> > > diff --git a/tests/btrfs/614 b/tests/btrfs/614
> > > new file mode 100755
> > > index 00000000..87dd27f9
> > > --- /dev/null
> > > +++ b/tests/btrfs/614
> > > @@ -0,0 +1,76 @@
> > > +#! /bin/bash
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +# Copyright (c) 2023 Meta Platforms, Inc.  All Rights Reserved.
> > > +#
> > > +# FS QA Test 614
> > > +#
> > > +# Try taking a snapshot of an encrypted subvolume. Make sure the snapshot is
> > > +# still readable. Rewrite part of the subvol with the same data; make sure it's
> > > +# still readable.
> > > +#
> > > +. ./common/preamble
> > > +_begin_fstest auto encrypt
> > 
> > Should be in the 'snapshot' and 'subvol' groups too, as it creates a
> > snapshot and a subvolume.
> > Also maybe in the 'quick' group too, see the comments further below.
> > 
> > > +
> > > +# Import common functions.
> > > +. ./common/encrypt
> > > +. ./common/filter
> > > +
> > > +# real QA test starts here
> > > +_supported_fs btrfs
> > > +
> > > +_require_test
> > 
> > The test device is not used, so this can go away.
> > 
> > > +_require_scratch
> > > +_require_scratch_encryption -v 2
> > > +_require_command "$KEYCTL_PROG" keyctl
> > > +
> > > +_scratch_mkfs_encrypted &>> $seqres.full
> > > +_scratch_mount
> > > +
> > > +udir=$SCRATCH_MNT/reference
> > > +dir=$SCRATCH_MNT/subvol
> > > +dir2=$SCRATCH_MNT/subvol2
> > > +$BTRFS_UTIL_PROG subvolume create $dir >> $seqres.full
> > > +mkdir $udir
> > > +
> > > +_set_encpolicy $dir $TEST_KEY_IDENTIFIER
> > > +_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
> > > +
> > > +# get files with lots of extents by using backwards writes.
> > > +for j in `seq 0 50`; do
> > > +       for i in `seq 20 -1 1`; do
> > > +               $XFS_IO_PROG -f -d -c "pwrite $(($i * 4096)) 4096" \
> > > +               $dir/foo-$j >> $seqres.full | _filter_xfs_io
> > > +               $XFS_IO_PROG -f -d -c "pwrite $(($i * 4096)) 4096" \
> > > +               $udir/foo-$j >> $seqres.full | _filter_xfs_io
> > > +       done
> > > +done
> > > +
> > > +$BTRFS_UTIL_PROG subvolume snapshot $dir $dir2 | _filter_scratch
> > > +
> > > +_scratch_remount
> > > +_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
> > > +sleep 30
> > 
> > What's the sleep for?
> > Is the 30 seconds to wait for a transaction commit?
> > If it is then I'd rather mount the fs with -o commit=3 (or some other
> > low value) and then "sleep 3" to make the test run much faster.
> > A comment explaining why the sleep is there, what is its purpose,
> > should also be in place.
> > 
> > > +echo "Diffing $dir and $dir2"
> > > +diff $dir $dir2
> > > +
> > > +echo "Rewriting $dir2 partly"
> > > +# rewrite half of each file in the snapshot
> > > +for j in `seq 0 50`; do
> > > +       for i in `seq 10 -1 1`; do
> > > +               $XFS_IO_PROG -f -d -c "pwrite $(($i * 4096)) 4096" \
> > > +               $dir2/foo-$j >> $seqres.full | _filter_xfs_io
> > > +       done
> > > +done
> > > +
> > > +echo "Diffing $dir and $dir2"
> > > +diff $dir $dir2
> > > +
> > > +echo "Dropping key and diffing"
> > > +_rm_enckey $SCRATCH_MNT $TEST_KEY_IDENTIFIER
> > > +diff $dir $dir2 |& _filter_scratch | _filter_nokey_filenames
> > > +
> > > +$BTRFS_UTIL_PROG subvolume delete $dir > /dev/null 2>&1
> > 
> > What's the purpose of this subvolume delete?
> > It's ignoring stdout and stderr, so it doesn't care whether it
> > succeeds or fails, and we
> > don't do any tests/checks after it.
> > 
> > Thanks.
> 
> 
> Josef, I'm planning to get this patchset ready for the PR. Are you planning
> to address the review comments as mentioned above? These
> aren't bugs, but they definitely add more clarity and adds to the
> missing groups.
> 

Can you hold off Anand?  I haven't responded because I've been working on this
series and making appropriate changes to my local branch, I'll send a refreshed
version of the patches when I send the next set of the fscrypt enablement
patches.  I've got all the comments addressed locally, it'll save you some work.
Thanks,

Josef

