Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D762340B67E
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Sep 2021 20:04:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230220AbhINSFU (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Sep 2021 14:05:20 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:50248 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231527AbhINSFU (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Sep 2021 14:05:20 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 075C31FE1E;
        Tue, 14 Sep 2021 18:04:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1631642642;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2As+fQ/ohn1szKzAnFw3TZZxVSVD/JQvvSLAbGUvZqw=;
        b=1Bd18+7/IH4c0AH5WPQKsijYzDUnkkYZH2oNvkA2mJal/d57BvFmjMNm+MiCv3VSQuRVxF
        79wKS1UnxfsBkjPZ0D1sSxkKxc8M/p6ySmRh79mT3vtmUXEZLCRynBdVzrRCbHgPqm9JjZ
        j1OT3KMNo5Mrhf2uZgXOw+/KYtS8yBY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1631642642;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=2As+fQ/ohn1szKzAnFw3TZZxVSVD/JQvvSLAbGUvZqw=;
        b=CImG9EKoBlEbBb1YjdWHO73g2v2DVEkrMRjMRTcHqLhKe5voN/zXhOINAYXjgnscylKS3X
        WbTdnx6mbsnRK8Bw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id F137BA3B96;
        Tue, 14 Sep 2021 18:04:01 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id A1F02DA781; Tue, 14 Sep 2021 20:03:53 +0200 (CEST)
Date:   Tue, 14 Sep 2021 20:03:53 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     Eric Biggers <ebiggers@kernel.org>, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v6 2/3] btrfs: initial fsverity support
Message-ID: <20210914180353.GI9286@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        Eric Biggers <ebiggers@kernel.org>, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@fb.com
References: <cover.1625083099.git.boris@bur.io>
 <797d6524e4e6386fc343cd5d0bcdd53878a6593e.1625083099.git.boris@bur.io>
 <YUDcy73zXVPneImG@sol.localdomain>
 <YUDgmgq1Q5l5e/K4@zen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YUDgmgq1Q5l5e/K4@zen>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Sep 14, 2021 at 10:49:33AM -0700, Boris Burkov wrote:
> >    inode flags ro_compat instead, right?
> 
> I believe it is still being used, unless I messed up the patch I sent in
> the end. Taking a quick look, I think it's set at fs/btrfs/verity.c:558.
> 
> btrfs_set_fs_compat_ro(root->fs_info, VERITY);
> 
> I believe I still needed it because the tree checker doesn't scan every
> inode on the filesystem when you mount, so it would only freak out about
> a ro-compat inode later on if the inode didn't happen to be in a leaf
> that was being checked at mount time.
> 
> > 
> > 2. Is there a minimum version of btrfs-progs that is required to use btrfs
> >    verity?  With ext4 and f2fs, the fsck tools had to be updated, so there were
> >    minimum versions of the userspace tools required.
> 
> Hmm. I didn't update fsck, but now that you mention it, I think I need to...
> I'll test it right away and get back to you, but I suspect I need to
> hurry up and implement it.

The timing of kernel features and btrfs-progs is to have them at the
same release number at the latest, but it could be any time earlier as
it also makes testing easier (released vs git snapshot).
