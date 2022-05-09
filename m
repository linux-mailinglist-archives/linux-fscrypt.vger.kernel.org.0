Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B3E520740
	for <lists+linux-fscrypt@lfdr.de>; Mon,  9 May 2022 23:56:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbiEIWAa (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 May 2022 18:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231168AbiEIWA3 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 May 2022 18:00:29 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 17332737A0;
        Mon,  9 May 2022 14:56:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A7FBC60C72;
        Mon,  9 May 2022 21:56:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C433EC385C2;
        Mon,  9 May 2022 21:56:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652133393;
        bh=wHLWT1Gll/cvK2j3e8LMoFzDmeDWBW7dkJOSEFpCqlk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=msh/uKHQvklZ0wtmp5N5Of0ULdBVEMKEg8ske61MFbi1y/PAYyOhfESYV7FT2qlfS
         btnhan/bTDBZvgENyc8vd/6SsewsY+NoV7a3+l7rL117i4eTpufFz4LMWltbuPmhvF
         cdHQb8D6oVaW2z38/EwfKBReboVoN3zIABXNTcx183dvsxdz+ntAHxi/Cz3nwJkGq8
         uL1GVTACgW0+ggSEkvKfFM0QhvWhMOawGDf2WsNmjJD/rlNpKUOSoqZXvyZOE2HMf0
         LNXqNrpZeSDFRGItCZq2XUzRsk2lgHNug9hz5F3NQNRGNKEYdA1VlF4htCGpvdob1g
         7atWZNlj+I/kw==
Date:   Mon, 9 May 2022 14:56:31 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     linux-crypto@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>,
        linux-arm-kernel@lists.infradead.org,
        Paul Crowley <paulcrowley@google.com>,
        Sami Tolvanen <samitolvanen@google.com>,
        Ard Biesheuvel <ardb@kernel.org>
Subject: Re: [PATCH v7 6/9] crypto: arm64/aes-xctr: Improve readability of
 XCTR and CTR modes
Message-ID: <YnmOD+bzabjoxaEN@sol.localdomain>
References: <20220509191107.3556468-1-nhuck@google.com>
 <20220509191107.3556468-7-nhuck@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509191107.3556468-7-nhuck@google.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, May 09, 2022 at 07:11:04PM +0000, Nathan Huckleberry wrote:
> Added some clarifying comments, changed the register allocations to make
> the code clearer, and added register aliases.
> 
> Signed-off-by: Nathan Huckleberry <nhuck@google.com>
> Reviewed-by: Eric Biggers <ebiggers@google.com>

Did you mean to add Ard's Reviewed-by that he gave on v6 as well?

One comment about the v7 changes below:

>  	/*
>  	 * aes_ctr_encrypt(u8 out[], u8 const in[], u8 const rk[], int rounds,
>  	 *		   int bytes, u8 ctr[])
> +	 *
> +	 * The input and output buffers must always be at least 16 bytes even if
> +	 * encrypting/decrypting less than 16 bytes.  Otherwise out of bounds
> +	 * accesses will occur.
>  	 */

This comment, along with the other similar ones you added, doesn't properly
describe the behavior when bytes < 16, as it's not mentioned that the extra
space needs to be before the pointed-to regions rather than after.  That's the
most unusual part of these functions, so it really should be mentioned.

Separately, applying this patch and the previous one causes the following
whitespace errors to be reported:

Applying: crypto: arm64/aes-xctr: Add accelerated implementation of XCTR
.git/rebase-apply/patch:299: space before tab in indent.
        ld1             {v5.16b-v7.16b}, [x1], #48
warning: 1 line adds whitespace errors.
Applying: crypto: arm64/aes-xctr: Improve readability of XCTR and CTR modes
.git/rebase-apply/patch:216: space before tab in indent.
        ld1             {v5.16b-v7.16b}, [IN], #48
warning: 1 line adds whitespace errors.

- Eric
