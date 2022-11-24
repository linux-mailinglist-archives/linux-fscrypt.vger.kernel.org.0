Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6319A637339
	for <lists+linux-fscrypt@lfdr.de>; Thu, 24 Nov 2022 08:59:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229693AbiKXH76 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 24 Nov 2022 02:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229487AbiKXH7z (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 24 Nov 2022 02:59:55 -0500
Received: from out30-54.freemail.mail.aliyun.com (out30-54.freemail.mail.aliyun.com [115.124.30.54])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD39DC6611;
        Wed, 23 Nov 2022 23:59:48 -0800 (PST)
X-Alimail-AntiSpam: AC=PASS;BC=-1|-1;BR=01201311R241e4;CH=green;DM=||false|;DS=||;FP=0|-1|-1|-1|0|-1|-1|-1;HT=ay29a033018046050;MF=tianjia.zhang@linux.alibaba.com;NM=1;PH=DS;RN=10;SR=0;TI=SMTPD_---0VVa7Khj_1669276784;
Received: from 30.25.224.158(mailfrom:tianjia.zhang@linux.alibaba.com fp:SMTPD_---0VVa7Khj_1669276784)
          by smtp.aliyun-inc.com;
          Thu, 24 Nov 2022 15:59:45 +0800
Message-ID: <0d47da05-9818-e6ed-c778-b1ad90688125@linux.alibaba.com>
Date:   Thu, 24 Nov 2022 15:59:43 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.13.1
Subject: Re: [PATCH v2 2/2] fscrypt: Add SM4 XTS/CTS symmetric algorithm
 support
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Jens Axboe <axboe@kernel.dk>,
        Ard Biesheuvel <ardb@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-block@vger.kernel.org
References: <20221122070632.21910-1-tianjia.zhang@linux.alibaba.com>
 <20221122070632.21910-3-tianjia.zhang@linux.alibaba.com>
 <Y30hjJq1Vwl4k1dJ@sol.localdomain>
From:   Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
In-Reply-To: <Y30hjJq1Vwl4k1dJ@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-9.9 required=5.0 tests=BAYES_00,
        ENV_AND_HDR_SPF_MATCH,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_PASS,UNPARSEABLE_RELAY,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Eric,

On 11/23/22 3:22 AM, Eric Biggers wrote:
> On Tue, Nov 22, 2022 at 03:06:32PM +0800, Tianjia Zhang wrote:
>> SM4 is a symmetric algorithm widely used in China, this patch enables
>> to use SM4-XTS mode to encrypt file content, and use SM4-CBC-CTS to
>> encrypt filename.
>>
>> Signed-off-by: Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
> 
> There is still no explanation here about why you believe this algorithm is
> useful to support in fscrypt.
> 
> - Eric

Sorry, I will send a new version of patch to add these information.

Best regards,
Tianjia
