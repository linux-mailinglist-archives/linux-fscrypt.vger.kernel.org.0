Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C90E64C416
	for <lists+linux-fscrypt@lfdr.de>; Wed, 14 Dec 2022 07:54:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237447AbiLNGyo (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 14 Dec 2022 01:54:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229615AbiLNGyn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 14 Dec 2022 01:54:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD6153897;
        Tue, 13 Dec 2022 22:54:42 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C49806181B;
        Wed, 14 Dec 2022 06:54:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0B54C433EF;
        Wed, 14 Dec 2022 06:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1671000881;
        bh=/xvZZEVHwXif/yR6pv6H07haNPLvpHZxBhqpI8uxEYA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uBKr7RHgMmSW9bkc5ih/wW+Zyj1RpfL4wcWu1hzn1BctG6/k0ci7A6SPUquKdmJCm
         yAmzmpTm2rqmSikMIRZLP5aimWTBMzFn9rOJYDKQzzFrukmA0EioNL5Nkpwo+RNy1S
         JaCvrfPwLNmcKvRV8faV8jZ/6rI9VCTuDLNwgBEDioVjglVdMs0CcEh6Iw/Y3X+P0s
         z1Lvl6KZGC8lMqHvFx24QDpvN3pFpSg2kvnJ3/q1qE4OLbUJOd2w2DfA3dE6C35yuF
         OMSldDlQAbmTmZeCOAs/Gf+9We2ROWyKlvOC9xjZle50SqL2b8WhUL6YM6z14F8Hjh
         kn5SFCAqrocfQ==
Date:   Tue, 13 Dec 2022 22:54:39 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Jun Nie <jun.nie@linaro.org>
Cc:     tytso@mit.edu, jaegeuk@kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fscrypt: Fix null pointer when defer i_crypt_info
Message-ID: <Y5lzLzVz6icx+5K1@sol.localdomain>
References: <20221213081103.2182231-1-jun.nie@linaro.org>
 <Y5jKfdDrJkdKtEbC@sol.localdomain>
 <CABymUCMtTmSiZQNV9tXTYp90Jk3M37QiF4z5UbrukB43wSx-mw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABymUCMtTmSiZQNV9tXTYp90Jk3M37QiF4z5UbrukB43wSx-mw@mail.gmail.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Dec 14, 2022 at 09:33:41AM +0800, Jun Nie wrote:
> Eric Biggers <ebiggers@kernel.org> 于2022年12月14日周三 02:54写道：
> >
> > On Tue, Dec 13, 2022 at 04:11:03PM +0800, Jun Nie wrote:
> > > syzbot report below bug[1]. Fix it with checking null pointer before
> > > deferring i_crypt_info.
> > >
> >
> > Thanks, but this has already been fixed upstream by commit 105c78e12468
> > ("ext4: don't allow journal inode to have encrypt flag").
> >
> > Also, I don't think adding a NULL check to __fscrypt_inode_uses_inline_crypto()
> > is a good idea because it is only meant to be called when the inode's encryption
> > key has already been set up.  Instead of making the function return a
> > potentially-incorrect result, it was better to address the root cause of why it
> > was being called at an inappropriate time in the first place.
> >
> > - Eric
> 
> Thanks for the information! Do you know what's the plan/schedule of
> back porting,
> such as linux-5.15.y branch?
> 
> - Jun

The commit has 'Cc: stable@vger.kernel.org', and it is marked as fixing a commit
in 5.9.  So it will be backported to 5.10 LTS and later.  It will take a little
while for the stable maintainers to pick it up, though, since it just made it
upstream yesterday.

- Eric
