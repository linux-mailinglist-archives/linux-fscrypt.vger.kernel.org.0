Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EAEEB59A8B0
	for <lists+linux-fscrypt@lfdr.de>; Sat, 20 Aug 2022 00:43:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242589AbiHSWig (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 19 Aug 2022 18:38:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242572AbiHSWie (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 19 Aug 2022 18:38:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE3D13FA21;
        Fri, 19 Aug 2022 15:38:29 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 039EF614AB;
        Fri, 19 Aug 2022 22:38:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FEB2C433B5;
        Fri, 19 Aug 2022 22:38:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660948708;
        bh=zkqozrlPC/FpAKliZeY7BD2iSujAcOynm6bsYmG3Nrc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=PlTePol34kCemWZs5l8QxjrsLaQ+dAl8l06vYhK73tz39ROxdo3IreGNXX5Xf2dZu
         ind9XhFVwNVGLgB0kw7eYH8nvqPfbtyb67A7A6l66RVhzBu58mplnLyb6Hx8Uw7oEW
         iSOQZdewGgVd+VswwUErR/B8HdW+YFmivpFjxg0OVooGlmRGVO9wwHo84HQIBcp3XR
         nQqDYvqxRBgC/i/jKWKRzyJ6oacIHOLaFIkYkKdtYxGQOBaNn2eEK79rQSWbxYEDII
         DrKfs1TOwnTyjsMmO46bdfIEK5tjf4d6vPAnvf4MH5d4+nkrwDoBEZexYYPS8Sh22A
         xP/wWUsH/g9eg==
Date:   Fri, 19 Aug 2022 15:38:26 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        fstests@vger.kernel.org
Subject: Re: [PATCH v4] fstests: add btrfs fs-verity send/recv test
Message-ID: <YwAQ4klC2wjpIDsf@sol.localdomain>
References: <c46544a9bd65f22debac5dfff0a624e3b4996ca6.1660937484.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c46544a9bd65f22debac5dfff0a624e3b4996ca6.1660937484.git.boris@bur.io>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Fri, Aug 19, 2022 at 12:34:05PM -0700, Boris Burkov wrote:
> Test btrfs send/recv support for fs-verity. Includes tests for
> signatures, salts, and interaction with chmod/caps. The last of those is
> to ensure the various features that go in during inode_finalize interact
> properly.
> 
> This depends on the kernel patch adding support for send:
> btrfs: send: add support for fs-verity
> 
> And the btrfs-progs patch adding support for recv:
> btrfs-progs: receive: add support for fs-verity
> 
> Signed-off-by: Boris Burkov <boris@bur.io>

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
