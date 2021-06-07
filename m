Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 287CE39E8F4
	for <lists+linux-fscrypt@lfdr.de>; Mon,  7 Jun 2021 23:13:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230483AbhFGVOv (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 7 Jun 2021 17:14:51 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:55862 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230450AbhFGVOv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 7 Jun 2021 17:14:51 -0400
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id D2B8D219C2;
        Mon,  7 Jun 2021 21:12:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1623100378;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gElMYfSXqsNiKD1OOnvNhTJ70YygUr713fzi9KR+zdc=;
        b=L5Re/naDXUxkuFm4XK8ZswCVMh3Jgw17EMQNPYyahGkwzu2NfkSCXrRJ1aoVfffxoI76+N
        0s9dF4I1UA5p2GMdrWW+iCuPHdcdhv51Vh4SIv1o216sSLOK8rpygtWJrmVgE43T6bwakD
        q8zjAqQeleKdsWo0dmoz5RA/QVlZKj8=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1623100378;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=gElMYfSXqsNiKD1OOnvNhTJ70YygUr713fzi9KR+zdc=;
        b=U9jgcTHR6xjbbi1BICt+ROHvkMQY6jVaByNyAuIvAncjiOdkBNiVV4SFld+1YB37Ht9cWP
        +YfEJ03D6HVCztAw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id AAFCDA3BE3;
        Mon,  7 Jun 2021 21:12:58 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 76261DB228; Mon,  7 Jun 2021 23:10:15 +0200 (CEST)
Date:   Mon, 7 Jun 2021 23:10:15 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 1/5] btrfs: add compat_flags to btrfs_inode_item
Message-ID: <20210607211015.GN31483@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Eric Biggers <ebiggers@kernel.org>,
        Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@fb.com
References: <cover.1620241221.git.boris@bur.io>
 <6ed83a27f88e18f295f7d661e9c87e7ec7d33428.1620241221.git.boris@bur.io>
 <YK0+BU9twmldQ9Q0@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YK0+BU9twmldQ9Q0@sol.localdomain>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, May 25, 2021 at 11:12:21AM -0700, Eric Biggers wrote:
> On Wed, May 05, 2021 at 12:20:39PM -0700, Boris Burkov wrote:
> > The tree checker currently rejects unrecognized flags when it reads
> > btrfs_inode_item. Practically, this means that adding a new flag makes
> > the change backwards incompatible if the flag is ever set on a file.
> > 
> > Take up one of the 4 reserved u64 fields in the btrfs_inode_item as a
> > new "compat_flags". These flags are zero on inode creation in btrfs and
> > mkfs and are ignored by an older kernel, so it should be safe to use
> > them in this way.
> > 
> > Signed-off-by: Boris Burkov <boris@bur.io>
> 
> This patchset doesn't have a cover letter anymore for some reason.
> 
> Also, please mention where this patchset applies to.  I tried mainline and
> btrfs/for-next, but neither works.

There was a parallel change updating file attributes causing conflict
with the patchset as sent. Boris is aware of that and the new version
will be on top of something that appalies on top of the btrfs
development branch again.
