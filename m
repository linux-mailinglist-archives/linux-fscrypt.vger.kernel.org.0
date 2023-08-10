Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4487C777089
	for <lists+linux-fscrypt@lfdr.de>; Thu, 10 Aug 2023 08:37:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230147AbjHJGhs (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 10 Aug 2023 02:37:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57128 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229789AbjHJGhs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 10 Aug 2023 02:37:48 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0ADA9C5;
        Wed,  9 Aug 2023 23:37:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9D98864FE0;
        Thu, 10 Aug 2023 06:37:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE155C433C7;
        Thu, 10 Aug 2023 06:37:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1691649467;
        bh=iKsNzqG8yEomJegPTh4Mn9vJhmb5CLlpGTRkksWD2H0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=uKS5aJrJPCvYs6NPu57FfIhFBRM946s2PlXMlCPJBUlVuJ+JjSbDJ0j00hY9HEBZa
         beQlWN2BwZEGIocUqrx7B20Ha+t4EsS62qfuPaFfWRk98i2lWUH7DFWsZMfLXVf6LO
         gwdfCQZMxRDICGnmUmhV1Iro5Qa+ivyqovgHEwj/VmSmCsUhL+UHFQSV1WHWY7YVSn
         pgKKYPgX1EmYwYFSXd5ukkrr6GaN1CdMxWxR2kr87/lcbgbGfbv7zM7teRnxFEz3HS
         +zTMTfhXUWcnwvJ/lit1mL4gQs3KRgKJy9XC7hh8QcevpIyDZtH+ASbqURJjQwphj/
         Vjd+WnS9rnomA==
Date:   Wed, 9 Aug 2023 23:37:45 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v6 3/8] fscrypt: split setup_per_mode_enc_key()
Message-ID: <20230810063745.GF923@sol.localdomain>
References: <cover.1691505830.git.sweettea-kernel@dorminy.me>
 <cd8fffce4ec37af89c5f92fd8077e7f055fccc0e.1691505830.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cd8fffce4ec37af89c5f92fd8077e7f055fccc0e.1691505830.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Aug 08, 2023 at 01:08:03PM -0400, Sweet Tea Dorminy wrote:
> +static int find_mode_prepared_key(struct fscrypt_info *ci,
> +				  struct fscrypt_master_key *mk,
> +				  struct fscrypt_prepared_key *keys,
> +				  u8 hkdf_context, bool include_fs_uuid)
> +{
> +	struct fscrypt_mode *mode = ci->ci_mode;
> +	const u8 mode_num = mode - fscrypt_modes;
> +	struct fscrypt_prepared_key *prep_key;
> +	int err;
> +
> +	if (WARN_ON_ONCE(mode_num > FSCRYPT_MODE_MAX))
> +		return -EINVAL;
> +
> +	prep_key = &keys[mode_num];
> +	if (fscrypt_is_key_prepared(prep_key, ci)) {
> +		ci->ci_enc_key = *prep_key;
> +		return 0;
> +	}
> +	err = setup_new_mode_prepared_key(mk, prep_key, ci, hkdf_context,
> +					  include_fs_uuid);
> +	if (err)
> +		return err;
> +
> +	ci->ci_enc_key = *prep_key;
> +	return 0;
> +}

Any thoughts about the feedback I gave about this on v2
(https://lore.kernel.org/linux-fscrypt/20230411032935.GC47625@sol.localdomain/)?
The new naming with "find" seems wrong.

- Eric
