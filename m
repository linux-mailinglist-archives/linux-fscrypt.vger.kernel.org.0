Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EC10E504D32
	for <lists+linux-fscrypt@lfdr.de>; Mon, 18 Apr 2022 09:25:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230316AbiDRH1m (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 18 Apr 2022 03:27:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234151AbiDRH1l (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 18 Apr 2022 03:27:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B28C15F8C
        for <linux-fscrypt@vger.kernel.org>; Mon, 18 Apr 2022 00:25:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E4AF61011
        for <linux-fscrypt@vger.kernel.org>; Mon, 18 Apr 2022 07:25:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C115C385A7;
        Mon, 18 Apr 2022 07:25:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650266702;
        bh=j4xs7SkMmhm2j04X/afnhRDKOBRxj9u003+VEQ5Rp7A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MKa5wxuooDkf/4GgnxmSxizXnkiAvZOp7FfYTfGWJNvjO0CLS9kLn8rnWWvX+Pbu6
         hvl6xhKlTBWJrdEgf1hMj3IVcwLo+lxbTgF6o69qRW6b33yz3aqpuHVc4KFxwyipLU
         shCdNy9xDCLUCXkbBjL786d5ZFde9/05EWWdazGg9c92HO0+19VMwOl8+htM3ZDI4h
         VDf4y1s/YyOnJTG/oloAe793+Gs2tvSJeRjgEN1morySx5JzujYvyZhOttJpz0nNJZ
         UvyO+I2YjLwDXoXVjKO+4YHYSp1Att4Gd6CQsdz75GhgOdh5du0/1/Ml3OcXhudWJk
         xVYhERk3f29FQ==
Date:   Mon, 18 Apr 2022 00:25:00 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     =?utf-8?B?5bi45Yek5qWg?= <changfengnan@vivo.com>
Cc:     "tytso@mit.edu" <tytso@mit.edu>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: why fscrypt_mergeable_bio use logical block number?
Message-ID: <Yl0STBXYgZC3GvQW@sol.localdomain>
References: <KL1PR0601MB4003998B841513BCAA386ADEBBEE9@KL1PR0601MB4003.apcprd06.prod.outlook.com>
 <Ylm+VyMLzJ92yndr@gmail.com>
 <KL1PR0601MB40035814CF8324474BC543B2BBF09@KL1PR0601MB4003.apcprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <KL1PR0601MB40035814CF8324474BC543B2BBF09@KL1PR0601MB4003.apcprd06.prod.outlook.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Apr 17, 2022 at 02:34:17AM +0000, 常凤楠 wrote:
> 
> 
> > -----Original Message-----
> > From: Eric Biggers <ebiggers@kernel.org>
> > Sent: Saturday, April 16, 2022 2:50 AM
> > To: 常凤楠 <changfengnan@vivo.com>
> > Cc: tytso@mit.edu; jaegeuk@kernel.org; linux-fscrypt@vger.kernel.org
> > Subject: Re: why fscrypt_mergeable_bio use logical block number?
> > 
> > On Fri, Apr 15, 2022 at 08:18:11AM +0000, 常凤楠 wrote:
> > > Hi:
> > > 	When I dig into a problem, I found: bio merge may reduce a lot when
> > > 	enable inlinecrypt, the root cause is fscrypt_mergeable_bio use logical
> > > 	block number rather than physical block number. I had read the UFSHCI,
> > > 	but not see any description about why data unit number shoud use
> > logical
> > > 	block number. I want to know why, Is the anyone can explain this?
> > >
> > > Thanks.
> > > Fengnan Chang.
> > 
> > The main reason that fscrypt generates IVs using the file logical block number
> > instead of the sector number is because f2fs needs to move data blocks
> > around without the key.  That would be impossible with sector number
> > based encryption.
> So if use sector number to generate IVs, after f2fs move data blocks in gc, we can
> not decrypt correctly, am I right ?

Yes, that's correct.

> > 
> > There are other reasons too.  Always using the file logical block number
> > keeps the various fscrypt options consistent, it works well with per-file keys, it
> > doesn't break filesystem resizing, and it avoids having the interpretation of
> > the filesystem depend on its on-disk location which would be a layering
> > violation.  But the need to support f2fs is the main one.
> > 
> > Note that by default, fscrypt uses a different key for every file, and in that case
> > the only way that using the file logical block number instead of the sector
> > number would prevent merging is if data was being read/written from a file
> > that is physically but not logically contiguous.  That's not a very common
> > case.
> This is exactly the problem I have faced. We read/write a file in physically contiguous but not logically.
> So I'm wander if we can keep physically contiguous always, can we skip check wheatear logical block 
> number is contiguous when bio merge?

No, inline encryption requires contiguous DUNs.

- Eric
