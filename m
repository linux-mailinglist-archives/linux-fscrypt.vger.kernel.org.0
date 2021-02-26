Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72F9F325B68
	for <lists+linux-fscrypt@lfdr.de>; Fri, 26 Feb 2021 02:58:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229460AbhBZB5r (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 25 Feb 2021 20:57:47 -0500
Received: from zg8tmty1ljiyny4xntqumjca.icoremail.net ([165.227.154.27]:39277
        "HELO zg8tmty1ljiyny4xntqumjca.icoremail.net" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with SMTP id S229492AbhBZB5q (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 25 Feb 2021 20:57:46 -0500
X-Greylist: delayed 833 seconds by postgrey-1.27 at vger.kernel.org; Thu, 25 Feb 2021 20:57:44 EST
Received: from [10.115.11.33] (unknown [198.19.131.34])
        by front-2 (Coremail) with SMTP id DAGowAC3gX4JUjhgB7o1AA--.5397S3;
        Fri, 26 Feb 2021 09:42:33 +0800 (CST)
Subject: Re: [PATCH] f2fs: fsverity: Truncate cache pages if set verity failed
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     Chao Yu <chao@kernel.org>, jaegeuk@kernel.org,
        linux-f2fs-devel@lists.sourceforge.net, bintian.wang@hihonor.com,
        linux-fscrypt@vger.kernel.org
References: <20210223112425.19180-1-heyunlei@hihonor.com>
 <c1ce1421-2576-5b48-322c-fa682c7510d7@kernel.org>
 <YDbbGSsd6ibKOpzT@sol.localdomain> <YDbdEEcEV5bzgtL6@sol.localdomain>
From:   heyunlei 00015531 <heyunlei@hihonor.com>
Message-ID: <fae4a2f9-b1c9-e673-cefe-fe024ce6f9ab@hihonor.com>
Date:   Fri, 26 Feb 2021 09:42:33 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.0
MIME-Version: 1.0
In-Reply-To: <YDbdEEcEV5bzgtL6@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID: DAGowAC3gX4JUjhgB7o1AA--.5397S3
X-Coremail-Antispam: 1UD129KBjvJXoW7Kry3urWDKw1DtFyUAry8Grg_yoW8Cw4DpF
        WkJF10ka1DAry7urn2vF109r1FyFWUKrW7ZF98Xw109F1vvFnagr40qrZY9anFqr4xGa10
        qw47GFZrXr48CaDanT9S1TB71UUUUUUqnTZGkaVYY2UrUUUUjbIjqfuFe4nvWSU5nxnvy2
        9KBjDU0xBIdaVrnRJUUU901xkIjI8I6I8E6xAIw20EY4v20xvaj40_Wr0E3s1l1IIY67AE
        w4v_Jr0_Jr4l8cAvFVAK0II2c7xJM28CjxkF64kEwVA0rcxSw2x7M28EF7xvwVC0I7IYx2
        IY67AKxVWDJVCq3wA2z4x0Y4vE2Ix0cI8IcVCY1x0267AKxVW0oVCq3wA2z4x0Y4vEx4A2
        jsIE14v26rxl6s0DM28EF7xvwVC2z280aVCY1x0267AKxVW0oVCq3wAS0I0E0xvYzxvE52
        x082IY62kv0487Mc02F40EFcxC0VAKzVAqx4xG6I80ewAv7VC0I7IYx2IY67AKxVWUtVWr
        XwAv7VC2z280aVAFwI0_Gr1j6F4UJwAm72CE4IkC6x0Yz7v_Jr0_Gr1lF7xvr2IY64vIr4
        1lF7I21c0EjII2zVCS5cI20VAGYxC7Mxk0xIA0c2IEe2xFo4CEbIxvr21lc2xSY4AK6svP
        MxAIw28IcxkI7VAKI48JMxAIw28IcVCjz48v1sIEY20_XFWUJr1UMxC20s026xCaFVCjc4
        AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWlx4CE
        17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r1xMI
        IF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_WFyUJVCq
        3wCI42IY6I8E87Iv67AKxVWUJVW8JwCI42IY6I8E87Iv6xkF7I0E14v26r1j6r4UYxBIda
        VFxhVjvjDU0xZFpf9x0JULTmhUUUUU=
X-CM-SenderInfo: pkh130hohlqxxlkr003uof0z/1tbiAQIGEV3ki2PqPwABsR
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


在 2021/2/25 7:11, Eric Biggers 写道:
> On Wed, Feb 24, 2021 at 03:02:52PM -0800, Eric Biggers wrote:
>> Hi Yunlei,
>>
>> On Wed, Feb 24, 2021 at 09:16:24PM +0800, Chao Yu wrote:
>>> Hi Yunlei,
>>>
>>> On 2021/2/23 19:24, heyunlei wrote:
>>>> If file enable verity failed, should truncate anything wrote
>>>> past i_size, including cache pages.
>>> +Cc Eric,
>>>
>>> After failure of enabling verity, we will see verity metadata if we truncate
>>> file to larger size later?
>>>
>>> Thanks,
Hi Eric，
>>>> Signed-off-by: heyunlei <heyunlei@hihonor.com>
>>>> ---
>>>>    fs/f2fs/verity.c | 4 +++-
>>>>    1 file changed, 3 insertions(+), 1 deletion(-)
>>>>
>>>> diff --git a/fs/f2fs/verity.c b/fs/f2fs/verity.c
>>>> index 054ec852b5ea..f1f9b9361a71 100644
>>>> --- a/fs/f2fs/verity.c
>>>> +++ b/fs/f2fs/verity.c
>>>> @@ -170,8 +170,10 @@ static int f2fs_end_enable_verity(struct file *filp, const void *desc,
>>>>    	}
>>>>    	/* If we failed, truncate anything we wrote past i_size. */
>>>> -	if (desc == NULL || err)
>>>> +	if (desc == NULL || err) {
>>>> +		truncate_inode_pages(inode->i_mapping, inode->i_size);
>>>>    		f2fs_truncate(inode);
>>>> +	}
>>>>    	clear_inode_flag(inode, FI_VERITY_IN_PROGRESS);
>>>>
By the way，should  we consider  set xattr failed?

Thanks.

>> This looks good; thanks for finding this.  You can add:
>>
>> 	Reviewed-by: Eric Biggers <ebiggers@google.com>
>>
>> I thought that f2fs_truncate() would truncate pagecache pages too, but in fact
>> that's not the case.
>>
>> ext4_end_enable_verity() has the same bug too.  Can you please send a patch for
>> that too (to linux-ext4)?
>>
> Also please include the following tags in the f2fs patch:
>
> 	Fixes: 95ae251fe828 ("f2fs: add fs-verity support")
> 	Cc: <stable@vger.kernel.org> # v5.4+
>
> and in the ext4 patch:
>
> 	Fixes: c93d8f885809 ("ext4: add basic fs-verity support")
> 	Cc: <stable@vger.kernel.org> # v5.4+
>
> - Eric

