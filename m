Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B54B37F024
	for <lists+linux-fscrypt@lfdr.de>; Thu, 13 May 2021 01:56:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231577AbhELX4e (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 12 May 2021 19:56:34 -0400
Received: from mx2.suse.de ([195.135.220.15]:33010 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236670AbhELXkY (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 12 May 2021 19:40:24 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id EEAF3B190;
        Wed, 12 May 2021 23:38:45 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id E389BDA919; Thu, 13 May 2021 01:36:15 +0200 (CEST)
Date:   Thu, 13 May 2021 01:36:15 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Boris Burkov <boris@bur.io>
Cc:     dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 5/5] btrfs: verity metadata orphan items
Message-ID: <20210512233615.GD7604@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1620240133.git.boris@bur.io>
 <8e7e0d3dd84f729d86e7f1a466fe8828f0e7ba58.1620241221.git.boris@bur.io>
 <20210512174827.GV7604@twin.jikos.cz>
 <YJwZuTXDfObB6Nbi@zen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YJwZuTXDfObB6Nbi@zen>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 12, 2021 at 11:08:57AM -0700, Boris Burkov wrote:
> On Wed, May 12, 2021 at 07:48:27PM +0200, David Sterba wrote:
> > On Wed, May 05, 2021 at 12:20:43PM -0700, Boris Burkov wrote:
> > > +/*
> > > + * Helper to manage the transaction for adding an orphan item.
> > > + */
> > > +static int add_orphan(struct btrfs_inode *inode)
> > 
> > I wonder if this helper is useful, it's used only once and the code is
> > not long. Simply wrapping btrfs_orphan_add into a transaction is short
> > enough to be in btrfs_begin_enable_verity.
> 
> I agree that just the plain transaction logic is not a big deal, and I
> couldn't figure out how to phrase the comment so I left it at that,
> which is unhelpful.
> 
> With that said, I found that pulling it out into a helper function
> significantly reduced the gross-ness of the error handling in the
> callsites. Especially for del_orphan in end verity which tries to
> handle failures deleting the orphans, which quickly got tangled up with
> other errors in the function and the possible transaction errors.
> 
> Honestly, I was surprised just how much it helped, and couldn't really
> figure out why. If a helper being really beneficial is abnormal, I can
> try again to figure out a clean way to write the code with the
> transaction in-line.

This gives me an impression that the helper in your view helps
readability and that's something I'm fine with. In the past we got
cleanups that remove one time helpers so I'm affected by that. Also the
helpers hide some details like the transaction start that could be
considered heavy so the helper kind of obscures that. But there's
another aspect, again readability, "do that and the caller does not need
to care", and when the helper is static in the same file it's easy to
look up and not a big deal.

> > > +{
> > > +	struct btrfs_trans_handle *trans;
> > > +	struct btrfs_root *root = inode->root;
> > > +	int ret = 0;
> > > +
> > > +	trans = btrfs_start_transaction(root, 1);
> > > +	if (IS_ERR(trans)) {
> > > +		ret = PTR_ERR(trans);
> > > +		goto out;
> > > +	}
> > > +	ret = btrfs_orphan_add(trans, inode);
> > > +	if (ret) {
> > > +		btrfs_abort_transaction(trans, ret);
> > > +		goto out;
> > > +	}
> > > +	btrfs_end_transaction(trans);
> > > +
> > > +out:
> > > +	return ret;
> > > +}
> > > +
> > > +/*
> > > + * Helper to manage the transaction for deleting an orphan item.
> > > + */
> > > +static int del_orphan(struct btrfs_inode *inode)
> > 
> > Same here.
> 
> My comment is dumb again, but the nlink check does make this function
> marginally more useful for re-use/correctness.

I don't think it's dumb, the nlink check is one line with several lines
of comment explaining and also described in the changelog as a corner
case and it's not obvious. For that reason a helper is fine and let's
keep the helpers as they are, so it's consistent. It's just when I'm
reading the code I'm questioning everything but it does not mean that
all of that needs to be done the way I see it, in the comments I'm
just exploring the possibility to do so.
