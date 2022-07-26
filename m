Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E940A580951
	for <lists+linux-fscrypt@lfdr.de>; Tue, 26 Jul 2022 04:13:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236121AbiGZCNT (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 25 Jul 2022 22:13:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236428AbiGZCNS (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 25 Jul 2022 22:13:18 -0400
Received: from box.fidei.email (box.fidei.email [71.19.144.250])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C29DD28E21;
        Mon, 25 Jul 2022 19:13:16 -0700 (PDT)
Received: from authenticated-user (box.fidei.email [71.19.144.250])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        by box.fidei.email (Postfix) with ESMTPSA id 939A580856;
        Mon, 25 Jul 2022 22:13:14 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dorminy.me; s=mail;
        t=1658801596; bh=ptXxAfZgAszQC6rVofIN+8stpKgcYrpCGjXOeETcBxI=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=sY8+uTyYkmYgw5vXe18+OY5dPxTlS5lsMHmeATXw7zDP6bbTOuH6lqbVq5WQPGAFx
         0H7tYofi+pWTxWq2edyUpvCgy57Q/E3jhVoiC8KDahGKp3XSGib55KK3xgRoIZPOIR
         s83TFrzKd7lszUOB/TtvCnSio0k8SMM7E7Gr5bUOvgDCZetwC51u7vzFmATtW98XQn
         CnFCk0BOpRWBmaQJBPR+NIqKDkBDHgrx7pAceAjaVLM/Qgcdzpqb2AU62lb241KVdG
         zPetzFUaTQretRex1i+9uEz/warkPbb6shtOoHmbwyvwSWY6ujYldn+cjJKbHeCpd1
         Akk0HuSyb+aaQ==
Message-ID: <7b35f666-b474-9628-1cc4-7b8fc35e5074@dorminy.me>
Date:   Mon, 25 Jul 2022 22:13:12 -0400
MIME-Version: 1.0
Subject: Re: [PATCH RFC 2/4] fscrypt: add flag allowing partially-encrypted
 directories
Content-Language: en-US
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y . Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        linux-fscrypt@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-btrfs@vger.kernel.org, osandov@osandov.com,
        kernel-team@fb.com
References: <cover.1658623235.git.sweettea-kernel@dorminy.me>
 <0508dac7fd6ec817007c5e21a565d1bb9d4f4921.1658623235.git.sweettea-kernel@dorminy.me>
 <Yt7zsMGrxwKiM+GH@sol.localdomain>
From:   Sweet Tea Dorminy <sweettea-kernel@dorminy.me>
In-Reply-To: <Yt7zsMGrxwKiM+GH@sol.localdomain>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.7 required=5.0 tests=BAYES_00,DKIM_INVALID,
        DKIM_SIGNED,SPF_HELO_PASS,SPF_PASS autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org


>> diff --git a/include/linux/fscrypt.h b/include/linux/fscrypt.h
>> index 6020b738c3b2..fb48961c46f6 100644
>> --- a/include/linux/fscrypt.h
>> +++ b/include/linux/fscrypt.h
>> @@ -102,6 +102,8 @@ struct fscrypt_nokey_name {
>>    * pages for writes and therefore won't need the fscrypt bounce page pool.
>>    */
>>   #define FS_CFLG_OWN_PAGES (1U << 1)
>> +/* The filesystem allows partially encrypted directories/files. */
>> +#define FS_CFLG_ALLOW_PARTIAL (1U << 2)
> 
> I'm very confused about what the semantics of this are.  So a directory will be
> able to contain both encrypted and unencrypted filenames?  If so, how will it be
> possible to distinguish between them? Or is it just both encrypted and
> unencrypted files (which is actually already possible, in the case where
> encrypted files are moved into an unencrypted directory)?  What sort of metadata
> is stored with the parent directory?
Yes, a directory for a filesystem with this flag could have both 
encrypted and unencrypted filenames.

When a directory switches to encrypted, the filesystem can get and store 
a fscrypt_context for it, as though it were a new directory. All new 
filenames for that directory will be encrypted, as will any filename 
lookup requests, by fscrypt_prepare_filename() since the directory has a 
context.

When a request for a lookup of a name in that directory comes in, it'll 
be an encrypted or nokey name; the directory can be searched for both 
the encrypted and unencrypted versions of that name. I don't think any 
filename collisions can result, as any encrypted filename which happens 
to match a plaintext filename will be detected as a collision when it's 
first added.

> 
> Please note that any new semantics and APIs will need to be documented in
> Documentation/filesystems/fscrypt.rst.
Good point.

Thanks!

Sweet Tea
