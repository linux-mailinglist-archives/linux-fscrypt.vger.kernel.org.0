Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E42796B897C
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Mar 2023 05:21:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229484AbjCNEVX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 14 Mar 2023 00:21:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbjCNEVW (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 14 Mar 2023 00:21:22 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7889122CAE
        for <linux-fscrypt@vger.kernel.org>; Mon, 13 Mar 2023 21:20:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678767632;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=R78HCvU6k068SGJ+knP4kotRCmvYjI3dD35bsH56ELE=;
        b=ejI0MWyE+aha/QRoZopRjhrdcmWqKN6h/vBxJ5dIjqfSgtr5OO+E99yPux0sp9cmz4QGVr
        SOUamfEE4srG8hnLmBY0bE2fU5tcxteHHM03+ZYQ9qtNu14ZDggCy2l5UBw8tFf2Tf4rui
        0B9VUcz/YWsEVFCIl+9GMiy8KCEeTRk=
Received: from mail-pj1-f72.google.com (mail-pj1-f72.google.com
 [209.85.216.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-654-6Bdt7j2HOYOKB4JCuXryeg-1; Tue, 14 Mar 2023 00:20:31 -0400
X-MC-Unique: 6Bdt7j2HOYOKB4JCuXryeg-1
Received: by mail-pj1-f72.google.com with SMTP id m1-20020a17090a668100b00237d84de790so5352783pjj.0
        for <linux-fscrypt@vger.kernel.org>; Mon, 13 Mar 2023 21:20:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678767630;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=R78HCvU6k068SGJ+knP4kotRCmvYjI3dD35bsH56ELE=;
        b=UITXi9MoST6uhuM8Oo8DMUsjRXvelKaDgAefJ/LZJk75UA7Xt7zOnzQ3SriBe0v6aM
         DVygrcTFQl1Kok/8RIubneuyTr2AZzITdrdh4L94B8KQmcfvcFZaT0fyK11ePj9p5Mq0
         pxDdlqMbaHQk/jw1eD2pI1IjpypUQAjeK0On7pVfqWJfTxYhVBGgxF/mjgXmxmQQouGP
         4lgbxSsmlY5RwYQ0uxDq6gJg8zDqkv5ORhC6ZxSsv/VfXnbxC2dzHx+M/koRmF6pJYsV
         2t5aSyMs/GnY0TY32tTO7jdk0GEVqzh2+y20FLJSSltEyaP4PUZ3aOm7+f7c0yaPgyVh
         wVmQ==
X-Gm-Message-State: AO0yUKXmY7BJIC4zcvuoq25Tdh3smfAsfC8Zvq1o5DBT0SDkkYTTuB4r
        iBl9No0YGKk8I7fS7TBsdQjzNRlRGg4vzYhjJ/QfIqgYs9rAyHyaUzbdviAMZezP/weZfpUmUwH
        WErFV0zTt8m7MjM+2wk84q36F0Q==
X-Received: by 2002:a17:90b:180e:b0:23b:4439:4179 with SMTP id lw14-20020a17090b180e00b0023b44394179mr8416469pjb.28.1678767630503;
        Mon, 13 Mar 2023 21:20:30 -0700 (PDT)
X-Google-Smtp-Source: AK7set/JmwImg6inGqrRc9dNvLn3BYr2p9tnnvhBPq9197sAI606IDsFblmpIUfQVni3+ukdXVRysg==
X-Received: by 2002:a17:90b:180e:b0:23b:4439:4179 with SMTP id lw14-20020a17090b180e00b0023b44394179mr8416454pjb.28.1678767630210;
        Mon, 13 Mar 2023 21:20:30 -0700 (PDT)
Received: from [10.72.12.147] ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id z16-20020a631910000000b0050336b0b08csm522908pgl.19.2023.03.13.21.20.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 21:20:29 -0700 (PDT)
Message-ID: <46e90e39-1f7d-7260-acfc-e7ffd9aa88bd@redhat.com>
Date:   Tue, 14 Mar 2023 12:20:23 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 1/2] fscrypt: new helper function -
 fscrypt_prepare_atomic_open()
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Jeff Layton <jlayton@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230313123310.13040-1-lhenriques@suse.de>
 <20230313123310.13040-2-lhenriques@suse.de>
 <ZA9mwPUg7H/fq0L8@sol.localdomain>
 <f72cf7fe-f489-47f2-fab9-be9eee441fca@redhat.com>
 <ZA/bJ+BNEAIsunsG@sol.localdomain>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <ZA/bJ+BNEAIsunsG@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 14/03/2023 10:25, Eric Biggers wrote:
> On Tue, Mar 14, 2023 at 08:53:51AM +0800, Xiubo Li wrote:
>> On 14/03/2023 02:09, Eric Biggers wrote:
>>> On Mon, Mar 13, 2023 at 12:33:09PM +0000, Luís Henriques wrote:
>>>> + * The regular open path will use fscrypt_file_open for that, but in the
>>>> + * atomic open a different approach is required.
>>> This should actually be fscrypt_prepare_lookup, not fscrypt_file_open, right?
>>>
>>>> +int fscrypt_prepare_atomic_open(struct inode *dir, struct dentry *dentry)
>>>> +{
>>>> +	int err;
>>>> +
>>>> +	if (!IS_ENCRYPTED(dir))
>>>> +		return 0;
>>>> +
>>>> +	err = fscrypt_get_encryption_info(dir, true);
>>>> +	if (!err && !fscrypt_has_encryption_key(dir)) {
>>>> +		spin_lock(&dentry->d_lock);
>>>> +		dentry->d_flags |= DCACHE_NOKEY_NAME;
>>>> +		spin_unlock(&dentry->d_lock);
>>>> +	}
>>>> +
>>>> +	return err;
>>>> +}
>>>> +EXPORT_SYMBOL_GPL(fscrypt_prepare_atomic_open);
>>> [...]
>>>> +static inline int fscrypt_prepare_atomic_open(struct inode *dir,
>>>> +					      struct dentry *dentry)
>>>> +{
>>>> +	return -EOPNOTSUPP;
>>>> +}
>>> This has different behavior on unencrypted directories depending on whether
>>> CONFIG_FS_ENCRYPTION is enabled or not.  That's bad.
>>>
>>> In patch 2, the caller you are introducing has already checked IS_ENCRYPTED().
>>>
>>> Also, your kerneldoc comment for fscrypt_prepare_atomic_open() says it is for
>>> *encrypted* directories.
>>>
>>> So IMO, just remove the IS_ENCRYPTED() check from the CONFIG_FS_ENCRYPTION
>>> version of fscrypt_prepare_atomic_open().
>> IMO we should keep this check in fscrypt_prepare_atomic_open() to make it
>> consistent with the existing fscrypt_prepare_open(). And we can just remove
>> the check from ceph instead.
>>
> Well, then the !CONFIG_FS_ENCRYPTION version would need to return 0 if
> IS_ENCRYPTED() too.

For the !CONFIG_FS_ENCRYPTION version I think you mean:

  static inline int fscrypt_prepare_atomic_open(struct inode *dir, 
struct dentry *dentry)

  {
          if (IS_ENCRYPTED(dir))
                  return -EOPNOTSUPP;
          return 0;
  }


> Either way would be okay, but please don't do a mix of both approaches within a
> single function, as this patch currently does.
>
> Note that there are other fscrypt_* functions, such as fscrypt_get_symlink(),
> that require an IS_ENCRYPTED() inode, so that pattern is not new.

Yeah, correct, I didn't notice that.

- Xiubo
> - Eric
>
-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

