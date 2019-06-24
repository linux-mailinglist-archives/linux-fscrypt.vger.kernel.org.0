Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55CA7503C8
	for <lists+linux-fscrypt@lfdr.de>; Mon, 24 Jun 2019 09:40:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726795AbfFXHkm (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 24 Jun 2019 03:40:42 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45695 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726334AbfFXHkm (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 24 Jun 2019 03:40:42 -0400
Received: by mail-io1-f67.google.com with SMTP id e3so287816ioc.12;
        Mon, 24 Jun 2019 00:40:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc;
        bh=8dWeSIsidu/P7YsuUWucyysKYbzHuX6DsanqLCDVdyY=;
        b=cawtwA/hvq1bKSlAN/Yro4UJfOs1Do+w1Tz8Q7Ydrv6hktmpz7VixOW3j3Q3E9keTl
         PKzu4RemPIw4/Vwk8ahNyd6NleKRrU9S+Nf8icfFDTbnFXAwyPr4yRpCnc5V5v4SyR2C
         VdBApvsmq0eCN09kBZCfaOx0kKBRFYA7qQ/wqvqSPZ/MMrzFBK5JfkXETUouXdL6RQ8c
         w5yrm0YS84SUA0ZoE9sDyuF5+LkpyD/ChkdO0S7ega4LrB+bmLbjUxQ/9nFoAUN9o66x
         NIKkyFrEBi9TnzeOYxqOoOx8Vf8A1mTdUPkHZO2AZ8FscnXpZBpkTpDsnbUaWyeibIL0
         1IQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:in-reply-to:references:from:date
         :message-id:subject:to:cc;
        bh=8dWeSIsidu/P7YsuUWucyysKYbzHuX6DsanqLCDVdyY=;
        b=LJVteEFjawDe/Z4/6rvL8Rd2VTJw6humcJtWV6ieRko6IvpGbifzRdrvdynK9qecsW
         sG9yartPanzTRX5Lc1ZAkAOVvEZDe22bDc7Uuy8zq3qTMzjNM7xp4nAwce0Od7zz4jA8
         NPpaSGgOXgeKBbhOO/MuIIA6Kt8u1VdaIeos5zs0I69TJi199bd/sKA8w+csuvq6UKbS
         ZfnKwRWFXVNYEgnbS/P/j2YNREk8vvQx3klbJx+fcXeOfTKIhMyphNXWrcmJB0JZYwK0
         l0M8adjY1nxC761kQ1xlk9kD0ryKW3uTjw0teMdFjtCMvQciMXxkqeYWWGuAjxMaM9Gd
         nngQ==
X-Gm-Message-State: APjAAAWVkOZHEfbOzrLaKjfi8khIM1LetM/gYO5nC0jbjCuU5eEE0UhH
        hdHIyQgsRfXsxrhX5WHV2VKhtsSK5XkuzanH3Ig=
X-Google-Smtp-Source: APXvYqxAkDNHhm8nw4Daqg7MaBDWvII5tBWjXXxj+x9xAMGNRq8t5fajlOjTlm53fZwOtP4vdRUYaCwMWuXihPzxOQE=
X-Received: by 2002:a6b:6611:: with SMTP id a17mr32114562ioc.179.1561362041175;
 Mon, 24 Jun 2019 00:40:41 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a4f:9896:0:0:0:0:0 with HTTP; Mon, 24 Jun 2019 00:40:40
 -0700 (PDT)
In-Reply-To: <af75aefc-438b-9e31-b922-c847879d9dd9@gmail.com>
References: <20190621080918.22809-1-ard.biesheuvel@arm.com>
 <20190621080918.22809-5-ard.biesheuvel@arm.com> <af75aefc-438b-9e31-b922-c847879d9dd9@gmail.com>
From:   Surachai Saiwong <buriram1601@gmail.com>
Date:   Mon, 24 Jun 2019 14:40:40 +0700
Message-ID: <CAL1AwE-77TnQubVJDDhtCb0CW9QkMD+h+oZ72CKCrSc7gtkJfw@mail.gmail.com>
Subject: Re: [dm-devel] [PATCH v4 4/6] md: dm-crypt: switch to ESSIV crypto
 API template
To:     Milan Broz <gmazyland@gmail.com>
Cc:     ard.biesheuvel@linaro.org, linux-crypto@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

2562-06-24 14:05 GMT+07:00, Milan Broz <gmazyland@gmail.com>:
> On 21/06/2019 10:09, Ard Biesheuvel wrote:
>> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
>>
>> Replace the explicit ESSIV handling in the dm-crypt driver with calls
>> into the crypto API, which now possesses the capability to perform
>> this processing within the crypto subsystem.
>
> I tried a few crazy dm-crypt configurations and was not able to crash it
> this time :-)
>
> So, it definitely need some more testing, but for now, I think it works.
>
> Few comments below for this part:
>
>> --- a/drivers/md/dm-crypt.c
>> +++ b/drivers/md/dm-crypt.c
>
>>  static const struct crypt_iv_operations crypt_iv_benbi_ops = {
>>  	.ctr	   = crypt_iv_benbi_ctr,
>>  	.dtr	   = crypt_iv_benbi_dtr,
>> @@ -2283,7 +2112,7 @@ static int crypt_ctr_ivmode(struct dm_target *ti,
>> const char *ivmode)
>>  	else if (strcmp(ivmode, "plain64be") == 0)
>>  		cc->iv_gen_ops = &crypt_iv_plain64be_ops;
>>  	else if (strcmp(ivmode, "essiv") == 0)
>> -		cc->iv_gen_ops = &crypt_iv_essiv_ops;
>> +		cc->iv_gen_ops = &crypt_iv_plain64_ops;
>
> This is quite misleading - it looks like you are switching to plain64 here.
> The reality is that it uses plain64 to feed the ESSIV wrapper.
>
> So either it need some comment to explain it here, or just keep simple
> essiv_iv_ops
> and duplicate that plain64 generator (it is 2 lines of code).
>
> For the clarity, I would prefer the second variant (duplicate ops) here.
>
>> @@ -2515,8 +2357,18 @@ static int crypt_ctr_cipher_old(struct dm_target
>> *ti, char *cipher_in, char *key
>>  	if (!cipher_api)
>>  		goto bad_mem;
>>
>> -	ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
>> -		       "%s(%s)", chainmode, cipher);
>> +	if (*ivmode && !strcmp(*ivmode, "essiv")) {
>> +		if (!*ivopts) {
>> +			ti->error = "Digest algorithm missing for ESSIV mode";
>> +			return -EINVAL;
>> +		}
>> +		ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
>> +			       "essiv(%s(%s),%s,%s)", chainmode, cipher,
>> +			       cipher, *ivopts);
>
> This becomes quite long string already (limit is now 128 bytes), we should
> probably
> check also for too long string. It will perhaps fail later, but I would
> better add
>
> 	if (ret < 0 || ret >= CRYPTO_MAX_ALG_NAME) {
> 	...
>
>> +	} else {
>> +		ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
>> +			       "%s(%s)", chainmode, cipher);
>> +	}
>>  	if (ret < 0) {
>>  		kfree(cipher_api);
>>  		goto bad_mem;
>>
>
> Thanks,
> Milan
>
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
>
