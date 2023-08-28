Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD7C678A902
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Aug 2023 11:34:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229716AbjH1Jd3 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Aug 2023 05:33:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55124 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230071AbjH1JdY (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Aug 2023 05:33:24 -0400
Received: from www62.your-server.de (www62.your-server.de [213.133.104.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 10078FF;
        Mon, 28 Aug 2023 02:33:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=iogearbox.net; s=default2302; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID;
        bh=uHxuq2I8/ZyhsPIJmnm5XYbNAhRPkS8ziwT5zTbeJps=; b=lO8mubL68pHZiPHcvvPCwSD50I
        uex7iY0O9aXpWaBriDkeZBCETSv7sEcsAyNKdE/OHPrADmuQHX02Ze/3A6Mi8r92DsYCorXkBAH9C
        PRVkyOCr/jR1d6nYpa3K3KVQGEPKyQI0Maa0WkE2MFYz/sjPUt35p8d6QCX6WaK/cJjK8p9U+j/a5
        BiFLoXm+c4QvzqDbv2mYgaUyr4chWFHNNOfHfjJ5rFyllD3wZT0q+2HozNJw/+UGJ8S0qOZNV30GO
        j5pw+8Hn6XbiAqG6geKRCBIfWB5toKYt68QhCVW085lRCPhWiewmJvE9UsI9zBCw8GPBY6UgTvpAL
        6/puGIWw==;
Received: from sslproxy05.your-server.de ([78.46.172.2])
        by www62.your-server.de with esmtpsa  (TLS1.3) tls TLS_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <daniel@iogearbox.net>)
        id 1qaYcN-0007aY-A4; Mon, 28 Aug 2023 11:33:07 +0200
Received: from [85.1.206.226] (helo=linux.home)
        by sslproxy05.your-server.de with esmtpsa (TLSv1.3:TLS_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <daniel@iogearbox.net>)
        id 1qaYcM-0000ba-24; Mon, 28 Aug 2023 11:33:06 +0200
Subject: Re: [PATCH] KEYS: Include linux/errno.h in linux/verification.h
To:     Herbert Xu <herbert@gondor.apana.org.au>,
        kernel test robot <lkp@intel.com>
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
References: <E1qYl9s-006vDm-IW@formenos.hmeau.com>
 <202308261414.HKw1Mrip-lkp@intel.com> <ZOm5mX0+oUGzO3xh@gondor.apana.org.au>
From:   Daniel Borkmann <daniel@iogearbox.net>
Message-ID: <8481f02f-7dad-0459-bd2e-536ff8ab6896@iogearbox.net>
Date:   Mon, 28 Aug 2023 11:33:04 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <ZOm5mX0+oUGzO3xh@gondor.apana.org.au>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Authenticated-Sender: daniel@iogearbox.net
X-Virus-Scanned: Clear (ClamAV 0.103.8/27014/Mon Aug 28 09:38:26 2023)
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Herbert,

On 8/26/23 10:36 AM, Herbert Xu wrote:
> On Sat, Aug 26, 2023 at 02:58:48PM +0800, kernel test robot wrote:
>>
>> All errors (new ones prefixed by >>):
>>
>>     In file included from fs/ubifs/auth.c:12:
>>>> include/linux/verification.h:23:11: error: use of undeclared identifier 'EINVAL'
> 
> ---8<---
> Add inclusion of linux/errno.h as otherwise the reference to EINVAL
> may be invalid.
> 
> Fixes: f3cf4134c5c6 ("bpf: Add bpf_lookup_*_key() and bpf_key_put() kfuncs")
> Reported-by: kernel test robot <lkp@intel.com>
> Closes: https://lore.kernel.org/oe-kbuild-all/202308261414.HKw1Mrip-lkp@intel.com/
> Signed-off-by: Herbert Xu <herbert@gondor.apana.org.au>
> 
> diff --git a/include/linux/verification.h b/include/linux/verification.h
> index f34e50ebcf60..cb2d47f28091 100644
> --- a/include/linux/verification.h
> +++ b/include/linux/verification.h
> @@ -8,6 +8,7 @@
>   #ifndef _LINUX_VERIFICATION_H
>   #define _LINUX_VERIFICATION_H
>   
> +#include <linux/errno.h>
>   #include <linux/types.h>
>   
>   /*
> 

Looks good, do you plan to route this fix to Linus?

Thanks,
Daniel
