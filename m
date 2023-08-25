Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 06C5678903F
	for <lists+linux-fscrypt@lfdr.de>; Fri, 25 Aug 2023 23:15:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjHYVO2 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 25 Aug 2023 17:14:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229610AbjHYVN6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 25 Aug 2023 17:13:58 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F4AD211E;
        Fri, 25 Aug 2023 14:13:56 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0D28A62FFA;
        Fri, 25 Aug 2023 21:13:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B0ECC433C7;
        Fri, 25 Aug 2023 21:13:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1692998035;
        bh=uiXkyRVOSV4tA0Dr9xfhgTNwejV2oZiBsqM/hZn5yPg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UgSWvtl49FkDkaRYO3r0z4VzYK/yDU2hQmm5FUy/saN2DaYbzz5vuhxj+oTpq/YEz
         6iPySb9lNptNeguxiheMPfLw58USp34CyI6yLgGfRUu28v0iNMZb16krVHW1DR7eer
         X7/UJR9hvVw1WO8f9x3khDGmYa5/plHR8kM491NKMqEuNO4Pw9iZDNRrB6DqgVa63r
         +IjWV8he6N0kCyEWrQbC5VfgXNT058QGjrBf2pO6OG6y8NaLAaMZTNAT4pmMeyQyKD
         eh10XcSY2us9pZi/URLX1z5VvUzlXT9gvz7Jlc/CvSoA1f7ssDARtN21vNHvUsEQko
         AuIIYRR5eP06A==
Date:   Fri, 25 Aug 2023 14:13:52 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org, Ilya Dryomov <idryomov@gmail.com>,
        Xiubo Li <xiubli@redhat.com>, Jeff Layton <jlayton@kernel.org>,
        ceph-devel@vger.kernel.org,
        Steffen Klassert <steffen.klassert@secunet.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <martineau@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Neil Brown <neilb@suse.de>, linux-nfs@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        linux-integrity@vger.kernel.org,
        "Jason A. Donenfeld" <Jason@zx2c4.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: Re: [PATCH 1/12] fscrypt: Do not include crypto/algapi.h
Message-ID: <20230825211352.GB1366@sol.localdomain>
References: <ZOXf3JTIqhRLbn5j@gondor.apana.org.au>
 <E1qYl9q-006vDd-FJ@formenos.hmeau.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1qYl9q-006vDd-FJ@formenos.hmeau.com>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Aug 23, 2023 at 06:32:15PM +0800, Herbert Xu wrote:
> The header file crypto/algapi.h is for internal use only.  Use the
> header file crypto/utils.h instead.
> 
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
> 
>  fs/crypto/keysetup_v1.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/fs/crypto/keysetup_v1.c b/fs/crypto/keysetup_v1.c
> index 75dabd9b27f9..d698ecb9ad44 100644
> --- a/fs/crypto/keysetup_v1.c
> +++ b/fs/crypto/keysetup_v1.c
> @@ -20,8 +20,8 @@
>   *    managed alongside the master keys in the filesystem-level keyring)
>   */
>  
> -#include <crypto/algapi.h>
>  #include <crypto/skcipher.h>
> +#include <crypto/utils.h>
>  #include <keys/user-type.h>
>  #include <linux/hashtable.h>
>  #include <linux/scatterlist.h>

Acked-by: Eric Biggers <ebiggers@google.com>

- Eric
