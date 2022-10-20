Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D6577606BB7
	for <lists+linux-fscrypt@lfdr.de>; Fri, 21 Oct 2022 00:55:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229789AbiJTWzP (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 20 Oct 2022 18:55:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229776AbiJTWzL (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 20 Oct 2022 18:55:11 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E2C2DBBC6;
        Thu, 20 Oct 2022 15:55:06 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 14DD480238;
        Thu, 20 Oct 2022 18:55:04 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1666306506; bh=8UEx+3H1BitMLy+Y3opYn6AIE/LsLVHIBo5VnEHXCVw=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=CJGtiYiPMGuByPCBs2ytnDfU2xzkXC46LSWZLq1hQZmr++zBaAYR3HxTN7xZLLFnP
         YY6o0dEgargDZse4z7t3WKwVK+SDP9OMRHT3aQMf0cxLJm1fEUfmt7TnzxuhCtCblR
         iusKbpU9ch5V4LmPYh2+WetxHFL4W35RRkhe3CcATZmb7cKvejMDZG76reqzBdntIK
         dGJ8zX+xn3BQkN15wjII2EaQfLQo/mOJfmo9g8DCNvDzmKS7+5SjiWq+OTNlank02a
         Pb0zrb+0xP673RzT8nA+u7HH5B0OXYDesEa7MNqtlL6+OE4EDu7EEX0cNP3K46VZTk
         ANKuC4JYAYcDw==
Message-ID: <43955182-7158-0ce9-aeff-7dfa51559624@dorminy.me>
Date:   Thu, 20 Oct 2022 18:55:04 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v3 04/22] fscrypt: add extent-based encryption
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, Chris Mason <clm@fb.com>,
        Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>, linux-fscrypt@vger.kernel.org,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
References: <cover.1666281276.git.sweettea-kernel@dorminy.me>
 <d7246959ee0b8d2eeb7d6eb8cf40240374c6035c.1666281277.git.sweettea-kernel@dorminy.me>
 <Y1HBkva6fzSMpm+P@sol.localdomain>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <Y1HBkva6fzSMpm+P@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 10/20/22 17:45, Eric Biggers wrote:
> On Thu, Oct 20, 2022 at 12:58:23PM -0400, Sweet Tea Dorminy wrote:
>> Some filesystems need to encrypt data based on extents, rather than on
>> inodes, due to features incompatible with inode-based encryption. For
>> instance, btrfs can have multiple inodes referencing a single block of
>> data, and moves logical data blocks to different physical locations on
>> disk in the background; these two features mean traditional inode-based
>> file contents encryption will not work for btrfs.
>>
>> This change introduces fscrypt_extent_context objects, in analogy to
>> existing context objects based on inodes. For a filesystem which opts to
>> use extent-based encryption, a new hook provides a new
>> fscrypt_extent_context, generated in close analogy to the IVs generated
>> with existing policies. During file content encryption/decryption, the
>> existing fscrypt_context object provides key information, while the new
>> fscrypt_extent_context provides IV information. For filename encryption,
>> the existing IV generation methods are still used, since filenames are
>> not stored in extents.
>>
>> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>> ---
>>   fs/crypto/crypto.c          | 20 ++++++++--
>>   fs/crypto/fscrypt_private.h | 25 +++++++++++-
>>   fs/crypto/inline_crypt.c    | 28 ++++++++++---
>>   fs/crypto/policy.c          | 79 +++++++++++++++++++++++++++++++++++++
>>   include/linux/fscrypt.h     | 47 ++++++++++++++++++++++
>>   5 files changed, 189 insertions(+), 10 deletions(-)
>>
>> diff --git a/fs/crypto/crypto.c b/fs/crypto/crypto.c
>> index 7fe5979fbea2..08b495dc5c0c 100644
>> --- a/fs/crypto/crypto.c
>> +++ b/fs/crypto/crypto.c
>> @@ -81,8 +81,22 @@ void fscrypt_generate_iv(union fscrypt_iv *iv, u64 lblk_num,
>>   			 const struct fscrypt_info *ci)
>>   {
>>   	u8 flags = fscrypt_policy_flags(&ci->ci_policy);
>> +	struct inode *inode = ci->ci_inode;
>> +	const struct fscrypt_operations *s_cop = inode->i_sb->s_cop;
>>   
>> -	memset(iv, 0, ci->ci_mode->ivsize);
>> +	memset(iv, 0, sizeof(*iv));
>> +	if (s_cop->get_extent_context && lblk_num != U64_MAX) {
>> +		size_t extent_offset;
>> +		union fscrypt_extent_context ctx;
>> +		int ret;
>> +
>> +		ret = fscrypt_get_extent_context(inode, lblk_num, &ctx,
>> +						 &extent_offset, NULL);
>> +		WARN_ON_ONCE(ret);
>> +		memcpy(iv->raw, ctx.v1.iv.raw, sizeof(*iv));
>> +		iv->lblk_num += cpu_to_le64(extent_offset);
>> +		return;
>> +	}
> 
> Please read through my review comment
> https://lore.kernel.org/linux-fscrypt/Yx6MnaUqUTdjCmX+@quark/ again, as it
> doesn't seem that you've addressed it.
> 
> - Eric

I probably didn't understand it correctly. I think there were three 
points in it:

1) reconsider per-extent keys
2) make IV generation work for non-directkey policies as similarly as 
possible to how they work in inode-based filesystems
3) never use 'file-based' except in contrast to dm-crypt and other 
block-layer encryption.

For point 2, I changed the initial extent context generation to match up 
with fscrypt_generate_iv() (and probably didn't call that out enough in 
the description). (Looking at it again, I could literally call 
fscrypt_generate_iv() to generate the initial extent context; I didn't 
realize that before).

Then adding lblk_num to the existing lblk_num in the iv from the start 
of the extent should be the same as the iv->lblk_num setting in the 
inode-based case: for lblk 12, for instance, the same IV should result 
from inode-based with lblk 12, as with extent-based with an initial 
lblk_num of 9 and an extent_offset of 3. For shared extents, they'll be 
different, but for singly-referenced extents, the IVs should be exactly 
the same in theory.

I'm not sure whether I misunderstood the points or didn't address them 
fully, I apologize. Would you be up for elaborating where I missed, 
either by email or by videochat whenever works for you?

Thanks.
