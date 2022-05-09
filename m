Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BFDFE5209A1
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 May 2022 01:44:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232480AbiEIXse (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 9 May 2022 19:48:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233160AbiEIXrb (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 9 May 2022 19:47:31 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2BCD52CE230;
        Mon,  9 May 2022 16:40:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68BEBB819D6;
        Mon,  9 May 2022 23:40:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DDCDFC385C2;
        Mon,  9 May 2022 23:40:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652139629;
        bh=RLRAqi8NcpOLCm0sad+42+BXu2XUKaGuSgWzJjtxch0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OB6Bv54N3c1nd1ASVso50lKwDGHnTt3gojR/6u9cXxTNXqkrPFwKTRS22ATNcXBvU
         FupdC/uG4ukZCXgG2H3BNJpxkeS8LLVNxEoyQ2oSocyxx4kH/d0y3mXElKwwvIPtHe
         dUDzt35YsU5vqDWLVD6p/TTs61j/q6G+YoBgJBuENC0jDB0r4IdlyRaI8+FwAgXL8y
         SWkEEEi7WUg2UseIzsD8TmxEY1Uwb+iSOZ9mgm9c9snZ8emFvzxv4f4Zmyt6NUfQOi
         TzMZlseoamQ7+mj8VAL+eVvudLGA3viK3ePWFp7W1RLT3znPRwKTk3rkEthqPAsOpF
         0nMruR3yXmo4g==
Date:   Mon, 9 May 2022 16:40:27 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     linux-fscrypt@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net
Cc:     Jeff Layton <jlayton@kernel.org>,
        Lukas Czerner <lczerner@redhat.com>,
        Theodore Ts'o <tytso@mit.edu>, Jaegeuk Kim <jaegeuk@kernel.org>
Subject: Re: [PATCH v2 5/7] ext4: fix up test_dummy_encryption handling for
 new mount API
Message-ID: <Ynmma+tkA2myRvz6@sol.localdomain>
References: <20220501050857.538984-1-ebiggers@kernel.org>
 <20220501050857.538984-6-ebiggers@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220501050857.538984-6-ebiggers@kernel.org>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

A couple corrections I'll include in the next version:

On Sat, Apr 30, 2022 at 10:08:55PM -0700, Eric Biggers wrote:
> +	if (fc->purpose == FS_CONTEXT_FOR_RECONFIGURE) {
> +		if (fscrypt_dummy_policies_equal(&sbi->s_dummy_enc_policy,
> +						 &ctx->dummy_enc_policy))
> +			return 0;
>  		ext4_msg(NULL, KERN_WARNING,
> -			 "Can't set test_dummy_encryption on remount");
> +			 "Can't set or change test_dummy_encryption on remount");
>  		return -EINVAL;
>  	}

I think this needs to be 'fc->purpose == FS_CONTEXT_FOR_RECONFIGURE ||
fscrypt_is_dummy_policy_set(&sbi->s_dummy_enc_policy)', since ext4 can parse
mount options from both s_mount_opts and the regular mount options.

> +static void ext4_apply_test_dummy_encryption(struct ext4_fs_context *ctx,
> +                                            struct super_block *sb)
> +{
> +	if (!fscrypt_is_dummy_policy_set(&ctx->dummy_enc_policy))
> +		return;

To handle remounts correctly, this needs to be
'!fscrypt_is_dummy_policy_set(&ctx->dummy_enc_policy) ||
fscrypt_is_dummy_policy_set(&EXT4_SB(sb)->s_dummy_enc_policy)'.

- Eric
