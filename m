Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D26D6DD010
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Apr 2023 05:18:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjDKDSk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 23:18:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229717AbjDKDSj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 23:18:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63F9EE47
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 20:18:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CC98361FBB
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 03:18:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01D9BC433EF;
        Tue, 11 Apr 2023 03:18:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681183109;
        bh=8rvRdOHnF1fcjzxzj/qKnUrES3KWeAXKEIpCwBngu2A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZLWK/B0Tybyu03uafeuYC6pU4qqHFkrxeNYPgALJ30w4Mwe9lYe03TooAQgVGKDM0
         LJBMjBlTA2/jcEtpZfSlpQTeqwsuQPDkoNkgcu1NwOJlr47uUsOuYt99uf5cElOncU
         IjfZdAzlBknInc2L697FqGbVn42lixKJ0Xuhw4D5FxthDNk0Ik5blHqUbt4fEYilvq
         A/WXNPubHq8j5ijGb1gf6adoSVT8IhJvZNSrI+tXrxN+2XXHN+Z+xOPM6ggYjXVBv/
         uDNf7CP+0MGk/1I5kZt19zPug6nRwLHe8s4mbmNITpCado9FbvxzXZrprapql+N0t1
         Ol4uF358gfvnA==
Date:   Mon, 10 Apr 2023 20:18:27 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 00/11] fscrypt: rearrangements preliminary to extent
 encryption
Message-ID: <20230411031827.GA47625@sol.localdomain>
References: <cover.1681155143.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1681155143.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Sweet Tea,

On Mon, Apr 10, 2023 at 03:39:53PM -0400, Sweet Tea Dorminy wrote:
> As per [1], extent-based encryption needs to split allocating and
> preparing crypto_skciphers, since extent infos will be loaded at IO time
> and crypto_skciphers cannot be allocated at IO time. 
> 
> This changeset undertakes to split the existing code to clearly
> distinguish preparation and allocation of fscrypt_prepared_keys,
> wrapping crypto_skciphers. Elegance of code is in the eye of the
> beholder, but I've tried a decent variety of arrangements here and this
> seems like the clearest result to me; happy to adjust as desired, and
> more changesets coming soon, this just seemed like the clearest cutoff
> point for preliminaries without being pure refactoring.
> 
> Patchset should apply cleanly to fscrypt/for-next (as per base-commit
> below), and pass ext4/f2fs tests (kvm-xfstests is not currently
> succesfully setting up ubifs volumes for me).
> 
> [1] https://lore.kernel.org/linux-btrfs/Y7NQ1CvPyJiGRe00@sol.localdomain/ 
> 
> Changes from v1:
> Included change 1, erroneously dropped, and generated patches using --base.
> 
> Sweet Tea Dorminy (11):
>   fscrypt: move inline crypt decision to info setup.
>   fscrypt: split and rename setup_file_encryption_key()
>   fscrypt: split and rename setup_per_mode_enc_key()
>   fscrypt: move dirhash key setup away from IO key setup
>   fscrypt: reduce special-casing of IV_INO_LBLK_32
>   fscrypt: make infos have a pointer to prepared keys
>   fscrypt: move all the shared mode key setup deeper
>   fscrypt: make ci->ci_direct_key a bool not a pointer
>   fscrypt: make prepared keys record their type.
>   fscrypt: explicitly track prepared parts of key
>   fscrypt: split key alloc and preparation
> 
>  fs/crypto/crypto.c          |   2 +-
>  fs/crypto/fname.c           |   4 +-
>  fs/crypto/fscrypt_private.h |  73 +++++--
>  fs/crypto/inline_crypt.c    |  30 +--
>  fs/crypto/keysetup.c        | 387 ++++++++++++++++++++++++------------
>  fs/crypto/keysetup_v1.c     |  13 +-
>  6 files changed, 340 insertions(+), 169 deletions(-)
> 

Thanks for the patchset!  I don't see any major issues with these cleanups; I'll
leave some comments on individual patches.  But, I also feel that most of them
aren't too convincing on their own.  So, I'm very interested in seeing where you
go with this.  It seems that your goal is to allow filesystems to more directly
create and manage fscrypt_prepared_key structs.  Do you know when you'll have a
proof of concept ready that includes the changes/additions to the interface
between fs/crypto/ and filesystems (include/linux/fscrypt.h)?

- Eric
