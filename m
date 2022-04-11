Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 631414FBEC5
	for <lists+linux-fscrypt@lfdr.de>; Mon, 11 Apr 2022 16:16:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346986AbiDKOS0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 11 Apr 2022 10:18:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347158AbiDKOR3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 11 Apr 2022 10:17:29 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEF7D13F6E;
        Mon, 11 Apr 2022 07:14:56 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out1.suse.de (Postfix) with ESMTP id 54AA6210E3;
        Mon, 11 Apr 2022 14:14:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1649686495;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xAV7PZtZa1/q3Byq00oQJjXQLIfNCIYGqpoVQIgdBaA=;
        b=STMO/2Saod2TnGj3mehgEezpd2zGo/nuXeJnMrJIoYC+fU8EPr3F6/Thn1Y2UZtFaaYUzT
        D9NwX7CKgDRkAWPKNki1c6Yf1cKpsPvU+xU0/LUlJBRMgDenvqjnnINHOR71VmNfkzoZc4
        XjmQ5G2w2mLztNt2dIGwkRtcO1xRLNE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1649686495;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=xAV7PZtZa1/q3Byq00oQJjXQLIfNCIYGqpoVQIgdBaA=;
        b=5AP2QO3JxOmFIFJzaWtvRzneJoAAM1G9LBxZV2lT2wp2yMgmgB5oSRMw6MBqiM/11UYzn+
        Go+lyQ1Cg2oyfKCw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 83F01A3B99;
        Mon, 11 Apr 2022 14:14:54 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 29582DA7DA; Mon, 11 Apr 2022 16:10:50 +0200 (CEST)
Date:   Mon, 11 Apr 2022 16:10:50 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Eryu Guan <guan@eryu.me>
Cc:     Boris Burkov <boris@bur.io>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH v8 3/5] btrfs: test btrfs specific fsverity corruption
Message-ID: <20220411141050.GJ15609@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Eryu Guan <guan@eryu.me>,
        Boris Burkov <boris@bur.io>, fstests@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com
References: <cover.1647461985.git.boris@bur.io>
 <fd69c62b9971d446f53ba3d168625fb3a3468882.1647461985.git.boris@bur.io>
 <YlLvUCWvx3fK2ocg@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlLvUCWvx3fK2ocg@desktop>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Apr 10, 2022 at 10:53:04PM +0800, Eryu Guan wrote:
> On Wed, Mar 16, 2022 at 01:25:13PM -0700, Boris Burkov wrote:
> > There are some btrfs specific fsverity scenarios that don't map
> > neatly onto the tests in generic/574 like holes, inline extents,
> > and preallocated extents. Cover those in a btrfs specific test.
> > 
> > This test relies on the btrfs implementation of fsverity in the patch:
> > btrfs: initial fsverity support
> > 
> > and on btrfs-corrupt-block for corruption in the patches titled:
> > btrfs-progs: corrupt generic item data with btrfs-corrupt-block
> > btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block
> > 
> > Signed-off-by: Boris Burkov <boris@bur.io>
> > ---
> >  tests/btrfs/290     | 168 ++++++++++++++++++++++++++++++++++++++++++++
> >  tests/btrfs/290.out |  25 +++++++
> >  2 files changed, 193 insertions(+)
> >  create mode 100755 tests/btrfs/290
> >  create mode 100644 tests/btrfs/290.out
> > 
> > diff --git a/tests/btrfs/290 b/tests/btrfs/290
> > new file mode 100755
> > index 00000000..f9acd55a
> > --- /dev/null
> > +++ b/tests/btrfs/290
> > @@ -0,0 +1,168 @@
> > +#! /bin/bash
> > +# SPDX-License-Identifier: GPL-2.0
> > +# Copyright (C) 2021 Facebook, Inc. All Rights Reserved.
> 
> I noticed that all patches have 2021 in copyright statement, should be
> updated to 2022?
> 
> And I'd like btrfs folks to help review these 2 btrfs specific tests.

I did not do a deep review so no rev-by tag, but overall it looks sane
to me, also we'd rather like to have some fsverity tests in the suite
and fix them later eventually than nothing.
