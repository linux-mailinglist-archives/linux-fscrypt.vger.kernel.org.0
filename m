Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C8CA578BFB
	for <lists+linux-fscrypt@lfdr.de>; Mon, 18 Jul 2022 22:43:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234636AbiGRUnw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 Jul 2022 16:43:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235656AbiGRUnp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 Jul 2022 16:43:45 -0400
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A951B30F58;
        Mon, 18 Jul 2022 13:43:44 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 177D85C011B;
        Mon, 18 Jul 2022 16:43:44 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute2.internal (MEProxy); Mon, 18 Jul 2022 16:43:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1658177024; x=1658263424; bh=FnddR2qd/j
        yRaeemWdHw9cVjrT+zhuOzDDuuSDRdvrM=; b=UA/GX3UTbWgyUovjwr0xb3Z9eV
        AdDQl/CZGFZ66k/l5fSvvOZ+XQ3xVfYIjKeqxldD163jfHDvGSiJZItz4oNU3dA5
        VM3mf5S02xR69Tyf8alReXmyaRWcl9dRvCrX+hNXvZxSyzmeklO+SX0dlWoNbatz
        +WHFMYezWX2iyWnUp3WVzVuZON58AFM58cOxIjs996jRq8MmJ+l764t17hzPQ9lD
        qHP2ip1Ac0qVg9oj+7Yl57lVAdmqFx2aTltGO74qBasjB3W6Gix6SuiSgcQ9Mqfi
        5Ax8k/Z/r2euxfhBAa/dVvjAud6/PjMO3oDh3RShp+KNQiM4Yg930U0zAkPw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1658177024; x=1658263424; bh=FnddR2qd/jyRaeemWdHw9cVjrT+z
        huOzDDuuSDRdvrM=; b=dfAfHjoojTGtNkHbD84B4SvXyLDoo9o9xU2XioBjrAPt
        ZvZo8NqWUb2vmmTWP/63l4vC47QrPmCt7iASyZk3OGXpb67ilDTZg46mVcSuWfHB
        zuKI6ASgWO1ha/qs8jsAJYuUeq+NvTHh6lqTJrKYpv4UAJsLJKYLsIs/niNFGBjR
        7eETO/o3m5jQR47nE9T6iNLS2g2V2EgqN7lFTcqnVGksKbnApYnY0AkJqu0JnhC5
        6Z/+KheVKyF85PEgRvf/aYkV9ri+Vl+4fwTBU/p7u8VoESsJlfsJArExLvnquHcP
        YDEkRAUghlgGjeZv9aJ3ZtfZP8bH40A8AyLRnyiCAQ==
X-ME-Sender: <xms:_8XVYlQNRf2UQopAyBoME94EpDpVi4NcqmGWk_ds_U5yGgGZ9UzVfw>
    <xme:_8XVYuxAxkmaevShgh5JK1zYKpyjzBNFFNkesspr1W_eDx3ukIKEycJz2OD32vJlR
    73Orm7GZIH6lR5_J6M>
X-ME-Received: <xmr:_8XVYq0ErgCDDSCHzAv-DkroIi36oFg6uVIc9BFt0oEm5urQPDNLdf4KgYlGSMp2qd6NIBod567NV5RHIohHtHiSebiauw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekkedgudehudcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhr
    ihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnh
    ephedthfevgffhtdevgffhlefhgfeuueegtdevudeiheeiheetleeghedvfeegfeegnecu
    ffhomhgrihhnpehkvghrnhgvlhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:_8XVYtDXqjwSKGUFZhMgehWMl5vFCr4EvD8EiQVOruMuZFsZ_ZM5IA>
    <xmx:_8XVYuiHpuLLCApiTShlifmZMMAk_mQVmHEHvauCX08SuKuvY5ovNQ>
    <xmx:_8XVYhrqyBntTN_75_QaxrqqHLTcAL0Lo1FNG3m4AaNhoW47-EP7gQ>
    <xmx:AMbVYgbAIxs-qcOokqrDVWGiD2EpzSEWxS5IKyN2g_ItUhmiH_8_KQ>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Jul 2022 16:43:43 -0400 (EDT)
Date:   Mon, 18 Jul 2022 13:43:41 -0700
From:   Boris Burkov <boris@bur.io>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Eric Biggers <ebiggers@google.com>,
        Josef Bacik <josefbacik@toxicpanda.com>
Subject: Re: [PATCH v10 4/5] btrfs: test verity orphans with dmlogwrites
Message-ID: <YtXF/d4j8KrKDkV8@zen>
References: <28979252b803c073d6a8084c11b5ba27@dorminy.me>
 <YtWzWN3R4pbftK4o@zen>
 <441eacdd0e69e6e87aab2d0c6b4890dd@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <441eacdd0e69e6e87aab2d0c6b4890dd@dorminy.me>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jul 18, 2022 at 04:01:47PM -0400, Sweet Tea Dorminy wrote:
> 
> > > 
> > > I'm not understanding the snapshot part. It seems like most tests
> > > using
> > > log-writes do `_log_writes_replay_log_range $cur $SCRATCH_DEV >>
> > > $seqres.full` to start each iteration; and then it seems like this
> > > test can
> > > check the item counts before and after a
> > > _scratch_mount/_scratch_umount
> > > cycle  and get the same results. (And, if that worked, the test
> > > wouldn't
> > > need its own _cleanup() and its own lv management, I think?) But I'm
> > > probably missing something.
> > 
> > IIRC, the purpose of the snapshots is that the mount/unmount cycle is
> > destructive in the middle of the operation. If the orphan is present,
> > we'll blow up all the verity items, so if we did it on the device we
> > were replaying onto, it would leave it in a messed up state as we kept
> > replaying. So we snapshot at each entry and mount/unmount that to check
> > the invariants.
> 
> I think what you're saying is that we can't use the device itself instead of
> the snapshot, because mount/unmount change the underlying device, and this
> definitely makes sense.
> 
> Looking at other dmlogwrites users, though, generic/482 looks like it does
> something similar, and I don't understand what the difference between the
> replay+snapshot+mount cycles here and the replay+mount cycles there. I
> probably just don't understand what the difference between the two tests'
> scenarios is, though.

I just noticed a comment in generic/482 that I think explains it:

# We don't care to preserve any data on the replay dev, as we can replay
# back to the point we need, and in fact sometimes creating/deleting
# snapshots repeatedly can be slower than replaying the log.

So it looks to me like those tests re-replay the full log, including
whatever the mkfs preamble stuff is onto replaydev for each FUA. That
would work for me, I just assumed snapshots would be more efficient,
though this comment challenges that assumption.

Also, it looks like that tests tracks the prev entry redundantly.
Looking into its history, it looks like it was always that way, but
evolved into that state from originally being more like my test.
https://patchwork.kernel.org/project/linux-btrfs/patch/20180314090230.25055-3-wqu@suse.com/#21608233
