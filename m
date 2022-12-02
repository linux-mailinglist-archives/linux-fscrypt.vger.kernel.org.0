Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E7B4E64064B
	for <lists+linux-fscrypt@lfdr.de>; Fri,  2 Dec 2022 13:02:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232653AbiLBMCF (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 2 Dec 2022 07:02:05 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233419AbiLBMB6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 2 Dec 2022 07:01:58 -0500
Received: from out30-1.freemail.mail.aliyun.com (out30-1.freemail.mail.aliyun.com [115.124.30.1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D827A5558;
        Fri,  2 Dec 2022 04:01:57 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R931e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045192;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VWE9a8o_1669982512;
Received: from 30.32.112.227(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VWE9a8o_1669982512)
          by smtp.aliyun-inc.com;
          Fri, 02 Dec 2022 20:01:53 +0800
Message-ID: <4ac71618-030a-e198-2885-f5f06d8483b3@linux.alibaba.com>
Date:   Fri, 2 Dec 2022 20:01:50 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v4 0/2] Add SM4 XTS symmetric algorithm for blk-crypto and
 fscrypt
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Ard Biesheuvel <ardb@kernel.org>,
        Bagas Sanjaya <bagasdotme@gmail.com>,
        linux-fscrypt@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
References: <20221201125819.36932-1-tianjia.zhang@linux.alibaba.com>
 <Y4kAiKhZL4Ucv3MI@sol.localdomain>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <Y4kAiKhZL4Ucv3MI@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

On 12/2/22 3:29 AM, Eric Biggers wrote:
> On Thu, Dec 01, 2022 at 08:58:17PM +0800, Tianjia Zhang wrote:
>> SM4 is widely used in China's data encryption software and hardware.
>> these algoritms are mandatory in many scenarios. This serial of
>> patches enables the SM4-XTS algorithm in blk-crypto and enables the
>> SM4-XTS/CTS algorithm in fscrypt to encrypt file content and filename.
>>
>> v4 changes:
>>    - only allow the SM4 XTS/CTS algorithm in policy v2 for fscrypt
>>    - update git commit message
>>
>> v3 change:
>>    - update git commit message
>>
>> v2 change:
>>    - As Eric said, the new FSCRYPT_MODE is defined for the unused numbers 7 and 8
>>
>> Tianjia Zhang (2):
>>    blk-crypto: Add support for SM4-XTS blk crypto mode
>>    fscrypt: Add SM4 XTS/CTS symmetric algorithm support
>>
>>   Documentation/filesystems/fscrypt.rst |  1 +
>>   block/blk-crypto.c                    |  6 ++++++
>>   fs/crypto/keysetup.c                  | 15 +++++++++++++++
>>   fs/crypto/policy.c                    |  5 +++++
>>   include/linux/blk-crypto.h            |  1 +
>>   include/uapi/linux/fscrypt.h          |  2 ++
>>   6 files changed, 30 insertions(+)
> 
> Applied.  I don't think anyone should actually use this, but with the SM*
> algorithms turning up everywhere these days, and people seemingly being totally
> okay with that for some reason, I don't think it's fair for me to reject this.
> 
> - Eric

Thanks, this is really frustrating, still very grateful for your advice
and review.

Best regards,
Tianjia
