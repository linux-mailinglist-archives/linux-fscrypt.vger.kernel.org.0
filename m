Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E773B62D152
	for <lists+linux-fscrypt@lfdr.de>; Thu, 17 Nov 2022 03:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239017AbiKQC6c (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 16 Nov 2022 21:58:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234469AbiKQC6b (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 16 Nov 2022 21:58:31 -0500
Received: from out30-133.freemail.mail.aliyun.com (out30-133.freemail.mail.aliyun.com [115.124.30.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 40E50DF44;
        Wed, 16 Nov 2022 18:58:28 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R201e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VV-9OtK_1668653902;
Received: from 30.240.99.252(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VV-9OtK_1668653902)
          by smtp.aliyun-inc.com;
          Thu, 17 Nov 2022 10:58:24 +0800
Message-ID: <bed9b29d-72c1-8724-64df-1a9ef2a4aa94@linux.alibaba.com>
Date:   Thu, 17 Nov 2022 10:58:22 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH 2/2] fscrypt: Add SM4 XTS/CTS symmetric algorithm support
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        linux-fscrypt@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org,
        linux-crypto@vger.kernel.org
References: <20221116082416.98977-1-tianjia.zhang@linux.alibaba.com>
 <20221116082416.98977-3-tianjia.zhang@linux.alibaba.com>
 <Y3UdKwtHE+SrERka@sol.localdomain>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <Y3UdKwtHE+SrERka@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

On 11/17/22 1:26 AM, Eric Biggers wrote:
> On Wed, Nov 16, 2022 at 04:24:16PM +0800, Tianjia Zhang wrote:
>> SM4 is a symmetric algorithm widely used in China
> 
> So?
> 
> What is the use case for adding this to fscrypt specifically?
> 
> Just because an algorithm is widely used doesn't necessarily mean it is useful
> or appropriate to support with fscrypt.
> 

We want to provide our users with the ability to encrypt disks and files
using SM4-XTS, the ability to sign SM2/3, and the ability to use
SM4-GCM/CCM with TLS (of course this belongs to other parts), quite a
few users need these features.

>> , this patch enables
>> to use SM4-XTS mode to encrypt file content, and use SM4-CBC-CTS to
>> encrypt filename.
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
>> ---
>>   Documentation/filesystems/fscrypt.rst |  1 +
>>   fs/crypto/fscrypt_private.h           |  2 +-
>>   fs/crypto/keysetup.c                  | 15 +++++++++++++++
>>   fs/crypto/policy.c                    |  4 ++++
>>   include/uapi/linux/fscrypt.h          |  4 +++-
>>   5 files changed, 24 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
>> index 5ba5817c17c2..af27e7b2c74f 100644
>> --- a/Documentation/filesystems/fscrypt.rst
>> +++ b/Documentation/filesystems/fscrypt.rst
>> @@ -336,6 +336,7 @@ Currently, the following pairs of encryption modes are supported:
>>   
>>   - AES-256-XTS for contents and AES-256-CTS-CBC for filenames
>>   - AES-128-CBC for contents and AES-128-CTS-CBC for filenames
>> +- SM4-XTS for contents and SM4-CTS-CBC for filenames
>>   - Adiantum for both contents and filenames
>>   - AES-256-XTS for contents and AES-256-HCTR2 for filenames (v2 policies only)
>>   
>> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
>> index d5f68a0c5d15..e79a701de028 100644
>> --- a/fs/crypto/fscrypt_private.h
>> +++ b/fs/crypto/fscrypt_private.h
>> @@ -31,7 +31,7 @@
>>   #define FSCRYPT_CONTEXT_V2	2
>>   
>>   /* Keep this in sync with include/uapi/linux/fscrypt.h */
>> -#define FSCRYPT_MODE_MAX	FSCRYPT_MODE_AES_256_HCTR2
>> +#define FSCRYPT_MODE_MAX	FSCRYPT_MODE_SM4_CTS
>>   
>>   struct fscrypt_context_v1 {
>>   	u8 version; /* FSCRYPT_CONTEXT_V1 */
>> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
>> index f7407071a952..c0a3f882f5a4 100644
>> --- a/fs/crypto/keysetup.c
>> +++ b/fs/crypto/keysetup.c
>> @@ -59,6 +59,21 @@ struct fscrypt_mode fscrypt_modes[] = {
>>   		.security_strength = 32,
>>   		.ivsize = 32,
>>   	},
>> +	[FSCRYPT_MODE_SM4_XTS] = {
>> +		.friendly_name = "SM4-XTS",
>> +		.cipher_str = "xts(sm4)",
>> +		.keysize = 32,
>> +		.security_strength = 16,
>> +		.ivsize = 16,
>> +		.blk_crypto_mode = BLK_ENCRYPTION_MODE_SM4_XTS,
>> +	},
>> +	[FSCRYPT_MODE_SM4_CTS] = {
>> +		.friendly_name = "SM4-CTS",
>> +		.cipher_str = "cts(cbc(sm4))",
>> +		.keysize = 16,
>> +		.security_strength = 16,
>> +		.ivsize = 16,
>> +	},
>>   };
>>   
>>   static DEFINE_MUTEX(fscrypt_mode_key_setup_mutex);
>> diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
>> index 46757c3052ef..4881fd3af6ee 100644
>> --- a/fs/crypto/policy.c
>> +++ b/fs/crypto/policy.c
>> @@ -75,6 +75,10 @@ static bool fscrypt_valid_enc_modes_v1(u32 contents_mode, u32 filenames_mode)
>>   	    filenames_mode == FSCRYPT_MODE_ADIANTUM)
>>   		return true;
>>   
>> +	if (contents_mode == FSCRYPT_MODE_SM4_XTS &&
>> +	    filenames_mode == FSCRYPT_MODE_SM4_CTS)
>> +		return true;
>> +
>>   	return false;
>>   }
>>   
>> diff --git a/include/uapi/linux/fscrypt.h b/include/uapi/linux/fscrypt.h
>> index a756b29afcc2..34d791bd162c 100644
>> --- a/include/uapi/linux/fscrypt.h
>> +++ b/include/uapi/linux/fscrypt.h
>> @@ -28,7 +28,9 @@
>>   #define FSCRYPT_MODE_AES_128_CTS		6
>>   #define FSCRYPT_MODE_ADIANTUM			9
>>   #define FSCRYPT_MODE_AES_256_HCTR2		10
>> -/* If adding a mode number > 10, update FSCRYPT_MODE_MAX in fscrypt_private.h */
>> +#define FSCRYPT_MODE_SM4_XTS			11
>> +#define FSCRYPT_MODE_SM4_CTS			12
>> +/* If adding a mode number > 12, update FSCRYPT_MODE_MAX in fscrypt_private.h */
> 
> This might be a good time to reclaim some of the unused mode numbers.  Maybe 7-8
> which were very briefly used for Speck128/256.  (Irony not lost?)
> 

This looks awesome, I'll reclaim the gaps in the next version if
possible.

Cheers,
Tianjia
