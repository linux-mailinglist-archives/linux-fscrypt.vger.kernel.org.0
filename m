Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BCFF14DCD6E
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Mar 2022 19:17:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237292AbiCQSSj (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 17 Mar 2022 14:18:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237344AbiCQSRw (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 17 Mar 2022 14:17:52 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3D381D7D92;
        Thu, 17 Mar 2022 11:16:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C5F3616EA;
        Thu, 17 Mar 2022 18:16:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD7E1C340E9;
        Thu, 17 Mar 2022 18:16:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647540993;
        bh=lDbTMb22KQoMx+O9M+oCoMJj0G/8QElIp3RPlMzy2Gw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o9YL80Eiud8cHxRBsB8uWRv9QCh0merym9W8qsEjdQA2c3F/D5d0nSzzT9JVDdC4P
         fBG5DtLxk2KKYiGM7yggvSm7Xf8arydikT/gsrbpDUGrkWQiPvMEPCSPJMwlrBJozc
         lZXIfCzQtruYVT5q9PenSw8ZsCsapkAiz6hvo3AqkeicbQACQzBF4QjeUbg2v8HZqT
         2R8gOrykRKvBi8tZopbmthd6mH9Ln7rf4qDrta65CaxIC14oz9P+u2SbTh3/ZPRL3B
         dxdgIAguJqmnIt0LH6o9A6nPfNXf/R0tF75GHPnVVR5Nj6hmPCw0nGhllxZyc/tkyA
         sRCurw09r58+w==
Date:   Thu, 17 Mar 2022 18:16:32 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v8 1/5] common/verity: require corruption functionality
Message-ID: <YjN7AGeGYu1/3NSq@gmail.com>
References: <cover.1647461985.git.boris@bur.io>
 <c142dce513191c0097989e5752a57515246e0de9.1647461985.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c142dce513191c0097989e5752a57515246e0de9.1647461985.git.boris@bur.io>
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Mar 16, 2022 at 01:25:11PM -0700, Boris Burkov wrote:
> Corrupting ext4 and f2fs relies on xfs_io fiemap. Btrfs corruption
> testing will rely on a btrfs specific corruption utility. Add the
> ability to require corruption functionality to make this properly
> modular. To start, just check for fiemap, as that is needed
> universally for _fsv_scratch_corrupt_bytes.
> 
> Signed-off-by: Boris Burkov <boris@bur.io>
> ---
>  common/verity     | 6 ++++++
>  tests/generic/574 | 1 +
>  tests/generic/576 | 1 +
>  3 files changed, 8 insertions(+)

Reviewed-by: Eric Biggers <ebiggers@google.com>

- Eric
