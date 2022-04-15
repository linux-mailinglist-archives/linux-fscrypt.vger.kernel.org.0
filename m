Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B45F502ED8
	for <lists+linux-fscrypt@lfdr.de>; Fri, 15 Apr 2022 20:51:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235432AbiDOSw6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 15 Apr 2022 14:52:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244409AbiDOSwc (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 15 Apr 2022 14:52:32 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F27F5E162
        for <linux-fscrypt@vger.kernel.org>; Fri, 15 Apr 2022 11:50:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A12BB82CE7
        for <linux-fscrypt@vger.kernel.org>; Fri, 15 Apr 2022 18:50:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1494C385A4;
        Fri, 15 Apr 2022 18:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650048601;
        bh=W842dY530zIns+8SLocRvyPDSfGVi7UZi1XBjNHKlyk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iHFSSWpON+T72nCUZLSB4eVQdVtUkUYDrIFa/5/sJgIrUY1dy0RXq9wNLNqTm9e7m
         znYafCp5Ldhku7brEzMHP4FxYVyG9SBNtn0476CZ/cvh9kaCiHhXI8gpHJK7u1ZFbx
         vskOtsVYNvgBY699eNDl7eaaZ/rAX+UpjvaiieWJ995pFhzqHffDL9S6E1QcfhsXWk
         H3Gmpi1aSfAQK2z5XXMfm3RrNo/q8G4Fr2VYia7BhjNU+GmdDZ11aUDMjfZyMBCa3B
         p5WcemwXgYsiP/0m3pFzNex5MF6XbX7C9YFYRFRaIR6V8MaqFJmkeDAvQwY/QYWvVO
         BPouLdaY6EVUg==
Date:   Fri, 15 Apr 2022 18:49:59 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     =?utf-8?B?5bi45Yek5qWg?= <changfengnan@vivo.com>
Cc:     "tytso@mit.edu" <tytso@mit.edu>,
        "jaegeuk@kernel.org" <jaegeuk@kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>
Subject: Re: why fscrypt_mergeable_bio use logical block number?
Message-ID: <Ylm+VyMLzJ92yndr@gmail.com>
References: <KL1PR0601MB4003998B841513BCAA386ADEBBEE9@KL1PR0601MB4003.apcprd06.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <KL1PR0601MB4003998B841513BCAA386ADEBBEE9@KL1PR0601MB4003.apcprd06.prod.outlook.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Apr 15, 2022 at 08:18:11AM +0000, 常凤楠 wrote:
> Hi:
> 	When I dig into a problem, I found: bio merge may reduce a lot when
> 	enable inlinecrypt, the root cause is fscrypt_mergeable_bio use logical
> 	block number rather than physical block number. I had read the UFSHCI,
> 	but not see any description about why data unit number shoud use logical
> 	block number. I want to know why, Is the anyone can explain this?
> 
> Thanks.
> Fengnan Chang.

The main reason that fscrypt generates IVs using the file logical block number
instead of the sector number is because f2fs needs to move data blocks around
without the key.  That would be impossible with sector number based encryption.

There are other reasons too.  Always using the file logical block number keeps
the various fscrypt options consistent, it works well with per-file keys, it
doesn't break filesystem resizing, and it avoids having the interpretation of
the filesystem depend on its on-disk location which would be a layering
violation.  But the need to support f2fs is the main one.

Note that by default, fscrypt uses a different key for every file, and in that
case the only way that using the file logical block number instead of the sector
number would prevent merging is if data was being read/written from a file that
is physically but not logically contiguous.  That's not a very common case.

- Eric
