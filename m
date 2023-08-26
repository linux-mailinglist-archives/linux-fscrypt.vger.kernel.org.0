Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 16FD27894D6
	for <lists+linux-fscrypt@lfdr.de>; Sat, 26 Aug 2023 10:38:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231351AbjHZIiR (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sat, 26 Aug 2023 04:38:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231818AbjHZIiC (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sat, 26 Aug 2023 04:38:02 -0400
Received: from 167-179-156-38.a7b39c.syd.nbn.aussiebb.net (167-179-156-38.a7b39c.syd.nbn.aussiebb.net [167.179.156.38])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C53A4213A;
        Sat, 26 Aug 2023 01:37:56 -0700 (PDT)
Received: from loth.rohan.me.apana.org.au ([192.168.167.2])
        by formenos.hmeau.com with smtp (Exim 4.94.2 #2 (Debian))
        id 1qZomd-007ymm-Rh; Sat, 26 Aug 2023 16:36:40 +0800
Received: by loth.rohan.me.apana.org.au (sSMTP sendmail emulation); Sat, 26 Aug 2023 16:36:41 +0800
Date:   Sat, 26 Aug 2023 16:36:41 +0800
From:   Herbert Xu <herbert@gondor.apana.org.au>
To:     kernel test robot <lkp@intel.com>
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
        "David S. Miller" <davem@davemloft.net>,
        Johannes Berg <johannes@sipsolutions.net>,
        linux-wireless@vger.kernel.org,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Mat Martineau <martineau@kernel.org>,
        Chuck Lever <chuck.lever@oracle.com>,
        Neil Brown <neilb@suse.de>, linux-nfs@vger.kernel.org,
        Mimi Zohar <zohar@linux.ibm.com>,
        linux-inte@web.codeaurora.org, grity@vger.kernel.org,
        "Jason A.Donenfeld" <Jason@zx2c4.com>,
        Ayush Sawal <ayush.sawal@chelsio.com>, llvm@lists.linux.dev,
        oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
        David Howells <dhowells@redhat.com>, keyrings@vger.kernel.org
Subject: [PATCH] KEYS: Include linux/errno.h in linux/verification.h
Message-ID: <ZOm5mX0+oUGzO3xh@gondor.apana.org.au>
References: <E1qYl9s-006vDm-IW@formenos.hmeau.com>
 <202308261414.HKw1Mrip-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202308261414.HKw1Mrip-lkp@intel.com>
X-Spam-Status: No, score=2.7 required=5.0 tests=BAYES_00,HELO_DYNAMIC_IPADDR2,
        PDS_RDNS_DYNAMIC_FP,RCVD_IN_DNSWL_BLOCKED,RDNS_DYNAMIC,SPF_HELO_NONE,
        SPF_PASS,TVD_RCVD_IP autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On Sat, Aug 26, 2023 at 02:58:48PM +0800, kernel test robot wrote:
>
> All errors (new ones prefixed by >>):
> 
>    In file included from fs/ubifs/auth.c:12:
> >> include/linux/verification.h:23:11: error: use of undeclared identifier 'EINVAL'

---8<---
Add inclusion of linux/errno.h as otherwise the reference to EINVAL
may be invalid.

Fixes: f3cf4134c5c6 ("bpf: Add bpf_lookup_*_key() and bpf_key_put() kfuncs")
Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202308261414.HKw1Mrip-lkp@intel.com/
Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>

diff --git a/include/linux/verification.h b/include/linux/verification.h
index f34e50ebcf60..cb2d47f28091 100644
--- a/include/linux/verification.h
+++ b/include/linux/verification.h
@@ -8,6 +8,7 @@
 #ifndef _LINUX_VERIFICATION_H
 #define _LINUX_VERIFICATION_H
 
+#include <linux/errno.h>
 #include <linux/types.h>
 
 /*
-- 
Email: Herbert Xu <herbert@gondor.apana.org.au>
Home Page: http://gondor.apana.org.au/~herbert/
PGP Key: http://gondor.apana.org.au/~herbert/pubkey.txt
