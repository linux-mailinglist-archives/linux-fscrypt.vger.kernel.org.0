Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7807757A839
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 Jul 2022 22:32:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238010AbiGSUcf (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 Jul 2022 16:32:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233670AbiGSUce (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 Jul 2022 16:32:34 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 745114506B;
        Tue, 19 Jul 2022 13:32:33 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id E1F898041F;
        Tue, 19 Jul 2022 16:32:31 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1658262753; bh=qRzCCAkp1r3p2i4KTMW27LIkWIe9akCQ2qGjKlvDh/4=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=cfwIGkpuwVaPWPDMsGroC8o4neAg9VWDtR9yxgseEFiS4pkEIfyqk1IRkw3Q5SKL8
         ci/3l849/bk2MDpjacH7yRUQDi1q9fP3wcEZORQEwDOE+uzHebif7SmRsDL+2PLcRp
         bGead6AgdzRJT6sCcvQEJIsWbj28eRLvDLifSfhSRs0a1lWs0a7s85q2KxJxsk45go
         MyK1yzlFWeFnLVegkgijDeuZ2ZW+NXsXcQ6tnE0NNYHPlnl/DccwzkGiQfOJ55MBYS
         LApLnp9865vZ26VZvrZTNwio1nN++ZmqpNt0OUJQjfQgpSmjJCuLXVcp1X/8hkS+xP
         ptexk/VOMbPCw==
Message-ID: <63de9e8e-733f-8650-a8f1-5eec0f881175@dorminy.me>
Date:   Tue, 19 Jul 2022 16:32:30 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v12 0/5] tests for btrfs fsverity
Content-Language: en-US
To:     Boris Burkov <boris@bur.io>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1658188603.git.boris@bur.io>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <cover.1658188603.git.boris@bur.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 7/18/22 19:58, Boris Burkov wrote:
> This patchset provides tests for fsverity support in btrfs.
> 
> It includes modifications for generic tests to pass with btrfs as well
> as new tests.
> 
> --
> v12:
> - Actually incorporate Sweet Tea's significant improvement to the commit
>    message for the log-writes test.
> v11:
> - remove unneeded common/btrfs sourcing from common/verity
> - fix btrfs/290 prealloc test in case the disk extent actually
>    had zeros.
> - make logic a little more consistent in btrfs/291
> - make btrfs/291 work regardless of how btrfs-progs prints the Merkle
>    items.
> v10:
> - rebase
> - add nodatasum instead of setting it
> - rewrite eof block test to read zap_len at eof and to compare with a
>    zero file instead of using xxd
> - add _require_loop to the log_writes test
> 
> v9:
> - use nodatasum for btrfs corruption tests.
> - modify eof block corruption test to allow all zeroes rather than
>    requiring an error.
> v8:
> - reorganize to have a patch for enabling generic tests followed by the
>    patches with new and specific tests.
> - fix some rebasing miscues from v7.
> - fix a chunk of space characters instead of a tab in the new requires
>    function.
> v7:
> - add a new patch to make the new corruption requires more clear
> - require corruption in generic/576
> - require only btrfs_corrupt_block in btrfs/290
> - add missing xfs_io requirements in btrfs/290
> - remove unneeded zero byte check from btrfs corruption function
> - fix sloppy extras in generic/690
> v6:
> - refactor "requires" for verity corruption tests so that other verity
>    tests can run on btrfs even without the corruption command available.
>    Also, explictly require xfs_io fiemap for all corruption tests.
> - simplify and clarify "non-trivial EFBIG" calculation and documentation
>    per suggestions by Eric Biggers.
> - remove unnecessary adjustment to max file size in the new EFBIG test;
>    the bug it worked around has been fixed.
> v5:
> - more idiomatic requires structure for making efbig test generic
> - make efbig test use truncate instead of pwrite for making a big file
> - improve documentation for efbig test approximation
> - fix underscores vs dashes in btrfs_requires_corrupt_block
> - improvements in missing/redundant requires invocations
> - move orphan test image file to $TEST_DIR
> - make orphan test replay/snapshot device size depend on log device
>    instead of hard-coding it.
> - rebase (signicant: no more "groups" file; use preamble)
> v4:
> - mark local variables
> - get rid of redundant mounts and syncs
> - use '_' in function names correctly
> - add a test for the EFBIG case
> - reduce usage of requires_btrfs_corrupt_block
> - handle variable input when corrupting merkle tree
> v3: rebase onto xfstests master branch
> v2: pass generic tests, add logwrites test
> 
> 
> Boris Burkov (5):
>    common/verity: require corruption functionality
>    common/verity: support btrfs in generic fsverity tests
>    btrfs: test btrfs specific fsverity corruption
>    btrfs: test verity orphans with dmlogwrites
>    generic: test fs-verity EFBIG scenarios
> 
>   common/btrfs          |   5 ++
>   common/config         |   1 +
>   common/verity         |  48 ++++++++++++
>   tests/btrfs/290       | 172 ++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/290.out   |  25 ++++++
>   tests/btrfs/291       | 167 ++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/291.out   |   2 +
>   tests/generic/574     |  38 +++++++++-
>   tests/generic/574.out |  13 +---
>   tests/generic/576     |   1 +
>   tests/generic/692     |  64 ++++++++++++++++
>   tests/generic/692.out |   7 ++
>   12 files changed, 531 insertions(+), 12 deletions(-)
>   create mode 100755 tests/btrfs/290
>   create mode 100644 tests/btrfs/290.out
>   create mode 100755 tests/btrfs/291
>   create mode 100644 tests/btrfs/291.out
>   create mode 100644 tests/generic/692
>   create mode 100644 tests/generic/692.out
> 

For the series, for my part,
Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
