Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 18AFF52C5EC
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 00:05:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229516AbiERWE6 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 18 May 2022 18:04:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229965AbiERWE3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 18 May 2022 18:04:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 940FB4755B;
        Wed, 18 May 2022 15:01:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6905B60FC8;
        Wed, 18 May 2022 22:01:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A9D65C385A9;
        Wed, 18 May 2022 22:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652911269;
        bh=Dz5y7AtcgMaq6vy+R0Fpm0/Nxq0RyA35q79peiTxQMY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iAGvg+QQ7BZNMzRi3f3bNzJpEXGWBXOaLhnMlMKsgcdv4hp7Gb2+NdnCpsEsp2V7T
         l0X5pB+LfworHlmVU8DSzqL3eSYGUIpVO2F4/MxuNSCYNfdGYq/oWE3HQIqRekF5bK
         1t3mT7TfBxHBLgf6e+nKEYbaIG+mCzTG+rduCBWcmAPeeWiR4otHGx9glqhrNa5GNI
         4doE+49Hot1l8jbQtTYsQVY6Mz3FrBTyLhmAtuYvkV8jhk4Of1ccSHx4GUM86pIkqm
         lWKP5DONLuHHPILNZxZP6iPdduxJVqlZnY+UuCaKRedA842ptzN2yRSr7gtWFim05r
         WHLp/YIdOdKHg==
Date:   Wed, 18 May 2022 15:01:08 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-ext4@vger.kernel.org, Lukas Czerner <lczerner@redhat.com>
Subject: Re: [xfstests PATCH 0/2] update test_dummy_encryption testing in
 ext4/053
Message-ID: <YoVspJ6NUByHPn3r@sol.localdomain>
References: <20220501051928.540278-1-ebiggers@kernel.org>
 <20220518141911.zg73znk2o2krxxwk@zlang-mailbox>
 <YoUu60S2AjP2fEOk@sol.localdomain>
 <20220518181607.fpzqmtnaky5jdiuw@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220518181607.fpzqmtnaky5jdiuw@zlang-mailbox>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Zorro, can you fix your email configuration?  Your emails have a
Mail-Followup-To header that excludes you, so replying doesn't work correctly;
I had to manually fix the recipients list.  If you're using mutt, you need to
add 'set followup_to = no' to your muttrc.

On Thu, May 19, 2022 at 02:16:07AM +0800, Zorro Lang wrote:
> > > 
> > > And I saw some discussion under this patchset, and no any RVB, so I'm wondering
> > > if you are still working/changing on it?
> > > 
> > 
> > I might add a check for kernel version >= 5.19 in patch 1.  Otherwise I'm not
> > planning any more changes.
> 
> Actually I don't think the kernel version check (in fstests) is a good method. Better
> to check a behavior/feature directly likes those "_require_*" functions.
> 
> Why ext4/053 need >=5.12 or even >=5.19, what features restrict that? If some
> features testing might break the garden image (.out file), we can refer to
> _link_out_file(). Or even split this case to several small cases, make ext4/053
> only test old stable behaviors. Then use other cases to test new features,
> and use _require_$feature_you_test for them (avoid the kernel version
> restriction).

This has been discussed earlier in this thread as well as on the patch that
added ext4/053 originally.  ext4/053 has been gated on version >= 5.12 since the
beginning.  Kernel version checks are certainly bad in general, but ext4/053 is
a very nit-picky test intended to detect if anything changed, where a change
does not necessarily mean a bug.  So maybe the kernel version check makes sense
there.  Lukas, any thoughts about the issues you encountered when running
ext4/053 on older kernels?

If you don't want a >= 5.19 version check for the test_dummy_encryption test
case as well, then I'd rather treat the kernel patch
"ext4: only allow test_dummy_encryption when supported" as a bug fix and
backport it to the LTS kernels.  The patch is fixing the mount option to work
the way it should have worked originally.  Either that or we just remove the
test_dummy_encryption test case as Ted suggested.

- Eric
