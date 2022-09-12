Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FAC25B529A
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Sep 2022 03:50:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiILBuM (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 11 Sep 2022 21:50:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiILBuK (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 11 Sep 2022 21:50:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E35281570D;
        Sun, 11 Sep 2022 18:50:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 90D7DB80B49;
        Mon, 12 Sep 2022 01:50:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45ABEC433C1;
        Mon, 12 Sep 2022 01:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662947407;
        bh=D2iM6v0OxGuoIKxfg1+xJzgcVIbXTsO/kUbcttFOr7w=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DkAxgREOQ+dfbhFu+S0d6YC8tBTIKu9LQbMO6Y9Acic5bP1Me1LI0PTEGtQZULfiZ
         xHG8vBoBKQkdrcYqRyxM6DyqVWOPjARZoN22PlBhOp/en04cTbuyekqsirgIzhHqxF
         x7WuLGO2vHLWOZnvN8VYjeDpeV96UYOKgfY1tK+UTobShgKj79xNjE9XcPen+6pRt1
         0uAPyD8CSUtiodLsriy02e9JHRwdG512LS0tvy6INGVXw2WqBezmfNWVWdkqWFAh6y
         kdc3RDqXMbqUeQpy8sKVDLe70RtORen2y5o9dEktRv95j73B5U5ZQgUFZD6o5gqoZg
         63MjjnwMwS7Og==
Date:   Sun, 11 Sep 2022 20:50:00 -0500
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     dsterba@suse.cz, "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        Omar Sandoval <osandov@osandov.com>
Subject: Re: [PATCH v2 12/20] btrfs: start using fscrypt hooks.
Message-ID: <Yx6QSPWiLCO46pzD@quark>
References: <cover.1662420176.git.sweettea-kernel@dorminy.me>
 <4b27b127a4048a58af965634436b562ec1217c82.1662420176.git.sweettea-kernel@dorminy.me>
 <20220907201717.GK32411@twin.jikos.cz>
 <24ea47b2-ec19-afdd-3faa-c3d86c6d498e@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24ea47b2-ec19-afdd-3faa-c3d86c6d498e@dorminy.me>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Sep 07, 2022 at 04:42:40PM -0400, Sweet Tea Dorminy wrote:
> 
> > > diff --git a/fs/btrfs/file.c b/fs/btrfs/file.c
> > > index 7216ac1f860c..929a0308676c 100644
> > > --- a/fs/btrfs/file.c
> > > +++ b/fs/btrfs/file.c
> > > @@ -3695,6 +3695,9 @@ static int btrfs_file_open(struct inode *inode, struct file *filp)
> > >   	int ret;
> > >   	filp->f_mode |= FMODE_NOWAIT | FMODE_BUF_RASYNC;
> > > +	ret = fscrypt_file_open(inode, filp);
> > > +	if (ret)
> > > +		return ret;
> > >   	ret = fsverity_file_open(inode, filp);
> > 
> > Can fsverity and fscrypt can be used at the same time?
> 
> Yes, and there's a fstest, generic/576, checking the hooks are in the right
> order.

In order to use them at the same time, you'd need to implement encryption of the
verity metadata, which it appears you haven't done yet.  So for now it can't be
allowed by btrfs.  ext4 and f2fs get the verity metadata encryption "for free"
because they store it appended to the file contents.  That's why ext4 and f2fs
allow fscrypt+fsverity together.  However, btrfs stores the verity metadata
separately, so it would need to handle encrypting it explicitly.

- Eric
