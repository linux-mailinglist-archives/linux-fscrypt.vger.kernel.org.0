Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FDC26DD07B
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Apr 2023 05:45:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230123AbjDKDpt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 23:45:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42346 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229916AbjDKDpY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 23:45:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D463730D6
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 20:44:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 67A06620F8
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 03:44:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9780AC433EF;
        Tue, 11 Apr 2023 03:44:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681184650;
        bh=uUs2Nk93d2/Y0wxjQb5VXPwXMYGZfiMX3a8AN91Nuqg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SboESO7u3zCZPFZP8NyyAKVngt3DZXNaBe8iXthChNaXPnYrXNvw0sHpsxoSPy8bf
         6zfoCTTzIgMWeAtlhvTUECII7muUNcvddNdAoAieAclukNUKSxVo40Adgk8TecFjgR
         PUeYh8ilvmBI5kih6OE3z7M7JTuElX4KqYXwX6Xo2PGgTKT8klQ/yTQUEToE6MhMVG
         fFR+G31wSHGjv0rI5dJLJLCMndw7NDFE/RB5+KplV8l4SYSFt4vmExOC3tg+ik/F79
         ZhI4YDjCwOH+/gGLkMscamMA3WJ/HmlsIYKCfeuK/KcGBvRQGUfliTX2ME9Yt1mH1v
         51okzGxf369Xw==
Date:   Mon, 10 Apr 2023 20:44:08 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 06/11] fscrypt: make infos have a pointer to prepared
 keys
Message-ID: <20230411034408.GF47625@sol.localdomain>
References: <cover.1681155143.git.sweettea-kernel@dorminy.me>
 <49da55a9d6787c1d3b900f48f15c09da505581ad.1681155143.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <49da55a9d6787c1d3b900f48f15c09da505581ad.1681155143.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Apr 10, 2023 at 03:39:59PM -0400, Sweet Tea Dorminy wrote:
> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
> index 8b32200dbbc0..f07e3b9579cf 100644
> --- a/fs/crypto/keysetup.c
> +++ b/fs/crypto/keysetup.c
> @@ -181,7 +181,11 @@ void fscrypt_destroy_prepared_key(struct super_block *sb,
>  int fscrypt_set_per_file_enc_key(struct fscrypt_info *ci, const u8 *raw_key)
>  {
>  	ci->ci_owns_key = true;
> -	return fscrypt_prepare_key(&ci->ci_enc_key, raw_key, ci);
> +	ci->ci_enc_key = kzalloc(sizeof(*ci->ci_enc_key), GFP_KERNEL);
> +	if (!ci->ci_enc_key)
> +		return -ENOMEM;
> +
> +	return fscrypt_prepare_key(ci->ci_enc_key, raw_key, ci);
>  }

Any idea how much this will increase the per-inode memory usage by, in the
per-file keys case?  (Counting the overhead of the slab allocator.)

> -	else if (ci->ci_owns_key)
> +	else if (ci->ci_owns_key) {
>  		fscrypt_destroy_prepared_key(ci->ci_inode->i_sb,
> -					     &ci->ci_enc_key);
> +					     ci->ci_enc_key);
> +		kfree(ci->ci_enc_key);

Use kfree_sensitive() here, please.  Yes, it's not actually needed here because
the allocation doesn't contain the keys themselves.  But I want to code
defensively here.

- Eric
