Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4375137FC72
	for <lists+linux-fscrypt@lfdr.de>; Thu, 13 May 2021 19:24:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbhEMRZR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 13 May 2021 13:25:17 -0400
Received: from mx2.suse.de ([195.135.220.15]:36340 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229877AbhEMRZQ (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 13 May 2021 13:25:16 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 62493B124;
        Thu, 13 May 2021 17:24:05 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id DEAB7DAF1B; Thu, 13 May 2021 19:21:34 +0200 (CEST)
Date:   Thu, 13 May 2021 19:21:34 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v3 1/5] btrfs: add compat_flags to btrfs_inode_item
Message-ID: <20210513172134.GJ7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        Anand Jain <anand.jain@oracle.com>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, linux-fscrypt@vger.kernel.org
References: <cover.1617900170.git.boris@bur.io>
 <7fd3068c977de9dd25eb98fa2b9d3cd928613138.1617900170.git.boris@bur.io>
 <f0c82e93-6d21-740e-5ece-e3b5cc5a8677@oracle.com>
 <YHCa2lw4vBw/3ea1@zen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YHCa2lw4vBw/3ea1@zen>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Apr 09, 2021 at 11:20:32AM -0700, Boris Burkov wrote:
> On Fri, Apr 09, 2021 at 07:40:44AM +0800, Anand Jain wrote:
> > On 09/04/2021 02:33, Boris Burkov wrote:
> > Why not update the tree checker (need to fix stable kernel as well) and
> > inode flags, so that we spare u64 space in the btrfs_inode_item?
> 
> I don't understand this suggestion, could you be more specific?

That's probably the same suggestion I made regarding the existing inode
flags split, with some minimal backport to recognize the compat flags.

> > Also, I think we need the incompt flags to check during mount.
> 
> Same for this one, sorry. What do you think I should check?

The flag is read-only compat, and once it's added to the set
BTRFS_FEATURE_COMPAT_RO_SUPP it's already checked in open_ctree

3290 /*
3291  * Needn't use the lock because there is no other task which will
3292  * update the flag.
3293  */
3294 btrfs_set_super_incompat_flags(disk_super, features);
3295
3296 features = btrfs_super_compat_ro_flags(disk_super) &
3297         ~BTRFS_FEATURE_COMPAT_RO_SUPP;
3298 if (!sb_rdonly(sb) && features) {
3299         btrfs_err(fs_info,
3300 "cannot mount read-write because of unsupported optional features (%llx)",
3301                features);
3302         err = -EINVAL;
3303         goto fail_alloc;
3304 }

So the mount check is there.
