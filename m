Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6E4117867FC
	for <lists+linux-fscrypt@lfdr.de>; Thu, 24 Aug 2023 09:00:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240269AbjHXHAL (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 24 Aug 2023 03:00:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231968AbjHXG7l (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 24 Aug 2023 02:59:41 -0400
Received: from sipsolutions.net (s3.sipsolutions.net [IPv6:2a01:4f8:242:246e::2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A64911AD;
        Wed, 23 Aug 2023 23:59:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=sipsolutions.net; s=mail; h=MIME-Version:Content-Transfer-Encoding:
        Content-Type:References:In-Reply-To:Date:Cc:To:From:Subject:Message-ID:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:Resent-To:
        Resent-Cc:Resent-Message-ID; bh=HMhvBcrp05+CiarwI8trcnBfG30fJaYkCg7iyfQbXOI=;
        t=1692860379; x=1694069979; b=b4q1VMhOQPp6dEcnGgonLJd9oflbReuCoEepd8EJxBoAayb
        IuzdviKM/KZ3OojaY2a8QA3pOr1ZPmKRPgcRl1iORVAnUIbpC5LPVG8gpuz1ydzskdY2/Ccf4cWWC
        lhqP3ScgVtLauXNJ8UF+xN6PRz7PuwEuWurb12wLPj31Z0G/CvQlYPZUQk9hrS2M/haKHxmx/vPF5
        bPk75cuF5hmkjShpyOLYpDyHg7s9iANSfT/7vLUWoFOVIBsL+ipjS6rSM2J7a6lgmWHzQs/cELKpT
        HaxIZjIVinwhXmZMtWzcGn+1+zO2nwNeVB5oEakvsZmQLvwkENpQTm4Vg/nUMnHw==;
Received: by sipsolutions.net with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_256_GCM:256)
        (Exim 4.96)
        (envelope-from <johannes@sipsolutions.net>)
        id 1qZ4JB-008ia3-2s;
        Thu, 24 Aug 2023 08:59:10 +0200
Message-ID: <dbbd230e26245274d5a05c64c553c42574f15d4b.camel@sipsolutions.net>
Subject: Re: [PATCH 6/12] wifi: mac80211: Do not include crypto/algapi.h
From:   Johannes Berg <johannes@sipsolutions.net>
To:     Herbert Xu <herbert@gondor.apana.org.au>
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
Date:   Thu, 24 Aug 2023 08:59:08 +0200
In-Reply-To: <ZObmLqztZ4vMFKnI@gondor.apana.org.au>
References: <ZOXf3JTIqhRLbn5j@gondor.apana.org.au>
         <E1qYlA0-006vFr-Ts@formenos.hmeau.com>
         <d776152a79c9604f4f0743fe8d4ab16efd517926.camel@sipsolutions.net>
         <ZObmLqztZ4vMFKnI@gondor.apana.org.au>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
User-Agent: Evolution 3.48.4 (3.48.4-1.fc38) 
MIME-Version: 1.0
X-malware-bazaar: not-scanned
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Thu, 2023-08-24 at 13:10 +0800, Herbert Xu wrote:
> On Wed, Aug 23, 2023 at 12:34:35PM +0200, Johannes Berg wrote:
> >=20
> > No objection, of course, but I don't think it's necessarily clear that
> > it "is for internal use only", it literally says:
> >=20
> >  * Cryptographic API for algorithms (i.e., low-level API).
> >=20
> > which really isn't the same as "don't use this file".
> >=20
> > Might want to clarify that, or even move it into crypto/ from
> > include/crypto/ or something?
>=20
> Yes it should be in include/crypto/internal.  Once the churn gets
> small enough I'll move it there.
>=20

Sounds good :)

I was kind of waiting to see - but now that others have applied some
patches to their tree I've done the same.

johannes
