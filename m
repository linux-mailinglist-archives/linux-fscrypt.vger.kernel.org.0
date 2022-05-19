Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 884A552C9A6
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 04:11:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiESCLX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 18 May 2022 22:11:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231824AbiESCLW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 18 May 2022 22:11:22 -0400
Received: from outgoing.mit.edu (outgoing-auth-1.mit.edu [18.9.28.11])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92C3E5402F;
        Wed, 18 May 2022 19:11:21 -0700 (PDT)
Received: from cwcc.thunk.org (pool-108-7-220-252.bstnma.fios.verizon.net [108.7.220.252])
        (authenticated bits=0)
        (User authenticated as tytso@ATHENA.MIT.EDU)
        by outgoing.mit.edu (8.14.7/8.12.4) with ESMTP id 24J2B3JG020839
        (version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-GCM-SHA384 bits=256 verify=NOT);
        Wed, 18 May 2022 22:11:04 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mit.edu; s=outgoing;
        t=1652926265; bh=G8AwOJ7aNH9K4G4CQ4xdeR2aO3xM2mJKQnu9NPGy5xU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To;
        b=CFbTgQcXF8r4oLV3cOeIo8/HxrBG5BvkcDzWUG7rE7elqhW1seFqHmLu49mk7jrXB
         aSx9ERO4Py3NjEwiaPtZkNC+vRYhbGOH6Y5zHDH6Torgqw+n5mZNQ21Rdkk6K+bZYp
         NGAon6ivzr6JixkwCoBncs2RLDAPe5bl4EymWmcgaF36lutDapYKFUJ7bd5N2N5rtc
         JSeGLJexcRnJFP2yTNK0b2PzcBVAyPOsvlAQvMXPgdC1shQ2e7K0X1/V4CZu4O8KVd
         x3rP7o8DmMkwBYLUQbuSlruhTzmvg/rkhSQ1frc10tvoqohIapgoxBmL2bEsFVaasl
         sSr41wGfnd9vw==
Received: by cwcc.thunk.org (Postfix, from userid 15806)
        id 1EDB815C3EC0; Wed, 18 May 2022 22:11:03 -0400 (EDT)
Date:   Wed, 18 May 2022 22:11:03 -0400
From:   "Theodore Ts'o" <tytso@mit.edu>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jeff Layton <jlayton@kernel.org>,
        Lukas Czerner <lczerner@redhat.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH v3 2/5] ext4: only allow test_dummy_encryption when
 supported
Message-ID: <YoWnN/qY30ly9znS@mit.edu>
References: <20220513231605.175121-1-ebiggers@kernel.org>
 <20220513231605.175121-3-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220513231605.175121-3-ebiggers@kernel.org>
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, May 13, 2022 at 04:16:02PM -0700, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Make the test_dummy_encryption mount option require that the encrypt
> feature flag be already enabled on the filesystem, rather than
> automatically enabling it.  Practically, this means that "-O encrypt"
> will need to be included in MKFS_OPTIONS when running xfstests with the
> test_dummy_encryption mount option.  (ext4/053 also needs an update.)
> 
> Moreover, as long as the preconditions for test_dummy_encryption are
> being tightened anyway, take the opportunity to start rejecting it when
> !CONFIG_FS_ENCRYPTION rather than ignoring it.
> 
> The motivation for requiring the encrypt feature flag is that:
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
> 
> - f2fs already requires it (for its equivalent feature flag).
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Thanks, applied.

					- Ted
