Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 484826B871F
	for <lists+linux-fscrypt@lfdr.de>; Tue, 14 Mar 2023 01:41:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229978AbjCNAl5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 13 Mar 2023 20:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229807AbjCNAl5 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 13 Mar 2023 20:41:57 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 868AD8316B
        for <linux-fscrypt@vger.kernel.org>; Mon, 13 Mar 2023 17:40:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678754338;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=TACuEVUrpVGXTKr6EQlyJHtwWOffnTkzlOP52YnEJ9Q=;
        b=fBfZSaF7msr9rrMwXHlM6bJ886hZCxkrEjh1o1GCqGvdfrJexIQp2WdKdmKGAeSZB0Ulwg
        Y9jB1xp38ATz1GSpWN43qJX9fc+4mqyGR7iEtkjRlmw49J9UztWo0oFISSdpwuoRpME6A3
        kXmjaDcZF44bVe/FwdoTzCny4cveaGs=
Received: from mail-pl1-f199.google.com (mail-pl1-f199.google.com
 [209.85.214.199]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-480-N0hruRtgPlGnNc1YLLe-9A-1; Mon, 13 Mar 2023 20:38:57 -0400
X-MC-Unique: N0hruRtgPlGnNc1YLLe-9A-1
Received: by mail-pl1-f199.google.com with SMTP id l1-20020a170903244100b001a0468b4afcso2569495pls.12
        for <linux-fscrypt@vger.kernel.org>; Mon, 13 Mar 2023 17:38:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678754336;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=TACuEVUrpVGXTKr6EQlyJHtwWOffnTkzlOP52YnEJ9Q=;
        b=TRsG2aY0WJmq73uKjQQNaympK8nRPR1joyL8VJpVV3JxOlIkhRKgcpyE7b82AF4CYd
         dCm2+kMrQmq6uOo+4tjkzbdhJWpW9h7JFaFh6pD5wVvyBTxlwE0glJYJcqdHV2QdJrAt
         nbSLL95L0cWY6CjTL5pXg1t/4RHVR0rzMnKJ2Jhktr17zZQAVsoi+l0qmru6QRay3xsf
         BlAGwhRLkobC8kchTlUmXZfdHMSLFBOWd0Ne+SKlEn7+ujQAqdMhCoAnpQ4EyRokN29e
         AobGo8OSt/N7fwH4KhsKOSWrZTHJwGonMFlS9MRggqMKYI9QyqTxOQ7A/jVLmYhpJAgy
         uSYg==
X-Gm-Message-State: AO0yUKW5STlVgnK88S6uGXni/ytgWDd1OQmWe1b5TLklmb1yEOcP3/yr
        hnRVnHQpPeDxCprBEcIrn1ZuWmYFuNRhysb4Vr5zKDrys1gH9BnbcQFY4zxRlaiYa+46huCy5fG
        CRlQ6g/kiFpGaMcVRFcjxa/d+DA==
X-Received: by 2002:a05:6a20:258c:b0:cc:24de:4d6d with SMTP id k12-20020a056a20258c00b000cc24de4d6dmr36702650pzd.4.1678754336410;
        Mon, 13 Mar 2023 17:38:56 -0700 (PDT)
X-Google-Smtp-Source: AK7set9K+B8tzulqAPV8mv2hXEb5R62MQmg30WDjLsaks6kCiaul6YikY8Z+atOv0CNqRJUSEzKycQ==
X-Received: by 2002:a05:6a20:258c:b0:cc:24de:4d6d with SMTP id k12-20020a056a20258c00b000cc24de4d6dmr36702628pzd.4.1678754336077;
        Mon, 13 Mar 2023 17:38:56 -0700 (PDT)
Received: from [10.72.12.147] ([43.228.180.230])
        by smtp.gmail.com with ESMTPSA id s14-20020a65644e000000b0050362744b63sm285320pgv.90.2023.03.13.17.38.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 13 Mar 2023 17:38:55 -0700 (PDT)
Message-ID: <8aa61954-b6c4-d9b5-bb81-c03ca3631e3b@redhat.com>
Date:   Tue, 14 Mar 2023 08:38:49 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH 2/2] ceph: switch atomic open to use new fscrypt helper
Content-Language: en-US
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>,
        Eric Biggers <ebiggers@kernel.org>
Cc:     Jeff Layton <jlayton@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Ilya Dryomov <idryomov@gmail.com>,
        linux-fscrypt@vger.kernel.org, ceph-devel@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20230313123310.13040-1-lhenriques@suse.de>
 <20230313123310.13040-3-lhenriques@suse.de>
 <ZA9nPXNpBX0U5joC@sol.localdomain> <87cz5cv6h2.fsf@suse.de>
From:   Xiubo Li <xiubli@redhat.com>
In-Reply-To: <87cz5cv6h2.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 14/03/2023 02:42, Luís Henriques wrote:
> Eric Biggers <ebiggers@kernel.org> writes:
>
>> On Mon, Mar 13, 2023 at 12:33:10PM +0000, Luís Henriques wrote:
>>> Switch ceph atomic open to use fscrypt_prepare_atomic_open().  This fixes
>>> a bug where a dentry is incorrectly set with DCACHE_NOKEY_NAME when 'dir'
>>> has been evicted but the key is still available (for example, where there's
>>> a drop_caches).
>>>
>>> Signed-off-by: Luís Henriques <lhenriques@suse.de>
>>> ---
>>>   fs/ceph/file.c | 8 +++-----
>>>   1 file changed, 3 insertions(+), 5 deletions(-)
>>>
>>> diff --git a/fs/ceph/file.c b/fs/ceph/file.c
>>> index dee3b445f415..5ad57cc4c13b 100644
>>> --- a/fs/ceph/file.c
>>> +++ b/fs/ceph/file.c
>>> @@ -795,11 +795,9 @@ int ceph_atomic_open(struct inode *dir, struct dentry *dentry,
>>>   	ihold(dir);
>>>   	if (IS_ENCRYPTED(dir)) {
>>>   		set_bit(CEPH_MDS_R_FSCRYPT_FILE, &req->r_req_flags);
>>> -		if (!fscrypt_has_encryption_key(dir)) {
>>> -			spin_lock(&dentry->d_lock);
>>> -			dentry->d_flags |= DCACHE_NOKEY_NAME;
>>> -			spin_unlock(&dentry->d_lock);
>>> -		}
>>> +		err = fscrypt_prepare_atomic_open(dir, dentry);
>>> +		if (err)
>>> +			goto out_req;
>> Note that this patch does not apply to upstream or even to linux-next.
> True, I should have mentioned that in the cover-letter.  This patch should
> be applied against the 'testing' branch in https://github.com/ceph/ceph-client,
> which is where the ceph fscrypt currently lives.
>
>> I'd be glad to take patch 1 through the fscrypt tree for 6.4.  But I'm wondering
>> what the current plans are for getting ceph's fscrypt support upstream?
> As far as I know, the current plan is to try to merge the ceph code during
> the next merge window for 6.4 (but Xiubo and Ilya may correct me if I'm
> wrong).  Also, regarding who picks which patch, I'm fine with you picking
> the first one.  But I'll let the ceph maintainers say what they think,
> because it may be easier for them to keep both patches together due to the
> testing infrastructure being used.
>
> Anyway, I'll send out a new rev tomorrow taking your comments into
> account.  Thanks, Eric!

Eric, Luis,

It will be fine if Eric could merge patch 1 into the fscrypt tree. Then 
I will merge the patch 1 into the ceph-client's testing by tagging as 
[DO NOT MERGE] to run our tests.

And locally we are still running the test, and there have several fixes 
followed and need more time to review.

Thanks

- Xiubo

> Cheers,

-- 
Best Regards,

Xiubo Li (李秀波)

Email: xiubli@redhat.com/xiubli@ibm.com
Slack: @Xiubo Li

