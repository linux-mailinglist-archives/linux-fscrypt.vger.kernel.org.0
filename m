Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A919D65B8C5
	for <lists+linux-fscrypt@lfdr.de>; Tue,  3 Jan 2023 02:23:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbjACBXb (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 2 Jan 2023 20:23:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230080AbjACBXa (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 2 Jan 2023 20:23:30 -0500
Received: from box.fidei.email (box.fidei.email [IPv6:2605:2700:0:2:a800:ff:feba:dc44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC3E921A1;
        Mon,  2 Jan 2023 17:23:28 -0800 (PST)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 187C482636;
        Mon,  2 Jan 2023 20:23:27 -0500 (EST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1672709008; bh=KVxPR6pQvc0IPDNN2mlXrJzsVBC1nnN4xFfIEhenVN8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=JhDZHIDTjruRn1pe3pcy2UhI8mFouMl5YgGY1rrgCFvi7I2uU0mt2cbWTUfnKecAn
         Sx9bTnKYjmRFkkLKTq9igPEVCXnHlm9654bFfU+A9iIkVyE7HVUW2AuiFA2k9rHF5F
         ZYl7nt938+HG0QDHwhwiwPW8KTMuCVK/JVCRW6l5xg9MKieCakzAU8hR0eahfftgt3
         hulj3lMpzlXAN9ozh1jfnVUOSFGKNfYGrfnw2/Lg3WgGGkfBVV00TaXVnPZfd4mL9/
         NCrgNU3jItcMRjR/EvFHwwbHxztjvyc8AcDRyoPgdGY63FJv/2QGC7SVwTz85/3gyC
         KtKYZ+UT44gqw==
Message-ID: <5433bb39-3d59-8b96-0be3-a32953ef79af@dorminy.me>
Date:   Mon, 2 Jan 2023 20:23:26 -0500
MIME-Version: 1.0
Subject: Re: [RFC PATCH 15/17] fscrypt: allow load/save of extent contexts
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     linux-fscrypt@vger.kernel.org, paulcrowley@google.com,
        linux-btrfs@vger.kernel.org, kernel-team@meta.com
References: <cover.1672547582.git.sweettea-kernel@dorminy.me>
 <fd5c7a78de125737abe447370fe37f9fe90155d6.1672547582.git.sweettea-kernel@dorminy.me>
 <Y7NQ1CvPyJiGRe00@sol.localdomain>
 <686e2eb9-b218-6b23-472c-b6035bd2186b@dorminy.me>
 <Y7NgCKPnVybgBaq/@sol.localdomain>
 <66385ee9-3e11-f5a6-259d-ae504ab6dfaa@dorminy.me>
 <Y7N7KCCqYZPwjOGX@sol.localdomain>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <Y7N7KCCqYZPwjOGX@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org



On 1/2/23 19:47, Eric Biggers wrote:
> On Mon, Jan 02, 2023 at 07:33:15PM -0500, Sweet Tea Dorminy wrote:
>>
>>>
>>> Anyway, crypto_alloc_skcipher() takes a lock (crypto_alg_sem) under which memory
>>> is allocated with GFP_KERNEL.  So neither preloading kernel modules nor
>>> memalloc_nofs_save() helps for it; it's still not GFP_NOFS-safe.
>>
>> I'm still confused. My understanding is that memalloc_nofs_save() means all
>> allocations on that thread until memalloc_nofs_restore() is called
>> effectively gets GFP_NOFS appended to the allocation flags. So since
>> crypto_alloc_skcipher()'s allocation appears to be on the same thread as
>> we'd be calling memalloc_nofs_save/restore(), it would presumably get
>> allocated as though it had flags GFP_KERNEL | GFP_NOFS, even though the call
>> is kzalloc(..., GFP_KERNEL, ...).
>>
>> I don't understand how the lock would make a difference. Can you elaborate?
>>
>> Sorry for my confusion...
> 
> Other tasks (using the crypto API for another purpose, perhaps totally unrelated
> to fs/crypto/) can take crypto_alg_sem without taking the same precaution.  So,
> when your task that is running in fs-reclaim context and has used
> memalloc_nofs_save() tries to take the same lock, it might be that the lock is
> already held by another thread that is waiting for fs-reclaim to complete in
> order to satisfy a GFP_KERNEL allocation.
> 
> That's a deadlock.
> 
> Locks are only GFP_NOFS-safe when everyone agrees to use them that way.
> 
> - Eric

Ah that is definitely what I was missing, I've never had to think about 
that interaction. Thank you for explaining!
