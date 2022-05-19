Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B480D52C96C
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 03:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229566AbiESBun (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 18 May 2022 21:50:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232555AbiESBum (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 18 May 2022 21:50:42 -0400
Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2D311EC64;
        Wed, 18 May 2022 18:50:40 -0700 (PDT)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.56])
        by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4L3Xmb5Wy9zQkGp;
        Thu, 19 May 2022 09:47:43 +0800 (CST)
Received: from [10.67.110.73] (10.67.110.73) by canpemm500005.china.huawei.com
 (7.192.104.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 09:50:38 +0800
Message-ID: <0002ef8b-ebce-4b4b-8597-9687722d4e55@huawei.com>
Date:   Thu, 19 May 2022 09:50:38 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH -next] fs-verity: Use struct_size() helper in
 fsverity_ioctl_measure()
To:     Eric Biggers <ebiggers@kernel.org>
CC:     <tytso@mit.edu>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220518093829.2248801-1-chris.zjh@huawei.com>
 <YoUxX7iDBczYwGHC@sol.localdomain>
From:   "zhangjianhua (E)" <chris.zjh@huawei.com>
In-Reply-To: <YoUxX7iDBczYwGHC@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.110.73]
X-ClientProxiedBy: dggems701-chm.china.huawei.com (10.3.19.178) To
 canpemm500005.china.huawei.com (7.192.104.229)
X-CFilter-Loop: Reflected
X-Spam-Status: No, score=-6.3 required=5.0 tests=BAYES_00,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Thanks, I will modify the commit message and send the next version.


Zhang Jianhua

在 2022/5/19 1:48, Eric Biggers 写道:
> On Wed, May 18, 2022 at 05:38:29PM +0800, Zhang Jianhua wrote:
>> Make use of the struct_size() helper instead of an open-coded version,
>> in order to avoid any potential type mistakes or integer overflows that,
>> in the worst scenario, could lead to heap overflows.
>>
>> Also, address the following sparse warnings:
>> fs/verity/measure.c:48:9: warning: using sizeof on a flexible structure
>> fs/verity/measure.c:52:38: warning: using sizeof on a flexible structure
>>
>> Signed-off-by: Zhang Jianhua <chris.zjh@huawei.com>
>> ---
>>   fs/verity/measure.c | 5 +++--
>>   1 file changed, 3 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/verity/measure.c b/fs/verity/measure.c
>> index e99c00350c28..4a388116d0de 100644
>> --- a/fs/verity/measure.c
>> +++ b/fs/verity/measure.c
>> @@ -27,6 +27,7 @@ int fsverity_ioctl_measure(struct file *filp, void __user *_uarg)
>>   	const struct fsverity_info *vi;
>>   	const struct fsverity_hash_alg *hash_alg;
>>   	struct fsverity_digest arg;
>> +	size_t arg_size = struct_size(&arg, digest, 0);
>>   
>>   	vi = fsverity_get_info(inode);
>>   	if (!vi)
>> @@ -44,11 +45,11 @@ int fsverity_ioctl_measure(struct file *filp, void __user *_uarg)
>>   	if (arg.digest_size < hash_alg->digest_size)
>>   		return -EOVERFLOW;
>>   
>> -	memset(&arg, 0, sizeof(arg));
>> +	memset(&arg, 0, arg_size);
>>   	arg.digest_algorithm = hash_alg - fsverity_hash_algs;
>>   	arg.digest_size = hash_alg->digest_size;
>>   
>> -	if (copy_to_user(uarg, &arg, sizeof(arg)))
>> +	if (copy_to_user(uarg, &arg, arg_size))
>>   		return -EFAULT;
> 'arg' is just a stack variable that doesn't use the flexible array field.  So
> this change on its own is pretty pointless and just obfuscates the code.
>
> If it's nevertheless worth it to get rid of the sparse warning, to make the
> wider codebase clean of this class of warning, we could still do it anyway.  But
> please make the commit message correctly say that the purpose is just to
> eliminate the sparse warning, and don't incorrectly claim that the code "could
> lead to heap overflows".
>
> - Eric
> .
