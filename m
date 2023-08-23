Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1BBD4785733
	for <lists+linux-fscrypt@lfdr.de>; Wed, 23 Aug 2023 13:52:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234580AbjHWLwQ (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 23 Aug 2023 07:52:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234579AbjHWLwP (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 23 Aug 2023 07:52:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A36C10E3;
        Wed, 23 Aug 2023 04:51:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature RSA-PSS (2048 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A08D660C4;
        Wed, 23 Aug 2023 11:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D6BBC433D9;
        Wed, 23 Aug 2023 11:51:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
        dkim=pass (1024-bit key) header.d=zx2c4.com header.i=@zx2c4.com header.b="HvlznVnN"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=zx2c4.com; s=20210105;
        t=1692791504;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=i9S50yEi/p2rCDiQFKotCIoS/umPPt7Pl2fEpLB+hPU=;
        b=HvlznVnN4+nTE+9P5lkr2rPCYQplDgdO5TEv4CB+fveG2FN0HLeY+NAKhcNFA6GMXSUYPq
        R8vqfNV1vDE9kWFG8KCRj+3M8C/lrcTsz5tgdrIKsIZ/EgSSCfZRt8uPFm8LgCHWdCfxEV
        UQuclphoiHFSePfXFFvOomDkbQr3/xM=
Received: by mail.zx2c4.com (ZX2C4 Mail Server) with ESMTPSA id c56767ad (TLSv1.3:TLS_AES_256_GCM_SHA384:256:NO);
        Wed, 23 Aug 2023 11:51:44 +0000 (UTC)
Received: by mail-vs1-f48.google.com with SMTP id ada2fe7eead31-44d5ac10c41so854545137.0;
        Wed, 23 Aug 2023 04:51:44 -0700 (PDT)
X-Gm-Message-State: AOJu0YxusXUY5obDP6tjt4IEgrt6n41c6CPK6h+LdHr5QGxUrieLlpmG
        5z9b6I8BK1hxlOFHEoIbSfloTkZB5DLdQUZYUqQ=
X-Google-Smtp-Source: AGHT+IFt7G1/ZeusTY56LT7aeMj6tJiORTuiaRW4q76XBgQu2EncKhol2bejM2ffQ7Afv6eCg3gMogdKzIe6mnDS5dk=
X-Received: by 2002:a67:ba0c:0:b0:44d:40b1:9273 with SMTP id
 l12-20020a67ba0c000000b0044d40b19273mr8437282vsn.4.1692791501269; Wed, 23 Aug
 2023 04:51:41 -0700 (PDT)
MIME-Version: 1.0
References: <ZOXf3JTIqhRLbn5j@gondor.apana.org.au> <E1qYlAB-006vJI-Cv@formenos.hmeau.com>
In-Reply-To: <E1qYlAB-006vJI-Cv@formenos.hmeau.com>
From:   "Jason A. Donenfeld" <Jason@zx2c4.com>
Date:   Wed, 23 Aug 2023 13:48:47 +0200
X-Gmail-Original-Message-ID: <CAHmME9qwYhM55he7WyWQZXwSg9Ri6-9K31tHHqaKcMYFEJYxTw@mail.gmail.com>
Message-ID: <CAHmME9qwYhM55he7WyWQZXwSg9Ri6-9K31tHHqaKcMYFEJYxTw@mail.gmail.com>
Subject: Re: [PATCH 11/12] wireguard: Do not include crypto/algapi.h
To:     herbert@gondor.apana.org.au
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
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
        Ayush Sawal <ayush.sawal@chelsio.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Aug 23, 2023 at 12:33=E2=80=AFPM Herbert Xu <herbert@gondor.apana.o=
rg.au> wrote:
>
> The header file crypto/algapi.h is for internal use only.  Use the
> header file crypto/utils.h instead.
>
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> ---
>
>  drivers/net/wireguard/cookie.c  |    2 +-
>  drivers/net/wireguard/netlink.c |    2 +-
>  drivers/net/wireguard/noise.c   |    2 +-
>  3 files changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/net/wireguard/cookie.c b/drivers/net/wireguard/cooki=
e.c
> index 4956f0499c19..f89581b5e8cb 100644
> --- a/drivers/net/wireguard/cookie.c
> +++ b/drivers/net/wireguard/cookie.c
> @@ -12,9 +12,9 @@
>
>  #include <crypto/blake2s.h>
>  #include <crypto/chacha20poly1305.h>
> +#include <crypto/utils.h>
>
>  #include <net/ipv6.h>
> -#include <crypto/algapi.h>
>
>  void wg_cookie_checker_init(struct cookie_checker *checker,
>                             struct wg_device *wg)
> diff --git a/drivers/net/wireguard/netlink.c b/drivers/net/wireguard/netl=
ink.c
> index 6d1bd9f52d02..0a1502100e8b 100644
> --- a/drivers/net/wireguard/netlink.c
> +++ b/drivers/net/wireguard/netlink.c
> @@ -12,10 +12,10 @@
>
>  #include <uapi/linux/wireguard.h>
>
> +#include <crypto/utils.h>
>  #include <linux/if.h>
>  #include <net/genetlink.h>
>  #include <net/sock.h>
> -#include <crypto/algapi.h>
>
>  static struct genl_family genl_family;
>
> diff --git a/drivers/net/wireguard/noise.c b/drivers/net/wireguard/noise.=
c
> index 720952b92e78..e7ad81ca4a36 100644
> --- a/drivers/net/wireguard/noise.c
> +++ b/drivers/net/wireguard/noise.c
> @@ -10,12 +10,12 @@
>  #include "queueing.h"
>  #include "peerlookup.h"
>
> +#include <crypto/utils.h>
>  #include <linux/rcupdate.h>
>  #include <linux/slab.h>
>  #include <linux/bitmap.h>
>  #include <linux/scatterlist.h>
>  #include <linux/highmem.h>
> -#include <crypto/algapi.h>
>
>  /* This implements Noise_IKpsk2:
>   *

Small nit - with the exception of the cookie.c reordering, could you
maintain the existing #include ordering of the other files? No need to
send a v2 for that if you don't want. And please make the entire
commit subject lowercase. With those done,

Acked-by: Jason A. Donenfeld <Jason@zx2c4.com>

As a side note, you may want to eventually do something to make sure
people don't add back algapi.h, like move it to internal/ or out of
include/ all together. I figure you've already thought about this, and
this series is just the first step.

Jason
