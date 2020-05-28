Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E74F1E6219
	for <lists+linux-fscrypt@lfdr.de>; Thu, 28 May 2020 15:23:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390338AbgE1NXI (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Thu, 28 May 2020 09:23:08 -0400
Received: from sender11-op-o11.zoho.eu ([31.186.226.225]:17110 "EHLO
        sender11-op-o11.zoho.eu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390329AbgE1NXH (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Thu, 28 May 2020 09:23:07 -0400
ARC-Seal: i=1; a=rsa-sha256; t=1590672176; cv=none; 
        d=zohomail.eu; s=zohoarc; 
        b=DxI8YpEk+98qpz7z81QYTKoDI4oZL8nL99DWyn5aytF3eKuKZnZ4WGueBGw0vY4wIVQcnRdj8vasASKOi9Y8f72Yemm0Dx+uauWs5+dekUBRr3jp5nRT+lHqy9M50Y+WrP0OoC4BkLef6oD1zhrT1aeZWcflThqMx0SLTw86TvM=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.eu; s=zohoarc; 
        t=1590672176; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=J/sOEUxkp7d/Mtk2b6oQUl19z1UIBLKXFXCNEaw9pck=; 
        b=BkSDvXTo4vCHxiu4qFgtpcAqnVMshaDIyBB6LBpbFF3O2JW7gspsw0sUyq8+bALgm4494s2J2qpJKtlojWgZ2jb621oJJsE9LYLqQxIwUapB7RDZR7umH7lAVf2BUHfzopV9a5Dtvwg2ClpqALPIpJINJ26gxxHXFZOitEqd3mo=
ARC-Authentication-Results: i=1; mx.zohomail.eu;
        spf=pass  smtp.mailfrom=jes@trained-monkey.org;
        dmarc=pass header.from=<jes@trained-monkey.org> header.from=<jes@trained-monkey.org>
Received: from [100.109.20.165] (163.114.130.7 [163.114.130.7]) by mx.zoho.eu
        with SMTPS id 1590672174877637.9003238341555; Thu, 28 May 2020 15:22:54 +0200 (CEST)
Subject: Re: [PATCH v2 0/3] fsverity-utils: introduce libfsverity
To:     Eric Biggers <ebiggers@kernel.org>, linux-fscrypt@vger.kernel.org,
        Jes Sorensen <jes.sorensen@gmail.com>
Cc:     jsorensen@fb.com, kernel-team@fb.com
References: <20200525205432.310304-1-ebiggers@kernel.org>
 <20200527211544.GA14135@sol.localdomain>
From:   Jes Sorensen <jes@trained-monkey.org>
Message-ID: <6c829c1c-9197-122f-885c-20157b2b4c22@trained-monkey.org>
Date:   Thu, 28 May 2020 09:22:53 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200527211544.GA14135@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ZohoMailClient: External
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 5/27/20 5:15 PM, Eric Biggers wrote:
> On Mon, May 25, 2020 at 01:54:29PM -0700, Eric Biggers wrote:
>> From the 'fsverity' program, split out a library 'libfsverity'.
>> Currently it supports computing file measurements ("digests"), and
>> signing those file measurements for use with the fs-verity builtin
>> signature verification feature.
>>
>> Rewritten from patches by Jes Sorensen <jsorensen@fb.com>.
>> I made a lot of improvements; see patch 2 for details.
>>
>> This patchset can also be found at branch "libfsverity" of
>> https://git.kernel.org/pub/scm/linux/kernel/git/ebiggers/fsverity-utils.git/
>>
>> Changes v1 => v2:
>>   - Fold in the Makefile fixes from Jes
>>   - Rename libfsverity_digest_size() and libfsverity_hash_name()
>>   - Improve the documentation slightly
>>   - If a memory allocation fails, print the allocation size
>>   - Use EBADMSG for invalid cert or keyfile, not EINVAL
>>   - Make libfsverity_find_hash_alg_by_name() handle NULL
>>   - Avoid introducing compiler warnings with AOSP's default cflags
>>   - Don't assume that BIO_new_file() sets errno
>>   - Other small cleanups
>>
>> Eric Biggers (3):
>>   Split up cmd_sign.c
>>   Introduce libfsverity
>>   Add some basic test programs for libfsverity
>>
> 
> Applied and pushed out to the 'master' branch.

Awesome, any idea when you'll be able to tag a new official release?

Thanks,
Jes

