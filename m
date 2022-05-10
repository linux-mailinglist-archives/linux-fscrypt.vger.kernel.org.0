Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B4121522785
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 May 2022 01:23:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237327AbiEJXXc (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 May 2022 19:23:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233372AbiEJXX2 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 May 2022 19:23:28 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F42A2802F5;
        Tue, 10 May 2022 16:23:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E8F27B8201C;
        Tue, 10 May 2022 23:23:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7F481C385CE;
        Tue, 10 May 2022 23:23:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652225003;
        bh=e59r18xSxhijBVYd8jpKjsz2cx3igw6HBJgjPaVJtDY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Sv0ubqWbpdeqLbwbUaUTEs6+W/fnUGWHrFuHBYr82WMm9aR4ymhqifd0jvcmpBNb0
         LoS+NHYvGR2oXcO+EyUYfftGyD4gvMCNThE4IO0UgIEFihoFphP8kpd8IFl1mCdkuV
         pr9JuYpOJdljpQn0eU+yVswhajqRkAVdHvq+5ZmnW1cBcVNFiq0UH0WPDttPtQtrPH
         ZPt6sF1xd68swqRfy53yRl2OwrzTzV9o2h20dSy4rScODkm04zjr+Iej3Hh5y8sPPi
         eZTh8rWM7WxXXEB2wNEZAprzcwVyArX3NRLNSYmFh3tV5BVUA1cxnndvq1Vkn4L+8J
         U8ep19b3ySU9Q==
Date:   Tue, 10 May 2022 16:23:21 -0700
From:   Jaegeuk Kim <jaegeuk@kernel.org>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        Jeff Layton <jlayton@kernel.org>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>
Subject: Re: [PATCH v2 0/7] test_dummy_encryption fixes and cleanups
Message-ID: <Ynrz6foNrUwivT94@google.com>
References: <20220501050857.538984-1-ebiggers@kernel.org>
 <YnmlZ15YPS1cy4aV@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YnmlZ15YPS1cy4aV@sol.localdomain>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 05/09, Eric Biggers wrote:
> On Sat, Apr 30, 2022 at 10:08:50PM -0700, Eric Biggers wrote:
> > This series cleans up and fixes the way that ext4 and f2fs handle the
> > test_dummy_encryption mount option:
> > 
> > - Patches 1-2 make test_dummy_encryption consistently require that the
> >   'encrypt' feature flag already be enabled and that
> >   CONFIG_FS_ENCRYPTION be enabled.  Note, this will cause xfstest
> >   ext4/053 to start failing; my xfstests patch "ext4/053: update the
> >   test_dummy_encryption tests" will fix that.
> > 
> > - Patches 3-7 replace the fscrypt_set_test_dummy_encryption() helper
> >   function with new functions that work properly with the new mount API,
> >   by splitting up the parsing, checking, and applying steps.  These fix
> >   bugs that were introduced when ext4 started using the new mount API.
> > 
> > We can either take all these patches through the fscrypt tree, or we can
> > take them in multiple cycles as follows:
> > 
> >     1. patch 1 via ext4, patch 2 via f2fs, patch 3-4 via fscrypt
> >     2. patch 5 via ext4, patch 6 via f2fs
> >     3. patch 7 via fscrypt
> > 
> > Ted and Jaegeuk, let me know what you prefer.
> > 
> > Changed v1 => v2:
> >     - Added patches 2-7
> >     - Also reject test_dummy_encryption when !CONFIG_FS_ENCRYPTION
> > 
> > Eric Biggers (7):
> >   ext4: only allow test_dummy_encryption when supported
> >   f2fs: reject test_dummy_encryption when !CONFIG_FS_ENCRYPTION
> >   fscrypt: factor out fscrypt_policy_to_key_spec()
> >   fscrypt: add new helper functions for test_dummy_encryption
> >   ext4: fix up test_dummy_encryption handling for new mount API
> >   f2fs: use the updated test_dummy_encryption helper functions
> >   fscrypt: remove fscrypt_set_test_dummy_encryption()
> 
> Since I haven't heard from anyone, I've gone ahead and applied patches 3-4 to
> fscrypt#master for 5.19, so that the filesystem-specific patches can be taken in
> 5.20.  But patches 1-2 could still be applied now.

Hi Eric,

Let me apply #2 in the f2fs tree first.
You can put "Acked-by: Jaegeuk Kim <jaegeuk@kernel.org>" in #6.

Thanks,

> 
> Any feedback on this series would be greatly appreciated!
> 
> - Eric
