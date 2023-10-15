Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 506D57C9825
	for <lists+linux-fscrypt@lfdr.de>; Sun, 15 Oct 2023 08:23:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229872AbjJOGXD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 15 Oct 2023 02:23:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjJOGXC (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 15 Oct 2023 02:23:02 -0400
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9D3DC5;
        Sat, 14 Oct 2023 23:23:00 -0700 (PDT)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 41ACEC433C8;
        Sun, 15 Oct 2023 06:23:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1697350980;
        bh=mZRpTjzFzUS02FE095oUZ3j3BI1TWewcgAkfXK7XV+g=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=MIktqqMNRWXlUEBOPwJZimBEhXWZ9rUuI3nS6ZfR6+P6iwaMvp/sn4QavBvBcyMCO
         IGQdaOmmJIOXu6XIBQvTsepEWfHAi7/5k+LKpvw2wj7W73aG32Vve0yDqvahS1lcJq
         5DYwm2bmtCZh4+2f6yMLxg/r8NqfxO39jLuVM/48bMU0B8iU1N1Qjawd+Vv/2pZMV1
         jXFkA+yn5p+1XaSYfqmnBTptuwjCl4ocytldbrDitskf9DduO0/YTQiIqZlfIHFRTZ
         uslyezMuPsZzJsE+bj9l0B+8f+XE1LXbTaLdGNTG3iPFh0yCI0ASc6OmCI4/HvNytm
         qam3bT47pk/sw==
Date:   Sat, 14 Oct 2023 23:22:58 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Josef Bacik <josef@toxicpanda.com>
Cc:     linux-fscrypt@vger.kernel.org, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 01/36] fscrypt: use a flag to indicate that the master
 key is being evicted
Message-ID: <20231015062258.GA10525@sol.localdomain>
References: <cover.1696970227.git.josef@toxicpanda.com>
 <e86c16dddc049ff065f877d793ad773e4c6bfad9.1696970227.git.josef@toxicpanda.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e86c16dddc049ff065f877d793ad773e4c6bfad9.1696970227.git.josef@toxicpanda.com>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Tue, Oct 10, 2023 at 04:40:16PM -0400, Josef Bacik wrote:
> Currently we wipe the mk->mk_secret when we remove the master key, and
> we use this status to tell everybody whether or not the master key is
> available for use.
> 
> With extent based encryption we're going to need to keep the secret
> around until the inode is evicted, so we need a different mechanism to
> tell everybody that the key is currently unusable.
> 
> Accomplish this with a mk_flags member in the master key, and update the
> is_master_key_secret_present() helper to return the status of this bit.
> Update the removal and adding helpers to manipulate this bit and use it
> as the source of truth about whether or not the key is available for
> use.
> 
> Signed-off-by: Josef Bacik <josef@toxicpanda.com>
> ---
>  fs/crypto/fscrypt_private.h | 17 ++++++++---------
>  fs/crypto/hooks.c           |  2 +-
>  fs/crypto/keyring.c         | 20 ++++++++++++++------
>  fs/crypto/keysetup.c        |  4 ++--
>  4 files changed, 25 insertions(+), 18 deletions(-)

Thanks, this patch seems like it's on the right track.  There are a lot of
little things that need to be updated to be consistent, though.  I'm also
thinking we should do it the other way around, where we explicitly mark the key
as "present", matching the terminology used in the UAPI for
FS_IOC_GET_ENCRYPTION_KEY_STATUS.  I also noticed two bugs: BIT(0) should be 0,
and the code in add_existing_master_key() is racy.

Can you take a look at the patch
"fscrypt: track master key presence separately from secret"
(https://lore.kernel.org/r/20231015061055.62673-1-ebiggers@kernel.org)
I just sent out?  It's a replacement for this one.

- Eric
