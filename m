Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2AD306DD08A
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Apr 2023 05:56:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229523AbjDKD4J (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 23:56:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52856 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229864AbjDKD4I (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 23:56:08 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C2CD2118
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 20:56:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 28F31619F4
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 03:56:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63CA0C433EF;
        Tue, 11 Apr 2023 03:56:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681185366;
        bh=ecWHF70rXwrETEUTjPyHD1P2ivDz65wXH/nbSUVkHuw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=qTwGp16dEV9CsDzo7vyYSdgu8RXE8ctZClpYCaMaxetj315E3QsIKQnDQ9FnfHCRj
         M0ipBH5jRD9KNmVJQ+MzyzQGymMPQarMM8vSt8LRTDmCzWuSX0f1twJx7Ixa+x8wPo
         ly9hf61nn6x0JHLX86wguBiNI8KQsjFw2maFILv6bOtQWfD9hrE9f+781mlrzwcmo2
         jiWaFQ9JS/Lj2DiERAlOhy1aGNazfLG7SdX6R5U6WsJHd6mJnhcArkmOapzmIlybbT
         4wUxyWW1YL+ny6n+iJhOxaBDB9qHL4y5xfOzsyDhPy2faKfSniAoaFOw+7p5/4xuzG
         MrR9Hi9GRmcYg==
Date:   Mon, 10 Apr 2023 20:56:04 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 07/11] fscrypt: move all the shared mode key setup
 deeper
Message-ID: <20230411035604.GG47625@sol.localdomain>
References: <cover.1681155143.git.sweettea-kernel@dorminy.me>
 <07509950e40e37344aac535a07d8176f680a7e18.1681155143.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <07509950e40e37344aac535a07d8176f680a7e18.1681155143.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Apr 10, 2023 at 03:40:00PM -0400, Sweet Tea Dorminy wrote:
> +static const u8 FSCRYPT_POLICY_FLAGS_KEY_MASK =
> +	(FSCRYPT_POLICY_FLAG_DIRECT_KEY
> +	 | FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64
> +	 | FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32);

A comment describing the meaning of the above constant would be helpful.

> +static size_t fill_hkdf_info(const struct fscrypt_info *ci, u8 *hkdf_info)

Maybe call this fill_hkdf_info_for_mode_key() to avoid ambiguity with other uses
of HKDF?  Also, maybe add an explicit array size to hkdf_info?  E.g.
hkdf_info[MAX_MODE_KEY_HKDF_INFO_SIZE]

> +static u8 hkdf_context_for_policy(const union fscrypt_policy *policy)
> +{
> +	switch (fscrypt_policy_flags(policy) & FSCRYPT_POLICY_FLAGS_KEY_MASK) {
> +		case FSCRYPT_POLICY_FLAG_DIRECT_KEY:
> +			return HKDF_CONTEXT_DIRECT_KEY;
> +		case FSCRYPT_POLICY_FLAG_IV_INO_LBLK_64:
> +			return HKDF_CONTEXT_IV_INO_LBLK_64_KEY;
> +		case FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32:
> +			return HKDF_CONTEXT_IV_INO_LBLK_32_KEY;
> +		default:
> +			return 0;
> +	}
> +}

There's an extra level of indentation above.

Also, more importantly, since fill_hkdf_info() checks the policy flags anyway,
maybe just handle the HKDF context bytes directly in there?  E.g.:

	if (ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_DIRECT_KEY) {
		hkdf_info[0] = HKDF_CONTEXT_DIRECT_KEY;
		return 1;
	}
	if (ci->ci_policy.v2.flags & FSCRYPT_POLICY_FLAG_IV_INO_LBLK_32)
		hkdf_info[0] = HKDF_CONTEXT_IV_INO_LBLK_32_KEY;
	else
		hkdf_info[0] = HKDF_CONTEXT_IV_INO_LBLK_64_KEY;
	memcpy(&hkdf_info[1], &sb->s_uuid, sizeof(sb->s_uuid));
	return 1 + sizeof(sb->s_uuid);

- Eric
