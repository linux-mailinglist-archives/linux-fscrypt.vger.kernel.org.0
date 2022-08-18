Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56888598AA5
	for <lists+linux-fscrypt@lfdr.de>; Thu, 18 Aug 2022 19:45:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345083AbiHRRp1 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 18 Aug 2022 13:45:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345082AbiHRRpZ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 18 Aug 2022 13:45:25 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [IPv6:2001:67c:2178:6::1c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F27516EF34;
        Thu, 18 Aug 2022 10:45:23 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 28F2E342D4;
        Thu, 18 Aug 2022 17:45:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1660844722;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0Cjg7cBz612uRfv/xfAQ1Sk+UdoOReoiZhjIXkb3Rag=;
        b=pIUY5xGKc351whIkrYvQbfr2IalHzUPdfuECUsbAv92oUCSHetJPdzKBzvLyCKUQXjDv1y
        JSVHGF5bMj/FN/ynrdYp5O4fqDb2Q37TMBRAUUZJVtRGOhMGIYPRvMdiSRM+9+0sCwlDQp
        p6IK7JGq7CMKnFEogfq4tzJEwojQN/I=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1660844722;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0Cjg7cBz612uRfv/xfAQ1Sk+UdoOReoiZhjIXkb3Rag=;
        b=8ScMH7P/L9IMOpuyPXftV9xejukBki1OZXS8mwt0A7vFMXLqTFkC8SUppckElpnWn3YxJ/
        h0bfYkDBLvgYDnAw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id E4794133B5;
        Thu, 18 Aug 2022 17:45:21 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id tcfCNrF6/mL0SQAAMHmgww
        (envelope-from <dsterba@suse.cz>); Thu, 18 Aug 2022 17:45:21 +0000
Date:   Thu, 18 Aug 2022 19:40:10 +0200
From:   David Sterba <dsterba@suse.cz>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v4] btrfs: send: add support for fs-verity
Message-ID: <20220818174010.GO13489@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, Eric Biggers <ebiggers@kernel.org>,
        Boris Burkov <boris@bur.io>, linux-btrfs@vger.kernel.org,
        kernel-team@fb.com, linux-fscrypt@vger.kernel.org
References: <0561e8a33f991fa15053054b7b089d176fde6523.1660596577.git.boris@bur.io>
 <Yv3GssrE8hAFzGLJ@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yv3GssrE8hAFzGLJ@sol.localdomain>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_SOFTFAIL,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Aug 17, 2022 at 09:57:22PM -0700, Eric Biggers wrote:
> On Mon, Aug 15, 2022 at 01:54:28PM -0700, Boris Burkov wrote:
> > diff --git a/fs/btrfs/send.c b/fs/btrfs/send.c
> > index e7671afcee4f..9e8679848d54 100644
> > --- a/fs/btrfs/send.c
> > +++ b/fs/btrfs/send.c
> > @@ -3,6 +3,7 @@
> >   * Copyright (C) 2012 Alexander Block.  All rights reserved.
> >   */
> >  
> > +#include "linux/compiler_attributes.h"
> 
> I don't understand the purpose of this include.  And why is it in quotes?

It compiles without it so I've deleted it.

> 
> Otherwise this patch looks good to me.

I assume it's acked-by/reviewed-by namely for the fs-verity changes,
right?
