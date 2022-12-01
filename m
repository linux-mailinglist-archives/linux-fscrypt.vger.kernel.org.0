Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D391963F0CA
	for <lists+linux-fscrypt@lfdr.de>; Thu,  1 Dec 2022 13:46:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230213AbiLAMqK (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 1 Dec 2022 07:46:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230040AbiLAMqJ (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 1 Dec 2022 07:46:09 -0500
Received: from out30-7.freemail.mail.aliyun.com (out30-7.freemail.mail.aliyun.com [115.124.30.7])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA30684DFA;
        Thu,  1 Dec 2022 04:46:03 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R111e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018045170;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=11;SR=0;TI=SMTPD_---0VW8qGyf_1669898759;
Received: from 30.32.116.214(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VW8qGyf_1669898759)
          by smtp.aliyun-inc.com;
          Thu, 01 Dec 2022 20:46:01 +0800
Message-ID: <fc2c7a50-6330-b9d5-6f50-0c6e2ccfb680@linux.alibaba.com>
Date:   Thu, 1 Dec 2022 20:45:58 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v3 2/2] fscrypt: Add SM4 XTS/CTS symmetric algorithm
 support
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
References: <20221125121630.87793-1-tianjia.zhang@linux.alibaba.com>
 <20221125121630.87793-3-tianjia.zhang@linux.alibaba.com>
 <1a5e57be-ccff-f281-6e06-be5e59db1d05@gmail.com>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <1a5e57be-ccff-f281-6e06-be5e59db1d05@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-10.2 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
        UNPARSEABLE_RELAY,USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Bagas,

On 11/28/22 9:33 PM, Bagas Sanjaya wrote:
> On 11/25/22 19:16, Tianjia Zhang wrote:
>> SM4 is a symmetric algorithm widely used in China, and is even mandatory
>> in many scenarios. We need to provide these users with the ability to
>> encrypt files or disks using SM4-XTS, and many other algorithms that use
>> SM2/3/4 algorithms or their combined algorithm scenarios, these features
>> are demanded by many users, this patch enables to use SM4-XTS mode to
>> encrypt file content, and use SM4-CBC-CTS to encrypt filename.
>>
> 
> Similar reply as [1]. That is, better say:
> 
> ```
> Add support for XTS and CTS mode variant of SM4 algorithm, in similar
> fashion to SM2 and SM3. The former is used to encrypt file contents, while
> the latter (SM4-CBC-CTS) is used to encrypt filenames.
> ```
> 
> Thanks.
> 
> [1]: https://lore.kernel.org/linux-doc/42624542-6ccb-26a5-db98-d7944972246e@gmail.com/
> 

Thanks for your reply, it is very valuable for me, I will update it in
the next patch.

Cheers,
Tianjia
