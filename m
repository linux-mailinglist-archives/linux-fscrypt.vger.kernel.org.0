Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23783786705
	for <lists+linux-fscrypt@lfdr.de>; Thu, 24 Aug 2023 07:13:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239671AbjHXFLg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 24 Aug 2023 01:11:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41388 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239177AbjHXFLJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 24 Aug 2023 01:11:09 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DBC810F9;
        Wed, 23 Aug 2023 22:11:06 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qZ2bd-007EU6-EA; Thu, 24 Aug 2023 13:10:06 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Thu, 24 Aug 2023 13:10:06 +0800
Date:   Thu, 24 Aug 2023 13:10:06 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     Linux Crypto Mailing List <linux-crypto@vger.kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y.Ts'o" <tytso@mit.edu>,
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
        linux-wireless@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <martineau@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Neil Brown <neilb@suse.de>, linux-nfs@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        linux-integrity@vger.kernel.org,
        "Jason A.Donenfeld" <Jason@zx2c4.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>
Subject: Re: [PATCH 6/12] wifi: mac80211: Do not include crypto/algapi.h
Message-ID: <ZObmLqztZ4vMFKnI@gondor.apana.org.au>
References: <ZOXf3JTIqhRLbn5j@gondor.apana.org.au>
 <E1qYlA0-006vFr-Ts@formenos.hmeau.com>
 <d776152a79c9604f4f0743fe8d4ab16efd517926.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d776152a79c9604f4f0743fe8d4ab16efd517926.camel@sipsolutions.net>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        PDS_RDNS_DYNAMIC_FP,RDNS_DYNAMIC,SPF_HELO_NONE,SPF_PASS,TVD_RCVD_IP
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Wed, Aug 23, 2023 at 12:34:35PM +0200, Johannes Berg wrote:
> 
> No objection, of course, but I don't think it's necessarily clear that
> it "is for internal use only", it literally says:
> 
>  * Cryptographic API for algorithms (i.e., low-level API).
> 
> which really isn't the same as "don't use this file".
> 
> Might want to clarify that, or even move it into crypto/ from
> include/crypto/ or something?

Yes it should be in include/crypto/internal.  Once the churn gets
small enough I'll move it there.

Thanks,
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
