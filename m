Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D13697DFD38
	for <lists+linux-fscrypt@lfdr.de>; Fri,  3 Nov 2023 00:12:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377571AbjKBXME (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Nov 2023 19:12:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235013AbjKBXMD (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Nov 2023 19:12:03 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 17194197;
        Thu,  2 Nov 2023 16:11:59 -0700 (PDT)
Received: from [10.137.106.151] (unknown [131.107.159.23])
        by linux.microsoft.com (Postfix) with ESMTPSA id 4D22220B74C1;
        Thu,  2 Nov 2023 16:11:58 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 4D22220B74C1
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1698966718;
        bh=sN/Mi76Mk3NmyPbtaF7zfyETOmjtDtZDxeZhp7Ju7YM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ICZrtpk2pjn0h7boORoZutOlTmaL7xZpFUzWC2vlIp2RQnmeqzZn60bjXDty3++Py
         g83lnITy3AoPGqfS3IA9KbAKi63F6DMpoSJDa9mzxKM6+qQ9X7VQxxTTsuKdrf9F4I
         raKYGcAXtGGLsMJ/W7Q6U9XPb2IrtVDhMZXj+vz8=
Message-ID: <8d4673ce-e5cf-4c70-971a-b9d0a6cdcbc9@linux.microsoft.com>
Date:   Thu, 2 Nov 2023 16:11:58 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v11 18/19] ipe: kunit test for parser
Content-Language: en-US
To:     Paul Moore <paul@paul-moore.com>, corbet@lwn.net,
        zohar@linux.ibm.com, jmorris@namei.org, serge@hallyn.com,
        tytso@mit.edu, ebiggers@kernel.org, axboe@kernel.dk,
        agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Cc:     linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        linux-fscrypt@vger.kernel.org, linux-block@vger.kernel.org,
        dm-devel@redhat.com, audit@vger.kernel.org,
        roberto.sassu@huawei.com, linux-kernel@vger.kernel.org,
        Deven Bowers <deven.desai@linux.microsoft.com>
References: <1696457386-3010-19-git-send-email-wufan@linux.microsoft.com>
 <88259677752389b350614857e6003b8c.paul@paul-moore.com>
From:   Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <88259677752389b350614857e6003b8c.paul@paul-moore.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-17.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_BLOCKED,
        SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,
        USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 10/23/2023 8:52 PM, Paul Moore wrote:
> On Oct  4, 2023 Fan Wu <wufan@linux.microsoft.com> wrote:
>>
>> Add various happy/unhappy unit tests for both IPE's parser.
> 
> I'm going to suggest: "... for IPE's policy parser."
Yeah this sounds more precise.
> 
> Also, aside from the policy parser tests, are there any other IPE
> functional tests?  We do have a testing guideline for new LSM
> submissions:
> 
>   "New LSMs must be accompanied by a test suite to verify basic
>    functionality and help identify regressions. The test suite
>    must be publicly available without download restrictions
>    requiring accounts, subscriptions, etc. Test coverage does
>    not need to reach a specific percentage, but core functionality
>    and any user interfaces should be well covered by the test
>    suite. Maintaining the test suite in a public git repository is
>    preferable over tarball snapshots. Integrating the test suite
>    with existing automated Linux kernel testing services is
>    encouraged."
> 
> https://github.com/LinuxSecurityModule/kernel/blob/main/README.md#new-lsm-guidelines
>
Yes we do have a test suite. I will add it in the next version.
-Fan

>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
>> ---
>> v1-v6:
>>    + Not present
>>
>> v7:
>>    Introduced
>>
>> v8:
>>    + Remove the kunit tests with respect to the fsverity digest, as these
>>      require significant changes to work with the new method of acquiring
>>      the digest at runtime.
>>
>> v9:
>>    + Remove the kunit tests related to ipe_context
>>
>> v10:
>>    + No changes
>>
>> v11:
>>    + No changes
>> ---
>>   security/ipe/Kconfig        |  17 +++
>>   security/ipe/Makefile       |   3 +
>>   security/ipe/policy_tests.c | 294 ++++++++++++++++++++++++++++++++++++
>>   3 files changed, 314 insertions(+)
>>   create mode 100644 security/ipe/policy_tests.c
> 
> --
> paul-moore.com
