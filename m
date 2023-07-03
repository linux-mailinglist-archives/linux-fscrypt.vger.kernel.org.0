Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D3019746133
	for <lists+linux-fscrypt@lfdr.de>; Mon,  3 Jul 2023 19:13:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230037AbjGCRN2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 3 Jul 2023 13:13:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229804AbjGCRN1 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 3 Jul 2023 13:13:27 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FF55B2;
        Mon,  3 Jul 2023 10:13:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A975060FE9;
        Mon,  3 Jul 2023 17:13:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16B5EC433CD;
        Mon,  3 Jul 2023 17:13:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1688404405;
        bh=IIWEycHmAGwur8gE2BWQqjWuVqDrIpZbsg6767sTTOU=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=o5PNCEracJf6h70UQ4Ko1v1bVaj350QBqijSzTifzWd+drzOA4TMGapvYxcxFh4UI
         csdK4kpXv+prQENqVC942oUiCJbYhGcfNMsa6zb6lccHjVkNPYTyt6eFalNbHbM1IO
         SasFakniWlN8YdY7Dj4kGnE4KtgYh+O/riuv1+GHNG90oTErKSQRnS16SUuGZ44YAH
         2C0BKhVPAK5GDKzOmx9M7BlWtmYvnu3otNAauyqD5UPFGsCb7DSMfC5iNg/H+1swz4
         nvgueD16Z2Uh1pO4f6EwepnqY8SsbbloR7vJR9xy2veMD93AwBt3XAxELXZ2tSxbDl
         RPfzS1nyI6N0A==
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-1b00b0ab0daso4210902fac.0;
        Mon, 03 Jul 2023 10:13:25 -0700 (PDT)
X-Gm-Message-State: AC+VfDxViMmpJUdrg1OK1ZMZ7EQ/NMvL8LKOdZOOyoWCYCrjoHeiFU6E
        AfRuVyuZ4PKQ30sIrfNNxIipT1tsldocSWmYNJM=
X-Google-Smtp-Source: APBJJlHtTz2oI6ap4OzfR6Bnh8VdUAq3RK4Gf41ZXbOjhDeSIVwA4bbzvAJqZ/IrWv1EYnRrN7CrmvRfXmQgwG/N/SI=
X-Received: by 2002:a05:6870:e0cb:b0:1b0:c99:fd1e with SMTP id
 a11-20020a056870e0cb00b001b00c99fd1emr9539293oab.4.1688404404152; Mon, 03 Jul
 2023 10:13:24 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1688076612.git.sweettea-kernel@dorminy.me> <dbf938dfa6828b9307759c89a48237b16dbcb5a3.1688076612.git.sweettea-kernel@dorminy.me>
In-Reply-To: <dbf938dfa6828b9307759c89a48237b16dbcb5a3.1688076612.git.sweettea-kernel@dorminy.me>
From:   Filipe Manana <fdmanana@kernel.org>
Date:   Mon, 3 Jul 2023 18:12:48 +0100
X-Gmail-Original-Message-ID: <CAL3q7H6TM-0a6aaJz6SNdU5Ke28Fk-TMeS1zS47H=KSNGfxkXQ@mail.gmail.com>
Message-ID: <CAL3q7H6TM-0a6aaJz6SNdU5Ke28Fk-TMeS1zS47H=KSNGfxkXQ@mail.gmail.com>
Subject: Re: [RFC PATCH 8/8] btrfs: add simple test of reflink of encrypted data
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@meta.com, ebiggers@google.com, anand.jain@oracle.com,
        linux-fscrypt@vger.kernel.org, fsverity@lists.linux.dev,
        zlang@kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Jun 29, 2023 at 11:26=E2=80=AFPM Sweet Tea Dorminy
<sweettea-kernel@dorminy.me> wrote:
>
> Make sure that we succeed at reflinking encrypted data.
>
> Test deliberately numbered with a high number so it won't conflict with
> tests between now and merge.
> ---
>  tests/btrfs/613     | 62 +++++++++++++++++++++++++++++++++++++++++++++
>  tests/btrfs/613.out | 13 ++++++++++
>  2 files changed, 75 insertions(+)
>  create mode 100755 tests/btrfs/613
>  create mode 100644 tests/btrfs/613.out
>
> diff --git a/tests/btrfs/613 b/tests/btrfs/613
> new file mode 100755
> index 00000000..93c209c4
> --- /dev/null
> +++ b/tests/btrfs/613
> @@ -0,0 +1,62 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2023 YOUR NAME HERE.  All Rights Reserved.

Don't forget to fill this...

> +#
> +# FS QA Test 613
> +#
> +# Check if reflinking one encrypted file on btrfs succeeds.
> +#
> +. ./common/preamble
> +_begin_fstest auto encrypt
> +
> +# Import common functions.
> +. ./common/encrypt
> +. ./common/filter
> +. ./common/reflink
> +
> +# real QA test starts here
> +
> +# Modify as appropriate.
> +_supported_fs btrfs
> +
> +_require_test
> +_require_scratch
> +_require_cp_reflink
> +_require_scratch_encryption -v 2
> +_require_command "$KEYCTL_PROG" keyctl
> +
> +_scratch_mkfs_encrypted &>> $seqres.full
> +_scratch_mount
> +
> +dir=3D$SCRATCH_MNT/dir
> +mkdir $dir
> +_set_encpolicy $dir $TEST_KEY_IDENTIFIER
> +_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
> +echo "Creating and reflinking a file"
> +$XFS_IO_PROG -t -f -c "pwrite 0 33k" $dir/test > /dev/null

Why the -t (truncate)? We are creating the file on a brand new fs.

> +sync

What's this sync for? The reflink code flushes delalloc (for both
source and destination inodes, always).
Is this really necessary? If so please add a comment explaining why
it's needed, otherwise remove it.

> +cp --reflink=3Dalways $dir/test $dir/test2
> +sync

Same here. What is this sync for?
Please add a comment explaining why it's needed, otherwise remove it.

Thanks.

> +
> +echo "Can't reflink encrypted and unencrypted"
> +cp --reflink=3Dalways $dir/test $SCRATCH_MNT/fail |& _filter_scratch
> +
> +echo "Diffing the file and its copy"
> +diff $dir/test $dir/test2
> +
> +echo "Verifying the files are reflinked"
> +_verify_reflink $dir/test $dir/test2
> +
> +echo "Diffing the files after remount"
> +_scratch_cycle_mount
> +_add_enckey $SCRATCH_MNT "$TEST_RAW_KEY"
> +diff $dir/test $dir/test2
> +
> +echo "Diffing the files after key remove"
> +echo 2 > /proc/sys/vm/drop_caches
> +_rm_enckey $SCRATCH_MNT $TEST_KEY_IDENTIFIER
> +diff $dir/test $dir/test2 |& _filter_scratch
> +
> +# success, all done
> +status=3D0
> +exit
> diff --git a/tests/btrfs/613.out b/tests/btrfs/613.out
> new file mode 100644
> index 00000000..4895d6dd
> --- /dev/null
> +++ b/tests/btrfs/613.out
> @@ -0,0 +1,13 @@
> +QA output created by 613
> +Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
> +Creating and reflinking a file
> +Can't reflink encrypted and unencrypted
> +cp: failed to clone 'SCRATCH_MNT/fail' from 'SCRATCH_MNT/dir/test': Inva=
lid argument
> +Diffing the file and its copy
> +Verifying the files are reflinked
> +Diffing the files after remount
> +Added encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
> +Diffing the files after key remove
> +Removed encryption key with identifier 69b2f6edeee720cce0577937eb8a6751
> +diff: SCRATCH_MNT/dir/test: No such file or directory
> +diff: SCRATCH_MNT/dir/test2: No such file or directory
> --
> 2.40.1
>
