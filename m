Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B39A552CBDE
	for <lists+linux-fscrypt@lfdr.de>; Thu, 19 May 2022 08:22:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231694AbiESGWr (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 19 May 2022 02:22:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229654AbiESGWq (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 19 May 2022 02:22:46 -0400
Received: from szxga08-in.huawei.com (szxga08-in.huawei.com [45.249.212.255])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EB0F2719;
        Wed, 18 May 2022 23:22:44 -0700 (PDT)
Received: from canpemm500005.china.huawei.com (unknown [172.30.72.55])
        by szxga08-in.huawei.com (SkyGuard) with ESMTP id 4L3frH6TCfz1JCPG;
        Thu, 19 May 2022 14:21:19 +0800 (CST)
Received: from [10.67.110.73] (10.67.110.73) by canpemm500005.china.huawei.com
 (7.192.104.229) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2375.24; Thu, 19 May
 2022 14:22:42 +0800
Message-ID: <6ef6905f-563d-2361-36fb-d6f56a5d6353@huawei.com>
Date:   Thu, 19 May 2022 14:22:41 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.1.0
Subject: Re: [PATCH -next v2] fs-verity: Use struct_size() helper in
 enable_verity()
To:     Eric Biggers <ebiggers@kernel.org>
CC:     <tytso@mit.edu>, <linux-fscrypt@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
References: <20220519022450.2434483-1-chris.zjh@huawei.com>
 <YoW0HG+Nbg681yWL@sol.localdomain> <YoW25wrIAiRVifMi@sol.localdomain>
 <e030eaf6-0b6b-7685-c5b6-fd0b57aea600@huawei.com>
 <YoXGEckfSNWKj2oT@sol.localdomain>
From:   "zhangjianhua (E)" <chris.zjh@huawei.com>
In-Reply-To: <YoXGEckfSNWKj2oT@sol.localdomain>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.67.110.73]
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
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

Thanks, I will do more work about sparse and maybe find some answers.


Zhang Jianhua

在 2022/5/19 12:22, Eric Biggers 写道:
> [Please use reply all, not just reply!]
>
> On Thu, May 19, 2022 at 11:54:48AM +0800, zhangjianhua (E) wrote:
>> Hi Eric
>>
>> The warnings in commit message are from the build log in Jan 2022, and I
>> find these sizeof are still here, so I submit
>>
>> these two patches. I build the kernel just now and encounter the same
>> situation with you, there are lots of warnings.
>>
>> Maybe you are right, there should be some mechanism to solve this problem
>> completely.
>>
>>
> I've updated the commit message and applied this patch, but not the other one,
> as the other one wasn't actually dealing with a variable length which made it
> pretty much pointless, as I mentioned.
>
> If you'd like to look into making sparse enable this warning by default, I'd
> certainly encourage you to do so.  But it looks like the warning itself could
> use some more work.  It probably should only warn if the
> sizeof(struct_with_flexible_array) is actually being added to another value, and
> where that value is not a compile-time constant.
>
> - Eric
> .
