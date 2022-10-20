Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A69D5606A69
	for <lists+linux-fscrypt@lfdr.de>; Thu, 20 Oct 2022 23:40:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiJTVkq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 17:40:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229932AbiJTVkp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 17:40:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 86D1218E2A8;
        Thu, 20 Oct 2022 14:40:43 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1A0E7B82767;
        Thu, 20 Oct 2022 21:40:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6FD3EC433D6;
        Thu, 20 Oct 2022 21:40:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666302040;
        bh=QXhsit7Hwrz5smmoQ+U8d5E1+j4GcjrLM1pnHlopCEI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=G1XpQS8/hKxXsPd9RTfZPOQkGtkQAyj2NUoTw1dYgZ1fgyVn+ix79UXGED/PrakIE
         bcBVqKkw5czEFnj87ict/wcizTF8Oe8pRBArMFDHlWvz1eakik4kvZ3PhyJ0pYs6OX
         TLkVdWNFQDa3d1zqsXqjoYWSnI5k3sFfzX9nuClZXbl8vMR1tN7+wlfjpP8+DJaRnT
         WY4yaSzSWvEra2aX69NJ9qv+/9ayN/knygEBAV2fwlHI9R87iD4E+qOMZXXedBfynp
         c2Z9qMFCgw8m9CWpNCkt8D5oFpK5nyhzT+to2vOWbtgY7wtg3VULAQFLpBYOtHM58G
         nJaHzDs4NHdMQ==
Date:   Thu, 20 Oct 2022 14:40:38 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v3 04/22] fscrypt: add extent-based encryption
Message-ID: <Y1HAVm8F3U/b+Ic2@sol.localdomain>
References: <cover.1666281276.git.sweettea-kernel@dorminy.me>
 <d7246959ee0b8d2eeb7d6eb8cf40240374c6035c.1666281277.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d7246959ee0b8d2eeb7d6eb8cf40240374c6035c.1666281277.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, Oct 20, 2022 at 12:58:23PM -0400, Sweet Tea Dorminy wrote:
> +
> +/*
> + * fscrypt_extent_context - the encryption context for an extent
> + *
> + * For filesystems that support extent encryption, this context provides the
> + * necessary randomly-initialized IV in order to encrypt/decrypt the data
> + * stored in the extent. It is stored alongside each extent, and is
> + * insufficient to decrypt the extent: the extent's owning inode(s) provide the
> + * policy information (including key identifier) necessary to decrypt.
> + */
> +struct fscrypt_extent_context_v1 {
> +	u8 version;
> +	union fscrypt_iv iv;
> +} __packed;

On the previous version I had suggested using a 16-byte nonce per extent, so
that it's the same as the inode-based case.  Is there a reason you didn't do
that?

- Eric
