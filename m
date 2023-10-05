Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AAF707BA3A4
	for <lists+linux-fscrypt@lfdr.de>; Thu,  5 Oct 2023 17:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237972AbjJEP6I (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 5 Oct 2023 11:58:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234238AbjJEP4v (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 5 Oct 2023 11:56:51 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8B5D9D6E;
        Thu,  5 Oct 2023 07:05:12 -0700 (PDT)
Received: from [10.137.106.151] (unknown [131.107.159.23])
        by linux.microsoft.com (Postfix) with ESMTPSA id B993820B74C2;
        Wed,  4 Oct 2023 19:49:13 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com B993820B74C2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1696474153;
        bh=Q9nbMnYwHH7f2GSlKNYYueS4IcpkI9CiL+VC8hIGotI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=WbyW9rxMnFaT2Iu36dhbn8F+5sVeCOT8afGiKS5M3ZL0Um3gbVUZ49Mo8SCCLRpsN
         UGAMWmzNZClK+Dvzc0KLYQUXO8IZxUrjpwLkyUrxjR1L4etFdOiroBlvNu2qKxByqI
         0qEvB7/Rp9wtcn280lLIP3CbLdOdFHN3tCRQbyHs=
Message-ID: <d95c06e5-60e7-4adb-896f-5c99e7f4db52@linux.microsoft.com>
Date:   Wed, 4 Oct 2023 19:49:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [RFC PATCH v11 15/19] fsverity: consume builtin signature via LSM
 hook
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     corbet@lwn.net, zohar@linux.ibm.com, jmorris@namei.org,
        serge@hallyn.com, tytso@mit.edu, axboe@kernel.dk, agk@redhat.com,
        snitzer@kernel.org, eparis@redhat.com, paul@paul-moore.com,
        linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
References: <1696457386-3010-1-git-send-email-wufan@linux.microsoft.com>
 <1696457386-3010-16-git-send-email-wufan@linux.microsoft.com>
 <20231005022707.GA1688@quark.localdomain>
From:   Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <20231005022707.GA1688@quark.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-16.0 required=5.0 tests=BAYES_00,DATE_IN_PAST_06_12,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,
        RCVD_IN_DNSWL_BLOCKED,SPF_HELO_PASS,SPF_PASS,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 10/4/2023 7:27 PM, Eric Biggers wrote:
> On Wed, Oct 04, 2023 at 03:09:42PM -0700, Fan Wu wrote:
>> +#ifdef CONFIG_FS_VERITY_BUILTIN_SIGNATURES
>> +static int fsverity_inode_setsecurity(struct inode *inode,
>> +				      struct fsverity_descriptor *desc)
>> +{
>> +	return security_inode_setsecurity(inode, FS_VERITY_INODE_SEC_NAME,
>> +					  desc->signature,
>> +					  le32_to_cpu(desc->sig_size), 0);
>> +}
> 
> Why isn't the type of the second argument 'const struct fsverity_descriptor *'?
> 
> - Eric

Thanks for the suggestion. I agree that adding 'const' here is a better 
approach. I will update this in the next version.

-Fan
