Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C86846F8C79
	for <lists+linux-fscrypt@lfdr.de>; Sat,  6 May 2023 00:40:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233502AbjEEWka (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 5 May 2023 18:40:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50316 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233400AbjEEWk3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 5 May 2023 18:40:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A59449C5
        for <linux-fscrypt@vger.kernel.org>; Fri,  5 May 2023 15:40:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2A32640F7
        for <linux-fscrypt@vger.kernel.org>; Fri,  5 May 2023 22:40:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1BB56C433D2;
        Fri,  5 May 2023 22:40:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1683326427;
        bh=2kcbvZ3vtrJvQVF2SOpsg65QX8fpckWqOctBUmyn0Rg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vBFqotkVmMQOvFGOyirD39HUqWhJQHDPFw6+pnik7KJXBJa7aA05+G4qj+dXcdC5f
         6u8EJWPgmdIUI8R+ApeSVZE9sjHsCHEDhYovzUj48n2o6qV7rcXH6wvVInAIB2DSsj
         8aVcM91Mr74vf46AMyykA1TkA3oV3eseBdfX9sOeEnAZAbNHwC38e68ktQE2P9h7dy
         dYYVZccozLNaSJOZo9OBH8o8QuYc4ovIrjj+JCLYbutrqCLSfoEG8WeIU4mFqwF0DA
         gQZ1f8zEhsInDNLWXn4LyEFdhQnJ1UqbP3eZeMIHuaGN4q1JpkEbsQtabSkh4lxAq6
         oEW3Ag+7gPPVg==
Date:   Fri, 5 May 2023 22:40:13 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v1 0/7] fscrypt: add pooled prepared keys facility
Message-ID: <ZFWFzUE6r30yVPB+@gmail.com>
References: <cover.1681871298.git.sweettea-kernel@dorminy.me>
 <20230502034736.GA1131@sol.localdomain>
 <e7ee1491-e67c-6461-8825-6f39bf723c86@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7ee1491-e67c-6461-8825-6f39bf723c86@dorminy.me>
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, May 05, 2023 at 08:15:44AM -0400, Sweet Tea Dorminy wrote:
> 
> > As I mentioned earlier
> > (https://lore.kernel.org/r/Y7NQ1CvPyJiGRe00@sol.localdomain),
> > blk-crypto-fallback actually already solved the problem of caching
> > crypto_skcipher objects for I/O.  And, it's possible for a filesystem to *only*
> > support blk-crypto, not filesystem-layer contents encryption.  You'd just need
> > to put btrfs encryption behind a new kconfig option that is automatically
> > selected by CONFIG_FS_ENCRYPTION_INLINE_CRYPT && CONFIG_BLK_ENCRYPTION_FALLBACK.
> > 
> > (BTW, I'm thinking of simplifying the kconfig options by removing
> > CONFIG_FS_ENCRYPTION_INLINE_CRYPT.  Then, the blk-crypto code in fs/crypto/ will
> > be built if CONFIG_FS_ENCRYPTION && CONFIG_BLK_INLINE_ENCRYPTION.)
> > 
> > Indeed, filesystem-layer contents encryption is a bit redundant these days now
> > that blk-crypto-fallback exists.  I'm even tempted to make ext4 and f2fs support
> > blk-crypto only someday.  That was sort of the original plan, actually...
> > 
> > So, I'm wondering if you've considered going the blk-crypto-fallback route?
> 
> I did, and gave it a shot, but ran into problems because as far as I can
> tell it requires having a bio to crypt. For verity data and inline extents,
> there's no obvious bio, and even if we tried to construct a bio pointing at
> the relevant data, it's not necessarily sector- sized or aligned. I couldn't
> figure out a good way to make it work, but maybe it's better to special-case
> those or there's something I'm not seeing.

ext4 and f2fs just don't use inline data on encrypted files.  I.e. when an encrypted file is
created, it always uses non-inline data.  Is that an option for btrfs?

For the verity metadata, how are you thinking of encrypting it, exactly?  Verity metadata is
immutable once written, so surely it avoids many of the issues you are dealing with for extents?  It
should just need one key, and that key could be set up at file open time.  So I don't think it will
need the key pool at all?

- Eric
