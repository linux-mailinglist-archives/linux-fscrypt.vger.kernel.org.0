Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFBB86DD0A6
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Apr 2023 06:05:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229889AbjDKEF4 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Apr 2023 00:05:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59216 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229879AbjDKEFz (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Apr 2023 00:05:55 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9ABC81BE8
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 21:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3566061D3F
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 04:05:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71684C433EF;
        Tue, 11 Apr 2023 04:05:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681185953;
        bh=z31uBCVcAAFTQhcX2YaqHMpt6lvjgXuCm4uwx+wIe1E=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ESHF6WtsGIXpFGWAkDdUrRdl0lWxusuvh0unDJwJyHsPQL8JsL9XzG6YgFwSmnMWz
         0OWAJdSmGrcetm/vlsdYnvNfv2nscWplC3OaSrOy+mmv/Ethm5BZmyvzTKj8UDOIF+
         71f+EP8WTFaCjlkFkYPKdOY5qdlqbAQ+ekN8NGYFu9FQnOkEiHc1QqgICeV3znUg6q
         zV7vH+Ohk5u+R3hncd8fzkx02L+c3VW6jHvBoEILMxZFhBgXag0xfHP363QUG7tS8/
         XkD6wFHn17PwCoNw/7Ce3NkK2loJKDTM7IIkws1JXNPzjX9jlsCK7hs01lwMFRhaww
         oo+rrI7U6EneQ==
Date:   Mon, 10 Apr 2023 21:05:51 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 10/11] fscrypt: explicitly track prepared parts of key
Message-ID: <20230411040551.GI47625@sol.localdomain>
References: <cover.1681155143.git.sweettea-kernel@dorminy.me>
 <2a9bf42af2b2ac6289d0ac886d1f07042feafbe5.1681155143.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a9bf42af2b2ac6289d0ac886d1f07042feafbe5.1681155143.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Apr 10, 2023 at 03:40:03PM -0400, Sweet Tea Dorminy wrote:
> So far, it has sufficed to allocate and prepare the block key or the TFM
> completely before ever setting the relevant field in the prepared key.
> This is necessary for mode keys -- because multiple inodes could be
> trying to set up the same per-mode prepared key at the same time on
> different threads, we currently must not set the prepared key's tfm or
> block key pointer until that key is completely set up. Otherwise,
> another inode could see the key to be present and attempt to use it
> before it is fully set up.
> 
> But when using pooled prepared keys, we'll have pre-allocated fields,
> and if we separate allocating the fields of a prepared key from
> preparing the fields, that inherently sets the fields before they're
> ready to use. So, either pooled prepared keys must use different
> allocation and setup functions, or we can split allocation and
> preparation for all prepared keys and use some other mechanism to signal
> that the key is fully prepared.
> 
> In order to avoid having similar yet different functions, this function
> adds a new field to the prepared key to explicitly track which parts of
> it are prepared, setting it explicitly. The same acquire/release
> semantics are used to check it in the case of shared mode keys; the cost
> lies in the extra byte per prepared key recording which members are
> fully prepared.
> 
> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
> ---
>  fs/crypto/fscrypt_private.h | 26 +++++++++++++++-----------
>  fs/crypto/inline_crypt.c    |  8 +-------
>  fs/crypto/keysetup.c        | 36 ++++++++++++++++++++++++++----------
>  3 files changed, 42 insertions(+), 28 deletions(-)

I wonder if this is overcomplicating things and we should simply add a new
rw_semaphore to struct fscrypt_master_key and use it to protect the per-mode key
preparation, instead of trying to keep the fast path lockless?

So the flow (for setting up a file that uses a per-mode key) would look like:

        down_read(&mk->mk_mode_key_prep_sem);
        if key already prepared, unlock and return
        up_read(&mk->mk_mode_key_prep_sem);

        down_write(&mk->mk_mode_key_prep_sem);
        if key already prepared, unlock and return
        prepare the key
        up_write(&mk->mk_mode_key_prep_sem);

Lockless algorithms are nice, but we shouldn't take them too far if they cause
too much trouble...

- Eric
