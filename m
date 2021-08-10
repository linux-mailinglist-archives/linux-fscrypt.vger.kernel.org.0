Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF0043E5480
	for <lists+linux-fscrypt@lfdr.de>; Tue, 10 Aug 2021 09:41:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236528AbhHJHl5 (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Tue, 10 Aug 2021 03:41:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236555AbhHJHly (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Tue, 10 Aug 2021 03:41:54 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB260C061799
        for <linux-fscrypt@vger.kernel.org>; Tue, 10 Aug 2021 00:41:32 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1mDMO4-0005bc-BD; Tue, 10 Aug 2021 09:41:24 +0200
Subject: Re: [PATCH v2] fscrypt: support trusted keys
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>, kernel@pengutronix.de,
        Jarkko Sakkinen <jarkko@kernel.org>,
        James Morris <jmorris@namei.org>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        James Bottomley <jejb@linux.ibm.com>,
        Mimi Zohar <zohar@linux.ibm.com>,
        Sumit Garg <sumit.garg@linaro.org>,
        David Howells <dhowells@redhat.com>,
        linux-fscrypt@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210806150928.27857-1-a.fatoum@pengutronix.de>
 <YRGdBiJQ3xqZAT4w@gmail.com>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <2bc19003-82a1-0d2d-4548-3315686d77b4@pengutronix.de>
Date:   Tue, 10 Aug 2021 09:41:20 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YRGdBiJQ3xqZAT4w@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 2001:67c:670:201:5054:ff:fe8d:eefb
X-SA-Exim-Mail-From: a.fatoum@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-fscrypt@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hello Eric,

On 09.08.21 23:24, Eric Biggers wrote:
> Hi Ahmad,
> 
> This generally looks okay, but I have some comments below.
> 
> On Fri, Aug 06, 2021 at 05:09:28PM +0200, Ahmad Fatoum wrote:
>> Kernel trusted keys don't require userspace knowledge of the raw key
>> material and instead export a sealed blob, which can be persisted to
>> unencrypted storage. Userspace can then load this blob into the kernel,
>> where it's unsealed and from there on usable for kernel crypto.
> 
> Please be explicit about where and how the keys get generated in this case.

I intentionally avoided talking about this. You see, the trusted key documentation[1]
phrases it as "all keys are created in the kernel", but you consider
"'The key material is generated
 within the kernel' [a] misleading claim'. [2]

Also, I hope patches to force kernel RNG and CAAM support (using kernel RNG as
default) will soon be accepted, which would invalidate any further claims in the
commit message without a means to correct them.

I thus restricted my commit message to the necessary bit that are needed to
understand the patch, which is: userspace knowledge of the key material is
not required. If you disagree, could you provide me the text you'd prefer?

>> This is incompatible with fscrypt, where userspace is supposed to supply
>> the raw key material. For TPMs, a work around is to do key unsealing in
>> userspace, but this may not be feasible for other trusted key backends.
> 
> As far as I can see, "Key unsealing in userspace" actually is the preferred way
> to implement TPM-bound encryption.  So it doesn't seem fair to call it a "work
> around".

In the context of *kernel trusted keys*, direct interaction with the TPM
outside the kernel to decrypt a kernel-encrypted blob is surely not the
preferred way.

For TPM-bound encryption completely in userspace? Maybe. But that's not
what this patch is about. It's about kernel trusted keys and offloading
part of its functionality to userspace to _work around_ lack of kernel-side
integration is exactly that: a _work around_.

>> +  Most users leave this 0 and specify the raw key directly.
>> +  "trusted" keys are useful to leverage kernel support for sealing
>> +  and unsealing key material. Sealed keys can be persisted to
>> +  unencrypted storage and later be used to decrypt the file system
>> +  without requiring userspace to have knowledge of the raw key
>> +  material.
>> +  "fscrypt-provisioning" key support is intended mainly to allow
>> +  re-adding keys after a filesystem is unmounted and re-mounted,
>>    without having to store the raw keys in userspace memory.
>>  
>>  - ``raw`` is a variable-length field which must contain the actual
>>    key, ``raw_size`` bytes long.  Alternatively, if ``key_id`` is
>>    nonzero, then this field is unused.
>>  
>> +.. note::
>> +
>> +   Users should take care not to reuse the fscrypt key material with
>> +   different ciphers or in multiple contexts as this may make it
>> +   easier to deduce the key.
>> +   This also applies when the key material is supplied indirectly
>> +   via a kernel trusted key. In this case, the trusted key should
>> +   perferably be used only in a single context.
> 
> Again, please be explicit about key generation.  Note that key generation is
> already discussed in a different section, "Master Keys".  There should be a
> mention of trusted keys there.  The above note about not reusing keys probably
> belongs there too.  (The section you're editing here is
> "FS_IOC_ADD_ENCRYPTION_KEY", which is primarily intended to just document the
> ioctl, so it's not necessarily the best place for this type of information.)

Yes. The content of the note is more appropriate there.

>> @@ -577,28 +578,44 @@ static int get_keyring_key(u32 key_id, u32 type,
>>  	key_ref_t ref;
>>  	struct key *key;
>>  	const struct fscrypt_provisioning_key_payload *payload;
>> -	int err;
>> +	int err = 0;
>>  
>>  	ref = lookup_user_key(key_id, 0, KEY_NEED_SEARCH);
>>  	if (IS_ERR(ref))
>>  		return PTR_ERR(ref);
>>  	key = key_ref_to_ptr(ref);
>>  
>> -	if (key->type != &key_type_fscrypt_provisioning)
>> -		goto bad_key;
>> -	payload = key->payload.data[0];
>> +	if (key->type == &key_type_fscrypt_provisioning) {
> 
> This function is getting long; it probably should be broken this up into several
> functions.  E.g.:

Will do for v3.

> static int get_keyring_key(u32 key_id, u32 type,
>                            struct fscrypt_master_key_secret *secret)
> {
>         key_ref_t ref;
>         struct key *key;
>         int err;
> 
>         ref = lookup_user_key(key_id, 0, KEY_NEED_SEARCH);
>         if (IS_ERR(ref))
>                 return PTR_ERR(ref);
>         key = key_ref_to_ptr(ref);
> 
>         if (key->type == &key_type_fscrypt_provisioning) {
>                 err = fscrypt_get_provisioning_key(key, type, secret);
>         } else if (IS_REACHABLE(CONFIG_TRUSTED_KEYS) &&
>                    key->type == &key_type_trusted) {
>                 err = fscrypt_get_trusted_key(key, secret);
>         } else {
>                 err = -EKEYREJECTED;
>         }
>         key_ref_put(ref);
>         return err;
> }
> 
>> +		/* Don't allow fscrypt v1 keys to be used as v2 keys and vice versa. */
> 
> Please avoid overly-long lines.

For v3 with helper functions, there will be one indentation level less,
so this will be less 79 again instead of 87.

> 
>> +		tkp = key->payload.data[0];
>> +		if (!tkp || tkp->key_len < FSCRYPT_MIN_KEY_SIZE ||
>> +		    tkp->key_len > FSCRYPT_MAX_KEY_SIZE) {
>> +			up_read(&key->sem);
>> +			err = -EINVAL;
>> +			goto out_put;
>> +		}
> 
> What does the !tkp case mean?  For "user" and "logon" keys it means "key
> revoked", but the "trusted" key type doesn't implement revoke.  Is this included
> just to be safe?

Oh, good point. I think I cargo-culted it off encrypted key support for
eCryptfs and dm-crypt. Encrypted keys don't support revoke either..

That might be reasonable, but perhaps the error code in that
> case (but not the invalid length cases) should be -EKEYREVOKED instead?

Yes. It was like this for v1, but I missed it when dropping the
dependency on the key_extract_material patch. Will fix for v3.

[1]: https://www.kernel.org/doc/html/v5.14-rc5/security/keys/trusted-encrypted.html
[2]: https://lore.kernel.org/linux-fscrypt/YQLzOwnPF1434kUk@gmail.com/


Cheers and thanks for the review,
Ahmad


> 
> - Eric
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
