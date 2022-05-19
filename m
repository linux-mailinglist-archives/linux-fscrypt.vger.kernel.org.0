Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0833952DABB
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 18:57:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229505AbiESQ5T (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 May 2022 12:57:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238895AbiESQ5R (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 May 2022 12:57:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6A1858721F;
        Thu, 19 May 2022 09:57:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 17456B82740;
        Thu, 19 May 2022 16:57:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 943CDC385AA;
        Thu, 19 May 2022 16:57:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652979433;
        bh=VEjdU82/bow48A+cyfYtA8v8UU6wb/m9JAwU69VPaVA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=crPkALRU6wP+vnTMQkLBC/roxkASG6H7crrHLU7kNs1CK3+W8bqbDlTf9q+q4h5AZ
         xQ+Ns3/OwbMagiHBiFSMe7AkdSfP5xCdtp1caRlRF2010H0iC3Z6G0SxT54uKL5c5L
         N+iyaW7zdTbtQJVtnqvj+47XKi3igOo5r9oRkBHq8eYxnb6KbqfqYxToXDY1lYP670
         WIjOpqcss6/MY8r8FiqwEsdzddgIRlalobRZO85e399emQpy5r6dYpQgrRlXlz/bDs
         atnZz6+vkvMp1AwUHog4riQrCfzjsvE2krFYH54AWeCpCjRmhEE5E94P1sc9SKr04z
         0IXMSiKAuE5TA==
Date:   Thu, 19 May 2022 09:57:12 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Zhang Jianhua <chris.zjh@huawei.com>, tytso@mit.edu,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next v2] fs-verity: Use struct_size() helper in
 enable_verity()
Message-ID: <YoZ26O3XCK0+7h2Y@sol.localdomain>
References: <20220519022450.2434483-1-chris.zjh@huawei.com>
 <YoW0HG+Nbg681yWL@sol.localdomain>
 <YoW25wrIAiRVifMi@sol.localdomain>
 <YoYo/XBmqn6KGz5k@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoYo/XBmqn6KGz5k@hovoldconsulting.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, May 19, 2022 at 01:24:45PM +0200, Johan Hovold wrote:
> On Wed, May 18, 2022 at 08:17:59PM -0700, Eric Biggers wrote:
> > On Wed, May 18, 2022 at 08:06:04PM -0700, Eric Biggers wrote:
> > > On Thu, May 19, 2022 at 10:24:50AM +0800, Zhang Jianhua wrote:
> > > > Also, address the following sparse warning:
> > > > fs/verity/enable.c:205:28: warning: using sizeof on a flexible structure
> > > 
> > > How can I reproduce this warning?  I am using the latest version of sparse, and
> > > I don't see any of these warnings you're reporting.
> > > 
> > > $ sparse --version
> > > v0.6.4
> > > $ make C=2 fs/verity/
> > >   CHECK   scripts/mod/empty.c
> > >   CALL    scripts/checksyscalls.sh
> > >   CALL    scripts/atomic/check-atomics.sh
> > >   DESCEND objtool
> > >   CHECK   fs/verity/enable.c
> > >   CHECK   fs/verity/hash_algs.c
> > >   CHECK   fs/verity/init.c
> > >   CHECK   fs/verity/measure.c
> > >   CHECK   fs/verity/open.c
> > >   CHECK   fs/verity/read_metadata.c
> > >   CHECK   fs/verity/verify.c
> > >   CHECK   fs/verity/signature.c
> > > 
> > 
> > 'make C=2 CHECK="sparse -Wflexible-array-sizeof"' does the trick.  However, it
> > produces a *lot* of warnings all over the place.
> > 
> > Unless there is an effort to actually address all of these so that this warning
> > can be enabled by default, I don't see the poinnt in addressing these just for
> > the warnings sake.  The change to fsverity_ioctl_measure() is definitely just
> > for the warning's sake, so I don't really want to do that one.  The change to
> > enable_verity() is a bit less useless, so I could still take that one.
> 
> Importantly, struct_size() still relies on sizeof() so this has zero
> effect on those sparse warnings.
> 

Yeah, you're right.  In fact struct_size() generates two warnings, whereas
directly writing sizeof only generates 1!  So clearly sparse's
-Wflexible-array-sizeof warning is useless as-is.

I'm still keeping this patch, but I updated the commit message to not claim that
it addresses a sparse warning.  Now it's just:

    fs-verity: Use struct_size() helper in enable_verity()

    Follow the best practice for allocating a variable-sized structure.

- Eric
