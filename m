Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D16657C982F
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 Oct 2023 08:32:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjJOGch (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 15 Oct 2023 02:32:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjJOGcg (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 15 Oct 2023 02:32:36 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D6551C5;
        Sat, 14 Oct 2023 23:32:35 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8B2C433C8;
        Sun, 15 Oct 2023 06:32:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697351555;
        bh=d6xuGOzJZuwgxDsW1KDIXHD7c4zgZAlt19ISSXfUsRQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=afuskj+eSjn5goaasZk2ohUalSh4RQn/57gw9Cv0Bqz/+vhs/bKkx07a9xK3nXSPa
         II3s8NLkxL6A3bEdIh1S+Cw3+OmfUJ0M62Sv4frdXqOgFA03BYy3McrUKvJSGz2ewJ
         CVcE0/51ax3RCLAnoBLfWIohg3TfMDPswO5gsbHuFnGEGqoJL+sPaP1ULKVcmvlZMR
         YORsudrrSv3cBh4IHgONztOny2sYLNruxW5F8YqPTB1QkxyOyux609TOsHFtD8zOE2
         S5opfDksetDsuSLUJxRn9YbSnSYLFQQWJsaN7fidVHZ9HyWBR5WMmM0Tt+pJQuNpP9
         4wUucy4JAnheA==
Date:   Sat, 14 Oct 2023 23:32:33 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 05/36] blk-crypto: add a process bio callback
Message-ID: <20231015063233.GD10525@sol.localdomain>
References: <cover.1696970227.git.josef@toxicpanda.com>
 <ab3493e225d34845fa953c429b3cd07c112ec7e7.1696970227.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ab3493e225d34845fa953c429b3cd07c112ec7e7.1696970227.git.josef@toxicpanda.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 10, 2023 at 04:40:20PM -0400, Josef Bacik wrote:
> diff --git a/include/linux/blk-crypto-profile.h b/include/linux/blk-crypto-profile.h
> index 90ab33cb5d0e..3c002e85631a 100644
> --- a/include/linux/blk-crypto-profile.h
> +++ b/include/linux/blk-crypto-profile.h
> @@ -100,6 +100,13 @@ struct blk_crypto_profile {
>  	 */
>  	struct device *dev;
>  
> +	/**
> +	 * @process_bio_supported: Some things, like btrfs, require the
> +	 * encrypted data for checksumming. Drivers set this to true if they can
> +	 * handle the process_bio() callback.
> +	 */
> +	bool process_bio_supported;
> +

Is there any reason to think that real inline encryption hardware could support
this?  For the encryption case it seems impossible, since Linux never gets
access to the ciphertext unless it reads it back from disk.

So, given the dependency on blk-crypto-fallback, I'm wondering if we should just
do something like 'profile == blk_crypto_fallback_profile' instead of having
this bool in the struct blk_crypto_profile.

- Eric
