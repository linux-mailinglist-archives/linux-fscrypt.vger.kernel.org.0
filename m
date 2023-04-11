Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A4B6B6DD03C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Apr 2023 05:35:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229884AbjDKDfk (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 10 Apr 2023 23:35:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229733AbjDKDfj (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 10 Apr 2023 23:35:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9B96A1726
        for <linux-fscrypt@vger.kernel.org>; Mon, 10 Apr 2023 20:35:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3720E61DC8
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 03:35:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69D4CC433EF;
        Tue, 11 Apr 2023 03:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681184137;
        bh=EwnOYuYuSbiaIOvRCAWQXGvCoLG7WQNhFkQ8wWRrQHg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=jN/t1MPCs5s73LPotKHCVAqjcxtRHGHbuLCDczgHlrI1brSJQyDqGLzfdZ9kpRR0k
         RvnylmgCsbPJ3Xwn4gCdhsXkEF8yIh0v+I4Xd50aX8TtwXMZFIuj2WjGDvjAvl3huS
         yqjaZCjnfhV1Qt7J+4Aaqy+vVsjEVsYpZDFBtb9Gse1NK7IAU/GFztrrZGQS8Xv6W+
         uee/sSta7FuJcaOA8Hd+laeCJ2qzxx2/W3nV4Qrv6MJMNzsmrQ9nC6VD6kXI5ZKLGk
         xt/1XgHGVDrHDo7ZpjA226gcZ/le7pgiORqfWeJ8ucrrh4jJMRE14k5vgmAsxWrmym
         oTKhujfyg4NEw==
Date:   Mon, 10 Apr 2023 20:35:35 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
Subject: Re: [PATCH v2 04/11] fscrypt: move dirhash key setup away from IO
 key setup
Message-ID: <20230411033535.GD47625@sol.localdomain>
References: <cover.1681155143.git.sweettea-kernel@dorminy.me>
 <e025a6f6f904e2d810539cc20b59ca79666bb644.1681155143.git.sweettea-kernel@dorminy.me>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e025a6f6f904e2d810539cc20b59ca79666bb644.1681155143.git.sweettea-kernel@dorminy.me>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Mon, Apr 10, 2023 at 03:39:57PM -0400, Sweet Tea Dorminy wrote:
> @@ -391,13 +390,6 @@ static int fscrypt_setup_v2_file_key(struct fscrypt_info *ci,
>  	if (err)
>  		return err;
>  
> -	/* Derive a secret dirhash key for directories that need it. */
> -	if (need_dirhash_key) {
> -		err = fscrypt_derive_dirhash_key(ci, mk);
> -		if (err)
> -			return err;
> -	}
> -
>  	return 0;
>  }

Instead of:

        if (err)
                return err;
        return 0;

Just do:

        return err;

- Eric
