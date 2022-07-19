Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DAE357A767
	for <lists+linux-fscrypt@lfdr.de>; Tue, 19 Jul 2022 21:49:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239378AbiGSTtT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 19 Jul 2022 15:49:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiGSTtT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 19 Jul 2022 15:49:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16722491DC;
        Tue, 19 Jul 2022 12:49:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8EB7B618C1;
        Tue, 19 Jul 2022 19:49:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA996C341C6;
        Tue, 19 Jul 2022 19:49:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658260155;
        bh=HAYo79tL5nA/TUGg0/d+zceBgjrEmBxH0qkqTHxd9ds=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=VGhSVCDL0WJrEJUp8HnsbwbJzpYdeBi3+vL8Jj2pPozaKAQhjbY1I6tqxQFB6TKsl
         yorqRFrdIjqzaFruKvAbNtc6xwJ8EuzueyKk83QYpfAOfEdXlfUvT239irBfwKmOUU
         8wlNKu01HZ1cCKutzH0DVaS5yALW5vg+WsEqPcaYLbVrS5UBl4INrHYU1+lYjc23ZI
         YSLG9MWwghDQqbwrJkWXGgUzN975JFUyiJsF46Q+LbekuGs7avuZZ9bFqAABm8q4Jw
         N0hNX7+4jnR6vAd8KZtDeT0fdA/vMvysAlFzKv5sPE7sCTkn2+LfzSMHPHWwy/WgBu
         eOI1dlPPpoY/g==
Date:   Tue, 19 Jul 2022 12:49:14 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     fstests@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Sami Tolvanen <samitolvanen@google.com>
Subject: Re: [RFC PATCH v4 1/2] fscrypt-crypt-util: add HCTR2 implementation
Message-ID: <YtcKugK3KWHri1t3@sol.localdomain>
References: <20220601071811.1353635-1-nhuck@google.com>
 <20220601071811.1353635-2-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220601071811.1353635-2-nhuck@google.com>
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Jun 01, 2022 at 12:18:10AM -0700, Nathan Huckleberry wrote:
> diff --git a/src/fscrypt-crypt-util.c b/src/fscrypt-crypt-util.c
[...]
> +void gf2_128_mul_polyval(ble128 *r, const ble128 *b)
> +{

This function should be static.

> +/*----------------------------------------------------------------------------*
> + *                                 POLYVAL                                     *
> + *----------------------------------------------------------------------------*/

This could use a link to a specification, similar to the other more "unusual"
algorithms in this file.  Try:

		git grep -A1 'Reference:' src/fscrypt-crypt-util.c

Likewise for HCTR2.  The commit message has a link to the HCTR2 paper, but it
should be in the code itself too.  

> +static void polyval_update(const u8 key[POLYVAL_KEY_SIZE],
> +			   const u8 *msg, size_t msglen,
> +			   u8 accumulator[POLYVAL_BLOCK_SIZE])
> +{
> +	ble128 h;
> +	ble128 aligned_accumulator;
> +	size_t chunk_size;
> +	// x^{-128} = x^127 + x^124 + x^121 + x^114 + 1
> +	static const ble128 inv128 = {
> +		cpu_to_le64(1),
> +		cpu_to_le64(0x9204ULL << 48)
> +	};
> +
> +	memcpy(&h, key, POLYVAL_BLOCK_SIZE);
> +	memcpy(&aligned_accumulator, accumulator, POLYVAL_BLOCK_SIZE);
> +	gf2_128_mul_polyval(&h, &inv128);
> +
> +	while (msglen > 0) {
> +		chunk_size = MIN(POLYVAL_BLOCK_SIZE, msglen);
> +		xor((u8 *)&aligned_accumulator, (u8 *)&aligned_accumulator, msg,
> +		    chunk_size);
> +		gf2_128_mul_polyval(&aligned_accumulator, &h);
> +		msg += chunk_size;
> +		msglen -= chunk_size;
> +	}

The partial block support is unnecessary, so POLYVAL_BLOCK_SIZE could be used
instead of chunk_size, and an assertion ASSERT(msglen % POLYVAL_BLOCK_SIZE ==
0) could be added.  See poly1305() in the same file which works similarly.

Otherwise this looks good, thanks!

- Eric
