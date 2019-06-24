Return-Path: <linux-fscrypt-owner@vger.kernel.org>
X-Original-To: lists+linux-fscrypt@lfdr.de
Delivered-To: lists+linux-fscrypt@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3187502B5
	for <lists+linux-fscrypt@lfdr.de>; Mon, 24 Jun 2019 09:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726343AbfFXHFe (ORCPT <rfc822;lists+linux-fscrypt@lfdr.de>);
        Mon, 24 Jun 2019 03:05:34 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:35166 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726340AbfFXHFd (ORCPT
        <rfc822;linux-fscrypt@vger.kernel.org>);
        Mon, 24 Jun 2019 03:05:33 -0400
Received: by mail-wr1-f68.google.com with SMTP id f15so2720664wrp.2;
        Mon, 24 Jun 2019 00:05:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=/dsVZYxomLMoyXfQ9mUiAOft0OKIueHGnSJjcph32Cw=;
        b=GEIfAnvWKV2cM8oGcFp3ij+jFe48MAsv65mEMsXEuF0n6HNp090g3BbJ/pmx094Bl1
         hP02uJOzrd9bb5kYCp0rQDC+wu322cBBMfnFbBs/ggiXcm2xS4StK4pvVqbEhOmNNLwe
         ZQ81Cw1GBBkA5FU8XLioNSYwnj6Q5QnOfhRoVZQ+qmfx3nDAjVBSxMLiyn2qBv5r3cPR
         T50UFs+dAEHvc3fnRMOUnl2rRm0T8BKbTgKvWA69qATU9VpgAC5jksGE2/ZNF/fHWpuk
         XvL+Rvwv4EdS5cZeszfMm6XDuAIVb5IJEzkuDuGzFTQ/mx1WWWiL9WEx8ybZHBOYuoU1
         zW0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:message-id
         :date:user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/dsVZYxomLMoyXfQ9mUiAOft0OKIueHGnSJjcph32Cw=;
        b=TWczTl6jKiLIreWppA3QdvufH/T04tMlh9nBQdsDngvLqZlD44ZD23P+JNv/8K9a5J
         xK5KCZaV9nZqIV4lqIoDAokxOseDWZPX0cAopasCuKVH8G5dNAGS8W9WUpeJ79BE8IS4
         YiwiVAW4eiKBGq3dSvyzDkSUteX4ksMNcjX5KnqtLHrKSFPlQx1QxIoXZlpwWfSQJRqr
         CCjEBHp0vPkF/i/2yKahwgsHFGk5ZpdpCyAmtuwYw+2N4w7dT8Jvo78KX0Nwc0C1g41r
         DYt2r8SlRsYaiVUKy+BOigStwPDS+VqbI/htdlPOSUZgCLWgJfmeih2CT4Fb1RuerUP/
         BLEA==
X-Gm-Message-State: APjAAAXF+6SuMuriNyB9iKIugc5nUcno1A3ftQo2p4BbjSphbzR4+ezn
        nrD7ZjxTwsToYPTEYT+b9ok=
X-Google-Smtp-Source: APXvYqyUI9sxarZRT7ca/pkV9SQLxHe4kaJgAVev+gcG6bN3l+xz6UD8eLF1tXxeq+KeVVwHdVs/HA==
X-Received: by 2002:a5d:528b:: with SMTP id c11mr44329691wrv.25.1561359931675;
        Mon, 24 Jun 2019 00:05:31 -0700 (PDT)
Received: from [172.22.36.64] (redhat-nat.vtp.fi.muni.cz. [78.128.215.6])
        by smtp.gmail.com with ESMTPSA id t15sm8225210wrx.84.2019.06.24.00.05.30
        (version=TLS1_3 cipher=AEAD-AES128-GCM-SHA256 bits=128/128);
        Mon, 24 Jun 2019 00:05:31 -0700 (PDT)
Subject: Re: [PATCH v4 4/6] md: dm-crypt: switch to ESSIV crypto API template
To:     ard.biesheuvel@linaro.org, linux-crypto@vger.kernel.org
Cc:     Herbert Xu <herbert@gondor.apana.org.au>,
        Eric Biggers <ebiggers@google.com>, dm-devel@redhat.com,
        linux-fscrypt@vger.kernel.org,
        Gilad Ben-Yossef <gilad@benyossef.com>
References: <20190621080918.22809-1-ard.biesheuvel@arm.com>
 <20190621080918.22809-5-ard.biesheuvel@arm.com>
From:   Milan Broz <gmazyland@gmail.com>
Openpgp: preference=signencrypt
Message-ID: <af75aefc-438b-9e31-b922-c847879d9dd9@gmail.com>
Date:   Mon, 24 Jun 2019 09:05:30 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <20190621080918.22809-5-ard.biesheuvel@arm.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-fscrypt-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-fscrypt.vger.kernel.org>
X-Mailing-List: linux-fscrypt@vger.kernel.org

On 21/06/2019 10:09, Ard Biesheuvel wrote:
> From: Ard Biesheuvel <ard.biesheuvel@linaro.org>
> 
> Replace the explicit ESSIV handling in the dm-crypt driver with calls
> into the crypto API, which now possesses the capability to perform
> this processing within the crypto subsystem.

I tried a few crazy dm-crypt configurations and was not able to crash it this time :-)

So, it definitely need some more testing, but for now, I think it works.

Few comments below for this part:

> --- a/drivers/md/dm-crypt.c
> +++ b/drivers/md/dm-crypt.c

>  static const struct crypt_iv_operations crypt_iv_benbi_ops = {
>  	.ctr	   = crypt_iv_benbi_ctr,
>  	.dtr	   = crypt_iv_benbi_dtr,
> @@ -2283,7 +2112,7 @@ static int crypt_ctr_ivmode(struct dm_target *ti, const char *ivmode)
>  	else if (strcmp(ivmode, "plain64be") == 0)
>  		cc->iv_gen_ops = &crypt_iv_plain64be_ops;
>  	else if (strcmp(ivmode, "essiv") == 0)
> -		cc->iv_gen_ops = &crypt_iv_essiv_ops;
> +		cc->iv_gen_ops = &crypt_iv_plain64_ops;

This is quite misleading - it looks like you are switching to plain64 here.
The reality is that it uses plain64 to feed the ESSIV wrapper.

So either it need some comment to explain it here, or just keep simple essiv_iv_ops
and duplicate that plain64 generator (it is 2 lines of code).

For the clarity, I would prefer the second variant (duplicate ops) here.

> @@ -2515,8 +2357,18 @@ static int crypt_ctr_cipher_old(struct dm_target *ti, char *cipher_in, char *key
>  	if (!cipher_api)
>  		goto bad_mem;
>  
> -	ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
> -		       "%s(%s)", chainmode, cipher);
> +	if (*ivmode && !strcmp(*ivmode, "essiv")) {
> +		if (!*ivopts) {
> +			ti->error = "Digest algorithm missing for ESSIV mode";
> +			return -EINVAL;
> +		}
> +		ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
> +			       "essiv(%s(%s),%s,%s)", chainmode, cipher,
> +			       cipher, *ivopts);

This becomes quite long string already (limit is now 128 bytes), we should probably
check also for too long string. It will perhaps fail later, but I would better add

	if (ret < 0 || ret >= CRYPTO_MAX_ALG_NAME) {
	...

> +	} else {
> +		ret = snprintf(cipher_api, CRYPTO_MAX_ALG_NAME,
> +			       "%s(%s)", chainmode, cipher);
> +	}
>  	if (ret < 0) {
>  		kfree(cipher_api);
>  		goto bad_mem;
> 

Thanks,
Milan
