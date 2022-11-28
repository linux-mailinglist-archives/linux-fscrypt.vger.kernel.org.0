Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1174D63B18C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Nov 2022 19:44:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232030AbiK1Sov (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Nov 2022 13:44:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231743AbiK1Sou (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Nov 2022 13:44:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB1ED132;
        Mon, 28 Nov 2022 10:44:49 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BCCBAB80E9E;
        Mon, 28 Nov 2022 18:44:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 606EBC433C1;
        Mon, 28 Nov 2022 18:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669661086;
        bh=G51+0qBa8uFG2fCGIrC9eOsWrvLMH5foF69kYPIeOV4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a802eFOx4Qg7inDSdvH/fydqzvE9cWptdtPYQWrZJ2AoTsnPI/X4e4j84RWkh9hKq
         pge/ULKBx1g4dpARd6yCtuocnCpiCJL/h755rmhclp2cL1JWo1ZUeZDIMKzv2wu7wD
         VSqqjwe7v6XJWH59wE4iFCgeAOM1DnIIYBF5ptjQ2s/DZIdfiV0GzcuF443bG23hWl
         G0U23zBWjnw9NANzaXOFP1hmnUtWgDo2LYsPenxY7AzwG4Io2PWOK1rG3JMwbfBgqc
         woGIAIauM7dYoJWHYuc47NmCulVO2SqYgSTBj+EfZapR/Nw1a5Khr1oGhxbEvovg3R
         +hX/JeCQkyCug==
Date:   Mon, 28 Nov 2022 18:44:32 +0000
From:   Eric Biggers <ebiggers@kernel.org>
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>,
        Paul Crowley <paulcrowley@google.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com,
        Omar Sandoval <osandov@osandov.com>, Chris Mason <clm@fb.com>
Subject: Re: [PATCH v5 00/18] btrfs: add fscrypt integration
Message-ID: <Y4UBkNoCgLyUhyvH@gmail.com>
References: <cover.1667389115.git.sweettea-kernel@dorminy.me>
 <CA+_SqcAFMXjW6V2u1NZzGwBe4na4m_FBspgP0Z6Q0oTvT+QJVQ@mail.gmail.com>
 <81e3763c-2c02-2c9f-aece-32aa575abbca@dorminy.me>
 <55686ed2-b182-3478-37aa-237e306be6e1@dorminy.me>
 <4857f0df-dae0-178e-85e3-307197701d34@dorminy.me>
 <Y4RqbKSdxQ5owg0h@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y4RqbKSdxQ5owg0h@infradead.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sun, Nov 27, 2022 at 11:59:40PM -0800, Christoph Hellwig wrote:
> On Wed, Nov 23, 2022 at 08:22:30PM -0500, Sweet Tea Dorminy wrote:
> > The document has been updated to hopefully reflect the discussion we had;
> > further comments are always appreciated. https://docs.google.com/document/d/1janjxewlewtVPqctkWOjSa7OhCgB8Gdx7iDaCDQQNZA/edit?usp=sharing
> 
> How is this going to work with hardware encryption offload?  I think
> the number of keys for UFS and eMMC inline encryption, but Eric may
> correct me.

First, traditional crypto accelerators via the crypto API will work in any case.
I think your question is specifically about inline encryption
(https://www.kernel.org/doc/html/latest/block/inline-encryption.html).

To use inline encryption hardware, consecutive blocks must use consecutive IVs,
and the nonzero part of the IVs needs to fit within the hardware's DUN size.
That's 64 bits for the UFS standard, and 32 bits for the eMMC standard.

fscrypt's "default" setting of per-file keys satisfies both of those
requirements.  That means the current proposal for btrfs does too, since it's
the same as that "default" setting -- just with extents instead of files.
(For eMMC, extents would have to be limited to 2^32 blocks.)

The other consideration, which seems to be what you're asking about, is a
performance one: how well this performs on hardware where switching keys is very
expensive.  The answer is not very well.  Of course, that's the answer for
per-file keys too.  Note that this is an issue for some inline encryption
hardware (e.g. Qualcomm ICE), but not others (e.g. Exynos FMP, Mediatek UFS).

The way this problem is "solved" in ext4 and f2fs is by also providing the (less
than cryptographically ideal) settings IV_INO_LBLK_64 and IV_INO_LBLK_32.  Those
squeeze the inode number *and* file offset into a 64-bit or 32-bit IV, so that
per-file keys aren't needed.

There's a natural mapping of the IV_INO_LBLK_* settings onto extent-based
encryption.  A 32-bit extent number would just be used instead of an inode
number.  Or, if a 32-bit extent number is infeasible, an extent nonce of any
length hashed with a secret key could be used instead.

So yes, it would be possible to provide settings that optimize for hardware like
Qualcomm ICE, as ext4 and f2fs do with IV_INO_LBLK_*.  However, it makes sense
to leave that for later until if/when someone actually has a use case for it.

- Eric
