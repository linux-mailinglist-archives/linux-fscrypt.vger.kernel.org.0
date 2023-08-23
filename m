Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1A4297861C6
	for <lists+linux-fscrypt@lfdr.de>; Wed, 23 Aug 2023 22:53:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236717AbjHWUxY (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 23 Aug 2023 16:53:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236742AbjHWUxV (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 23 Aug 2023 16:53:21 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 04FB510C8;
        Wed, 23 Aug 2023 13:53:20 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id 5614622812f47-3a84c228f26so139447b6e.1;
        Wed, 23 Aug 2023 13:53:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1692823999; x=1693428799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JBzuOUokFnbIvdABYXgxVqx9GE8BaF/60yc9jGc5dow=;
        b=ifnYBZ/z06PEthqsBU8HiWYT10InB2ZeB1Y6vsDDSct7lsEMYnCyzojld08QczG4y2
         FUMvuJDrSG8gJxOkIJ1Xq8QOWi7EbXJY90L3J2ijoLRi7Oxne5kAutyRTZ8dhsKyJ8Tm
         GgOm4JhvObKDz/DHO9zQxSv+Tnh3HclqbXCwiMmcyJl4CLfPY0Jm6mp7SQi8lHADhWQz
         uWVAuTieWCuepOe/Wvdl3E5+v1MJN/4eKv134zQmdZsidL9G9nFqjtGGDyXeyTgAZTzK
         /vjog61vWigYGhl/XZsB6Y/CuiNJ4DR6mdHS53x4CWoFyJ63JheDZnuwad+ipe5YsIPL
         Voew==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1692823999; x=1693428799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=JBzuOUokFnbIvdABYXgxVqx9GE8BaF/60yc9jGc5dow=;
        b=j/OYo9e9OWTOG6pVJx1cQdrQghYk+y0oOft5g3zccCxBtbispdqyyn1vcqDtq+foTT
         k7R/5R3YfC75o1K4Hjyg6GRKDM7haKH1Dn2raiF4FP0GW11hJCFLbJpaA+quYHGvi2zf
         kW+3gh5MwD60WJbS+3rA9s1GEje9EvYger3GQju7btWSby2nUv5eKCwktDzetA3BUJwk
         mjsKLsvvJbWCQF8uU+lIKGHrrBYDELfrEQ/ArDp4ugF9/DVDfHwZ2q2JYE2o/h17Jptp
         DrwTMC6R8qjEpAazyghk5LAE21LC883LsXq3efioUBuKcpsLzNpcadAQqUjX7i/86/BH
         zOLw==
X-Gm-Message-State: AOJu0YwHfXL+sPbUVnvefvYkZUrZSMktFmMkCxcoCcfxQftW4XxPdjc5
        Mcthh7n3yBT2H57AhuVoB7oJmkiJXnHLX3r9+rE=
X-Google-Smtp-Source: AGHT+IFEwtEKi0ASYKlkdJHjS3VmWFQAWnMsjK8W4r5tNoeTEcjoneObafNLHnT2CCsQ51YZgYhlBs6BkOpakYJXZGU=
X-Received: by 2002:a05:6808:23c1:b0:3a7:7b7e:f309 with SMTP id
 bq1-20020a05680823c100b003a77b7ef309mr9358159oib.10.1692823999253; Wed, 23
 Aug 2023 13:53:19 -0700 (PDT)
MIME-Version: 1.0
References: <ZOXf3JTIqhRLbn5j@gondor.apana.org.au> <E1qYl9w-006vEX-O3@formenos.hmeau.com>
In-Reply-To: <E1qYl9w-006vEX-O3@formenos.hmeau.com>
From:   Ilya Dryomov <idryomov@gmail.com>
Date:   Wed, 23 Aug 2023 22:53:07 +0200
Message-ID: <CAOi1vP-n3tNgRWfOAYDaQvuC+781QGXxuT6wt+XEh7n2P4_3Ug@mail.gmail.com>
Subject: Re: [PATCH 4/12] ceph: Do not include crypto/algapi.h
To:     Herbert Xu <herbert@gondor.apana.org.au>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, Richard Weinberger <richard@nod.at>,
        linux-mtd@lists.infradead.org,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-bluetooth@vger.kernel.org, Xiubo Li <xiubli@redhat.com>,
        Jeff Layton <jlayton@kernel.org>, ceph-devel@vger.kernel.org,
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
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Aug 23, 2023 at 12:32=E2=80=AFPM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:
>
> The header file crypto/algapi.h is for internal use only.  Use the
> header file crypto/utils.h instead.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>
>  net/ceph/messenger_v2.c |    2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
> index 1a888b86a494..4aab32144833 100644
> --- a/net/ceph/messenger_v2.c
> +++ b/net/ceph/messenger_v2.c
> @@ -8,9 +8,9 @@
>  #include <linux/ceph/ceph_debug.h>
>
>  #include <crypto/aead.h>
> -#include <crypto/algapi.h>  /* for crypto_memneq() */
>  #include <crypto/hash.h>
>  #include <crypto/sha2.h>
> +#include <crypto/utils.h>
>  #include <linux/bvec.h>
>  #include <linux/crc32c.h>
>  #include <linux/net.h>

Applied.

Thanks,

                Ilya
