Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C9A0C598AB9
	for <lists+linux-fscrypt@lfdr.de>; Thu, 18 Aug 2022 19:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240238AbiHRRvz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 18 Aug 2022 13:51:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52468 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239324AbiHRRvy (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 18 Aug 2022 13:51:54 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 012F5C6B51;
        Thu, 18 Aug 2022 10:51:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A9442B8221C;
        Thu, 18 Aug 2022 17:51:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27F25C433C1;
        Thu, 18 Aug 2022 17:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660845111;
        bh=tivNZwoj3zZKzgBW1fvdHFOuwBNUa53rvoT4SpXblRE=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=tcF3WSyhtXzrWSXkHXeI0UgqjSs8Mpm6SDzFicIvGqUu618Wl0utxhf3kKN2EbJN9
         9i8dcQuJ6yaGKBDEoystxs/PJYrIL+YRgBGTX2//PEe0oUOkbM0Coyd8yI8h92YH4q
         aVgXAurUsqMLXCoO8nzzCKCVWHd/8zz1275Lll4Oom43jQDYqlMccyH8EjS0cIR2XY
         VEMV83DDohdc9Turk1mVWkapC8Vh8C5+Dd93ogQ/JZnj4Ye1VRfr8ksnOGDzsCObR0
         FQ95H1idY+Y93RB1YaVyJ89dNnFdvOk+zGwv0nEfG4PkF9LLVDcmCIROO61MvyrbFC
         sxl3bHq2ILqYw==
Date:   Thu, 18 Aug 2022 17:51:49 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     dsterba@suse.cz, Boris Burkov <boris@bur.io>,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v4] btrfs: send: add support for fs-verity
Message-ID: <Yv58NctXwBzG1Ry1@gmail.com>
References: <0561e8a33f991fa15053054b7b089d176fde6523.1660596577.git.boris@bur.io>
 <Yv3GssrE8hAFzGLJ@sol.localdomain>
 <20220818174010.GO13489@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220818174010.GO13489@twin.jikos.cz>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Aug 18, 2022 at 07:40:10PM +0200, David Sterba wrote:
> On Wed, Aug 17, 2022 at 09:57:22PM -0700, Eric Biggers wrote:
> > On Mon, Aug 15, 2022 at 01:54:28PM -0700, Boris Burkov wrote:
> > > diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> > > index e7671afcee4f..9e8679848d54 100644
> > > --- a/fs/btrfs/send.c
> > > +++ b/fs/btrfs/send.c
> > > @@ -3,6 +3,7 @@
> > >   * Copyright (C) 2012 Alexander Block.  All rights reserved.
> > >   */
> > >  
> > > +#include "linux/compiler_attributes.h"
> > 
> > I don't understand the purpose of this include.  And why is it in quotes?
> 
> It compiles without it so I've deleted it.
> 
> > 
> > Otherwise this patch looks good to me.
> 
> I assume it's acked-by/reviewed-by namely for the fs-verity changes,
> right?

Yes if you're just fixing that without a new version, you can add:

Acked-by: Eric Biggers <ebiggers@google.com>

(By the way, please fix your email client to not generate a Mail-Followup-To
header, as it causes replies to move everyone to "To".  If you're using mutt,
you need 'set followup_to = no' in your muttrc.)

- Eric
