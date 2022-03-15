Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B8D934DA506
	for <lists+linux-fscrypt@lfdr.de>; Tue, 15 Mar 2022 23:06:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352144AbiCOWHv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 15 Mar 2022 18:07:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344194AbiCOWHs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 15 Mar 2022 18:07:48 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73130443FB;
        Tue, 15 Mar 2022 15:06:35 -0700 (PDT)
Received: from compute3.internal (compute3.nyi.internal [10.202.2.43])
        by mailout.nyi.internal (Postfix) with ESMTP id D83435C011B;
        Tue, 15 Mar 2022 18:06:34 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute3.internal (MEProxy); Tue, 15 Mar 2022 18:06:34 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; bh=kwP+Ne/UqsGXkqSu7O6W+6U8g+GJLANUtZZP4p
        x2F7Q=; b=Fdv4OezjF0230mYFRRO5AQ0zHD4F0/REu/CRzQedCtKHBOzN8sU+BS
        uTSmwCIvHXjpdk2t38CXKfEnutdn9pIyFWDKcik6r7yNn5MgbYVOjw/pDoosj6v4
        uS7N1F/1mjgsei1bv2jf+/kLqAOhsJFHaI6FpuyTy5q2NuwYw4FGWxn1D0scZ5ch
        VTj0NDZdoJFso8Q2ccMNZOHkoNT9twKW2GEZ4+JviDInV0aUatmbJIHL/xRXPcfn
        /W3Ni+JQ0R79vokzWbwKSHy2WQxLG6upT5q7Fkqt1mmVzOzhRty+R4dJQSTdxdZC
        hQdvahCuWbSci8lMlnnbTkRCzKmy+SyQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=kwP+Ne/UqsGXkqSu7
        O6W+6U8g+GJLANUtZZP4px2F7Q=; b=ESANhYI20UKSVcS0hrVThHFiIrC3O8Wfq
        a9ZNQSPLFCs0iDO23+fQ0MPFegBYkFZBdespBizxRjsmMZAsDpkpWduf3jo9Op0A
        0c0Pd/G6rUe6wAI2EzvMxL1cQujDP+jAw9sl2O14RqS1jUqB5VgVaU+dDJajinZY
        LA7dypMF4FKiQUETIYQxepKMeFdodi40oglxNELePXCSzrMVRe2YB40dbs9ESsF+
        75oWnQmedMCHRK5uyhxqMgs+HINvUuN//ZQQQsI9V4ChwcjndHwU3QEJ7MJuH8JV
        HfQLMyMHRCE7PKG8MkUCMN1RDA8b82byL+7zB5HuahblMGR3uVYKg==
X-ME-Sender: <xms:6g0xYu-xaZqEujZsRrQMHSZ4Ky_hqn37y0XL5O3sjtwqeLU2_OMKtw>
    <xme:6g0xYuuYJ0fT_z4vn_wvnlarl9cZacH8e1B1at4rUvXPjMYAlGsRDpCSCZ06IlnML
    0-6v_BiYk5PNKCsd5s>
X-ME-Received: <xmr:6g0xYkCWQ5lqJHoTz8P4U_7oNQukeZlHia61Vu6_zAzrDhpqrwCJQH7UIQFuFxatUceNaB3AZJUhbdSFVqRJ6NIzZOo1Kw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrudeftddgudehiecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepuehorhhi
    shcuuehurhhkohhvuceosghorhhishessghurhdrihhoqeenucggtffrrghtthgvrhhnpe
    ehudevleekieetleevieeuhfduhedtiefgheekfeefgeelvdeuveeggfduueevfeenucev
    lhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhsse
    gsuhhrrdhioh
X-ME-Proxy: <xmx:6g0xYmflp0KKrZC_CyqVF5D6p-X98ve_IkO0iL-_rRp6UuWzqgqiXw>
    <xmx:6g0xYjP7zkJG1wX2GJc5AZGFGjg-N3F91JJvXZ1stfXqBE6vISmfFg>
    <xmx:6g0xYglju7W2KXP7VVMNiGXN3KYtoAHq9a33_bV3_6IsgWGyHjLp-Q>
    <xmx:6g0xYsrAn5xq5ryMr2ro482NFbn0_BLthlOmNgB-zREqdwB2ZacaKw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 15 Mar 2022 18:06:34 -0400 (EDT)
Date:   Tue, 15 Mar 2022 15:06:32 -0700
From:   Boris Burkov <boris@bur.io>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v6 4/4] generic: test fs-verity EFBIG scenarios
Message-ID: <YjEN6AzzisfT9j7u@zen>
References: <cover.1644883592.git.boris@bur.io>
 <f8189930d20888a7ac95b7fc2fbb0d522e8851fc.1644883592.git.boris@bur.io>
 <Yi/2/isOZMX3Riww@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yi/2/isOZMX3Riww@gmail.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Mar 15, 2022 at 02:16:30AM +0000, Eric Biggers wrote:
> On Mon, Feb 14, 2022 at 04:09:58PM -0800, Boris Burkov wrote:
> > diff --git a/tests/generic/690 b/tests/generic/690
> > new file mode 100755
> > index 00000000..77906dd8
> > --- /dev/null
> > +++ b/tests/generic/690
> > @@ -0,0 +1,66 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (c) 2021 Facebook, Inc.  All Rights Reserved.
> > +#
> > +# FS QA Test 690
> > +#
> > +# fs-verity requires the filesystem to decide how it stores the Merkle tree,
> > +# which can be quite large.
> > +# It is convenient to treat the Merkle tree as past EOF, and ext4, f2fs, and
> > +# btrfs do so in at least some fashion. This leads to an edge case where a
> > +# large file can be under the file system file size limit, but trigger EFBIG
> > +# on enabling fs-verity. Test enabling verity on some large files to exercise
> > +# EFBIG logic for filesystems with fs-verity specific limits.
> > +#
> > +. ./common/preamble
> > +_begin_fstest auto quick verity
> > +
> > +
> > +# Import common functions.
> > +. ./common/filter
> > +. ./common/verity
> > +
> > +# real QA test starts here
> > +_supported_fs generic
> > +_require_test
> > +_require_math
> > +_require_scratch_verity
> > +_require_fsverity_max_file_size_limit
> > +_require_scratch_nocheck
> 
> Why is _require_scratch_nocheck() needed?  _require_scratch_verity() already
> does _require_scratch(), and I don't see why skipping fsck would be needed.
> 
> > +# have to go back by 4096 from max to not hit the fsverity MAX_LEVELS check.
> > +truncate -s $max_sz $fsv_file
> 
> The above comment should be removed.
> 

Thanks for catching these oversights, will fix them. The nocheck thing
was left over from mixing/copy-pasting with btrfs/290 during this test's
evolution. Works fine without it on ext4 and btrfs.

> - Eric
