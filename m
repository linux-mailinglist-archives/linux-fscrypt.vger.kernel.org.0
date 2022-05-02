Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06908516FC2
	for <lists+linux-fscrypt@lfdr.de>; Mon,  2 May 2022 14:46:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1385088AbiEBMtz (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 May 2022 08:49:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239224AbiEBMty (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 May 2022 08:49:54 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95ED614000;
        Mon,  2 May 2022 05:46:25 -0700 (PDT)
Received: from penguin.thunk.org (cn-8-34-116-185.paclightwave.com [8.34.116.185] (may be forged))
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 242CkG5a001996
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Mon, 2 May 2022 08:46:17 -0400
Received: by penguin.thunk.org (Postfix, from userid 1000)
        id 14746403C0; Mon,  2 May 2022 05:46:12 -0700 (PDT)
Date:   Mon, 2 May 2022 05:46:11 -0700
From:   tytso <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
Subject: Re: [xfstests PATCH 1/2] ext4/053: update the test_dummy_encryption
 tests
Message-ID: <Ym/Sk7D17iCeQIJa@mit.edu>
References: <20220501051928.540278-1-ebiggers@kernel.org>
 <20220501051928.540278-2-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220501051928.540278-2-ebiggers@kernel.org>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Apr 30, 2022 at 10:19:27PM -0700, Eric Biggers wrote:
> 
> The kernel patch "ext4: only allow test_dummy_encryption when supported"
> will tighten the requirements on when the test_dummy_encryption mount
> option will be accepted.  Update ext4/053 accordingly.

One of the problems with ext4/053 is that it is very implementation
dependent.  It was useful when we were making the change to the new
mount API, but the problem is any future changes to the mount option
handling is going to break the patch.

So for example, the kernel patch which Eric has proposed, "ext4: only
allow test_dummy_encryption when supported", breaks ext4/053, which I
noted in the review the patch.  But then this patch will break kernels
as they currently stand without this patch, and for kernels that
haven't moved to the new mount API, fixing it is going to be a mess.

Perhaps ext4/053 is still useful in that it will flag changes that
might unintentionally make user-visible changes mount options handling
in ext4, but for cases like this one, where we are changing a mount
option which is really intended for kernel developers, perhaps the
right approach here is to just remove the parts of ext4/053 that are
testing the behaviour of test_dummy_encryption in such a
super-nit-picky way?

What do folks think?

> Move the test cases to later in the file to group them with the other
> test cases that use do_mkfs to add custom mkfs options instead of using
> the "default" filesystem that the test creates at the beginning.

Note: this patch doesn't apply because ext4/053 currently has this
line:

		not_mnt test_dummy_encryption=v3

and the patch is trying to remove this line in the first patch chunk:

		mnt test_dummy_encryption=v3 ^test_dummy_encryption=v3

I checked the upstream version of ext4/053 just in case I had some
local modification of ext4/053 in my tree via "git diff -r
origin/master tests/ext4/053" but that returned no deltas.

Eric, do you have a local modification to this test in your tree
already, perhaps?

						- Ted
