Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C1B43D8A07
	for <lists+linux-fscrypt@lfdr.de>; Wed, 28 Jul 2021 10:51:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235315AbhG1IvD (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jul 2021 04:51:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45220 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234655AbhG1Iu6 (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jul 2021 04:50:58 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9E36C0613D5
        for <linux-fscrypt@vger.kernel.org>; Wed, 28 Jul 2021 01:50:56 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[IPv6:::1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1m8fH5-00087o-36; Wed, 28 Jul 2021 10:50:47 +0200
Subject: Re: [RFC PATCH v1] fscrypt: support encrypted and trusted keys
To:     Eric Biggers <ebiggers@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
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
        linux-kernel@vger.kernel.org, git@andred.net,
        Omar Sandoval <osandov@osandov.com>,
        Pengutronix Kernel Team <kernel@pengutronix.de>
References: <20210727144349.11215-1-a.fatoum@pengutronix.de>
 <YQA2fHPwH6EsH9BR@sol.localdomain>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <367ea5bb-76cf-6020-cb99-91b5ca82d679@pengutronix.de>
Date:   Wed, 28 Jul 2021 10:50:42 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <YQA2fHPwH6EsH9BR@sol.localdomain>
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

On 27.07.21 18:38, Eric Biggers wrote:
> On Tue, Jul 27, 2021 at 04:43:49PM +0200, Ahmad Fatoum wrote:
>> For both v1 and v2 key setup mechanisms, userspace supplies the raw key
>> material to the kernel after which it is never again disclosed to
>> userspace.
>>
>> Use of encrypted and trusted keys offers stronger guarantees:
>> The key material is generated within the kernel and is never disclosed to
>> userspace in clear text and, in the case of trusted keys, can be
>> directly rooted to a trust source like a TPM chip.
> 
> Please include a proper justification for this feature

I've patches pending for extending trusted keys to wrap the key sealing
functionality of the CAAM IP on NXP SoCs[1]. I want the kernel to
generate key material in the factory, have the CAAM encrypt it using its
undisclosed unique key and pass it to userspace as encrypted blob that is
persisted to an unencrypted volume. The intention is to thwart offline
decryption of an encrypted file system in an embedded system, where a
passphrase can't be supplied by an end user.

Employing TPM and TEE trusted keys with this is already possible with
dm-crypt, but I'd like this to be possible out-of-the-box with
ubifs + fscrypt as well.

> and update the relevant
> sections of Documentation/filesystems/fscrypt.rst to explain why someone would
> want to use this feature and what it accomplishes.

How about:

-  type "fscrypt-provisioning" whose payload is
+  type "fscrypt-provisioning" or "trusted":
+  "fscrypt-provisioning" keys have a payload of
   struct fscrypt_provisioning_key_payload whose ``raw`` field contains
   the raw key and whose ``type`` field matches ``key_spec.type``.
   Since ``raw`` is variable-length, the total size of this key's
   payload must be ``sizeof(struct fscrypt_provisioning_key_payload)``
-  plus the raw key size.  The process must have Search permission on
-  this key.
+  plus the raw key size.
+  For "trusted" keys, the payload is directly taken as the raw key.

+  The process must have Search permission on this key.

-  Most users should leave this 0 and specify the raw key directly.

+  Most users leave this 0 and specify the raw key directly.
-  The support for specifying a Linux keyring key is intended mainly to

-  allow re-adding keys after a filesystem is unmounted and re-mounted,
+  "trusted" keys are useful to leverage kernel support for sealing and
+  unsealing key material. Sealed keys can be persisted to unencrypted
+  storage and later used to decrypt the file system without requiring
+  userspace to know the raw key material.
+  "fscrypt-provisioning" key support is intended mainly to allow
+  re-adding keys after a filesystem is unmounted and re-mounted,

> As-is, this feature doesn't seem to have a very strong justification.  Please
> also see previous threads where this feature was discussed/requested:
> https://lkml.kernel.org/linux-fscrypt/20180110124418.24385-1-git@andred.net/T/#u,
> https://lkml.kernel.org/linux-fscrypt/20180118131359.8365-1-git@andred.net/T/#u,
> https://lkml.kernel.org/linux-fscrypt/20200116193228.GA266386@vader/T/#u

Thanks. I wasn't aware of the last one. I (re-)read them now. I hope
this mail manages to address the concerns.

(Also added original authors of these mail threads to CC)

> Note that there are several design flaws with the encrypted and trusted key
> types:
> 
> - By default, trusted keys are generated using the TPM's RNG rather than the
>   kernel's RNG, which places all trust in an unauditable black box.

Patch to fix that awaits feedback on linux-integrity[2].

> - trusted and encrypted keys aren't restricted to specific uses in the kernel
>   (like the fscrypt-provisioning key type is) but rather are general-purpose.
>   Hence, it may be possible to leak their contents to userspace by requesting
>   their use for certain algorithms/features, e.g. to encrypt a dm-crypt target
>   using a weak cipher that is vulnerable to key recovery attacks.

The footgun is already there by allowing users to specify their own

raw key. Users can already use $keyid for dm-crypt and then do

  $ keyctl pipe $keyid | fscryptctl add_key /mnt

The responsibility to not reuse key material already lies with the users,
regardless if they handle the raw key material directly or indirectly via
a trusted key description/ID.

> - "encrypted" keys that use a master key of type "user" are supported, despite
>   these being easily obtainable in the clear by userspace providing their own
>   master key.  This violates one of the main design goals of "encrypted" keys.

I care for trusted keys foremost, so I've no problems dropping the encrypted
key support.

> Also, using the "trusted" key type isn't necessary to achieve TPM-bound
> encryption, as TPM binding can be handled in userspace instead.

Trusted keys support TEE and hopefully CAAM soon as well. I don't want my
userspace directly poking a DMA master.
> So I really would like to see a proper justification for this feature, and have
> it be properly documented.

In light of the extended justification above, do you want me to respin with
the proposed changes?

> One comment on the UAPI below.

> Why not just allow the key_id field to specify a "trusted" or "encrypted" key?
> Why is it necessary for FS_IOC_ADD_ENCRYPTION_KEY to support two different ways
> of looking up keyring keys -- by ID and by description?  Looking up by ID works
> fine for "fscrypt-provisioning" keys; why are "trusted" and "encrypted" keys
> different in this regard?

Mixture of reading emails predating key_id and misunderstanding the API.
key_id would be much cleaner indeed. I can change this for v2.

Thanks for your review.

[1]: https://lore.kernel.org/linux-integrity/655aab117f922320e2123815afb5bf3daeb7b8b3.1626885907.git-series.a.fatoum@pengutronix.de/
[2]: https://lore.kernel.org/linux-integrity/cover.9fc9298fd9d63553491871d043a18affc2dbc8a8.1626885907.git-series.a.fatoum@pengutronix.de/T/#meaefcdc9ac091944ddadaebe0410c2325af0032e

Cheers,
Ahmad

> 
> - Eric
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
