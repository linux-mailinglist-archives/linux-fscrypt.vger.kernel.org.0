Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B69FA52DED0
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 22:56:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239760AbiESU4b (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 May 2022 16:56:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244935AbiESU4N (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 May 2022 16:56:13 -0400
Received: from bhuna.collabora.co.uk (bhuna.collabora.co.uk [46.235.227.227])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33F0859BB0;
        Thu, 19 May 2022 13:56:11 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1])
        (Authenticated sender: krisman)
        with ESMTPSA id 98FC71F45F77
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1652993769;
        bh=6q8ppakx2OLJ492VVGe2mKKo6sKvvEbdlNxvarzehx0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=jtvFkbzLZbLw3d/1nWM2lRi8vLH4axjUG3mYYmdR5vh/IIluywymCnr/nIwgVe9eh
         cxlPJDsYc6fsWXS6jTMq0Ry23BZctZ74CP686IkyV1ffmySXArz25RU8HEe6VPfJUn
         GlkDaw9S6224ZvtOojs7lTysa9WdJ4fjwc0qD7j2h1LEB8kVvAn40b9scBPksxhfY0
         mWkLohNxxkvrDVvFl6DPtPs4IgOQQYG4bMd68EQ8GKpcSqqqix9aeshgiM1/kKYECb
         SWsor9R/C8ObYeuWT0uCmWJig5o4B2rLqkCdOGa+xkunQzBlf2JtOb4VfVVdzpWUH3
         NnQztpLCDUudQ==
From:   Gabriel Krisman Bertazi <krisman@collabora.com>
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-ext4@vger.kernel.org, Theodore Ts'o <tytso@mit.edu>,
        linux-fscrypt@vger.kernel.org
Subject: Re: [PATCH v4] ext4: only allow test_dummy_encryption when supported
Organization: Collabora
References: <20220519204437.61645-1-ebiggers@kernel.org>
Date:   Thu, 19 May 2022 16:56:06 -0400
In-Reply-To: <20220519204437.61645-1-ebiggers@kernel.org> (Eric Biggers's
        message of "Thu, 19 May 2022 13:44:37 -0700")
Message-ID: <877d6hnswp.fsf@collabora.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/27.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNPARSEABLE_RELAY autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Eric Biggers <ebiggers@kernel.org> writes:

> From: Eric Biggers <ebiggers@google.com>
>
> Make the test_dummy_encryption mount option require that the encrypt
> feature flag be already enabled on the filesystem, rather than
> automatically enabling it.  Practically, this means that "-O encrypt"
> will need to be included in MKFS_OPTIONS when running xfstests with the
> test_dummy_encryption mount option.  (ext4/053 also needs an update.)
>
> Moreover, as long as the preconditions for test_dummy_encryption are
> being tightened anyway, take the opportunity to start rejecting it when
> !CONFIG_FS_ENCRYPTION rather than ignoring it.
>
> The motivation for requiring the encrypt feature flag is that:
>
> - Having the filesystem auto-enable feature flags is problematic, as it
>   bypasses the usual sanity checks.  The specific issue which came up
>   recently is that in kernel versions where ext4 supports casefold but
>   not encrypt+casefold (v5.1 through v5.10), the kernel will happily add
>   the encrypt flag to a filesystem that has the casefold flag, making it
>   unmountable -- but only for subsequent mounts, not the initial one.
>   This confused the casefold support detection in xfstests, causing
>   generic/556 to fail rather than be skipped.
>
> - The xfstests-bld test runners (kvm-xfstests et al.) already use the
>   required mkfs flag, so they will not be affected by this change.  Only
>   users of test_dummy_encryption alone will be affected.  But, this
>   option has always been for testing only, so it should be fine to
>   require that the few users of this option update their test scripts.
>
> - f2fs already requires it (for its equivalent feature flag).
>
> Signed-off-by: Eric Biggers <ebiggers@google.com>

Makes sense to me and code looks good.  Please add:

Reviewed-by: Gabriel Krisman Bertazi <krisman@collabora.com>

-- 
Gabriel Krisman Bertazi
