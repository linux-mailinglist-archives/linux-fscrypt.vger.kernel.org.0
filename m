Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69575175AA
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 May 2022 19:19:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384908AbiEBRWm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 May 2022 13:22:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1378055AbiEBRWm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 May 2022 13:22:42 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21D42A1B3;
        Mon,  2 May 2022 10:19:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A072161387;
        Mon,  2 May 2022 17:19:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA972C385A4;
        Mon,  2 May 2022 17:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651511952;
        bh=CtRpX1tdcltC56Fv1eZRdGrqwoNvl2NEMPN+4Lp1ZSA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=i/x1wgrcgzDeaMLiYZ9AdDxoIXX/UruxTSQOa9XzRsHjlfMBMUp49E5LKJgYRqMuK
         +2zP0vkleiNW4OvfODRHSPwBzeWIZFEPUzJ+PWFLt2M4hNlPfQad76DxIT3NHBzQdZ
         HqQBrnNvUkaGYwSauo7O0eXkFe0RQLw+bK8cupKoZNdwhHjg5GMNduHLMaDyNtTYt6
         yixey9gsNdzb6VyhqqgENzWLErp26zvcXVRwvaERes4gjqnOmrzTjeN5lueVFj8XCq
         tlWN9dKs2Bf/di6IL5CFnUa/aFHQaOE7yvTCBHt4ABRH12mEN6AeHsvql77um9kRKQ
         LIpivkerkzbFw==
Date:   Mon, 2 May 2022 10:19:10 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     tytso <tytso@mit.edu>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
Subject: Re: [xfstests PATCH 1/2] ext4/053: update the test_dummy_encryption
 tests
Message-ID: <YnASjrPbudBXCYfK@sol.localdomain>
References: <20220501051928.540278-1-ebiggers@kernel.org>
 <20220501051928.540278-2-ebiggers@kernel.org>
 <Ym/Sk7D17iCeQIJa@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Ym/Sk7D17iCeQIJa@mit.edu>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, May 02, 2022 at 05:46:11AM -0700, tytso wrote:
> On Sat, Apr 30, 2022 at 10:19:27PM -0700, Eric Biggers wrote:
> > 
> > The kernel patch "ext4: only allow test_dummy_encryption when supported"
> > will tighten the requirements on when the test_dummy_encryption mount
> > option will be accepted.  Update ext4/053 accordingly.
> 
> One of the problems with ext4/053 is that it is very implementation
> dependent.  It was useful when we were making the change to the new
> mount API, but the problem is any future changes to the mount option
> handling is going to break the patch.
> 
> So for example, the kernel patch which Eric has proposed, "ext4: only
> allow test_dummy_encryption when supported", breaks ext4/053, which I
> noted in the review the patch.  But then this patch will break kernels
> as they currently stand without this patch, and for kernels that
> haven't moved to the new mount API, fixing it is going to be a mess.
> 
> Perhaps ext4/053 is still useful in that it will flag changes that
> might unintentionally make user-visible changes mount options handling
> in ext4, but for cases like this one, where we are changing a mount
> option which is really intended for kernel developers, perhaps the
> right approach here is to just remove the parts of ext4/053 that are
> testing the behaviour of test_dummy_encryption in such a
> super-nit-picky way?
> 
> What do folks think?

I'd like to keep the test_dummy_encryption test cases.  Trying to add a couple
new test cases (patch 2) actually found a regression.

We could gate them on the kernel version, similar to the whole ext4/053 which
already only runs on kernel version 5.12.  (Kernel versions checks suck, but
maybe it's the right choice for this very-nit-picky test.)  Alternatively, I
could just backport "ext4: only allow test_dummy_encryption when supported" to
5.15, which would be the only relevant LTS kernel version.

> 
> > Move the test cases to later in the file to group them with the other
> > test cases that use do_mkfs to add custom mkfs options instead of using
> > the "default" filesystem that the test creates at the beginning.
> 
> Note: this patch doesn't apply because ext4/053 currently has this
> line:
> 
> 		not_mnt test_dummy_encryption=v3
> 
> and the patch is trying to remove this line in the first patch chunk:
> 
> 		mnt test_dummy_encryption=v3 ^test_dummy_encryption=v3
> 
> I checked the upstream version of ext4/053 just in case I had some
> local modification of ext4/053 in my tree via "git diff -r
> origin/master tests/ext4/053" but that returned no deltas.
> 
> Eric, do you have a local modification to this test in your tree
> already, perhaps?

Sorry about that; as I mentioned in the cover letter, this is based on my other
patch "ext4/053: fix the rejected mount option testing".  As-is, 'not_mnt'
doesn't really work at all, so I wanted to fix that first.

- Eric
