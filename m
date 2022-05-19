Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C3AD652D162
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 13:24:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232705AbiESLYs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 May 2022 07:24:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232638AbiESLYs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 May 2022 07:24:48 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1AD7F43ACE;
        Thu, 19 May 2022 04:24:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9CC9B82428;
        Thu, 19 May 2022 11:24:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FE1DC385AA;
        Thu, 19 May 2022 11:24:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652959484;
        bh=JyMB6oWlyYh4PF0KpUmQD0/mP51jgsDFqsMZ8m0zokw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VyRAkZAfRGr9g54LYYckfTfgAgCxE+vaPs36oLeXEs24Oi1uPfVHksCcSDlPq1Qqu
         NwRI8Qr2WnYTk5jn5W0+19n6d6s/Fa6XODrtNw6jrAdkdUuw1fJA53CUhUhLnGwYz2
         JxKQZosQF1s2+Jk2520HAUxNAPoxZjjCcNvMkOJV9mhWPteAOYqfzx2eav6q8GDlwR
         r9FFmIkD1WE+9eAEmvBB5N6HrNtqiTEEKZ9gmGgU3trrssGPI7+3yXmoipZgoyZpUd
         RvANRPm2J2Q1Eu/TMiMn44oi55JZbCA7PGzhZaCoglZNROKCZcXalGAXdWIYSgRCIA
         IWEA3w2HUcfZA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1nreGr-0006gR-Nn; Thu, 19 May 2022 13:24:46 +0200
Date:   Thu, 19 May 2022 13:24:45 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Zhang Jianhua <chris.zjh@huawei.com>, tytso@mit.edu,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next v2] fs-verity: Use struct_size() helper in
 enable_verity()
Message-ID: <YoYo/XBmqn6KGz5k@hovoldconsulting.com>
References: <20220519022450.2434483-1-chris.zjh@huawei.com>
 <YoW0HG+Nbg681yWL@sol.localdomain>
 <YoW25wrIAiRVifMi@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoW25wrIAiRVifMi@sol.localdomain>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 18, 2022 at 08:17:59PM -0700, Eric Biggers wrote:
> On Wed, May 18, 2022 at 08:06:04PM -0700, Eric Biggers wrote:
> > On Thu, May 19, 2022 at 10:24:50AM +0800, Zhang Jianhua wrote:
> > > Also, address the following sparse warning:
> > > fs/verity/enable.c:205:28: warning: using sizeof on a flexible structure
> > 
> > How can I reproduce this warning?  I am using the latest version of sparse, and
> > I don't see any of these warnings you're reporting.
> > 
> > $ sparse --version
> > v0.6.4
> > $ make C=2 fs/verity/
> >   CHECK   scripts/mod/empty.c
> >   CALL    scripts/checksyscalls.sh
> >   CALL    scripts/atomic/check-atomics.sh
> >   DESCEND objtool
> >   CHECK   fs/verity/enable.c
> >   CHECK   fs/verity/hash_algs.c
> >   CHECK   fs/verity/init.c
> >   CHECK   fs/verity/measure.c
> >   CHECK   fs/verity/open.c
> >   CHECK   fs/verity/read_metadata.c
> >   CHECK   fs/verity/verify.c
> >   CHECK   fs/verity/signature.c
> > 
> 
> 'make C=2 CHECK="sparse -Wflexible-array-sizeof"' does the trick.  However, it
> produces a *lot* of warnings all over the place.
> 
> Unless there is an effort to actually address all of these so that this warning
> can be enabled by default, I don't see the poinnt in addressing these just for
> the warnings sake.  The change to fsverity_ioctl_measure() is definitely just
> for the warning's sake, so I don't really want to do that one.  The change to
> enable_verity() is a bit less useless, so I could still take that one.

Importantly, struct_size() still relies on sizeof() so this has zero
effect on those sparse warnings.

Johan
