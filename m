Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098F6445782
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Nov 2021 17:50:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231814AbhKDQwu (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 4 Nov 2021 12:52:50 -0400
Received: from linux.microsoft.com ([13.77.154.182]:52224 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231670AbhKDQwu (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 4 Nov 2021 12:52:50 -0400
Received: from [10.137.106.139] (unknown [131.107.159.11])
        by linux.microsoft.com (Postfix) with ESMTPSA id 5488920ABA8A;
        Thu,  4 Nov 2021 09:50:11 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 5488920ABA8A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636044611;
        bh=70oKxXaC5XNouM0+NDiFgXEE5PMtET77eJLZFYYci9k=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=QTKVBJVMXPh2gPnr0WaTWevKIfpWcFm2+KUmt6g4+ZerTiyO4bnaGQU9fE12l0+Xh
         NA6uM9jk0VvhmBHbQp81K7f4KhiJzw0/yqY6vASd8stPO9uNngf5K8DzODGIhlxdTe
         6sM2ssGJXoFwN71AI5Iv1rQ/NlHEMZ1edwBVJXsQ=
Message-ID: <99aaf850-21d6-5f8c-0cf1-6c7390b8ceea@linux.microsoft.com>
Date:   Thu, 4 Nov 2021 09:50:10 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC PATCH v7 04/16] ipe: add userspace interface
Content-Language: en-US
To:     Roberto Sassu <roberto.sassu@huawei.com>,
        "corbet@lwn.net" <corbet@lwn.net>,
        "axboe@kernel.dk" <axboe@kernel.dk>,
        "agk@redhat.com" <agk@redhat.com>,
        "snitzer@redhat.com" <snitzer@redhat.com>,
        "ebiggers@kernel.org" <ebiggers@kernel.org>,
        "tytso@mit.edu" <tytso@mit.edu>,
        "paul@paul-moore.com" <paul@paul-moore.com>,
        "eparis@redhat.com" <eparis@redhat.com>,
        "jmorris@namei.org" <jmorris@namei.org>,
        "serge@hallyn.com" <serge@hallyn.com>
Cc:     "jannh@google.com" <jannh@google.com>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-fscrypt@vger.kernel.org" <linux-fscrypt@vger.kernel.org>,
        "linux-audit@redhat.com" <linux-audit@redhat.com>,
        "linux-security-module@vger.kernel.org" 
        <linux-security-module@vger.kernel.org>,
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
 <1634151995-16266-5-git-send-email-deven.desai@linux.microsoft.com>
 <601a323495b745f0a060e67f03af2337@huawei.com>
From:   Deven Bowers <deven.desai@linux.microsoft.com>
In-Reply-To: <601a323495b745f0a060e67f03af2337@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 11/3/2021 2:42 AM, Roberto Sassu wrote:
>>
>> +
>> +/**
>> + * ipe_init_securityfs: Initialize IPE's securityfs tree at fsinit
>> + *
>> + * Return:
>> + * !0 - Error
>> + * 0 - OK
>> + */
>> +static int __init ipe_init_securityfs(void)
>> +{
>> +	int rc = 0;
>> +	struct ipe_context *ctx = NULL;
>> +
>> +	ctx = ipe_current_ctx();
> Hi Deven
>
> the instruction above should be executed only if IPE LSM is
> enabled. Otherwise, the kernel panics due to the illegal access
> to the security blob of the task.

I see. I mistakenly assumed that failure in the LSM init would cause
a kernel panic (as the system is now booting without a potentially
required security component) as opposed to just disabling the LSM
and emitting a warning.

Easy fix for v8.

Thanks for pointing it out.


