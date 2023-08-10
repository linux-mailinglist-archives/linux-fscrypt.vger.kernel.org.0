Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C786777122
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Aug 2023 09:19:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230304AbjHJHTJ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Aug 2023 03:19:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229934AbjHJHTJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Aug 2023 03:19:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F2FC10C;
        Thu, 10 Aug 2023 00:19:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 949C764F23;
        Thu, 10 Aug 2023 07:19:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A83C7C433C8;
        Thu, 10 Aug 2023 07:19:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691651948;
        bh=b8Myjv7EUeYaB0THCTW/6EaRif4JFFlb8kxQgdY9FoA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jPj5/eO+PoK0F5nz2LM6LzERa0OfTt+oN05/8sfpAGTpK3YZcKsxbKpef9HJa3vv8
         IUjCsmANLq1S5NerWIFhaVHLeEZTdNEmXCaSmQ7vdi6xVoTrv8Ql1ZeMND72mzj13C
         sTcYrU4tppM7ixU0J5tBCRsyGF5RI/AcjaohxI3/+Pb1YPGoB9sGcG2ehvHvAysG9l
         +el8EtJyPgEsUihC53uf6RaoY2CG3rmdhhkKZQgI+aDRoJoXijJN5eiGkFx+dPlUJq
         1dg3ac8374QoI8sUbYa+F3ueu11Qm3ncgZ+M7EfBupcOKvhotyQ9WkjNtH27Em0McW
         SQBAUe1I5ky3A==
Date:   Thu, 10 Aug 2023 00:19:05 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v6 8/8] fscrypt: make prepared keys record their type
Message-ID: <20230810071905.GI923@sol.localdomain>
References: <cover.1691505830.git.sweettea-kernel@dorminy.me>
 <64c47243cea5a8eca15538b51f88c0a6d53799cf.1691505830.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <64c47243cea5a8eca15538b51f88c0a6d53799cf.1691505830.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 08, 2023 at 01:08:08PM -0400, Sweet Tea Dorminy wrote:
> +/**
> + * enum fscrypt_prepared_key_type - records a prepared key's ownership
> + *
> + * @FSCRYPT_KEY_PER_INFO: this prepared key is allocated for a specific info
> + *		          and is never shared.
> + * @FSCRYPT_KEY_DIRECT_V1: this prepared key is embedded in a fscrypt_direct_key
> + *		           used in v1 direct key policies.
> + * @FSCRYPT_KEY_MASTER_KEY: this prepared key is a per-mode and policy key,
> + *			    part of a fscrypt_master_key, shared between all
> + *			    users of this master key having this mode and
> + *			    policy.
> + */
> +enum fscrypt_prepared_key_type {
> +	FSCRYPT_KEY_PER_INFO = 1,
> +	FSCRYPT_KEY_DIRECT_V1,
> +	FSCRYPT_KEY_MASTER_KEY,
> +} __packed;

FSCRYPT_KEY_MASTER_KEY seems misnamed, since it's not for master keys.  It's for
what the code elsewhere calls a per-mode key.  So maybe FSCRYPT_KEY_PER_MODE?

I think your intent was for the name to reflect the struct that the
fscrypt_prepared_key is embedded in.  I don't think that's obvious as-is.  If
you want to name it that way, it should be made super clear, like this:

    enum fscrypt_prepared_key_owner {
            FSCRYPT_KEY_OWNED_BY_INFO = 1,
            FSCRYPT_KEY_OWNED_BY_DIRECT_V1,
            FSCRYPT_KEY_OWNED_BY_MASTER_KEY,
    };

But, I think I'm leaning towards your proposal with
s/FSCRYPT_KEY_MASTER_KEY/FSCRYPT_KEY_PER_MODE/.

- Eric
