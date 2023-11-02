Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B7EA87DFD30
	for <lists+linux-fscrypt@lfdr.de>; Fri,  3 Nov 2023 00:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbjKBXKH (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 2 Nov 2023 19:10:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbjKBXKG (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 2 Nov 2023 19:10:06 -0400
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 4E200E5;
        Thu,  2 Nov 2023 16:10:00 -0700 (PDT)
Received: from [10.137.106.151] (unknown [131.107.159.23])
        by linux.microsoft.com (Postfix) with ESMTPSA id 9910520B74C0;
        Thu,  2 Nov 2023 16:09:59 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 9910520B74C0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1698966599;
        bh=lp2z5BxeRGAHA/HAb67fp8SLQnfHslP51OFaV1ICsHM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=ZbkFjUNGs32xbYQ2lx/qXk1hmKb3yJTxfTbeVKjhKAfTGmaS+VJXtC+so76x7ubRQ
         E+e8vbuv6XKMDEUYdophRxGt8FMSuGIR7EZprLnBAzJ2DPJuMujJR9Dx0A2E9RbkJb
         b/S1EpOnEFD+dW40FzsEZGH82Is4Kp7xJUMq5WAo=
Message-ID: <674f6e74-e630-4ed3-b7e8-1de89a83f032@linux.microsoft.com>
Date:   Thu, 2 Nov 2023 16:09:59 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v11 17/19] scripts: add boot policy generation program
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
References: <1696457386-3010-18-git-send-email-wufan@linux.microsoft.com>
 <0c3ac562e5b8ea82d962478459bc7047.paul@paul-moore.com>
From:   Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <0c3ac562e5b8ea82d962478459bc7047.paul@paul-moore.com>
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
>> Enables an IPE policy to be enforced from kernel start, enabling access
>> control based on trust from kernel startup. This is accomplished by
>> transforming an IPE policy indicated by CONFIG_IPE_BOOT_POLICY into a
>> c-string literal that is parsed at kernel startup as an unsigned policy.
>>
>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
>> ---
>> v2:
>>    + No Changes
>>
>> v3:
>>    + No Changes
>>
>> v4:
>>    + No Changes
>>
>> v5:
>>    + No Changes
>>
>> v6:
>>    + No Changes
>>
>> v7:
>>    + Move from 01/11 to 14/16
>>    + Don't return errno directly.
>>    + Make output of script more user-friendly
>>    + Add escaping for tab and '?'
>>    + Mark argv pointer const
>>    + Invert return code check in the boot policy parsing code path.
>>
>> v8:
>>    + No significant changes.
>>
>> v9:
>>    + No changes
>>
>> v10:
>>    + Update the init part code for rcu changes in the eval loop patch
>>
>> v11:
>>    + Fix code style issues
>> ---
>>   MAINTAINERS                   |   1 +
>>   scripts/Makefile              |   1 +
>>   scripts/ipe/Makefile          |   2 +
>>   scripts/ipe/polgen/.gitignore |   1 +
>>   scripts/ipe/polgen/Makefile   |   6 ++
>>   scripts/ipe/polgen/polgen.c   | 145 ++++++++++++++++++++++++++++++++++
>>   security/ipe/.gitignore       |   1 +
>>   security/ipe/Kconfig          |  10 +++
>>   security/ipe/Makefile         |  11 +++
>>   security/ipe/fs.c             |   8 ++
>>   security/ipe/ipe.c            |  12 +++
>>   11 files changed, 198 insertions(+)
>>   create mode 100644 scripts/ipe/Makefile
>>   create mode 100644 scripts/ipe/polgen/.gitignore
>>   create mode 100644 scripts/ipe/polgen/Makefile
>>   create mode 100644 scripts/ipe/polgen/polgen.c
>>   create mode 100644 security/ipe/.gitignore
> 
> ...
> 
>> diff --git a/scripts/ipe/polgen/polgen.c b/scripts/ipe/polgen/polgen.c
>> new file mode 100644
>> index 000000000000..40b6fe07f47b
>> --- /dev/null
>> +++ b/scripts/ipe/polgen/polgen.c
>> @@ -0,0 +1,145 @@
> 
> ...
> 
>> +static int write_boot_policy(const char *pathname, const char *buf, size_t size)
>> +{
>> +	int rc = 0;
>> +	FILE *fd;
>> +	size_t i;
>> +
>> +	fd = fopen(pathname, "w");
>> +	if (!fd) {
>> +		rc = errno;
>> +		goto err;
>> +	}
>> +
>> +	fprintf(fd, "/* This file is automatically generated.");
>> +	fprintf(fd, " Do not edit. */\n");
>> +	fprintf(fd, "#include <linux/stddef.h>\n");
>> +	fprintf(fd, "\nextern const char *const ipe_boot_policy;\n\n");
>> +	fprintf(fd, "const char *const ipe_boot_policy =\n");
>> +
>> +	if (!buf || size == 0) {
>> +		fprintf(fd, "\tNULL;\n");
>> +		fclose(fd);
>> +		return 0;
>> +	}
>> +
>> +	fprintf(fd, "\t\"");
>> +
>> +	for (i = 0; i < size; ++i) {
>> +		switch (buf[i]) {
>> +		case '"':
>> +			fprintf(fd, "\\\"");
>> +			break;
>> +		case '\'':
>> +			fprintf(fd, "'");
>> +			break;
> 
> The revision of IPE proposed in this patchset doesn't support parsing
> single or double quotes, yes? >
Actually all characters can be used in the policy. The previous revision 
was removing the quote syntax, which supports having space in the policy 
name like policy_name="example policy". But that is not related to the 
boot policy generation code here.

The code here is to generate a C source code that will be linked into 
IPE. Thus we have to escape these characters to conform with the C 
language string literal standard.

-Fan
>> +		case '\n':
>> +			fprintf(fd, "\\n\"\n\t\"");
>> +			break;
>> +		case '\\':
>> +			fprintf(fd, "\\\\");
>> +			break;
>> +		case '\t':
>> +			fprintf(fd, "\\t");
>> +			break;
>> +		case '\?':
>> +			fprintf(fd, "\\?");
>> +			break;
> 
> Similar, are question marks supported by the parser?
> 
>> +		default:
>> +			fprintf(fd, "%c", buf[i]);
>> +		}
>> +	}
>> +	fprintf(fd, "\";\n");
>> +	fclose(fd);
>> +
>> +	return 0;
>> +
>> +err:
>> +	if (fd)
>> +		fclose(fd);
>> +	return rc;
>> +}
> 
> ...
> 
>> diff --git a/security/ipe/.gitignore b/security/ipe/.gitignore
>> new file mode 100644
>> index 000000000000..eca22ad5ed22
>> --- /dev/null
>> +++ b/security/ipe/.gitignore
>> @@ -0,0 +1 @@
>> +boot-policy.c
>> \ No newline at end of file
> 
> Add a newline please.
> 
> --
> paul-moore.com
