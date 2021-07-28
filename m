Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476743D98D5
	for <lists+linux-fscrypt@lfdr.de>; Thu, 29 Jul 2021 00:28:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232169AbhG1W2e (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Wed, 28 Jul 2021 18:28:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232559AbhG1W2b (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Wed, 28 Jul 2021 18:28:31 -0400
Received: from metis.ext.pengutronix.de (metis.ext.pengutronix.de [IPv6:2001:67c:670:201:290:27ff:fe1d:cc33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 664DDC08E9AF
        for <linux-fscrypt@vger.kernel.org>; Wed, 28 Jul 2021 15:27:32 -0700 (PDT)
Received: from gallifrey.ext.pengutronix.de ([2001:67c:670:201:5054:ff:fe8d:eefb] helo=[127.0.0.1])
        by metis.ext.pengutronix.de with esmtp (Exim 4.92)
        (envelope-from <a.fatoum@pengutronix.de>)
        id 1m8s1P-0004d1-BN; Thu, 29 Jul 2021 00:27:27 +0200
Subject: Re: [RFC PATCH v1] fscrypt: support encrypted and trusted keys
To:     Jarkko Sakkinen <jarkko@kernel.org>
Cc:     "Theodore Y. Ts'o" <tytso@mit.edu>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>,
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
References: <20210727144349.11215-1-a.fatoum@pengutronix.de>
 <20210728222243.4wqs64pqngzzii3b@kernel.org>
From:   Ahmad Fatoum <a.fatoum@pengutronix.de>
Message-ID: <3d0a380b-ea75-6c99-0515-0988d6ecab1c@pengutronix.de>
Date:   Thu, 29 Jul 2021 00:27:23 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
MIME-Version: 1.0
In-Reply-To: <20210728222243.4wqs64pqngzzii3b@kernel.org>
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

Hello Jarkko,

On 29.07.21 00:22, Jarkko Sakkinen wrote:
> On Tue, Jul 27, 2021 at 04:43:49PM +0200, Ahmad Fatoum wrote:
>> For both v1 and v2 key setup mechanisms, userspace supplies the raw key
>> material to the kernel after which it is never again disclosed to
>> userspace.
>>
>> Use of encrypted and trusted keys offers stronger guarantees:
>> The key material is generated within the kernel and is never disclosed to
>> userspace in clear text and, in the case of trusted keys, can be
>> directly rooted to a trust source like a TPM chip.
>>
>> Add support for trusted and encrypted keys by repurposing
>> fscrypt_add_key_arg::raw to hold the key description when the new
>> FSCRYPT_KEY_ARG_TYPE_DESC flag is supplied. The location of the flag
>> was previously reserved and enforced by ioctl code to be zero, so this
>> change won't break backwards compatibility.
>>
>> Corresponding userspace patches are available for fscryptctl:
>> https://github.com/google/fscryptctl/pull/23
>>
>> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>
>> ---
>> key_extract_material used by this patch is added in
>> <cover.b2fdd70b830d12853b12a12e32ceb0c8162c1346.1626945419.git-series.a.fatoum@pengutronix.de>
>> which still awaits feedback.
>>
>> Sending this RFC out anyway to get some feedback from the fscrypt
>> developers whether this is the correct way to go about it.
>>
>> To: "Theodore Y. Ts'o" <tytso@mit.edu>
>> To: Jaegeuk Kim <jaegeuk@kernel.org>
>> To: Eric Biggers <ebiggers@kernel.org>
>> Cc: Jarkko Sakkinen <jarkko@kernel.org>
>> Cc: James Morris <jmorris@namei.org>
>> Cc: "Serge E. Hallyn" <serge@hallyn.com>
>> Cc: James Bottomley <jejb@linux.ibm.com>
>> Cc: Mimi Zohar <zohar@linux.ibm.com>
>> Cc: Sumit Garg <sumit.garg@linaro.org>
>> Cc: David Howells <dhowells@redhat.com>
>> Cc: linux-fscrypt@vger.kernel.org
>> Cc: linux-crypto@vger.kernel.org
>> Cc: linux-integrity@vger.kernel.org
>> Cc: linux-security-module@vger.kernel.org
>> Cc: keyrings@vger.kernel.org
>> Cc: linux-kernel@vger.kernel.org
>> ---
>>  Documentation/filesystems/fscrypt.rst | 24 ++++++++---
>>  fs/crypto/keyring.c                   | 59 ++++++++++++++++++++++++---
>>  include/uapi/linux/fscrypt.h          | 16 +++++++-
>>  3 files changed, 87 insertions(+), 12 deletions(-)
>>
>> diff --git a/Documentation/filesystems/fscrypt.rst b/Documentation/filesystems/fscrypt.rst
>> index 44b67ebd6e40..83738af2afa3 100644
>> --- a/Documentation/filesystems/fscrypt.rst
>> +++ b/Documentation/filesystems/fscrypt.rst
>> @@ -681,11 +681,15 @@ It can be executed on any file or directory on the target filesystem,
>>  but using the filesystem's root directory is recommended.  It takes in
>>  a pointer to struct fscrypt_add_key_arg, defined as follows::
>>  
>> +    #define FSCRYPT_KEY_ADD_RAW_ASIS		0
>> +    #define FSCRYPT_KEY_ADD_RAW_DESC		1
> 
> Would be nice to have these documented.

They have explanatory comments in the uAPI header. The Documentation file
purposefully omits these comments and describes each field separately after
the code block. I am just following suit.

FWIW, I intend to drop these flags for v2 anyway.

Cheers,
Ahmad

> 
> /Jarkko
> 


-- 
Pengutronix e.K.                           |                             |
Steuerwalder Str. 21                       | http://www.pengutronix.de/  |
31137 Hildesheim, Germany                  | Phone: +49-5121-206917-0    |
Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
