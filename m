Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9238F666526
	for <lists+linux-fscrypt@lfdr.de>; Wed, 11 Jan 2023 21:59:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234049AbjAKU7Q (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 11 Jan 2023 15:59:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234545AbjAKU6n (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 11 Jan 2023 15:58:43 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E901DF16;
        Wed, 11 Jan 2023 12:58:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D976461E0B;
        Wed, 11 Jan 2023 20:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34E0BC433F0;
        Wed, 11 Jan 2023 20:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673470718;
        bh=sTNb1ZUNuHuHWFtUWWqy+u4jtukWpmRO/yAqd4y0neE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=o6AYB3C0IhPgOAjtVD5Y0guy8lmtq2UKWTo3brIkZqrmyqdPwKlLTaLZzMVJkMZQR
         Bkf6bNn+E0AjtERzRtADIc6jBiv3HLUrwgZy1taMzamYDYiy0u339Vtlr5j8AJtVnd
         RSv/NiNMn67GpANRGxUkomGaVyIJwqpD3MC6uVmv0p2mS7U+UFxRuN5eWIYKwgiKLx
         M1nFdSFtFq30lc5TDSQOWbL23AWjJANquLR72/IFdyb9Z15gjKFs8AJbWE9Bsl5ITN
         U9akWvnppAXZhPwtVcXsX/sRkuorUOZlLdyZdTkwzy+wxsY6NK4TVv89gtVL1RFMZt
         0dslRq8aYldGg==
Date:   Wed, 11 Jan 2023 12:58:36 -0800
From:   Eric Biggers <ebiggers@kernel.org>
To:     fstests@vger.kernel.org
Cc:     linux-fscrypt@vger.kernel.org,
        Ojaswin Mujoo <ojaswin@linux.ibm.com>
Subject: Re: [PATCH v2] generic/692: generalize the test for non-4K Merkle
 tree block sizes
Message-ID: <Y78i/G9cFZk0LmAo@sol.localdomain>
References: <20230111204739.77828-1-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111204739.77828-1-ebiggers@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jan 11, 2023 at 12:47:39PM -0800, Eric Biggers wrote:
> +bs=$FSV_BLOCK_SIZE
> +hash_size=32   # SHA-256
> +hash_per_block=$(echo "scale=30; $bs/($hash_size)" | $BC -q)
> +
> +# Compute the proportion of the original file size that the non-leaf levels of
> +# the Merkle tree take up.  Ignoring padding, this is 1/${hashes_per_block}^2 +
> +# 1/${hashes_per_block}^3 + 1/${hashes_per_block}^4 + ...  Compute it using the

Sorry, just saw a couple minor things to fix.  v3 incoming...

- Eric
