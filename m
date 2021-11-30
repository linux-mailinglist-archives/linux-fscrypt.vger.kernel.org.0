Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A841B462C36
	for <lists+linux-fscrypt@lfdr.de>; Tue, 30 Nov 2021 06:33:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238323AbhK3Fgt (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 30 Nov 2021 00:36:49 -0500
Received: from linux.microsoft.com ([13.77.154.182]:46422 "EHLO
        linux.microsoft.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230163AbhK3Fgs (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 30 Nov 2021 00:36:48 -0500
Received: from [10.137.112.111] (unknown [131.107.147.111])
        by linux.microsoft.com (Postfix) with ESMTPSA id E2F0B20DEED2;
        Mon, 29 Nov 2021 21:33:29 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 linux.microsoft.com E2F0B20DEED2
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.microsoft.com;
        s=default; t=1638250410;
        bh=Ka0mPJgYWmiDnzwsdqmRMIk4RJt332upLQtsgsCn/dc=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=DovVDIeZ3Wk5BWgvAvkCFlTP8xh0m4/KwjRKzNT4UxmUoMb2HGiKFwl23OmtgG64p
         dcuIW/1LucLBJ+M5s70CVF0Ei9Ctthc0h7PgLAampsdeRfK0KaEbt5pVgnHFigvWJJ
         LpSZ1pMQoiwVz9ZInscmql2LI9ohi6qHkLpek2XM=
Message-ID: <53ee68b8-e3fe-887c-89d3-a327c8dc181f@linux.microsoft.com>
Date:   Mon, 29 Nov 2021 21:33:29 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH 1/4] fs-verity: define a function to return the integrity
 protected file digest
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>,
        Mimi Zohar <zohar@linux.ibm.com>
Cc:     linux-integrity@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20211129170057.243127-1-zohar@linux.ibm.com>
 <20211129170057.243127-2-zohar@linux.ibm.com>
 <YaWKJEqD6G23uG/A@sol.localdomain>
From:   Lakshmi Ramasubramanian <nramas@linux.microsoft.com>
In-Reply-To: <YaWKJEqD6G23uG/A@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi Mimi,

On 11/29/2021 6:19 PM, Eric Biggers wrote:
> Generally looks fine.  A few nits below:
> 
> On Mon, Nov 29, 2021 at 12:00:54PM -0500, Mimi Zohar wrote:
>> Define a function named fsverity_measure() to return the verity file digest
>> and the associated hash algorithm (enum hash_algo).
>>
>> Signed-off-by: Mimi Zohar <zohar@linux.ibm.com>
>> ---
>>   fs/verity/fsverity_private.h |  6 -----
>>   fs/verity/measure.c          | 49 ++++++++++++++++++++++++++++++++++++
>>   include/linux/fsverity.h     | 17 +++++++++++++
>>   3 files changed, 66 insertions(+), 6 deletions(-)
>>
>> diff --git a/fs/verity/fsverity_private.h b/fs/verity/fsverity_private.h
>> index a7920434bae5..54c5f0993541 100644
>> --- a/fs/verity/fsverity_private.h
>> +++ b/fs/verity/fsverity_private.h
>> @@ -26,12 +26,6 @@ struct ahash_request;
>>    */
>>   #define FS_VERITY_MAX_LEVELS		8
>>   
>> -/*
>> - * Largest digest size among all hash algorithms supported by fs-verity.
>> - * Currently assumed to be <= size of fsverity_descriptor::root_hash.
>> - */
>> -#define FS_VERITY_MAX_DIGEST_SIZE	SHA512_DIGEST_SIZE
> 
> The include of sha2.h should be removed from this file.
> 
>> +/**
>> + * fsverity_measure() - get a verity file's digest
nit: The function name seems to suggest it is measuring the fs-verity 
file's digest. Since it is reading the file's digest: 
fsverity_read_digest() or fsverity_read_measure()?

  -lakshmi

>> + * @inode: inode to get digest of
>> + * @digest: pointer to the digest
>> + * @alg: pointer to the hash algorithm enumeration
> 
> It should be made clear that @digest and @alg are output, for example:
> 
>   * @digest: (out) pointer to the digest
>   * @alg: (out) pointer to the hash algorithm enumeration
> 
>> + * Return the file hash algorithm, digest size, and digest of an fsverity
>> + * protected file.
> 
> The digest size is implied, not returned.
> 
>> +
>> +		if (!strcmp(hash_alg->name, hash_algo_name[i])) {
> 
> As the kernel test robot pointed out, this creates a dependency on
> CRYPTO_HASH_INFO.  So FS_VERITY will need to select CRYPTO_HASH_INFO.
> 
> - Eric
> 
