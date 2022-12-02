Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE60D640662
	for <lists+linux-fscrypt@lfdr.de>; Fri,  2 Dec 2022 13:08:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232750AbiLBMI0 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 2 Dec 2022 07:08:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233079AbiLBMIW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 2 Dec 2022 07:08:22 -0500
Received: from out30-42.freemail.mail.aliyun.com (out30-42.freemail.mail.aliyun.com [115.124.30.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C4AD52FC02;
        Fri,  2 Dec 2022 04:08:20 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R811e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=3;SR=0;TI=SMTPD_---0VWE9zAq_1669982897;
Received: from 30.32.112.227(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VWE9zAq_1669982897)
          by smtp.aliyun-inc.com;
          Fri, 02 Dec 2022 20:08:18 +0800
Message-ID: <65e77226-7ba7-5f72-0197-ea4f4fcd774a@linux.alibaba.com>
Date:   Fri, 2 Dec 2022 20:08:16 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH] fscrypt: add additional documentation for SM4 support
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org
Cc:     linux-doc@vger.kernel.org
References: <20221201191452.6557-1-ebiggers@kernel.org>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <20221201191452.6557-1-ebiggers@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

On 12/2/22 3:14 AM, Eric Biggers wrote:
> From: Eric Biggers <ebiggers@google.com>
> 
> Add a paragraph about SM4, like there is for the other modes.
> 
> Signed-off-by: Eric Biggers <ebiggers@google.com>
> ---
>   Documentation/filesystems/fscrypt.rst | 6 ++++++
>   1 file changed, 6 insertions(+)
> 
> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
> index c0784ec055530..ef183387da208 100644
> --- a/Documentation/filesystems/fscrypt.rst
> +++ b/Documentation/filesystems/fscrypt.rst
> @@ -370,6 +370,12 @@ CONFIG_CRYPTO_HCTR2 must be enabled.  Also, fast implementations of XCTR and
>   POLYVAL should be enabled, e.g. CRYPTO_POLYVAL_ARM64_CE and
>   CRYPTO_AES_ARM64_CE_BLK for ARM64.
>   
> +SM4 is a Chinese block cipher that is an alternative to AES.  It has
> +not seen as much security review as AES, and it only has a 128-bit key
> +size.  It may be useful in cases where its use is mandated.
> +Otherwise, it should not be used.  For SM4 support to be available, it
> +also needs to be enabled in the kernel crypto API.
> +

Looks good to me, this description is appropriate.

Reviewed-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>

Thanks,
Tianjia

>   New encryption modes can be added relatively easily, without changes
>   to individual filesystems.  However, authenticated encryption (AE)
>   modes are not currently supported because of the difficulty of dealing
