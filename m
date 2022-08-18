Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DA6D597DEE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 18 Aug 2022 07:13:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243140AbiHRFMN (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 18 Aug 2022 01:12:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234664AbiHRFMM (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 18 Aug 2022 01:12:12 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1BAB8ACA3E;
        Wed, 17 Aug 2022 22:12:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 75A3BCE1F89;
        Thu, 18 Aug 2022 05:12:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 95C6AC433C1;
        Thu, 18 Aug 2022 05:12:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660799528;
        bh=xQW0Mw99vw/CXrHD6MllDujKrHAFhSY3e7ANdZywKuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=calAXd8+vEW/Uns5TaBH0bKEtdPcUCpzKa6WiQyYFgN8sQ+ux/+G2OEibWdqpYmej
         kqqs1fK6LLxexuWHmYAnfDb2fv5Qy/GbOo3tAzuH/tRdvOf13yGs2YqKeUvd2rYNVJ
         NiRHG24nDY04aLIfgi2et7kNcppNmysQ1/H0nXTHJcNQvTs+wz+6ScMD3VpQBqjxSB
         E6EC4MVgjk6NLvpXK/FCD7FdDX5tW+Z785VjR536iGk5zRXKZ7NQBNsi1qNZ9EDG45
         lW9T4mh7Of40JqylSyUjNTJH9CmKg0lPPZuFw5kbYvebjS1HRPM8htjN7nn1jLGMFs
         A8RdNvC55ItwQ==
Date:   Wed, 17 Aug 2022 22:12:06 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     linux-btrfs@vger.kernel.org, fstests@vger.kernel.org,
        kernel-team@fb.com, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH] fstests: add btrfs fs-verity send/recv test
Message-ID: <Yv3KJtM7L1CsIkVz@sol.localdomain>
References: <9e0ee6345a406765cf06594b805cb3568de16acc.1660596985.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e0ee6345a406765cf06594b805cb3568de16acc.1660596985.git.boris@bur.io>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Aug 15, 2022 at 01:57:56PM -0700, Boris Burkov wrote:
> diff --git a/tests/btrfs/271 b/tests/btrfs/271
> new file mode 100755
> index 00000000..93b34540
> --- /dev/null
> +++ b/tests/btrfs/271

There is already a btrfs/271, so this patch doesn't apply anymore.  Best to use
a higher number and let the maintainer renumber the test when applying.

> @@ -0,0 +1,114 @@
> +#! /bin/bash
> +# SPDX-License-Identifier: GPL-2.0
> +# Copyright (c) 2022 YOUR NAME HERE.  All Rights Reserved.

YOUR NAME HERE is a great company to work for :-)

> +_require_test

I don't see where this uses the test filesystem; it seems to use scratch only.

> +	if [ $salt -eq 1 ]; then
> +		extra_args+=" --salt=deadbeef"
> +	fi

I like to use true and false for this sort of thing so you can just do:

	if $salt; then

> +	echo "check received subvolume..."
> +	echo 3 > /proc/sys/vm/drop_caches

A comment explaining why the drop_caches is needed would be helpful.
And should there be a sync before it, and should it be _scratch_cycle_mount?

> +	_fsv_measure $fsv_file > $tmp.digest-after
> +	$GETCAP_PROG $fsv_file > $tmp.cap-after
> +	diff $tmp.digest-before $tmp.digest-after
> +	diff $tmp.cap-before $tmp.cap-after
> +	_scratch_unmount
> +	echo OK

Should this compare the file's contents too?

- Eric
