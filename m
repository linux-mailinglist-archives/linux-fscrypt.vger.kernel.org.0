Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B075512049
	for <lists+linux-fscrypt@lfdr.de>; Wed, 27 Apr 2022 20:38:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239639AbiD0P17 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 27 Apr 2022 11:27:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239573AbiD0P16 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 27 Apr 2022 11:27:58 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A3F330D49D;
        Wed, 27 Apr 2022 08:24:46 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 23RFOXp5006539
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 27 Apr 2022 11:24:34 -0400
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 968B715C3EA1; Wed, 27 Apr 2022 11:24:33 -0400 (EDT)
Date:   Wed, 27 Apr 2022 11:24:33 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH] ext4: make test_dummy_encryption require the encrypt
 feature
Message-ID: <YmlgMQ6e4DCxCSBl@mit.edu>
References: <20220421184040.173802-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421184040.173802-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Apr 21, 2022 at 11:40:40AM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Make the test_dummy_encryption mount option require that the encrypt
> feature flag be already enabled on the filesystem, rather than
> automatically enabling it.  Practically, this means that "-O encrypt"
> will need to be included in MKFS_OPTIONS when running xfstests with the
> test_dummy_encryption mount option.
> 
> The motivation for this is that:
> 
> - Having the filesystem auto-enable feature flags is problematic, as it
>   bypasses the usual sanity checks.  The specific issue which came up
>   recently is that in kernel versions where ext4 supports casefold but
>   not encrypt+casefold (v5.1 through v5.10), the kernel will happily add
>   the encrypt flag to a filesystem that has the casefold flag, making it
>   unmountable -- but only for subsequent mounts, not the initial one.
>   This confused the casefold support detection in xfstests, causing
>   generic/556 to fail rather than be skipped.
> 
> - The xfstests-bld test runners (kvm-xfstests et al.) already use the
>   required mkfs flag, so they will not be affected by this change.  Only
>   users of test_dummy_encryption alone will be affected.  But, this
>   option has always been for testing only, so it should be fine to
>   require that the few users of this option update their test scripts.

One of the test scripts involved is xfstests's ext4/053, as the
zero-day test rebot has remarked upon.  Eric, could you look into
submitting a patch to xfstests's ext4/053.

Thanks!

					- Ted
