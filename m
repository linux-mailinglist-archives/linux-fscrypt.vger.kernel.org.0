Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B4A5463E30
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Nov 2021 19:55:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239772AbhK3S6m (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 30 Nov 2021 13:58:42 -0500
Received: from linux.microsoft.com ([13.77.154.182]:43938 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235387AbhK3S6k (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 30 Nov 2021 13:58:40 -0500
Received: from [10.137.106.139] (unknown [131.107.159.11])
        by linux.microsoft.com (Postfix) with ESMTPSA id 7526020DEE27;
        Tue, 30 Nov 2021 10:55:20 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com 7526020DEE27
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1638298520;
        bh=jdJ3O+n/LkBO98hWieh7dVs9KitCGmYhprvFZHk6PLk=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=YTILtOkEbTZwRWJmewl5mN87VA4st2CE3JZSd1WYfYEJdIZP+2VlG0gesXwp7zu93
         U4SIdob24AcRoO3d4ZbxVLSIXo1q87l8Bym8UI+NOSDnq5yuPhNCBqBjZh0AtrS7o1
         Kqk712gvF4+URWAA4SG1WmlXi3FTLbeZsZ0VmM9c=
Message-ID: <81d5e825-1ee2-8f6b-cd9d-07b0f8bd36d3@linux.microsoft.com>
Date:   Tue, 30 Nov 2021 10:55:20 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [RFC PATCH v7 11/16] ipe: add support for dm-verity as a trust
 provider
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
        "linux-integrity@vger.kernel.org" <linux-integrity@vger.kernel.org>,
        "tusharsu@linux.microsoft.com" <tusharsu@linux.microsoft.com>
References: <1634151995-16266-1-git-send-email-deven.desai@linux.microsoft.com>
 <1634151995-16266-12-git-send-email-deven.desai@linux.microsoft.com>
 <721462c3da064d359ca3c83845298ccf@huawei.com>
From:   Deven Bowers <deven.desai@linux.microsoft.com>
In-Reply-To: <721462c3da064d359ca3c83845298ccf@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


On 11/25/2021 1:37 AM, Roberto Sassu wrote:
>> From: deven.desai@linux.microsoft.com
>> [mailto:deven.desai@linux.microsoft.com]
>> Sent: Wednesday, October 13, 2021 9:07 PM
>> From: Deven Bowers <deven.desai@linux.microsoft.com>

..snip

>> diff --git a/security/ipe/modules/Makefile b/security/ipe/modules/Makefile
>> index e0045ec65434..84fadce85193 100644
>> --- a/security/ipe/modules/Makefile
>> +++ b/security/ipe/modules/Makefile
>> @@ -6,3 +6,5 @@
>>   #
>>
>>   obj-$(CONFIG_IPE_PROP_BOOT_VERIFIED) += boot_verified.o
>> +obj-$(CONFIG_IPE_PROP_DM_VERITY_SIGNATURE) += dmverity_signature.o
>> +obj-$(CONFIG_IPE_PROP_DM_VERITY_ROOTHASH) += dmverity_roothash.o
>> diff --git a/security/ipe/modules/dmverity_roothash.c
>> b/security/ipe/modules/dmverity_roothash.c
>> new file mode 100644
>> index 000000000000..0f82bec3b842
>> --- /dev/null
>> +++ b/security/ipe/modules/dmverity_roothash.c
>> @@ -0,0 +1,80 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) Microsoft Corporation. All rights reserved.
>> + */
>> +
>> +#include "ipe_module.h"
>> +
>> +#include <linux/fs.h>
>> +#include <linux/types.h>
>> +
>> +struct counted_array {
>> +	size_t	len;
>> +	u8     *data;
>> +};
>> +
>> +static int dvrh_parse(const char *valstr, void **value)
>> +{
>> +	int rv = 0;
>> +	struct counted_array *arr;
>> +
>> +	arr = kzalloc(sizeof(*arr), GFP_KERNEL);
>> +	if (!arr) {
>> +		rv = -ENOMEM;
>> +		goto err;
>> +	}
>> +
>> +	arr->len = (strlen(valstr) / 2);
>> +
>> +	arr->data = kzalloc(arr->len, GFP_KERNEL);
>> +	if (!arr->data) {
>> +		rv = -ENOMEM;
>> +		goto err;
>> +	}
>> +
>> +	rv = hex2bin(arr->data, valstr, arr->len);
>> +	if (rv != 0)
>> +		goto err2;
>> +
>> +	*value = arr;
>> +	return rv;
>> +err2:
>> +	kfree(arr->data);
>> +err:
>> +	kfree(arr);
>> +	return rv;
>> +}
>> +
>> +static bool dvrh_eval(const struct ipe_eval_ctx *ctx, const void *val)
>> +{
>> +	const u8 *src;
>> +	struct counted_array *expect = (struct counted_array *)val;
>> +
>> +	if (!ctx->ipe_bdev)
>> +		return false;
>> +
>> +	if (ctx->ipe_bdev->hashlen != expect->len)
>> +		return false;
>> +
>> +	src = ctx->ipe_bdev->hash;
>> +
>> +	return !memcmp(expect->data, src, expect->len);
> Hi Deven
>
> I was curious to see if determining the property at run-time
> could apply also to dm-verity. It seems it could be done
> (I omit some checks, I also keep the expected value in hex
> format):
>
> ---
>          md = dm_get_md(file_inode(ctx->file)->i_sb->s_dev);
>          table = dm_get_live_table(md, &srcu_idx);
>          num_targets = dm_table_get_num_targets(table);
>
>          for (i = 0; i < num_targets; i++) {
>                  struct dm_target *ti = dm_table_get_target(table, i);
>
>                  if (strcmp(ti->type->name, "verity"))
>                          continue;
>
>                  ti->type->status(ti, STATUSTYPE_IMA, 0, result, sizeof(result));
>          }
>
>          dm_put_live_table(md, srcu_idx);
>          dm_put(md);
>
>          root_digest_ptr = strstr(result, "root_digest=");
>          return !strncmp(expect->data, root_digest_ptr + 12, expect->len);
> ---
>
> Only dm_table_get_target() is not exported yet, but I guess it could
> be. dm_table_get_num_targets() is exported.

I had tried something similar in a very early draft of IPE. The issue
that comes with this is that when you compile device-mapper as a module
(CONFIG_BLK_DEV_DM=m) you start to get linking errors with this
approach.

Obviously, we can fix this in the IPE's module Kconfig by setting the
dependency to be =y, but it's something to highlight. My general
preference is to support the =m configuration by using these blobs.

The runtime approach does work with fs-verity, because fs-verity is a
file-system level feature that cannot be compiled as a module.

> With this code, you would not have to manage security blobs
> outside IPE. Maybe you could add a blob for the super block, so
> that you verify the dm-verity property just once per filesystem.
>
> Roberto
>
> HUAWEI TECHNOLOGIES Duesseldorf GmbH, HRB 56063
> Managing Director: Li Peng, Zhong Ronghua
>
>> +}
>> +
>> +static int dvrh_free(void **val)
>> +{
>> +	struct counted_array *expect = (struct counted_array *)val;
>> +
>> +	kfree(expect->data);
>> +	kfree(expect);
>> +
>> +	return 0;
>> +}
>> +
>> +IPE_MODULE(dvrh) = {
>> +	.name = "dmverity_roothash",
>> +	.version = 1,
>> +	.parse = dvrh_parse,
>> +	.free = dvrh_free,
>> +	.eval = dvrh_eval,
>> +};
>> diff --git a/security/ipe/modules/dmverity_signature.c
>> b/security/ipe/modules/dmverity_signature.c
>> new file mode 100644
>> index 000000000000..08746fcbcb3e
>> --- /dev/null
>> +++ b/security/ipe/modules/dmverity_signature.c
>> @@ -0,0 +1,25 @@
>> +// SPDX-License-Identifier: GPL-2.0
>> +/*
>> + * Copyright (C) Microsoft Corporation. All rights reserved.
>> + */
>> +
>> +#include "ipe_module.h"
>> +
>> +#include <linux/fs.h>
>> +#include <linux/types.h>
>> +
>> +static bool dvv_eval(const struct ipe_eval_ctx *ctx, const void *val)
>> +{
>> +	bool expect = (bool)val;
>> +	bool eval = ctx->ipe_bdev && (!!ctx->ipe_bdev->sigdata);
>> +
>> +	return expect == eval;
>> +}
>> +
>> +IPE_MODULE(dvv) = {
>> +	.name = "dmverity_signature",
>> +	.version = 1,
>> +	.parse = ipe_bool_parse,
>> +	.free = NULL,
>> +	.eval = dvv_eval,
>> +};
>> --
>> 2.33.0
