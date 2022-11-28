Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4124863A201
	for <lists+linux-fscrypt@lfdr.de>; Mon, 28 Nov 2022 08:35:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229885AbiK1Hfq (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 28 Nov 2022 02:35:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40798 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229713AbiK1Hfp (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 28 Nov 2022 02:35:45 -0500
Received: from out30-57.freemail.mail.aliyun.com (out30-57.freemail.mail.aliyun.com [115.124.30.57])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEC4B12AAF;
        Sun, 27 Nov 2022 23:35:43 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R151e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045176;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VVpnSmS_1669620938;
Received: from 30.27.90.133(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VVpnSmS_1669620938)
          by smtp.aliyun-inc.com;
          Mon, 28 Nov 2022 15:35:39 +0800
Message-ID: <e0461754-39c4-a9e1-6ca1-381659e4a2d7@linux.alibaba.com>
Date:   Mon, 28 Nov 2022 15:35:37 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v3 2/2] fscrypt: Add SM4 XTS/CTS symmetric algorithm
 support
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
References: <20221125121630.87793-1-tianjia.zhang@linux.alibaba.com>
 <20221125121630.87793-3-tianjia.zhang@linux.alibaba.com>
 <Y4EIR+n8aKutuLo0@sol.localdomain>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <Y4EIR+n8aKutuLo0@sol.localdomain>
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

On 11/26/22 2:24 AM, Eric Biggers wrote:
> On Fri, Nov 25, 2022 at 08:16:30PM +0800, Tianjia Zhang wrote:
>> diff --git a/fs/crypto/policy.c b/fs/crypto/policy.c
>> index 46757c3052ef..8e69bc0c35cd 100644
>> --- a/fs/crypto/policy.c
>> +++ b/fs/crypto/policy.c
>> @@ -71,6 +71,10 @@ static bool fscrypt_valid_enc_modes_v1(u32 contents_mode, u32 filenames_mode)
>>   	    filenames_mode == FSCRYPT_MODE_AES_128_CTS)
>>   		return true;
>>   
>> +	if (contents_mode == FSCRYPT_MODE_SM4_XTS &&
>> +	    filenames_mode == FSCRYPT_MODE_SM4_CTS)
>> +		return true;
>> +
>>   	if (contents_mode == FSCRYPT_MODE_ADIANTUM &&
>>   	    filenames_mode == FSCRYPT_MODE_ADIANTUM)
>>   		return true;
> 
> Sorry, one more thing I didn't notice before.  Since this is a new feature,
> please only allow it in fscrypt_valid_enc_modes_v2(), not in
> fscrypt_valid_enc_modes_v1().  That's what we did for AES-256-XTS +
> AES-256-HCTR2 recently.  There should be no need to add new features to
> v1 encryption policies, which have been deprecated for several years.
> 
> - Eric

Thanks for reminder, it makes sense to only support the new algorithm in
v2 policy, which I will do this.

BR,
Tianjia
