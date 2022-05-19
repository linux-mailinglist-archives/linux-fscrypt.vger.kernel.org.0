Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2E08052CA2F
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 05:18:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231519AbiESDSD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 18 May 2022 23:18:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231345AbiESDSC (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 18 May 2022 23:18:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D999419BD;
        Wed, 18 May 2022 20:18:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A4ABE61937;
        Thu, 19 May 2022 03:18:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E22C9C385A9;
        Thu, 19 May 2022 03:18:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652930281;
        bh=UVtafeBuUvFSIafJnXkGP/gTPv0mAWVeBB9/MYkE118=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=l/o2KFlJdI7yeg/cDNQn3ni2us9mTaKQQ0kPWnMMy0bKg8urXZIvtc6O/2/40VL+f
         hzByPLO2lfRuW1Bws7W8Iu9GUTUNwD2kaphwlCvefc00X15a9WRj8cFBp16alYAWFl
         zH4bIjgz4i8Q5CBbqpofFDiHnudnlFy/APdbNQl6hdkXkwW9/Q3MPI2UHQ6eUgyU2Y
         8Uiyy1qCCEps4y9+I2MJf9I83ZNrC5YZ1hHufwrfN0o06n2iwzvwoVEfM0DC9Cz1VD
         FyaCCpFiDxAa37PVhAjmY5GE1IiYOYrTc238qOXi7Pt7f7uKWIFSueBE8xPZUGaXFG
         fyfnXeuT5Ur0A==
Date:   Wed, 18 May 2022 20:17:59 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Zhang Jianhua <chris.zjh@huawei.com>
Cc:     tytso@mit.edu, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH -next v2] fs-verity: Use struct_size() helper in
 enable_verity()
Message-ID: <YoW25wrIAiRVifMi@sol.localdomain>
References: <20220519022450.2434483-1-chris.zjh@huawei.com>
 <YoW0HG+Nbg681yWL@sol.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YoW0HG+Nbg681yWL@sol.localdomain>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, May 18, 2022 at 08:06:04PM -0700, Eric Biggers wrote:
> On Thu, May 19, 2022 at 10:24:50AM +0800, Zhang Jianhua wrote:
> > Also, address the following sparse warning:
> > fs/verity/enable.c:205:28: warning: using sizeof on a flexible structure
> 
> How can I reproduce this warning?  I am using the latest version of sparse, and
> I don't see any of these warnings you're reporting.
> 
> $ sparse --version
> v0.6.4
> $ make C=2 fs/verity/
>   CHECK   scripts/mod/empty.c
>   CALL    scripts/checksyscalls.sh
>   CALL    scripts/atomic/check-atomics.sh
>   DESCEND objtool
>   CHECK   fs/verity/enable.c
>   CHECK   fs/verity/hash_algs.c
>   CHECK   fs/verity/init.c
>   CHECK   fs/verity/measure.c
>   CHECK   fs/verity/open.c
>   CHECK   fs/verity/read_metadata.c
>   CHECK   fs/verity/verify.c
>   CHECK   fs/verity/signature.c
> 

'make C=2 CHECK="sparse -Wflexible-array-sizeof"' does the trick.  However, it
produces a *lot* of warnings all over the place.

Unless there is an effort to actually address all of these so that this warning
can be enabled by default, I don't see the poinnt in addressing these just for
the warnings sake.  The change to fsverity_ioctl_measure() is definitely just
for the warning's sake, so I don't really want to do that one.  The change to
enable_verity() is a bit less useless, so I could still take that one.

- Eric
