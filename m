Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 66E16774E81
	for <lists+linux-fscrypt@lfdr.de>; Wed,  9 Aug 2023 00:45:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230155AbjHHWpF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 8 Aug 2023 18:45:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbjHHWpF (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 8 Aug 2023 18:45:05 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 46A97100;
        Tue,  8 Aug 2023 15:45:04 -0700 (PDT)
Received: by linux.microsoft.com (Postfix, from userid 1052)
        id ACC3A20FC0D2; Tue,  8 Aug 2023 15:45:03 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com ACC3A20FC0D2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1691534703;
        bh=sVCat3a1M7KHdlESd70oA1x2KXrxJ+56GtFSeTDlhcM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IKGEzYVtmP2d5RXQGvuDn1I/QZ4sOzZi4K/A2GFZ2iulDRvmRtjOIZiRVuMKczceS
         0CiDLnNBQ2LUBMhDJBdn1PQPlunEfC8CXQzTGInv/hBg/Ilpo2DmC4rg8xJgCfKGlU
         /LGb9xCJTxmrboncvvC5Grxc+B/9dleXOZ5FNzVQ=
Date:   Tue, 8 Aug 2023 15:45:03 -0700
From:   Fan Wu <wufan@linux.microsoft.com>
To:     Paul Moore <paul@paul-moore.com>
Cc:     Mike Snitzer <snitzer@kernel.org>, corbet@lwn.net,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk,
        agk@redhat.com, eparis@redhat.com, linux-doc@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
Subject: Re: [RFC PATCH v10 11/17] dm-verity: consume root hash digest and
 signature data via LSM hook
Message-ID: <20230808224503.GA20095@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
References: <1687986571-16823-1-git-send-email-wufan@linux.microsoft.com>
 <1687986571-16823-12-git-send-email-wufan@linux.microsoft.com>
 <ZKgm+ffQbdDTxrg9@redhat.com>
 <20230712034319.GA17642@linuxonhyperv3.guj3yctzbm1etfxqx2vob5hsef.xx.internal.cloudapp.net>
 <CAHC9VhQFxqcfgR0acgdiXKP9LT1KLgGjZd-QHs6O1dEex31HEQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHC9VhQFxqcfgR0acgdiXKP9LT1KLgGjZd-QHs6O1dEex31HEQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Jul 25, 2023 at 04:43:48PM -0400, Paul Moore wrote:
> On Tue, Jul 11, 2023 at 11:43???PM Fan Wu <wufan@linux.microsoft.com> wrote:
> > On Fri, Jul 07, 2023 at 10:53:45AM -0400, Mike Snitzer wrote:
> 
> ...
> 
> > > Both of your calls to security_bdev_setsecurity() to set your blobs in
> > > the bdev are suspect because you're doing so from the verity_ctr().
> > > The mapped_device has 2 dm_table slots (active and inactive).  The
> > > verity_ctr() becomes part of the inactive slot, there is an extra step
> > > to bind the inactive table to the active table.
> > >
> > > This leads to you changing the blobs in the global bdev _before_ the
> > > table is actually active.  It is possible that the inactive table will
> > > simply be removed and the DM verity device put back in service;
> > > leaving your blob(s) in the bdev inconsistent.
> > >
> > > This issue has parallels to how we need to defer changing the global
> > > queue_limits associated with a request_queue until _after_ all table
> > > loading is settled and then the update is done just before resuming
> > > the DM device (mapped_device) -- see dm_table_set_restrictions().
> > >
> > > Unfortunately, this feels like it may require a new hook in the
> > > target_type struct (e.g. ->finalize())
> >
> > Thanks for pointing out this issue. We were calling security_bdev_setsecurity()
> > because the roothash signature data is only available in verity_ctr()
> > and it is discarded after verity_ctr() finishes.
> > After digging deeper into the table_load, I realized that we were indeed
> > wrong here.
> >
> > Based on my understanding of your suggestion, it seems that the correct
> > approach would be to save the roothash signature into the struct dm_target
> 
Sorry for the delay in responding. It took me a while to test out the design idea
suggested by Mike.

The current implementation is indeed incorrect. However, I've been able to develop
a working prototype that addresses the problem identified in the existing implementation.
I still need some additional time to fine-tune and clean up the prototype.

My goal is to have everything ready and send it out next month.

> Would you be doing this with a LSM hook, or would this live in the
> device mapper layer?
> 
In my implemention, it is a new hook in the device mapper layer. 
The hook is triggered just before activating an inactive table of a mapped device.
So in our case, we use the hook to attached the dm-verity's roothash metadata
to the block_device struct of mapped device.

> > and then invoke security_bdev_setsecurity() before activating
> > the inactive table in the __bind function (where dm_table_set_restrictions is called).
> >
> > To facilitate this process, it seems appropriate to introduce a new hook
> > called finalize() within the struct target_type. This hook would enable
> > targets to define tasks that need to be completed before activating
> > a new table.
> >
> > In our specific case, we would add a finalize hook to the dm-verity module,
> > allowing us to call security_bdev_setsecurity() and associate the roothash
> > information in the struct dm_target with the struct block_device of
> > the struct mapped_device. Is this correct?
> 
> Where would the finalize() hook be called?

It is in the __bind function in drivers/md/dm.c, calling just before 
rcu_assign_pointer(md->map, (void *)t) which activates the inactive table.

-Fan
