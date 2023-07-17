Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DFEDD755920
	for <lists+linux-fscrypt@lfdr.de>; Mon, 17 Jul 2023 03:43:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229959AbjGQBnp (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Sun, 16 Jul 2023 21:43:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229461AbjGQBnn (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Sun, 16 Jul 2023 21:43:43 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30B7BE51;
        Sun, 16 Jul 2023 18:43:42 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 7DAC480508;
        Sun, 16 Jul 2023 21:43:40 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1689558222; bh=z06Jmfp6cwsSLCgIn6MUCCgZS0wHR/ZKSeFohmJUC1w=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=BWnuQetVrAm/L5ajnqapCg4pjmQUFEQNs1xqr/UPRniXSA1Z8VTQt5YKbttJZXmEM
         CWYW/4Dc0rab9q7/MiHNR5x3sKKMY70GkrD7gOzTr3BvK9ceS2cW8jm3v1pFXKYdry
         24LXxxetCJG7Uz6DAb1mVUc8y3Agqi2WHO2L0HrPCpUrG5wcs+i1tY4UUFl5+JB6pS
         QNAsPYm6rgw+Q2VnxXsuKr1kfflRqDKu4egSiJCobmucdh3qWif45eKOeGcCVH32II
         KiawF3Cs4tYiDemBRGpIzFup6VL9mQHzV1yphKW/rXh49yTbhvtHBYqG0BwLaB+m5q
         HAsKFk9IEJA+Q==
Message-ID: <09d05271-3b4d-dcaa-bac6-b8fbde02a948@dorminy.me>
Date:   Sun, 16 Jul 2023 21:43:39 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v1 05/17] btrfs: add inode encryption contexts
Content-Language: en-US
To:     Boris Burkov <boris@bur.io>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        Eric Biggers <ebiggers@kernel.org>,
        "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Omar Sandoval <osandov@osandov.com>
References: <cover.1687988380.git.sweettea-kernel@dorminy.me>
 <a4e0968259ca4843e0684f7801fd5359ed74f7c6.1687988380.git.sweettea-kernel@dorminy.me>
 <20230707233256.GA2579580@zen>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <20230707233256.GA2579580@zen>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 7/7/23 19:32, Boris Burkov wrote:
> On Wed, Jun 28, 2023 at 08:35:28PM -0400, Sweet Tea Dorminy wrote:
>> From: Omar Sandoval <osandov@osandov.com>
>>
>> In order to store encryption information for directories, symlinks,
>> etc., fscrypt stores a context item with each encrypted non-regular
>> inode. fscrypt provides an arbitrary blob for the filesystem to store,
>> and it does not clearly fit into an existing structure, so this goes in
>> a new item type.
>>
>> Signed-off-by: Omar Sandoval <osandov@osandov.com>
>> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>> ---
>>   fs/btrfs/fscrypt.c              | 116 ++++++++++++++++++++++++++++++++
>>   fs/btrfs/fscrypt.h              |   2 +
>>   fs/btrfs/inode.c                |  19 ++++++
>>   fs/btrfs/ioctl.c                |   8 ++-
>>   include/uapi/linux/btrfs_tree.h |  10 +++
>>   5 files changed, 153 insertions(+), 2 deletions(-)
>>
>> diff --git a/fs/btrfs/fscrypt.c b/fs/btrfs/fscrypt.c
>> index 3a53dc59c1e4..235f65e43d96 100644
>> --- a/fs/btrfs/fscrypt.c
>> +++ b/fs/btrfs/fscrypt.c
>> @@ -1,8 +1,124 @@
>>   // SPDX-License-Identifier: GPL-2.0
>>   
>> +#include <linux/iversion.h>
>>   #include "ctree.h"
>> +#include "accessors.h"
>> +#include "btrfs_inode.h"
>> +#include "disk-io.h"
>> +#include "fs.h"
>>   #include "fscrypt.h"
>> +#include "ioctl.h"
>> +#include "messages.h"
>> +#include "transaction.h"
>> +#include "xattr.h"
>> +
>> +static int btrfs_fscrypt_get_context(struct inode *inode, void *ctx, size_t len)
>> +{
>> +	struct btrfs_key key = {
>> +		.objectid = btrfs_ino(BTRFS_I(inode)),
>> +		.type = BTRFS_FSCRYPT_CTXT_ITEM_KEY,
>> +		.offset = 0,
>> +	};
>> +	struct btrfs_path *path;
>> +	struct extent_buffer *leaf;
>> +	unsigned long ptr;
>> +	int ret;
>> +
>> +
>> +	path = btrfs_alloc_path();
>> +	if (!path)
>> +		return -ENOMEM;
>> +
>> +	ret = btrfs_search_slot(NULL, BTRFS_I(inode)->root, &key, path, 0, 0);
>> +	if (ret) {
>> +		len = -EINVAL;
> 
> I'm a little wary about squishing the errors down like this. It could
> be some error, in which case it might be interesting to get the real errno
> or it could be ret > 1, in which case I think ENOENT is more useful than
> EINVAL.

I'll make it ENOENT.

> Also, having a ret variable and mashing that into len feels kinda weird.
> Maybe that's the neatest way to write this logic, though.

It's the way the existing fscrypt interface does things, so it'd be hard 
to change.

> 
> Since the variables usually go by ctx, I lightly prefer CTX_ITEM_KEY.
> Obviously not a big deal.
Sure, will do.
