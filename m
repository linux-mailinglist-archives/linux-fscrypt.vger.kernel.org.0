Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0A8E2581A4B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Jul 2022 21:29:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231809AbiGZT3S (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 26 Jul 2022 15:29:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGZT3R (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 26 Jul 2022 15:29:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87EA21A807;
        Tue, 26 Jul 2022 12:29:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 211086156B;
        Tue, 26 Jul 2022 19:29:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 226E2C433D7;
        Tue, 26 Jul 2022 19:29:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658863755;
        bh=WlwSgYuZ7DFZd25furNi2YJWO8JHrpAPXAv1LXJRhNI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=vIZ6FT+gIccoXebDvLukleSESPSpc77naQ7Nq5Xa8ZsRAtW6rPeZLVUx0Md888S+M
         WTw/z0N6gZJ9+VNeeBE29/EyuWIc+x9Eo1HiG3scsWcoanfMws5Qhnp4g20pPnjnZb
         eSLb9QeSc7DPTUIRQODcBmQg7CvmIdKg2+9oGeipCwkrVVMZd9wn9wZ+bEn+Fx5cGh
         VwOIrcgXYnpk9AlSrvLw/1KzWCKXQpAyS8VnZlwm2QT3s0dhi/PdqzsF0kIfrFG4gR
         tjuKtuKbdE0W0pf0LO07KgdnDXuOyCARCvLyzHkPpO4H3xjggL8xkTw/jcY1mxYqtR
         HgblGPdqp0H4g==
Date:   Tue, 26 Jul 2022 19:29:13 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, osandov@osandov.com,
        kernel-team@fb.com
Subject: Re: [PATCH RFC 4/4] fscrypt: Add new encryption policy for btrfs.
Message-ID: <YuBAiRg9K8IrlCqV@gmail.com>
References: <cover.1658623235.git.sweettea-kernel@dorminy.me>
 <675dd03f1a4498b09925fbf93cc38b8430cb7a59.1658623235.git.sweettea-kernel@dorminy.me>
 <Yt8oEiN6AkglKfIc@sol.localdomain>
 <7130dd3f-202c-2e70-c37f-57be9b85548b@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7130dd3f-202c-2e70-c37f-57be9b85548b@dorminy.me>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jul 25, 2022 at 10:16:07PM -0400, Sweet Tea Dorminy wrote:
> 
> 
> On 7/25/22 19:32, Eric Biggers wrote:
> > On Sat, Jul 23, 2022 at 08:52:28PM -0400, Sweet Tea Dorminy wrote:
> > > Certain filesystems may want to use IVs generated and stored outside of
> > > fscrypt's inode-based IV generation policies.  In particular, btrfs can
> > > have multiple inodes referencing a single block of data, and moves
> > > logical data blocks to different physical locations on disk; these two
> > > features mean inode or physical-location-based IV generation policies
> > > will not work for btrfs. For these or similar reasons, such filesystems
> > > may want to implement their own IV generation and storage for data
> > > blocks.
> > > 
> > > Plumbing each such filesystem's internals into fscrypt for IV generation
> > > would be ungainly and fragile. Thus, this change adds a new policy,
> > > IV_FROM_FS, and a new operation function pointer, get_fs_derived_iv.  If
> > > this policy is selected, the filesystem is required to provide the
> > > function pointer, which populates the IV for a particular data block.
> > > The IV buffer passed to get_fs_derived_iv() is pre-populated with the
> > > inode contexts' nonce, in case the filesystem would like to use this
> > > information; for btrfs, this is used for filename encryption.  Any
> > > filesystem using this policy is expected to appropriately generate and
> > > store a persistent random IV for each block of data.
> > 
> > This is changed from the original proposal to store just a random "starting IV"
> > per extent, right?
> 
> This is intended to be a generic interface that doesn't require any
> particular IV scheme from the filesystem. 

I don't think that's a good way to do it.  The fscrypt settings are supposed to
be very concrete, meaning that they specify a particular way of doing the
encryption, which can be reviewed for its security and which can be tested for
correctness of the on-disk format.  There shouldn't be cryptographic differences
between how different filesystems implement the same setting.

The fscrypt settings also shouldn't specify internal implementation details of
the code, as "IV_FROM_FS" does.  From userspace's perspective, *all* fscrypt
settings have IVs chosen by the filesystem; the division between the
"filesystem" and fs/crypto/ is an internal kernel implementation detail.

So I think you should go with something like RANDOM_IV or IV_PER_EXTENT.

> In practice, the btrfs side of the code is using a per-extent starting IV, as
> originally proposed. 

This is inconsistent with your commit message, which says that there is a random
IV for each block of data.  It's also inconsistent with your proposed change to
fscrypt_limit_io_blocks().  So I don't know which to believe.

Clearly this can't be properly reviewed on its own, so please send out the whole
patch series and not just the fs/crypto/ parts.

- Eric
