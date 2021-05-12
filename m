Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8211037D4E5
	for <lists+linux-fscrypt@lfdr.de>; Wed, 12 May 2021 23:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243461AbhELSeS (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 12 May 2021 14:34:18 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:34319 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1349949AbhELSKO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 12 May 2021 14:10:14 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id BA6E85C00B5;
        Wed, 12 May 2021 14:08:59 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute5.internal (MEProxy); Wed, 12 May 2021 14:08:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bur.io; h=date
        :from:to:subject:message-id:references:mime-version:content-type
        :in-reply-to; s=fm3; bh=mVuVSwXb3ObHDmkSW7Ob+xCbpYrocXpt0HUBl5hK
        t0Q=; b=LVXWyESimuL/STLNXI9o8h8wmfjsF7ozzvwM+W5Bh1fPoyc8yQne5X0G
        92SpM+iYy4iYl/6teDwIXQNGHBtjZdt0HLe48ncXLzJBZ0L6zloLcfbzSFELEJ1O
        yyb9Qp0O/ov3uO155k9x0NpIdfBhs+EgIeBA43XVCfjH5yBrWulNzVe4JsxPo29F
        HZehDypH7X27Ce6A0l59p333PjXInZiLfqwVmp7d1CjEf2ePjDNELwDRthLvH/Zk
        o7SEZESt0b6LuWRkIiYKHdwo9sFY8inp4uh/E2ph7UqT0NgjTfcL+kX4ZBUo80lw
        pUwN5WGNG/yHRR4NCYo34yMtSW7Wcg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=mVuVSw
        Xb3ObHDmkSW7Ob+xCbpYrocXpt0HUBl5hKt0Q=; b=Cwrh30zPv+JzkvQXC/5HiM
        GHC/f6gGsI6f2JUHyLcOB8dGfjYy4d4WdFurrcklNWJA/OBGddit7TwTdau6P+wv
        MoM4HHVtdSWXaNerYe6ucaDkf8TMHbIdZgy5syPMR4nFF5qKYgaBrWHGugn9Gxt9
        wQqd/isBY+KoxI+Nx6enTvQIme23r28YXnv3Mkh44thFqR50ZFXnmrNw4gn85YIC
        /7OUcCKlFeh/UAcHqs3W5j24yzjf1AgrkSZ1+zTZhwjQMn6tgL3CJkm2bCLxz7jf
        4Caq6C/uuvdfK1RUU+v7pizNNz7dLfzAs4H7vttlKj6neEUPfQpSLreNY9c9EgNQ
        ==
X-ME-Sender: <xms:uxmcYHIRGLlZJ8lXCpz_KXzgaurZgM8dUowqfQjrbtbGBLc_L9XIFg>
    <xme:uxmcYLL1-adv0ac2SGhgXRIT4f8hDHFKg9ONjM_uHQCs8D8-Vf8nd8YawK0snUAku
    niiHPk4cP56Qps11ek>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduledrvdehvddguddulecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecunecujfgurhepfffhvffukfhfgggtuggjsehttd
    ertddttddvnecuhfhrohhmpeeuohhrihhsuceuuhhrkhhovhcuoegsohhrihhssegsuhhr
    rdhioheqnecuggftrfgrthhtvghrnhepheduveelkeeiteelveeiuefhudehtdeigfehke
    effeegledvueevgefgudeuveefnecukfhppedvtdejrdehfedrvdehfedrjeenucevlhhu
    shhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpegsohhrihhssegsuh
    hrrdhioh
X-ME-Proxy: <xmx:uxmcYPvgo-vd5dRhp6KqRqrZ89OiaW892IEFIx-XVOtqUc5CskPyFw>
    <xmx:uxmcYAa5L-fxaChz9duR7uIM4V5TLnUTdaHBQDOAOvUiQAZyRIngOQ>
    <xmx:uxmcYObvWFGNaPTDKc9FNpbZjMo2rN_y8_27QoqnZX6Lijms6tpojQ>
    <xmx:uxmcYByfRgSy0l-108qon-TqJvn669Xsmc-sHtZp1BtdZ2WOVqCUSw>
Received: from localhost (unknown [207.53.253.7])
        by mail.messagingengine.com (Postfix) with ESMTPA;
        Wed, 12 May 2021 14:08:58 -0400 (EDT)
Date:   Wed, 12 May 2021 11:08:57 -0700
From:   Boris Burkov <boris@bur.io>
To:     dsterba@suse.cz, linux-btrfs@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v4 5/5] btrfs: verity metadata orphan items
Message-ID: <YJwZuTXDfObB6Nbi@zen>
References: <cover.1620240133.git.boris@bur.io>
 <8e7e0d3dd84f729d86e7f1a466fe8828f0e7ba58.1620241221.git.boris@bur.io>
 <20210512174827.GV7604@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210512174827.GV7604@twin.jikos.cz>
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 12, 2021 at 07:48:27PM +0200, David Sterba wrote:
> On Wed, May 05, 2021 at 12:20:43PM -0700, Boris Burkov wrote:
> > +/*
> > + * Helper to manage the transaction for adding an orphan item.
> > + */
> > +static int add_orphan(struct btrfs_inode *inode)
> 
> I wonder if this helper is useful, it's used only once and the code is
> not long. Simply wrapping btrfs_orphan_add into a transaction is short
> enough to be in btrfs_begin_enable_verity.
> 

I agree that just the plain transaction logic is not a big deal, and I
couldn't figure out how to phrase the comment so I left it at that,
which is unhelpful.

With that said, I found that pulling it out into a helper function
significantly reduced the gross-ness of the error handling in the
callsites. Especially for del_orphan in end verity which tries to
handle failures deleting the orphans, which quickly got tangled up with
other errors in the function and the possible transaction errors.

Honestly, I was surprised just how much it helped, and couldn't really
figure out why. If a helper being really beneficial is abnormal, I can
try again to figure out a clean way to write the code with the
transaction in-line.

> > +{
> > +	struct btrfs_trans_handle *trans;
> > +	struct btrfs_root *root = inode->root;
> > +	int ret = 0;
> > +
> > +	trans = btrfs_start_transaction(root, 1);
> > +	if (IS_ERR(trans)) {
> > +		ret = PTR_ERR(trans);
> > +		goto out;
> > +	}
> > +	ret = btrfs_orphan_add(trans, inode);
> > +	if (ret) {
> > +		btrfs_abort_transaction(trans, ret);
> > +		goto out;
> > +	}
> > +	btrfs_end_transaction(trans);
> > +
> > +out:
> > +	return ret;
> > +}
> > +
> > +/*
> > + * Helper to manage the transaction for deleting an orphan item.
> > + */
> > +static int del_orphan(struct btrfs_inode *inode)
> 
> Same here.

My comment is dumb again, but the nlink check does make this function
marginally more useful for re-use/correctness.

> 
> > +{
> > +	struct btrfs_trans_handle *trans;
> > +	struct btrfs_root *root = inode->root;
> > +	int ret;
> > +
> > +	/*
> > +	 * If the inode has no links, it is either already unlinked, or was
> > +	 * created with O_TMPFILE. In either case, it should have an orphan from
> > +	 * that other operation. Rather than reference count the orphans, we
> > +	 * simply ignore them here, because we only invoke the verity path in
> > +	 * the orphan logic when i_nlink is 0.
> > +	 */
> > +	if (!inode->vfs_inode.i_nlink)
> > +		return 0;
> > +
> > +	trans = btrfs_start_transaction(root, 1);
> > +	if (IS_ERR(trans))
> > +		return PTR_ERR(trans);
> > +
> > +	ret = btrfs_del_orphan_item(trans, root, btrfs_ino(inode));
> > +	if (ret) {
> > +		btrfs_abort_transaction(trans, ret);
> > +		return ret;
> > +	}
> > +
> > +	btrfs_end_transaction(trans);
> > +	return ret;
> > +}
