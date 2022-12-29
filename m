Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E58965935F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 30 Dec 2022 00:47:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233854AbiL2XrQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 29 Dec 2022 18:47:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49680 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234319AbiL2XrN (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 29 Dec 2022 18:47:13 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E94113EB2;
        Thu, 29 Dec 2022 15:47:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EDD2261978;
        Thu, 29 Dec 2022 23:47:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 300C5C433EF;
        Thu, 29 Dec 2022 23:47:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672357631;
        bh=BRwAOEDQdFfyBDo4SmXClaLm9XOgsxR0oc8PLSOuiUc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZeRveALYkLoway30dBqq807Mv7kx+Z0u2Pvs5YpsG+WbclmYJtJhEBpH7YFSHekDF
         l6SXfuofN/9Ab3nlvIyuwOGJ1WgVDf2oCDJVrSkwbREcsognPxeB+rFYAS/JgIfRU9
         xi4Dnv64x/NlyO24Tqdy5vZ00A54fuymz+ACxyRi2lBvkzc1zuQlRC1OvnjpIhPYxb
         nkJN5kJvsp6cSyoCQ566CyIolmBS/z4UAFEiQBbV6GVB7iT+HhuhksetXuxqzVMby4
         VUU6M8yDRchKB4lMqMlpVcI71q1Ftd8lweijEpFOUY5+7JNGaMNlf657jXzdZ8sEtz
         YJvlDMcgEd//Q==
Date:   Thu, 29 Dec 2022 15:47:09 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     Zorro Lang <zlang@redhat.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v2 08/10] generic/574: test multiple Merkle tree block
 sizes
Message-ID: <Y64m/WNnlKYBAFVk@sol.localdomain>
References: <20221223010554.281679-1-ebiggers@kernel.org>
 <20221223010554.281679-9-ebiggers@kernel.org>
 <20221225124600.faouh6a7suhq2wuu@zlang-mailbox>
 <Y6kvXs33MmxVovNO@sol.localdomain>
 <20221229163215.zpwgul6faq2rhpay@zlang-mailbox>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221229163215.zpwgul6faq2rhpay@zlang-mailbox>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Dec 30, 2022 at 12:32:15AM +0800, Zorro Lang wrote:
> > 
> > This test passes for me both before and after this patch series.
> > 
> > Both before and after, the way this is supposed to work is that in:
> > 
> > 	bash -c "trap '' SIGBUS; command_that_exits_with_sigbus"
> > 
> > ... bash should print "Bus error" to stderr due to
> > 'command_that_exits_with_sigbus'.  That "Bus error" is then redirected.  Before
> > it was redirected to a pipeline; after it is redirected to a file.
> > 
> > I think what's happening is that the version of bash your system has is not
> > forking before exec'ing 'command_that_exits_with_sigbus'.  As a result, "Bus
> > error" is printed by the *parent* bash process instead, skipping any redirection
> > in the shell script.
> > 
> > Apparently skipping fork is a real thing in bash, and different versions of bash
> > have had subtly different conditions for enabling it.  So this seems plausible.
> > 
> > Adding an extra command after 'command_that_exits_with_sigbus' should fix this:
> > 
> > 	bash -c "trap '' SIGBUS; command_that_exits_with_sigbus; true"
> 
> Thanks for this explanation, I think you're right!
> 
> I'm not sure if it's a bug of bash. If it's not a bug, I think we can do this
> change (add a true) to avoid that failure. If it's a bug, hmmm..., I think we'd
> better to avoid that failure too, due to we don't test for bash :-/
> 
> How about your resend this single patch (by version 2.1), to fix this problem.
> Other patches looks good to me, I'd like to merge this patchset this weekend.
> 
> Thanks,
> Zorro

I expect that the bash developers wouldn't consider this to be a bug, since it
could only be fixed by removing the "skip fork" optimization entirely.

Anyway, the workaround I suggested is simple enough.

I just resent the whole series, since it's confusing to have new versions of
patches within existing series versions.  But only this one patch changed.

Thanks!

- Eric
