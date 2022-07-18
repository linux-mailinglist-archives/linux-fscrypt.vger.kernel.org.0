Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38FC5578B67
	for <lists+linux-fscrypt@lfdr.de>; Mon, 18 Jul 2022 22:02:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233409AbiGRUCQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 Jul 2022 16:02:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234984AbiGRUBw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 Jul 2022 16:01:52 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9DE32A962;
        Mon, 18 Jul 2022 13:01:47 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id B3BC08111A;
        Mon, 18 Jul 2022 16:01:47 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1658174507; bh=PsUjABwQbehPW1YkNa1zR6qfM/hUZXIbC/U70Svlr7k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ZOGFvicNPBLcoWcebJ9ZAnzyAIGo2YBbnt92AcLh3fIWxSsLobPhOQ6oXao5vmBHx
         IqbqR5fYlc377j4GY3AfqQ7t52dz9YHS6OHXueWkRg+6vTqGx/81W27D1WRYI4g8tr
         m6oChwqtaHpwOyDuTjoqKX58UDEl2RTpyHANXVp0dHlZfVQgMirLFd3GM2uw/RMEj8
         R0Oou26OYJim5rR5CJ3Oc9tVLTb4GY+EncmIfDRiTGqBNpBtLq+zmsFgvyB/HuhfOt
         OM2T28vcWoarRFZXcvNT5Awx4AtXttswfjbLvt9m/L1RXk6H7flSNNRG/37juFQMRn
         N2ubUpQ3zSFdg==
MIME-Version: 1.0
Date:   Mon, 18 Jul 2022 16:01:47 -0400
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Eric Biggers <ebiggers@google.com>,
        Josef Bacik <josefbacik@toxicpanda.com>
Subject: Re: [PATCH v10 4/5] btrfs: test verity orphans with dmlogwrites
In-Reply-To: <YtWzWN3R4pbftK4o@zen>
References: <28979252b803c073d6a8084c11b5ba27@dorminy.me>
 <YtWzWN3R4pbftK4o@zen>
Message-ID: <441eacdd0e69e6e87aab2d0c6b4890dd@dorminy.me>
X-Sender: sweettea-kernel@dorminy.me
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


>> 
>> I'm not understanding the snapshot part. It seems like most tests 
>> using
>> log-writes do `_log_writes_replay_log_range $cur $SCRATCH_DEV >>
>> $seqres.full` to start each iteration; and then it seems like this 
>> test can
>> check the item counts before and after a 
>> _scratch_mount/_scratch_umount
>> cycle  and get the same results. (And, if that worked, the test 
>> wouldn't
>> need its own _cleanup() and its own lv management, I think?) But I'm
>> probably missing something.
> 
> IIRC, the purpose of the snapshots is that the mount/unmount cycle is
> destructive in the middle of the operation. If the orphan is present,
> we'll blow up all the verity items, so if we did it on the device we
> were replaying onto, it would leave it in a messed up state as we kept
> replaying. So we snapshot at each entry and mount/unmount that to check
> the invariants.

I think what you're saying is that we can't use the device itself 
instead of the snapshot, because mount/unmount change the underlying 
device, and this definitely makes sense.

Looking at other dmlogwrites users, though, generic/482 looks like it 
does something similar, and I don't understand what the difference 
between the replay+snapshot+mount cycles here and the replay+mount 
cycles there. I probably just don't understand what the difference 
between the two tests' scenarios is, though.
