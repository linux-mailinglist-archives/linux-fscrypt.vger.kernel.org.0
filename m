Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 11D846DE15D
	for <lists+linux-fscrypt@lfdr.de>; Tue, 11 Apr 2023 18:46:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229835AbjDKQqX (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 11 Apr 2023 12:46:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbjDKQqT (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 11 Apr 2023 12:46:19 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 706535278
        for <linux-fscrypt@vger.kernel.org>; Tue, 11 Apr 2023 09:46:03 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id E5E2580551;
        Tue, 11 Apr 2023 12:45:29 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1681231531; bh=3xFDj8qH+Eo/xUGmv8rdoZ+R1NC1wpTPUEQm4pVj8tQ=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=expihCldMsDgt5tLwI9Cfkr30SAS5wNPpBKdWPVpQlmoWUVnyp+0z7jw23W1iiPQY
         XpL8zTeeXZtDRkNSMK7l1gfaHSFNahM0WrLq1jGGG7oAfnTAhBNmS5wfcsSP8qqJIf
         1/r1UNh4b0/smtD2TYFrXYzKuSyFQRAw8VjtAsVxYyXHT89Y0UECVNxKsqefIHnZ8z
         GktoC2EUcjjrUrwFiWcLM2MbS4Im+TATP9Q8EXpV/xxldr66LdGTblk7fUrz7EnYn3
         32qk68ydkf1eI4S3LkO50bxnDm2AuM2AHGhTdLHMlo5AS5ANnHqY7891ECwasicyxT
         bpdcmqTJDratA==
Message-ID: <0e3d9d01-f185-f6db-792f-a268cc2e04df@dorminy.me>
Date:   Tue, 11 Apr 2023 12:45:28 -0400
MIME-Version: 1.0
Subject: Re: [PATCH v2 10/11] fscrypt: explicitly track prepared parts of key
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, kernel-team@meta.com
References: <cover.1681155143.git.sweettea-kernel@dorminy.me>
 <2a9bf42af2b2ac6289d0ac886d1f07042feafbe5.1681155143.git.sweettea-kernel@dorminy.me>
 <20230411040551.GI47625@sol.localdomain>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <20230411040551.GI47625@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 4/11/23 00:05, Eric Biggers wrote:
> On Mon, Apr 10, 2023 at 03:40:03PM -0400, Sweet Tea Dorminy wrote:
>> So far, it has sufficed to allocate and prepare the block key or the TFM
>> completely before ever setting the relevant field in the prepared key.
>> This is necessary for mode keys -- because multiple inodes could be
>> trying to set up the same per-mode prepared key at the same time on
>> different threads, we currently must not set the prepared key's tfm or
>> block key pointer until that key is completely set up. Otherwise,
>> another inode could see the key to be present and attempt to use it
>> before it is fully set up.
>>
>> But when using pooled prepared keys, we'll have pre-allocated fields,
>> and if we separate allocating the fields of a prepared key from
>> preparing the fields, that inherently sets the fields before they're
>> ready to use. So, either pooled prepared keys must use different
>> allocation and setup functions, or we can split allocation and
>> preparation for all prepared keys and use some other mechanism to signal
>> that the key is fully prepared.
>>
>> In order to avoid having similar yet different functions, this function
>> adds a new field to the prepared key to explicitly track which parts of
>> it are prepared, setting it explicitly. The same acquire/release
>> semantics are used to check it in the case of shared mode keys; the cost
>> lies in the extra byte per prepared key recording which members are
>> fully prepared.
>>
>> Signed-off-by: Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
>> ---
>>   fs/crypto/fscrypt_private.h | 26 +++++++++++++++-----------
>>   fs/crypto/inline_crypt.c    |  8 +-------
>>   fs/crypto/keysetup.c        | 36 ++++++++++++++++++++++++++----------
>>   3 files changed, 42 insertions(+), 28 deletions(-)
> 
> I wonder if this is overcomplicating things and we should simply add a new
> rw_semaphore to struct fscrypt_master_key and use it to protect the per-mode key
> preparation, instead of trying to keep the fast path lockless?
> 
> So the flow (for setting up a file that uses a per-mode key) would look like:
> 
>          down_read(&mk->mk_mode_key_prep_sem);
>          if key already prepared, unlock and return
>          up_read(&mk->mk_mode_key_prep_sem);
> 
>          down_write(&mk->mk_mode_key_prep_sem);
>          if key already prepared, unlock and return
>          prepare the key
>          up_write(&mk->mk_mode_key_prep_sem);
> 
> Lockless algorithms are nice, but we shouldn't take them too far if they cause
> too much trouble...

You're noting that we only really need preparedness for per-mode keys, 
and that's a point I didn't explicitly grasp before; everywhere else we 
know whether it's merely allocated or fully prepared. Two other thoughts 
on ways we could pull the preparedness out of fscrypt_prepared_key and 
still keep locklessness:

fscrypt_master_key could setup both block key and tfm (if block key is 
applicable) when it sets up a prepared key, so we can use just one bit 
of preparedness information, and keep a bitmap recording which prepared 
keys are ready in fscrypt_master_key.

Or we could have
struct fscrypt_master_key_prepared_key {
	u8 preparedness;
	struct fscrypt_prepared_key prep_key;
}
and similarly isolate the preparedness tracking from per-file keys.

Do either of those sound appealing as alternatives to the semaphore?
