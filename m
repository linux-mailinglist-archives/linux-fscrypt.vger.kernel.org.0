Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05DD857B88B
	for <lists+linux-fscrypt@lfdr.de>; Wed, 20 Jul 2022 16:30:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231760AbiGTOae (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 20 Jul 2022 10:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbiGTOad (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 20 Jul 2022 10:30:33 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE52F46DA5;
        Wed, 20 Jul 2022 07:30:30 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id D96CB811CF;
        Wed, 20 Jul 2022 10:30:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1658327430; bh=j6pSIsicmSDYHHmekm0xrii0oHIr0LiP8jaXBAoTmiI=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=uey/8sEPUCRod0x24n3hRuEawsN0hZ6771lb5tdbsYX0ap/1lJyxEBhjNyAuMf3QH
         4lsW561Uiqccx2J+zfLcXFxAVZnmG1RS0QTsiiuT/0wUkNr6tDDlNCUZt9jHh1JesY
         OvNSGLJfxnxiNj7DwG3gzmtgbDBuANhhBezheUlRzDyWZpiu2TgpJTIdT9INYjkWit
         saq0tzqNQfUg6w1Li6e3nSv4YPIjxwY7PTtTS1acM8ctQCge8QE+MuWdwwPYtJbZMM
         hjNbXZBK6CuNqqXVreeRAK41G2rO1wDzZMZGP0HMcscNigBV2HoQk6cFQ1hz48ISMW
         +XSQORv04F4+w==
Message-ID: <14f33fb7-c7f1-5463-ad4a-fe031d2a8583@dorminy.me>
Date:   Wed, 20 Jul 2022 10:30:27 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v13 4/5] btrfs: test verity orphans with dmlogwrites
Content-Language: en-US
To:     Boris Burkov <boris@bur.io>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1658277755.git.boris@bur.io>
 <57123fe31da2886cfae01e27ffc43095ef7db7d1.1658277755.git.boris@bur.io>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <57123fe31da2886cfae01e27ffc43095ef7db7d1.1658277755.git.boris@bur.io>
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

On 7/19/22 20:49, Boris Burkov wrote:
> The behavior of orphans is most interesting across mounts, interrupted
> at arbitrary points during fsverity enable. To cover as many such cases
> as possible, use dmlogwrites and dmsnapshot as in
> log-writes/replay-individual.sh. As we replay the log events, we run a
> state machine with different invariants enforced at each state.
> 
> There are three possible states for a given point in the log:
> 0. Verity has not yet started
> 1. Verity has started but not finished
> 2. Verity has finished.
> 
> The possible transitions with causes are:
> 0->1: We see an orphan item for the file.
> 1->2: Running 'fsverity measure' succeeds on the file.
> 
> Each state has its own invariant for testing:
> 0: No verity items exist.
> 1: Mount should handle the orphan and blow away verity data: expect 0
>     Merkle items after mounting.
> 2: The orphan should be gone and mount should not blow away merkle
>     items. Expect the same number of merkle items before and after
>     mounting.
> 
> As a result, we can be confident that if the file system loses power at
> any point during enabling verity on a file, the work is either completed,
> or gets rolled-back by mount.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> Reviewed-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>   tests/btrfs/291     | 168 ++++++++++++++++++++++++++++++++++++++++++++
>   tests/btrfs/291.out |   2 +
>   2 files changed, 170 insertions(+)
>   create mode 100755 tests/btrfs/291
>   create mode 100644 tests/btrfs/291.out
> 

Still looks good to me, with the fua-hunting rewrite.

It occurred to me last night that the test doesn't verify that it sees a 
disk state in state 1 -- theoretically it could go directly from state 0 
to state 2 -- but I don't see a good way to ensure the test spends time 
in state 1.
