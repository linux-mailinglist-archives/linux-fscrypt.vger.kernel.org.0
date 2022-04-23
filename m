Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 072AD50C5DA
	for <lists+linux-fscrypt@lfdr.de>; Sat, 23 Apr 2022 03:00:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229965AbiDWBDA (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 22 Apr 2022 21:03:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41036 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229785AbiDWBC7 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 22 Apr 2022 21:02:59 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B30D5527C9;
        Fri, 22 Apr 2022 18:00:03 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4FB80B83344;
        Sat, 23 Apr 2022 01:00:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D0332C385A4;
        Sat, 23 Apr 2022 01:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650675601;
        bh=3L5PJgdEy97z+D+D0QAwn839C0O1ozkKJYjxHicbAqg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gUVj69+/VZcfRYpID6zkGH9kH8dsghdv7gMri0/JwevJnXBtqjgVJgUxcN3vriRsU
         Fb5eqIcPLj5CeL3cJPOMkr1Y1h3VZueWo7XFxpB9cFil1oP8DTzL8e2zbEj5sQN2nF
         7Hrpn05NhxF7foFFT73x+VhvwddvvhPClaPm2OlJYsnkQuSs/PKxyR92IVqo6gEWwv
         oKVD5w+NYdnmSUAR4dlCbi3wXRr4zv1xJRUSgPh6m715Aw8OKK6PL2RzB2SVK6GQkQ
         5D+ZaqdqrNoCuUf5ITmmg21ppcfCpKB2WtvIlZbs91RseZ7oXs0p/iJ8C6f8WrZg6h
         3G1OkYwnFOcCQ==
Date:   Fri, 22 Apr 2022 17:59:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v8 2/5] common/verity: support btrfs in generic fsverity
 tests
Message-ID: <YmNPhzTpoE9jIU4D@sol.localdomain>
References: <cover.1647461985.git.boris@bur.io>
 <9c64fbf9ad37dc84a31caf91762edd64b33d59db.1647461985.git.boris@bur.io>
 <YjN7Dc9aTD2FHTTO@gmail.com>
 <YmM54bCgX6Kz2XVX@zen>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YmM54bCgX6Kz2XVX@zen>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Apr 22, 2022 at 04:27:29PM -0700, Boris Burkov wrote:
> On Thu, Mar 17, 2022 at 06:16:45PM +0000, Eric Biggers wrote:
> > On Wed, Mar 16, 2022 at 01:25:12PM -0700, Boris Burkov wrote:
> > > generic/572-579 have tests for fsverity. Now that btrfs supports
> > > fsverity, make these tests function as well. For a majority of the tests
> > > that pass, simply adding the case to mkfs a btrfs filesystem with no
> > > extra options is sufficient.
> > > 
> > > However, generic/574 has tests for corrupting the merkle tree itself.
> > > Since btrfs uses a different scheme from ext4 and f2fs for storing this
> > > data, the existing logic for corrupting it doesn't work out of the box.
> > > Adapt it to properly corrupt btrfs merkle items.
> > > 
> > > 576 does not run because btrfs does not support transparent encryption.
> > > 
> > > This test relies on the btrfs implementation of fsverity in the patch:
> > > btrfs: initial fsverity support
> > > 
> > > and on btrfs-corrupt-block for corruption in the patches titled:
> > > btrfs-progs: corrupt generic item data with btrfs-corrupt-block
> > > btrfs-progs: expand corrupt_file_extent in btrfs-corrupt-block
> > > 
> > > Signed-off-by: Boris Burkov <boris@bur.io>
> > > ---
> > >  common/btrfs  |  5 +++++
> > >  common/config |  1 +
> > >  common/verity | 23 +++++++++++++++++++++++
> > >  3 files changed, 29 insertions(+)
> > 
> > Reviewed-by: Eric Biggers <ebiggers@google.com>
> > 
> > - Eric
> 
> Eric,
> 
> Unfortunately, I think I found a more serious problem with the
> compatibility of generic/574 and btrfs while working on testing the
> enable/disable sysctls.
> 
> I realized that I had forgotten to customize the mount options for btrfs
> to use "nodatasum" and as a result, this test was passing for btrfs
> inappropriately, since we were getting EIOs for failing data checksums,
> not verity checks.
> 
> I fixed the mount option issue only to realize that some of the test
> cases make assumptions that don't apply to btrfs. For example:
> "corruption_test 130999 131000 72"
> 
> Btrfs zeros pages past EOF in readpage before they make it to the user
> via read or mmap, and the fsverity check is done at that point, so
> corrupting the disk past EOF does not cause a verity failure (or get
> leaked to the user) but it does cause csum failures since those are done
> on bios, like verity checks in ext4. I verified that removing that
> zeroing in readpage makes the test case pass.
> 
> Do you have a preference for how I might fix this? My first thought is
> to try to factor out any such test cases into a new test with a new
> requires clause that btrfs fails but ext4/f2fs pass, kind of like what
> we did for the EFBIG test for future FSes that might not logically
> address the Merkle tree in the past-EOF space.

The reason that an error is expected for corruption past EOF in the block
containing EOF, is to ensure that the bad data isn't visible via mmap reads.  If
that's not a problem for btrfs due to it always zeroing the part past EOF, I
think it would be fine to change that test case (specifically the one with
parameters "corruption_test 130999 131000 72") to just try a mmap read of the
whole EOF block, and check that it either fails with an error *or* returns
zeroes.  I don't think that an entirely new test script would be warranted.

- Eric
