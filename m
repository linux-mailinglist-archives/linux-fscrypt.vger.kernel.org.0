Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E356D57A6B0
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 Jul 2022 20:47:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236561AbiGSSrb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 Jul 2022 14:47:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43586 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236423AbiGSSra (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 Jul 2022 14:47:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 19DCC550DC;
        Tue, 19 Jul 2022 11:47:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3FFC6177F;
        Tue, 19 Jul 2022 18:47:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1632C341C6;
        Tue, 19 Jul 2022 18:47:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658256448;
        bh=WqqIKJXFmiieBiWdZUcQa3wfr1QuXK5MqMt3oifdfq8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=TwekebeMIkAK6+Bk9GrDyhxBiaEIM+6TjB4+h7yeAPkhqC67XofEEGHlpqFskn968
         o6iWQFE+sEUZx/sfnNL2hg169XvaPGdCUsZnQmYMBfuWN7L6xpYzv9z++kmwsPv2nz
         WYOrSAi0h8t9JFCsEa8SJT8XqB9040roQCRTy46GwHuz+ydk75scltUVQS5Kbv+D1P
         VupXyLzSGK3x5/kJcMmiUU/Vl2yOseOzM1M6TW/4E2UyLgEYn6MFgi2qPT58Agpox5
         d60MzCd7VcwXpOQm0MB1b17bGsSHLKmZyMWpXWXCpHMf72LDjgHio5ggLFcttztaB/
         3Kkx4DVO7cvNg==
Date:   Tue, 19 Jul 2022 11:47:26 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Boris Burkov <boris@bur.io>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@fb.com
Subject: Re: [PATCH v12 2/5] common/verity: support btrfs in generic fsverity
 tests
Message-ID: <Ytb8Pirys+103mHU@sol.localdomain>
References: <cover.1658188603.git.boris@bur.io>
 <c2a3bcb8ff16fd6b1ce8c300ee5e8188ccaddb7a.1658188603.git.boris@bur.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c2a3bcb8ff16fd6b1ce8c300ee5e8188ccaddb7a.1658188603.git.boris@bur.io>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Jul 18, 2022 at 04:58:30PM -0700, Boris Burkov wrote:
> +# btrfs will return IO errors on corrupted data with or without fs-verity.
> +# to really test fs-verity, use nodatasum.
> +if [ "$FSTYP" == "btrfs" ]; then
> +        if [ -z $MOUNT_OPTIONS ]; then
> +                export MOUNT_OPTIONS="-o nodatasum"
> +        else
> +                export MOUNT_OPTIONS+=" -o nodatasum"
> +        fi
> +fi

$MOUNT_OPTIONS needs to be quoted in the if expression.  Otherwise -o is treated
as the OR operator.  Fun fact, [ -z -o foo ] evaluates to true...

> +	echo "Checking for SIGBUS or zeros..."
> +	<$tmp.eof_block_read grep -q -e '^Bus error$' \

This line is odd.  It would be easier to read as:

	grep -q -e '^Bus error$' $tmp.eof_block_read

Other than that, this patch looks fine.  Thanks!

- Eric
