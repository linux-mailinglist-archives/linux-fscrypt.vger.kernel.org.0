Return-Path: <linux-fscrypt+bounces-176-lists+linux-fscrypt=lfdr.de@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from sy.mirrors.kernel.org (sy.mirrors.kernel.org [IPv6:2604:1380:40f1:3f00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F098584AA52
	for <lists+linux-fscrypt@lfdr.de>; Tue,  6 Feb 2024 00:12:04 +0100 (CET)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sy.mirrors.kernel.org (Postfix) with ESMTPS id 384A1B271B0
	for <lists+linux-fscrypt@lfdr.de>; Mon,  5 Feb 2024 23:12:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D91F4879D;
	Mon,  5 Feb 2024 23:11:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b="sZ5JcpBE"
X-Original-To: linux-fscrypt@vger.kernel.org
Received: from linux.microsoft.com (linux.microsoft.com [13.77.154.182])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 62D3947F71;
	Mon,  5 Feb 2024 23:11:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=13.77.154.182
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707174680; cv=none; b=UDSCaCOWW/D8koIvF3T5Bvom4UeutsEOf7UGJKqZRQWLKp3tvqnAqPhDrGUDUUCkGMgLTp6LhXq2YFVO1vHH8Lc48UOc7zMpEPJ4c/9qa3repYw8ixFlruBtQU3egD6wXFJHq24vc4Kd/xsQYNBFWPIhHPHB0h5wSa45VVNeUt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707174680; c=relaxed/simple;
	bh=pE6MdVN8qRUDubmDe46A7CJY5B3Qr0+bzM13aSgneso=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Scp++9RPRIM7OXqP4raypbtKIpe7osKIYe3kaHkrDOVfrWXyANXQIZEymMhPDrXFX0jdMFCKBhhu9nzxG+m0FY6nghGwTK8Bzxq2cei2HtHPTVzRBffZhfSUFbjncKiNiErcP0T34ArWI6TwYvecZPZzGQm51KjIGrg5XSwnAWI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com; spf=pass smtp.mailfrom=linux.microsoft.com; dkim=pass (1024-bit key) header.d=linux.microsoft.com header.i=@linux.microsoft.com header.b=sZ5JcpBE; arc=none smtp.client-ip=13.77.154.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.microsoft.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.microsoft.com
Received: from [10.137.106.151] (unknown [131.107.8.87])
	by linux.microsoft.com (Postfix) with ESMTPSA id D8C2A20B2000;
	Mon,  5 Feb 2024 15:11:17 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com D8C2A20B2000
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
	s=default; t=1707174678;
	bh=Ndb3q4NxTVGdYAy+TAfeKWikxpySz2s7vTNU2j8oIL0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=sZ5JcpBEWZCQFsCouuZivlp8iM7AvQIuNOf+fza8KND4ZizOEY7volAf2PCDH9BaQ
	 7cf8cK0vRo29gbMz4OlsuWJ0Bt0Yfk3offf/ohotKJrKT3yrNTYNUV2J7GkGcahRnl
	 b4UXffDncGye8rwlLaTTZQP/4sFhzaImaso64bUw=
Message-ID: <05cb5f03-9236-47b7-8dd4-1741c289efdc@linux.microsoft.com>
Date: Mon, 5 Feb 2024 15:11:17 -0800
Precedence: bulk
X-Mailing-List: linux-fscrypt@vger.kernel.org
List-Id: <linux-fscrypt.vger.kernel.org>
List-Subscribe: <mailto:linux-fscrypt+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-fscrypt+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v12 15/20] ipe: add support for dm-verity as a trust
 provider
Content-Language: en-US
To: Paul Moore <paul@paul-moore.com>, corbet@lwn.net, zohar@linux.ibm.com,
 jmorris@namei.org, serge@hallyn.com, tytso@mit.edu, ebiggers@kernel.org,
 axboe@kernel.dk, agk@redhat.com, snitzer@kernel.org, eparis@redhat.com
Cc: linux-doc@vger.kernel.org, linux-integrity@vger.kernel.org,
 linux-security-module@vger.kernel.org, linux-fscrypt@vger.kernel.org,
 linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 audit@vger.kernel.org, linux-kernel@vger.kernel.org,
 Deven Bowers <deven.desai@linux.microsoft.com>
References: <1706654228-17180-16-git-send-email-wufan@linux.microsoft.com>
 <6ac3cca9d1d3505f3ed9c7196512f2db@paul-moore.com>
From: Fan Wu <wufan@linux.microsoft.com>
In-Reply-To: <6ac3cca9d1d3505f3ed9c7196512f2db@paul-moore.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit



On 2/3/2024 2:25 PM, Paul Moore wrote:
> On Jan 30, 2024 Fan Wu <wufan@linux.microsoft.com> wrote:
>>
>> Allows author of IPE policy to indicate trust for a singular dm-verity
>> volume, identified by roothash, through "dmverity_roothash" and all
>> signed dm-verity volumes, through "dmverity_signature".
>>
>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>> Signed-off-by: Fan Wu <wufan@linux.microsoft.com>
>> ---
>> v2:
>>    + No Changes
>>
>> v3:
>>    + No changes
>>
>> v4:
>>    + No changes
>>
>> v5:
>>    + No changes
>>
>> v6:
>>    + Fix an improper cleanup that can result in
>>      a leak
>>
>> v7:
>>    + Squash patch 08/12, 10/12 to [11/16]
>>
>> v8:
>>    + Undo squash of 08/12, 10/12 - separating drivers/md/ from security/
>>      & block/
>>    + Use common-audit function for dmverity_signature.
>>    + Change implementation for storing the dm-verity digest to use the
>>      newly introduced dm_verity_digest structure introduced in patch
>>      14/20.
>>
>> v9:
>>    + Adapt to the new parser
>>
>> v10:
>>    + Select the Kconfig when all dependencies are enabled
>>
>> v11:
>>    + No changes
>>
>> v12:
>>    + Refactor to use struct digest_info* instead of void*
>>    + Correct audit format
>> ---
>>   security/ipe/Kconfig         |  18 ++++++
>>   security/ipe/Makefile        |   1 +
>>   security/ipe/audit.c         |  37 ++++++++++-
>>   security/ipe/digest.c        | 120 +++++++++++++++++++++++++++++++++++
>>   security/ipe/digest.h        |  26 ++++++++
>>   security/ipe/eval.c          |  90 +++++++++++++++++++++++++-
>>   security/ipe/eval.h          |  10 +++
>>   security/ipe/hooks.c         |  67 +++++++++++++++++++
>>   security/ipe/hooks.h         |   8 +++
>>   security/ipe/ipe.c           |  15 +++++
>>   security/ipe/ipe.h           |   4 ++
>>   security/ipe/policy.h        |   3 +
>>   security/ipe/policy_parser.c |  26 +++++++-
>>   13 files changed, 421 insertions(+), 4 deletions(-)
>>   create mode 100644 security/ipe/digest.c
>>   create mode 100644 security/ipe/digest.h
>>
>> diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
>> index ac4d558e69d5..7afb1ce0cb99 100644
>> --- a/security/ipe/Kconfig
>> +++ b/security/ipe/Kconfig
>> @@ -8,6 +8,7 @@ menuconfig SECURITY_IPE
>>   	depends on SECURITY && SECURITYFS && AUDIT && AUDITSYSCALL
>>   	select PKCS7_MESSAGE_PARSER
>>   	select SYSTEM_DATA_VERIFICATION
>> +	select IPE_PROP_DM_VERITY if DM_VERITY && DM_VERITY_VERIFY_ROOTHASH_SIG
>>   	help
>>   	  This option enables the Integrity Policy Enforcement LSM
>>   	  allowing users to define a policy to enforce a trust-based access
>> @@ -15,3 +16,20 @@ menuconfig SECURITY_IPE
>>   	  admins to reconfigure trust requirements on the fly.
>>   
>>   	  If unsure, answer N.
>> +
>> +if SECURITY_IPE
>> +menu "IPE Trust Providers"
>> +
>> +config IPE_PROP_DM_VERITY
>> +	bool "Enable support for dm-verity volumes"
>> +	depends on DM_VERITY && DM_VERITY_VERIFY_ROOTHASH_SIG
>> +	help
>> +	  This option enables the properties 'dmverity_signature' and
>> +	  'dmverity_roothash' in IPE policy. These properties evaluates
>> +	  to TRUE when a file is evaluated against a dm-verity volume
>> +	  that was mounted with a signed root-hash or the volume's
>> +	  root hash matches the supplied value in the policy.
>> +
>> +endmenu
>> +
>> +endif
>> diff --git a/security/ipe/Makefile b/security/ipe/Makefile
>> index 2279eaa3cea3..66de53687d11 100644
>> --- a/security/ipe/Makefile
>> +++ b/security/ipe/Makefile
>> @@ -6,6 +6,7 @@
>>   #
>>   
>>   obj-$(CONFIG_SECURITY_IPE) += \
>> +	digest.o \
>>   	eval.o \
>>   	hooks.o \
>>   	fs.o \
>> diff --git a/security/ipe/audit.c b/security/ipe/audit.c
>> index ed390d32c641..a4ad8e888df0 100644
>> --- a/security/ipe/audit.c
>> +++ b/security/ipe/audit.c
>> @@ -13,6 +13,7 @@
>>   #include "hooks.h"
>>   #include "policy.h"
>>   #include "audit.h"
>> +#include "digest.h"
>>   
>>   #define ACTSTR(x) ((x) == IPE_ACTION_ALLOW ? "ALLOW" : "DENY")
>>   
>> @@ -54,8 +55,30 @@ static const char *const audit_prop_names[__IPE_PROP_MAX] = {
>>   	"boot_verified=FALSE",
>>   	"boot_verified=TRUE",
>>   #endif /* CONFIG_BLK_DEV_INITRD */
>> +#ifdef CONFIG_IPE_PROP_DM_VERITY
>> +	"dmverity_roothash=",
>> +	"dmverity_signature=FALSE",
>> +	"dmverity_signature=TRUE",
>> +#endif /* CONFIG_IPE_PROP_DM_VERITY */
>>   };
>>   
>> +#ifdef CONFIG_IPE_PROP_DM_VERITY
>> +/**
>> + * audit_dmv_roothash - audit a roothash of a dmverity volume.
>> + * @ab: Supplies a pointer to the audit_buffer to append to.
>> + * @rh: Supplies a pointer to the digest structure.
>> + */
>> +static void audit_dmv_roothash(struct audit_buffer *ab, const void *rh)
>> +{
>> +	audit_log_format(ab, "%s", audit_prop_names[IPE_PROP_DMV_ROOTHASH]);
>> +	ipe_digest_audit(ab, rh);
>> +}
>> +#else
>> +static void audit_dmv_roothash(struct audit_buffer *ab, const void *rh)
>> +{
>> +}
>> +#endif /* CONFIG_IPE_PROP_DM_VERITY */
> 
> I talked about this back in my review of the v11 patchset and I'm
> guessing you may have missed it ... the problem with the above code is
> that the fields in an audit record should remain constant, even if
> there is no data for that particular field.  In cases where there is no
> data to record for a given field, a "?" should be used as the field's
> value, for example:
> 
>    dmverify_roothash=?
> 
> My guess is that you would want to do something like this:
> 
>    #else  /* !CONFIG_IPE_PROP_DM_VERITY */
>    static void audit_dmv_roothash(...)
>    {
>      audit_log_format(ab, "%s=?", audit_prop_names[...]);
>    }
>    #endif /* CONFIG_IPE_PROP_DM_VERITY */
> 
> --
> paul-moore.com

These code are used for auditing a policy rule, which the parser will 
guarantee the property will always have a valid value. The comments 
might be misleading which sounds like it's auditing a file's state. I 
will correct them.

Also as we previously discussed, the policy grammar shouldn't depend on 
any kernel switch so these preprocessor statement will be removed.

However, as an audit record should remain constant, I guess we should do 
some special treatment to anonymous files? Like audit record for them 
should include "path=? dev=? ino=?"

Thanks,
Fan

