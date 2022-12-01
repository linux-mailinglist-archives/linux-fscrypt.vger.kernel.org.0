Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 68D9763F98D
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Dec 2022 22:10:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230083AbiLAVKV (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 1 Dec 2022 16:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33166 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229967AbiLAVKV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 1 Dec 2022 16:10:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56B29BEE19;
        Thu,  1 Dec 2022 13:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7916462121;
        Thu,  1 Dec 2022 21:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD9C8C433D6;
        Thu,  1 Dec 2022 21:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669929016;
        bh=Tw0moB5gNQBwfnqISVjz/I0T0nL1A+tdOcbPHPWK5Po=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jMpoxW0TJWvAgr66A0bUX3277ng0uH+I/rNaHt+AtAjERFEGpiyHa4SmDzbaBTrl1
         XwCKGkLE9Gg7DDo81gS+12iMVzRwyzmTK0DoKzftf7fuj78NGo61cctCXN+Na8a65M
         pd0P5B1Yl8DpXriLuH3OHPks4kxCLv4McWsDdXAIS02sCYvTrgne5BaBtnpzqrG5qJ
         F5qChvWtvQ36e882W+V9AghPn56d1hn+UXMyY4IU3Bt9WJtNEBTTa3mRo2tAK633fI
         voRRqYf2H1kCSKJrzIM6gyAeWADYsQtiOPqhCxYltzr/luBYyqMG5jakM1sZv+6jEq
         NO1QA2ROD5FOQ==
Date:   Thu, 1 Dec 2022 21:10:15 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     xiubli@redhat.com
Cc:     idryomov@gmail.com, ceph-devel@vger.kernel.org, jlayton@kernel.org,
        khiremat@redhat.com, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] ceph: make sure all the files successfully put before
 unmounting
Message-ID: <Y4kYN8FPeq6NDe5i@gmail.com>
References: <20221201065800.18149-1-xiubli@redhat.com>
 <Y4j+Ccqzi6JxWchv@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4j+Ccqzi6JxWchv@sol.localdomain>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Dec 01, 2022 at 11:18:33AM -0800, Eric Biggers wrote:
> On Thu, Dec 01, 2022 at 02:58:00PM +0800, xiubli@redhat.com wrote:
> > From: Xiubo Li <xiubli@redhat.com>
> > 
> > When close a file it will be deferred to call the fput(), which
> > will hold the inode's i_count. And when unmounting the mountpoint
> > the evict_inodes() may skip evicting some inodes.
> > 
> > If encrypt is enabled the kernel generate a warning when removing
> > the encrypt keys when the skipped inodes still hold the keyring:
> 
> This does not make sense.  Unmounting is only possible once all the files on the
> filesystem have been closed.
> 

Specifically, __fput() puts the reference to the dentry (and thus the inode)
*before* it puts the reference to the mount.  And an unmount cannot be done
while the mount still has references.  So there should not be any issue here.

- Eric
