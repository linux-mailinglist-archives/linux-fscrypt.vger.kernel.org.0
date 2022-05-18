Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F6B652C11C
	for <lists+linux-fscrypt@lfdr.de>; Wed, 18 May 2022 19:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240948AbiERRhw (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 18 May 2022 13:37:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240889AbiERRhv (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 18 May 2022 13:37:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C2E01DFDAB;
        Wed, 18 May 2022 10:37:50 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 370816179F;
        Wed, 18 May 2022 17:37:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 79E12C385A5;
        Wed, 18 May 2022 17:37:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652895469;
        bh=ouxYcnUG3DMG8JeqNw3VUgAtJhJI0XoOf7fkaCI0LwQ=;
        h=Date:From:To:Subject:References:In-Reply-To:From;
        b=HqNq9WAxCpySAAV/YVvRRd3SjO/GXkTzh92RepFUJcStvK/yfKfIN35DFlRvUe+eO
         oE7LSKVNRQ9Nwm3Ne3CjJ1EGwt7DpByCLZK9SRtNjd+n96qBPgll1jljuRE5c9+KBp
         5C5d0hjf+oWTfU9MhEfRvEI/sjv+o51bj6+cP0VSmLfYsn9dCSVpZuhSBHFgIbLqQK
         QtQ7jw9nZRd8i2LoeCOqyrofAqEl11zUBnJg01m7CGlWh4cXFgWugKIVaS8+XcA8pX
         fklUIlr1W9XprcQw6yIkPLLmtLB7C8zJsOLFRDMybEeKcDWftg7e1Wv0HmT/5V/i7C
         UO1pPqx/neGGw==
Date:   Wed, 18 May 2022 10:37:47 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [xfstests PATCH 0/2] update test_dummy_encryption testing in
 ext4/053
Message-ID: <YoUu60S2AjP2fEOk@sol.localdomain>
References: <20220501051928.540278-1-ebiggers@kernel.org>
 <20220518141911.zg73znk2o2krxxwk@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518141911.zg73znk2o2krxxwk@zlang-mailbox>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 18, 2022 at 10:19:11PM +0800, Zorro Lang wrote:
> On Sat, Apr 30, 2022 at 10:19:26PM -0700, Eric Biggers wrote:
> > This series updates the testing of the test_dummy_encryption mount
> > option in ext4/053.
> > 
> > The first patch will be needed for the test to pass if the kernel patch
> > "ext4: only allow test_dummy_encryption when supported"
> > (https://lore.kernel.org/r/20220501050857.538984-2-ebiggers@kernel.org)
> > is applied.
> > 
> > The second patch starts testing a case that previously wasn't tested.
> > It reproduces a bug that was introduced in the v5.17 kernel and will
> > be fixed by the kernel patch
> > "ext4: fix up test_dummy_encryption handling for new mount API"
> > (https://lore.kernel.org/r/20220501050857.538984-6-ebiggers@kernel.org).
> > 
> > This applies on top of my recent patch
> > "ext4/053: fix the rejected mount option testing"
> > (https://lore.kernel.org/r/20220430192130.131842-1-ebiggers@kernel.org).
> 
> Hi Eric,
> 
> Your "ext4/053: fix the rejected mount option testing" has been merged. As the
> two kernel patches haven't been merged by upstream linux, I'd like to merge
> this patchset after the kernel patches be merged. (feel free to ping me, if
> I forget this:)

Yes, I'm waiting for them to be applied.

> 
> And I saw some discussion under this patchset, and no any RVB, so I'm wondering
> if you are still working/changing on it?
> 

I might add a check for kernel version >= 5.19 in patch 1.  Otherwise I'm not
planning any more changes.

- Eric
