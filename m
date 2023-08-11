Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 61B2E7794E0
	for <lists+linux-fscrypt@lfdr.de>; Fri, 11 Aug 2023 18:39:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235842AbjHKQjg (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Fri, 11 Aug 2023 12:39:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235840AbjHKQjd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Fri, 11 Aug 2023 12:39:33 -0400
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EEB352696;
        Fri, 11 Aug 2023 09:39:31 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 7F9118032F;
        Fri, 11 Aug 2023 12:39:30 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1691771971; bh=vtDDRR1tlvbLdscaG4vBP2onznrL2ewWFiHHoxkN+Ys=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=m7Z/VOJNpnphxJPqry8F3Obuqx2cYDym8n6ImGMsFKzX6f5ygK+EvkiCY0wbrzmCH
         eHaL41BzD09xhNkIcxjuppqrqcDZAhCGGJlY/lIMnxq+IIAwVUWdlPCf6eVd53IdY/
         lw6JWAdmxBvy1XZ0KafoUlJoCaFumYjDtBsjtCdKXzG+86jEs7pY3Hqmyz6UsxoSth
         KGdl0ZIY67MeboTSbTDuoUOzwm1CA7rF/oh7mLQIBD3e9O/p5HHauO19tG7RR4kIVl
         BjU1TXSInsKpCOVIW3NRPLi16e9m9vmG+Xl+JcfUFo5mNtZOR8Q76fD/5gxJ5w1eva
         ujShGl1u05vwQ==
Message-ID: <24ae5aa5-98e7-1800-1226-3c2cfa3d8101@dorminy.me>
Date:   Fri, 11 Aug 2023 12:39:26 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v3 13/16] fscrypt: allow multiple extents to reference one
 info
Content-Language: en-US
To:     =?UTF-8?Q?Lu=c3=ads_Henriques?= <lhenriques@suse.de>
Cc:     Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
        David Sterba <dsterba@suse.com>,
        "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel-team@meta.com,
        linux-btrfs@vger.kernel.org, linux-fscrypt@vger.kernel.org,
        Eric Biggers <ebiggers@kernel.org>
References: <cover.1691505882.git.sweettea-kernel@dorminy.me>
 <2fc070a3990716077dee122740f21abcea8121a8.1691505882.git.sweettea-kernel@dorminy.me>
 <87edkagakc.fsf@suse.de>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <87edkagakc.fsf@suse.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=1.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_BLOCKED,
        RCVD_IN_SBL_CSS,SPF_HELO_PASS,SPF_PASS,URIBL_BLOCKED autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Level: *
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 8/10/23 11:51, Luís Henriques wrote:
> Sweet Tea Dorminy <sweettea-kernel@dorminy.me> writes:
> 
>> btrfs occasionally splits in-memory extents while holding a mutex. This
>> means we can't just copy the info, since setting up a new inlinecrypt
>> key requires taking a semaphore. Thus adding a mechanism to split
>> extents and merely take a new reference on the info is necessary.
>>
>> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>> ---
>>   fs/crypto/fscrypt_private.h |  5 +++++
>>   fs/crypto/keysetup.c        | 18 +++++++++++++++++-
>>   include/linux/fscrypt.h     |  2 ++
>>   3 files changed, 24 insertions(+), 1 deletion(-)
>>
>> diff --git a/fs/crypto/fscrypt_private.h b/fs/crypto/fscrypt_private.h
>> index cd29c71b4349..03be2c136c0e 100644
>> --- a/fs/crypto/fscrypt_private.h
>> +++ b/fs/crypto/fscrypt_private.h
>> @@ -287,6 +287,11 @@ struct fscrypt_info {
>>   
>>   	/* Hashed inode number.  Only set for IV_INO_LBLK_32 */
>>   	u32 ci_hashed_ino;
>> +
>> +	/* Reference count. Normally 1, unless a extent info is shared by
>> +	 * several virtual extents.
>> +	 */
>> +	refcount_t refs;
>>   };
>>   
>>   typedef enum {
>> diff --git a/fs/crypto/keysetup.c b/fs/crypto/keysetup.c
>> index 8d50716bdf11..12c3851b7cd6 100644
>> --- a/fs/crypto/keysetup.c
>> +++ b/fs/crypto/keysetup.c
>> @@ -598,7 +598,7 @@ static void put_crypt_info(struct fscrypt_info *ci)
>>   {
>>   	struct fscrypt_master_key *mk;
>>   
>> -	if (!ci)
>> +	if (!ci || !refcount_dec_and_test(&ci->refs))
>>   		return;
>>   
>>   	if (ci->ci_enc_key) {
>> @@ -686,6 +686,7 @@ fscrypt_setup_encryption_info(struct inode *inode,
>>   	crypt_info->ci_inode = inode;
>>   	crypt_info->ci_sb = inode->i_sb;
>>   	crypt_info->ci_policy = *policy;
>> +	refcount_set(&crypt_info->refs, 1);
>>   	memcpy(crypt_info->ci_nonce, nonce, FSCRYPT_FILE_NONCE_SIZE);
>>   
>>   	mode = select_encryption_mode(&crypt_info->ci_policy, inode);
>> @@ -1046,6 +1047,21 @@ int fscrypt_load_extent_info(struct inode *inode, void *buf, size_t len,
>>   }
>>   EXPORT_SYMBOL_GPL(fscrypt_load_extent_info);
>>   
>> +/**
>> + * fscrypt_get_extent_info_ref() - mark a second extent using the same info
>> + * @info: the info to be used by another extent
>> + *
>> + * Sometimes, an existing extent must be split into multiple extents in memory.
>> + * In such a case, this function allows multiple extents to use the same extent
>> + * info without allocating or taking any lock, which is necessary in certain IO
>> + * paths.
>> + */
>> +void fscrypt_get_extent_info_ref(struct fscrypt_info *info)
>> +{
>> +	if (info)
>> +		refcount_inc(&info->refs);
>> +}
>> +
> 
> There's an EXPORT_SYMBOL_GPL() missing here, right?
> 
> Cheers,

Oof, guess I need to add 'build btrfs as a module' to my preflight 
checklist. Thank you.
