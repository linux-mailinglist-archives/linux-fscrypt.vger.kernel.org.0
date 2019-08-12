Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 02CA68972C
	for <lists+linux-fscrypt@lfdr.de>; Mon, 12 Aug 2019 08:33:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfHLGdh (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 12 Aug 2019 02:33:37 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:35921 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725819AbfHLGdh (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 12 Aug 2019 02:33:37 -0400
Received: by mail-wm1-f66.google.com with SMTP id g67so10724961wme.1;
        Sun, 11 Aug 2019 23:33:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=uZyZcBmr9tVQIt83TCEOc/l00emIgBlhTZYad4aAofw=;
        b=VB9Vzg2C9ADIvBOZK9/oZVxZHuPoA4uuMdlM8v54Tv/uS97hoV7BuBu5+Z7yoS+ssX
         OkmTggCX9e7unzkHVMuPMNBO7uR+NNeCOc9L6vU8aXow7MtKz5lybDdSMnvxyhHHE1KA
         3fxzEUqmmns1Qxl4ZHamdt48JWZASK3HjeItTT4r9fO3nN3d4GO0S46Oly6ZwfES+gJP
         7IhlzA5mWNZO9TyIEmm7rdJSoqDQtunFccbHv7e13O4plYnBzm34gQke+G61boJx+x/C
         KgkZunb7wLsqOAN/wSh1fNA8KKoPT3ghh5C11bCDSS9a+fwJpecz83ll2JNA0dhJH68+
         RYEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uZyZcBmr9tVQIt83TCEOc/l00emIgBlhTZYad4aAofw=;
        b=g8pZO34FlhRP/Vny1m3GOYAgsL4u+p4qU1ixaH/CJvv3g9W6629warOJ7XHrRvuSdy
         Hf1eKeJYvkQO29Xb7xyjj5nMSgYX2mtIlXWpFNmpXGypK1DFwBvCXiRtGP1nS4f7SKnH
         0ujQwyHu99bFU5exDYzhXXNa2hXGjgKQSOlJadLF0vYvMx2ODAjjxqeJLwnLnZmVGoVu
         p67bfzE2/Yy3xx/0El05JC8TCjMT6J44FbgtVevW2SEEH2+T5tuUfS+5sih1MxBKszya
         ubKmyMWj4cdQpgEutjx6vLcbWNHtoPjktwbzIDOyBTRIbK4mN2psyLeB8lu+tmJ/vJpH
         x9EQ==
X-Gm-Message-State: APjAAAWrfL2yQ3Td+jjbkPZntLUoY9oL+Ycq+fwAg/xqgzNUaPPT9jv+
        As6I0i2+/ZGklHfuetfHqZQ=
X-Google-Smtp-Source: APXvYqyDs4Fx8K1sJ9CuUzgdhWOaNLbFjtMOEQR57ZK8iKqg6uKUoYsR6eSGr711E939zjTFoQ0l1w==
X-Received: by 2002:a7b:c21a:: with SMTP id x26mr15527259wmi.61.1565591614527;
        Sun, 11 Aug 2019 23:33:34 -0700 (PDT)
Received: from [172.22.36.64] (redhat-nat.vtp.fi.muni.cz. [78.128.215.6])
        by smtp.gmail.com with ESMTPSA id r15sm110324859wrj.68.2019.08.11.23.33.33
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Sun, 11 Aug 2019 23:33:33 -0700 (PDT)
Subject: Re: [PATCH v9 3/7] md: dm-crypt: switch to ESSIV crypto API template
To:     Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
References: <20190810094053.7423-1-ard.biesheuvel@linaro.org>
 <20190810094053.7423-4-ard.biesheuvel@linaro.org>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <8679d2f5-b005-cd89-957e-d79440b78086@gmail.com>
Date:   Mon, 12 Aug 2019 08:33:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190810094053.7423-4-ard.biesheuvel@linaro.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

Hi,

On 10/08/2019 11:40, Ard Biesheuvel wrote:
> Replace the explicit ESSIV handling in the dm-crypt driver with calls
> into the crypto API, which now possesses the capability to perform
> this processing within the crypto subsystem.
> 
> Signed-off-by: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> ---
>  drivers/md/Kconfig    |   1 +
>  drivers/md/dm-crypt.c | 194 ++++----------------
>  2 files changed, 33 insertions(+), 162 deletions(-)
> 
> diff --git a/drivers/md/Kconfig b/drivers/md/Kconfig
> index 3834332f4963..b727e8f15264 100644
> --- a/drivers/md/Kconfig
> +++ b/drivers/md/Kconfig
...
> @@ -2493,6 +2339,20 @@ static int crypt_ctr_cipher_new(struct dm_target *ti, char *cipher_in, char *key
>  	if (*ivmode && !strcmp(*ivmode, "lmk"))
>  		cc->tfms_count = 64;
>  
> +	if (*ivmode && !strcmp(*ivmode, "essiv")) {
> +		if (!*ivopts) {
> +			ti->error = "Digest algorithm missing for ESSIV mode";
> +			return -EINVAL;
> +		}
> +		ret = snprintf(buf, CRYPTO_MAX_ALG_NAME, "essiv(%s,%s)",
> +			       cipher_api, *ivopts);

This is wrong. It works only in length-preserving modes, not in AEAD modes.

Try for example
# cryptsetup luksFormat /dev/sdc -c aes-cbc-essiv:sha256 --integrity hmac-sha256 -q -i1

It should produce Crypto API string
  authenc(hmac(sha256),essiv(cbc(aes),sha256))
while it produces
  essiv(authenc(hmac(sha256),cbc(aes)),sha256)
(and fails).

You can run "luks2-integrity-test" from cryptsetup test suite to detect it.

Just the test does not fail, it prints N/A for ESSIV use cases - we need to deal with older kernels...
I can probable change it to fail unconditionally though.

...
> @@ -2579,9 +2439,19 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
>  	if (!cipher_api)
>  		goto bad_mem;
>  
> -	ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
> -		       "%s(%s)", chainmode, cipher);
> -	if (ret < 0) {
> +	if (*ivmode && !strcmp(*ivmode, "essiv")) {
> +		if (!*ivopts) {
> +			ti->error = "Digest algorithm missing for ESSIV mode";
> +			kfree(cipher_api);
> +			return -EINVAL;
> +		}
> +		ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
> +			       "essiv(%s(%s),%s)", chainmode, cipher, *ivopts);

I guess here it is ok, because old forma cannot use AEAD.

Thanks,
Milan
