Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EB0DA5006D9
	for <lists+linux-fscrypt@lfdr.de>; Thu, 14 Apr 2022 09:27:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240300AbiDNH3x (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 14 Apr 2022 03:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229527AbiDNH3w (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 14 Apr 2022 03:29:52 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E573150C;
        Thu, 14 Apr 2022 00:27:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 81107B8289C;
        Thu, 14 Apr 2022 07:27:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD41BC385A1;
        Thu, 14 Apr 2022 07:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649921246;
        bh=yyMOVrLFGw00C3yLO3iW8jwxwMQ6NSQS5TbsghEfV9k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=U/+tMIsYb44X9mJOYJTTCeoRMHULSahzf6p1WEIi1vjK8n7TGqSDH9rDoFycdr90Q
         ITLc78iKYVHbT27PrGGgrkG1CR5iz9KcYfRuxOoPSAQhrRfw23EodvNahHD3hhRRDl
         cc6ew/LpiNJga0IarsFOHW4b8nljSFPaVnhQYNZDg3AjFnUq/THAIHGW7KgZXXkbu2
         5kMfXIDxQmhOgZVRnG1fkEyujIJLahc38ITL+QhC2GX+MMZQU967d7CQ4mDi76oLLi
         IDmcgOfmBO/fMZ5GYa3bakod5WEq7bIuTdsSqEHE0eKteaThaDBV7QTC3vhHZRJZ28
         HtNIMSUa70+hA==
Date:   Thu, 14 Apr 2022 00:27:24 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Eryu Guan <guan@eryu.me>, Ritesh Harjani <ritesh.list@gmail.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [xfstests PATCH] common/encrypt: use a sub-keyring within the
 session keyring
Message-ID: <YlfM3E7zY68t38Ml@sol.localdomain>
References: <20220407062621.346777-1-ebiggers@kernel.org>
 <YlL8deEu4llJHZVa@desktop>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YlL8deEu4llJHZVa@desktop>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Apr 10, 2022 at 11:49:09PM +0800, Eryu Guan wrote:
> On Wed, Apr 06, 2022 at 11:26:21PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > Make the encryption tests create and use a named keyring "xfstests" in
> > the session keyring that the tests happen to be running under, rather
> > than replace the session keyring using 'keyctl new_session'.
> > Unfortunately, the latter doesn't work when the session keyring is owned
> > by a non-root user, which (depending on the Linux distro) can happen if
> > xfstests is run in a sudo "session" rather than in a real root session.
> > 
> > This isn't a great solution, as the lifetime of the keyring will no
> > longer be tied to the tests as it should be, but it should work.  The
> > alternative would be the weird hack of making the 'check' script
> > re-execute itself using something like 'keyctl session - $0 $@'.
> > 
> > Reported-by: Ritesh Harjani <ritesh.list@gmail.com>
> > Signed-off-by: Eric Biggers <ebiggers@google.com>
> 
> This patch conflicts with patch "common/encrypt: allow the use of
> 'fscrypt:' as key prefix", which has been applied in my local tree.
> Would you please rebase & resend this one?
> 

Done: https://lore.kernel.org/r/20220414071932.166090-1-ebiggers@kernel.org

Ritesh, can you verify that this actually fixes the problem for you?

- Eric
