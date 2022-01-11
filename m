Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 790AA48B915
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Jan 2022 21:58:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236380AbiAKU6l (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Jan 2022 15:58:41 -0500
Received: from vps-vb.mhejs.net ([37.28.154.113]:58236 "EHLO vps-vb.mhejs.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236303AbiAKU6k (ORCPT <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Jan 2022 15:58:40 -0500
X-Greylist: delayed 1509 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 Jan 2022 15:58:39 EST
Received: from MUA
        by vps-vb.mhejs.net with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94.2)
        (envelope-from <mail@maciej.szmigiero.name>)
        id 1n7NpY-00034Q-U7; Tue, 11 Jan 2022 21:33:20 +0100
Message-ID: <ab29dd6f-1301-e012-8898-9c739ca511a3@maciej.szmigiero.name>
Date:   Tue, 11 Jan 2022 21:33:15 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Content-Language: en-US
To:     Roberto Sassu <roberto.sassu@huawei.com>
Cc:     keyrings@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org, zohar@linux.ibm.com,
        ebiggers@kernel.org, dhowells@redhat.com, dwmw2@infradead.org,
        herbert@gondor.apana.org.au, davem@davemloft.net
References: <20220111180318.591029-1-roberto.sassu@huawei.com>
From:   "Maciej S. Szmigiero" <mail@maciej.szmigiero.name>
Subject: Re: [PATCH 00/14] KEYS: Add support for PGP keys and signatures
In-Reply-To: <20220111180318.591029-1-roberto.sassu@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 11.01.2022 19:03, Roberto Sassu wrote:
> Support for PGP keys and signatures was proposed by David long time ago,
> before the decision of using PKCS#7 for kernel modules signatures
> verification was made. After that, there has been not enough interest to
> support PGP too.
> 
> Lately, when discussing a proposal of introducing fsverity signatures in
> Fedora [1], developers expressed their preference on not having a separate
> key for signing, which would complicate the management of the distribution.
> They would be more in favor of using the same PGP key, currently used for
> signing RPM headers, also for file-based signatures (not only fsverity, but
> also IMA ones).

Aren't PGP keys simply RSA / ECC / EdDSA keys with additional metadata?
Can't they be unwrapped from their (complex) PGP format in userspace and
loaded raw into the kernel, in a similar way as they are sometimes used
for SSH authentication?

This will save us from having to add complex parsers (a well-known source
of bugs) into the kernel - I guess there aren't any plans to add an
in-kernel PGP Web of Trust implementation.

Thanks,
Maciej
