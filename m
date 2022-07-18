Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 056FD578AA2
	for <lists+linux-fscrypt@lfdr.de>; Mon, 18 Jul 2022 21:24:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235616AbiGRTYR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 Jul 2022 15:24:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43260 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235909AbiGRTYO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 Jul 2022 15:24:14 -0400
Received: from out5-smtp.messagingengine.com (out5-smtp.messagingengine.com [66.111.4.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 011EA12760;
        Mon, 18 Jul 2022 12:24:12 -0700 (PDT)
Received: from compute2.internal (compute2.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 7DA1F5C0143;
        Mon, 18 Jul 2022 15:24:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute2.internal (MEProxy); Mon, 18 Jul 2022 15:24:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=cc:cc
        :content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; t=1658172250; x=1658258650; bh=7gP5SfXBLY
        zvYPQmm363Nym+7P+Hib8IvxPnXWqbi3s=; b=kD8wnI0hBFb0DyxjDK4oj/rgO7
        5MOa5VvzhBOGimSI0TT1jdCzyi9uTV4wB0jN9U7BZTKcn481Hh6RDjKjJ9c1uLOa
        WNqkaVlTSNGDyEOiCTcjkcLLhyt442rY8zLdemhoncy3Z0Ky2cUpvBC13mIAaIqY
        wAo388nUsH0LTvYXSbgLU5wFiTlsHtGd9Fy+x4lx+v/I6S8SjIheDtS1VVswAFbX
        ixvGvS/5Z05Rop/sllCgwu+Szxhtm/tDVA/CdE3qDsRoHeVls+MAzmNPZR5GhTCT
        FtuJspIRjyVmolo1OMTZiLEylnUDGsB52XWBf/DGyQv07XS5b8RqjE9OreTQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:feedback-id
        :feedback-id:from:from:in-reply-to:in-reply-to:message-id
        :mime-version:references:reply-to:sender:subject:subject:to:to
        :x-me-proxy:x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=
        fm3; t=1658172250; x=1658258650; bh=7gP5SfXBLYzvYPQmm363Nym+7P+H
        ib8IvxPnXWqbi3s=; b=hT8IZaQFjq4bhCONhLJksXAaV6Y0F1Xaxw+wzr9Y5Zjv
        IwsZbUouuPtDBVzbpPOfu+WgFq8N9GIAJ2f7gA6kkcmdX2mTnOXuILV40P3DqOPz
        PVID9xQ3FL1xLjaG+axhodaLTIUNGFdCv7+nBnI0AaII9yUgDvvy3NI3zUXrCLfQ
        Yae+ZtK/19nZzu9p3si/xln6MLJdkqfWc6TH9i1LJQihWzCg7iN2zdvthlS1mWXC
        uBw+o3LTJXrlliWfTtqi87acxZyl+4z2sgPIXU0uZawzP2Ashtwutf+IwZeWNgsO
        aihqbXQfb7/6Jxl/mopwIm8OJi4chYxHQZLFbWGEiw==
X-ME-Sender: <xms:WrPVYgETcGmBZ_Cku75cDzTEhxOiYHrTd4K7ulhcDkyURc8Xly2KzQ>
    <xme:WrPVYpUZrUA7haC-L_2G7D_55kh44wXkNvIYtiDFuuD38ROAYg5d596GQJJMsSdzi
    X3ykuxq64ZhFV6TYg4>
X-ME-Received: <xmr:WrPVYqIabNHHWdnnLB2tVoE7rm8WIW-6hShV0EhP9uLf7u94bzJ9AM6tsYGHYIcfIpHRwc-LlGcy9sVOL3lt1u-Vc6bv9A>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrudekkedgudefhecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpeeuohhr
    ihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhrrdhioheqnecuggftrfgrthhtvghrnh
    epleffgeevgeetueegledtueeluddtudekhefhudeuheegfeevieehteevieejueetnecu
    ffhomhgrihhnpehgihhthhhusgdrtghomhenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuhhrrdhioh
X-ME-Proxy: <xmx:WrPVYiFPMJnlXtl21JPemU4PypaBFoTmHGe2LZIm-itsHpoMCnXtYg>
    <xmx:WrPVYmUbWW0xBM1VtwAg6Q2du5isdMNmoaZINgVC_IzmbOdCgtPMig>
    <xmx:WrPVYlMEkPWWvjA5SXqgZF7PDBByuDMzesXGGiMEOZfCl57Pvd73TA>
    <xmx:WrPVYodmWRML3wiJwdq-45pLZrrB_O8ap4LlGg4TOUK59pskIDu-kw>
Feedback-ID: i083147f8:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 18 Jul 2022 15:24:09 -0400 (EDT)
Date:   Mon, 18 Jul 2022 12:24:08 -0700
From:   Boris Burkov <boris@bur.io>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Eric Biggers <ebiggers@google.com>,
        Josef Bacik <josefbacik@toxicpanda.com>
Subject: Re: [PATCH v10 4/5] btrfs: test verity orphans with dmlogwrites
Message-ID: <YtWzWN3R4pbftK4o@zen>
References: <28979252b803c073d6a8084c11b5ba27@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <28979252b803c073d6a8084c11b5ba27@dorminy.me>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jul 18, 2022 at 02:22:44PM -0400, Sweet Tea Dorminy wrote:
> 
> > At each log entry, we want to assert a
> > somewhat complicated invariant:
> > 
> > If verity has not yet started: an orphan indicates that verity has
> > started.
> > If verity has started: mount should handle the orphan and blow away
> > verity data: expect 0 merkle items after mounting the snapshot dev. If
> > we can measure the file, verity has finished.
> > If verity has finished: the orphan should be gone, so mount should not
> > blow away merkle items. Expect the same number of merkle items before
> > and after mounting the snapshot dev.
> 
> I was a bit confused by the mix of invariants and state transition
> conditions, and think this would be somewhat clearer to split into 'state
> transition' and 'state invariant' sections, perhaps as follows:
> 
> There are three possible states for a given point in the log: initially
> verity has not yet started; then verity has started but not finished; and
> finally verity has finished. The log must proceed through these states in
> order: verity starts when an orphan item is added; and
> verity has finished when, post-mount, the verity tool can measure the file.
> 
> Each state has its own invariant for testing:
> - If verity has not yet started: no verity items exist.
> - If verity has started: mount should handle the orphan and blow away
>  verity data: expect 0 merkle items after mounting.
> - If verity has finished: the orphan should be gone and mount should not
>  blow away merkle items. Expect the same number of merkle items before
>  and after mounting.

Thank you so much for untangling the state transitions from the
invariant at each state, that makes it much much clearer.

> 
> > 
> > Note that this relies on grepping btrfs inspect-internal dump-tree.
> > Until btrfs-progs has the ability to print the new Merkle items, they
> > will show up as UNKNOWN.36/37.
> 
> I think that progs versions 5.17+ include print verity items [1] but I don't
> know how tests deal with version-dependent output...
> 
> [1] https://github.com/kdave/btrfs-progs/commit/c4947248580c20869e75e8e61fb9b5e020053b3c

Good point! I think we should just target the new one?

> 
> > +replay_log_prog=$here/src/log-writes/replay-log
> > +num_entries=$($replay_log_prog --log $LOGWRITES_DEV --num-entries)
> > +entry=$($replay_log_prog --log $LOGWRITES_DEV --replay $replay_dev
> > --find --end-mark mkfs | cut -d@ -f1)
> > +$replay_log_prog --log $LOGWRITES_DEV --replay $replay_dev --limit
> > $entry || \
> > + _fail "failed to replay to start entry $entry"
> > +let entry+=1
> > +
> > +# state = 0: verity hasn't started
> > +# state = 1: verity underway
> > +# state = 2: verity done
> > +state=0
> > +while [ $entry -lt $num_entries ];
> > +do
> > + $replay_log_prog --limit 1 --log $LOGWRITES_DEV --replay $replay_dev
> > --start $entry || \
> > + _fail "failed to take replay step at entry: $entry"
> > +
> > + $LVM_PROG lvcreate -s -L 4M -n $snapname $vgname/$lvname
> > >>$seqres.full 2>&1 || \
> > + _fail "Failed to create snapshot"
> > + $UDEV_SETTLE_PROG >>$seqres.full 2>&1
> > +
> > + orphan=$(count_item $snap_dev ORPHAN)
> > + if [ $state -eq 0 ]; then
> > + [ $orphan -gt 0 ] && state=1
> > + fi
> This being in an if is inconsistent with the state transitions a few lines
> down; it would be nice to be consistent, though I don't have a preference
> about which way.

Oh yeah, I am a bit inconsistent. I'll try to make it more uniform.

> > +
> > + pre_mount=$(count_item $snap_dev UNKNOWN.3[67])
> > + _mount $snap_dev $SCRATCH_MNT || _fail "mount failed at entry $entry"
> > + fsverity measure $SCRATCH_MNT/fsv >>$seqres.full 2>&1
> > + measured=$?
> > + umount $SCRATCH_MNT
> > + [ $state -eq 1 ] && [ $measured -eq 0 ] && state=2
> > + [ $state -eq 2 ] && ([ $measured -eq 0 ] || _fail "verity done, but
> > measurement failed at entry $entry")
> > + post_mount=$(count_item $snap_dev UNKNOWN.3[67])
> > +
> > + echo "entry: $entry, state: $state, orphan: $orphan, pre_mount:
> > $pre_mount, post_mount: $post_mount" >> $seqres.full
> > +
> > + if [ $state -eq 1 ]; then
> > + [ $post_mount -eq 0 ] || \
> > + _fail "mount failed to clear under-construction merkle items pre:
> > $pre_mount, post: $post_mount at entry $entry";
> > + fi
> > + if [ $state -eq 2 ]; then
> > + [ $pre_mount -gt 0 ] || \
> > + _fail "expected to have verity items before mount at entry $entry"
> > + [ $pre_mount -eq $post_mount ] || \
> > + _fail "mount cleared merkle items after verity was enabled
> > $pre_mount vs $post_mount at entry $entry";
> > + fi
> > +
> > + let entry+=1
> > + $LVM_PROG lvremove $vgname/$snapname -y >>$seqres.full
> > +done
> 
> I'm not understanding the snapshot part. It seems like most tests using
> log-writes do `_log_writes_replay_log_range $cur $SCRATCH_DEV >>
> $seqres.full` to start each iteration; and then it seems like this test can
> check the item counts before and after a _scratch_mount/_scratch_umount
> cycle  and get the same results. (And, if that worked, the test wouldn't
> need its own _cleanup() and its own lv management, I think?) But I'm
> probably missing something.

IIRC, the purpose of the snapshots is that the mount/unmount cycle is
destructive in the middle of the operation. If the orphan is present,
we'll blow up all the verity items, so if we did it on the device we
were replaying onto, it would leave it in a messed up state as we kept
replaying. So we snapshot at each entry and mount/unmount that to check
the invariants.

I think I might be able to switch to the helper functions for advancing
the log from FUA to FUA instead of by 1 entry each time, though. That
might make the test a bit faster :)
