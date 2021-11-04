Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAAD4445798
	for <lists+linux-fscrypt@lfdr.de>; Thu,  4 Nov 2021 17:52:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231642AbhKDQzO (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 4 Nov 2021 12:55:14 -0400
Received: from linux.microsoft.com ([13.77.154.182]:52558 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231616AbhKDQzO (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 4 Nov 2021 12:55:14 -0400
Received: from [10.137.106.139] (unknown [131.107.159.11])
        by linux.microsoft.com (Postfix) with ESMTPSA id 65FFE20ABA8A;
        Thu,  4 Nov 2021 09:52:35 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 65FFE20ABA8A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1636044755;
        bh=gVjYOmqakaCBm33SjcaX622aYmR7Eb5QVNqywVzkR1A=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=gyEKumgIdpc7ysbgRnLAYxnXTPpxkFXPp6NSz27VXnlnlcbgCMYPXyp7Lh+9ujL7c
         Mrg63flAg85A8iz8O4qzXtvZwPimtanwvLI47n8etgA4TWIsGnMiRCNra7cY2J8Dob
         F1KFn66qhrEK7wfrbRMw7pItdxnESdpr9OfKn1xA=
Message-ID: <81c57884-8a57-ae1f-1d85-929c3cb5bd58@linux.microsoft.com>
Date:   Thu, 4 Nov 2021 09:52:35 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.2.1
Subject: Re: [RFC PATCH v7 14/16] scripts: add boot policy generation program
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
 <1634151995-16266-15-git-send-email-deven.desai@linux.microsoft.com>
 <12aec559d6df4191a39ecaec7a0a378e@huawei.com>
 <5b4cdc3c3dba4fe68dfc9590b7d12e48@huawei.com>
From:   Deven Bowers <deven.desai@linux.microsoft.com>
In-Reply-To: <5b4cdc3c3dba4fe68dfc9590b7d12e48@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 11/3/2021 9:53 AM, Roberto Sassu wrote:
>> From: Roberto Sassu [mailto:roberto.sassu@huawei.com]
>> Sent: Wednesday, November 3, 2021 5:43 PM
>>> From: deven.desai@linux.microsoft.com
>>> [mailto:deven.desai@linux.microsoft.com]
>>> From: Deven Bowers <deven.desai@linux.microsoft.com>
>>>
>>> Enables an IPE policy to be enforced from kernel start, enabling access
>>> control based on trust from kernel startup. This is accomplished by
>>> transforming an IPE policy indicated by CONFIG_IPE_BOOT_POLICY into a
>>> c-string literal that is parsed at kernel startup as an unsigned policy.
>>>
>>> Signed-off-by: Deven Bowers <deven.desai@linux.microsoft.com>
>>> ---
>>>
>>> Relevant changes since v6:
>>>    * Move patch 01/12 to [14/16] of the series
>>>
>>> ---
>>>   MAINTAINERS                   |   1 +
>>>   scripts/Makefile              |   1 +
>>>   scripts/ipe/Makefile          |   2 +
>>>   scripts/ipe/polgen/.gitignore |   1 +
>>>   scripts/ipe/polgen/Makefile   |   6 ++
>>>   scripts/ipe/polgen/polgen.c   | 145 ++++++++++++++++++++++++++++++++++
>>>   security/ipe/.gitignore       |   1 +
>>>   security/ipe/Kconfig          |  10 +++
>>>   security/ipe/Makefile         |  13 +++
>>>   security/ipe/ctx.c            |  18 +++++
>>>   10 files changed, 198 insertions(+)
>>>   create mode 100644 scripts/ipe/Makefile
>>>   create mode 100644 scripts/ipe/polgen/.gitignore
>>>   create mode 100644 scripts/ipe/polgen/Makefile
>>>   create mode 100644 scripts/ipe/polgen/polgen.c
>>>   create mode 100644 security/ipe/.gitignore
>>>
>>> diff --git a/MAINTAINERS b/MAINTAINERS
>>> index f1e76f791d47..a84ca781199b 100644
>>> --- a/MAINTAINERS
>>> +++ b/MAINTAINERS
>>> @@ -9283,6 +9283,7 @@ INTEGRITY POLICY ENFORCEMENT (IPE)
>>>   M:	Deven Bowers <deven.desai@linux.microsoft.com>
>>>   M:	Fan Wu <wufan@linux.microsoft.com>
>>>   S:	Supported
>>> +F:	scripts/ipe/
>>>   F:	security/ipe/
>>>
>>>   INTEL 810/815 FRAMEBUFFER DRIVER
>>> diff --git a/scripts/Makefile b/scripts/Makefile
>>> index 9adb6d247818..a31da6d57a36 100644
>>> --- a/scripts/Makefile
>>> +++ b/scripts/Makefile
>>> @@ -41,6 +41,7 @@ targets += module.lds
>>>   subdir-$(CONFIG_GCC_PLUGINS) += gcc-plugins
>>>   subdir-$(CONFIG_MODVERSIONS) += genksyms
>>>   subdir-$(CONFIG_SECURITY_SELINUX) += selinux
>>> +subdir-$(CONFIG_SECURITY_IPE) += ipe
>>>
>>>   # Let clean descend into subdirs
>>>   subdir-	+= basic dtc gdb kconfig mod
>>> diff --git a/scripts/ipe/Makefile b/scripts/ipe/Makefile
>>> new file mode 100644
>>> index 000000000000..e87553fbb8d6
>>> --- /dev/null
>>> +++ b/scripts/ipe/Makefile
>>> @@ -0,0 +1,2 @@
>>> +# SPDX-License-Identifier: GPL-2.0-only
>>> +subdir-y := polgen
>>> diff --git a/scripts/ipe/polgen/.gitignore b/scripts/ipe/polgen/.gitignore
>>> new file mode 100644
>>> index 000000000000..80f32f25d200
>>> --- /dev/null
>>> +++ b/scripts/ipe/polgen/.gitignore
>>> @@ -0,0 +1 @@
>>> +polgen
>>> diff --git a/scripts/ipe/polgen/Makefile b/scripts/ipe/polgen/Makefile
>>> new file mode 100644
>>> index 000000000000..066060c22b4a
>>> --- /dev/null
>>> +++ b/scripts/ipe/polgen/Makefile
>>> @@ -0,0 +1,6 @@
>>> +# SPDX-License-Identifier: GPL-2.0
>>> +hostprogs-always-y	:= polgen
>>> +HOST_EXTRACFLAGS += \
>>> +	-I$(srctree)/include \
>>> +	-I$(srctree)/include/uapi \
>>> +
>>> diff --git a/scripts/ipe/polgen/polgen.c b/scripts/ipe/polgen/polgen.c
>>> new file mode 100644
>>> index 000000000000..73cf13e743f7
>>> --- /dev/null
>>> +++ b/scripts/ipe/polgen/polgen.c
>>> @@ -0,0 +1,145 @@
>>> +// SPDX-License-Identifier: GPL-2.0
>>> +/*
>>> + * Copyright (C) Microsoft Corporation. All rights reserved.
>>> + */
>>> +
>>> +#include <stdlib.h>
>>> +#include <stddef.h>
>>> +#include <stdio.h>
>>> +#include <unistd.h>
>>> +#include <errno.h>
>>> +
>>> +static void usage(const char *const name)
>>> +{
>>> +	printf("Usage: %s OutputFile (PolicyFile)\n", name);
>>> +	exit(EINVAL);
>>> +}
>>> +
>>> +static int policy_to_buffer(const char *pathname, char **buffer, size_t *size)
>>> +{
>>> +	int rc = 0;
>>> +	FILE *fd;
>>> +	char *lbuf;
>>> +	size_t fsize;
>>> +	size_t read;
>>> +
>>> +	fd = fopen(pathname, "r");
>>> +	if (!fd) {
>>> +		rc = errno;
>>> +		goto out;
>>> +	}
>>> +
>>> +	fseek(fd, 0, SEEK_END);
>>> +	fsize = ftell(fd);
>>> +	rewind(fd);
>>> +
>>> +	lbuf = malloc(fsize);
>>> +	if (!lbuf) {
>>> +		rc = ENOMEM;
>>> +		goto out_close;
>>> +	}
>>> +
>>> +	read = fread((void *)lbuf, sizeof(*lbuf), fsize, fd);
>>> +	if (read != fsize) {
>>> +		rc = -1;
>>> +		goto out_free;
>>> +	}
>>> +
>>> +	*buffer = lbuf;
>>> +	*size = fsize;
>>> +	fclose(fd);
>>> +
>>> +	return rc;
>>> +
>>> +out_free:
>>> +	free(lbuf);
>>> +out_close:
>>> +	fclose(fd);
>>> +out:
>>> +	return rc;
>>> +}
>>> +
>>> +static int write_boot_policy(const char *pathname, const char *buf, size_t
>> size)
>>> +{
>>> +	int rc = 0;
>>> +	FILE *fd;
>>> +	size_t i;
>>> +
>>> +	fd = fopen(pathname, "w");
>>> +	if (!fd) {
>>> +		rc = errno;
>>> +		goto err;
>>> +	}
>>> +
>>> +	fprintf(fd, "/* This file is automatically generated.");
>>> +	fprintf(fd, " Do not edit. */\n");
>>> +	fprintf(fd, "#include <stddef.h>\n");
>>> +	fprintf(fd, "\nextern const char *const ipe_boot_policy;\n\n");
>>> +	fprintf(fd, "const char *const ipe_boot_policy =\n");
>>> +
>>> +	if (!buf || size == 0) {
>>> +		fprintf(fd, "\tNULL;\n");
>>> +		fclose(fd);
>>> +		return 0;
>>> +	}
>>> +
>>> +	fprintf(fd, "\t\"");
>>> +
>>> +	for (i = 0; i < size; ++i) {
>>> +		switch (buf[i]) {
>>> +		case '"':
>>> +			fprintf(fd, "\\\"");
>>> +			break;
>>> +		case '\'':
>>> +			fprintf(fd, "'");
>>> +			break;
>>> +		case '\n':
>>> +			fprintf(fd, "\\n\"\n\t\"");
>>> +			break;
>>> +		case '\\':
>>> +			fprintf(fd, "\\\\");
>>> +			break;
>>> +		case '\t':
>>> +			fprintf(fd, "\\t");
>>> +			break;
>>> +		case '\?':
>>> +			fprintf(fd, "\\?");
>>> +			break;
>>> +		default:
>>> +			fprintf(fd, "%c", buf[i]);
>>> +		}
>>> +	}
>>> +	fprintf(fd, "\";\n");
>>> +	fclose(fd);
>>> +
>>> +	return 0;
>>> +
>>> +err:
>>> +	if (fd)
>>> +		fclose(fd);
>>> +	return rc;
>>> +}
>>> +
>>> +int main(int argc, const char *const argv[])
>>> +{
>>> +	int rc = 0;
>>> +	size_t len = 0;
>>> +	char *policy = NULL;
>>> +
>>> +	if (argc < 2)
>>> +		usage(argv[0]);
>>> +
>>> +	if (argc > 2) {
>>> +		rc = policy_to_buffer(argv[2], &policy, &len);
>>> +		if (rc != 0)
>>> +			goto cleanup;
>>> +	}
>>> +
>>> +	rc = write_boot_policy(argv[1], policy, len);
>>> +cleanup:
>>> +	if (policy)
>>> +		free(policy);
>>> +	if (rc != 0)
>>> +		perror("An error occurred during policy conversion: ");
>>> +	return rc;
>>> +}
>>> diff --git a/security/ipe/.gitignore b/security/ipe/.gitignore
>>> new file mode 100644
>>> index 000000000000..eca22ad5ed22
>>> --- /dev/null
>>> +++ b/security/ipe/.gitignore
>>> @@ -0,0 +1 @@
>>> +boot-policy.c
>>> \ No newline at end of file
>>> diff --git a/security/ipe/Kconfig b/security/ipe/Kconfig
>>> index fcf82a8152ec..39df680b67a2 100644
>>> --- a/security/ipe/Kconfig
>>> +++ b/security/ipe/Kconfig
>>> @@ -20,6 +20,16 @@ menuconfig SECURITY_IPE
>>>
>>>   if SECURITY_IPE
>>>
>>> +config IPE_BOOT_POLICY
>>> +	string "Integrity policy to apply on system startup"
>>> +	help
>>> +	  This option specifies a filepath to a IPE policy that is compiled
>>> +	  into the kernel. This policy will be enforced until a policy update
>>> +	  is deployed via the $securityfs/ipe/policies/$policy_name/active
>>> +	  interface.
>>> +
>>> +	  If unsure, leave blank.
>>> +
>>>   choice
>>>   	prompt "Hash algorithm used in auditing policies"
>>>   	default IPE_AUDIT_HASH_SHA1
>>> diff --git a/security/ipe/Makefile b/security/ipe/Makefile
>>> index 1e7b2d7fcd9e..89fec670f954 100644
>>> --- a/security/ipe/Makefile
>>> +++ b/security/ipe/Makefile
>>> @@ -7,7 +7,18 @@
>>>
>>>   ccflags-y := -I$(srctree)/security/ipe/modules
>>>
>>> +quiet_cmd_polgen = IPE_POL $(2)
>>> +      cmd_polgen = scripts/ipe/polgen/polgen security/ipe/boot-policy.c $(2)
>>> +
>>> +$(eval $(call config_filename,IPE_BOOT_POLICY))
>>> +
>>> +targets += boot-policy.c
>>> +
>>> +$(obj)/boot-policy.c: scripts/ipe/polgen/polgen
>>> $(IPE_BOOT_POLICY_FILENAME) FORCE
>>> +	$(call if_changed,polgen,$(IPE_BOOT_POLICY_FILENAME))
>>> +
>>>   obj-$(CONFIG_SECURITY_IPE) += \
>>> +	boot-policy.o \
>>>   	ctx.o \
>>>   	eval.o \
>>>   	fs.o \
>>> @@ -21,3 +32,5 @@ obj-$(CONFIG_SECURITY_IPE) += \
>>>   	policyfs.o \
>>>
>>>   obj-$(CONFIG_AUDIT) += audit.o
>>> +
>>> +clean-files := boot-policy.c \
>>> diff --git a/security/ipe/ctx.c b/security/ipe/ctx.c
>>> index fc9b8e467bc9..879acf4ceac5 100644
>>> --- a/security/ipe/ctx.c
>>> +++ b/security/ipe/ctx.c
>>> @@ -15,6 +15,7 @@
>>>   #include <linux/spinlock.h>
>>>   #include <linux/moduleparam.h>
>>>
>>> +extern const char *const ipe_boot_policy;
>>>   static bool success_audit;
>>>   static bool enforce = true;
>>>
>>> @@ -329,6 +330,7 @@ void ipe_put_ctx(struct ipe_context *ctx)
>>>   int __init ipe_init_ctx(void)
>>>   {
>>>   	int rc = 0;
>>> +	struct ipe_policy *p = NULL;
>>>   	struct ipe_context *lns = NULL;
>>>
>>>   	lns = create_ctx();
>>> @@ -342,10 +344,26 @@ int __init ipe_init_ctx(void)
>>>   	WRITE_ONCE(lns->enforce, enforce);
>>>   	spin_unlock(&lns->lock);
>>>
>>> +	if (ipe_boot_policy) {
>>> +		p = ipe_new_policy(ipe_boot_policy, strlen(ipe_boot_policy),
>>> +				   NULL, 0);
>>> +		if (IS_ERR(p)) {
>>> +			rc = PTR_ERR(lns);
>> This should be:
>>
>> 	rc = PTR_ERR(p);
>>
>>> +			goto err;
>>> +		}
>>> +
>>> +		ipe_add_policy(lns, p);
>>> +		rc = ipe_set_active_pol(p);
>>> +		if (!rc)
>> Here you need to set a non-zero value, so that ipe_init()
>> does not enable the LSM.
> Actually you probably should just check that rc is not zero
> and goto err.
>
> Roberto
>
Yeah, I actually noticed these two mistakes myself fairly recently.

Changes will be applied in v8.
>
>> I would set to 1 a new global variable, like ipe_lsm_enabled,
>> in ipe_init() just before security_add_hooks().
>>
>> Then, I would add a check of this variable in ipe_init_securityfs()
>> to avoid the kernel panic.

That's my plan.

-Deven
